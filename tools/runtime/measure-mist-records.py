#!/usr/bin/env python3
"""Measure a live-bound 0x40 DEC9C pool without scanning guessed entity slots.

Pool table address and ID must come from current-session true-stop bindings.
DE8A8 reads descriptor+8 (storage), +C (start index), +E (active count).
Read pairs are tick-bracketed; header changes are flagged rather than hidden.
Random immutable initialization fields identify records across pool compaction.
No gameplay writes, input or persistent debugger control is used.
"""
import argparse, base64, hashlib, importlib.util, json, math, statistics, struct, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CLIENT = REPO / "research/live-tests/pokitaru/waterfall-001/ppsspp-ws.py"
spec = importlib.util.spec_from_file_location("mist_ws", CLIENT)
ws = importlib.util.module_from_spec(spec); spec.loader.exec_module(ws)
TICK_HZ = 222_000_000
OFFSETS = {"scalar": 0x18, "counter": 0x1C, "lifeStep": 0x20,
           "sin": 0x2C, "cos": 0x30, "scalarStep": 0x34, "scale": 0x38}
IMMUTABLE = (0x20, 0x2C, 0x30, 0x34, 0x38)


def read(c, address, size):
    b = base64.b64decode(c.request("memory.read", {"address": address, "size": size,
                                               "replacements": False})["base64"])
    if len(b) != size: raise RuntimeError("short memory read")
    return b


