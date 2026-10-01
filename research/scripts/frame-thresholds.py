#!/usr/bin/env python3
"""Second-pass frame-timer detection: count-up/count-down integer fields (scan-decompiled
int_step hits, local-variable aware) and integer literals compared in the same function.

For each function with an int_step on a field, literals (2..0x3fff) appearing in
comparisons (<, <=, >, >=, ==) are listed as candidate frame thresholds. Output feeds
FindImmediates/timer-patch-spec. Status: STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF.
Usage: python research/scripts/frame-thresholds.py --scan <scan-summary.json> --all <dir> --out <json>
"""
import argparse, json, re
from pathlib import Path

CMP = re.compile(r'(?:[<>]=?|==)\s*(0x[0-9a-f]+|\d+)\b|\b(0x[0-9a-f]+|\d+)\s*(?:[<>]=?|==)')

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--scan', type=Path, required=True); ap.add_argument('--all', type=Path, required=True)
    ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args()
    funcs = json.loads(a.scan.read_text(encoding='utf-8'))['functionsDetail']
    out = {}
    for rva, v in funcs.items():
        if not v['kinds'].get('int_step'): continue
        classes = [c for c in v['reachedFrom'] if c != 'ENGINE']
        if not classes or len(classes) > 6: continue          # skip engine-wide helpers
        t = (a.all/'c'/(rva+'.c')).read_text(encoding='utf-8', errors='replace')
        body = t.split('{', 1)[1] if '{' in t else ''
        lits = set()
        for m in CMP.finditer(body):
            x = m.group(1) or m.group(2); n = int(x, 16) if x.startswith("0x") else int(x)
            if 2 <= n <= 0x3fff: lits.add(x)
        if lits:
            out[rva] = {'classes': classes, 'stepFields': sorted({h['field'] for h in v['hits'] if h['kind'] == 'int_step'}),
                        'literals': sorted(lits, key=lambda x: int(x, 16) if x.startswith('0x') else int(x))}
    a.out.write_text(json.dumps({'status': 'STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF', 'functions': out}, indent=1), encoding='utf-8')
    print(len(out), 'functions')
    for r, v in sorted(out.items()): print(r, v['classes'][:3], v['stepFields'], v['literals'][:10])

if __name__ == '__main__':
    main()
