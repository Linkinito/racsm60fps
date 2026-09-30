// Minimal fake PPSSPP debugger WebSocket server used by the observer tests.
//
// It speaks the same JSON-over-WebSocket protocol as PPSSPP's debugger page
// (subprotocol "debugger.ppsspp.org") so the observer can be exercised without
// touching the real emulator. It also records any non-read-only request it
// receives, so the tests can prove the observer never tries to write.
import crypto from 'node:crypto';
import http from 'node:http';

const HANDSHAKE_GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';

export const FORBIDDEN_EVENT_PATTERNS = [
  /^memory\.write/i,
  /^memory\.breakpoint/i,
  /^cpu\.set/i,
  /^input\./i,
  /^savestate/i,
  /^config\./i,
  /^gpu\./i,
];

export const KNOWN_STATES = Object.freeze({
  A0: {wait: 'vanilla', sharedDelta: 0x3c043d08, loopThreshold: 0x2a240002, localScalar: 0x46006506, dt: 1 / 30},
  B0: {wait: 'nop', sharedDelta: 0x3c043d08, loopThreshold: 0x2a240002, localScalar: 0x46006506, dt: 1 / 30},
  B1: {wait: 'nop', sharedDelta: 0x3c043c88, loopThreshold: 0x2a240002, localScalar: 0x46006506, dt: 1 / 60},
  C1: {wait: 'nop', sharedDelta: 0x3c043c88, loopThreshold: 0x2a240001, localScalar: 0x46006506, dt: 1 / 60},
  // Hybrid: WAIT removed with a 1/30 shared delta but a threshold of 1.
  HYBRID: {wait: 'nop', sharedDelta: 0x3c043d08, loopThreshold: 0x2a240001, localScalar: 0x46006506, dt: 1 / 30},
  // Unexpected local scalar word (neither vanilla nor a known variant).
  ODD_SCALAR: {wait: 'nop', sharedDelta: 0x3c043c88, loopThreshold: 0x2a240001, localScalar: 0x46006507, dt: 1 / 60},
});

const GUARD_RVAS = {wait: 0x96650, sharedDelta: 0x151e0, loopThreshold: 0x2fcfc, localScalar: 0x2fbbc};
const WAIT_TARGET_RVA = 0x1bf424;

function jalWord(pc, target) {
  return (((pc + 4) & 0xf0000000) | (3 << 26) | ((target >>> 2) & 0x03ffffff)) >>> 0;
}

function encodeFrame(payload, opcode = 0x1) {
  const data = Buffer.isBuffer(payload) ? payload : Buffer.from(payload, 'utf8');
  let header;
  if (data.length < 126) {
    header = Buffer.alloc(2);
    header[1] = data.length;
  } else if (data.length < 0x10000) {
    header = Buffer.alloc(4);
    header[1] = 126;
    header.writeUInt16BE(data.length, 2);
  } else {
    header = Buffer.alloc(10);
    header[1] = 127;
    header.writeBigUInt64BE(BigInt(data.length), 2);
  }
  header[0] = 0x80 | opcode;
  return Buffer.concat([header, data]);
}

function decodeFrames(state) {
  const frames = [];
  for (;;) {
    const buffer = state.buffer;
    if (buffer.length < 2) break;
    const fin = (buffer[0] & 0x80) !== 0;
    const opcode = buffer[0] & 0x0f;
    const masked = (buffer[1] & 0x80) !== 0;
    let length = buffer[1] & 0x7f;
    let offset = 2;
    if (length === 126) {
      if (buffer.length < 4) break;
      length = buffer.readUInt16BE(2);
      offset = 4;
    } else if (length === 127) {
      if (buffer.length < 10) break;
      length = Number(buffer.readBigUInt64BE(2));
      offset = 10;
    }
    let maskKey = null;
    if (masked) {
      if (buffer.length < offset + 4) break;
      maskKey = buffer.subarray(offset, offset + 4);
      offset += 4;
    }
    if (buffer.length < offset + length) break;
    const payload = Buffer.from(buffer.subarray(offset, offset + length));
    if (maskKey) {
      for (let i = 0; i < payload.length; i += 1) payload[i] ^= maskKey[i % 4];
    }
    state.buffer = buffer.subarray(offset + length);
    frames.push({fin, opcode, payload});
  }
  return frames;
}

