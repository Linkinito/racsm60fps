#!/usr/bin/env python3
"""Rank LEVEL_01 helpers shared by many entity update callbacks (static, OBSERVED shape only).

Function starts = callback RVAs from the C1 residual timing atlas plus every
direct jal target; a function spans to the next start (approximation). For each
function: direct callees, float stores to +0x30/+0x34/+0x38 (entity position,
INFERRED), float read-modify-write sites (lwc1 X,off(r) .. add/sub.s .. swc1 ..,off(r)),
reads of $f12 (incoming delta) and known timing float immediates. Helpers are
ranked by the number of distinct callbacks reaching them within DEPTH calls.
The disassembly cache is local; outputs are small JSON/Markdown summaries.

Usage: python research/scripts/shared-helper-census.py --out research/v2/shared-helpers
"""
import argparse, collections, csv, hashlib, json, re, subprocess
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
LEGACY = REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14'
PRX = LEGACY/'development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX'
OBJDUMP = LEGACY/'toolchains/pspdev-win/bin/psp-objdump.exe'
ATLAS = REPO/'research/v2/c1-residual-timing-atlas/c1-residual-timing-atlas.csv'
SHA = 'd10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571'
DEPTH = 3
TIMING_HI = {'0x3d08': '1/30', '0x3c88': '1/60', '0x41f0': '30.0', '0x4270': '60.0',
             '0x3f00': '0.5', '0x4000': '2.0'}
LINE = re.compile(r'^\s*([0-9a-f]+):\s+[0-9a-f]{8}\s+(\S+)\s*(.*)$')

def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def disassemble(cache):
    if not cache.exists():
        out = subprocess.run([str(OBJDUMP), '-d', '-j', '.text', str(PRX)], stdout=subprocess.PIPE,
                             text=True, check=True).stdout
        cache.write_text(out, encoding='utf-8')
    ins = []
    for line in cache.read_text(encoding='utf-8').splitlines():
        m = LINE.match(line)
        if m: ins.append((int(m.group(1), 16), m.group(2), m.group(3).split('<')[0].strip()))
    return ins

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--cache', type=Path, default=Path.home()/'AppData/Local/Temp/level01-text.dis')
    a = ap.parse_args()
    if sha(PRX) != SHA: raise SystemExit('vanilla LEVEL_01 hash mismatch')
    ins = disassemble(a.cache)
    classes = collections.defaultdict(list)
    for r in csv.DictReader(ATLAS.open(encoding='utf-8-sig', newline='')):
        for item in r['update_functions'].split(';'):
            if item.startswith('M01:'): classes[int(item[4:], 16)].append(r['class_name'])
    starts = set(classes)
    for _, op, arg in ins:
        if op == 'jal': starts.add(int(arg, 16))
    order = sorted(starts); idx = {addr: i for i, (addr, _, _) in enumerate(ins)}
    funcs = {}
    for n, s in enumerate(order):
        if s not in idx: continue
        end = order[n+1] if n+1 < len(order) else ins[-1][0]+4
        body = []
        i = idx[s]
        while i < len(ins) and ins[i][0] < end: body.append(ins[i]); i += 1
        funcs[s] = body
    feat = {}
    for s, body in funcs.items():
        calls = sorted({int(arg, 16) for _, op, arg in body if op == 'jal'})
        pos = [hex(ad) for ad, op, arg in body if op == 'swc1' and re.search(r',(48|52|56)\((?!sp\))', arg)]
        loads = {}; rmw = []
        for ad, op, arg in body:
            if op == 'lwc1':
                reg, mem = arg.split(',', 1)
                if '(sp)' not in mem: loads[reg] = mem
            elif op in ('add.s', 'sub.s', 'mul.s') and arg.count(',') == 2:
                d, x, y = [t.strip() for t in arg.split(',')]
                src = loads.get(x) or loads.get(y)
                if src: loads[d] = src
            elif op == 'swc1':
                reg, mem = arg.split(',', 1)
                if loads.get(reg) == mem: rmw.append(hex(ad))
        f12 = any('$f12' in arg.split(',', 1)[-1] for _, op, arg in body if op not in ('lwc1', 'mtc1'))
        consts = sorted({TIMING_HI[arg.split(',')[1].strip()] for _, op, arg in body
                         if op == 'lui' and arg.split(',')[-1].strip() in TIMING_HI})
        feat[s] = {'size': len(body), 'calls': calls, 'posStores': pos, 'floatRmw': rmw,
                   'readsF12': f12, 'timingImmediates': consts}
    reach = collections.defaultdict(set)
    for cb in classes:
        frontier, seen = {cb}, {cb}
        for _ in range(DEPTH):
            nxt = set()
            for f in frontier:
                for c in feat.get(f, {}).get('calls', []):
                    if c not in seen: seen.add(c); nxt.add(c)
            frontier = nxt
        for f in seen - {cb}: reach[f].add(cb)
    ranked = sorted(reach, key=lambda f: -len(reach[f]))
    rows = []
    for f in ranked:
        x = feat.get(f)
        if not x: continue
        rows.append({'rva': hex(f), 'callbacks': len(reach[f]),
                     'directCallbacks': sum(1 for cb in reach[f] if f in feat.get(cb, {}).get('calls', [])),
                     'size': x['size'], 'posStores': len(x['posStores']), 'floatRmw': len(x['floatRmw']),
                     'readsF12': x['readsF12'], 'timingImmediates': x['timingImmediates'],
                     'exampleClasses': sorted({n for cb in list(reach[f])[:6] for n in classes[cb]})[:6]})
    movers = [r for r in rows if (r['posStores'] or r['floatRmw']) and r['callbacks'] >= 5]
    a.out.mkdir(parents=True, exist_ok=True)
    result = {'status': 'STATIC_SHAPE_OBSERVED_SEMANTICS_INFERRED', 'prxSha256': SHA,
              'atlasSha256': sha(ATLAS), 'methodSha256': sha(__file__), 'depth': DEPTH,
              'callbacks': len(classes), 'functions': len(feat), 'topShared': rows[:60],
              'sharedMovementCandidates': movers[:60],
              'callbackSelf': [{'rva': hex(cb), 'classes': classes[cb], 'posStores': len(feat.get(cb, {}).get('posStores', [])),
                                'floatRmw': len(feat.get(cb, {}).get('floatRmw', [])),
                                'readsF12': feat.get(cb, {}).get('readsF12')} for cb in sorted(classes)]}
    (a.out/'shared-helpers.json').write_text(json.dumps(result, indent=1), encoding='utf-8')
    print(json.dumps({'callbacks': len(classes), 'functions': len(feat), 'movers': len(movers)}))

if __name__ == '__main__':
    main()
