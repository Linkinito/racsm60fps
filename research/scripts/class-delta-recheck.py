#!/usr/bin/env python3
"""Domain-2 backlog: classes whose earlier static profile counted "delta shapes" although their pump-1
update never receives the frame delta (call-context dataflow). Static, INFERRED; review queue only.

Inputs: level01-class-verdicts.json (old profile), level01-call-contexts.json (readsF12 of each class
update), level01-fixed-step-candidates.json (per-class step functions), tools/runtime/fixes.py (which
step functions already contain a fix site, by code address or by data-constant user).
Output: research/v2/decomp-summary/level01-domain2-backlog.json
Usage: python research/scripts/class-delta-recheck.py
"""
import bisect, hashlib, importlib.util, json
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
S = REPO/'research/v2/decomp-summary'
VER, CTX, FSC, OUT = (S/'level01-class-verdicts.json', S/'level01-call-contexts.json',
                      S/'level01-fixed-step-candidates.json', S/'level01-domain2-backlog.json')


def main():
    spec = importlib.util.spec_from_file_location('fixes', REPO/'tools/runtime/fixes.py')
    fx = importlib.util.module_from_spec(spec); spec.loader.exec_module(fx)
    cc_spec = importlib.util.spec_from_file_location('cc', REPO/'research/scripts/call-contexts.py')
    cc = importlib.util.module_from_spec(cc_spec); cc_spec.loader.exec_module(cc)
    ctx = json.loads(CTX.read_text(encoding='utf-8'))['functions']
    F = {int(x['rva'], 16): x for x in ctx}
    starts = sorted(F)

    def fn_of(a):
        i = bisect.bisect_right(starts, a) - 1
        return starts[i] if i >= 0 and a < starts[i] + F[starts[i]]['size'] else None

    # functions touched by a fix: code sites directly, data constants through their loaders
    A = cc.Analyzer(cc.PRX.read_bytes(), {s: {'size': F[s]['size'], 'callees': []} for s in starts})
    data_sites = {rva for rva, _o, _n in fx.DATA.values() if rva >= cc.TEXT_END}
    fixed_fn = {}
    for k, (rva, _o, _n) in fx.DATA.items():
        if rva < cc.TEXT_END and fn_of(rva) is not None: fixed_fn.setdefault(fn_of(rva), set()).add(k)
    for s in starts:
        hit = A.scan(s, {}, set())['globalLoads'] & data_sites
        for a in hit:
            for k, (rva, _o, _n) in fx.DATA.items():
                if rva == a: fixed_fn.setdefault(s, set()).add(k)
    for k, v in fx.WRAPPERS.items():
        for site in v[1]:
            if fn_of(site) is not None: fixed_fn.setdefault(fn_of(site), set()).add(k)

    reads = {c.split('.')[0]: x['readsF12'] for x in ctx for c in x['classUpdateOf']}
    steps = {c['class']: c for c in json.loads(FSC.read_text(encoding='utf-8'))['classes']}
    rows = []
    for r in json.loads(VER.read_text(encoding='utf-8'))['rows']:
        if r['deltaShapes'] > 0 and reads.get(r['class']) is False:
            fns = steps.get(r['class'], {}).get('functions', [])
            rows.append({'class': r['class'], 'oldVerdict': r['verdict'], 'deltaShapes': r['deltaShapes'],
                         'fixedShapes': r['fixedShapes'], 'stepFunctions': fns,
                         'stepFunctionsWithFix': {f: sorted(fixed_fn[int(f, 16)])[:6] for f in fns
                                                  if int(f, 16) in fixed_fn},
                         'uncovered': [f for f in fns if int(f, 16) not in fixed_fn]})
    rows.sort(key=lambda x: (-len(x['uncovered']), x['class']))
    rec = {'status': 'STATIC review queue (INFERRED): class update never receives the delta; old delta shapes '
                     'are per-call unless driven by another time source',
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'inputs': {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in (VER, CTX, FSC, REPO/'tools/runtime/fixes.py')},
           'count': len(rows), 'classes': rows}
    OUT.write_text(json.dumps(rec, indent=1), encoding='utf-8', newline='\n')
    print(json.dumps({'count': len(rows), 'top': [(x['class'], len(x['uncovered'])) for x in rows[:15]]}, indent=0))


if __name__ == '__main__':
    main()
