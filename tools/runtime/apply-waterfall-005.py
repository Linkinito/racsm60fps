#!/usr/bin/env python3
"""Phase-2 half-step for the 0x40-stride effect walker (mist / river surfaces).

Function `base+0xDE8A8` (0xDE8A8..0xDEC94, runs 29.97/s A0 -> 59.94/s in C1)
integrates the 0x40-stride record pools (DEC9C-family rings, e.g. the mist)
and emits their vertex strip.  Its per-call accumulations must advance at the
A0 rate in C1, exactly like the droplet walker fixed by apply-waterfall-004:

  0xDE980  counter  : t7[0x1C] -= t7[0x20]   (borders a c.le/bc1f -> special)
  0xDEA78  pos.x    : t7[0x00] += t7[0x0C]
  0xDEA88  pos.y    : t7[0x04] += t7[0x10]
  0xDEA98  pos.z    : t7[0x08] += t7[0x14]
  0xDEAE8  field+24 : f9      -= t7[0x2C]
  0xDEAF0  rot      : t7[0x18] += t7[0x34]
  0xDEAF8  phase    : t7[0x28] += rate (stack param)

Each site becomes `j <cave>` (ra-free, same proven mechanism as v5); the
original next instruction is the delay slot (all verified harmless, see the
report).  For 0xDE980 the whole counter compare is replicated inside the
cave because its delay slot IS the comparison.

Scratch: `at` (zero uses in the whole function) and `f31` (zero uses, not in
the function's saved set) with an explicit `swc1 f31,-4(sp)` save/restore in
every stub so no ABI-visible register changes.

Caves live at 0x093FB600..0x093FB70F (PT_LOAD0 zero run, disjoint from the
v5 stubs at 0x093FB530..0x093FB5AF).

WARNING (2026-09-26, first live application): within ~2 s of applying all
seven sites the game froze (globals stopped, emitter stop-burst 135/s) and
then the process reset.  Apply/revert read-backs were clean and the code
analysis found no structural fault, so ONE of the seven sites (or their
combination) is unsafe - cause UNKNOWN.  Do NOT re-apply all seven at once:
isolate one site at a time with a health check between (protocol in
CURRENT_STATE.md / report s.12).

Usage:
  apply-waterfall-005.py --apply --expect-state C1 [--json-out ...]
  apply-waterfall-005.py --revert [--json-out ...]
  apply-waterfall-005.py --verify
"""
import argparse, base64, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CLIENT = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE = 0x09139D00
CAVE_BASE = 0x093FB600
DATA_HALF = 0x093FB700
CAVE_SPAN = (CAVE_BASE, 0x110)
NOP = 0x00000000

AT, SP, F31 = 1, 29, 31
FP_S, MUL_S, ADD_S, SUB_S, C_LE_S = 16, 0x02, 0x00, 0x01, 0x3E


def fpop(funct, ft, fs, fd=0):
    return (0x11 << 26) | (FP_S << 21) | (ft << 16) | (fs << 11) | (fd << 6) | funct


def lwc1(ft, imm, base):
    return (0x31 << 26) | (base << 21) | (ft << 16) | (imm & 0xFFFF)


def swc1(ft, imm, base):
    return (0x39 << 26) | (base << 21) | (ft << 16) | (imm & 0xFFFF)


def lui(rt, imm):
    return (0x0F << 26) | (rt << 16) | (imm & 0xFFFF)


def jmp(addr):
    return (0x02 << 26) | ((addr >> 2) & 0x03FFFFFF)


def bc1f(target, pc):
    return (0x11 << 26) | (8 << 21) | (((target - (pc + 4)) >> 2) & 0xFFFF)


AT_HI = (DATA_HALF + 0x8000) >> 16          # 0x0940: keeps the offset in int16
OFF_HALF = (DATA_HALF - (AT_HI << 16)) & 0xFFFF


def std_stub(cave, addend, op_word, ret):
    return [lui(AT, AT_HI), swc1(F31, -4, SP), lwc1(F31, OFF_HALF, AT),
            fpop(MUL_S, F31, addend, F31), op_word, lwc1(F31, -4, SP),
            jmp(ret), NOP]


def s1_stub(cave):
    pc_bc = cave + 8 * 4
    return [lui(AT, AT_HI), swc1(F31, -4, SP), lwc1(F31, OFF_HALF, AT),
            fpop(MUL_S, F31, 13, F31), fpop(ADD_S, F31, 12, 12),
            lwc1(F31, -4, SP), fpop(C_LE_S, 11, 12),
            NOP, bc1f(0x09218750, pc_bc), swc1(12, 0x1C, 15),
            jmp(0x09218690), NOP]


