#!/usr/bin/env python3
"""Owner-assisted bisect of RI hooks: cycles runtime switches while fire is held, announcing each step by N beeps.

Steps (mask bits of `render-interp.py off`; mode 1 base): 1 all hooks on; 2 particle gating off; 3 deferred list +
pump-1 entry replay off; 4 fog + light gates off; 5 every hook off (pump 1 gating only); 6 mode 0 (no gating, control).
Fire is held with input.buttons.send circle (circle = fire, observed 2026-11-09). Restores mode 2 / mask 0 at the end.
Usage: python tools/runtime/bisect-cycle.py --seconds 20 --lead 10
"""
import argparse, importlib.util, json, subprocess, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pg', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
ap = argparse.ArgumentParser(); ap.add_argument('--seconds', type=float, default=20); ap.add_argument('--lead', type=float, default=10)
a = ap.parse_args()
c = pg.Client('127.0.0.1', 60907); c.connect()
st = int(json.loads((REPO/'tmp/render-interp-last.json').read_text())['st'], 16)
names = ['square', 'triangle', 'circle', 'cross', 'rtrigger', 'ltrigger', 'start', 'select', 'up', 'down', 'left', 'right']
def beeps(n):
    subprocess.run(['powershell', '-NoProfile', '-Command', '1..%d | ForEach-Object { [System.Media.SystemSounds]::Exclamation.Play(); Start-Sleep -Milliseconds 450 }' % n], capture_output=True)
steps = [(1, 1, 0), (2, 1, 16), (3, 1, 12), (4, 1, 3), (5, 1, 127), (6, 0, 0)]
log = []
def refill(tag):
    subprocess.run(['python', str(REPO/'tools/runtime/set-ammo.py'), '--equipped', '--value', '10000', '--out', str(REPO/'tmp'/('set-ammo-cycle-%s-%d' % (tag, int(time.time()*1000))))], capture_output=True)
try:
    refill(0); time.sleep(a.lead)
    c.raw_request({'event': 'input.buttons.send', 'buttons': {'circle': True}})
    for n, mode, mask in steps:
        refill(n)
        c.write(st, mode); c.write(st+26*4, mask)
        log.append({'step': n, 'mode': mode, 'mask': mask, 't': time.strftime('%H:%M:%S')})
        beeps(n); time.sleep(a.seconds)
finally:
    c.raw_request({'event': 'input.buttons.send', 'buttons': {x: False for x in names}})
    c.write(st, 2); c.write(st+26*4, 0)
print(json.dumps(log)); beeps(1)
