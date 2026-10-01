#!/usr/bin/env python3
"""Per-class motion/timing profile from the local full decompilation (static).

For every class: does its update receive and use the float delta? which functions in
its update tree (depth 3) write position (+0x30/+0x34/+0x38) or rotation-like fields,
which shared movers it calls, and which helpers are shared with other classes.
Output (no code): research/v2/decomp-summary/level01-motion-profiles.json
Usage: python research/scripts/motion-profile.py --all <dir> --classes <table>
"""
import argparse, collections, json, re
from pathlib import Path

POS = re.compile(r'\*\(float \*\)\((?:param_\d+|iVar\d+|\w+) \+ 0x3[048]\) =')
def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--all', type=Path, required=True); ap.add_argument('--classes', type=Path, required=True)
    a = ap.parse_args()
    idx = json.loads((a.all/'index.json').read_text(encoding='utf-8'))
    callees = {r['rva']: r['callees'] for r in idx}; names = {r['rva']: r['name'] for r in idx}
    table = json.loads(a.classes.read_text(encoding='utf-8'))['classes']
    txt = {}
    def t(r):
        if r not in txt:
            p = a.all/'c'/(r+'.c'); txt[r] = p.read_text(encoding='utf-8', errors='replace') if p.exists() else ''
        return txt[r]
    users = collections.defaultdict(set); trees = {}
    for c in table:
        seen = {c['update']}; fr = {c['update']}
        for _ in range(3):
            fr = {g for f in fr for g in callees.get(f, []) if g not in seen}; seen |= fr
        trees[c['class']] = seen
        for f in seen: users[f].add(c['class'])
    out = {}
    for c in table:
        u = c['update']; code = t(u); hdr = code.split('{', 1)[0]
        fparams = re.findall(r'float\s+(param_\d+)', hdr)
        body = code.split('{', 1)[1] if '{' in code else ''
        uses_dt = any(re.search(r'\b%s\b' % p, body) for p in fparams)
        poswriters = sorted(f for f in trees[c['class']] if POS.search(t(f)))
        shared = sorted(f for f in trees[c['class']] if 2 <= len(users[f]) <= 25 and POS.search(t(f)))
        out[c['class']] = {'update': u, 'updateLines': code.count('\n'), 'deltaParam': bool(fparams), 'usesDelta': uses_dt,
                           'positionWriters': poswriters[:20], 'sharedPositionWriters': shared[:12]}
    p = Path('research/v2/decomp-summary/level01-motion-profiles.json')
    p.write_text(json.dumps({'status': 'STATIC_PROFILE', 'classes': out}, indent=1), encoding='utf-8')
    hist = collections.Counter(len(users[f]) for f in users)
    common = sorted(((f, len(users[f])) for f in users if 3 <= len(users[f]) <= 30 and POS.search(t(f))), key=lambda x: -x[1])
    print('shared position writers:', [(f, names.get(f), n) for f, n in common[:25]])

if __name__ == '__main__':
    main()
