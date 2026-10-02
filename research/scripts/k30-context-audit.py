#!/usr/bin/env python3
"""Re-audit of the LEVEL_01 literal-1/30 census with call context and delta dataflow (static).

Why: level01-frame-time-constants.json split the 108 `lui 0x3D08` sites into timer steps (patched by
`frametimers`), "scale" conversions and "other". Context showed two errors: some timer steps sit in the
player substep body (already correct after C1), and several "scale" sites are per-call rates in code
that never sees the frame delta (camera, Lvl3Elevator, Teleporter effects, fade channels).

Verdict per site (INFERRED, review before use):
  SUBSTEP_ALREADY_CORRECT  function reached only from the substep body (60 calls/s in A0 and C1)
  DELTA_FUNCTION           function receives the frame delta: 1/30 is likely a unit conversion
  IN_FIX:<names>           the site is already a key of tools/runtime/fixes.py
  PER_CALL_CANDIDATE       no delta, reached from per-frame contexts (or only indirectly): likely domain 4
Inputs: level01-frame-time-constants.json, level01-call-contexts.json, tools/runtime/fixes.py (DATA).
Output: research/v2/decomp-summary/level01-k30-context-audit.json
Usage: python research/scripts/k30-context-audit.py
"""
import hashlib, importlib.util, json
from collections import Counter, defaultdict
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
S = REPO/'research/v2/decomp-summary'
FT, CTX, OUT = S/'level01-frame-time-constants.json', S/'level01-call-contexts.json', S/'level01-k30-context-audit.json'


def main():
    spec = importlib.util.spec_from_file_location('fixes', REPO/'tools/runtime/fixes.py')
    fx = importlib.util.module_from_spec(spec); spec.loader.exec_module(fx)
    in_fix = defaultdict(list)
    for k, (rva, _o, _n) in fx.DATA.items(): in_fix[rva].append(k)
    group_of = {}
    for g, keys in (('frametimers', fx.FRAMETIMERS), ('teleporterfx', getattr(fx, 'TELEPORTERFX', [])),
                    ('groupfade', getattr(fx, 'GROUPFADE', [])), ('k30calls', getattr(fx, 'K30CALLS', [])),
                    ('camera', fx.CAMERA)):
        for k in keys: group_of[k] = g
    ctx = {x['rva']: x for x in json.loads(CTX.read_text(encoding='utf-8'))['functions']}
    rows = []
    for r in json.loads(FT.read_text(encoding='utf-8'))['sites']:
        x = ctx[r['fn']]
        site = int(r['site'], 16)
        if x['regions'] == ['substep']: v = 'SUBSTEP_ALREADY_CORRECT'
        elif site in in_fix: v = 'IN_FIX:' + ','.join(sorted({group_of.get(k, k) for k in in_fix[site]}))
        elif x['dtEntry'] or x['readsF12']: v = 'DELTA_FUNCTION'
        else: v = 'PER_CALL_CANDIDATE'
        rows.append({'site': r['site'], 'fn': r['fn'], 'name': x['name'], 'oldKind': r['kind'],
                     'classes': r['classes'], 'regions': x['regions'], 'dtEntry': x['dtEntry'],
                     'readsF12': x['readsF12'], 'verdict': v})
    rec = {'status': 'STATIC: INFERRED verdicts from call context + delta dataflow; review each site before patching',
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'inputs': {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in (FT, CTX, REPO/'tools/runtime/fixes.py')},
           'counts': dict(Counter(r['verdict'] for r in rows)),
           'sites': rows}
    OUT.write_text(json.dumps(rec, indent=1), encoding='utf-8', newline='\n')
    print(json.dumps(rec['counts'], indent=1))


if __name__ == '__main__':
    main()
