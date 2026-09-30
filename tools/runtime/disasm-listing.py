#!/usr/bin/env python3
"""Convert a raw live-disasm JSON capture into a clean ascending RVA listing.

Merges branch-guide segments, deduplicates addresses, and marks gaps.
Usage: disasm-listing.py <raw.json>   -> writes <raw>.txt next to it
"""
import json, sys
from pathlib import Path
BASE = 0x09139D00


def main():
    src = Path(sys.argv[1])
    dst = src.with_suffix(".txt")
    seen = {}
    for line in src.read_text().splitlines():
        line = line.strip()
        if not line.startswith("{"):
            continue
        d = json.loads(line)
        if d.get("type") != "opcode":
            continue
        seen[d["address"]] = d
    out, prev = [], None
    for a in sorted(seen):
        d = seen[a]
        if prev is not None and a != prev + 4:
            out.append("---- gap ----")
        out.append("+0x%06X %08X  %-8s %s" % (
            a - BASE, d["encoding"] & 0xFFFFFFFF, d.get("name") or "", d.get("params") or ""))
        prev = a
    dst.write_text("\n".join(out) + "\n")
    print("wrote %s (%d instrs)" % (dst, len(seen)))


if __name__ == "__main__":
    main()
