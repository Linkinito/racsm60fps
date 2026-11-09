#!/usr/bin/env python3
"""One command to (re)enable or disable the RI hybrid patch after loading a savestate.

  python tools/runtime/ri-hybrid.py on        apply RI (mode 2) + 60 Hz classes (BlasterShot, RynoRocket, ShockRocketShot) + their words + ammo
  python tools/runtime/ri-hybrid.py mode0     60 Hz without gating (keeps the 60 Hz projectile words)
  python tools/runtime/ri-hybrid.py mode2     hybrid again
  python tools/runtime/ri-hybrid.py off       back to the original 30 fps state (remove)
Loading a savestate that was saved without the patch removes it (words are A0 again): run `on` again.
If a previous run left stray words in the cave while every hook site is original, they are cleared first.
"""
import importlib.util, subprocess, sys, shutil, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
RI = [sys.executable, str(REPO/'tools/runtime/render-interp.py')]
def ri(*a): 
    r = subprocess.run(RI + list(a), capture_output=True, text=True); print((r.stdout or r.stderr).strip().splitlines()[-1][:220] if (r.stdout or r.stderr).strip() else ''); return r.returncode
cmd = sys.argv[1] if len(sys.argv) > 1 else 'on'
if cmd == 'on':
    spec = importlib.util.spec_from_file_location('pg', REPO/'tools/runtime/pump-gate.py'); pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
    c = pg.Client('127.0.0.1', 60907); c.connect()
    base = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'rcp1'][0]['address']
    if c.read(base+0x15230, 1)[0] == pg.jal(base+pg.PUMP1):       # hooks absent: clear stray cave words
        for lo, hi in ((0x2C1818, 0x2C281C), (0x2B7700, 0x2B9000)):
            for i in range(0, (hi-lo)//4):
                if c.read(base+lo+4*i, 1)[0]: c.write(base+lo+4*i, 0)
    shutil.rmtree(REPO/'tmp/render-interp-build', ignore_errors=True)
    (REPO/'tmp/render-interp-last.json').unlink(missing_ok=True)
    if ri('apply', '--mode', '2'): sys.exit(1)
    ri('cls', '--rvas', '0x118130,0x169698,0x170B20'); ri('bshot', '1'); ri('ryno', '1'); ri('shock', '1'); ri('xfade', '0')
    subprocess.run([sys.executable, str(REPO/'tools/runtime/set-ammo.py'), '--weapons', '2,15', '--value', '10000', '--out', str(REPO/'tmp'/('set-ammo-%d' % int(time.time())))], capture_output=True)
elif cmd in ('mode0', 'mode2'): ri('mode', cmd[-1])
elif cmd == 'off': ri('remove')
elif cmd in ('xfade0', 'xfade1'): ri('xfade', cmd[-1])
else: sys.exit('usage: ri-hybrid.py on|mode0|mode2|off')
