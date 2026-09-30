#!/usr/bin/env python3
"""Locate the live data of a pump-1 class (default Crab) and list fields that change.

1. Breakpoint at the class callback (LEVEL_01 RVA) to collect entity pointers (a0).
2. For the first entity, follow every word of its 0x80 record that points into
   user RAM and read REGION bytes there.
3. With the CPU running, sample the record and regions SAMPLES times and report
   words that change: offset, float/int classification, distinct values, range.
Read-only except the temporary breakpoint. Owner should keep the class active
(e.g. a crab chasing Ratchet) during sampling.

Usage: python tools/runtime/crab-probe.py --out <new dir> [--rva 0x126F28] [--samples 60]
"""
import argparse, base64, importlib.util, json, math, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
REGION = 0x400

def fval(w):
    f = struct.unpack('<f', struct.pack('<I', w))[0]
    e = (w >> 23) & 0xFF
    return f if (w in (0, 0x80000000) or 0x40 <= e <= 0xBE) and math.isfinite(f) else None

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    ap.add_argument('--rva', type=lambda x: int(x, 0), default=0x126F28)
    ap.add_argument('--stops', type=int, default=8); ap.add_argument('--samples', type=int, default=60)
    a = ap.parse_args()
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'rva': hex(a.rva)}
    c = pg.Client('127.0.0.1', a.port); c.connect(); bp = None
    try:
        mods = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive') and m['name'] == 'rcp1']
        if len(mods) != 1 or mods[0]['size'] != pg.MODULE_SIZE: raise RuntimeError('LEVEL_01 not resident')
        base = mods[0]['address']; rec['base'] = hex(base)
        if c.request('cpu.breakpoint.list').get('breakpoints'): raise RuntimeError('breakpoints already set')
        bp = base+a.rva
        c.request('cpu.breakpoint.add', {'address': bp, 'enabled': True, 'log': False})
        entities = []
        for _ in range(a.stops):
            deadline = time.monotonic()+6
            st = c.request('cpu.status')
            while not st.get('stepping'):
                if time.monotonic() > deadline: raise RuntimeError('class callback not hit within 6 s (no active instance nearby?)')
                time.sleep(0.03); st = c.request('cpu.status')
            regs = c.request('cpu.getAllRegs')['categories'][0]
            a0 = regs['uintValues'][regs['registerNames'].index('a0')]
            entities.append(a0)
            c.request('cpu.resume', no_reply=True, delay_ms=30)
        c.request('cpu.breakpoint.remove', {'address': bp}); bp = None
        time.sleep(0.1)
        if c.request('cpu.status').get('stepping'): c.request('cpu.resume', no_reply=True, delay_ms=50)
        uniq = sorted(set(entities)); rec['entities'] = [hex(e) for e in uniq]
        ent = entities[0]
        record = c.read(ent, 32)
        regions = {'entity': (ent, 0x80)}
        for i, w in enumerate(record):
            if 0x08800000 <= w < 0x0A000000-REGION and not w & 3 and not (ent <= w < ent+0x80):
                regions['ptr+0x%02X' % (i*4)] = (w, REGION)
        rec['regions'] = {k: hex(v[0]) for k, v in regions.items()}
        samples = {k: [] for k in regions}
        t0 = time.monotonic()
        for _ in range(a.samples):
            for k, (addr, size) in regions.items():
                samples[k].append(c.read(addr, size//4))
            time.sleep(0.05)
        rec['sampleSeconds'] = round(time.monotonic()-t0, 2)
        changes = []
        for k, rows in samples.items():
            for i in range(len(rows[0])):
                col = [r[i] for r in rows]
                if len(set(col)) < 2: continue
                fl = [fval(w) for w in col]
                if all(v is not None for v in fl):
                    steps = [abs(fl[j+1]-fl[j]) for j in range(len(fl)-1) if fl[j+1] != fl[j]]
                    changes.append({'region': k, 'off': hex(i*4), 'type': 'float', 'distinct': len(set(col)),
                                    'min': round(min(fl), 4), 'max': round(max(fl), 4),
                                    'medianStep': round(sorted(steps)[len(steps)//2], 5) if steps else 0})
                else:
                    iv = [w if w < 0x80000000 else w-0x100000000 for w in col]
                    changes.append({'region': k, 'off': hex(i*4), 'type': 'int', 'distinct': len(set(col)),
                                    'min': min(iv), 'max': max(iv), 'first': iv[0], 'last': iv[-1]})
        rec['changes'] = changes; rec['result'] = 'OBSERVED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
    finally:
        if bp is not None:
            try:
                c.request('cpu.breakpoint.remove', {'address': bp})
                if c.request('cpu.status').get('stepping'): c.request('cpu.resume', no_reply=True, delay_ms=50)
            except Exception as e: rec['cleanupError'] = str(e)
        c.close()
        a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

if __name__ == '__main__':
    r = main()
    print(json.dumps({k: r.get(k) for k in ('result', 'error', 'base', 'entities', 'regions', 'sampleSeconds')}))
    for ch in r.get('changes', []): print(ch)
