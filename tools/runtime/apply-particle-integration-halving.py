#!/usr/bin/env python3
"""In-body half-step for the waterfall particle integrator (v3, safe design).

v1 failed because it skipped the animator CALL (the walker consumes v0).
v3 touches only four arithmetic instructions INSIDE the per-entry body:
  0xDE528  add.s f12,f12,f13   pos.x += vel.x   -> cave: pos.x + vel.x*0.5
  0xDE530  add.s f14,f14,f15   pos.y += vel.y   -> cave: pos.y + vel.y*0.5
  0xDE54C  add.s f12,f12,f14   pos.z += vel.z   -> cave: pos.z + vel.z*0.5
  0xDE554  sub.s f13,f16,f13   vel.y -= g      -> cave: vel.y - g*0.5
Each site becomes `jal <cave>`; the original next instruction runs as the
delay slot (verified harmless), the cave computes the halved operation using
t0 and f30 (both proven dead in this block) and returns to the instruction
after the delay slot. The call convention, prologue, epilogue and v0 are
untouched.

In C1 the body runs 60/s instead of 30/s, so pos advances by vel/2 per call
and gravity applies g/2 per call: per real second both match A0 exactly
(30*vel and 30*g). Damping ([+0x44]=1.0) and the counter stay uncorrected.

Caves live at 0x095A4760/4780/47A0/47C0 in a locally verified stable-zero
.bss run (0x095A4744, length 0x2F8). Pass-through mode keeps the original
operations in the caves to prove the mechanics before enabling the halves.

Usage:
  apply-particle-integration-halving.py --passthrough --expect-state C1
  apply-particle-integration-halving.py --apply --expect-state C1
  apply-particle-integration-halving.py --revert
  apply-particle-integration-halving.py --verify
"""
import argparse, base64, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CLIENT = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE = 0x09139D00
CAVE_ZERO = (0x093FB514, 0x1008)
SITES = [
    # target_rva, original, cave, passthrough words, active words
    # caves live in the PT_LOAD0 (R+X) unreferenced zero run at RVA 0x2C1814
    # (validated 2026-09-21, see CAVE-RAM-FINDING.md); .bss is NOT executable
    (0xDE528, 0x460D6300, 0x093FB530,
     [0x460D6300, 0x03E00008, 0x00000000],
     [0x3C083F00, 0x4488F000, 0x461E6F82, 0x461E6300, 0x03E00008, 0x00000000]),
    (0xDE530, 0x460F7380, 0x093FB550,
     [0x460F7380, 0x03E00008, 0x00000000],
     [0x3C083F00, 0x4488F000, 0x461E7F82, 0x461E7380, 0x03E00008, 0x00000000]),
    (0xDE54C, 0x460E6300, 0x093FB570,
     [0x460E6300, 0x03E00008, 0x00000000],
     [0x3C083F00, 0x4488F000, 0x461E7782, 0x461E6300, 0x03E00008, 0x00000000]),
    (0xDE554, 0x460D8341, 0x093FB590,
     [0x460D8341, 0x03E00008, 0x00000000],
     [0x3C083F00, 0x4488F000, 0x461E6F82, 0x461E8341, 0x03E00008, 0x00000000]),
]
JALS = {0xDE528: 0x0E4FED4C, 0xDE530: 0x0E4FED54, 0xDE54C: 0x0E4FED5C, 0xDE554: 0x0E4FED64}

spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT)
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)
ws.ALLOWED |= {"memory.breakpoint.list"}

class Writer(ws.DebuggerClient):
    def write_word(self, address, word):
        self.seq += 1; t = "v3-%d" % self.seq
        self._send_frame(json.dumps({"event": "memory.write_u32", "ticket": t,
                                     "address": address, "value": word}).encode())
        dl = time.monotonic() + 10
        while True:
            r = json.loads(self._recv_message())
            if r.get("ticket") == t:
                if r.get("event") == "error": raise RuntimeError(str(r))
                return
            if time.monotonic() > dl: raise RuntimeError("write timeout")


