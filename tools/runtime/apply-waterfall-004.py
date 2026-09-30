#!/usr/bin/env python3
"""Waterfall particle half-step v5 (ra-free) for the C1 state.

Root cause fixed here (see waterfall-003 REPORT s.10): every previous v1/v3/v4
attempt hooked a NON-call instruction with `jal`, which clobbers `ra` for the
whole enclosing function.  The water-pool walker (`0xDE23C`) returns via
`jr ra` at `0xDE8A0`; the clobbered ra (`site+8`) turned its return into an
infinite loop over the walker body (live-proven: spinning thread held
ra=0x09218230 = BASE+0xDE530).  `j` does NOT touch ra, so v5 uses:

  site (1 word)  : j <cave>           (original next instr = delay slot)
  cave (6 words) : lui at,0x3F00 / mtc1 at,f17 / mul.s f17,vel,f17 /
                   <op> dest,dest,f17 / j <return> / nop

Scratch `at` and `f17`: liveness scan over the whole function shows `at` has
zero uses; f17 (caller-saved FP temp) is dead from 0xDE528 until its next
write at 0xDE5A8.  No stack, no ra, no ABI-saved register is touched.

Per-call arithmetic halved (C1 runs this body 2x per real second):
  0xDE528  add.s f12,f12,f13   pos.x += vel.x   -> pos.x + vel.x*0.5
  0xDE530  add.s f14,f14,f15   pos.y += vel.y   -> pos.y + vel.y*0.5
  0xDE54C  add.s f12,f12,f14   pos.z += vel.z   -> pos.z + vel.z*0.5
  0xDE554  sub.s f13,f16,f13   vel.y -= g      -> vel.y -  g*0.5
Plus one constant: 0xDE344 `lui a1,0xBF80` -> `lui a1,0xBF00`, i.e. f2 =
-1.0 -> -0.5.  f2 is the walker's per-call countdown step (life +0x48,
respawn timer +0x20, loaded fresh each call at 0xDE34C): halved so slot
lifetimes and respawn intervals keep their A0 real-time duration.

Not corrected by this historical arithmetic recipe: the +0x18 scalar
add (0xDE5D0), the +0x2C/+0x30 complex rotation (0xDE5A8..0xDE5CC), damping
(+0x44 = .97 in the later bound second family). Call count is untouched;
this does not establish emission parity. The 2026-09-26 owner-bound experiment
supersedes these omissions with droplets006 and the common emitter gate.

Usage:
  apply-waterfall-004.py --apply   --expect-state C1 [--json-out ...]
  apply-waterfall-004.py --revert  [--json-out ...]
  apply-waterfall-004.py --verify
"""
import argparse, base64, hashlib, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CLIENT = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
BASE = 0x09139D00
CAVE_ZERO = (0x093FB530, 0x80)  # this tool's own stub span (0x093FB530..0x5AF)
# NB: guard/revert cover only this span so that the phase-2 tool
# (apply-waterfall-005.py, caves at 0x093FB600+) can coexist.
NOP = 0x00000000

# (site_rva, site_original, site_patched_j, cave_addr, cave_words)
SITES = [
    (0xDE528, 0x460D6300, 0x0A4FED4C, 0x093FB530, [
        0x3C013F00,  # lui   at,0x3F00
        0x44818800,  # mtc1  at,f17        ; f17 = 0.5f
        0x46116C42,  # mul.s f17,f13,f17   ; vel.x * 0.5
        0x46116300,  # add.s f12,f12,f17   ; pos.x += vel.x/2
        0x0A48608C,  # j     0x09218230    ; resume at 0xDE530
        NOP,
    ]),
    (0xDE530, 0x460F7380, 0x0A4FED54, 0x093FB550, [
        0x3C013F00,
        0x44818800,
        0x46117C42,  # mul.s f17,f15,f17   ; vel.y * 0.5
        0x46117380,  # add.s f14,f14,f17   ; pos.y += vel.y/2
        0x0A48608E,  # j     0x09218238    ; resume at 0xDE538
        NOP,
    ]),
    (0xDE54C, 0x460E6300, 0x0A4FED5C, 0x093FB570, [
        0x3C013F00,
        0x44818800,
        0x46117442,  # mul.s f17,f14,f17   ; vel.z * 0.5
        0x46116300,  # add.s f12,f12,f17   ; pos.z += vel.z/2
        0x0A486095,  # j     0x09218254    ; resume at 0xDE554
        NOP,
    ]),
    (0xDE554, 0x460D8341, 0x0A4FED64, 0x093FB590, [
        0x3C013F00,
        0x44818800,
        0x46116C42,  # mul.s f17,f13,f17   ; g * 0.5
        0x46118341,  # sub.s f13,f16,f17   ; vel.y - g/2
        0x0A486097,  # j     0x0921825C    ; resume at 0xDE55C
        NOP,
    ]),
]
# f2 = -1.0 -> -0.5 (walker per-call countdown step)
F2_SITE = (0xDE344, 0x3C05BF80, 0x3C05BF00)

