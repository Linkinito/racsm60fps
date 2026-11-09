#!/usr/bin/env python3
"""Which draw entries look like 30 fps? Per frame (stop at the flush entry) log all direct draw entries with type, count, key,
whether the key belongs to the walker's captured entries (RI blob `wlist`), and for stride 20/24 the centroid of the last three
floats; then summarise per key: frames seen, share of frames with zero centroid movement, mean step, longest run of zero steps.
Usage: python tools/runtime/particle-who.py --stops 240 [--fire]
"""
import argparse, base64, collections, importlib.util, json, math, re, struct, subprocess, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pg', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
ap = argparse.ArgumentParser(); ap.add_argument('--stops', type=int, default=240); ap.add_argument('--fire', action='store_true')
a = ap.parse_args()
SDK = REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/toolchains/pspdev-win/bin/psp-nm.exe'
nm = subprocess.run([str(SDK), str(REPO/'tmp/render-interp-build/ri.elf')], capture_output=True, text=True).stdout
sym = {l.split()[2]: int(l.split()[0], 16) for l in nm.splitlines() if len(l.split()) == 3}
c = pg.Client('127.0.0.1', 60907); c.connect()
base = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'rcp1'][0]['address']
stride = [c.read(base+0x2B66B0+4*i, 1)[0] for i in range(16)]
names = ['square', 'triangle', 'circle', 'cross', 'rtrigger', 'ltrigger', 'start', 'select', 'up', 'down', 'left', 'right']
if a.fire: c.raw_request({'event': 'input.buttons.send', 'buttons': {'circle': True}}); time.sleep(0.5)
bp = base+0x15358; frames = []   # after the flush call: final entries, after RI mixing
c.request('cpu.breakpoint.add', {'address': bp, 'enabled': True, 'log': False})
try:
    t0 = time.monotonic()
    while len(frames) < a.stops and time.monotonic()-t0 < 150:
        if not c.request('cpu.status').get('stepping'): time.sleep(0.005); continue
        wc = min(c.read(sym['wcount'], 1)[0], 16); wl = c.read(sym['wlist'], 1)[0]
        wkeys = {c.read(wl+20*k, 1)[0] for k in range(wc)} if wc and 0x08800000 <= wl < 0x0A000000 else set()
        arr = c.read(base+0x302F1C, 1)[0]; last = c.read(base+0x2DD330, 1)[0]
        n = (last-arr)//0x14+1 if last >= arr else 0; ents = []
        if 0 < n <= 128:
            e = c.read(arr, n*5)
            for k in range(n):
                key, w1, w2, vp, w4 = e[k*5:k*5+5]; t = (key >> 2) & 15; cnt = (w2 >> 16) & 0xFFFF; st = stride[t]
                cen = None
                if st in (20, 24) and 0 < cnt < 600 and 0x08800000 <= (vp & 0x0FFFFFFF) < 0x0A000000:
                    raw = base64.b64decode(c.request('memory.read', {'address': vp & 0x0FFFFFFF, 'size': cnt*st, 'replacements': False})['base64'])
                    pos = [struct.unpack_from('<3f', raw, v*st+st-12) for v in range(cnt)]
                    cen = [sum(p[i] for p in pos)/cnt for i in range(3)]
                ents.append((key, t, cnt, key in wkeys, cen))
        frames.append(ents)
        c.request('cpu.resume', no_reply=True, delay_ms=20); time.sleep(0.05)
finally:
    c.request('cpu.breakpoint.remove', {'address': bp})
    if c.request('cpu.status').get('stepping'): c.request('cpu.resume', no_reply=True, delay_ms=50)
    if a.fire: c.raw_request({'event': 'input.buttons.send', 'buttons': {x: False for x in names}})
by = collections.defaultdict(list)
for i, ents in enumerate(frames):
    seen = collections.Counter()
    for key, t, cnt, w, cen in ents:
        seen[key] += 1
        if seen[key] == 1: by[key].append((i, t, cnt, w, cen))
print('frames', len(frames))
rows = []
for key, v in by.items():
    steps = [math.dist(p[4], q[4]) for p, q in zip(v, v[1:]) if q[0] == p[0]+1 and p[4] and q[4]]
    if len(steps) < 12: continue
    zero = sum(1 for s in steps if s < 1e-4)/len(steps); run = best = 0
    for s in steps:
        run = run+1 if s < 1e-4 else 0; best = max(best, run)
    rows.append((len(v), hex(key), v[0][1], any(x[3] for x in v), v[0][2], round(zero, 2), round(sum(steps)/len(steps), 3), best))
print('seen key type walker count zero-step-share mean-step longest-zero-run')
for r in sorted(rows, reverse=True)[:14]: print(*r)
