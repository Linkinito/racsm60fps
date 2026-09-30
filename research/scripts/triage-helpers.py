#!/usr/bin/env python3
"""Per-helper float dataflow triage for shared-helper census candidates (static shape).

For each candidate: whether $f12 is read before being written (delta-like float
parameter, INFERRED), and for each float read-modify-write site (lwc1 X,m .. swc1 Y,m)
the chain of add/sub/mul operands with a coarse provenance tag:
  mem:<off(reg)>  loaded field      imm:<hex>  lui/mtc1 float immediate
  f12             incoming float argument (possibly delta)   ?  unknown
Usage: python research/scripts/triage-helpers.py --cache <dis> [--rva 0x...]
"""
import argparse, json, re
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
LINE = re.compile(r'^\s*([0-9a-f]+):\s+[0-9a-f]{8}\s+(\S+)\s*(.*)$')

def load(cache):
    ins = []
    for line in Path(cache).read_text(encoding='utf-8').splitlines():
        m = LINE.match(line)
        if m: ins.append((int(m.group(1), 16), m.group(2), m.group(3).split('<')[0].strip()))
    return ins

def body(ins, start, size):
    i = next(k for k, x in enumerate(ins) if x[0] == start)
    return ins[i:i+size]

def triage(code):
    src, gpr_imm, notes, first_f12 = {}, {}, [], None
    for ad, op, arg in code:
        ops = [t.strip() for t in arg.split(',')]
        if first_f12 is None and '$f12' in arg:
            dest_write = op in ('lwc1', 'mtc1', 'mov.s', 'add.s', 'sub.s', 'mul.s', 'div.s', 'neg.s', 'sqrt.s', 'cvt.s.w') and \
                (ops[0] == '$f12' if op != 'mtc1' else ops[1] == '$f12')
            first_f12 = 'written' if dest_write and ops.count('$f12') == 1 else 'read'
            if op == 'swc1': first_f12 = 'read'
        if op == 'lui': gpr_imm[ops[0]] = ops[1]
        elif op == 'mtc1': src[ops[1]] = 'imm:'+gpr_imm.get(ops[0], '?') if ops[0] != 'zero' else 'imm:0'
        elif op == 'lwc1':
            if '(sp)' not in ops[1]: src[ops[0]] = 'mem:'+ops[1]
            else: src[ops[0]] = 'stack'
        elif op == 'mov.s': src[ops[0]] = src.get(ops[1], 'f12' if ops[1] == '$f12' else '?')
        elif op in ('add.s', 'sub.s', 'mul.s', 'div.s') and len(ops) == 3:
            a = src.get(ops[1], 'f12' if ops[1] == '$f12' else '?')
            b = src.get(ops[2], 'f12' if ops[2] == '$f12' else '?')
            src[ops[0]] = '(%s %s %s)' % (a, op[:3], b)
        elif op == 'swc1' and '(sp)' not in ops[1]:
            val = src.get(ops[0], '?')
            if 'mem:'+ops[1] in val and ('add' in val or 'sub' in val):
                notes.append({'site': hex(ad), 'field': ops[1], 'expr': val[:160]})
    return first_f12, notes

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--cache', required=True); ap.add_argument('--rva')
    ap.add_argument('--census', default=str(REPO/'research/v2/shared-helpers/shared-helpers.json'))
    a = ap.parse_args()
    ins = load(a.cache)
    cands = json.loads(Path(a.census).read_text(encoding='utf-8'))['sharedMovementCandidates']
    for c in cands:
        if a.rva and c['rva'] != a.rva: continue
        f12, notes = triage(body(ins, int(c['rva'], 16), c['size']))
        print('== %s cb=%d size=%d f12=%s classes=%s' % (c['rva'], c['callbacks'], c['size'], f12, ','.join(c['exampleClasses'][:4])))
        for n in notes: print('   %s %s = %s' % (n['site'], n['field'], n['expr']))

if __name__ == '__main__':
    main()