# built at import; word-level assertions against the known live originals
SITES = [
    (0xDE980, 0x460B603E,          # c.le f12,f11  (special: counter compare)
     CAVE_BASE + 0x0C0, s1_stub(CAVE_BASE + 0x0C0)),
    (0xDEA78, fpop(ADD_S, 14, 13, 13), CAVE_BASE + 0x000,
     std_stub(CAVE_BASE + 0x000, 14, fpop(ADD_S, F31, 13, 13), 0x09218780)),
    (0xDEA88, fpop(ADD_S, 16, 15, 15), CAVE_BASE + 0x020,
     std_stub(CAVE_BASE + 0x020, 16, fpop(ADD_S, F31, 15, 15), 0x09218790)),
    (0xDEA98, fpop(ADD_S, 18, 17, 13), CAVE_BASE + 0x040,
     std_stub(CAVE_BASE + 0x040, 18, fpop(ADD_S, F31, 17, 13), 0x092187A0)),
    (0xDEAE8, fpop(SUB_S, 14, 9, 9),  CAVE_BASE + 0x060,
     std_stub(CAVE_BASE + 0x060, 14, fpop(SUB_S, F31, 9, 9), 0x092187F0)),
    (0xDEAF0, fpop(ADD_S, 0, 16, 12),  CAVE_BASE + 0x080,
     std_stub(CAVE_BASE + 0x080, 0, fpop(ADD_S, F31, 16, 12), 0x092187F8)),
    (0xDEAF8, fpop(ADD_S, 7, 13, 7),   CAVE_BASE + 0x0A0,
     std_stub(CAVE_BASE + 0x0A0, 7, fpop(ADD_S, F31, 13, 7), 0x09218800)),
]
assert SITES[1][1] == 0x460E6B40 and SITES[2][1] == 0x46107BC0
assert SITES[3][1] == 0x46128B40 and SITES[4][1] == 0x460E4A41
assert SITES[5][1] == 0x46008300 and SITES[6][1] == 0x460769C0
assert SITES[0][3][8] == bc1f(0x09218750, SITES[0][2] + 0x20)

spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT)
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)
ws.ALLOWED |= {"memory.breakpoint.list"}


class Writer(ws.DebuggerClient):
    def write_word(self, address, word):
        self.seq += 1; t = "w5-%d" % self.seq
        self._send_frame(json.dumps({"event": "memory.write_u32", "ticket": t,
                                     "address": address, "value": word}).encode())
        dl = time.monotonic() + 10
        while True:
            r = json.loads(self._recv_message())
            if r.get("ticket") == t:
                if r.get("event") == "error":
                    raise RuntimeError(str(r))
                return
            if time.monotonic() > dl:
                raise RuntimeError("write timeout")


def read_bytes(c, address, size):
    return base64.b64decode(c.request("memory.read",
        {"address": address, "size": size, "replacements": False}).get("base64", ""))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--revert", action="store_true")
    ap.add_argument("--verify", action="store_true")
    ap.add_argument("--expect-state", default=None)
    ap.add_argument("--json-out", default=None)
    args = ap.parse_args()
    if sum((args.apply, args.revert, args.verify)) != 1:
        ap.error("choose exactly one mode")
    mode = "apply" if args.apply else "revert" if args.revert else "verify"
    c = Writer("127.0.0.1", 60907); c.connect()
    rec = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
           "tool": "apply-waterfall-005.py", "version": "phase2-mist-river",
           "mode": mode, "result": None}
    written = []

    def w(addr, word):
        c.write_word(addr, word)
        written.append(addr)

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
        patched = {rva: jmp(cave) for rva, _, cave, _ in SITES}
        rec["observed"] = {"0x%06X" % k: "0x%08X" % v for k, v in site_words.items()}
        if mode == "verify":
            if all(site_words[rva] == orig for rva, orig, *_ in SITES):
                rec["verdict"] = "VANILLA"
            elif all(site_words[rva] == patched[rva] for rva, *_ in SITES):
                rec["verdict"] = "PATCHED"
            else:
                rec["verdict"] = "OTHER"
            rec["result"] = "PASS"
        elif mode == "apply":
            for rva, orig, *_ in SITES:
                if site_words[rva] != orig:
                    raise RuntimeError("site 0x%06X not vanilla (0x%08X)"
                                       % (rva, site_words[rva]))
            if any(read_bytes(c, CAVE_SPAN[0], CAVE_SPAN[1])):
                raise RuntimeError("cave span not zero")
            for rva, orig, cave, words in SITES:
                for i, wd in enumerate(words):
                    w(cave + 4 * i, wd)
            w(DATA_HALF, 0x3F000000)          # 0.5f
            for rva, orig, cave, words in SITES:
                w(BASE + rva, patched[rva])
            for rva, orig, cave, words in SITES:
                if ws.read_word(c, BASE + rva) != patched[rva]:
                    raise RuntimeError("patch read-back failed 0x%06X" % rva)
            if ws.read_word(c, DATA_HALF) != 0x3F000000:
                raise RuntimeError("data word read-back failed")
            rec["result"] = "PASS"
        else:  # revert
            for rva, orig, cave, words in SITES:
                if site_words[rva] not in (orig, patched[rva]):
                    raise RuntimeError("site 0x%06X in unexpected state" % rva)
                w(BASE + rva, orig)
            area = read_bytes(c, CAVE_SPAN[0], CAVE_SPAN[1])
            for off in range(0, CAVE_SPAN[1], 4):
                wd = int.from_bytes(area[off:off + 4], "little")
                if wd:
                    w(CAVE_SPAN[0] + off, 0)
            rec["result"] = "PASS"
    except Exception as e:
        rec["error"] = str(e)
        for addr in reversed(written):
            try:
                if any(addr == BASE + rva for rva, *_ in SITES):
                    c.write_word(addr, {BASE + rva: orig for rva, orig, *_ in SITES}[addr])
                else:
                    c.write_word(addr, 0)
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
