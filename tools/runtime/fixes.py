#!/usr/bin/env python3
"""Targeted LEVEL_01 60 FPS fixes on top of C1, switchable live (experimental RAM).

Requires the InterpGate plugin (IG-v6) as the only plugin. Each fix is a guarded
set of word writes; wrappers live in the plugin, data fixes are direct writes.
  nav       ground-navigation displacement halved (0x2A8F0 callers)       [owner: crab speed OK]
  debris    debris physics half-step (0x191D7C callers, 8 shrapnel classes)
  animdisp  animated displacement halved (0x6C318 callers, 38 sites)
  crab      crab attack frame threshold 27 -> 54 (data RVA 0x2CF3C8)    [owner: timing OK]
  particles waterfall particle animator 0xDE23C half-step (walker jalr site 0x8CE54)
Usage:
  python tools/runtime/fixes.py --target C1 --fix nav,crab --out <new dir>
  python tools/runtime/fixes.py --target A0 --out <new dir>
  python tools/runtime/fixes.py --target status --out <new dir>
"""
import argparse, hashlib, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
BUILD = REPO/'patches/experimental/interp-gate/build/IG-v10'
WRAPPERS = {  # name: (callee RVA, call sites, wrapper symbol, enable symbol, word offset)
    'nav': (0x2A8F0, (0x29188, 0x29334), 'ig_nav_move', 'ig_move', 0),
    'debris': (0x191D7C, (0x10E41C, 0x116320, 0x1239C8, 0x128230, 0x14328C, 0x17195C, 0x1833FC, 0x186750),
               'ig_debris', 'ig_fix', 0),
    'animdisp': (0x6C318, tuple(int(x, 16) for x in (
        '4378c 43c6c 64460 6c2f4 10bc58 117020 11aaf8 12ba0c 132ca0 132f78 1330e4 133328 139668 '
        '139b5c 139d9c 139e7c 142b10 144a6c 159cac 15a524 15aae0 15bcc8 168998 168ea0 168ef4 '
        '169088 16a11c 16d5b8 16f12c 16f2b0 16fc6c 16fcd0 170670 176040 1764e4 197834 19ac90 19b144').split()),
        'ig_anim_disp', 'ig_fix', 4),
}
DATA = {'crab': (0x2CF3C8, 0x41D80000, 0x42580000)}
PARTICLE_SITE, JALR_T0, PARTICLE_ANIMATOR = 0x8CE54, 0x0100F809, 0xDE23C
FIXES = (*WRAPPERS, *DATA, 'particles')

def resident(c, symbols):
    mods = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive')]
    other = [m['name'] for m in mods if m['name'] not in ('mcp', 'rcp1', 'InterpGate')]
    if other: raise RuntimeError('refusing: other plugins resident: %s' % other)
    game = [m for m in mods if m['name'] == 'rcp1']; ig = [m for m in mods if m['name'] == 'InterpGate']
    if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise RuntimeError('LEVEL_01 not unique')
    if len(ig) != 1: raise RuntimeError('InterpGate not loaded')
    return game[0]['address'], {k: ig[0]['address']+v for k, v in symbols.items()}

