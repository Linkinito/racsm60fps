#!/usr/bin/env python3
"""Reviewed Crab timer recipe (replacement for the quarantined generated batch).

Input: the generated spec (level01-timer-patch-spec.json, preserved unchanged) and the ten
sites rejected by research/v2/crab-timer-audit-20261001/REPORT.md (animation ids, a capacity
check, entity/lifecycle flag ORs). Output: the 19 remaining reload sites that store into Crab
data+0x60 (x2 immediates as generated), plus the separate data+0x64 cooldown reload
`trunc(helper * 15.0)` at 0x12754C (lui 0x4170 -> 0x41F0, i.e. 15.0 -> 30.0: the same time in
60 Hz frames for every selector value 1.0/1.1/1.2/1.3).
Random draws `rand % m + o` become `rand % 2m + 2o`: same range in seconds, finer granularity.
Status STATIC_CANDIDATE (CORROBORATED dataflow for the 19 sites, see the audit report).
Usage: python research/scripts/crab-timer-recipe.py --out research/v2/crab-timer-audit-20261001/crab-timer-recipe-v2.json
"""
import argparse, hashlib, json
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
SPEC = REPO/'research/v2/decomp-summary/level01-timer-patch-spec.json'
REJECTED = {0x124058, 0x1276D0, 0x12775C, 0x127888, 0x12792C, 0x127914, 0x127A24, 0x137BA4, 0x6A48C, 0x6A4A8}

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0]); ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args()
    spec = json.loads(SPEC.read_text(encoding='utf-8'))['classes']['Crab']
    sites = {}
    for s in spec:
        r = int(s['site'], 16)
        if r not in REJECTED: sites[r] = {'site': '0x%x' % r, 'before': s['before'], 'after': s['after'], 'field': '+0x60', 'text': s['text']}
    sites[0x12754C] = {'site': '0x12754c', 'before': '0x3c044170', 'after': '0x3c0441f0', 'field': '+0x64',
                       'text': 'lui a0,0x4170 (15.0) in trunc(helper 0x2172C * 15.0) cooldown reload'}
    rec = {'status': 'STATIC_CANDIDATE', 'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'specSha256': hashlib.sha256(SPEC.read_bytes()).hexdigest(), 'rejected': ['0x%x' % r for r in sorted(REJECTED)],
           'sites': [sites[k] for k in sorted(sites)]}
    a.out.write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    print(len(rec['sites']), 'sites')

if __name__ == '__main__':
    main()
