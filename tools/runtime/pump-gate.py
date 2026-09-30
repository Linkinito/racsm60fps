#!/usr/bin/env python3
"""E1 pump gate: run LEVEL_01 group pump 1 every second outer update (experimental RAM).

Hypothesis under test (INFERRED): under C1 most objects are ~2x too fast because
the first group pump (0x6B7F4, called once per outer update at 0x15230) applies
fixed per-call steps. G1 = C1 core + a cave gate that skips every second pump call
and hands the executed call the accumulated delta (f12) of both updates, so
delta consumers keep their real-time rate. Player, camera, the second pump and
all other subsystems stay at 60 Hz. No plugin is required: the gate lives in the
zero run of LEVEL_01 .data (r-x PT_LOAD0) already used by earlier caves.

Profiles: A0 original, C1 three-word core, G1 C1 + gate. The cave is retained
after removal (unreachable). Refuses when any plugin module is resident.

Usage:
  python tools/runtime/pump-gate.py --target status|A0|C1|G1 --out <new dir>
  python tools/runtime/pump-gate.py --self-test
"""
import argparse, base64, hashlib, importlib.util, json, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location(
    'ppsspp_ws', REPO/'research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py')
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)

MODULE_SIZE = 0x46B900                      # LEVEL_01 (rcp1) load extent
VBLANK, DELTA, LOOP = 0x96650, 0x151E0, 0x2FCFC
CALL, DELAY = 0x15230, 0x15234              # jal pump1 ; mov.s f12,f20
PUMP1, VBLANK_STUB = 0x6B7F4, 0x1BF424
MOV_F12_F20 = 0x4600A306
STATE = 0x2C2400                            # mode, phase, accum, runs, skips
CODE = 0x2C2420
CAVE_SPAN = 0x80                            # STATE..CODE+0x60, inside 0x2C1814..0x2C281C zero run
CORE = {'A0': None, 'C1': {DELTA: 0x3C043C88, LOOP: 0x2A240001}}
ORIGINAL_CORE = {DELTA: 0x3C043D08, LOOP: 0x2A240002}

T0, T1, T2, T3, RA = 8, 9, 10, 11, 31

def jal(target): return 0x0C000000 | ((target >> 2) & 0x03FFFFFF)
def j(target): return 0x08000000 | ((target >> 2) & 0x03FFFFFF)
def lui(rt, imm): return 0x3C000000 | rt << 16 | (imm & 0xFFFF)
def addiu(rt, rs, imm): return 0x24000000 | rs << 21 | rt << 16 | (imm & 0xFFFF)
def lw(rt, off, rs): return 0x8C000000 | rs << 21 | rt << 16 | (off & 0xFFFF)
def sw(rt, off, rs): return 0xAC000000 | rs << 21 | rt << 16 | (off & 0xFFFF)
def lwc1(ft, off, rs): return 0xC4000000 | rs << 21 | ft << 16 | (off & 0xFFFF)
def swc1(ft, off, rs): return 0xE4000000 | rs << 21 | ft << 16 | (off & 0xFFFF)
def xori(rt, rs, imm): return 0x38000000 | rs << 21 | rt << 16 | (imm & 0xFFFF)
def beqz(rs, off): return 0x10000000 | rs << 21 | (off & 0xFFFF)
def bnez(rs, off): return 0x14000000 | rs << 21 | (off & 0xFFFF)
def add_s(fd, fs, ft): return 0x46000000 | ft << 16 | fs << 11 | fd << 6
MTC1_ZERO_F0, JR_RA, NOP = 0x44800000, 0x03E00008, 0

