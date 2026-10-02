#!/usr/bin/env python3
"""Minimal MIPS32 (Allegrex) decoder shared by the static analysis scripts.

Purpose: the offline passes need to read instruction context (which register
holds a pointer, which register is compared against a literal, whether a branch
is taken on a float compare) without a full disassembler. This module decodes
the subset used by the project's scanners and marks everything else
`UNKNOWN_OP`, so callers never mistake an undecoded word for a semantic claim.

Read-only over the caller's bytes; no file or emulator access here.

Usage as a library:
    from mips_subset import decode_range, Insn
    for insn in decode_range(data, off, count): print(insn)

Usage as a CLI (RVA is module-file relative, calibration defaults to +0x74):
    python research/scripts/mips_subset.py --prx <path> --rva 0x6B9B8 --before 20
"""
import argparse
import os
import struct

CAL_DEFAULT = 0x74  # PT_LOAD0: file offset = RVA + 0x74 (validated 2026-09-21)

REG_NAMES = ['zero', 'at', 'v0', 'v1', 'a0', 'a1', 'a2', 'a3',
             't0', 't1', 't2', 't3', 't4', 't5', 't6', 't7',
             's0', 's1', 's2', 's3', 's4', 's5', 's6', 's7',
             't8', 't9', 'k0', 'k1', 'gp', 'sp', 'fp', 'ra']

SPECIAL = {0x00: 'sll', 0x02: 'srl', 0x03: 'sra', 0x04: 'sllv', 0x06: 'srlv',
           0x08: 'jr', 0x09: 'jalr', 0x10: 'mfhi', 0x12: 'mflo', 0x18: 'mult',
           0x19: 'multu', 0x1A: 'div', 0x1B: 'divu', 0x20: 'add', 0x21: 'addu',
           0x22: 'sub', 0x23: 'subu', 0x24: 'and', 0x25: 'or', 0x26: 'xor',
           0x27: 'nor', 0x2A: 'slt', 0x2B: 'sltu', 0x0C: 'syscall', 0x0D: 'break',
           0x2E: 'rotr', 0x38: 'ext', 0x3B: 'rdhwr', 0x39: 'ins'}

COP1_S = {0x00: 'add.s', 0x01: 'sub.s', 0x02: 'mul.s', 0x03: 'div.s',
          0x04: 'sqrt.s', 0x05: 'abs.s', 0x06: 'mov.s', 0x07: 'neg.s',
          0x0C: 'round.w.s', 0x0D: 'trunc.w.s', 0x0E: 'ceil.w.s',
          0x0F: 'floor.w.s', 0x20: 'cvt.s.w', 0x24: 'cvt.w.s',
          0x30: 'c.f.s', 0x31: 'c.un.s', 0x32: 'c.eq.s', 0x33: 'c.ueq.s',
          0x34: 'c.olt.s', 0x35: 'c.ult.s', 0x36: 'c.ole.s', 0x37: 'c.ule.s',
          0x3C: 'c.lt.s', 0x3E: 'c.le.s'}


class Insn(object):
    __slots__ = ('rva', 'word', 'op', 'mnem', 'rt', 'rs', 'rd', 'imm',
                 'target', 'simm')

    def __init__(self, rva, word, **kw):
        self.rva = rva
        self.word = word
        self.op = kw.get('op', 'UNKNOWN_OP')
        self.mnem = kw.get('mnem', 'UNKNOWN_OP')
        self.rt = kw.get('rt')
        self.rs = kw.get('rs')
        self.rd = kw.get('rd')
        self.imm = kw.get('imm')
        self.simm = kw.get('simm')
        self.target = kw.get('target')

    def __repr__(self):
        return '0x%06X %08X %s' % (self.rva, self.word, self.text())

    def text(self):
        r = lambda x: REG_NAMES[x] if isinstance(x, int) and 0 <= x < 32 else '?'
        m = self.mnem
        if m == 'UNKNOWN_OP':
            return 'unknown 0x%08X' % self.word
        if m in ('lui', 'ori', 'andi', 'xori', 'addiu', 'addi', 'slti', 'sltiu'):
            return '%s %s,%s,%s' % (m, r(self.rt), r(self.rs),
                                    hex(self.simm) if self.simm is not None else hex(self.imm or 0))
        if m in ('lw', 'sw', 'lb', 'lbu', 'sb', 'lh', 'lhu', 'sh', 'lwc1', 'swc1', 'll', 'sc'):
            return '%s %s,%s(%s)' % (m, r(self.rt), hex(self.simm or 0), r(self.rs))
        if m in ('beq', 'bne'):
            return '%s %s,%s,0x%06X' % (m, r(self.rs), r(self.rt), self.target or 0)
        if m in ('blez', 'bgtz', 'bltz', 'bgez', 'bltzal', 'bgezal'):
            return '%s %s,0x%06X' % (m, r(self.rs), self.target or 0)
        if m in ('j', 'jal'):
            return '%s 0x%06X' % (m, self.target or 0)
        if m == 'jalr':
            # jalr rs, rd : the link register is the rd field, not rt.
            return '%s %s,%s' % (m, r(self.rd), r(self.rs))
        if m in ('jr', 'mult', 'multu', 'div', 'divu'):
            return '%s %s,%s' % (m, r(self.rs), r(self.rt))
        if m in ('sll', 'srl', 'sra', 'rotr'):
            return '%s %s,%s,%d' % (m, r(self.rd), r(self.rt), self.imm or 0)
        if m in ('add', 'addu', 'sub', 'subu', 'and', 'or', 'xor', 'nor', 'slt', 'sltu'):
            return '%s %s,%s,%s' % (m, r(self.rd), r(self.rs), r(self.rt))
        if m.startswith('c.') or (self.op == 'COP1' and self.mnem.startswith('c.')):
            return '%s f%d,f%d' % (m, self.rs or 0, self.rt or 0)
        if m in ('mfc1', 'mtc1', 'cfc1', 'ctc1', 'mfc0'):
            return '%s %s,f%d' % (m, r(self.rt), (self.rd if self.rd is not None else self.rs) or 0)
        if m in ('bc1f', 'bc1t'):
            return '%s 0x%06X' % (m, self.target or 0)
        if self.op == 'COP1':
            return '%s f%d,f%d,f%d' % (m, self.rd or 0, self.rs or 0, self.rt or 0)
        if m in ('sync', 'nop', 'syscall', 'break'):
            return m
        return m


