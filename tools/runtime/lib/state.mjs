// Recognition of the four known RACSM timing guards (read-only).
//
// The four words live at fixed RVAs of the active gameplay module (rcp1).
// Their runtime base must always be detected dynamically: it differs between
// launches, so a stale base is never reused (see docs/methodology).
import {hexAddress, hexWord} from './util.mjs';

export const GAME_ID = 'UCES00420';
export const MODULE_NAME = 'rcp1';

// RVAs are relative to the active gameplay module base.
export const GUARDS = Object.freeze([
  {key: 'wait', rva: 0x96650, title: 'WAIT call', vanilla: 'vanilla WAIT call (JAL base+0x1BF424)'},
  {key: 'sharedDelta', rva: 0x151e0, title: 'shared delta', vanilla: '1/30 (0x3C043D08)'},
  {key: 'loopThreshold', rva: 0x2fcfc, title: 'loop threshold', vanilla: 'threshold 2 (0x2A240002)'},
  {key: 'localScalar', rva: 0x2fbbc, title: 'local scalar', vanilla: 'vanilla (0x46006506)'},
]);

export const WAIT_TARGET_RVA = 0x1bf424;

export const WORDS = Object.freeze({
  WAIT_NOP: 0x00000000,
  SHARED_DELTA_30: 0x3c043d08,
  SHARED_DELTA_60: 0x3c043c88,
  LOOP_THRESHOLD_2: 0x2a240002,
  LOOP_THRESHOLD_1: 0x2a240001,
  LOCAL_SCALAR_VANILLA: 0x46006506,
});

// The lowest guard RVA; a module smaller than this cannot be the gameplay module.
export const MIN_MODULE_BYTES = 0x40000;

// MIPS JAL encoding, mirroring the existing live-test expectation.
export function jalWord(pc, target) {
  return (((pc + 4) & 0xf0000000) | (3 << 26) | ((target >>> 2) & 0x03ffffff)) >>> 0;
}

export function waitVanillaWord(base) {
  return jalWord(base + GUARDS[0].rva, base + WAIT_TARGET_RVA);
}

export async function readGuards(client, base) {
  const guards = {};
  for (const guard of GUARDS) {
    const address = base + guard.rva;
    guards[guard.key] = {
      key: guard.key,
      title: guard.title,
      rva: guard.rva,
      address,
      word: await readWord(client, address),
    };
  }
  return guards;
}

// Guard words MUST be read with memory.read(replacements:false), the primitive
// already validated by the repository's live sessions (their guard-*.bin
// captures used the same call). The debugger's memory.read_u32 can return
// emulator-internal words for patched instruction addresses, which would make
// a known state look UNKNOWN.
export async function readWord(client, address) {
  const response = await client.request('memory.read', {address, size: 4, replacements: false});
  if (typeof response.base64 !== 'string') {
    throw new Error(`Missing payload for guard read at ${hexAddress(address)}`);
  }
  const buffer = Buffer.from(response.base64, 'base64');
  if (buffer.length < 4) {
    throw new Error(`Short payload (${buffer.length} bytes) for guard read at ${hexAddress(address)}`);
  }
  return buffer.readUInt32LE(0) >>> 0;
}

export function guardLabel(key, base, word) {
  switch (key) {
    case 'wait':
      if (word === waitVanillaWord(base)) return 'vanilla WAIT call';
      if (word === WORDS.WAIT_NOP) return 'NOP (WAIT removed)';
      return 'unexpected';
    case 'sharedDelta':
      if (word === WORDS.SHARED_DELTA_30) return '1/30 (0x3C043D08)';
      if (word === WORDS.SHARED_DELTA_60) return '1/60 (0x3C043C88)';
      return 'unexpected';
    case 'loopThreshold':
      if (word === WORDS.LOOP_THRESHOLD_2) return 'threshold 2 (0x2A240002)';
      if (word === WORDS.LOOP_THRESHOLD_1) return 'threshold 1 (0x2A240001)';
      return 'unexpected';
    case 'localScalar':
      if (word === WORDS.LOCAL_SCALAR_VANILLA) return 'vanilla (0x46006506)';
      return 'unexpected';
    default:
      return 'unknown guard';
  }
}

export function stateDescription(state) {
  switch (state) {
    case 'A0':
      return 'A0 (vanilla 30 FPS)';
    case 'B0':
      return 'B0 (WAIT NOP, shared delta 1/30)';
    case 'B1':
      return 'B1 (WAIT NOP, shared delta 1/60)';
    case 'C1':
      return 'C1 (WAIT NOP, shared delta 1/60, loop threshold 1)';
    default:
      return 'UNKNOWN';
  }
}

