#!/usr/bin/env python3
"""Print key motion/timing lines of a class update tree (local reading aid, no output file).
Usage: python research/scripts/motion-lines.py <Class> [depth] [maxlines]"""
import json, re, sys
from pathlib import Path
A = Path('research/v2/decomp-candidates/_local/20261001-mass/all')
idx = json.loads((A/'index.json').read_text(encoding='utf-8')); callees = {r['rva']: r['callees'] for r in idx}
users = {}
for r in idx:
    for c in r['callees']: users.setdefault(c, set()).add(r['rva'])
tab = {c['class']: c for c in json.loads(Path('research/v2/class-table/level01-classes.json').read_text())['classes']}
cls = sys.argv[1]; depth = int(sys.argv[2]) if len(sys.argv) > 2 else 2; mx = int(sys.argv[3]) if len(sys.argv) > 3 else 14
c = tab[cls]; roots = [c['update']]; seen = set(roots); fr = set(roots)
for _ in range(depth):
    fr = {g for f in fr for g in callees.get(f, []) if g not in seen and len(users.get(g, ())) < 12}; seen |= fr
KEY = re.compile(r'(\+ 0x3[048]\) =|0x3[048]\) = .*\+|\[\w+\] = .*[+-] |= \w+ \* param_1|param_1\b|0\.0333|-1\.0|\+ -1;|\+ 1;|% 0x|speed|DAT_\w+ \*)')
for f in sorted(seen):
    p = A/'c'/(f+'.c')
    if not p.exists(): continue
    lines = [l.strip() for l in p.read_text(encoding='utf-8', errors='replace').splitlines() if KEY.search(l) and not l.strip().startswith(('float', 'int', 'undefined'))]
    if lines:
        print('--', f, p.read_text(encoding='utf-8', errors='replace').split('(')[0].split()[-1])
        for l in lines[:mx]: print('   ', l[:150])
