#!/usr/bin/env python3
"""TEST AID: set weapon ammo stocks in RAM (owner-requested; not a parity change).

Ammo entry of weapon id N: LEVEL_01 module + 0x2AE95C + N x 0x58, stock at +0x40 (FUN_0001F71C with
player+0xF0 = -1; Blaster 2 -> 0x2AEA4C and Ryno 15 -> 0x2AEEC4 confirmed live 2026-10-02b).
Each write is read back; before/after values are recorded in <out>/set-ammo.json.

Usage: python tools/runtime/set-ammo.py --weapons 2,15 --value 10000 --out <new dir>
       python tools/runtime/set-ammo.py --equipped --value 10000 --out <new dir>
"""
import argparse, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--weapons', default=''); ap.add_argument('--equipped', action='store_true')
    ap.add_argument('--value', type=int, default=10000); ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args(); a.out.mkdir(parents=True, exist_ok=False)
    c = pg.Client('127.0.0.1', a.port); c.connect(); rows = []
    try:
        game = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive') and m['name'] == 'rcp1']
        if len(game) != 1 or game[0]['size'] != pg.MODULE_SIZE: raise SystemExit('LEVEL_01 not resident')
        base = game[0]['address']; pl = base + 0x337940
        f0 = c.read(pl + 0xF0, 1)[0]; f0 = f0 - (1 << 32) if f0 & 0x80000000 else f0
        ids = [int(x) for x in a.weapons.split(',') if x]
        if a.equipped: ids.append(c.read(pl + 0x998, 1)[0])
        for wid in ids:
            if not 0 <= wid < 0x19: raise SystemExit('bad weapon id %d' % wid)
            addr = base + 0x2AE95C + (wid + f0 + 1) * 0x58 + 0x40
            before = c.read(addr, 1)[0]; c.write(addr, a.value)
            rows.append({'weapon': wid, 'offset': hex(addr - base), 'before': before, 'after': c.read(addr, 1)[0]})
    finally:
        c.close()
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'action': 'TEST AID ammo set', 'rows': rows}
    (a.out/'set-ammo.json').write_text(json.dumps(rec, indent=1), encoding='utf-8', newline='\n')
    print(json.dumps(rows))


if __name__ == '__main__':
    main()