def decode_word(rva, w):
    op = w >> 26
    rs = (w >> 21) & 31
    rt = (w >> 16) & 31
    rd = (w >> 11) & 31
    imm = w & 0xFFFF
    simm = imm - 0x10000 if imm & 0x8000 else imm
    tgt = ((rva + 4) & 0xF0000000) | ((w & 0x03FFFFFF) << 2)

    def mk(mnem, **kw):
        kw.setdefault('rs', rs)
        kw.setdefault('rt', rt)
        kw.setdefault('rd', rd)
        kw.setdefault('imm', imm)
        kw.setdefault('simm', simm)
        return Insn(rva, w, mnem=mnem, **kw)

    if w == 0:
        return mk('nop')
    if op == 0x00:
        fn = w & 0x3F
        m = SPECIAL.get(fn)
        if m is None:
            return Insn(rva, w)
        if m in ('sll', 'srl', 'sra', 'rotr'):
            return mk(m, imm=(w >> 6) & 31)
        if m in ('jr', 'jalr'):
            return mk(m, rs=(w >> 21) & 31, rd=rd)
        if m in ('mfhi', 'mflo'):
            return mk(m, rd=rd)
        if m in ('mult', 'multu', 'div', 'divu'):
            return mk(m)
        return mk(m)
    if op == 0x01:
        return mk({0: 'bltz', 1: 'bgez', 16: 'bltzal', 17: 'bgezal'}.get(rt, 'REGIMM?'),
                  target=rva + 4 + (simm << 2))
    if op in (0x02, 0x03):
        return mk('j' if op == 2 else 'jal', target=tgt)
    if op in (0x04, 0x05):
        return mk('beq' if op == 4 else 'bne', target=rva + 4 + (simm << 2))
    if op in (0x06, 0x07):
        return mk('blez' if op == 6 else 'bgtz', target=rva + 4 + (simm << 2))
    if op == 0x08:
        return mk('addi')
    if op == 0x09:
        return mk('addiu')
    if op == 0x0A:
        return mk('slti')
    if op == 0x0B:
        return mk('sltiu')
    if op == 0x0C:
        return mk('andi')
    if op == 0x0D:
        return mk('ori')
    if op == 0x0E:
        return mk('xori')
    if op == 0x0F:
        return mk('lui')
    if op == 0x10:
        return mk('COP0')
    if op == 0x11:
        # COP1 field layout: rs is either a move-control op, the BC sub-op, or
        # the data format (S=0x10, D=0x11, W=0x14, L=0x15). Treating 0x10 as a
        # move-control op silently decodes every `mov.s` as `cfc1`.
        if rs == 0x08:
            return mk('bc1f' if rt == 0 else 'bc1t', target=rva + 4 + (simm << 2))
        if rs in (0x00, 0x02, 0x04, 0x06):
            name = {0x00: 'mfc1', 0x02: 'cfc1', 0x04: 'mtc1', 0x06: 'ctc1'}[rs]
            return mk(name, rs=rd)
        if rs in (0x10, 0x11, 0x14, 0x15):
            return mk(COP1_S.get(w & 0x3F, 'COP1.fmt%d?' % rs), op='COP1', rs=rd, rt=rt)
        return mk('COP1?', op='COP1')
    if op == 0x12:
        return mk('COP2', op='COP2')
    if op in (0x20, 0x21, 0x23, 0x24, 0x25, 0x26, 0x28, 0x29, 0x2B, 0x2E):
        m = {0x20: 'lb', 0x21: 'lh', 0x23: 'lw', 0x24: 'lbu', 0x25: 'lhu',
             0x26: 'lwr', 0x28: 'sb', 0x29: 'sh', 0x2B: 'sw', 0x2E: 'swr'}[op]
        return mk(m)
    if op in (0x31, 0x35, 0x39):
        return mk({0x31: 'lwc1', 0x35: 'swc1', 0x39: 'swc1x'}[op])
    if op in (0x30, 0x34, 0x38, 0x3C):
        return mk({0x30: 'll', 0x34: 'lwl', 0x38: 'sc', 0x3C: 'swl'}[op])
    return Insn(rva, w)


def decode_range(data, off, count, base_rva=None):
    """Decode `count` words starting at file offset `off`."""
    out = []
    for i in range(count):
        o = off + 4 * i
        if o + 4 > len(data):
            break
        w, = struct.unpack_from('<I', data, o)
        rva = (base_rva + 4 * i) if base_rva is not None else o
        out.append(decode_word(rva, w))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--prx', required=True)
    ap.add_argument('--rva', required=True)
    ap.add_argument('--before', type=int, default=0)
    ap.add_argument('--count', type=int, default=20)
    ap.add_argument('--cal', default=CAL_DEFAULT, type=lambda x: int(x, 0))
    a = ap.parse_args()
    data = open(a.prx, 'rb').read()
    rva = int(a.rva, 0) - 4 * a.before
    off = rva + a.cal
    for insn in decode_range(data, off, a.count, base_rva=rva):
        print(insn)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
