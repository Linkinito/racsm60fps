#!/usr/bin/env python3
"""Locate loads of the LEVEL_01 global frame counter (0x2AF28C) in selected functions.

The counter is incremented once per frame by the level loop (0x13F0C), so functions
that use it as a clock (periodic `& 3`, `% 5`, deadlines `counter + n`, input windows)
run twice as fast at 60 Hz. For each selected function this lists every load whose
address is formed by `lui rX,hi` + `lw rY,lo(rX)` and checks that rX is used only for
counter loads until it is redefined (linear scan). Exclusive groups can be redirected
to a plugin-maintained half-rate copy by rewriting the lui immediate and load offsets.
Status STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF. Output: RVAs and words only.
Usage: python research/scripts/clock-sites.py --prx <LEVEL_01.PRX> --index <index.json> --out <json>
"""
import argparse, hashlib, json, struct
from pathlib import Path

COUNTER = 0x2AF28C
# Clock users (decompilation review 2026-10-01): periodic triggers, self-contained deadlines and
# input windows. Excluded on purpose: once-per-frame guards (`last != counter`: 0x1281C8, 0x13D9F0,
# 0x13EAF8, 0x13FCEC, 0x67D94, 0x68070), timestamps read through structures or other modules
# (0x54EFC; 0x77098/0x783B0 cache last-use stamps; 0x106698 spawn stamp in an object field).
FUNCTIONS = {
    0x104C80: 'HUD sprite rotation angle counter * k / 30', 0x8341C: 'self-contained min interval in seconds (counter / 30)',
    0x1107CC: 'AgentsGrenade_Update: counter % n trigger', 0x149284: 'spark spawn deadline counter + rand%10+10',
    0x1525C8: 'deadline check (pair with 0x1526B8)', 0x1526B8: 'deadline set counter + 5',
    0x159928: 'counter & 3 trigger', 0x15F058: 'Polarizer_Update counter & 3 trigger', 0x163274: 'counter % 5 trigger',
    0x172FB8: 'SkillPoint_L01 time window (counter - start) < 0xAC8', 0x17F24C: 'counter & 1 trigger',
    0x189ECC: 'counter % 3 trigger', 0x48A6C: 'counter & 1 trigger', 0xB5508: 'input double-press window < 4 frames',
    0x3060: 'camera input stamp (pair with 0x7168)', 0x7168: 'frames since camera input stamp',
}
LOADS = {0x23: 'lw', 0x21: 'lh', 0x25: 'lhu', 0x20: 'lb', 0x24: 'lbu'}
NO_RT_WRITE = {0x01, 0x04, 0x05, 0x06, 0x07, 0x14, 0x15, 0x16, 0x17, 0x28, 0x29, 0x2B, 0x31, 0x39, 0x11, 0x12}

def sx(v): return v - 0x10000 if v & 0x8000 else v

def reads(w):
    op = w >> 26; rs, rt = (w >> 21) & 31, (w >> 16) & 31
    if op == 0: return {rs, rt}
    if op in (0x02, 0x03, 0x0F): return set()
    if op in (0x04, 0x05, 0x28, 0x29, 0x2B): return {rs, rt}
    return {rs}

def writes(w):
    op = w >> 26
    if op == 0: return {(w >> 11) & 31}
    if op == 0x03: return {31}
    if op in NO_RT_WRITE or op == 0x02: return set()
    return {(w >> 16) & 31}

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument('--prx', type=Path, required=True); ap.add_argument('--index', type=Path, required=True)
    ap.add_argument('--out', type=Path, required=True)
    a = ap.parse_args()
    prx = a.prx.read_bytes(); size = {int(r['rva'], 16): r['size'] for r in json.loads(a.index.read_text(encoding='utf-8'))}
    word = lambda r: struct.unpack_from('<I', prx, 0x74+r)[0]
    groups = []
    for fn, role in sorted(FUNCTIONS.items()):
        end = fn + size[fn]; r = fn
        while r < end:
            w = word(r)
            if w >> 26 == 0x0F:
                reg, hi = (w >> 16) & 31, (w & 0xFFFF) << 16
                loads, other, q = [], [], r + 4
                while q < end:
                    x = word(q); op = x >> 26
                    if reg in reads(x):
                        if op in LOADS and (x >> 21) & 31 == reg and (hi + sx(x & 0xFFFF)) & 0xFFFFFFFF == COUNTER:
                            loads.append({'site': '0x%x' % q, 'word': '0x%08x' % x, 'op': LOADS[op]})
                        else:
                            other.append('0x%x' % q)
                    if reg in writes(x) and q != r: break
                    q += 4
                if loads:
                    groups.append({'function': '0x%x' % fn, 'role': role, 'lui': '0x%x' % r, 'luiWord': '0x%08x' % w,
                                   'loads': loads, 'otherUses': other, 'exclusive': not other and all(l['op'] == 'lw' for l in loads)})
            r += 4
    found = {g['function'] for g in groups}
    rec = {'status': 'STATIC_CANDIDATE_NOT_TIMING_OR_PARITY_PROOF', 'counter': '0x%x' % COUNTER,
           'methodSha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(), 'prxSha256': hashlib.sha256(prx).hexdigest(),
           'missing': ['0x%x' % f for f in FUNCTIONS if '0x%x' % f not in found], 'groups': groups}
    a.out.write_text(json.dumps(rec, indent=1)+'\n', encoding='utf-8')
    print(len(groups), 'groups,', sum(g['exclusive'] for g in groups), 'exclusive; missing', rec['missing'])

if __name__ == '__main__':
    main()