def state(c, base, addr):
    core = {r: c.read(base+r, 1)[0] for r in (pg.VBLANK, pg.DELTA, pg.LOOP, pg.CALL, pg.DELAY)}
    core_state = next((p for p in ('A0', 'C1') if all(core[r] == v for r, v in pg.expected(base, p).items())), 'OTHER')
    fixes = {}
    for name, (callee, sites, sym, _, _) in WRAPPERS.items():
        words = [c.read(base+s, 1)[0] for s in sites]
        fixes[name] = 'off' if all(w == pg.jal(base+callee) for w in words) else \
            'on' if all(w == pg.jal(addr[sym]) for w in words) else 'MIXED'
    for name, (rva, orig, new) in DATA.items():
        w = c.read(base+rva, 1)[0]; fixes[name] = 'off' if w == orig else 'on' if w == new else 'MIXED'
    w = c.read(base+PARTICLE_SITE, 1)[0]
    fixes['particles'] = 'off' if w == JALR_T0 else 'on' if w == pg.jal(addr['ig_pwrap_stub']) else 'MIXED'
    return core_state, fixes

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--target', required=True, choices=('status', 'A0', 'C1'))
    ap.add_argument('--fix', default='', help='comma list: '+','.join(FIXES))
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args(); want = {f for f in a.fix.split(',') if f}
    if want - set(FIXES): ap.error('unknown fix')
    if a.target == 'A0' and want: ap.error('A0 takes no fixes')
    manifest = json.loads((BUILD/'manifest.json').read_text(encoding='utf-8'))
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'target': a.target, 'fix': sorted(want),
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(), 'prxSha256': manifest['prxSha256'], 'writes': 0}
    c = pg.Client('127.0.0.1', a.port); c.connect(); paused = False
    try:
        base, addr = resident(c, manifest['symbols']); rec['base'] = hex(base)
        rec['before'] = state(c, base, addr)
        if 'OTHER' in rec['before'][0] or 'MIXED' in rec['before'][1].values(): raise RuntimeError('unknown state %r' % (rec['before'],))
        if a.target == 'status': rec['result'] = 'OBSERVED'; return rec
        cpu = c.request('cpu.status')
        if cpu.get('paused') or cpu.get('stepping'): raise RuntimeError('CPU must be running')
        c.request('cpu.stepping'); paused = True
        def put(address, value):
            if c.read(address, 1)[0] != value: c.write(address, value); rec['writes'] += 1
        exp = pg.expected(base, a.target)
        for name, (callee, sites, sym, en, off) in WRAPPERS.items():
            on = name in want
            put(addr[en]+4*off+4, base+callee)                 # original address before redirect
            put(addr[en]+4*off, 1 if on else 0)
            for s in sites: put(base+s, pg.jal(addr[sym]) if on else pg.jal(base+callee))
        for name, (rva, orig, new) in DATA.items(): put(base+rva, new if name in want else orig)
        put(addr['ig_pfix']+4, base+PARTICLE_ANIMATOR); put(addr['ig_pfix'], 1 if 'particles' in want else 0)
        put(base+PARTICLE_SITE, pg.jal(addr['ig_pwrap_stub']) if 'particles' in want else JALR_T0)
        for r in (pg.VBLANK, pg.DELTA, pg.LOOP, pg.CALL): put(base+r, exp[r])
        after = state(c, base, addr)
        if after[0] != a.target or any((v == 'on') != (k in want) for k, v in after[1].items()):
            raise RuntimeError('post-write state %r' % (after,))
        c.request('cpu.resume'); paused = False
        t0 = c.request('cpu.status')['ticks']; time.sleep(3); t1 = c.request('cpu.status')['ticks']
        rec['after'] = state(c, base, addr)
        rec['calls'] = {'nav': c.read(addr['ig_move']+8, 1)[0], 'debris': c.read(addr['ig_fix']+8, 1)[0],
                        'animdisp': c.read(addr['ig_fix']+24, 1)[0], 'particleCalls': c.read(addr['ig_pfix']+8, 1)[0],
                        'particles': c.read(addr['ig_pfix']+12, 1)[0]}
        if t1 <= t0: raise RuntimeError('ticks did not advance')
        rec['result'] = 'APPLIED_NOT_GAMEPLAY_VALIDATED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
    finally:
        if paused:
            try: c.request('cpu.resume')
            except Exception as e: rec['resumeError'] = str(e)
        c.close(); a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

if __name__ == '__main__':
    r = main(); print(json.dumps(r))
    raise SystemExit(0 if r['result'] in ('OBSERVED', 'APPLIED_NOT_GAMEPLAY_VALIDATED') else 2)