export class FakePpssppDebugger {
  constructor(options = {}) {
    this.moduleName = options.moduleName ?? 'rcp1';
    this.moduleBase = options.moduleBase ?? 0x09139d00;
    this.moduleSize = options.moduleSize ?? 0x46b900;
    this.gameId = options.gameId ?? 'UCES00420';
    this.gameVersion = options.gameVersion ?? '1.00';
    this.gameTitle = options.gameTitle ?? 'Ratchet and Clank: Size Matters';
    this.ppssppName = options.ppssppName ?? 'PPSSPP';
    this.ppssppVersion = options.ppssppVersion ?? 'v1.20.4';
    this.entityAddress = options.entityAddress ?? 0x09471640;
    this.objectAddress = options.objectAddress ?? 0x09450000;
    this.pvarAddress = options.pvarAddress ?? 0x09451000;
    this.autoHitDelayMs = options.autoHitDelayMs ?? null;
    this.entityBlockSize = 0x600;
    this.extraModules = options.extraModules ?? [];
    this.stateName = options.state ?? 'A0';
    this.ticks = options.ticks ?? 323077292309;
    this.ticksAtStart = this.ticks;
    // When true, the fake tick counter never advances (simulates a frozen
    // emulated clock) so the observer's freeze warning can be tested.
    this.frozenTicks = options.frozenTicks === true;
    this.dropBreakpointAddAck = options.dropBreakpointAddAck === true;
    this.rejectBreakpointRemove = options.rejectBreakpointRemove === true;
    this.violations = [];
    this.controlRequests = [];
    this.requests = [];
    this.breakpoints = new Map();
    this.cpuStepping = false;
    this.currentPc = this.moduleBase + 0x1000;
    this.startMs = Date.now();
    this.#server = http.createServer((request, response) => {
      response.writeHead(404);
      response.end('fake PPSSPP debugger: WebSocket only');
    });
    this.#server.on('upgrade', (request, socket) => this.#onUpgrade(request, socket));
  }

  #server;
  #sockets = new Set();
  #closed = false;

  get port() {
    const address = this.#server.address();
    return typeof address === 'object' && address !== null ? address.port : null;
  }

  async start(port = 0) {
    await new Promise((resolve, reject) => {
      this.#server.once('error', reject);
      this.#server.listen(port, '127.0.0.1', resolve);
    });
    return this.port;
  }

  async stop() {
    this.#closed = true;
    for (const socket of this.#sockets) socket.destroy();
    this.#sockets.clear();
    await new Promise((resolve) => this.#server.close(resolve));
  }

  setState(name) {
    if (!KNOWN_STATES[name]) throw new Error(`Unknown fake state: ${name}`);
    this.stateName = name;
  }

  get dtValue() {
    return KNOWN_STATES[this.stateName].dt;
  }

  setModuleBase(base) {
    this.moduleBase = base;
  }

  setGameId(id) {
    this.gameId = id;
  }

  setRawGuardWord(key, word) {
    this.rawGuardOverrides = {...(this.rawGuardOverrides ?? {}), [key]: word >>> 0};
  }

  clearRawGuardOverrides() {
    this.rawGuardOverrides = {};
  }

  triggerBreakpoint(address = null) {
    const target = address ?? [...this.breakpoints.keys()][0];
    if (!Number.isInteger(target) || !this.breakpoints.has(target)) {
      throw new Error(`No active fake breakpoint at ${target}`);
    }
    this.cpuStepping = true;
    this.currentPc = target;
    if (!this.frozenTicks) this.ticks = this.ticksAtStart + Math.round((Date.now() - this.startMs) * 222222.222);
    for (const socket of this.#sockets) {
      this.#send(socket, {event: 'cpu.stepping', pc: target, ticks: this.ticks});
    }
  }

  guardWord(key) {
    const override = this.rawGuardOverrides?.[key];
    if (override !== undefined) return override;
    const preset = KNOWN_STATES[this.stateName];
    switch (key) {
      case 'wait':
        return preset.wait === 'nop' ? 0x00000000 : jalWord(this.moduleBase + GUARD_RVAS.wait, this.moduleBase + WAIT_TARGET_RVA);
      case 'sharedDelta':
        return preset.sharedDelta;
      case 'loopThreshold':
        return preset.loopThreshold;
      case 'localScalar':
        return preset.localScalar;
      default:
        throw new Error(`Unknown guard key: ${key}`);
    }
  }

  guardWords() {
    return {
      wait: this.guardWord('wait'),
      sharedDelta: this.guardWord('sharedDelta'),
      loopThreshold: this.guardWord('loopThreshold'),
      localScalar: this.guardWord('localScalar'),
    };
  }

  #entityBlock() {
    const buffer = Buffer.alloc(this.entityBlockSize);
    const elapsed = (Date.now() - this.startMs) / 1000;
    const dt = this.dtValue;
    buffer.writeFloatLE(dt, 0x56c);
    buffer.writeFloatLE((elapsed * 1.7) % 1, 0x570);
    buffer.writeFloatLE(elapsed * 0.5, 0x574);
    buffer.writeFloatLE(dt * 30, 0x578);
    return buffer;
  }

  #objectBlock() {
    const buffer = Buffer.alloc(0x100);
    const elapsed = (Date.now() - this.startMs) / 1000;
    buffer.writeFloatLE(elapsed * 3, 0x30);
    buffer.writeFloatLE(elapsed * 2, 0x34);
    buffer.writeFloatLE(elapsed, 0x38);
    buffer.writeUInt32LE(this.pvarAddress >>> 0, 0x58);
    buffer.writeFloatLE((elapsed * 30) % 15, 0x70);
    return buffer;
  }

  #pvarBlock() {
    const buffer = Buffer.alloc(0x100);
    const elapsed = (Date.now() - this.startMs) / 1000;
    buffer.writeFloatLE(1 / 30, 0x08);
    buffer.writeFloatLE(Math.max(0, 10 - elapsed), 0x0c);
    buffer.writeFloatLE((elapsed * 30) % 90, 0x10);
    buffer.writeFloatLE(Math.max(0, 180 - elapsed * 30), 0x14);
    buffer.writeFloatLE(2, 0x18);
    buffer.writeFloatLE(Math.max(0, 8 - elapsed), 0x34);
    buffer.writeFloatLE(Math.max(0, 23 - elapsed * 30), 0x40);
    return buffer;
  }

  #read(address, size) {
    const buffer = Buffer.alloc(size);
    const words = new Map();
    const guards = this.guardWords();
    for (const [key, rva] of Object.entries(GUARD_RVAS)) words.set(this.moduleBase + rva, guards[key]);
    for (const [wordAddress, value] of words) {
      if (wordAddress >= address && wordAddress + 4 <= address + size) {
        buffer.writeUInt32LE(value, wordAddress - address);
      }
    }
    const entity = this.#entityBlock();
    const entityStart = Math.max(address, this.entityAddress);
    const entityEnd = Math.min(address + size, this.entityAddress + entity.length);
    for (let cursor = entityStart; cursor < entityEnd; cursor += 1) {
      buffer[cursor - address] = entity[cursor - this.entityAddress];
    }
    for (const [base, source] of [
      [this.objectAddress, this.#objectBlock()],
      [this.pvarAddress, this.#pvarBlock()],
    ]) {
      const start = Math.max(address, base);
      const end = Math.min(address + size, base + source.length);
      for (let cursor = start; cursor < end; cursor += 1) buffer[cursor - address] = source[cursor - base];
    }
    return buffer;
  }

  #onUpgrade(request, socket) {
    const key = request.headers['sec-websocket-key'];
    if (!key) {
      socket.destroy();
      return;
    }
    const accept = crypto.createHash('sha1').update(`${key}${HANDSHAKE_GUID}`).digest('base64');
    socket.write(
      'HTTP/1.1 101 Switching Protocols\r\n' +
        'Upgrade: websocket\r\n' +
        'Connection: Upgrade\r\n' +
        `Sec-WebSocket-Accept: ${accept}\r\n` +
        'Sec-WebSocket-Protocol: debugger.ppsspp.org\r\n\r\n',
    );
    const state = {buffer: Buffer.alloc(0), fragment: null};
    this.#sockets.add(socket);
    socket.on('data', (chunk) => {
      state.buffer = Buffer.concat([state.buffer, chunk]);
      for (const frame of decodeFrames(state)) {
        if (frame.opcode === 0x8) {
          socket.end(encodeFrame(Buffer.alloc(0), 0x8));
          this.#sockets.delete(socket);
          return;
        }
        if (frame.opcode === 0x9) {
          socket.write(encodeFrame(frame.payload, 0xa));
          continue;
        }
        if (frame.opcode === 0xa) continue;
        if (frame.opcode === 0x0 && state.fragment) {
          state.fragment.payload = Buffer.concat([state.fragment.payload, frame.payload]);
          if (frame.fin) {
            this.#handleMessage(socket, state.fragment.payload.toString('utf8'));
            state.fragment = null;
          }
          continue;
        }
        if (frame.opcode === 0x1) {
          if (frame.fin) this.#handleMessage(socket, frame.payload.toString('utf8'));
          else state.fragment = {payload: frame.payload};
        }
      }
    });
    socket.on('close', () => this.#sockets.delete(socket));
    socket.on('error', () => this.#sockets.delete(socket));
  }

  #send(socket, payload) {
    if (this.#closed) return;
    socket.write(encodeFrame(JSON.stringify(payload)));
  }

  #handleMessage(socket, text) {
    let request;
    try {
      request = JSON.parse(text);
    } catch {
      return;
    }
    const event = String(request.event ?? '');
    const ticket = request.ticket;
    this.requests.push({event, fields: {...request, ticket: undefined, event: undefined}});
    if (FORBIDDEN_EVENT_PATTERNS.some((pattern) => pattern.test(event))) {
      this.violations.push({event, request});
      this.#send(socket, {event: 'error', ticket, message: `fake debugger: refusing non-read-only event ${event}`});
      return;
    }
    switch (event) {
      case 'version':
        this.#send(socket, {event: 'version', ticket, name: this.ppssppName, version: this.ppssppVersion});
        return;
      case 'game.status':
        this.#send(socket, {
          event: 'game.status',
          ticket,
          game: {id: this.gameId, version: this.gameVersion, title: this.gameTitle},
          paused: false,
        });
        return;
      case 'cpu.status':
        // Realistic tick source: the PSP tick counter runs at ~222.2 MHz.
        if (!this.frozenTicks) {
          this.ticks = this.ticksAtStart + Math.round((Date.now() - this.startMs) * 222222.222);
        }
        this.#send(socket, {
          event: 'cpu.status',
          ticket,
          stepping: this.cpuStepping,
          paused: false,
          pc: this.currentPc,
          ticks: this.ticks,
        });
        return;
      case 'cpu.breakpoint.list':
        this.controlRequests.push({event, address: null});
        this.#send(socket, {
          event,
          ticket,
          breakpoints: [...this.breakpoints.values()].map((item) => ({...item})),
        });
        return;
      case 'cpu.breakpoint.add': {
        if (!Number.isInteger(request.address) || request.enabled !== true || request.log !== false) {
          this.#send(socket, {event: 'error', ticket, message: 'fake debugger: invalid owned breakpoint'});
          return;
        }
        const item = {address: request.address >>> 0, enabled: true, log: false};
        this.breakpoints.set(item.address, item);
        this.controlRequests.push({event, address: item.address});
        if (!this.dropBreakpointAddAck) this.#send(socket, {event, ticket, ...item});
        if (Number.isFinite(this.autoHitDelayMs)) {
          setTimeout(() => {
            if (this.breakpoints.has(item.address)) this.triggerBreakpoint(item.address);
          }, this.autoHitDelayMs);
        }
        return;
      }
      case 'cpu.breakpoint.remove':
        this.controlRequests.push({event, address: request.address >>> 0});
        if (this.rejectBreakpointRemove) {
          this.#send(socket, {event: 'error', ticket, message: 'fake debugger: injected breakpoint removal failure'});
          return;
        }
        this.breakpoints.delete(request.address >>> 0);
        this.#send(socket, {event, ticket, address: request.address >>> 0});
        return;
      case 'cpu.getAllRegs': {
        this.controlRequests.push({event, address: null});
        const registerNames = ['zero', 'at', 'v0', 'v1', 'a0', 'a1', 'a2', 'a3', 't0', 't1', 't2', 't3', 't4', 't5', 't6', 't7', 's0', 's1', 's2', 's3', 's4', 's5', 's6', 's7', 't8', 't9', 'k0', 'k1', 'gp', 'sp', 'fp', 'ra'];
        const values = Object.fromEntries(registerNames.map((name) => [name, 0]));
        values.a0 = this.objectAddress;
        values.s0 = this.objectAddress;
        values.s1 = this.pvarAddress;
        values.s2 = this.pvarAddress;
        this.#send(socket, {
          event,
          ticket,
          categories: [{name: 'GPR', registerNames, uintValues: registerNames.map((name) => values[name] >>> 0)}],
        });
        return;
      }
      case 'cpu.resume':
        this.controlRequests.push({event, address: null});
        this.cpuStepping = false;
        this.#send(socket, {event: 'cpu.resume'});
        return;
      case 'cpu.stepping':
        this.controlRequests.push({event, address: null});
        this.cpuStepping = true;
        this.#send(socket, {event: 'cpu.stepping', pc: this.currentPc, ticks: this.ticks});
        return;
      case 'hle.module.list':
        this.#send(socket, {
          event: 'hle.module.list',
          ticket,
          modules: [
            {name: 'mcp', address: this.moduleBase - 0x9a0a00 > 0 ? this.moduleBase - 0x9a0a00 : 0x087f0000, size: 1388800, isActive: true},
            {name: this.moduleName, address: this.moduleBase, size: this.moduleSize, isActive: true},
            ...this.extraModules,
          ],
        });
        return;
      case 'memory.read_u32':
        this.#send(socket, {
          event: 'memory.read_u32',
          ticket,
          value: this.#read(request.address, 4).readUInt32LE(0),
        });
        return;
      case 'memory.read': {
        const size = request.size;
        if (!Number.isInteger(request.address) || !Number.isInteger(size) || size <= 0 || size > 0x10000) {
          this.#send(socket, {event: 'error', ticket, message: 'fake debugger: invalid memory.read range'});
          return;
        }
        this.#send(socket, {
          event: 'memory.read',
          ticket,
          base64: this.#read(request.address, size).toString('base64'),
        });
        return;
      }
      default:
        this.#send(socket, {event: 'error', ticket, message: `fake debugger: unsupported event ${event}`});
    }
  }
}
