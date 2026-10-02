#!/usr/bin/env python3
"""Projectile lifetime and distance tracker (read-only, live PPSSPP debugger).

Follows every live record of one pump-1 class (default BlasterShot) through the entity manager
(0x2CA0D0: groups of 0x50 bytes, records of 0x80 bytes, live flag +0x64 bit 0; same walk as
fix-monitor.py). For each life of a record it logs wall-clock lifetime, the entity age counter +0x70
at first/last sight (projectiles add 1.0 per update: lifetime in update calls, see age70), start/end
position (+0x30..+0x38), straight-line distance, path length and mean speed.
A life starts when the live flag rises or +0x70 drops; it ends when the flag falls.
Also counts ammo decrements (--ammo-offset, Blaster stock module+0x2AEA4C) in the same poll: one debugger
connection only (two concurrent clients starved each other and stalled the game, 2026-10-02).
Polling is throttled (--interval, default 50 ms): back-to-back memory reads froze emulation. The emulated
CPU tick rate during the run is recorded (emuSpeed = ticks/s / 222 MHz; must stay ~1.0).
Writes nothing to the emulator. Output: <out>/projectiles.json.

Usage: python tools/runtime/projectile-tracker.py --class BlasterShot --seconds 12 --label A0 --out <dir>
"""
import argparse, importlib.util, json, math, statistics, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
MANAGER, GROUP_STRIDE, RECORD = 0x2CA0D0, 0x50, 0x80
# weapon id -> projectile class (static: ammo lookups FUN_0001F71C(id) per class, 2026-10-02b; INFERRED)
WEAPONS = {2: 'BlasterShot', 3: 'BlitzGunShot', 4: 'Acidbomb', 5: 'AgentOfDoom', 6: 'BeeMine', 7: 'ShieldChargerBolt',
           8: 'ShockRocketShot', 9: 'CrossbowShot', 10: 'NapalmBubble', 11: None, 12: 'SuckCannonComet', 13: None, 15: 'RynoRocket'}
def ammo_offset(wid): return 0x2AE95C + wid * 0x58 + 0x40   # entry (id + player+0xF0 + 1) with +0xF0 = -1


def f32(w): return struct.unpack('<f', struct.pack('<I', w))[0]


