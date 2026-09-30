#!/usr/bin/env python3
"""Scoped live-bound DE23C 0x50 records, emulated-time regression measurements.

Follows current headers sharing a freshly bound owner, not a heap scan.
Compaction identity uses immutable initialization fields, excluding changing
velocities/orientation. Two live-bound families have damping1.0/.97.
No writes or breakpoints.
"""
import argparse,base64,hashlib,importlib.util,json,math,statistics,struct,time
from pathlib import Path
REPO=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location("pool_reader",REPO/"tools/runtime/measure-mist-records.py")
reader=importlib.util.module_from_spec(spec);spec.loader.exec_module(reader)
ws=reader.ws
KEY=(0x1C,0x24,0x28,0x34,0x38,0x3C,0x44)

def main():
    ap=argparse.ArgumentParser(description=__doc__.splitlines()[0]);ap.add_argument("--table",required=True,type=lambda x:int(x,0));ap.add_argument("--owner",required=True,type=lambda x:int(x,0));ap.add_argument("--label",required=True);ap.add_argument("--expect-state",required=True,choices=["A0","C1"]);ap.add_argument("--seconds",type=float,default=4);ap.add_argument("--out",required=True)
    args=ap.parse_args();out=Path(args.out)
    if not out.is_absolute():out=REPO/out
    if out.exists():raise RuntimeError("refusing to overwrite evidence")
    if not 0x08800000<=args.table<0x09FFF000 or not 0x08800000<=args.owner<0x0A000000:raise ValueError("invalid binding")
    c=ws.DebuggerClient("127.0.0.1",60907);c.connect()
    rec={"tool":"measure-droplet-records.py","toolSha256":hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),"utc":time.strftime("%Y-%m-%dT%H:%M:%SZ",time.gmtime()),"label":args.label,"table":hex(args.table),"owner":hex(args.owner),"samples":[],"tickHz":reader.TICK_HZ}
    try:
        ident=ws.identity(c);rec["identityBefore"]=ident;base=ident["module"]["baseDecimal"]
        if ident["state"]!=args.expect_state or ident["game"].get("id")!="UCES00420":raise RuntimeError("identity mismatch")
        if c.request("cpu.breakpoint.list").get("breakpoints"):raise RuntimeError("breakpoints present")
        words={hex(r):hex(ws.read_word(c,base+r)) for r in (0xDE344,0xDE528,0xDE530,0xDE54C,0xDE554,0xDE4A8,0x2D489C,0x2D49B8,0xDF304,0x151EDC,0xDE148,0xDE068,0x2D496C,0x2D4924,0x2D4928,0x2D4974,0x2D4978)};rec["componentWordsBefore"]=words
        initial=None;start=time.monotonic()
        while True:
            now=time.monotonic();cpu=c.request("cpu.status")
            if cpu.get("stepping") or cpu.get("paused"):raise RuntimeError("CPU stopped")
            table=reader.read(c,args.table,0x400);blocks=[];records=[]
            for index in range(64):
                h=table[index*16:(index+1)*16];owner,link,storage,packed=struct.unpack("<4I",h)
                if owner!=args.owner:continue
                first,count=packed&65535,packed>>16
                if not 0x08800000<=storage<0x09FFB000 or first+count>256:raise RuntimeError("bad descriptor")
                b=reader.read(c,storage+first*80,count*80) if count else b""
                blocks.append({"index":index,"header":h.hex(),"storage":hex(storage),"start":first,"count":count})
                for i in range(count):
                    rb=b[i*80:(i+1)*80];f=struct.unpack("<20f",rb)
                    if not all(math.isfinite(f[k]) for k in (0,1,2,3,4,5,8,9,17,18)) or min(abs(f[17]-1),abs(f[17]-.97),abs(f[17]-.9848858118057251))>1e-6:
                        rec["rejectedRecord"]={"address":hex(storage+(first+i)*80),"base64":base64.b64encode(rb).decode(),"floatFields":list(f),"header":blocks[-1]}
                        raise RuntimeError("unexpected droplet layout/damping")
                    records.append({"key":"-".join(rb[o:o+4].hex() for o in KEY),"address":hex(storage+(first+i)*80),"base64":base64.b64encode(rb).decode()})
            if not blocks:raise RuntimeError("owner disappeared")
            aftertable=reader.read(c,args.table,0x400);after=c.request("cpu.status");tick=(cpu["ticks"]+after["ticks"])/2
            if initial is None:initial=tick
            rec["samples"].append({"tick":tick,"readTickSpan":after["ticks"]-cpu["ticks"],"headerStable":all(bytes.fromhex(h["header"])==aftertable[h["index"]*16:(h["index"]+1)*16] for h in blocks),"headers":blocks,"records":records})
            if(tick-initial)/reader.TICK_HZ>=args.seconds:break
            if time.monotonic()-start>args.seconds*4+10:raise RuntimeError("clock not advancing")
            time.sleep(max(0,.05-(time.monotonic()-now)))
        last={};speeds=[];timers=[];lives=[];scalar=[];decay=[];phase=[]
        for i,s in enumerate(rec["samples"]):
            keys=[r["key"] for r in s["records"]]
            if len(keys)!=len(set(keys)):raise RuntimeError("identity collision")
            for r in s["records"]:
                f=struct.unpack("<20f",base64.b64decode(r["base64"]))
                if r["key"] in last:
                    pi,ps,p=last[r["key"]];dt=(s["tick"]-ps["tick"])/reader.TICK_HZ
                    if pi==i-1 and s["headerStable"] and ps["headerStable"] and dt>0:
                        if p[18]>0 and 0<f[18]<p[18]:lives.append((f[18]-p[18])/dt)
                        if p[18]==f[18]==0 and 0<f[8]<p[8]:
                            timers.append((f[8]-p[8])/dt)
                            if p[8]<p[9] and f[8]<f[9]:
                                speeds.append(math.sqrt(sum((f[k]-p[k])**2 for k in range(3)))/dt)
                                scalar.append((f[6]-p[6])/dt)
                                phi=math.atan2(f[12],f[11])-math.atan2(p[12],p[11]);phase.append(math.atan2(math.sin(phi),math.cos(phi))/dt)
                                if f[7]==0 and f[4]>0 and p[4]>0:decay.append(math.log(f[4]/p[4])/dt)
                last[r["key"]]=(i,s,f)
        if not speeds or not timers:raise RuntimeError("no qualifying moving records")
        rec["identityAfter"]=ws.identity(c)
        if rec["identityAfter"]["state"]!=ident["state"] or rec["identityAfter"]["module"]!=ident["module"]:raise RuntimeError("identity changed")
        rec["componentWordsAfter"]={r:hex(ws.read_word(c,base+int(r,16))) for r in words}
        if words!=rec["componentWordsAfter"]:raise RuntimeError("component changed")
        rec["summary"]={"speedUnitsPerEmuSecond":reader.stats(speeds),"timerSlopePerEmuSecond":reader.stats(timers),"lifetimeSlopePerEmuSecond":reader.stats(lives),"scalarSlopePerEmuSecond":reader.stats(scalar),"rotationRadiansPerEmuSecond":reader.stats(phase),"zeroGravityPositiveYDecayLogPerEmuSecond":reader.stats(decay),"occupancy":reader.stats([len(s["records"]) for s in rec["samples"]]),"unstableHeaders":sum(not s["headerStable"] for s in rec["samples"]),"emuSeconds":(rec["samples"][-1]["tick"]-initial)/reader.TICK_HZ}
        rec["breakpointsAfter"]=c.request("cpu.breakpoint.list").get("breakpoints",[]);rec["result"]="PASS"
    except Exception as e:rec["result"]="FAILED";rec["error"]=str(e);raise
    finally:
        c.close();out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(rec,indent=1),encoding="utf-8");print(json.dumps({k:rec.get(k) for k in("result","label","summary","error")},sort_keys=True))

if __name__=="__main__":main()
