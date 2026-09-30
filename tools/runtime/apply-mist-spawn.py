#!/usr/bin/env python3
"""Guarded, reversible LEVEL_01 Waterfall spawn components (experimental).

Components: mist lifetime/damping, droplet damping, shared emitter gate.
The old separate mist phase step is superseded; the speed probe is rejected.
C1 core and waves remain untouched. Original assets remain untouched.
"""
import argparse, base64, hashlib, importlib.util, json, time
from pathlib import Path

REPO=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location("mist_ws",REPO/"research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py")
ws=importlib.util.module_from_spec(spec);spec.loader.exec_module(ws)
PAIR={0x2D49E8:(0x42700000,0x42F00000),0x2D49EC:(0x42B40000,0x43340000)}
EMISSION={0x2D489C:(0x3EAAAAAB,0x3E2AAAAB)}
# Diagnostic only: stop new DEC9C records to bind the visible effect.
# Never include this suppression in a correction recipe.
MIST_SUPPRESS_DIAGNOSTIC={0x2D489C:(0x3EAAAAAB,0x00000000)}
DAMPING={0x2D49B8:(0x3F7851EC,0x3F7C217A)}
# The delay-slot edit needs its preceding branch rewritten identically to
# invalidate PPSSPP's cached branch+delay compilation (live-tested separately).
EMITTER_GATE={0x151EDC:(0x30A40001,0x30A40003),0x151ED8:(0x04A10003,0x04A10003)}
DROP_SPEED_PROBE={0x2D4924:(0x3D75C290,0x3CF5C290),0x2D4928:(0x3DA3D70A,0x3D23D70A),
             0x2D4974:(0x3DCCCCCE,0x3D4CCCCE),0x2D4978:(0x3E23D70A,0x3DA3D70A)}
DROP_DAMPING={0x2D496C:(0x3F7851EC,0x3F7C217A)}
ALLOWED={**PAIR,**EMISSION,**DAMPING,**EMITTER_GATE,**DROP_SPEED_PROBE,**DROP_DAMPING}
ALLOWED[0x2D489C]=(0x3EAAAAAB,0x3E2AAAAB,0x00000000)
CONTEXT={0xDE97C:0x460D6301,0xDE980:0x460B603E,0xDEAF0:0x46008300,
         0xDF31C:0xE60C0020,0xDF328:0xE60C0034,0xDF330:0xE60C0038}


class Writer(ws.DebuggerClient):
    def write_word(self,address,value,base):
        rva=address-base
        if rva not in ALLOWED or value not in ALLOWED[rva]:raise RuntimeError("write outside spawn components")
        self.seq+=1;ticket="mist-life-%d"%self.seq
        self._send_frame(json.dumps({"event":"memory.write_u32","ticket":ticket,
                                     "address":address,"value":value}).encode())
        deadline=time.monotonic()+5
        while time.monotonic()<deadline:
            response=json.loads(self._recv_message())
            if response.get("ticket")==ticket:
                if response.get("event")=="error":raise RuntimeError(str(response))
                return
        raise RuntimeError("write acknowledgment timeout")


