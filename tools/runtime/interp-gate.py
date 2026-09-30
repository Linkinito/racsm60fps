#!/usr/bin/env python3
"""Option A test: LEVEL_01 half-rate entity updates with position interpolation.

Requires the InterpGate plugin (patches/experimental/interp-gate) as the only
resident plugin. Profiles:
  A0  original words, hooks removed
  C1  three-word core + hooks installed, plugin mode 0 (passthrough)
  G   C1 + mode 1: each entity updated every second outer update, accumulated delta
  GI  C1 + mode 2: G + half-way position display on update frames
  H   C1 + mode 3: 60 Hz updates, changed float words keep half their change
  N   C1 + ground-navigation displacement (0x2A8F0 callers) halved
  HN  H + N
  I / IN      integer rule (+-1 changes kept every second update) [+ N]
  HI / HIN    H + integer rule [+ N]
Mode changes between C1/G/GI only write the plugin mode word.

Usage: python tools/runtime/interp-gate.py --target status|A0|C1|G|GI --out <new dir>
"""
import argparse, hashlib, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
BUILD = REPO/'patches/experimental/interp-gate/build/IG-v5'
ENTITY_CALL, JALR_A1 = 0x6B9B8, 0x00A0F809
MODES = {'C1': 0, 'G': 1, 'GI': 2, 'H': 3, 'N': 0, 'HN': 3, 'I': 4, 'IN': 4, 'HI': 5, 'HIN': 5}
NAV = {'N': 1, 'HN': 1, 'IN': 1, 'HIN': 1}
NAV_SITES, NAV_MOVE = (0x29188, 0x29334), 0x2A8F0
FIELDS = ('magic', 'abi', 'mode', 'pump1', 'parity', 'lastDelta', 'runs', 'skips',
          'interps', 'teleports', 'tableFull', 'generation')

def plugin(c, symbols):
    mods = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive')]
    other = [m['name'] for m in mods if m['name'] not in ('mcp', 'rcp1', 'InterpGate')]
    if other: raise RuntimeError('refusing: other plugins resident: %s' % other)
    ig = [m for m in mods if m['name'] == 'InterpGate']
    game = [m for m in mods if m['name'] == 'rcp1']
    if len(ig) != 1: raise RuntimeError('InterpGate plugin not loaded')
    if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise RuntimeError('LEVEL_01 not unique')
    p = ig[0]['address']
    addr = {k: p+v for k, v in symbols.items()}
    state = dict(zip(FIELDS, c.read(addr['ig_state'], 12)))
    if state['magic'] != 0x49475431 or state['abi'] != 1: raise RuntimeError('InterpGate ABI mismatch')
    return game[0]['address'], addr, state

def words(base, addr, installed):
    w = pg.expected(base, 'C1' if installed else 'A0')
    w[pg.CALL] = pg.jal(addr['ig_pump']) if installed else pg.jal(base+pg.PUMP1)
    w[ENTITY_CALL] = pg.jal(addr['ig_entity']) if installed else JALR_A1
    for site in NAV_SITES: w[site] = pg.jal(addr['ig_nav_move']) if installed else pg.jal(base+NAV_MOVE)
    return w

def classify(c, base, addr):
    cur = {r: c.read(base+r, 1)[0] for r in (pg.VBLANK, pg.DELTA, pg.LOOP, pg.CALL, pg.DELAY, ENTITY_CALL, *NAV_SITES)}
    for installed in (False, True):
        exp = words(base, addr, installed)
        if all(cur[r] == exp[r] for r in exp): return installed, cur
    return None, cur

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--target', required=True, choices=('status', 'A0', *MODES))
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args()
    manifest = json.loads((BUILD/'manifest.json').read_text(encoding='utf-8'))
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'target': a.target,
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'prxSha256': manifest['prxSha256'], 'writes': []}
    c = pg.Client('127.0.0.1', a.port); c.connect(); paused = False
    try:
        base, addr, state = plugin(c, manifest['symbols'])
        rec['base'] = hex(base); rec['stateBefore'] = state
        installed, cur = classify(c, base, addr)
        if installed is None: raise RuntimeError('unknown words: '+json.dumps({hex(k): hex(v) for k, v in cur.items()}))
        nav_on = c.read(addr['ig_move'], 1)[0]
        rec['before'] = ('A0' if not installed else next(k for k, v in MODES.items() if v == state['mode'] and NAV.get(k, 0) == nav_on))
        if a.target in ('status', rec['before']):
            rec['result'] = 'OBSERVED'; return rec
        cpu = c.request('cpu.status')
        if cpu.get('paused') or cpu.get('stepping'): raise RuntimeError('CPU must be running')
        c.request('cpu.stepping'); paused = True
        def put(address, value):
            old = c.read(address, 1)[0]
            if old != value:
                rec['writes'].append({'address': hex(address), 'before': hex(old), 'after': hex(value)})
                c.write(address, value)
        mode_addr = addr['ig_state']+8
        if a.target == 'A0':
            put(mode_addr, 0); put(addr['ig_move'], 0); exp = words(base, addr, False)
            for r in (*NAV_SITES, ENTITY_CALL, pg.CALL, pg.VBLANK, pg.DELTA, pg.LOOP): put(base+r, exp[r])
        else:
            if not installed:
                put(mode_addr, 0); put(addr['ig_move'], 0); put(addr['ig_state']+12, base+pg.PUMP1)
                put(addr['ig_move']+4, base+NAV_MOVE)
                exp = words(base, addr, True)
                for r in (pg.VBLANK, pg.DELTA, pg.LOOP, pg.CALL, ENTITY_CALL, *NAV_SITES): put(base+r, exp[r])
            put(mode_addr, MODES[a.target]); put(addr['ig_move'], NAV.get(a.target, 0))
        c.request('cpu.resume'); paused = False
        t0 = c.request('cpu.status')['ticks']; time.sleep(3)
        _, _, after = plugin(c, manifest['symbols']); t1 = c.request('cpu.status')['ticks']
        rec['stateAfter'] = after; rec['navCalls'] = c.read(addr['ig_move']+8, 1)[0]
        if t1 <= t0: raise RuntimeError('ticks did not advance')
        rec['result'] = 'APPLIED_NOT_GAMEPLAY_VALIDATED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
    finally:
        if paused:
            try: c.request('cpu.resume')
            except Exception as e: rec['resumeError'] = str(e)
        c.close()
        a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

if __name__ == '__main__':
    r = main(); print(json.dumps(r))
    raise SystemExit(0 if r['result'] in ('OBSERVED', 'APPLIED_NOT_GAMEPLAY_VALIDATED') else 2)
