#!/usr/bin/env python3
"""Inventory LEVEL_01 particle pools from the local full decompilation (static).

Every call to the pool registration FUN_0008ba64(handle, id, animator, recordSize, ...)
is extracted (multi-line aware). For each registering function, the classes whose
descriptor functions reach it (callee graph, depth 4) are listed, and each animator
is scanned with scan-decompiled.py rules. Output (no code): animator address, record
size, registering function, reaching classes, fixed-step kinds and fields.
Usage: python research/scripts/particle-inventory.py --all <dir> --classes <table> --out <dir>
"""
import argparse, collections, hashlib, importlib.util, json, re
from pathlib import Path

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('scan', HERE/'scan-decompiled.py'); scan = importlib.util.module_from_spec(spec); spec.loader.exec_module(scan)

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--all', type=Path, required=True); ap.add_argument('--classes', type=Path, required=True)
    ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args()
    index = json.loads((a.all/'index.json').read_text(encoding='utf-8'))
    names = {r['name']: r['rva'] for r in index}
    callers = collections.defaultdict(set)
    for r in index:
        for c in r['callees']: callers[c].add(r['rva'])
    table = json.loads(a.classes.read_text(encoding='utf-8'))['classes']
    callees = {r['rva']: r['callees'] for r in index}
    reach = collections.defaultdict(set)
    for c in table:
        frontier = {x for x in c['code'] + c['extra'] if x}
        for f in frontier: reach[f].add(c['class'])
        for _ in range(4):
            nxt = set()
            for f in frontier:
                for g in callees.get(f, []):
                    if c['class'] not in reach[g]: reach[g].add(c['class']); nxt.add(g)
            frontier = nxt
    pools = []
    for f in sorted(a.all.glob('c/*.c')):
        text = f.read_text(encoding='utf-8', errors='replace')
        for m in re.finditer(r'FUN_0008ba64\(([^;]*?)\);', text, re.S):
            args = [x.strip() for x in re.sub(r'\s+', ' ', m.group(1)).split(',')]
            anim = args[2] if len(args) > 2 else '?'
            am = re.search(r'(?:FUN_|LAB_)([0-9a-f]+)', anim)
            anim_rva = hex(int(am.group(1), 16)) if am else names.get(anim.lstrip('&'), anim)
            reg = f.stem
            # classes reaching the registering function, directly or one caller up
            cls = set(reach.get(reg, ()))
            for up in callers.get(reg, ()): cls |= reach.get(up, set())
            kinds, fields = {}, []
            af = a.all/'c'/(anim_rva+'.c')
            if af.exists():
                hits, delta = scan.scan(af.read_text(encoding='utf-8', errors='replace'))
                kinds = dict(collections.Counter(h['kind'] for h in hits if h['kind'] != 'frame_const'))
                fields = sorted({h['field'] for h in hits if h['field'] and h['kind'] in ('field_accum', 'float_const', 'int_step')})
            pools.append({'animator': anim_rva, 'animatorName': anim, 'recordSize': args[3] if len(args) > 3 else '?',
                          'registeredBy': reg, 'classes': sorted(cls), 'animatorKinds': kinds, 'animatorFields': fields})
    out = {'status': 'STATIC_INVENTORY_OBSERVED_ROLES_INFERRED', 'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'registrationFunction': '0x8ba64', 'pools': pools}
    a.out.mkdir(parents=True, exist_ok=True)
    (a.out/'level01-particle-pools.json').write_text(json.dumps(out, indent=1), encoding='utf-8')
    print(len(pools), 'pools;', len({p['animator'] for p in pools}), 'animators')
    for p in pools: print(p['animator'], p['recordSize'], p['registeredBy'], p['animatorKinds'], ','.join(p['classes'][:5]))

if __name__ == '__main__':
    main()
