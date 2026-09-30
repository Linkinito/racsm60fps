#!/usr/bin/env python3
"""Iterative f32 RAM scan (user RAM 0x08800000..0x0A000000), read-only.

  --start LO HI         keep every float in [LO, HI) ; writes candidates.json in --state
  --filter LO HI        re-read previous candidates, keep those now in [LO, HI)
  --decreased           keep previous candidates whose value went down (stores all values)
Usage: python tools/runtime/value-scan.py --state <dir> --start 40.5 42
       python tools/runtime/value-scan.py --state <dir> --filter 30.5 32
"""
import argparse, base64, importlib.util, json, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
LO, HI, CHUNK = 0x08800000, 0x0A000000, 0x100000

def read(c, address, size):
    r = c.request('memory.read', {'address': address, 'size': size, 'replacements': False})
    return base64.b64decode(r['base64'])

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--state', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument('--start', nargs=2, type=float); g.add_argument('--filter', nargs=2, type=float)
    g.add_argument('--decreased', action='store_true')
    a = ap.parse_args(); a.state.mkdir(parents=True, exist_ok=True)
    c = pg.Client('127.0.0.1', a.port); c.connect()
    try:
        path = a.state/'candidates.json'
        if a.start:
            lo, hi = a.start; found = {}
            for base in range(LO, HI, CHUNK):
                data = read(c, base, CHUNK)
                for i, (v,) in enumerate(struct.iter_unpack('<f', data)):
                    if lo <= v < hi: found[base+4*i] = v
        else:
            old = json.loads(path.read_text()); prev = old['candidates']; found = {}
            lo, hi = a.filter if a.filter else old['range']
            for addr in map(lambda x: int(x, 16), prev):
                v = struct.unpack('<f', read(c, addr, 4))[0]
                if a.decreased:
                    if v < old['values'][hex(addr)] - 1e-4: found[addr] = v
                elif lo <= v < hi: found[addr] = v
        out = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'range': [lo, hi],
               'count': len(found), 'candidates': [hex(k) for k in sorted(found)],
               'values': {hex(k): v for k, v in sorted(found.items())}}
        path.write_text(json.dumps(out, indent=1))
        (a.state/('step-%s.json' % time.strftime('%H%M%S'))).write_text(json.dumps(out, indent=1))
        print(json.dumps({'count': out['count'], 'first': [(k, round(v, 4)) for k, v in list(out['values'].items())[:25]]}))
    finally:
        c.close()

if __name__ == '__main__':
    main()
