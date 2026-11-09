#!/usr/bin/env python3
"""Find words of the LEVEL_01 .data/.bss that differ systematically between update and skipped frames.

Needs RI applied (mode >= 1). One temporary breakpoint at ri_frame (start of each frame); at each stop the
region [START, END) is read, the phase word ri_st[1] recorded, the game resumed. Read-only apart from the
breakpoint. Output JSON: words that were constant X on every update-frame snapshot and constant Y on every
skipped-frame snapshot with X != Y (RVA, X, Y).
Usage: python tools/runtime/parity-diff.py --frames 16 --out <new>.json
"""
import argparse, base64, importlib.util, json, struct, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pg', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
START, END = 0x2A0000, 0x46B830
ap = argparse.ArgumentParser(); ap.add_argument('--frames', type=int, default=16); ap.add_argument('--out', type=Path, required=True)
a = ap.parse_args()
if a.out.exists(): raise SystemExit('refusing to overwrite')
last = json.loads((REPO/'tmp/render-interp-last.json').read_text())
c = pg.Client('127.0.0.1', 60907); c.connect()
base = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'rcp1'][0]['address']
if hex(base) != last['base']: raise SystemExit('base changed')
info = json.loads((REPO/'tmp/render-interp-build/ri.json').read_text())
bp = int(info['symbols']['ri_frame'], 16); st = int(last['st'], 16)
def readblock(addr, n):
    out = bytearray()
    for off in range(0, n, 0x20000):
        k = min(0x20000, n-off)
        r = c.request('memory.read', {'address': addr+off, 'size': k, 'replacements': False})
        out += base64.b64decode(r['base64'])
    return bytes(out)
snaps = []
c.request('cpu.breakpoint.add', {'address': bp, 'enabled': True, 'log': False})
try:
    while len(snaps) < a.frames:
        s = c.request('cpu.status')
        if not s.get('stepping'): time.sleep(0.01); continue
        phase = c.read(st+4, 1)[0]; data = readblock(base+START, END-START)
        snaps.append((phase, data))
        c.request('cpu.resume', no_reply=True, delay_ms=30); time.sleep(0.1)
finally:
    c.request('cpu.breakpoint.remove', {'address': bp})
    if c.request('cpu.status').get('stepping'): c.request('cpu.resume', no_reply=True, delay_ms=50)
n = (END-START)//4
W = [struct.unpack('<%dI' % n, d) for _, d in snaps]
ph = [p for p, _ in snaps]
U = [w for w, p in zip(W, ph) if p == 1]; S = [w for w, p in zip(W, ph) if p == 0]
res = []
for i in range(n):
    u = {w[i] for w in U}; s = {w[i] for w in S}
    if len(u) == 1 and len(s) == 1 and u != s: res.append((hex(START+4*i), hex(next(iter(u))), hex(next(iter(s)))))
a.out.write_text(json.dumps({'update_snaps': len(U), 'skipped_snaps': len(S), 'words': res}))
print('snaps', len(snaps), 'update', len(U), 'skipped', len(S), 'parity words', len(res))