def main():
    ap=argparse.ArgumentParser(description=__doc__.splitlines()[0])
    mode=ap.add_mutually_exclusive_group(required=True)
    for name in ("apply","revert","verify"):mode.add_argument("--"+name,action="store_true")
    ap.add_argument("--port",type=int,default=60907);ap.add_argument("--out",required=True)
    ap.add_argument("--component",choices=["lifetime","emission","damping","emitter-gate","drop-speed-probe","drop-damping","mist-suppress-diagnostic"],default="lifetime")
    args=ap.parse_args();out=Path(args.out)
    if not out.is_absolute():out=REPO/out
    if out.exists():raise RuntimeError("refusing to overwrite evidence")
    selected={"lifetime":PAIR,"emission":EMISSION,"damping":DAMPING,"emitter-gate":EMITTER_GATE,
              "drop-speed-probe":DROP_SPEED_PROBE,"drop-damping":DROP_DAMPING,
              "mist-suppress-diagnostic":MIST_SUPPRESS_DIAGNOSTIC}[args.component]
    c=Writer("127.0.0.1",args.port);c.connect()
    rec={"utc":time.strftime("%Y-%m-%dT%H:%M:%SZ",time.gmtime()),"component":"mist-"+args.component,
         "toolSha256":hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         "mode":"apply" if args.apply else "revert" if args.revert else "verify","writes":[]}
    paused=False;before={};base=None
    try:
        ident=ws.identity(c);rec["identityBefore"]=ident;base=ident["module"]["baseDecimal"]
        if ident["game"].get("id")!="UCES00420":raise RuntimeError("wrong game")
        if args.apply and ident["state"]!="C1":raise RuntimeError("apply requires C1 core")
        cpu=c.request("cpu.status")
        if cpu.get("stepping") or cpu.get("paused"):raise RuntimeError("CPU must be running")
        if c.request("cpu.breakpoint.list").get("breakpoints"):raise RuntimeError("existing breakpoint")
        observed={r:ws.read_word(c,base+r) for r in CONTEXT}
        rec["context"]={hex(r):hex(w) for r,w in observed.items()}
        if observed!=CONTEXT:raise RuntimeError("LEVEL_01 context mismatch or old 005 present")
        if args.component.startswith("drop-"):
            drop_context={0xDDEBC:0xC6410000,0xDDFF4:0xC6540004,0xDE070:0xE60D003C,
                          0xDE078:0xE60D0044,0xDE560:0xC4AC0044,0xDE568:0x460C7B02,0xDE590:0x460D6302}
            rec["dropContext"]={hex(r):hex(ws.read_word(c,base+r)) for r in drop_context}
            if any(int(rec["dropContext"][hex(r)],16)!=w for r,w in drop_context.items()):raise RuntimeError("0x50 initializer/walker context mismatch")
        if args.component=="emission" and ws.read_word(c,base+0x152038)!=0x460D6300:
            raise RuntimeError("emitter phase-add instruction mismatch")
        if args.component=="emitter-gate":
            phase_lo=(base+0x2D4A18)&0xFFFF
            gate_context={0x151ED0:0x8E240000|phase_lo,0x151ED4:0x24850001,0x151ED8:0x04A10003,
                          0x151EE8:0x1480007F,0x151EEC:0xAE240000|phase_lo,
                          0x1520E8:0x3C050000|((base+0x151BF4+0x8000)>>16)}
            rec["gateContext"]={hex(r):hex(ws.read_word(c,base+r)) for r in gate_context}
            if any(int(rec["gateContext"][hex(r)],16)!=w for r,w in gate_context.items()):raise RuntimeError("Waterfall gate context mismatch")
            if ws.read_word(c,base+0x2D489C)!=EMISSION[0x2D489C][0]:raise RuntimeError("restore separate mist emission parameter first")
            phase=ws.read_word(c,base+0x2D4A18);rec["emitterGatePhase"]=phase
            if phase>3:raise RuntimeError("unexpected gate phase state")
        before={r:ws.read_word(c,base+r) for r in selected};rec["before"]={hex(r):hex(w) for r,w in before.items()}
        if args.verify:
            rec["verdict"]="ORIGINAL" if all(before[r]==v[0] for r,v in selected.items()) else "CORRECTED" if all(before[r]==v[1] for r,v in selected.items()) else "OTHER"
        else:
            expected=0 if args.apply else 1;wanted=1 if args.apply else 0
            if any(before[r]!=v[expected] for r,v in selected.items()):raise RuntimeError("component not in exact expected state")
            paused=True;c.request("cpu.stepping",no_reply=True,delay_ms=50)
            if not c.request("cpu.status").get("stepping"):raise RuntimeError("CPU pause not confirmed")
            for r,v in selected.items():
                rec["writes"].append(hex(r));c.write_word(base+r,v[wanted],base)
                if ws.read_word(c,base+r)!=v[wanted]:raise RuntimeError("readback mismatch")
            rec["after"]={hex(r):hex(ws.read_word(c,base+r)) for r in selected}
            c.request("cpu.resume",no_reply=True,delay_ms=50);paused=False
            first=c.request("cpu.status");time.sleep(5);last=c.request("cpu.status")
            rec["health"]={"before":first,"after":last,"tickDelta":last["ticks"]-first["ticks"]}
            if last.get("stepping") or last.get("paused") or rec["health"]["tickDelta"]<=0:raise RuntimeError("health check failed")
        rec["identityAfter"]=ws.identity(c)
        if rec["identityAfter"]["state"]!=ident["state"]:raise RuntimeError("core changed")
        rec["result"]="PASS"
    except Exception as e:
        rec["result"]="FAILED";rec["error"]=str(e)
        if rec["writes"] and base is not None:
            rec["rollback"]=[]
            try:
                if not paused:
                    paused=True;c.request("cpu.stepping",no_reply=True,delay_ms=50)
                if not c.request("cpu.status").get("stepping"):raise RuntimeError("rollback pause not confirmed")
                for r in selected:
                    c.write_word(base+r,before[r],base);got=ws.read_word(c,base+r)
                    rec["rollback"].append({"rva":hex(r),"readback":hex(got)})
                    if got!=before[r]:raise RuntimeError("rollback readback mismatch")
            except Exception as re:rec["rollbackError"]=str(re)
        raise
    finally:
        if paused:
            try:c.request("cpu.resume",no_reply=True,delay_ms=50)
            except Exception as e:rec["resumeError"]=str(e)
        c.close();out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(rec,indent=1),encoding="utf-8")
        print(json.dumps({k:rec.get(k) for k in ("result","mode","verdict","before","after","error")},sort_keys=True))

if __name__=="__main__":main()