// Strict classification: any unexpected word or any hybrid combination is
// UNKNOWN and must cause a capture refusal rather than a guess.
export function classifyState(guards, base) {
  const waitVanilla = waitVanillaWord(base);
  const wait = guards.wait.word;
  const shared = guards.sharedDelta.word;
  const threshold = guards.loopThreshold.word;
  const scalar = guards.localScalar.word;

  const waitKind = wait === waitVanilla ? 'vanilla' : wait === WORDS.WAIT_NOP ? 'nop' : 'unexpected';
  const sharedKind =
    shared === WORDS.SHARED_DELTA_30
      ? '1/30'
      : shared === WORDS.SHARED_DELTA_60
        ? '1/60'
        : 'unexpected';
  const thresholdKind =
    threshold === WORDS.LOOP_THRESHOLD_2
      ? '2'
      : threshold === WORDS.LOOP_THRESHOLD_1
        ? '1'
        : 'unexpected';
  const scalarKind = scalar === WORDS.LOCAL_SCALAR_VANILLA ? 'vanilla' : 'unexpected';

  const reasons = [];
  if (waitKind === 'unexpected') {
    reasons.push(
      `base+0x96650 = ${hexWord(wait)} (expected ${hexWord(waitVanilla)} vanilla WAIT call or 0x00000000 NOP)`,
    );
  }
  if (sharedKind === 'unexpected') {
    reasons.push(
      `base+0x151E0 = ${hexWord(shared)} (expected 0x3C043D08 1/30 or 0x3C043C88 1/60)`,
    );
  }
  if (thresholdKind === 'unexpected') {
    reasons.push(
      `base+0x2FCFC = ${hexWord(threshold)} (expected 0x2A240002 threshold 2 or 0x2A240001 threshold 1)`,
    );
  }
  if (scalarKind === 'unexpected') {
    reasons.push(`base+0x2FBBC = ${hexWord(scalar)} (expected 0x46006506 vanilla local scalar)`);
  }

  let state = 'UNKNOWN';
  if (waitKind === 'vanilla' && sharedKind === '1/30' && thresholdKind === '2' && scalarKind === 'vanilla') {
    state = 'A0';
  } else if (waitKind === 'nop' && sharedKind === '1/30' && thresholdKind === '2' && scalarKind === 'vanilla') {
    state = 'B0';
  } else if (waitKind === 'nop' && sharedKind === '1/60' && thresholdKind === '2' && scalarKind === 'vanilla') {
    state = 'B1';
  } else if (waitKind === 'nop' && sharedKind === '1/60' && thresholdKind === '1' && scalarKind === 'vanilla') {
    state = 'C1';
  }

  if (state === 'UNKNOWN' && reasons.length === 0) {
    reasons.push(
      'all four guards hold individually known words but the combination is hybrid/unexpected ' +
        `(wait=${waitKind}, sharedDelta=${sharedKind}, loopThreshold=${thresholdKind}, localScalar=${scalarKind})`,
    );
  }

  return {
    state,
    reasons,
    kinds: {waitKind, sharedKind, thresholdKind, scalarKind},
    expected: {
      waitVanilla: hexWord(waitVanilla),
      waitNop: hexWord(WORDS.WAIT_NOP),
      sharedDelta30: hexWord(WORDS.SHARED_DELTA_30),
      sharedDelta60: hexWord(WORDS.SHARED_DELTA_60),
      loopThreshold2: hexWord(WORDS.LOOP_THRESHOLD_2),
      loopThreshold1: hexWord(WORDS.LOOP_THRESHOLD_1),
      localScalarVanilla: hexWord(WORDS.LOCAL_SCALAR_VANILLA),
    },
  };
}

// Full identity inspection: connection features + guards + strict state.
// Nothing here writes to the emulator.
export async function inspectIdentity(client, {clientName, clientVersion} = {}) {
  const versionResponse = await client.request('version', {
    name: clientName ?? 'RACSM Runtime Observer',
    version: clientVersion ?? '0.1',
  });
  const gameResponse = await client.request('game.status');
  const cpuResponse = await client.request('cpu.status');
  const modulesResponse = await client.request('hle.module.list');

  const refusal = [];
  const game = gameResponse.game ?? {};
  if (game.id !== GAME_ID) {
    refusal.push(`game id is ${game.id ?? 'unknown'}, expected ${GAME_ID}`);
  }

  const modules = Array.isArray(modulesResponse.modules) ? modulesResponse.modules : [];
  const candidates = modules.filter((module) => module.name === MODULE_NAME && module.isActive);
  if (candidates.length !== 1) {
    refusal.push(
      `active module "${MODULE_NAME}" is not uniquely present (${candidates.length} candidate(s) in ${modules
        .map((m) => `${m.name}${m.isActive ? '' : ' (inactive)'}`)
        .join(', ') || 'empty module list'})`,
    );
  }
  const module = candidates[0] ?? null;
  if (module && (!Number.isInteger(module.size) || module.size < MIN_MODULE_BYTES)) {
    refusal.push(
      `module "${MODULE_NAME}" size ${hexAddress(module.size ?? 0)} is too small to contain the known guards`,
    );
  }

  let guards = null;
  let classification = null;
  if (refusal.length === 0) {
    guards = await readGuards(client, module.address);
    classification = classifyState(guards, module.address);
    if (classification.state === 'UNKNOWN') refusal.push(...classification.reasons);
  }

  const guardView = {};
  if (guards) {
    for (const guard of GUARDS) {
      const entry = guards[guard.key];
      guardView[guard.key] = {
        rva: `0x${guard.rva.toString(16).toUpperCase()}`,
        address: hexAddress(entry.address),
        word: hexWord(entry.word),
        label: guardLabel(guard.key, module.address, entry.word),
      };
    }
  }

  return {
    inspectedAtUtc: new Date().toISOString(),
    ppsspp: {name: versionResponse.name ?? 'PPSSPP', version: versionResponse.version ?? null},
    game: {id: game.id ?? null, version: game.version ?? null, title: game.title ?? null},
    gamePaused: gameResponse.paused === true,
    cpu: {
      stepping: cpuResponse.stepping === true,
      paused: cpuResponse.paused === true,
      pc: Number.isInteger(cpuResponse.pc) ? cpuResponse.pc : null,
      ticks: Number.isInteger(cpuResponse.ticks) ? cpuResponse.ticks : null,
    },
    modules,
    module: module
      ? {name: module.name, address: module.address, size: module.size ?? null, isActive: module.isActive === true}
      : null,
    guards: guardView,
    guardWords: guards
      ? Object.fromEntries(Object.entries(guards).map(([key, value]) => [key, value.word]))
      : null,
    state: classification?.state ?? 'UNKNOWN',
    stateReasons: refusal,
    identityValid: refusal.length === 0,
  };
}
