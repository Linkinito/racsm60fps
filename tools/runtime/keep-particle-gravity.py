#!/usr/bin/env python3
"""Continuously halve the per-call gravity of live waterfall droplet slots.

The particle arena rotates (live slots move and are re-initialized over time),
so a one-shot patch decays within seconds. This keeper sweeps the arena,
rewrites entry field +0x1C 0.008 -> 0.004 for slots with a droplet signature,
and repeats until the time budget ends. Read-mostly; writes only +0x1C.

Usage: keep-particle-gravity.py <seconds> [interval_s] [arena_hex]
"""
import base64, importlib.util, json, struct, sys, time
from pathlib import Path
REPO = Path(__file__).resolve().parents[2]
CLIENT = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
G008, G004 = 0x3C03126F, 0x3B83126F
ARENA, SPAN, CHUNK = 0x09D8B000, 0x39000, 0x4000
spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT)
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)

class W(ws.DebuggerClient):
    def write_word(self, address, word):
        self.seq += 1; t = "kg-%d" % self.seq
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
    seconds = float(sys.argv[1]) if len(sys.argv) > 1 else 120.0
    interval = float(sys.argv[2]) if len(sys.argv) > 2 else 0.5
    c = W("127.0.0.1", 60907); c.connect()
    t0 = time.monotonic(); sweeps = patched = 0
    try:
        while time.monotonic() - t0 < seconds:
            for off in range(0, SPAN, CHUNK):
                blob = base64.b64decode(c.request("memory.read",
                    {"address": ARENA+off, "size": CHUNK, "replacements": False}).get("base64",""))
                for pos in range(0, len(blob)-0x50, 4):
                    if struct.unpack("<I", blob[pos+0x1C:pos+0x20])[0] != G008:
                        continue
                    px, py, pz = struct.unpack("<3f", blob[pos:pos+12])
                    vy = struct.unpack("<f", blob[pos+0x10:pos+0x14])[0]
                    if 40 <= abs(px) <= 160 and -30 <= pz <= 10 and vy < 0.5:
                        c.write_word(ARENA+off+pos+0x1C, G004); patched += 1
            sweeps += 1
            time.sleep(interval)
    finally:
        c.close()
        print(json.dumps({"sweeps": sweeps, "patchedWrites": patched,
                          "seconds": round(time.monotonic()-t0, 1)}))

if __name__ == "__main__":
    main()
