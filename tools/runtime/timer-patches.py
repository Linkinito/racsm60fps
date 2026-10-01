#!/usr/bin/env python3
"""Apply/remove per-class frame-timer immediate patches (x2) from the static spec, live.

Spec: research/v2/decomp-summary/level01-timer-patch-spec.json (STATIC_CANDIDATE).
Every site word is checked against its original (or patched) value before any write;
CPU paused during writes; a JSON record is written. Works with or without C1.
Crab activation is quarantined: its generated list contains non-timer sites.
Status and restoration remain available. See research/v2/crab-timer-audit-20261001/REPORT.md.
Usage: python tools/runtime/timer-patches.py --class Crab --target on|off|status --out <new dir>
"""
import argparse, hashlib, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('pump_gate', REPO/'tools/runtime/pump-gate.py')
pg = importlib.util.module_from_spec(spec); spec.loader.exec_module(pg)
SPEC = REPO/'research/v2/decomp-summary/level01-timer-patch-spec.json'

def require_activation_review(cls, target):
    """Reject a known-invalid batch before connecting to the emulator."""
    if cls == 'Crab' and target == 'on':
        raise ValueError('Crab timer activation is quarantined: 10 of 29 sites are not timers. '
                         'Use status/off for inspection/restoration; a reviewed replacement is pending. '
                         'See research/v2/crab-timer-audit-20261001/REPORT.md')

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--class', dest='cls', required=True); ap.add_argument('--target', choices=('on', 'off', 'status'), required=True)
    ap.add_argument('--out', type=Path, required=True); ap.add_argument('--port', type=int, default=60907)
    a = ap.parse_args()
    require_activation_review(a.cls, a.target)
    sites = json.loads(SPEC.read_text(encoding='utf-8'))['classes'].get(a.cls)
    if not sites: raise SystemExit('no spec for class ' + a.cls)
    uniq = {s['site']: s for s in sites}
    rec = {'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'class': a.cls, 'target': a.target,
           'specSha256': hashlib.sha256(SPEC.read_bytes()).hexdigest(), 'sites': len(uniq), 'writes': 0}
    c = pg.Client('127.0.0.1', a.port); c.connect(); paused = False
    try:
        mods = [m for m in c.request('hle.module.list')['modules'] if m.get('isActive') and m['name'] == 'rcp1']
        if len(mods) != 1 or mods[0]['size'] != pg.MODULE_SIZE: raise RuntimeError('LEVEL_01 not resident')
        base = mods[0]['address']; rec['base'] = hex(base)
        cur = {k: c.read(base+int(k, 16), 1)[0] for k in uniq}
        state = {k: 'off' if cur[k] == int(s['before'], 16) else 'on' if cur[k] == int(s['after'], 16) else 'OTHER' for k, s in uniq.items()}
        rec['before'] = {v: sum(1 for x in state.values() if x == v) for v in ('off', 'on', 'OTHER')}
        if rec['before']['OTHER']: raise RuntimeError('unexpected words at %s' % [k for k, v in state.items() if v == 'OTHER'][:5])
        if a.target == 'status': rec['result'] = 'OBSERVED'; return rec
        c.request('cpu.stepping'); paused = True
        for k, s in uniq.items():
            want = int(s['after' if a.target == 'on' else 'before'], 16)
            if c.read(base+int(k, 16), 1)[0] != want: c.write(base+int(k, 16), want); rec['writes'] += 1
        c.request('cpu.resume'); paused = False
        rec['result'] = 'APPLIED_NOT_GAMEPLAY_VALIDATED'
    except Exception as e:
        rec['result'] = 'FAILED'; rec['error'] = str(e)
    finally:
        if paused:
            try: c.request('cpu.resume')
            except Exception: pass
        c.close(); a.out.mkdir(parents=True, exist_ok=False)
        (a.out/'result.json').write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    return rec

if __name__ == '__main__':
    print(json.dumps(main()))
