#!/usr/bin/env python3
"""E3 frame-time constants: C1 + every LEVEL_01 `lui rX,0x3D08` (1/30 s) -> 0x3C88 (1/60 s).

Hypothesis (INFERRED): hard-coded 1/30 frame-time immediates scale per-call steps,
timers and rate conversions; at 60 updates/s the true frame time is 1/60. The site
list is derived from the pinned vanilla LEVEL_01.PRX (.text words, not relocated:
lui immediates are position independent) and each word is verified live before it
is written. Only the immediate changes; register and opcode are preserved.
Profiles: A0 original, C1 three-word core, F1 C1 + all other 1/30 immediates.

Usage: python tools/runtime/frametime.py --target status|A0|C1|F1 --out <new dir> [--list]
"""
import argparse, hashlib, importlib.util, json, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
PRX = REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX'
SHA = 'd10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571'
TEXT_OFF, TEXT_SIZE = 0x74, 0x1BF1AC
ALLOWED_PLUGINS = ('InterpGate',)          # tolerated only while its hooks are absent

def sites():
    raw = PRX.read_bytes()
    if hashlib.sha256(raw).hexdigest() != SHA: raise RuntimeError('vanilla hash mismatch')
    out = {}
    for rva in range(0, TEXT_SIZE, 4):
        w = struct.unpack_from('<I', raw, TEXT_OFF+rva)[0]
        if w & 0xFFE0FFFF == 0x3C003D08 and rva != pg.DELTA:
            out[rva] = (w, (w & 0xFFFF0000) | 0x3C88)
    return out

def identify(c):
    if c.request('game.status').get('game', {}).get('id') != 'UCES00420': raise RuntimeError('requires UCES00420')
    mods = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive')]
    other = [m['name'] for m in mods if m['name'] not in ('mcp', 'rcp1', *ALLOWED_PLUGINS)]
    if other: raise RuntimeError('refusing: other plugins resident: %s' % other)
    game = [m for m in mods if m['name'] == 'rcp1']
    if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise RuntimeError('LEVEL_01 must be the unique level')
    return game[0]['address']

def classify(c, base, table):
    core = {r: c.read(base+r, 1)[0] for r in (pg.VBLANK, pg.DELTA, pg.LOOP, pg.CALL, pg.DELAY)}
    core_state = next((p for p in ('A0', 'C1') if all(core[r] == v for r, v in pg.expected(base, p).items())), None)
    lo, hi = min(table), max(table)
    data = c.read(base+lo, (hi-lo)//4+1)
    cur = {r: data[(r-lo)//4] for r in table}
    orig = sum(cur[r] == table[r][0] for r in table); new = sum(cur[r] == table[r][1] for r in table)
    consts = 'orig' if orig == len(table) else 'new' if new == len(table) else 'mixed(%d/%d)' % (orig, new)
    if core_state == 'A0' and consts == 'orig': return 'A0'
    if core_state == 'C1' and consts == 'orig': return 'C1'
    if core_state == 'C1' and consts == 'new': return 'F1'
    return 'OTHER core=%s consts=%s' % (core_state, consts)

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--target', choices=('status', 'A0', 'C1', 'F1'))
    ap.add_argument('--out', type=Path); ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--list', action='store_true')
    a = ap.parse_args(); table = sites()
    if a.list:
        print(json.dumps({'count': len(table), 'sites': [hex(r) for r in sorted(table)]})); return 0
    if not a.target or not a.out: ap.error('--target and --out required')
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'target': a.target,
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'siteCount': len(table), 'writes': 0}
    c = pg.Client('127.0.0.1', a.port); c.connect(); paused = False
    try:
        base = identify(c); rec['base'] = hex(base)
        before = classify(c, base, table); rec['before'] = before
        if before.startswith('OTHER'): raise RuntimeError('unknown state: '+before)
        if a.target in ('status', before): rec['result'] = 'OBSERVED'; return rec
        cpu = c.request('cpu.status')
        if cpu.get('paused') or cpu.get('stepping'): raise RuntimeError('CPU must be running')
        c.request('cpu.stepping'); paused = True
        if classify(c, base, table) != before: raise RuntimeError('state changed while pausing')
        core = pg.expected(base, 'A0' if a.target == 'A0' else 'C1')
        want = {r: (table[r][1] if a.target == 'F1' else table[r][0]) for r in table}
        for r, v in {**want, **{k: core[k] for k in (pg.VBLANK, pg.DELTA, pg.LOOP)}}.items():
            if c.read(base+r, 1)[0] != v:
                c.write(base+r, v); rec['writes'] += 1
        after = classify(c, base, table)
        if after != a.target: raise RuntimeError('post-write state '+after)
        c.request('cpu.resume'); paused = False
        t0 = c.request('cpu.status')['ticks']; time.sleep(3); t1 = c.request('cpu.status')['ticks']
        rec['after'] = classify(c, base, table)
        if t1 <= t0 or rec['after'] != a.target: raise RuntimeError('health check failed')
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
    r = main()
    if isinstance(r, dict):
        print(json.dumps(r)); raise SystemExit(0 if r['result'] in ('OBSERVED', 'APPLIED_NOT_GAMEPLAY_VALIDATED') else 2)
