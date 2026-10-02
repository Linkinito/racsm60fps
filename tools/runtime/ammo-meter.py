#!/usr/bin/env python3
"""Fire-rate meter from ammo decrements (read-only, live PPSSPP debugger).

Polls a weapon's ammo stock (int) and records every decrease with a wall-clock time while the owner
holds fire. Reports shots/s over the active window (first to last shot) and the gap distribution.
Blaster stock: LEVEL_01 module + 0x2AEA4C (entry +0x40 returned by 0x1F71C, found live 2026-10-02).
Other weapons: pass --offset (module-relative) once their entry is known. `infammo` must be OFF.
Writes nothing to the emulator. Output: <out>/ammo-meter.json.

Usage: python tools/runtime/ammo-meter.py --seconds 12 --label C1+weapondt --out measurements/<dir>
"""
import argparse, importlib.util, json, statistics, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
BLASTER_STOCK = 0x2AEA4C


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--seconds', type=float, default=12.0)
    ap.add_argument('--arm', type=float, default=60.0, help='max wait for the first shot')
    ap.add_argument('--offset', type=lambda s: int(s, 0), default=BLASTER_STOCK)
    ap.add_argument('--label', required=True, help='fix set under test, recorded verbatim')
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args()
    a.out.mkdir(parents=True, exist_ok=False)
    c = pg.Client('127.0.0.1', a.port); c.connect()
    try:
        if c.request('game.status').get('game', {}).get('id') != 'UCES00420': raise SystemExit('requires UCES00420')
        game = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive') and m['name'] == 'rcp1']
        if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise SystemExit('LEVEL_01 not resident')
        addr = game[0]['address'] + a.offset
        print('Waiting for the first shot (up to %.0f s), then %.0f s...' % (a.arm, a.seconds), flush=True)
        last = c.read(addr, 1)[0]; ta = time.perf_counter()
        while True:                                   # arm on the first decrement
            v = c.read(addr, 1)[0]
            if v < last: break
            last = v
            if time.perf_counter() - ta > a.arm: raise SystemExit('no shot within %.0f s' % a.arm)
        t0 = time.perf_counter(); shots, polls = [0.0] * (last - v), 0; last = v
        while time.perf_counter() - t0 < a.seconds:
            v = c.read(addr, 1)[0]; polls += 1
            if v < last: shots += [round(time.perf_counter() - t0, 4)] * (last - v)
            last = v
        dur = time.perf_counter() - t0
    finally:
        c.close()
    gaps = [round(b - x, 4) for x, b in zip(shots, shots[1:])]
    span = shots[-1] - shots[0] if len(shots) > 1 else 0.0
    rec = {'label': a.label, 'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'offset': hex(a.offset),
           'seconds': round(dur, 3), 'polls': polls, 'pollIntervalMs': round(1000 * dur / max(polls, 1), 2),
           'shots': len(shots), 'shotsPerSecond': round((len(shots) - 1) / span, 3) if span else None,
           'gapMedian': statistics.median(gaps) if gaps else None, 'gapMin': min(gaps, default=None),
           'gapMax': max(gaps, default=None), 'times': shots,
           'status': 'TESTED measurement; wall-clock polling resolution = pollIntervalMs'}
    (a.out/'ammo-meter.json').write_text(json.dumps(rec, indent=1), encoding='utf-8', newline='\n')
    print(json.dumps({k: rec[k] for k in ('label', 'shots', 'shotsPerSecond', 'gapMedian', 'pollIntervalMs')}))


if __name__ == '__main__':
    main()
