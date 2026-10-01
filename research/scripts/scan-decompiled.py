#!/usr/bin/env python3
"""Scan locally decompiled LEVEL_01 C (MassDecompile.java output) for fixed-step patterns.

Static shape only (STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF). Per function:
  int_step      *(int..)(X+o) = same + 1 / - 1             frame counters (or indices)
  float_const   *(float..)(X+o) = same +/- literal         per-call float steps (life -= 1.0)
  field_accum   *(float..)(X+o) = same +/- *(float..)(...) accumulation (pos += vel)
  int_vs_float  (float)*(int..) compared                   counter vs float threshold (crab)
  frame_const   literal 1/30, 1/60, 30.0, 60.0
  delta_param   float parameter used in arithmetic           delta-aware (probably fine)
Locals assigned from a field and stored back are followed one level.
Outputs (committable, no code text): <out>/scan-summary.json with addresses,
field offsets, kinds and literals; per-class aggregation via index.json reachedFrom.
Usage: python research/scripts/scan-decompiled.py --mass <dir with c/ and index.json> --out <dir>
"""
import argparse, collections, hashlib, json, re
from pathlib import Path

DEREF = r'\*\((?:float|int|uint|short|ushort|undefined4|byte|char) \*\)\s*\(([^;=]+?)\)'
STORE = re.compile(r'^\s*(' + DEREF + r')\s*=\s*(.+);\s*$')
LOCAL = re.compile(r'^\s*(\w+)\s*=\s*(' + DEREF + r')\s*;\s*$')
FLOAT_LIT = r'-?\d+\.\d+(?:e[-+]?\d+)?'
FRAME = {'0.033333335': '1/30', '0.033333': '1/30', '0.016666668': '1/60', '0.016667': '1/60', '30.0': '30.0', '60.0': '60.0'}

def offset(lhs):
    m = re.search(r'\+\s*(0x[0-9a-f]+|\d+)\)\s*$', lhs.strip())
    return m.group(1) if m else '0'

ASSIGN = re.compile(r'^\s*([^=!<>]+?)\s*=\s*([^=].*);\s*$')
CMP_THRESH = re.compile(r'(DAT_[0-9a-f]+)\s*(<=|<|>=|>)\s*\(float\)|\(float\)\s*[\w*()+ ]+?\s*(<=|<|>=|>)\s*(DAT_[0-9a-f]+)')

LVAL = re.compile(r'^(\*\(.+\)|[A-Za-z_]\w*\[[^\]]+\]|\*[A-Za-z_]\w*)$')

def lval_info(lhs, decls):
    """Return (type tag, field offset) for a memory lvalue, else None."""
    if lhs.startswith('*('):
        t = 'float' if 'float' in lhs.split(')', 1)[0] else 'int' if re.search(r'int|short|char|undefined4', lhs.split(')', 1)[0]) else '?'
        return t, offset(lhs)
    m = re.fullmatch(r'\*?([A-Za-z_]\w*)(?:\[([^\]]+)\])?', lhs)
    if not m: return None
    t = decls.get(m.group(1), '?')
    idx = m.group(2) or '0'
    try: off = hex(int(idx, 0) * 4) if t in ('float', 'int') else idx
    except ValueError: off = idx
    return t, off