spec = importlib.util.spec_from_file_location("ppsspp_ws", CLIENT)
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)
ws.ALLOWED |= {"memory.breakpoint.list"}


class Writer(ws.DebuggerClient):
    def write_word(self, address, word):
        self.seq += 1; t = "v5-%d" % self.seq
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
    out = Path(args.json_out) if args.json_out else None
    if out is not None:
        if not out.is_absolute(): out = REPO / out
        if out.exists(): raise RuntimeError("refusing to overwrite evidence")
    c = Writer("127.0.0.1", 60907); c.connect()
    rec = {"utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
           "tool": "apply-waterfall-004.py", "version": "v5-ra-free-transactional",
           "sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
           "mode": mode, "result": None}
    written = []
    paused = False
    before_values = {}

    def w(addr, word):
        written.append(addr)
        c.write_word(addr, word)

    try:
        active = [m for m in c.request("hle.module.list").get("modules", [])
                  if m.get("name") == "rcp1" and m.get("isActive")]
        if len(active) != 1 or active[0]["address"] != BASE:
            raise RuntimeError("wrong module base")
        rec["state"] = ws.decode_state(c, BASE)["state"]
        if mode == "apply" and rec["state"] != "C1":
            raise RuntimeError("apply requires C1 core")
        if args.expect_state and rec["state"] != args.expect_state:
            raise RuntimeError("state %s != %s" % (rec["state"], args.expect_state))
        if c.request("cpu.breakpoint.list").get("breakpoints"):
            raise RuntimeError("code breakpoints active")
        cpu = c.request("cpu.status")
        if cpu.get("paused") or cpu.get("stepping"):
            raise RuntimeError("CPU must be running")
        site_words = {rva: ws.read_word(c, BASE + rva)
                      for rva, *_ in SITES}
        site_words[F2_SITE[0]] = ws.read_word(c, BASE + F2_SITE[0])
        rec["observed"] = {"0x%06X" % k: "0x%08X" % v for k, v in site_words.items()}
        owned_cave = bytearray(CAVE_ZERO[1])
        for rva, orig, patched, cave, words in SITES:
            for i, word in enumerate(words):
                off = cave - CAVE_ZERO[0] + 4*i
                owned_cave[off:off+4] = word.to_bytes(4,"little")
        cave_area = read_bytes(c,CAVE_ZERO[0],CAVE_ZERO[1])
        if mode != "verify":
            if cave_area not in (bytes(CAVE_ZERO[1]),bytes(owned_cave)):
                raise RuntimeError("cave is neither zero nor exact owned v5 code")
            before_values = {BASE+rva:word for rva,word in site_words.items()}
            before_values.update({CAVE_ZERO[0]+off:int.from_bytes(cave_area[off:off+4],"little") for off in range(0,CAVE_ZERO[1],4)})
            paused=True
            c.request("cpu.stepping",no_reply=True,delay_ms=50)
            if not c.request("cpu.status").get("stepping"):
                raise RuntimeError("CPU pause not confirmed")
            for addr, expected in before_values.items():
                if ws.read_word(c,addr) != expected:
                    raise RuntimeError("snapshot changed before paused preflight")
        if mode == "verify":
            if all(site_words[rva] == orig for rva, orig, *_ in SITES) \
                    and site_words[F2_SITE[0]] == F2_SITE[1]:
                rec["verdict"] = "VANILLA"
            elif all(site_words[rva] == patched for rva, _, patched, *_ in SITES) \
                    and site_words[F2_SITE[0]] == F2_SITE[2]:
                rec["verdict"] = "PATCHED"
            else:
                rec["verdict"] = "OTHER"
            rec["result"] = "PASS"
        elif mode == "apply":
            for rva, orig, *_ in SITES:
                if site_words[rva] != orig:
                    raise RuntimeError("site 0x%06X not vanilla (0x%08X)" % (rva, site_words[rva]))
            if site_words[F2_SITE[0]] != F2_SITE[1]:
                raise RuntimeError("f2 site not vanilla (0x%08X)" % site_words[F2_SITE[0]])
            for rva, orig, patched, cave, words in SITES:
                for i, wd in enumerate(words):
                    w(cave + 4 * i, wd)
            for rva, orig, patched, cave, words in SITES:
                w(BASE + rva, patched)
            w(BASE + F2_SITE[0], F2_SITE[2])
            for rva, orig, patched, cave, words in SITES:
                if ws.read_word(c, BASE + rva) != patched:
                    raise RuntimeError("patch read-back failed 0x%06X" % rva)
            if ws.read_word(c, BASE + F2_SITE[0]) != F2_SITE[2]:
                raise RuntimeError("f2 patch read-back failed")
            if read_bytes(c,CAVE_ZERO[0],CAVE_ZERO[1]) != bytes(owned_cave):
                raise RuntimeError("cave read-back failed")
            rec["result"] = "PASS"
        else:  # revert
            if site_words[F2_SITE[0]] not in (F2_SITE[1], F2_SITE[2]):
                raise RuntimeError("counter site in unexpected state")
            for rva, orig, patched, cave, words in SITES:
                if site_words[rva] not in (orig, patched):
                    raise RuntimeError("site 0x%06X in unexpected state" % rva)
                w(BASE + rva, orig)
            w(BASE + F2_SITE[0], F2_SITE[1])
            # Retain exact owned caves until module reload: a previously
            # preempted game thread may still finish its existing trampoline.
            for rva, orig, *_ in SITES:
                if ws.read_word(c,BASE+rva)!=orig:
                    raise RuntimeError("revert readback failed")
            if ws.read_word(c,BASE+F2_SITE[0])!=F2_SITE[1]:
                raise RuntimeError("counter revert readback failed")
            rec["result"] = "PASS"
        if paused:
            c.request("cpu.resume",no_reply=True,delay_ms=50);paused=False
            first=c.request("cpu.status");time.sleep(5);last=c.request("cpu.status")
            rec["health"]={"before":first,"after":last,"tickDelta":last["ticks"]-first["ticks"]}
            if last.get("stepping") or last.get("paused") or rec["health"]["tickDelta"]<=0:
                raise RuntimeError("health check failed")
    except Exception as e:
        rec["error"] = str(e)
        # best-effort: undo the words written in this run, in reverse order
        if written and not paused:
            try:
                paused=True;c.request("cpu.stepping",no_reply=True,delay_ms=50)
                if not c.request("cpu.status").get("stepping"):raise RuntimeError("rollback pause not confirmed")
            except Exception as rollback_error:
                rec["rollbackPauseError"]=str(rollback_error)
                written=[]
        for addr in reversed(written):
            try:
                c.write_word(addr,before_values[addr])
                if ws.read_word(c,addr)!=before_values[addr]:raise RuntimeError("rollback readback failed")
            except Exception as rollback_error:
                rec.setdefault("rollbackErrors",[]).append({"address":hex(addr),"error":str(rollback_error)})
        rec["result"] = "FAILED"
        raise
    finally:
        if paused:
            try:c.request("cpu.resume",no_reply=True,delay_ms=50)
            except Exception as resume_error:rec["resumeError"]=str(resume_error)
        c.close()
        if out is not None:
            out.parent.mkdir(parents=True,exist_ok=True)
            out.write_text(json.dumps(rec, indent=1), encoding="utf-8")
        print(json.dumps({k: rec.get(k) for k in
                          ("result", "mode", "state", "verdict", "observed", "error")},
                         sort_keys=True))


if __name__ == "__main__":
    main()
