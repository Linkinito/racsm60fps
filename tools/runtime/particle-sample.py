#!/usr/bin/env python3
"""Sample world-space particle draw entries at the entry of the flush FUN_0008E2D4 (once per frame, present in A0 and patched).

At each stop: the pending direct draw entries (array 0x302F1C, last-entry pointer 0x2DD330) are read; for types 6, 7, 8
(stride 20/24, position = last three floats of the vertex) the centroid of the vertex positions, the vertex count and the
key are logged with the emulated tick. Read-only apart from one temporary breakpoint. Fire is NOT injected here.
Usage: python tools/runtime/particle-sample.py --stops 150 --out <new>.json
"""
import argparse, base64, importlib.util, json, struct, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pg', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
ap = argparse.ArgumentParser(); ap.add_argument('--stops', type=int, default=150); ap.add_argument('--out', type=Path, required=True)
a = ap.parse_args()
if a.out.exists(): raise SystemExit('refusing to overwrite')
c = pg.Client('127.0.0.1', 60907); c.connect()
base = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'rcp1'][0]['address']
stride = [c.read(base+0x2B66B0+4*i, 1)[0] for i in range(16)]
bp = base+0x8E2D4; rows = []
c.request('cpu.breakpoint.add', {'address': bp, 'enabled': True, 'log': False})
try:
    t0 = time.monotonic()
    while len(rows) < a.stops and time.monotonic()-t0 < 120:
        s = c.request('cpu.status')
        if not s.get('stepping'): time.sleep(0.005); continue
        arr = c.read(base+0x302F1C, 1)[0]; last = c.read(base+0x2DD330, 1)[0]
        n = (last-arr)//0x14+1 if last >= arr else 0
        ents = []
        if 0 < n <= 128:
            e = c.read(arr, n*5)
            for k in range(n):
                key, w1, w2, vp, w4 = e[k*5:k*5+5]; t = (key >> 2) & 15; cnt = (w2 >> 16) & 0xFFFF
                if t in (6, 7, 8) and 0 < cnt < 600 and 0x08800000 <= (vp & 0x0FFFFFFF) < 0x0A000000:
                    st = stride[t]; d = c.request('memory.read', {'address': vp & 0x0FFFFFFF, 'size': cnt*st, 'replacements': False})
                    raw = base64.b64decode(d['base64'])
                    pos = [struct.unpack_from('<3f', raw, v*st+st-12) for v in range(cnt)]
                    cx = [sum(p[i] for p in pos)/cnt for i in range(3)]
                    ents.append({'key': key, 'type': t, 'count': cnt, 'centroid': cx})
        rows.append({'tick': s['ticks'], 'entries': ents})
        c.request('cpu.resume', no_reply=True, delay_ms=20); time.sleep(0.05)
finally:
    c.request('cpu.breakpoint.remove', {'address': bp})
    if c.request('cpu.status').get('stepping'): c.request('cpu.resume', no_reply=True, delay_ms=50)
a.out.write_text(json.dumps(rows)); print('stops', len(rows), 'with world particles', sum(1 for r in rows if r['entries']))
