#!/usr/bin/env python3
"""Turn located timer literals into a word-patch spec (immediate x2), per class.

Input: frame-timer inventory (which class/field/function) and FindImmediates output
(instruction sites). Keeps only li/addiu/ori/slti/sltiu immediates (not lui address
halves, not memory offsets, not sp/gp arithmetic), literal 2..0x3fff. The new word
doubles the 16-bit immediate. Status: STATIC_CANDIDATE (each site needs live review).
Usage: python research/scripts/timer-patch-spec.py --timers <json> --sites <json> --out <json>
"""
import argparse, hashlib, json, re
from pathlib import Path

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--timers', type=Path, required=True); ap.add_argument('--sites', type=Path, required=True)
    ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args()
    timers = json.loads(a.timers.read_text(encoding='utf-8'))['classes']
    sites = json.loads(a.sites.read_text(encoding='utf-8'))
    fn_class = {}
    for cls, fs in timers.items():
        for fo, v in fs.items():
            for x in v['init'] + v['compare']: fn_class.setdefault(x['fn'], set()).add((cls, fo))
    spec, seen = {}, set()
    for s in sites:
        text = s['text'].lstrip('_')
        op = text.split()[0]
        if op not in ('li', 'addiu', 'ori', 'slti', 'sltiu'): continue
        if re.search(r'\b(sp|gp)\b', text): continue
        lit = int(s['literal'], 0)
        if not 2 <= lit <= 0x3fff or s['site'] in seen: continue
        word = int(s['word'], 16)
        if word & 0xffff != lit: continue
        seen.add(s['site'])
        new = (word & 0xffff0000) | (lit * 2)
        for cls, fo in sorted(fn_class.get(s['fn'], ())):
            spec.setdefault(cls, []).append({'site': s['site'], 'fn': s['fn'], 'field': fo, 'text': text,
                                             'before': '0x%08x' % word, 'after': '0x%08x' % new, 'literal': lit})
    out = {'status': 'STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF', 'rule': 'double 30 Hz frame-duration immediates',
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(), 'classes': spec}
    a.out.write_text(json.dumps(out, indent=1), encoding='utf-8')
    for cls, v in sorted(spec.items()): print(cls, len(v), [(x['site'], x['text']) for x in v][:8])

if __name__ == '__main__':
    main()