def read_bytes(c, address, size):
    return base64.b64decode(c.request("memory.read",
        {"address": address, "size": size, "replacements": False}).get("base64", ""))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--passthrough", action="store_true")
    ap.add_argument("--revert", action="store_true")
    ap.add_argument("--verify", action="store_true")
    ap.add_argument("--expect-state", default=None)
    ap.add_argument("--json-out", default=None)
    ap.add_argument("--only", default=None,
                    help="comma list of site RVAs to patch (default: all)")
    args = ap.parse_args()
    if sum((args.apply, args.passthrough, args.revert, args.verify)) != 1:
        ap.error("choose exactly one mode")
    if args.only:
        global SITES
        wanted = {int(x, 0) for x in args.only.split(",")}
        SITES = [site for site in SITES if site[0] in wanted]
        if not SITES:
            ap.error("no site matched --only")
    mode = ("apply" if args.apply else "passthrough" if args.passthrough
            else "revert" if args.revert else "verify")
    c = Writer("127.0.0.1", 60907); c.connect()
    rec = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
           "tool": "apply-particle-integration-halving.py", "mode": mode, "result": None}
    written = []
    try:
        active = [m for m in c.request("hle.module.list").get("modules", [])
                  if m.get("name") == "rcp1" and m.get("isActive")]
        if len(active) != 1 or active[0]["address"] != BASE:
            raise RuntimeError("wrong module base")
        rec["state"] = ws.decode_state(c, BASE)["state"]
        if args.expect_state and rec["state"] != args.expect_state:
            raise RuntimeError("state %s != %s" % (rec["state"], args.expect_state))
        if c.request("cpu.breakpoint.list").get("breakpoints"):
            raise RuntimeError("code breakpoints active")
        site_words = {rva: ws.read_word(c, BASE + rva) for rva, *_ in SITES}
        rec["observed"] = {"0x%06X" % k: "0x%08X" % v for k, v in site_words.items()}
        if mode == "verify":
            if all(site_words[rva] == orig for rva, orig, *_ in SITES):
                rec["verdict"] = "VANILLA"
            elif all(site_words[rva] == JALS[rva] for rva, *_ in SITES):
                rec["verdict"] = "PATCHED"
            else:
                rec["verdict"] = "OTHER"
            rec["result"] = "PASS"
        elif mode in ("apply", "passthrough"):
            for rva, orig, *_ in SITES:
                if site_words[rva] != orig:
                    raise RuntimeError("site 0x%06X not vanilla (0x%08X)"
                                       % (rva, site_words[rva]))
            if any(read_bytes(c, CAVE_ZERO[0], CAVE_ZERO[1])):
                raise RuntimeError("cave region not zero")
            for rva, orig, cave, passw, actw in SITES:
                for i, w in enumerate(passw if mode == "passthrough" else actw):
                    c.write_word(cave + 4 * i, w)
                    written.append((cave + 4 * i, 0))
            for rva, orig, cave, passw, actw in SITES:
                c.write_word(BASE + rva, JALS[rva])
                written.append((BASE + rva, orig))
            for rva, orig, cave, passw, actw in SITES:
                if ws.read_word(c, BASE + rva) != JALS[rva]:
                    raise RuntimeError("patch read-back failed 0x%06X" % rva)
            rec["result"] = "PASS"
        else:
            for rva, orig, cave, passw, actw in SITES:
                if site_words[rva] != JALS[rva]:
                    raise RuntimeError("site 0x%06X not patched" % rva)
            for rva, orig, cave, passw, actw in SITES:
                c.write_word(BASE + rva, orig)
                written.append((BASE + rva, JALS[rva]))
            cave_area = read_bytes(c, CAVE_ZERO[0], CAVE_ZERO[1])
            for off in range(0, CAVE_ZERO[1], 4):
                w = int.from_bytes(cave_area[off:off + 4], "little")
                if w:
                    c.write_word(CAVE_ZERO[0] + off, 0)
                    written.append((CAVE_ZERO[0] + off, w))
            rec["result"] = "PASS"
    except Exception as e:
        rec["error"] = str(e)
        for addr, orig in written:
            try:
                c.write_word(addr, orig)
            except Exception:
                pass
        rec["result"] = "FAILED"
        raise
    finally:
        c.close()
        if args.json_out:
            p = Path(args.json_out)
            if not p.is_absolute():
                p = REPO / p
            p.write_text(json.dumps(rec, indent=1), encoding="utf-8")
        print(json.dumps({k: rec.get(k) for k in
                          ("result", "mode", "state", "verdict", "observed", "error")},
                         sort_keys=True))


if __name__ == "__main__":
    main()