def scan(code):
    hits = []; locals_ = {}
    header = code.split('{', 1)[0]
    fparams = re.findall(r'float\s+(param_\d+)', header)
    decls = {}
    for t, v in re.findall(r'^\s*(float|int|uint|short|ushort|byte|char|undefined4)\s*\*\s*(\w+);', code, re.M):
        decls[v] = 'float' if t == 'float' else 'int'
    for ln in code.splitlines():
        am = ASSIGN.match(ln)
        if am:
            lhs, rhs = am.group(1).strip(), am.group(2).strip()
            if re.fullmatch(r'[A-Za-z_]\w*', lhs):
                locals_.setdefault(lhs, []).append(rhs)   # branch-insensitive: keep every assignment
                continue
            if not LVAL.match(lhs): continue
            info = lval_info(lhs, decls)
            if not info: continue
            cands = [rhs]
            first = re.match(r'([A-Za-z_]\w*)(.*)$', rhs)
            if first and any(e.strip() == lhs for e in locals_.get(first.group(1), [])):
                cands.append(lhs + first.group(2))
            if re.fullmatch(r'[A-Za-z_]\w*', rhs):
                for e in locals_.get(rhs, []):
                    cands.append(e)
                    f2 = re.match(r'([A-Za-z_]\w*)(.*)$', e)
                    if f2 and any(x.strip() == lhs for x in locals_.get(f2.group(1), [])): cands.append(lhs + f2.group(2))
            rhs_x = next((c for c in cands if c.startswith(lhs) and c[len(lhs):].strip()[:1] in ('+', '-')), None)
            if rhs_x is None: continue
            rest = rhs_x[len(lhs):].strip(); op = rest[:1]; operand = rest[1:].strip()
            if op not in '+-' or not operand: continue
            t, off = info; kind = None
            if re.fullmatch(r'-?1', operand) and t == 'int': kind = 'int_step'
            elif re.fullmatch(FLOAT_LIT, operand) or operand.startswith('DAT_'): kind = 'float_const'
            elif t == 'float' and (re.search(r'\*\(|\w\[', operand)): kind = 'field_accum'
            if any(re.search(r'\b%s\b' % p, operand) for p in fparams): kind = 'delta_step'
            if kind:
                hits.append({'kind': kind, 'field': off, 'op': op,
                             'literal': operand if kind in ('float_const', 'int_step') else None})
        tm = CMP_THRESH.search(ln)
        if tm:
            hits.append({'kind': 'int_vs_float', 'field': None, 'op': None, 'literal': tm.group(1) or tm.group(4)})
        for lit in re.findall(FLOAT_LIT, ln):
            if lit.lstrip('-') in FRAME: hits.append({'kind': 'frame_const', 'field': None, 'op': None, 'literal': FRAME[lit.lstrip('-')]})
    body = code.split('{', 1)[1] if '{' in code else ''
    uses_delta = any(re.search(r'\b%s\b' % p, body) for p in fparams)
    return hits, uses_delta

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--mass', type=Path, required=True); ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--classes', type=Path, help='class table (needed for full-module exports)')
    ap.add_argument('--depth', type=int, default=4)
    a = ap.parse_args()
    index = json.loads((a.mass/'index.json').read_text(encoding='utf-8'))
    if a.classes and index and 'reachedFrom' not in index[0]:
        # Full-module export: derive class reachability from every descriptor slot.
        table = json.loads(a.classes.read_text(encoding='utf-8'))['classes']
        callees = {r['rva']: r['callees'] for r in index}
        reach = collections.defaultdict(set)
        for c in table:
            roots = [x for x in c['code'] + c['extra'] if x]
            frontier = set(roots)
            for f in frontier: reach[f].add(c['class'])
            for _ in range(a.depth):
                nxt = set()
                for f in frontier:
                    for g in callees.get(f, []):
                        if c['class'] not in reach[g]: reach[g].add(c['class']); nxt.add(g)
                frontier = nxt
        updates = {c['update']: c['class'] for c in table}
        for r in index:
            r['reachedFrom'] = sorted(reach.get(r['rva'], ())); r['update'] = updates.get(r['rva'])
    funcs = {}; per_class = collections.defaultdict(collections.Counter)
    for row in index:
        f = a.mass/'c'/(row['rva']+'.c')
        if not f.exists(): continue
        hits, delta = scan(f.read_text(encoding='utf-8', errors='replace'))
        kinds = collections.Counter(h['kind'] for h in hits)
        funcs[row['rva']] = {'update': row['update'], 'size': row['size'], 'usesDelta': delta,
                             'kinds': dict(kinds), 'hits': hits[:60], 'reachedFrom': row['reachedFrom'][:40]}
        for cls in row['reachedFrom']:
            per_class[cls].update(kinds)
    shared = sorted(((r, v) for r, v in funcs.items() if len(v['reachedFrom']) >= 5 and
                     (v['kinds'].get('field_accum') or v['kinds'].get('float_const') or v['kinds'].get('int_step'))),
                    key=lambda kv: -len(kv[1]['reachedFrom']))
    out = {'status': 'STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF',
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           'functions': len(funcs), 'totals': dict(sum((collections.Counter(v['kinds']) for v in funcs.values()), collections.Counter())),
           'perClass': {k: dict(v) for k, v in sorted(per_class.items())},
           'sharedFixedStepHelpers': [{'rva': r, 'classes': len(v['reachedFrom']), 'kinds': v['kinds'], 'usesDelta': v['usesDelta']} for r, v in shared[:80]],
           'functionsDetail': funcs}
    a.out.mkdir(parents=True, exist_ok=True)
    (a.out/'scan-summary.json').write_text(json.dumps(out, indent=1), encoding='utf-8')
    print(json.dumps({'functions': out['functions'], 'totals': out['totals'], 'shared': len(shared)}))

if __name__ == '__main__':
    main()