def gate_code(base):
    """Cave body. Clobbers only caller-saved t0-t3/f0 (callsite is a plain jal)."""
    s = base+STATE; p = base+PUMP1
    hi = (s + 0x8000) >> 16; lo = s & 0xFFFF
    return [
        lui(T0, hi), addiu(T0, T0, lo),             # 0,1  t0=&state
        lw(T1, 0, T0),                             # 2    mode
        beqz(T1, 12),                              # 3 -> 16 pass
        lw(T2, 4, T0),                             # 4    phase (delay)
        xori(T2, T2, 1),                           # 5
        bnez(T2, 11),                              # 6 -> 18 skip
        sw(T2, 4, T0),                             # 7    store phase (delay)
        lwc1(0, 8, T0),                            # 8    f0 = accumulated delta
        add_s(12, 12, 0),                          # 9    f12 += f0
        MTC1_ZERO_F0,                              # 10
        swc1(0, 8, T0),                            # 11   accum = 0
        lw(T3, 12, T0),                            # 12   runs++
        addiu(T3, T3, 1),                          # 13
        j(p),                                      # 14   tail call pump1 (ra -> 0x15238)
        sw(T3, 12, T0),                            # 15   (delay)
        j(p),                                      # 16 pass: tail call unchanged
        NOP,                                       # 17
        swc1(12, 8, T0),                           # 18 skip: accum = f12
        lw(T3, 16, T0),                            # 19   skips++
        addiu(T3, T3, 1),                          # 20
        JR_RA,                                     # 21
        sw(T3, 16, T0),                            # 22   (delay)
    ]

def expected(base, profile):
    words = {VBLANK: jal(base+VBLANK_STUB), CALL: jal(base+PUMP1), DELAY: MOV_F12_F20, **ORIGINAL_CORE}
    if profile in ('C1', 'G1'):
        words.update({VBLANK: 0, **CORE['C1']})
    if profile == 'G1':
        words[CALL] = jal(base+CODE)
    return words

