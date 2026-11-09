#!/usr/bin/env python3
"""Read-only probe: does state change per logic tick (counter 0x2AF28C)?

Launches a savestate (see abc-bench.py), then every INTERVAL ms logs emulated ticks,
the frame counter, three camera blocks, the RNG word and N words of one entity.
Nothing is written. Addresses are LEVEL_01 RVAs (module 'rcp1' base added).
Usage: python tools/runtime/render-state-probe.py --slot 0 --entity 0x96f52f0 --out <new>.json
"""
import argparse, importlib.util, json, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('abc_bench', REPO/'tools/runtime/abc-bench.py')
ab = importlib.util.module_from_spec(spec); spec.loader.exec_module(ab)

CAM = (0x302FC4, 0x369E40, 0x369E80)
COUNTER, RNG_PTR = 0x2AF28C, 0x2DB90C

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--slot', type=int, required=True)
    ap.add_argument('--entity', type=lambda x: int(x, 0))
    ap.add_argument('--duration', type=float, default=6)
    ap.add_argument('--interval-ms', type=int, default=50)
    ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args()
    if a.out.exists(): raise SystemExit('refusing to overwrite')
    for n in range(3):
        ab.launch(a.slot)
        try: c = ab.connect(60907, 40); break
        except SystemExit: pass
    else: raise SystemExit('no game')
    time.sleep(3)
    mods = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'rcp1']
    if len(mods) != 1: raise SystemExit('rcp1 not found')
    base = mods[0]['address']
    rows = []; end = time.monotonic()+a.duration
    while time.monotonic() < end:
        r = {'ticks': c.request('cpu.status').get('ticks'), 'counter': c.read(base+COUNTER, 1)[0]}
        r['cam'] = [c.read(base+o, 16) for o in CAM]
        p = c.read(base+RNG_PTR, 1)[0]
        r['rng_ptr'] = p
        if 0x08000000 <= p < 0x0A000000: r['rng'] = c.read(p+0x58, 1)[0]
        if a.entity: r['ent'] = c.read(a.entity, 32)
        rows.append(r); time.sleep(a.interval_ms/1000)
    a.out.write_text(json.dumps({'base': base, 'rows': rows}))
    print('samples', len(rows), 'base', hex(base))

if __name__ == '__main__': main()