def find_group(c, base, update_rva):
    mgr = c.read(base+MANAGER, 1)[0]; arr, n = c.read(mgr+0x34, 2)
    for i in range(min(n, 256)):
        g = c.read(arr+i*GROUP_STRIDE, 20)
        if g[7] - base == update_rva: return g[3], min(g[15], 256)
    return None, 0


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--class', dest='cls', default=None)
    ap.add_argument('--weapon', type=int, default=None, help='weapon id: sets ammo offset and default class')
    ap.add_argument('--seconds', type=float, default=12.0)
    ap.add_argument('--arm', type=float, default=60.0, help='max wait for the first projectile')
    ap.add_argument('--interval', type=float, default=0.05, help='seconds between polls')
    ap.add_argument('--ammo-offset', type=lambda v: int(v, 0), default=0x2AEA4C)
    ap.add_argument('--label', required=True, help='fix set under test, recorded verbatim')
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args()
    if a.weapon is not None:
        a.ammo_offset = ammo_offset(a.weapon)
        if a.cls is None: a.cls = WEAPONS.get(a.weapon)
    if a.cls is None: a.cls = 'BlasterShot'
    table = json.loads((REPO/'research/v2/decomp-summary/level01-class-updates.json').read_text(encoding='utf-8'))['classes']
    upd = {t['class']: int(t['update'], 16) for t in table}
    if a.cls not in upd: raise SystemExit('unknown class %s' % a.cls)
    a.out.mkdir(parents=True, exist_ok=False)
    c = pg.Client('127.0.0.1', a.port); c.connect()
    lives, open_ = [], {}
    try:
        if c.request('game.status').get('game', {}).get('id') != 'UCES00420': raise SystemExit('requires UCES00420')
        game = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive') and m['name'] == 'rcp1']
        if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise SystemExit('LEVEL_01 not resident')
        base = game[0]['address']
        recs, cap = find_group(c, base, upd[a.cls])
        if not recs: raise SystemExit('%s group not found (fire once so the class is created, then rerun)' % a.cls)
        print('Waiting for the first projectile (up to %.0f s), then %.0f s, %d slots...' % (a.arm, a.seconds, cap), flush=True)
        ta = time.perf_counter()
        while not any(w & 1 for w in c.read(recs, cap*RECORD//4)[0x64//4::RECORD//4]):   # arm
            if time.perf_counter() - ta > a.arm: raise SystemExit('no projectile within %.0f s' % a.arm)
            time.sleep(a.interval)
        ammo_addr = base + a.ammo_offset; ammo_last = c.read(ammo_addr, 1)[0]; shots = []
        tick0 = c.request('cpu.status')['ticks']
        t0 = time.perf_counter(); polls = 0
        while time.perf_counter() - t0 < a.seconds:
            words = c.read(recs, cap*RECORD//4); t = time.perf_counter() - t0; polls += 1
            v = c.read(ammo_addr, 1)[0]
            if v < ammo_last: shots += [round(t, 4)] * (ammo_last - v)
            ammo_last = v
            time.sleep(max(0.0, a.interval - (time.perf_counter() - t0 - t)))
            for k in range(cap):
                w = words[k*32:(k+1)*32]
                live = w[0x64//4] & 1
                pos = (f32(w[0x30//4]), f32(w[0x34//4]), f32(w[0x38//4])); age = f32(w[0x70//4])
                cur = open_.get(k)
                if cur and (not live or age < cur['ageLast']):
                    lives.append(cur); open_.pop(k); cur = None
                if live:
                    if cur is None:
                        cur = open_[k] = {'slot': k, 't0': t, 'ageFirst': age, 'start': pos, 'path': 0.0}
                    else:
                        cur['path'] += math.dist(cur['end'], pos)
                    cur.update(t1=t, ageLast=age, end=pos)
        dur = time.perf_counter() - t0
        emu_speed = round((c.request('cpu.status')['ticks'] - tick0) / dur / 222e6, 3)
    finally:
        c.close()
    rows = []
    for L in lives:   # only lives seen to end; open ones at the deadline are dropped (truncated)
        life = L['t1'] - L['t0']
        rows.append({'slot': L['slot'], 'lifetimeS': round(life, 4), 'ageFirst': round(L['ageFirst'], 3),
                     'ageLast': round(L['ageLast'], 3), 'distance': round(math.dist(L['start'], L['end']), 3),
                     'stepPerAge': round(math.dist(L['start'], L['end']) / (L['ageLast'] - L['ageFirst']), 4) if L['ageLast'] > L['ageFirst'] else None,
                     'path': round(L['path'], 3), 'speed': round(L['path'] / life, 3) if life > 0 else None,
                     'start': [round(x, 3) for x in L['start']], 'end': [round(x, 3) for x in L['end']]})
    med = lambda k: statistics.median([r[k] for r in rows if r[k] is not None]) if rows else None
    rec = {'label': a.label, 'class': a.cls, 'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
           'seconds': round(dur, 3), 'emuSpeed': emu_speed, 'polls': polls, 'pollIntervalMs': round(1000*dur/max(polls, 1), 2),
           'lives': len(rows), 'truncatedAtEnd': len(open_),
           'ammoShots': len(shots), 'shotsPerSecond': round((len(shots)-1)/(shots[-1]-shots[0]), 3) if len(shots) > 1 and shots[-1] > shots[0] else None,
           'shotGapMedian': statistics.median([y-x for x, y in zip(shots, shots[1:])]) if len(shots) > 2 else None, 'shotTimes': shots,
           'median': {k: med(k) for k in ('lifetimeS', 'ageLast', 'distance', 'stepPerAge', 'path', 'speed')},
           'status': 'TESTED measurement; lifetime resolution = pollIntervalMs; first/last sight, not exact spawn/death',
           'rows': rows}
    (a.out/'projectiles.json').write_text(json.dumps(rec, indent=1), encoding='utf-8', newline='\n')
    print(json.dumps({k: rec[k] for k in ('label', 'class', 'emuSpeed', 'lives', 'truncatedAtEnd', 'ammoShots', 'shotsPerSecond', 'shotGapMedian', 'pollIntervalMs', 'median')}))


if __name__ == '__main__':
    main()
