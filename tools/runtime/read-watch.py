#!/usr/bin/env python3
"""Collect the instructions (PC, ra) that READ a memory range, via one temporary memory breakpoint.

Read-only apart from the breakpoint (removed at the end). Usage:
  python tools/runtime/read-watch.py --addr 0x96f5320 --size 4 --stops 60 --out <new>.json
PCs are also reported as rcp1 RVAs when the module is resident.
"""
import argparse, collections, importlib.util, json, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pg', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)

pg.ws.ALLOWED |= {'memory.breakpoint.add', 'memory.breakpoint.remove', 'memory.breakpoint.list'}
ap = argparse.ArgumentParser()
ap.add_argument('--addr', type=lambda x: int(x, 0), required=True)
ap.add_argument('--size', type=int, default=4)
ap.add_argument('--stops', type=int, default=60)
ap.add_argument('--wall-max', type=float, default=60)
ap.add_argument('--out', type=Path, required=True)
a = ap.parse_args()
if a.out.exists(): raise SystemExit('refusing to overwrite')
c = pg.Client('127.0.0.1', 60907); c.connect(); added = False; hits = []
mods = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'rcp1']
base = mods[0]['address']
try:
    if c.request('memory.breakpoint.list').get('breakpoints'): raise SystemExit('memory breakpoints already set')
    c.request('memory.breakpoint.add', {'type': 'memory', 'address': a.addr, 'size': a.size, 'read': True, 'write': False, 'change': False, 'enabled': True, 'log': False})
    added = True; end = time.monotonic()+a.wall_max
    while len(hits) < a.stops and time.monotonic() < end:
        st = c.request('cpu.status')
        if st.get('stepping'):
            cat = c.request('cpu.getAllRegs')['categories'][0]; n = cat['registerNames']; v = cat['uintValues']
            hits.append({'tick': st.get('ticks'), 'pc': st['pc'], 'ra': v[n.index('ra')], 'a0': v[n.index('a0')]})
            c.request('cpu.resume', no_reply=True, delay_ms=30)
        time.sleep(0.03)
finally:
    if added: c.request('memory.breakpoint.remove', {'address': a.addr, 'size': a.size})
    if c.request('cpu.status').get('stepping'): c.request('cpu.resume', no_reply=True, delay_ms=50)
a.out.write_text(json.dumps({'base': base, 'addr': a.addr, 'hits': hits}))
cnt = collections.Counter((h['pc']-base, h['ra']-base) for h in hits)
print('hits', len(hits))
for (pc, ra), n in cnt.most_common(12): print('pc rva 0x%X ra rva 0x%X x%d' % (pc, ra, n))
