#!/usr/bin/env python3
"""Register liveness scan over a disasm listing window.

Reads a .txt listing produced by disasm-listing.py and reports, for each
register, the instructions where it appears as a SOURCE (read) vs DEST
(written), plus the address ranges. Used to choose provably-dead scratch
registers for code caves (the v1 lesson: never guess liveness).

Usage: reg-liveness.py <listing.txt> [reg ...]
"""
import re, sys
from collections import defaultdict
from pathlib import Path

LINE = re.compile(r"^\+(0x[0-9A-F]+) ([0-9A-F]{8})\s+(\S+)\s*(.*)$")
STORES = {"sw", "sh", "sb", "swc1", "sdc1", "sdr", "swr", "swl"}
BRANCHES = {"beq", "bne", "bnel", "beql", "beql", "blez", "bgtz", "bltz", "bgez", "bgezal",
            "bltzal", "jr", "jalr", "bc1t", "bc1f", "bc1tl", "bc1fl", "c.eq", "c.lt",
            "c.le", "jal", "j", "b"}
LOADS = {"lw", "lh", "lhu", "lb", "lbu", "lwc1", "ldc1", "lwl", "lwr", "mfc1"}
MTC1 = "mtc1"


REG = re.compile(r"\b(at|zero|v[01]|a[0-3]|t[0-9]|s[0-7]|k[01]|gp|sp|fp|ra|f[0-9]{1,2})\b")


def regs_in(text):
    return REG.findall(text)


def main():
    path = Path(sys.argv[1])
    wanted = [r.lower() for r in sys.argv[2:]]
    reads = defaultdict(list)
    writes = defaultdict(list)
    for line in path.read_text().splitlines():
        m = LINE.match(line.strip())
        if not m:
            continue
        addr, enc, op, rest = m.group(1), m.group(2), m.group(3), m.group(4)
        toks = [t.strip() for t in rest.split(",") if t.strip()] if rest else []
        if op in ("nop", "----"):
            continue
        src = []
        dst = []
        if op in STORES or op in BRANCHES:
            src = toks
        elif op in LOADS:
            # lw rt, off(rs)  -> rt dest, base source
            if toks:
                dst = [toks[0]]
                src = toks[1:]
        elif op == MTC1:
            src = toks[:1]
            dst = toks[1:]
        else:
            if toks:
                dst = [toks[0]]
                src = toks[1:]
        for t in src:
            for r in regs_in(t):
                reads[r].append((addr, op))
        for t in dst:
            for r in regs_in(t):
                writes[r].append((addr, op))
    regs = wanted if wanted else sorted(set(reads) | set(writes))
    for r in regs:
        rd = reads.get(r, [])
        wr = writes.get(r, [])
        print("%-4s reads=%2d writes=%2d   reads@%s" % (
            r, len(rd), len(wr), ", ".join("%s(%s)" % (a, o) for a, o in rd[:8]) or "-"))


if __name__ == "__main__":
    main()
