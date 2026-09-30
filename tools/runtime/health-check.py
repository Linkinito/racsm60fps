#!/usr/bin/env python3
"""Quick health probe for the live UCES00420 session (read-only + stop counts)."""
import base64, importlib.util, struct, time
from collections import Counter
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
CLIENT = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT)
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)

def main():
    c = ws.DebuggerClient("127.0.0.1", 60907); c.connect()
    try:
        ident = ws.identity(c)
        print("state=%s base=%s" % (ident["state"], ident["module"]["base"]))
        def rd(a, s):
            return base64.b64decode(c.request("memory.read",
                {"address": a, "size": s, "replacements": False}).get("base64", ""))
        g1 = rd(0x09413400, 8); time.sleep(0.8); g2 = rd(0x09413400, 8)
        d = struct.unpack("<f", g2[:4])[0] - struct.unpack("<f", g1[:4])[0]
        print("globals delta over 0.8s: %+.4f (%s)" % (d, "OK" if abs(d) > 0.05 else "FROZEN?"))
        for rva, label, secs in ((0x151FCC, "waterfall", 1.2), (0x8CE54, "walk", 1.2)):
            c.request("cpu.breakpoint.add", {"address": 0x09139D00+rva, "enabled": True, "log": False})
            n = 0; dl = time.monotonic()+secs
            while time.monotonic() < dl and n < 200:
                st = c.request("cpu.status")
                if st.get("stepping"):
                    n += 1; c.request("cpu.resume", no_reply=True, delay_ms=5)
                else:
                    time.sleep(0.004)
            c.request("cpu.breakpoint.remove", {"address": 0x09139D00+rva})
            if c.request("cpu.status").get("stepping"):
                c.request("cpu.resume", no_reply=True, delay_ms=50)
            print("%s stops/%.1fs: %d" % (label, secs, n))
        pcs = Counter()
        for _ in range(10):
            st = c.request("cpu.status")
            pcs[((st.get("pc") or 0) - 0x09139D00) & 0xFFFFFFFF] += 1
            time.sleep(0.02)
        print("pc rvas:", ["+0x%06X x%d" % (k, v) for k, v in pcs.most_common(3)])
    finally:
        c.close()

if __name__ == "__main__":
    main()
