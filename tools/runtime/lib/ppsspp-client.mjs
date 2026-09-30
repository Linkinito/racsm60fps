// Minimal PPSSPP debugger WebSocket client for memory-read observation and a
// tightly bounded temporary-breakpoint binding transaction.
//
// The transport is the same one already used by the repository's live-test
// scripts (research/live-tests/...): a JSON request/response protocol over
// ws://127.0.0.1:<port>/debugger with subprotocol "debugger.ppsspp.org".
// This module factors that pattern out without changing those scripts.
//
// Policy: memory writes, register writes, input, savestates and configuration
// changes are always rejected before a frame is written. Debug-control events
// are admitted only so the observer can own one short bind/remove/resume cycle.
import { monotonicNs } from './util.mjs';

export class PolicyViolation extends Error {
  constructor(message) {
    super(message);
    this.name = 'PolicyViolation';
    this.requestSent = false;
  }
}

export const READ_ONLY_EVENTS = Object.freeze([
  'version',
  'game.status',
  'cpu.status',
  'hle.module.list',
  'memory.read',
  'memory.read_u32',
]);

export const DEBUG_CONTROL_EVENTS = Object.freeze([
  'cpu.breakpoint.list',
  'cpu.breakpoint.add',
  'cpu.breakpoint.remove',
  'cpu.getAllRegs',
  'cpu.resume',
  'cpu.stepping',
]);

const ALLOWED_EVENTS = new Set([...READ_ONLY_EVENTS, ...DEBUG_CONTROL_EVENTS]);
const EVENT_KEYED_RESPONSES = new Set(['cpu.resume', 'cpu.stepping']);

// Explicit denylist so a mistake produces a clear policy error instead of a
// generic "unknown event" message.
const FORBIDDEN_PATTERNS = [
  /^memory\.write/i,
  /^memory\.breakpoint/i,
  /^cpu\.set/i,
  /^input\./i,
  /^logpoint/i,
  /^breakpoint/i,
  /^savestate/i,
  /^state\./i,
  /^config\./i,
  /^gpu\./i,
  /^hle\.module\.load/i,
  /^debugger\./i,
];

export class PpssppClient {
  #ws = null;
  #pending = new Map();
  #serial = 0;
  #userClosed = false;
  #disconnectHandlers = new Set();
  #eventHandlers = new Map();
  #lastError = null;
  #connectedAtNs = null;
  #stats = { requests: 0, errors: 0, timeouts: 0, totalRoundTripMs: 0 };

  constructor({
    host = '127.0.0.1',
    port,
    timeoutMs = 8000,
    clientName = 'RACSM Runtime Observer',
    clientVersion = '0.1',
  } = {}) {
    if (!Number.isInteger(port) || port < 1 || port > 65535) {
      throw new Error(`Invalid debugger port: ${port}`);
    }
    this.host = host;
    this.port = port;
    this.timeoutMs = timeoutMs;
    this.clientName = clientName;
    this.clientVersion = clientVersion;
  }

  get url() {
    return `ws://${this.host}:${this.port}/debugger`;
  }

  get connected() {
    return this.#ws !== null && this.#ws.readyState === WebSocket.OPEN;
  }

