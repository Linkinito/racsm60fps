#!/usr/bin/env python3
"""Ryno fire-gate trace (read-only, live PPSSPP debugger, throttled polling).

Arms on the first Ryno ammo decrement (stock module+0x2AEEC4), then samples every --interval s:
ammo, Ryno moby (player 0x337940 +0x59C) refire counter +0x70 (24.0 on fire, -1.0 per Ryno_Update call),
state byte +0x45, pvar (moby+0x58) state +0x4 (3 = firing animation), player fire bits 0x95C, pad
0xD4, player states +0xF8/+0xFA, timer +0x138, +0xE38, anims +0x370/+0x37C and the main frame counter 0x2AF28C (to place samples on 30/60 Hz frames). Shows which gate is
still closed after the counter reaches 0 (Ryno cadence residual, session 2026-10-02b).
Writes nothing to the emulator. Output: <out>/ryno-probe.json.

Usage: python tools/runtime/ryno-probe.py --seconds 4 --label A0 --out <dir>
"""
import argparse, importlib.util, json, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
PLAYER, AMMO, FRAMES = 0x337940, 0x2AEEC4, 0x2AF28C


def f32(w): return round(struct.unpack('<f', struct.pack('<I', w))[0], 4)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--seconds', type=float, default=4.0); ap.add_argument('--arm', type=float, default=90.0)
    ap.add_argument('--interval', type=float, default=0.008)
    ap.add_argument('--weapon', type=int, default=15, help='weapon id for the ammo stock (lite mode works for any weapon)')
    ap.add_argument('--lite', action='store_true', help='frame counter + ammo only (2 reads per sample, no slowdown)')
    ap.add_argument('--label', required=True); ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args(); a.out.mkdir(parents=True, exist_ok=False)
    c = pg.Client('127.0.0.1', a.port); c.connect(); rows = []
    try:
        game = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive') and m['name'] == 'rcp1']
        if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise SystemExit('LEVEL_01 not resident')
        base = game[0]['address']; pl = base + PLAYER
        global AMMO
        AMMO = 0x2AE95C + a.weapon * 0x58 + 0x40
        moby = c.read(pl + 0x59C, 1)[0]; pv = c.read(moby + 0x58, 1)[0]
        last = c.read(base + AMMO, 1)[0]; ta = time.perf_counter()
        print('Waiting for the first Ryno shot...', flush=True)
        while True:
            v = c.read(base + AMMO, 1)[0]
            if v < last: break
            last = v
            if time.perf_counter() - ta > a.arm: raise SystemExit('no shot')
            time.sleep(0.05)
        tick0 = c.request('cpu.status')['ticks']; t0 = time.perf_counter()
        while time.perf_counter() - t0 < a.seconds:
            t = time.perf_counter() - t0
            if a.lite:
                rows.append({'t': round(t, 4), 'frame': c.read(base + FRAMES, 1)[0], 'ammo': c.read(base + AMMO, 1)[0]})
                time.sleep(a.interval); continue
            m = c.read(moby + 0x44, 12)        # +0x44..+0x73
            rows.append({'t': round(t, 4), 'frame': c.read(base + FRAMES, 1)[0], 'ammo': c.read(base + AMMO, 1)[0],
                         'refire': f32(m[0x2C//4]), 'state45': (m[0] >> 8) & 0xFF, 'pstate': c.read(pv + 4, 1)[0],
                         'fire20': (c.read(pl + 0x95C, 1)[0] >> 5) & 1, 'pad2000': (c.read(pl + 0xD4, 1)[0] >> 13) & 1,
                         'pstateF8': c.read(pl + 0xF8, 1)[0] & 0xFFFF, 'pstateFA': c.read(pl + 0xF8, 1)[0] >> 16,
                         't138': f32(c.read(pl + 0x138, 1)[0]), 'e38': c.read(pl + 0xE38, 1)[0],
                         'anim370': c.read(pl + 0x370, 1)[0], 'anim37c': c.read(pl + 0x37C, 1)[0]})
            time.sleep(a.interval)
        emu = round((c.request('cpu.status')['ticks'] - tick0) / (time.perf_counter() - t0) / 222e6, 3)
    finally:
        c.close()
    shots = [(p['frame'] + q['frame']) / 2 for p, q in zip(rows, rows[1:]) if q['ammo'] < p['ammo']]
    per = [round(y - x, 1) for x, y in zip(shots, shots[1:])]
    rec = {'label': a.label, 'shotFrames': shots, 'periodsFrames': per,
           'meanPeriodFrames': round((shots[-1] - shots[0]) / (len(shots) - 1), 3) if len(shots) > 1 else None, 'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'emuSpeed': emu,
           'samples': len(rows), 'status': 'TESTED trace; non-atomic sequential reads', 'rows': rows}
    (a.out/'ryno-probe.json').write_text(json.dumps(rec, indent=1), encoding='utf-8', newline='\n')
    print(json.dumps({'label': a.label, 'samples': len(rows), 'emuSpeed': emu, 'shots': len(shots), 'meanPeriodFrames': rec['meanPeriodFrames'], 'periodsFrames': per}))


if __name__ == '__main__':
    main()
