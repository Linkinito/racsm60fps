#!/usr/bin/env python3
"""Guarded, reversible LEVEL_01 Butterfly flap half-step (experimental RAM).

C1 core required for install. Preserve movement, steering, counters and the
per-instance step. Restore only redirect on removal; retain reachable cave.
"""
import argparse, hashlib, importlib.util, json, time
from pathlib import Path

REPO=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location("flap_motion",REPO/"tools/runtime/apply-waterfall-mist-motion.py")
motion=importlib.util.module_from_spec(spec);spec.loader.exec_module(motion)
ws=motion.ws
SITE=0x122C98; ORIGINAL=0x460D6300; CAVE=0x2C1CC0; SPAN=0x60
CONTEXT={0x122820:0x27BDFF00,0x122830:0x8E110054,
         0x122C8C:0xC60C0070,0x122C90:0xC62D005C,
         0x122C94:0x92040045,0x122C9C:0x34050001,
         0x122CA0:0x148500B3,0x122CA4:0xE60C0070}

def cave_words(base):
    # The displaced add uses f12/f13. Preserve AT, f15 and SP rather than
    # relying on an unproven spare register. The original delay-slot ori is
    # independent of this addition and still executes before cave entry.
    words=[0x27BDFFF0,0xAFA10000,0xE7AF0004,0x3C013F00,
           0x44817800,0x460F6BC2,0x460F6300,0x8FA10000,
           0xC7AF0004,0x27BD0010,motion.jump(base+SITE+8),0]
    return words+[0]*(SPAN//4-len(words))

def main():
    ap=argparse.ArgumentParser(description=__doc__.splitlines()[0])
    modes=ap.add_mutually_exclusive_group(required=True)
    for name in ("apply","revert","verify"):modes.add_argument("--"+name,action="store_true")
    ap.add_argument("--port",type=int,default=60907);ap.add_argument("--out",required=True)
    args=ap.parse_args();out=Path(args.out)
    if not out.is_absolute():out=REPO/out
    if out.exists():raise RuntimeError("refusing existing evidence")
    record={"utc":time.strftime("%Y-%m-%dT%H:%M:%SZ",time.gmtime()),
            "methodSha256":hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            "mode":"apply" if args.apply else "revert" if args.revert else "verify",
            "profile":"C1 core external + Butterfly flap only", "writes":[],"result":"FAILED"}
    c=motion.Writer("127.0.0.1",args.port);paused=False;connected=False;safe=True
    base=None;before_hook=None;wanted=None;error=None
    try:
        c.connect();connected=True
        ident=ws.identity(c);record["identityBefore"]=ident
        base=ident["module"]["baseDecimal"]
        if ident["game"].get("id")!="UCES00420" or ident["module"]["size"]!=0x46B900:
            raise RuntimeError("wrong LEVEL_01 identity")
        if args.apply and ident["state"]!="C1":raise RuntimeError("apply requires C1")
        if ident["cpu"]["paused"] or ident["cpu"]["stepping"] or c.request("cpu.breakpoint.list").get("breakpoints"):
            raise RuntimeError("CPU must be running without breakpoints")
        words=cave_words(base);redirect=motion.jump(base+CAVE)
        c.allowed={base+SITE:{ORIGINAL,redirect},**{base+CAVE+i*4:{0,w} for i,w in enumerate(words)}}
        c.request("cpu.stepping");paused=True
        stopped=ws.identity(c)
        if stopped["module"]!=ident["module"] or stopped["state"]!=ident["state"]:
            raise RuntimeError("identity changed before transaction")
        record["guards"]={hex(r):hex(ws.read_word(c,base+r)) for r in CONTEXT}
        if any(int(record["guards"][hex(r)],16)!=w for r,w in CONTEXT.items()):
            raise RuntimeError("Butterfly context mismatch")
        before_hook=ws.read_word(c,base+SITE);record["hookBefore"]=hex(before_hook)
        existing=[ws.read_word(c,base+CAVE+i*4) for i in range(len(words))]
        if before_hook not in (ORIGINAL,redirect):raise RuntimeError("foreign redirect")
        if existing not in ([0]*len(words),words):raise RuntimeError("foreign cave")
        if before_hook==redirect and existing!=words:raise RuntimeError("redirect with incomplete cave")
        if args.verify and (before_hook!=redirect or existing!=words):raise RuntimeError("candidate not installed")
        wanted=ORIGINAL if args.revert else redirect
        def write(address,value):
            old=ws.read_word(c,address)
            if old==value:return
            record["writes"].append({"address":hex(address),"before":hex(old),"after":hex(value)})
            c.write_word(address,value)
            if ws.read_word(c,address)!=value:raise RuntimeError("write readback mismatch")
        if args.apply:
            for i,w in enumerate(words):write(base+CAVE+i*4,w)
        if not args.verify:write(base+SITE,wanted)
        record["hookAfter"]=hex(ws.read_word(c,base+SITE))
        if ws.read_word(c,base+SITE)!=wanted:raise RuntimeError("redirect mismatch")
        c.request("cpu.resume");paused=False
        first=ws.identity(c);time.sleep(5);last=ws.identity(c)
        record["healthBefore"]=first;record["healthAfter"]=last
        if first["module"]!=last["module"] or last["state"]!=ident["state"]:
            raise RuntimeError("identity changed during health window")
        if last["cpu"]["paused"] or last["cpu"]["stepping"] or c.request("cpu.breakpoint.list").get("breakpoints"):
            raise RuntimeError("CPU stopped during health window")
        if last["cpu"]["ticks"]<=first["cpu"]["ticks"]:raise RuntimeError("ticks did not advance")
        if ws.read_word(c,base+SITE)!=wanted:raise RuntimeError("redirect changed during health window")
        record["result"]="PASS"
    except Exception as exc:
        error=exc;record["error"]=str(exc)
        if paused and before_hook is not None and base is not None:
            try:
                current=ws.read_word(c,base+SITE)
                if current!=before_hook:
                    if wanted is None or current!=wanted:raise RuntimeError("rollback redirect conflict")
                    c.write_word(base+SITE,before_hook)
                if ws.read_word(c,base+SITE)!=before_hook:raise RuntimeError("rollback readback mismatch")
                record["rollback"]="redirect restored; cave retained"
            except Exception as rollback:
                safe=False;record["rollbackError"]=str(rollback)
    finally:
        if connected:
            if paused and safe:
                try:c.request("cpu.resume");paused=False
                except Exception as exc:record["resumeError"]=str(exc);error=error or exc
            try:
                record["finalCpu"]=c.request("cpu.status")
                record["finalBreakpoints"]=c.request("cpu.breakpoint.list")
            except Exception as exc:record["finalCheckError"]=str(exc)
            c.close()
        out.parent.mkdir(parents=True,exist_ok=True)
        out.write_text(json.dumps(record,indent=1),encoding="utf-8")
        print(json.dumps({"result":record["result"],"writes":len(record["writes"]),"error":record.get("error")}))
    if error:raise SystemExit(1)

if __name__=="__main__":main()
