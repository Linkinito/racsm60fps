#!/usr/bin/env python3
"""Find draw entries with a 30 fps look, for every vertex type: right after the flush call (0x15358) read all direct draw
entries (array 0x302F1C, last-entry pointer 0x2DD330), hash each entry's raw vertex bytes, and per (key, type) report the
share of consecutive frames with identical vertex data (a strict 0/1 alternation of the identical share = 30 fps look) plus
the entry count, stride and how often it appears. Fire is held with `circle` only with --fire.
Usage: python tools/runtime/draw-who.py --stops 240 [--fire]
"""
import argparse, base64, collections, hashlib, importlib.util, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pg', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
ap = argparse.ArgumentParser(); ap.add_argument('--stops', type=int, default=240); ap.add_argument('--fire', action='store_true')
a = ap.parse_args()
c = pg.Client('127.0.0.1', 60907); c.connect()
base = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'rcp1'][0]['address']
stride = [c.read(base+0x2B66B0+4*i, 1)[0] for i in range(16)]
names = ['square', 'triangle', 'circle', 'cross', 'rtrigger', 'ltrigger', 'start', 'select', 'up', 'down', 'left', 'right']
if a.fire: c.raw_request({'event': 'input.buttons.send', 'buttons': {'circle': True}}); time.sleep(0.5)
bp = base+0x15358; frames = []
c.request('cpu.breakpoint.add', {'address': bp, 'enabled': True, 'log': False})
try:
    t0 = time.monotonic()
    while len(frames) < a.stops and time.monotonic()-t0 < 180:
        if not c.request('cpu.status').get('stepping'): time.sleep(0.005); continue
        arr = c.read(base+0x302F1C, 1)[0]; last = c.read(base+0x2DD330, 1)[0]
        n = (last-arr)//0x14+1 if last >= arr else 0; cur = {}
        if 0 < n <= 128:
            e = c.read(arr, n*5); seen = collections.Counter()
            for k in range(n):
                key, w1, w2, vp, w4 = e[k*5:k*5+5]; t = (key >> 2) & 15; cnt = (w2 >> 16) & 0xFFFF; st = stride[t]; m = vp & 0x0FFFFFFF
                if st and 0 < cnt < 800 and 0x08800000 <= m < 0x0A000000:
                    raw = base64.b64decode(c.request('memory.read', {'address': m, 'size': cnt*st, 'replacements': False})['base64'])
                    seen[(key, t)] += 1; cur[(key, t, seen[(key, t)])] = (cnt, st, hashlib.md5(raw).hexdigest())
        frames.append(cur)
        c.request('cpu.resume', no_reply=True, delay_ms=20); time.sleep(0.05)
finally:
    c.request('cpu.breakpoint.remove', {'address': bp})
    if c.request('cpu.status').get('stepping'): c.request('cpu.resume', no_reply=True, delay_ms=50)
    if a.fire: c.raw_request({'event': 'input.buttons.send', 'buttons': {x: False for x in names}})
by = collections.defaultdict(list)
for i, cur in enumerate(frames):
    for k, v in cur.items(): by[k].append((i, v))
rows = []
for k, v in by.items():
    same = [1 if (q[0] == p[0]+1 and q[1][2] == p[1][2]) else 0 for p, q in zip(v, v[1:]) if q[0] == p[0]+1]
    if len(same) < 12: continue
    alt = sum(1 for x, y in zip(same, same[1:]) if x != y)/max(len(same)-1, 1)
    rows.append((len(v), hex(k[0]), k[1], v[0][1][1], v[0][1][0], round(sum(same)/len(same), 2), round(alt, 2)))
print('frames', len(frames), '\nseen key type stride count identical-share alternation(1=strict 0/1)')
for r in sorted(rows, key=lambda r: -r[6]*r[0])[:16]: print(*r)
