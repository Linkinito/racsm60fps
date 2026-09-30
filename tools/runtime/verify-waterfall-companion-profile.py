#!/usr/bin/env python3
"""Read-only comparison of a built Waterfall recipe with the running RAM profile.

This verifies bytes/identity/health, not PRX loading or gameplay parity.
"""
import argparse, hashlib, importlib.util, json, time
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec); spec.loader.exec_module(module)
    return module


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--build", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    args = parser.parse_args()
    if args.out.exists(): raise RuntimeError("refusing to overwrite evidence")
    build = args.build.resolve()
    manifest = json.loads((build / "manifest.json").read_bytes())
    digest = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
    builder = REPO / "patches/experimental/waterfall-companion/build.py"
    if digest(builder) != manifest["builderSha256"]: raise RuntimeError("builder changed")
    for path, expected in manifest["inputs"].items():
        if digest(REPO/path) != expected: raise RuntimeError("recipe input changed: " + path)
    if digest(build/"recipe.generated.h") != manifest["recipeHeaderSha256"]:
        raise RuntimeError("generated header changed")
    if digest(build/"companion.c") != manifest["sourceSha256"]:
        raise RuntimeError("built source changed")
    if digest(build/"WaterfallExperimental/patch.prx") != manifest["prxSha256"]:
        raise RuntimeError("PRX changed")
    recipe = load("waterfall_build", builder)
    motion = load("waterfall_motion", REPO/"tools/runtime/apply-waterfall-mist-motion.py")
    rules, guards, vanilla, extent = recipe.recipe()
    if hex(extent) != manifest["targetSegmentExtent"]:
        raise RuntimeError("target segment extent changed")
    ws = motion.ws
    client = ws.DebuggerClient("127.0.0.1", 60907); client.connect()
    result = {"toolSha256": digest(Path(__file__)), "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
              "profile": manifest["profile"], "build": str(build), "manifest": manifest,
              "vanillaSha256": vanilla, "result": "FAILED", "words": []}
    try:
        before = ws.identity(client); result["identityBefore"] = before
        base = before["module"]["baseDecimal"]
        if before["state"] != "C1" or before["game"].get("id") != "UCES00420" or before["module"]["size"] != 0x46B900:
            raise RuntimeError("wrong core/module/game")
        if before["cpu"].get("paused") or before["cpu"].get("stepping"):
            raise RuntimeError("CPU stopped")
        if client.request("cpu.breakpoint.list").get("breakpoints"):
            raise RuntimeError("breakpoints active")
        def check(rva, expected, category):
            observed = ws.read_word(client, base+rva)
            result["words"].append({"rva":hex(rva),"expected":hex(expected),"observed":hex(observed),"category":category})
            if observed != expected: raise RuntimeError("profile mismatch at " + hex(rva))
        for rule in rules:
            value = rule["after"]; kind = rule["kind"]
            expected = motion.jump(base+value) if kind==1 else motion.lui(1,base+value) if kind==2 else motion.ori(1,base+value) if kind==3 else value
            check(rule["rva"], expected, "recipe")
        for rva, expected in guards.items(): check(rva, expected, "context")
        originals = {0x2D489C:0x3EAAAAAB,0x2D4924:0x3D75C290,0x2D4928:0x3DA3D70A,
                     0x2D4974:0x3DCCCCCE,0x2D4978:0x3E23D70A,0x2D488C:0x3F800000}
        for rva, expected in originals.items(): check(rva, expected, "excluded-probe-original")
        time.sleep(5)
        after = ws.identity(client); result["identityAfter"] = after
        if after["state"] != "C1" or after["module"] != before["module"]:
            raise RuntimeError("identity changed")
        if after["cpu"].get("stepping") or after["cpu"].get("paused") or after["cpu"]["ticks"] <= before["cpu"]["ticks"]:
            raise RuntimeError("CPU health failed")
        for word in result["words"]:
            if ws.read_word(client,base+int(word["rva"],16)) != int(word["expected"],16):
                raise RuntimeError("word changed during health window")
        result["breakpointsAfter"] = client.request("cpu.breakpoint.list").get("breakpoints",[])
        if result["breakpointsAfter"]: raise RuntimeError("breakpoint appeared")
        result["result"] = "PASS"
    except Exception as error:
        result["error"] = str(error); raise
    finally:
        client.close(); args.out.parent.mkdir(parents=True,exist_ok=True)
        args.out.write_text(json.dumps(result,indent=1),encoding="utf-8")
        print(json.dumps({"result":result["result"],"wordsChecked":len(result["words"]),"error":result.get("error"),"profile":result["profile"]}))


if __name__ == "__main__": main()