  get connectedForSeconds() {
    if (this.#connectedAtNs === null) return null;
    return (monotonicNs() - this.#connectedAtNs) / 1e9;
  }

  get lastError() {
    return this.#lastError;
  }

  get stats() {
    return { ...this.#stats, pendingRequests: this.#pending.size };
  }

  onDisconnect(handler) {
    this.#disconnectHandlers.add(handler);
    return () => this.#disconnectHandlers.delete(handler);
  }

  onEvent(eventName, handler) {
    if (!this.#eventHandlers.has(eventName)) this.#eventHandlers.set(eventName, new Set());
    this.#eventHandlers.get(eventName).add(handler);
    return () => this.#eventHandlers.get(eventName)?.delete(handler);
  }

  waitForEvent(eventName, {predicate = null, timeoutMs = this.timeoutMs, signal = null} = {}) {
    return new Promise((resolve, reject) => {
      let done = false;
      const finish = (error, value) => {
        if (done) return;
        done = true;
        clearTimeout(timer);
        off();
        signal?.removeEventListener('abort', onAbort);
        if (error) reject(error);
        else resolve(value);
      };
      const off = this.onEvent(eventName, (payload) => {
        if (predicate && !predicate(payload)) return;
        finish(null, payload);
      });
      const timer = setTimeout(
        () => finish(new Error(`Timeout after ${timeoutMs} ms waiting for unsolicited event "${eventName}"`)),
        timeoutMs,
      );
      const onAbort = () => finish(new Error(signal?.reason ? String(signal.reason) : 'event wait aborted'));
      if (signal?.aborted) onAbort();
      else signal?.addEventListener('abort', onAbort, {once: true});
    });
  }

  async connect() {
    if (this.connected) return;
    this.#userClosed = false;
    const ws = new WebSocket(this.url, 'debugger.ppsspp.org');
    this.#ws = ws;
    await new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        reject(new Error(`PPSSPP connection timeout after ${this.timeoutMs} ms (${this.url})`));
      }, this.timeoutMs);
      ws.addEventListener(
        'open',
        () => {
          clearTimeout(timer);
          this.#connectedAtNs = monotonicNs();
          resolve();
        },
        { once: true },
      );
      ws.addEventListener(
        'error',
        () => {
          clearTimeout(timer);
          reject(new Error(`PPSSPP WebSocket error on ${this.url}`));
        },
        { once: true },
      );
    });
    ws.addEventListener('message', (event) => this.#onMessage(event));
    ws.addEventListener('close', (event) => {
      const reason = `socket closed (code=${event.code}${event.reason ? `, reason=${event.reason}` : ''})`;
      this.#handleDisconnect(reason);
    });
    ws.addEventListener('error', () => {
      // A close event normally follows; this only records context.
      this.#lastError = `socket error on ${this.url}`;
    });
  }

  // Returns the raw response object. Error responses throw with `.response`.
  async request(event, fields = {}) {
    this.#assertAllowed(event);
    // A top-level toJSON hook could replace the entire validated envelope.
    for (const key of ['event', 'ticket', 'toJSON']) {
      if (Object.prototype.hasOwnProperty.call(fields ?? {}, key)) {
        throw new PolicyViolation(`Refusing reserved request envelope field "${key}".`);
      }
    }
    if (!this.connected) {
      throw Object.assign(new Error(`PPSSPP connection is not open (${this.url})`), {requestSent: false});
    }
    const ticket = `${this.clientName.replace(/\s+/g, '-').toLowerCase()}-${++this.#serial}`;
    const startedNs = monotonicNs();
    const response = await new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        this.#pending.delete(ticket);
        this.#stats.timeouts += 1;
        reject(new Error(`Timeout after ${this.timeoutMs} ms waiting for event "${event}"`));
      }, this.timeoutMs);
      this.#pending.set(ticket, { resolve, reject, timer, requestEvent: event });
      try {
        // Transport-owned keys always win, including for unusual field objects.
        this.#ws.send(JSON.stringify({ ...fields, event, ticket }));
      } catch (error) {
        clearTimeout(timer);
        this.#pending.delete(ticket);
        this.#stats.errors += 1;
        reject(Object.assign(new Error(`Failed to send event "${event}": ${error.message}`), {requestSent: false}));
      }
    });
    const elapsedMs = (monotonicNs() - startedNs) / 1e6;
    this.#stats.requests += 1;
    this.#stats.totalRoundTripMs += elapsedMs;
    if (response && response.event === 'error') {
      this.#stats.errors += 1;
      const error = new Error(
        `PPSSPP rejected event "${event}": ${response.message ?? JSON.stringify(response)}`,
      );
      error.response = response;
      throw error;
    }
    return response;
  }

  close(reason = 'closed by user') {
    this.#userClosed = true;
    this.#handleDisconnect(reason);
    try {
      this.#ws?.close();
    } catch {
      /* ignore */
    }
    this.#ws = null;
  }

  #assertAllowed(event) {
    if (typeof event !== 'string' || event.length === 0) {
      throw new PolicyViolation('Event name must be a non-empty string');
    }
    if (ALLOWED_EVENTS.has(event)) return;
    const forbidden = FORBIDDEN_PATTERNS.some((pattern) => pattern.test(event));
    if (forbidden) {
      throw new PolicyViolation(
        `Refusing "${event}": RACSM Observer v0.2 forbids memory/register writes, input and persistent emulator changes.`,
      );
    }
    throw new PolicyViolation(
      `Refusing "${event}": not in the read-only allowlist (${READ_ONLY_EVENTS.join(', ')}).`,
    );
  }

  #onMessage(event) {
    let parsed;
    try {
      const data = typeof event.data === 'string' ? event.data : Buffer.from(event.data).toString('utf8');
      parsed = JSON.parse(data);
    } catch {
      return; // ignore unsolicited or malformed frames
    }
    let pendingKey = parsed.ticket;
    let pending = this.#pending.get(pendingKey);
    if (!pending && EVENT_KEYED_RESPONSES.has(parsed.event)) {
      const entry = [...this.#pending].find(([, candidate]) => candidate.requestEvent === parsed.event);
      if (entry) [pendingKey, pending] = entry;
    }
    if (!pending) {
      for (const handler of this.#eventHandlers.get(parsed.event) ?? []) {
        try {
          handler(parsed);
        } catch {
          /* event handlers must not break the transport */
        }
      }
      return;
    }
    clearTimeout(pending.timer);
    this.#pending.delete(pendingKey);
    pending.resolve(parsed);
  }

  #handleDisconnect(reason) {
    const wasConnected = this.#ws !== null;
    this.#connectedAtNs = null;
    const error = new Error(`PPSSPP connection ${reason}`);
    for (const pending of this.#pending.values()) {
      clearTimeout(pending.timer);
      pending.reject(error);
    }
    this.#pending.clear();
    if (wasConnected && !this.#userClosed) {
      this.#lastError = reason;
      for (const handler of this.#disconnectHandlers) {
        try {
          handler(reason);
        } catch {
          /* handlers must not break the client */
        }
      }
    }
  }
}