def stats(values):
    if not values: return None
    return {"n": len(values), "min": min(values), "median": statistics.median(values),
            "mean": statistics.mean(values), "max": max(values)}


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--table", required=True, type=lambda x: int(x, 0))
    ap.add_argument("--pool", type=int, help="diagnostic single descriptor index")
    ap.add_argument("--owner", type=lambda x: int(x, 0), help="live-bound shared descriptor owner")
    ap.add_argument("--label", required=True)
    ap.add_argument("--expect-state", required=True, choices=["A0", "C1"])
    ap.add_argument("--seconds", type=float, default=12)
    ap.add_argument("--interval", type=float, default=.1)
    ap.add_argument("--expect-damping", type=float, default=.97)
    ap.add_argument("--port", type=int, default=60907)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    if not 0x08800000 <= args.table < 0x0A000000 or (args.pool is None) == (args.owner is None):
        ap.error("invalid live-bound pool table/ID")
    out = Path(args.out)
    if not out.is_absolute(): out = REPO / out
    if out.exists(): raise RuntimeError("refusing to overwrite evidence")
    c = ws.DebuggerClient("127.0.0.1", args.port); c.connect()
    rec = {"tool": "measure-mist-records.py", "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
           "toolSha256":hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),"expectedDamping":args.expect_damping,
           "label": args.label, "poolTable": hex(args.table), "poolId": args.pool,
           "owner": hex(args.owner) if args.owner else None,
           "tickHz": TICK_HZ, "intervalHostSeconds": args.interval, "samples": []}
    try:
        ident = ws.identity(c)
        if ident["state"] != args.expect_state: raise RuntimeError("wrong core state")
        rec["identityBefore"] = ident
        base = ident["module"]["baseDecimal"]
        rec["componentWordsBefore"] = {hex(r): hex(ws.read_word(c, base+r)) for r in
            (0x2D49E8, 0x2D49EC, 0x2D489C, 0xDE344, 0xDE528, 0xDE530,
             0xDE54C, 0xDE554, 0xDE980, 0xDEA78, 0xDEA88, 0xDEA98,
             0xDEAE8, 0xDEAF0, 0xDEAF8,0xDF304,0x2D49B8,0x2D49C0,0x2D49C4,0x151EDC)}
        rec["waveObjectWords"] = {hex(o): hex(ws.read_word(c, 0x096ED210+o)) for o in (0x24, 0x30)}
        if c.request("cpu.breakpoint.list").get("breakpoints"): raise RuntimeError("breakpoints present")
        first_tick = None; wall_start = time.monotonic()
        while True:
            host_before = time.monotonic()
            before = c.request("cpu.status")
            if before.get("stepping") or before.get("paused"): raise RuntimeError("CPU stopped")
            table = read(c, args.table, 0x400)
            indices = [args.pool] if args.pool is not None else [i for i in range(64)
                if struct.unpack_from("<I", table, i*16)[0] == args.owner]
            if not indices: raise RuntimeError("live-bound descriptor owner disappeared")
            blocks=[]
            for index in indices:
                h=table[index*16:(index+1)*16]
                owner, link, storage, packed = struct.unpack("<4I", h)
                start, count = packed & 0xFFFF, packed >> 16
                if not 0x08800000 <= storage < 0x0A000000 or start + count > 256:
                    raise RuntimeError("invalid pool storage or count")
                b = read(c, storage + start*64, count*64) if count else b""
                blocks.append((index,h,storage,start,count,b))
            table_after = read(c, args.table, 0x400)
            after = c.request("cpu.status")
            tick = (before["ticks"] + after["ticks"])/2
            if first_tick is None: first_tick = tick
            sample = {"tick": tick, "tickReadSpan": after["ticks"]-before["ticks"],
                      "hostReadSeconds": time.monotonic()-host_before,
                      "descriptors": [{"index":i,"hex":h.hex(),"storage":hex(st),"start":s,"count":n}
                                      for i,h,st,s,n,b in blocks],
                      "count": sum(n for i,h,st,s,n,b in blocks),
                      "headerStable": all(h == table_after[i*16:(i+1)*16] for i,h,st,s,n,b in blocks), "records": []}
            for index,h,storage,start,count,b in blocks:
                for i in range(count):
                    rb = b[i*64:(i+1)*64]
                    fields = {name: struct.unpack_from("<f", rb, offset)[0] for name, offset in OFFSETS.items()}
                    if not all(math.isfinite(x) for x in fields.values()): raise RuntimeError("nonfinite record")
                    if abs(fields["scale"] - args.expect_damping) > 1e-6 or not 1/181 < fields["lifeStep"] < 1/59:
                        rec["rejectedRecord"] = {"address": hex(storage+(start+i)*64), "fields": fields,
                            "base64": base64.b64encode(rb).decode(), "sample": {k:v for k,v in sample.items() if k != "records"}}
                        raise RuntimeError("pool does not match the live-bound DEC9C config/record layout")
                    sample["records"].append({"address": hex(storage+(start+i)*64),
                        "key": "-".join(rb[o:o+4].hex() for o in IMMUTABLE), "base64": base64.b64encode(rb).decode(), **fields})
            rec["samples"].append(sample)
            if (tick-first_tick)/TICK_HZ >= args.seconds: break
            if time.monotonic()-wall_start > args.seconds*4+10: raise RuntimeError("emulated clock did not advance")
            time.sleep(max(0, args.interval-(time.monotonic()-host_before)))
        rec["identityAfter"] = ws.identity(c)
        if rec["identityAfter"]["state"] != args.expect_state: raise RuntimeError("core state changed")
        if rec["identityAfter"]["module"] != ident["module"]: raise RuntimeError("module changed")
        rec["componentWordsAfter"] = {r: hex(ws.read_word(c, base+int(r,16))) for r in rec["componentWordsBefore"]}
        if rec["componentWordsAfter"] != rec["componentWordsBefore"]: raise RuntimeError("component words changed")
        tracks = {}; slopes = []; updates = []; scalar_slopes = []; births = []; lifetimes = []
        initial = {r["key"] for r in rec["samples"][0]["records"]}
        last_keys = set(initial); new_keys = set(); born = {}
        for i,s in enumerate(rec["samples"]):
            keys = {r["key"] for r in s["records"]}
            if len(keys) != len(s["records"]): raise RuntimeError("record identity collision")
            if i:
                for key in keys-last_keys:
                    new_keys.add(key); born[key] = s["tick"]; births.append(key)
                for key in last_keys-keys:
                    if key in born: lifetimes.append((s["tick"]-born.pop(key))/TICK_HZ)
            for r in s["records"]:
                prev = tracks.get(r["key"])
                if prev and prev[0] == i-1 and s["headerStable"] and rec["samples"][i-1]["headerStable"]:
                    dt=(s["tick"]-prev[1])/TICK_HZ
                    d=r["counter"]-prev[2]["counter"]
                    if dt > 0 and d < 0 and r["lifeStep"] > 0:
                        slopes.append(d/dt); updates.append(-d/(dt*r["lifeStep"]))
                        scalar_slopes.append((r["scalar"]-prev[2]["scalar"])/dt)
                tracks[r["key"]]=(i,s["tick"],r)
            last_keys=keys
        step_values = [t[2]["lifeStep"] for key,t in tracks.items() if key in new_keys]
        duration=(rec["samples"][-1]["tick"]-first_tick)/TICK_HZ
        if not slopes or not step_values: raise RuntimeError("no advancing/new DEC9C records observed")
        rec["summary"]={"emuSeconds":duration,"samples":len(rec["samples"]),
            "unstableHeaders":sum(not s["headerStable"] for s in rec["samples"]),
            "occupancy":stats([s["count"] for s in rec["samples"]]),
            "counterSlope":stats(slopes),"updatesPerEmuSecond":stats(updates),
            "scalarSlope":stats(scalar_slopes),"newRecordLifeStep":stats(step_values),
            "observedLifetimeSeconds":stats(lifetimes),"observedBirths":len(births),
            "observedBirthsPerEmuSecond":len(births)/duration}
        rec["breakpointsAfter"]=c.request("cpu.breakpoint.list").get("breakpoints",[])
        rec["result"]="PASS"
    except Exception as e:
        rec["result"]="FAILED";rec["error"]=str(e);raise
    finally:
        c.close();out.parent.mkdir(parents=True,exist_ok=True)
        out.write_text(json.dumps(rec,indent=1),encoding="utf-8")
        print(json.dumps({k:rec.get(k) for k in ("result","label","summary","error")},sort_keys=True))

if __name__=="__main__":main()
