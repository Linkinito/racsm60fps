#!/usr/bin/env python3
"""Read-only live inspector: register snapshots and disassembly windows.

Usage:
  live-inspect.py regs [n]            # n register snapshots (default 6)
  live-inspect.py disasm <addr> [n]   # n instructions (default 32)
"""
import importlib.util, json, sys, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
CLIENT = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT)
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)


def regs(c):
    d = {}
    for cat in c.request("cpu.getAllRegs").get("categories", []):
        for n, v in zip(cat.get("registerNames", []), cat.get("uintValues", [])):
            d.setdefault(n.lower(), v)
    return d


def main():
    c = ws.DebuggerClient("127.0.0.1", 60907); c.connect()
    try:
        cmd = sys.argv[1] if len(sys.argv) > 1 else "regs"
        if cmd == "regs":
            n = int(sys.argv[2]) if len(sys.argv) > 2 else 6
            for _ in range(n):
                d = regs(c)
                print("pc=0x%08X ra=0x%08X sp=0x%08X v0=0x%08X v1=0x%08X "
                      "a0=0x%08X t0=0x%08X k1=0x%08X" % (
                          d.get("pc", 0), d.get("ra", 0), d.get("sp", 0), d.get("v0", 0),
                          d.get("v1", 0), d.get("a0", 0), d.get("t0", 0), d.get("k1", 0)))
                time.sleep(0.08)
        elif cmd == "disasm":
            addr = int(sys.argv[2], 0)
            count = int(sys.argv[3]) if len(sys.argv) > 3 else 32
            r = c.request("memory.disasm", {"address": addr, "count": count})
            print("reply keys: %s" % sorted(r.keys()))
            for ln in r.get("lines", []):
                print(json.dumps(ln))
    finally:
        c.close()


if __name__ == "__main__":
    main()
