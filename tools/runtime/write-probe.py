#!/usr/bin/env python3
"""Find which code writes a field: memory write breakpoint, record pc/ra per stop.

Usage: python tools/runtime/write-probe.py --class-rva 0x126F28 --field 0x30 --out <new dir>
The entity is taken from a0 at the class callback (first stop). Stops are reported
as module RVAs when inside LEVEL_01. Read-only except temporary breakpoints.
"""
import argparse, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)

def wait_stop(c, seconds):
    deadline = time.monotonic()+seconds
    st = c.request('cpu.status')
    while not st.get('stepping'):
        if time.monotonic() > deadline: raise RuntimeError('no stop within %d s' % seconds)
        time.sleep(0.02); st = c.request('cpu.status')
    regs = c.request('cpu.getAllRegs')['categories'][0]
    return st, dict(zip(regs['registerNames'], regs['uintValues']))

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--class-rva', type=lambda x: int(x, 0))
    ap.add_argument('--field', type=lambda x: int(x, 0), default=0)
    ap.add_argument('--address', type=lambda x: int(x, 0), help='absolute address (skips class lookup)')
    ap.add_argument('--wait', type=int, default=6)
    ap.add_argument('--change', action='store_true', help='break only when the value changes')
    ap.add_argument('--stops', type=int, default=12)
    ap.add_argument('--deref', type=lambda x: int(x, 0), help='follow pointer at entity+DEREF, then add --field')
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args()
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'classRva': hex(a.class_rva) if a.class_rva is not None else None, 'address': hex(a.address) if a.address else None, 'field': hex(a.field), 'stops': []}
    c = pg.Client('127.0.0.1', a.port); c.connect(); cbp = mbp = None
    try:
        mods = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive') and m['name'] == 'rcp1']
        base = mods[0]['address']; rec['base'] = hex(base)
        if c.request('cpu.breakpoint.list').get('breakpoints'): raise RuntimeError('breakpoints already set')
        if a.address is None:
            cbp = base+a.class_rva
            c.request('cpu.breakpoint.add', {'address': cbp, 'enabled': True, 'log': False})
            _, regs = wait_stop(c, 6); ent = regs['a0']; rec['entity'] = hex(ent)
            c.request('cpu.breakpoint.remove', {'address': cbp}); cbp = None
            target = ent
        else:
            target = a.address
        if a.deref is not None:
            target = c.read(ent+a.deref, 1)[0]; rec['deref'] = hex(target)
        mbp = target+a.field
        rec['before'] = hex(c.read(mbp, 1)[0])
        c.raw_request({'event': 'memory.breakpoint.add', 'address': mbp, 'size': 4,
                       'enabled': True, 'log': False, 'read': False, 'write': True, 'change': a.change})
        if a.address is None: c.request('cpu.resume', no_reply=True, delay_ms=20)
        for _ in range(a.stops):
            st, regs = wait_stop(c, a.wait)
            pc, ra = st.get('pc'), regs.get('ra')
            rel = lambda x: hex(x-base) if base <= x < base+pg.MODULE_SIZE else hex(x)
            stack = c.read(regs['sp'], 64) if regs.get('sp') else []
            rec['stops'].append({'pc': rel(pc), 'ra': rel(ra), 'a0': hex(regs['a0']), 'a1': hex(regs['a1']), 's0': hex(regs['s0']),
                                 'value': hex(c.read(mbp, 1)[0]), 'stackCode': [rel(w) for w in stack if base <= w < base+pg.MODULE_SIZE]})
            c.request('cpu.resume', no_reply=True, delay_ms=20)
        rec['result'] = 'OBSERVED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
    finally:
        try:
            if cbp: c.request('cpu.breakpoint.remove', {'address': cbp})
            if mbp: c.raw_request({'event': 'memory.breakpoint.remove', 'address': mbp, 'size': 4})
            time.sleep(0.05)
            if c.request('cpu.status').get('stepping'): c.request('cpu.resume', no_reply=True, delay_ms=50)
        except Exception as e: rec['cleanupError'] = str(e)
        c.close()
        a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

if __name__ == '__main__':
    print(json.dumps(main(), indent=1))
