#!/usr/bin/env python3
"""Shock-wave / ray lifecycle statistics per record (read-only except optional fire-button injection).

Follows every record of a pump-1 class (default BlitzGunShot 0x11C1E8, Tremblator shock wave) and, per
life, records the frame (LEVEL_01 frame counter 0x2AF28C) at which its segmented-ray state (pv+0x24
ray state, phase byte pv+0x54) reaches phase 3 and the frame at which the record's live flag drops.
A0 reference 2026-10-02b: phase 3 at 13 frames, dead at 14 (30 Hz) -> 26 / 28 at 60 Hz.
--autofire N presses the fire button (circle, PPSSPP input.buttons.press) every N seconds so the owner
only positions and aims. Output: <out>/ray-stats.json.

Usage: python tools/runtime/ray-stats.py --seconds 30 --autofire 2 --label C1+... --out <dir>
"""
import argparse, importlib.util, json, time
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--seconds', type=float, default=30.0); ap.add_argument('--autofire', type=float, default=0.0)
    ap.add_argument('--update', type=lambda v: int(v, 0), default=0x11C1E8)
    ap.add_argument('--label', required=True); ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args(); a.out.mkdir(parents=True, exist_ok=False)
    c = pg.Client('127.0.0.1', a.port); c.connect()
    lives, cur, recs, cap = [], {}, None, 0
    try:
        base = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive') and m['name'] == 'rcp1'][0]['address']
        mods = {m['name']: m['address'] for m in c.request('hle.module.list')['modules'] if m.get('isActive')}
        sym = json.loads((REPO/'patches/experimental/interp-gate/build/IG-v24/manifest.json').read_text(encoding='utf-8'))['symbols']
        chalf = mods.get('InterpGate', 0) + sym['ig_chalf']; wrap = mods.get('InterpGate', 0) + sym['ig_classhalf']
        mgr = c.read(base + 0x2CA0D0, 1)[0]; arr, n = c.read(mgr + 0x34, 2)
        for i in range(n):
            g = c.read(arr + i * 0x50, 20); ga = arr + i * 0x50
            redirected = g[7] == wrap and ga in c.read(chalf + 8, 8)[0::2]   # blitzhalf: group pointer -> ig_classhalf
            if g[7] - base == a.update or (redirected and c.read(chalf + 8, 8)[c.read(chalf + 8, 8)[0::2].index(ga) * 2 + 1] - base == a.update):
                recs, cap = g[3], min(g[15], 16)
        if not recs: raise SystemExit('class group not found (fire once first)')
        t0 = time.perf_counter(); next_fire = 0.0; fr0 = c.read(base + 0x2AF28C, 1)[0]
        while time.perf_counter() - t0 < a.seconds:
            t = time.perf_counter() - t0
            if a.autofire and t >= next_fire:
                c.raw_request({'event': 'input.buttons.press', 'button': 'circle', 'duration': 6}); next_fire = t + a.autofire
            fr = c.read(base + 0x2AF28C, 1)[0]; w = c.read(recs, cap * 32)
            for k in range(cap):
                if w[k * 32 + 25] & 1:
                    if k not in cur: cur[k] = {'f0': fr, 'p3': None}
                    if cur[k]['p3'] is None and fr - cur[k]['f0'] > 2 and (c.read(w[k * 32 + 22] + 0x54, 1)[0] & 0xFF) == 3:
                        cur[k]['p3'] = fr - cur[k]['f0']
                elif k in cur:
                    l = cur.pop(k); l['dead'] = fr - l['f0']; lives.append(l)
            time.sleep(0.007)
        fps = (c.read(base + 0x2AF28C, 1)[0] - fr0) / (time.perf_counter() - t0)
    finally:
        c.close()
    p3 = [l['p3'] for l in lives if l['p3']]; dd = [l['dead'] for l in lives]
    rec = {'label': a.label, 'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'lives': len(lives),
           'phase3': dict(Counter(p3)), 'dead': dict(Counter(dd)),
           'meanPhase3': round(sum(p3) / len(p3), 2) if p3 else None, 'meanDead': round(sum(dd) / len(dd), 2) if dd else None,
           'gameFps': round(fps, 1), 'valid': 55.0 <= fps <= 62.0 or 27.0 <= fps <= 31.0,
           'status': 'TESTED; frame counter sampled every ~7 ms (non-atomic reads); invalid if game fps unstable (PPSSPP in background)'}
    (a.out/'ray-stats.json').write_text(json.dumps(rec, indent=1), encoding='utf-8', newline='\n')
    print(json.dumps(rec))


if __name__ == '__main__':
    main()
