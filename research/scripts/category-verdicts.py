#!/usr/bin/env python3
"""Per-class verdict table (static): fixed-step vs delta-based shapes in the class's own
update tree (depth 2, helpers shared by > 6 classes excluded), plus frame timers and
1/30 timer steps. Writes research/v2/decomp-summary/LEVEL01-CLASS-VERDICTS.md and .json.
Verdict: DELTA (only delta shapes), FIXED (only fixed-step shapes), MIXED, STATIC (none).
Usage: python research/scripts/category-verdicts.py"""
import collections, json, re
from pathlib import Path
import importlib.util
A = Path('research/v2/decomp-candidates/_local/20261001-mass/all')
spec = importlib.util.spec_from_file_location('scan', 'research/scripts/scan-decompiled.py'); scan = importlib.util.module_from_spec(spec); spec.loader.exec_module(scan)
idx = json.loads((A/'index.json').read_text(encoding='utf-8')); callees = {r['rva']: r['callees'] for r in idx}
users = collections.defaultdict(set)
tab = json.loads(Path('research/v2/class-table/level01-classes.json').read_text())['classes']
trees = {}
for c in tab:
    seen = {c['update']}; fr = {c['update']}
    for _ in range(2):
        fr = {g for f in fr for g in callees.get(f, []) if g not in seen}; seen |= fr
    trees[c['class']] = seen
    for f in seen: users[f].add(c['class'])
timers = json.loads(Path('research/v2/decomp-summary/level01-frame-timers.json').read_text())['classes']
ft = json.loads(Path('research/v2/decomp-summary/level01-frame-time-constants.json').read_text())['sites']
cache = {}
CATS = [('Weapons & gadgets', r'Blaster|Laser|Flame|Acid|Glove|Blitz|Crossbow|Ryno|Shock|Suck|Polar|Shield|Wrench|Hyper|Bomb|Mine|Gun|Rocket|Shot|Decoy|Electro|Gravity|Swarm|Sproutomatic|Titanium|Comet'),
        ('Enemies & NPCs', r'Luna|NPC|Animal|Butterfly|Shark|Crab|Cow|Bot|Robot|Agent|Bee|Enemy|Head|Torso|Mootator|Shrapnel'),
        ('Vehicles, platforms, doors', r'Boat|Ship|Dropship|Car|Elevator|Crank|Zip|Slide|Door|Teleport|Ratchet|Bolt'),
        ('Other objects', r'.')]
rows = []
for c in tab:
    cls = c['class']; k = collections.Counter(); dt = 0
    for f in trees[cls]:
        if len(users[f]) > 6: continue
        if f not in cache:
            p = A/'c'/(f+'.c'); cache[f] = scan.scan(p.read_text(encoding='utf-8', errors='replace')) if p.exists() else ([], False)
        hits, ud = cache[f]
        k.update(h['kind'] for h in hits); dt += ud
    fixed = k['field_accum'] + k['float_const'] + k['int_step'] + k['int_vs_float']
    delta = k['delta_step'] + dt
    nt = len(timers.get(cls, {})); nft = sum(1 for s in ft if s['kind'].startswith('timer') and cls in s['classes'])
    verdict = 'STATIC' if not fixed and not delta and not nt and not nft else 'DELTA' if delta and not (fixed or nt or nft) else 'FIXED' if not delta else 'MIXED'
    cat = next(n for n, rx in CATS if re.search(rx, cls))
    rows.append({'class': cls, 'category': cat, 'verdict': verdict, 'fixedShapes': fixed, 'deltaShapes': delta, 'frameTimers': nt, 'timerConst1_30': nft})
Path('research/v2/decomp-summary/level01-class-verdicts.json').write_text(json.dumps({'status': 'STATIC_PROFILE', 'rows': rows}, indent=1))
L = ['# LEVEL_01 class timing verdicts (static, generated)', '', 'DELTA = only delta-based shapes (likely correct under C1); FIXED = only fixed-step shapes;',
     'MIXED = both; STATIC = no timing shapes found. Counts are scanner shapes in the class update tree (depth 2). Not a parity verdict.', '']
for n, _ in CATS:
    L += ['## ' + n, '', '| Class | Verdict | Fixed shapes | Delta shapes | Frame timers | 1/30 timer steps |', '|---|---|---:|---:|---:|---:|']
    for r in sorted((r for r in rows if r['category'] == n), key=lambda r: (r['verdict'], r['class'])):
        L.append('| %s | %s | %d | %d | %d | %d |' % (r['class'], r['verdict'], r['fixedShapes'], r['deltaShapes'], r['frameTimers'], r['timerConst1_30']))
    L.append('')
Path('research/v2/decomp-summary/LEVEL01-CLASS-VERDICTS.md').write_text('\n'.join(L), encoding='utf-8')
print(collections.Counter((r['category'], r['verdict']) for r in rows))
