#!/usr/bin/env python3
"""Isolated, ra-neutral LEVEL_01 Waterfall half-step hooks (experimental).

Mist motion is gated by NEW record+38 == sqrt(.97); its rotation by config.
Droplets006 upgrades 004 position hooks, scopes damping by record+44, and
scopes rotation/scalar initialization by the two exact DDC08 config pointers.
The 004 gravity/countdown, C1 core and wave sites remain unchanged by this tool.
Each hook must be tested separately before composing. No original asset writes.
Revert restores the redirect but retains owned cave bytes until module reload,
so a preempted thread can finish its existing trampoline safely.
"""
import argparse, base64, hashlib, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("mist_ws", REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py")
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)

def jump(address): return 0x08000000 | ((address >> 2) & 0x03FFFFFF)
def lui(reg, word): return 0x3C000000 | (reg << 16) | (word >> 16)
def ori(reg, word): return 0x34000000 | (reg << 21) | (reg << 16) | (word & 0xFFFF)
def mtc(reg, fp): return 0x44800000 | (reg << 16) | (fp << 11)
def mfc(reg, fp): return 0x44000000 | (reg << 16) | (fp << 11)
def fp(op, dest, left, right=0): return 0x46000000 | (right << 16) | (left << 11) | (dest << 6) | op

SITES = {
    "x": (0xDEA78, 0x460E6B40, 0x2C1900, 0xC5F00010, 14, 13, 13),
    "y": (0xDEA88, 0x46107BC0, 0x2C1960, 0xC5F20014, 16, 15, 15),
    "z": (0xDEA98, 0x46128B40, 0x2C19C0, 0xE5EF0004, 18, 17, 13),
    "rotation": (0xDF304, 0xE60E002C, 0x2C1A20, 0xE60F0030),
    "drop-x": (0xDE528, 0x0A4FED4C, 0x2C1A80, 0xC4AF0010,13,12,12),
    "drop-y": (0xDE530, 0x0A4FED54, 0x2C1AE0, 0xE4AC0000,15,14,14),
    "drop-z": (0xDE54C, 0x0A4FED5C, 0x2C1B40, 0xC4AF000C,14,12,12),
    "drop-rotation": (0xDE148, 0xE60C0034, 0x2C1BA0, 0xE6140038),
    "drop-scalar": (0xDE068, 0xC7AD0064, 0x2C1C00, 0x00042602),
    "drop-alpha": (0xDE4A8, 0x8CA60040, 0x2C1C60, 0xC4AD0028),
}
SPAN = 0x60
CONTEXT = {0xDEAC0:0xC5F10038, 0xDEACC:0xC5F30038, 0xDEAD0:0x46116302,
           0xDEADC:0x46139482, 0xDF31C:0xE60C0020, 0xDF328:0xE60C0034,
           0xDF330:0xE60C0038}
ALPHA_CONTEXT = {0xDE4B8:0x00D23024,0xDE4C8:0x460D6301,0xDE4F0:0x4600630D,
                 0xDE518:0xACA60040,0xDE51C:0xC4AC0000}

