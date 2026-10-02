#!/usr/bin/env python3
"""Blaster fire-gate trace (read-only, live PPSSPP debugger, throttled polling).

Arms on the first ammo decrement, then samples every --interval s for --seconds: ammo stock
(module+0x2AEA4C), equipped weapon moby (player 0x337940 +0x59C) state byte +0x45, pvar (moby+0x58)
refire cooldown +0x4, state +0x8, hold timer +0xB4, flag +0xB9, countdown +0xBC, player fire bits
0x95C, pad 0xD4, gun-pose countdowns +0x9D4/+0x9D8 and frame scale +0x578. Shows which gate is closed
when a shot is refused (report F5 of research/v2/call-context-20261002/REPORT.md).
Writes nothing to the emulator. Output: <out>/blaster-probe.json.

Usage: python tools/runtime/blaster-probe.py --seconds 4 --label C1 --out <dir>
"""
import argparse, importlib.util, json, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
PLAYER, AMMO = 0x337940, 0x2AEA4C


def f32(w): return round(struct.unpack('<f', struct.pack('<I', w))[0], 4)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--seconds', type=float, default=4.0); ap.add_argument('--arm', type=float, default=90.0)
    ap.add_argument('--interval', type=float, default=0.015)
    ap.add_argument('--label', required=True); ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args(); a.out.mkdir(parents=True, exist_ok=False)
    c = pg.Client('127.0.0.1', a.port); c.connect(); rows = []
    try:
        game = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive') and m['name'] == 'rcp1']
        if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise SystemExit('LEVEL_01 not resident')
        base = game[0]['address']; pl = base + PLAYER
        moby = c.read(pl + 0x59C, 1)[0]; pv = c.read(moby + 0x58, 1)[0]
        last = c.read(base + AMMO, 1)[0]; ta = time.perf_counter()
        print('Waiting for the first shot...', flush=True)
        while True:
            v = c.read(base + AMMO, 1)[0]
            if v < last: break
            last = v
            if time.perf_counter() - ta > a.arm: raise SystemExit('no shot')
            time.sleep(0.05)
        tick0 = c.request('cpu.status')['ticks']; t0 = time.perf_counter()
        while time.perf_counter() - t0 < a.seconds:
            t = time.perf_counter() - t0
            p = c.read(pv, 0x30); s45 = (c.read(moby + 0x44, 1)[0] >> 8) & 0xFF
            plw = c.read(pl + 0x9D4, 2); fs = c.read(pl + 0x578, 1)[0]
            rows.append({'t': round(t, 4), 'ammo': c.read(base + AMMO, 1)[0], 'state45': s45,
                         'cooldown': f32(p[1]), 'pstate': p[2], 'hold': f32(p[0x2D]),
                         'b9': (p[0x2E] >> 8) & 0xFF, 'bc': f32(p[0x2F]),
                         'fire95c': c.read(pl + 0x95C, 1)[0], 'padD4': c.read(pl + 0xD4, 1)[0],
                         'pose9d4': f32(plw[0]), 'pose9d8': f32(plw[1]), 'scale578': f32(fs)})
            time.sleep(a.interval)
        emu = round((c.request('cpu.status')['ticks'] - tick0) / (time.perf_counter() - t0) / 222e6, 3)
    finally:
        c.close()
    rec = {'label': a.label, 'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'emuSpeed': emu,
           'samples': len(rows), 'status': 'TESTED trace; non-atomic sequential reads', 'rows': rows}
    (a.out/'blaster-probe.json').write_text(json.dumps(rec, indent=1), encoding='utf-8', newline='\n')
    print(json.dumps({'label': a.label, 'samples': len(rows), 'emuSpeed': emu}))


if __name__ == '__main__':
    main()
