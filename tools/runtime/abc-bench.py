#!/usr/bin/env python3
"""A/B/C bench step: fresh PPSSPP from a savestate, then sample float fields.

Launches PPSSPP with --state=<slot file> (fresh process, closes any running one),
waits for the debugger, then reads a float vector at ADDR every INTERVAL ms for
DURATION s, logging PPSSPP ticks per sample (emulated clock). Read-only except optional input
timeline (--inputs). Runs are comparable by ticks, not by sample index.

Usage:
  python tools/runtime/abc-bench.py --slot 0 --addr 0x96f5320 --count 3 \
      --duration 10 --out <new dir>/run1.csv
"""
import argparse, csv, importlib.util, json, struct, subprocess, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)

EXE = r'C:\Program Files\PPSSPP\PPSSPPWindows64.exe'
ISO = REPO/'02-Jeu-et-dumps/Ratchet & Clank - Size Matters (Europe) (PSN).iso'
STATES = Path.home()/'Documents/PPSSPP/PSP/PPSSPP_STATE'
TICK_HZ = 222222222  # established calibration, derived only


def launch(slot):
    subprocess.run(['taskkill', '/F', '/IM', 'PPSSPPWindows64.exe'], capture_output=True)
    time.sleep(2)
    st = STATES/('UCES00420_1.00_%d.ppst' % slot)
    if not st.exists(): raise SystemExit('missing savestate %s' % st)
    cmd = '"%s" --state="%s" "%s"' % (EXE, st, ISO)
    return subprocess.Popen(cmd)


def connect(port, timeout=90):
    end = time.monotonic()+timeout
    while time.monotonic() < end:
        try:
            c = pg.Client('127.0.0.1', port); c.connect()
            if c.request('game.status').get('game'): return c
        except Exception:
            pass
        time.sleep(1)
    raise SystemExit('debugger/game not ready')


OC_CTL_OFF = 0x3780   # oc_ctl in OC60-M2-v8 patch.elf; [30]=1 means fixes active (C), [31]=request


def set_arm(c, want):
    mod = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'Overcompensated60']
    if len(mod) != 1: raise SystemExit('plugin Overcompensated60 not resident')
    ctl = mod[0]['address']+OC_CTL_OFF
    cur = lambda: 'C' if c.read(ctl+30*4, 1)[0] == 1 else 'A'
    before = cur()
    if before != want:
        c.write(ctl+31*4, 1)
        for _ in range(60):
            time.sleep(0.05)
            if cur() == want: break
    after = cur()
    print('arm', before, '->', after)
    if after != want: raise SystemExit('toggle did not reach %s' % want)
    return {'before': before, 'after': after, 'ctl': hex(ctl)}


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--slot', type=int, required=True)
    ap.add_argument('--addr', type=lambda x: int(x, 0), required=True)
    ap.add_argument('--count', type=int, default=3)
    ap.add_argument('--duration', type=float, default=10)
    ap.add_argument('--interval-ms', type=int, default=50)
    ap.add_argument('--settle', type=float, default=3, help='seconds after game is up')
    ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--inputs', type=Path, help='JSON timeline: [{"t": emu_s, "stick": [x, y], "buttons": {"cross": true}}]')
    ap.add_argument('--arm', choices=('A', 'C'), help='force plugin state via oc_ctl[31] request before sampling')
    ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args()
    if a.out.exists(): raise SystemExit('refusing to overwrite %s' % a.out)
    a.out.parent.mkdir(parents=True, exist_ok=True)
    for attempt in range(3):  # a second launch sometimes stays at the menu (OBSERVED 2026-11-09)
        launch(a.slot)
        try: c = connect(a.port, timeout=40); break
        except SystemExit: print('relaunch', attempt+1)
    else: raise SystemExit('PPSSPP never reached the game')
    time.sleep(a.settle)
    arm_log = None
    if a.arm: arm_log = set_arm(c, a.arm)
    rows = []; t_end = time.monotonic()+a.duration
    timeline = json.loads(a.inputs.read_text()) if a.inputs else []
    timeline.sort(key=lambda e: e['t']); sent = []; t0 = None
    while time.monotonic() < t_end:
        ticks = c.request('cpu.status').get('ticks')
        if t0 is None: t0 = ticks
        while timeline and (ticks-t0)/TICK_HZ >= timeline[0]['t']:
            e = timeline.pop(0)
            if 'stick' in e: c.raw_request({'event': 'input.analog.send', 'x': e['stick'][0], 'y': e['stick'][1]})
            if 'buttons' in e: c.raw_request({'event': 'input.buttons.send', 'buttons': e['buttons']})
            sent.append({'planned_t': e['t'], 'actual_t': (ticks-t0)/TICK_HZ, 'event': e})
        words = c.read(a.addr, a.count)
        vals = [struct.unpack('<f', struct.pack('<I', w))[0] for w in words]
        rows.append([time.monotonic(), ticks] + vals)
        time.sleep(a.interval_ms/1000)
    with a.out.open('w', newline='') as f:
        w = csv.writer(f); w.writerow(['mono_s', 'ticks'] + ['f%d' % i for i in range(a.count)]); w.writerows(rows)
    if a.inputs:
        # release everything so the emulator is left neutral
        c.raw_request({'event': 'input.analog.send', 'x': 0, 'y': 0}); c.raw_request({'event': 'input.buttons.send', 'buttons': {}})
        a.out.with_suffix('.inputs.json').write_text(json.dumps(sent, indent=1))
    print('samples', len(rows), 'ticks', rows[0][1], '->', rows[-1][1], 'emu_s', (rows[-1][1]-rows[0][1])/TICK_HZ)


if __name__ == '__main__':
    main()