def cave_words(base):
    code = gate_code(base)
    state = [1, 0, 0, 0, 0, 0, 0, 0]
    return state + code + [0]*(CAVE_SPAN//4 - len(state) - len(code))

class Client(ws.DebuggerClient):
    def raw_request(self, message):
        self.seq += 1; message['ticket'] = 'pg-%d' % self.seq
        self._send_frame(json.dumps(message).encode())
        deadline = time.monotonic()+ws.REQUEST_TIMEOUT_S
        while True:
            reply = json.loads(self._recv_message())
            if reply.get('ticket') == message['ticket']:
                if reply.get('event') == 'error':
                    raise ws.WsError(json.dumps(reply))
                return reply
            if time.monotonic() > deadline:
                raise ws.WsError('timeout '+message['event'])
    def read(self, address, count):
        r = self.request('memory.read', {'address': address, 'size': 4*count, 'replacements': False})
        data = base64.b64decode(r['base64'])
        if len(data) != 4*count: raise ws.WsError('short read')
        return list(struct.unpack('<%dI' % count, data))
    def write(self, address, value):
        self.raw_request({'event': 'memory.write_u32', 'address': address, 'value': value})
        if self.read(address, 1)[0] != value: raise ws.WsError('readback mismatch at 0x%08X' % address)

def identify(c):
    if c.request('game.status').get('game', {}).get('id') != 'UCES00420':
        raise RuntimeError('requires UCES00420')
    mods = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive')]
    names = sorted(m['name'] for m in mods)
    if [m for m in mods if m['name'] not in ('mcp', 'rcp1')]:
        raise RuntimeError('refusing: other modules/plugins resident: %s' % names)
    game = [m for m in mods if m['name'] == 'rcp1']
    if len(game) != 1 or game[0]['size'] != MODULE_SIZE:
        raise RuntimeError('LEVEL_01 (Pokitaru) must be the unique resident level')
    return game[0]['address'], names

def classify(c, base):
    words = {r: c.read(base+r, 1)[0] for r in (VBLANK, DELTA, LOOP, CALL, DELAY)}
    cave = c.read(base+STATE, CAVE_SPAN//4)
    for profile in ('A0', 'C1', 'G1'):
        exp = expected(base, profile)
        if all(words[r] == exp[r] for r in exp):
            return profile, words, cave
    return 'OTHER', words, cave

def run(target, port, out):
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'target': target,
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(), 'writes': []}
    c = Client('127.0.0.1', port); c.connect(); paused = False
    try:
        base, names = identify(c); rec['base'] = hex(base); rec['modules'] = names
        cpu = c.request('cpu.status')
        if cpu.get('paused') or cpu.get('stepping') or c.request('cpu.breakpoint.list').get('breakpoints'):
            raise RuntimeError('CPU must be running without breakpoints')
        profile, words, cave = classify(c, base)
        rec['before'] = profile; rec['stateBefore'] = cave[:5]
        if profile == 'OTHER':
            raise RuntimeError('unknown word state: '+json.dumps({hex(k): hex(v) for k, v in words.items()}))
        wanted_cave = cave_words(base)
        if cave != [0]*len(cave) and cave[8:] != wanted_cave[8:]:
            raise RuntimeError('cave region is not zero nor our gate')
        if target == 'status' or target == profile:
            rec['result'] = 'OBSERVED' if target == 'status' else 'ALREADY'
            rec['state'] = dict(zip(('mode', 'phase', 'accum', 'runs', 'skips'), cave[:5]))
            return rec
        c.request('cpu.stepping'); paused = True
        if identify(c)[0] != base or classify(c, base)[0] != profile:
            raise RuntimeError('state changed while pausing')
        def put(rva, value):
            old = c.read(base+rva, 1)[0]
            if old != value:
                rec['writes'].append({'rva': hex(rva), 'before': hex(old), 'after': hex(value)})
                c.write(base+rva, value)
        if target == 'G1':
            if cave[8:] != wanted_cave[8:]:
                for i, w in enumerate(wanted_cave[8:]): put(CODE+4*i, w)
            for i in range(5): put(STATE+4*i, wanted_cave[i])     # mode1, reset phase/accum/counters
        exp = expected(base, target)
        order = [CALL, VBLANK, DELTA, LOOP] if profile == 'G1' else [VBLANK, DELTA, LOOP, CALL]
        for rva in order: put(rva, exp[rva])
        if classify(c, base)[0] != target: raise RuntimeError('post-write verification failed')
        c.request('cpu.resume'); paused = False
        t0 = c.request('cpu.status')['ticks']; time.sleep(3)
        after, _, cave2 = classify(c, base); t1 = c.request('cpu.status')['ticks']
        rec['after'] = after; rec['state'] = dict(zip(('mode', 'phase', 'accum', 'runs', 'skips'), cave2[:5]))
        if after != target or t1 <= t0: raise RuntimeError('health check failed')
        if target == 'G1' and (cave2[3] < 30 or abs(cave2[3]-cave2[4]) > 1):
            raise RuntimeError('gate counters not alternating: %r' % cave2[:5])
        rec['result'] = 'APPLIED_NOT_GAMEPLAY_VALIDATED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
        if paused and 'base' in rec and rec['before'] in ('A0', 'C1', 'G1'):
            try:
                exp = expected(base, rec['before'])
                for rva in [CALL, VBLANK, DELTA, LOOP]:
                    if c.read(base+rva, 1)[0] != exp[rva]: c.write(base+rva, exp[rva])
                rec['rollback'] = rec['before']
            except Exception as r:
                rec['rollbackError'] = str(r)
    finally:
        if paused:
            try: c.request('cpu.resume')
            except Exception as e: rec['resumeError'] = str(e)
        c.close()
        out.mkdir(parents=True, exist_ok=False)
        (out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

def self_test():
    base = 0x09164000
    words = gate_code(base)
    assert len(words) == 23 and 8*4 + len(words)*4 <= CAVE_SPAN
    assert add_s(20, 12, 12) == 0x460C6500          # known encoding from socle map
    assert expected(base, 'A0')[VBLANK] == jal(base+VBLANK_STUB)
    return ' '.join('%08x' % w for w in words)

if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--target', choices=('status', 'A0', 'C1', 'G1'))
    ap.add_argument('--out', type=Path); ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--self-test', action='store_true')
    a = ap.parse_args()
    if a.self_test:
        print(self_test()); raise SystemExit(0)
    if not a.target or not a.out: ap.error('--target and --out required')
    r = run(a.target, a.port, a.out); print(json.dumps(r))
    raise SystemExit(0 if r['result'] in ('OBSERVED', 'ALREADY', 'APPLIED_NOT_GAMEPLAY_VALIDATED') else 2)
