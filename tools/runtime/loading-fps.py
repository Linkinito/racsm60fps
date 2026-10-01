#!/usr/bin/env python3
"""EBOOT-driven screens (loading/transitions) 20 FPS -> 60 FPS probe, live experimental RAM.

Static basis (INFERRED, research/inbox/menus-debug-extras-static-20261001.md + dump scan):
the resident EBOOT frame loop (0x08807020, 5-state machine on u32 0x088410B0) is the only caller
of the EBOOT frame limiter 0x08806718 (call at 0x08807284). The limiter waits `interval` vblanks,
interval = float at 0x088410B8 = 3.0 (20 FPS); nothing writes it, and the per-frame delta
0x088410BC (0.05) is a stored value (0x088072AC computes interval/60 but is not called per frame: OBSERVED live). The 20-frame fade counter limit is
the literal at 0x08807230 (ori s2,zero,20). Gameplay levels have their own limiter (LEVEL PRX).
UNKNOWN: which EBOOT state is the loading screen; spinner / other per-frame counters.

Modes: status | on | off | watch (poll state/counters, no writes; use while a level loads).
`on` writes interval 1.0, delta 1/60, fade limit 60 and removes the extra vblank wait at 0x0880727C (interval 1.0
alone gave 30 FPS: loop waits 1 + limiter entry wait 1); `off` restores 3.0 and 20. Every word is checked
against its original/patched value first; CPU paused only during writes; JSON record written.
Usage: python tools/runtime/loading-fps.py --mode on|off|status|watch --out <new dir> [--seconds 60]
"""
import argparse, hashlib, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)

# address: (original, patched)
WORDS = {0x088410B8: (0x40400000, 0x3F800000),   # interval float 3.0 -> 1.0 vblanks per frame
         0x08807230: (0x34120014, 0x3412003C),   # ori s2,zero,20 -> 60 (fade keeps 1 s)
         # jal vblank wait before the limiter -> nop. The limiter itself waits one vblank on entry, so
         # with this wait kept the floor is 2 vblanks (30 FPS) whatever the interval (OBSERVED live 2026-10-01).
         0x0880727C: (0x0E20F09A, 0x00000000),
         # frame delta in seconds, handed to every state handler. NOT recomputed per frame (OBSERVED live:
         # stayed 0.05 with interval 1.0 and made loading animations 3x too fast): 0.05 -> 1/60
         0x088410BC: (0x3D4CCCCE, 0x3C888889)}
# Optional per-screen groups (static candidates from research/inbox/eboot-loading-anim-static-20261001.md,
# INFERRED): per-frame values written for 20 FPS (3x too fast at 60). Select with --group ribbon,s4,s0,s2.
_L, _D, _E = (0x41600000, 0x42280000), (0x3FE00000, 0x3F155555), (0x40A00000, 0x3FD55555)   # life x3, drift /3, emission /3
GROUPS = {'ribbon': {0x0884E964: (0x3E94EF4D, 0x3DC6945D)},                                 # state-3 ribbon spin step /3
          's4': {0x0884EA2C: _L, 0x0884EA34: _D, 0x0884E9F4: _E},
          's0': {0x0884EAB8: _L, 0x0884EAC0: _D, 0x0884EA80: _E},
          's2': {0x0884E884: ((0x41200000, 0x41F00000)), 0x0884E88C: _D, 0x0884E84C: _E}}
WATCH = {'state': 0x088410B0, 'interval': 0x088410B8, 'delta': 0x088410BC, 'spin': 0x088410C4, 'fade': 0x08841114}

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--mode', required=True, choices=('status', 'on', 'off', 'watch'))
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--seconds', type=float, default=60)
    ap.add_argument('--group', default='', help='optional extra groups: '+','.join(GROUPS))
    a = ap.parse_args()
    words = dict(WORDS)
    for g in [x for x in a.group.split(',') if x]:
        if g not in GROUPS: ap.error('unknown group '+g)
        words.update(GROUPS[g])
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'mode': a.mode, 'writes': 0,
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    c = pg.Client('127.0.0.1', a.port); c.connect(); paused = False
    try:
        if c.request('game.status').get('game', {}).get('id') != 'UCES00420': raise RuntimeError('requires UCES00420')
        cur = {k: c.read(k, 1)[0] for k in words}
        st = {k: 'off' if cur[k] == o else 'on' if cur[k] == n else 'OTHER' for k, (o, n) in words.items()}
        rec['before'] = {hex(k): v for k, v in st.items()}
        if 'OTHER' in st.values(): raise RuntimeError('unexpected EBOOT words %r (wrong state/version?)' % (rec['before'],))
        if a.mode == 'status': rec['result'] = 'OBSERVED'
        elif a.mode == 'watch':
            last, log, end = None, [], time.monotonic()+a.seconds
            while time.monotonic() < end:
                v = {n: c.read(ad, 1)[0] for n, ad in WATCH.items()}
                key = (v['state'], v['interval'], v['fade'] == 0)
                if key != last: log.append({'t': round(time.monotonic()-end+a.seconds, 2), **{n: hex(x) for n, x in v.items()}}); last = key
                time.sleep(0.05)
            rec['changes'] = log; rec['result'] = 'OBSERVED'
        else:
            cpu = c.request('cpu.status')
            if cpu.get('paused') or cpu.get('stepping'): raise RuntimeError('CPU must be running')
            c.request('cpu.stepping'); paused = True
            for k, (o, n) in words.items():
                want = n if a.mode == 'on' else o
                if c.read(k, 1)[0] != want: c.write(k, want); rec['writes'] += 1
            c.request('cpu.resume'); paused = False
            rec['after'] = {hex(k): ('on' if c.read(k, 1)[0] == n else 'off') for k, (o, n) in words.items()}
            rec['result'] = 'APPLIED_NOT_VALIDATED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
    finally:
        if paused:
            try: c.request('cpu.resume')
            except Exception as e: rec['resumeError'] = str(e)
        c.close(); a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

if __name__ == '__main__':
    r = main(); print(json.dumps(r))
    raise SystemExit(0 if r['result'] in ('OBSERVED', 'APPLIED_NOT_VALIDATED') else 2)
