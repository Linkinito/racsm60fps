#!/usr/bin/env python3
"""Minimal single-site cave reachability probe (apply -> verify -> auto-revert).

Patches ONE site (0xDE528) to `jal 0x093FB530` with a pass-through stub
[add.s f12,f12,f13 / jr ra / nop] in the 2026-09-21-validated PT_LOAD0 run,
then proves reachability with a breakpoint ON the cave address, reads `ra`,
runs a quick health sample, and reverts everything. Any guard failure aborts.

Usage: cave-probe.py run | cave-probe.py revert
"""
import base64, importlib.util, json, struct, sys, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
CLIENT = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE = 0x09139D00
SITE_RVA, SITE_ORIG = 0xDE528, 0x460D6300
CAVE = 0x093FB530
CAVE_WORDS = [0x460D6300, 0x03E00008, 0x00000000]
JAL = (3 << 26) | ((CAVE >> 2) & 0x03FFFFFF)
spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT)
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)

class W(ws.DebuggerClient):
    def write_word(self, address, word):
        self.seq += 1; t = "cp-%d" % self.seq
        self._send_frame(json.dumps({"event": "memory.write_u32", "ticket": t,
                                     "address": address, "value": word}).encode())
        dl = time.monotonic() + 10
        while True:
            r = json.loads(self._recv_message())
            if r.get("ticket") == t:
                if r.get("event") == "error": raise RuntimeError(str(r))
                return
            if time.monotonic() > dl: raise RuntimeError("write timeout")

def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "run"
    c = W("127.0.0.1", 60907); c.connect()
    out = {"mode": mode, "result": None}
    try:
        cur = ws.read_word(c, BASE + SITE_RVA)
        if mode == "revert":
            if cur != JAL: raise RuntimeError("site not patched (0x%08X)" % cur)
            c.write_word(BASE + SITE_RVA, SITE_ORIG)
            for i, w in enumerate(CAVE_WORDS):
                c.write_word(CAVE + 4 * i, 0)
            out["result"] = "REVERTED"
        else:
            if cur != SITE_ORIG: raise RuntimeError("site not vanilla")
            for i, w in enumerate(CAVE_WORDS):
                if ws.read_word(c, CAVE + 4 * i) != 0:
                    raise RuntimeError("cave word %d not zero" % i)
            for i, w in enumerate(CAVE_WORDS):
                c.write_word(CAVE + 4 * i, w)
            c.write_word(BASE + SITE_RVA, JAL)
            if ws.read_word(c, BASE + SITE_RVA) != JAL:
                raise RuntimeError("jal read-back failed")
            # reachability: breakpoint ON the cave
            c.request("cpu.breakpoint.add", {"address": CAVE, "enabled": True, "log": False})
            t0 = time.monotonic(); stop = None
            while time.monotonic() - t0 < 10:
                st = c.request("cpu.status")
                if st.get("stepping"): stop = st; break
                time.sleep(0.004)
            if stop:
                regs = {}
                for cat in c.request("cpu.getAllRegs").get("categories", []):
                    for n, v in zip(cat.get("registerNames", []), cat.get("uintValues", [])):
                        regs[n.lower()] = v
                out.update({"reached": True, "pc": "0x%08X" % (stop.get("pc") or 0),
                            "ra": "0x%08X" % (regs.get("ra") or 0),
                            "ticks": stop.get("ticks")})
                c.request("cpu.resume", no_reply=True, delay_ms=5)
            else:
                out["reached"] = False
            c.request("cpu.breakpoint.remove", {"address": CAVE})
            if c.request("cpu.status").get("stepping"):
                c.request("cpu.resume", no_reply=True, delay_ms=50)
            time.sleep(0.5)
            def rd(a, s):
                return base64.b64decode(c.request("memory.read",
                    {"address": a, "size": s, "replacements": False}).get("base64", ""))
            g1 = rd(0x09413400, 4); time.sleep(0.8); g2 = rd(0x09413400, 4)
            d = struct.unpack("<f", g2)[0] - struct.unpack("<f", g1)[0]
            out["globalsDelta"] = round(d, 4)
            out["healthy"] = abs(d) > 0.05
            # auto-revert
            c.write_word(BASE + SITE_RVA, SITE_ORIG)
            for i in range(len(CAVE_WORDS)):
                c.write_word(CAVE + 4 * i, 0)
            out["result"] = "PASS"
    except Exception as e:
        out["error"] = str(e); out["result"] = "FAILED"
    finally:
        c.close()
        print(json.dumps(out, sort_keys=True))

if __name__ == "__main__":
    main()