def cave_words(name, base):
    site, original, cave, delay, *regs = SITES[name]
    if name == "drop-alpha":
        # Scope through current Waterfall pool IDs, not fixed heap owners.
        # Existing delay loads fade+28. Original quantized alpha subtraction
        # runs on odd shared phases; even phases retain the packed alpha.
        first,second,phase=base+0x2D48A8,base+0x2D48AC,base+0x2D4A18
        words=[0x96E60010,lui(1,first),ori(1,first),0x8C270000,0x10C70006,0,
               lui(1,second),ori(1,second),0x8C270000,0x14C70007,0,
               lui(1,phase),ori(1,phase),0x8C260000,0x30C60001,0x10C00004,0,
               original,jump(base+site+8),0,jump(base+0xDE51C),0]
    elif name == "drop-scalar":
        first,second=base+0x2D4918,base+0x2D4968
        words=[0xC7AD0064,lui(1,first),ori(1,first),0x12410005,0,lui(1,second),ori(1,second),0x16410004,0,
               lui(1,0x3F000000),mtc(1,15),fp(2,13,13,15),jump(base+site+8),0]
    elif name == "drop-rotation":
        first,second=base+0x2D4918,base+0x2D4968
        words=[lui(1,first),ori(1,first),0x12410005,0,lui(1,second),ori(1,second),0x16410008,0,
               fp(0,20,20,13),lui(1,0x3F000000),mtc(1,13),fp(2,20,20,13),fp(4,20,20),
               fp(0,13,20,20),fp(3,12,12,13),0xE60C0034,0xE6140038,jump(base+site+8),0]
    elif name.startswith("drop-"):
        vel,left,dest=regs
        words=[mtc(12,17),0x8CA10044,lui(12,0x3F7C217A),ori(12,0x3F7C217A),0,mfc(12,17)]
        if name=="drop-y":words += [mtc(0,17),fp(0x3C,0,17,vel),0,0]
        words += [lui(1,0x3F00F984),ori(1,0x3F00F984),0,0]
        default=len(words);words += [lui(1,0x3F000000),ori(1,0x3F000000)]
        apply=len(words);words += [mtc(1,17),fp(2,17,vel,17),fp(0,dest,left,17),jump(base+site+8),0]
        words[4]=0x142C0000|(default-5)
        if name=="drop-y":words[8]=0x45000000|(default-9)
        words[default-2]=jump(base+cave+apply*4)
    elif name == "rotation":
        config = base + 0x2D49B8
        # bne s3,at,+7; f30 is the existing exact 1.0 constant.
        words = [lui(1,config), ori(1,config), 0x16610007, 0,
                 lui(1,0x3F000000), mtc(1,17), fp(0,15,15,30),
                 fp(2,15,15,17), fp(4,15,15), fp(0,17,15,15),
                 fp(3,14,14,17), 0xE60E002C, 0xE60F0030,
                 jump(base+site+8), 0]
        # Branch at word2 must target word11 (store original coefficients).
        words[2] = 0x16610008
    else:
        vel,left,dest = regs
        factor = 0x3F000000 if name == "y" else 0x3F00F984
        words = [mtc(12,1), 0x8DE10038, lui(12,0x3F7C217A), ori(12,0x3F7C217A),
                 0x142C0008, mfc(12,1), lui(1,factor), ori(1,factor), mtc(1,0),
                 fp(2,0,vel,0), fp(0,dest,left,0), jump(base+site+8), 0,
                 original, jump(base+site+8), 0]
    assert len(words)*4 <= SPAN
    return words + [0] * (SPAN//4-len(words))

def read_bytes(c,address,size):
    b=base64.b64decode(c.request("memory.read",{"address":address,"size":size,"replacements":False})["base64"])
    if len(b)!=size: raise RuntimeError("short read")
    return b

class Writer(ws.DebuggerClient):
    allowed = None
    def write_word(self,address,word):
        if address not in self.allowed or word not in self.allowed[address]:
            raise RuntimeError("write outside selected hook allowlist")
        self.seq+=1; ticket="mist-hook-%d"%self.seq
        self._send_frame(json.dumps({"event":"memory.write_u32","ticket":ticket,"address":address,"value":word}).encode())
        deadline=time.monotonic()+5
        while time.monotonic()<deadline:
            r=json.loads(self._recv_message())
            if r.get("ticket")==ticket:
                if r.get("event")=="error": raise RuntimeError(str(r))
                return
        raise RuntimeError("write acknowledgment timeout")

def main():
    ap=argparse.ArgumentParser(description=__doc__.splitlines()[0])
    modes=ap.add_mutually_exclusive_group(required=True)
    for name in ("apply","revert","verify"): modes.add_argument("--"+name,action="store_true")
    ap.add_argument("--only",required=True,choices=list(SITES))
    ap.add_argument("--port",type=int,default=60907); ap.add_argument("--out",required=True)
    args=ap.parse_args(); out=Path(args.out)
    if not out.is_absolute(): out=REPO/out
    if out.exists(): raise RuntimeError("refusing to overwrite evidence")
    c=Writer("127.0.0.1",args.port); c.connect()
    rec={"tool":"apply-waterfall-mist-motion.py","sha256":hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         "utc":time.strftime("%Y-%m-%dT%H:%M:%SZ",time.gmtime()), "hook":args.only,
         "mode":"apply" if args.apply else "revert" if args.revert else "verify","writes":[]}
    paused=False; before={}
    try:
        ident=ws.identity(c); rec["identityBefore"]=ident; base=ident["module"]["baseDecimal"]
        if ident["game"].get("id")!="UCES00420" or ident["module"]["size"]!=0x46B900: raise RuntimeError("wrong LEVEL_01 identity")
        if args.apply and ident["state"]!="C1": raise RuntimeError("apply requires C1 core")
        if args.only.startswith("drop-"):
            if ws.read_word(c,base+0xDE344)!=0x3C05BF00 or ws.read_word(c,base+0xDE554)!=0x0A4FED64:
                raise RuntimeError("drop upgrade requires droplet004 counter/gravity")
        if args.only=="drop-alpha":
            if any(ws.read_word(c,base+r)!=w for r,w in ALPHA_CONTEXT.items()):
                raise RuntimeError("alpha context mismatch")
            first,second=(ws.read_word(c,base+r) for r in (0x2D48A8,0x2D48AC))
            if first==second or not 0<=first<64 or not 0<=second<64:
                raise RuntimeError("Waterfall pool IDs invalid")
            if ws.read_word(c,base+0x151EDC)!=0x30A40003 or ws.read_word(c,base+0x2D4A18)>3:
                raise RuntimeError("alpha candidate requires the tested shared gate")
            rec["alphaScope"]={"poolIds":[first,second],"ownerLow16Offset":"0x10",
                               "originalAlphaOnPhase":"odd","scopeEvidence":"current live-bound owner IDs"}
        if ident["cpu"]["paused"] or ident["cpu"]["stepping"]: raise RuntimeError("CPU must be running")
        if c.request("cpu.breakpoint.list").get("breakpoints"): raise RuntimeError("existing breakpoint")
        rec["context"]={hex(r):hex(ws.read_word(c,base+r)) for r in CONTEXT}
        if any(int(rec["context"][hex(r)],16)!=w for r,w in CONTEXT.items()): raise RuntimeError("context mismatch")
        site,original,cave,delay,*_ = SITES[args.only]
        if ws.read_word(c,base+site+4)!=delay: raise RuntimeError("delay instruction mismatch")
        words=cave_words(args.only,base); patched=jump(base+cave)
        expected={base+site:original, **{base+cave+i*4:0 for i in range(len(words))}}
        replacement={base+site:patched, **{base+cave+i*4:w for i,w in enumerate(words)}}
        c.allowed={a:{expected[a],replacement[a]} for a in expected}
        before={a:ws.read_word(c,a) for a in expected}
        rec["before"]={hex(a):hex(w) for a,w in before.items()}
        if args.verify:
            retained={**replacement,base+site:original}
            rec["verdict"]="ORIGINAL" if before==expected else "REVERTED_CAVE_RETAINED" if before==retained else "CORRECTED" if before==replacement else "OTHER"
        else:
            source,target=(expected,replacement) if args.apply else (replacement,expected)
            retained={**replacement,base+site:original}
            if args.apply and before==retained:source=retained
            if args.revert:target=retained
            if before!=source: raise RuntimeError("selected site/cave not in exact expected state")
            paused=True; c.request("cpu.stepping",no_reply=True,delay_ms=50)
            if not c.request("cpu.status").get("stepping"): raise RuntimeError("pause not confirmed")
            # Install cave before redirect; never clear reachable retained code.
            addresses=list(target)
            if args.apply: addresses=addresses[1:]+addresses[:1]
            for a in addresses:
                if source[a]==target[a]: continue
                rec["writes"].append(hex(a)); c.write_word(a,target[a])
                if ws.read_word(c,a)!=target[a]: raise RuntimeError("write readback mismatch")
            rec["after"]={hex(a):hex(ws.read_word(c,a)) for a in expected}
            if any(int(rec["after"][hex(a)],16)!=target[a] for a in expected): raise RuntimeError("whole-hook readback mismatch")
            c.request("cpu.resume",no_reply=True,delay_ms=50); paused=False
            first=c.request("cpu.status"); time.sleep(5); last=c.request("cpu.status")
            rec["health"]={"before":first,"after":last,"tickDelta":last["ticks"]-first["ticks"]}
            if last.get("stepping") or last.get("paused") or rec["health"]["tickDelta"]<=0: raise RuntimeError("health failed")
        rec["identityAfter"]=ws.identity(c)
        if rec["identityAfter"]["module"]!=ident["module"] or rec["identityAfter"]["state"]!=ident["state"]: raise RuntimeError("identity/core changed")
        rec["breakpointsAfter"]=c.request("cpu.breakpoint.list").get("breakpoints",[])
        rec["result"]="PASS"
    except Exception as e:
        rec["result"]="FAILED"; rec["error"]=str(e)
        if rec["writes"]:
            rec["rollback"]=[]
            try:
                if not paused:
                    paused=True; c.request("cpu.stepping",no_reply=True,delay_ms=50)
                if not c.request("cpu.status").get("stepping"): raise RuntimeError("rollback pause not confirmed")
                for a in before:
                    if hex(a) not in rec["writes"]: continue
                    c.write_word(a,before[a]); got=ws.read_word(c,a)
                    rec["rollback"].append({"address":hex(a),"readback":hex(got)})
                    if got!=before[a]: raise RuntimeError("rollback readback mismatch")
            except Exception as re: rec["rollbackError"]=str(re)
        raise
    finally:
        if paused:
            try:c.request("cpu.resume",no_reply=True,delay_ms=50)
            except Exception as e:rec["resumeError"]=str(e)
        c.close(); out.parent.mkdir(parents=True,exist_ok=True); out.write_text(json.dumps(rec,indent=1),encoding="utf-8")
        print(json.dumps({k:rec.get(k) for k in ("result","hook","mode","verdict","health","error")},sort_keys=True))

if __name__=="__main__": main()
