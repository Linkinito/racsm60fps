#!/usr/bin/env python3
"""Temporarily disable one LEVEL_01 call (jal -> nop) to see what it drives, then restore.

The delay-slot instruction keeps executing (argument setup only; check the site). CPU paused around both writes.
Usage: python tools/runtime/call-toggle.py --site 0x15240 --seconds 4 --out <new dir>
"""
import argparse, importlib.util, json, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--site', type=lambda x: int(x, 0), required=True)
    ap.add_argument('--seconds', type=float, default=4); ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args(); rec = {'site': hex(a.site), 'seconds': a.seconds}
    c = pg.Client('127.0.0.1', a.port); c.connect(); paused = False; orig = None; base = None
    try:
        base = [m for m in c.request('hle.module.list')['modules'] if m['name'] == 'rcp1' and m.get('isActive')][0]['address']
        orig, delay = c.read(base+a.site, 2)
        if orig >> 26 != 3: raise RuntimeError('site is not jal: %08x' % orig)
        rec['delay'] = hex(delay)   # delay slot still executes; it only sets an argument register
        rec['word'] = hex(orig)
        c.request('cpu.stepping'); paused = True; c.write(base+a.site, 0); c.request('cpu.resume'); paused = False
        time.sleep(a.seconds)
        c.request('cpu.stepping'); paused = True; c.write(base+a.site, orig); c.request('cpu.resume'); paused = False
        rec['result'] = 'RESTORED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
        try:
            if orig is not None and base is not None and c.read(base+a.site, 1)[0] != orig:
                if not paused: c.request('cpu.stepping'); paused = True
                c.write(base+a.site, orig); rec['rollback'] = True
        except Exception as r: rec['rollbackError'] = str(r)
    finally:
        if paused:
            try: c.request('cpu.resume')
            except Exception: pass
        c.close(); a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

if __name__ == '__main__':
    print(json.dumps(main()))
