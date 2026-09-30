#!/usr/bin/env python3
"""Break at a LEVEL_01 function entry; record a0/a1/ra and module-code words on the stack.

Usage: python tools/runtime/call-probe.py --rva 0x1254CC --stops 4 --wait 60 --out <new dir>
"""
import argparse, importlib.util, json, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('write_probe', REPO/'tools/runtime/write-probe.py')
wp = importlib.util.module_from_spec(spec); spec.loader.exec_module(wp)
pg = wp.pg

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--rva', type=lambda x: int(x, 0), required=True)
    ap.add_argument('--stops', type=int, default=4); ap.add_argument('--wait', type=int, default=60)
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args(); rec = {'rva': hex(a.rva), 'stops': []}
    c = pg.Client('127.0.0.1', a.port); c.connect(); bp = None
    try:
        base = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'rcp1' and m.get('isActive')][0]['address']
        rel = lambda x: hex(x-base) if base <= x < base+pg.MODULE_SIZE else hex(x)
        bp = base+a.rva; c.request('cpu.breakpoint.add', {'address': bp, 'enabled': True, 'log': False})
        for _ in range(a.stops):
            st, regs = wp.wait_stop(c, a.wait)
            stack = c.read(regs['sp'], 48)
            rec['stops'].append({'a0': hex(regs['a0']), 'a1': hex(regs['a1']), 'a2': hex(regs['a2']), 'a3': hex(regs['a3']), 't0': rel(regs['t0']), 'ra': rel(regs['ra']),
                                 'stackCode': [rel(w) for w in stack if base <= w < base+pg.MODULE_SIZE]})
            c.request('cpu.resume', no_reply=True, delay_ms=40)
        rec['result'] = 'OBSERVED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
    finally:
        try:
            if bp: c.request('cpu.breakpoint.remove', {'address': bp})
            time.sleep(0.05)
            if c.request('cpu.status').get('stepping'): c.request('cpu.resume', no_reply=True, delay_ms=50)
        except Exception as e: rec['cleanupError'] = str(e)
        c.close(); a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

if __name__ == '__main__':
    print(json.dumps(main(), indent=1))
