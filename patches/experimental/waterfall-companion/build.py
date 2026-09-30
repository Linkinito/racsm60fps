#!/usr/bin/env python3
"""Build a separate C1 add-on from tested RAM recipes and the existing PSP SDK.

No installation, core patch, source-cache edit or original asset modification.
Refuses existing output. Guards every original word against hash-pinned ELF.
"""
import argparse, hashlib, importlib.util, json, os, re, shutil, struct, subprocess
from pathlib import Path

HERE=Path(__file__).resolve().parent; REPO=HERE.parents[2]
SDK=REPO/"01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/toolchains/pspdev-win"
BASE=0x09139D00

def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path); mod=importlib.util.module_from_spec(spec); spec.loader.exec_module(mod); return mod
def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def recipe():
    motion=load("motion_recipe",REPO/"tools/runtime/apply-waterfall-mist-motion.py")
    droplets=load("droplet_recipe",REPO/"tools/runtime/apply-waterfall-004.py")
    spawn=load("spawn_recipe",REPO/"tools/runtime/apply-mist-spawn.py")
    static=load("static_recipe",REPO/"research/scripts/analyze-waterfall-mist-halfangle.py")
    flap=load("flap_recipe",REPO/"tools/runtime/apply-butterfly-flap.py")
    raw=static.REFERENCE.read_bytes()
    if hashlib.sha256(raw).hexdigest()!=static.EXPECTED_SHA256: raise RuntimeError("vanilla hash mismatch")
    segments=static.load_segments(raw)
    # Kernel module-info reports PT_LOAD memory extents, whereas the debugger
    # reports the rounded allocation. Derive the kernel guard from pinned ELF.
    phoff=struct.unpack_from("<I",raw,28)[0]
    entsize,count=struct.unpack_from("<HH",raw,42)
    loads=[struct.unpack_from("<8I",raw,phoff+i*entsize) for i in range(count)]
    loads=[p for p in loads if p[0]==1]
    if not loads or min(p[2] for p in loads)!=0:raise RuntimeError("unexpected target load origin")
    extent=max(p[2]+p[5] for p in loads)
    if extent!=0x46B830:raise RuntimeError("unexpected pinned target memory extent")
    def word(rva):
        match=[off+rva-va for va,off,size,flags in segments if va<=rva and rva+4<=va+size]
        if len(match)!=1:raise RuntimeError("unmapped vanilla word")
        return struct.unpack_from("<I",raw,match[0])[0]
    rules=[];redirects=[];guards={**motion.CONTEXT,**motion.ALPHA_CONTEXT,**spawn.CONTEXT,**flap.CONTEXT,0x152038:0x460D6300,
                                0x151ED4:0x24850001,0x151EE8:0x1480007F,
                                0xDE074:0xC7AD0080,0xDE078:0xE60D0044,
                                0x2D489C:0x3EAAAAAB,0x2D488C:0x3F800000,
                                0x2D4924:0x3D75C290,0x2D4928:0x3DA3D70A,
                                0x2D4974:0x3DCCCCCE,0x2D4978:0x3E23D70A,
                                0x2D4968:0x00000000,0x2D491C:0x3F800000}
    drop_originals={rva:orig for rva,orig,*_ in droplets.SITES}
    def add(rva,before,after,kind=0,cave=0):
        if word(rva)!=before:raise RuntimeError(f"reference mismatch at{rva:#x}")
        rules.append({"rva":rva,"before":before,"after":after,"kind":kind,"cave":cave})
    for name,site in motion.SITES.items():
        rva,orig,cave,delay,*_=site
        guards[rva+4]=delay
        for i,w in enumerate(motion.cave_words(name,BASE)):
            kind=0; value=w
            if w>>26==2:kind=1;value=((w&0x03FFFFFF)<<2)-BASE
            if name=="rotation" and i in(0,1):kind=2+i;value=0x2D49B8
            if name=="drop-rotation" and i in(0,1,4,5):kind=2+(i%2);value=0x2D4918 if i<4 else 0x2D4968
            if name=="drop-scalar" and i in(1,2,5,6):kind=2+((i-1)%2);value=0x2D4918 if i<5 else 0x2D4968
            if name=="drop-alpha" and i in(1,2,6,7,11,12):
                kind=2 if i in(1,6,11) else 3
                value=0x2D48A8 if i<6 else 0x2D48AC if i<11 else 0x2D4A18
            add(cave+i*4,0,value,kind,1)
        redirects.append((rva,drop_originals.get(rva,orig),cave,1,0))
    for rva,orig,patched,cave,words in droplets.SITES[3:]:
        guards[rva+4]=word(rva+4)
        for i in range(8):
            w=words[i] if i<len(words) else 0;kind=0;value=w
            if w>>26==2:kind=1;value=((w&0x03FFFFFF)<<2)-BASE
            add(cave-BASE+i*4,0,value,kind,1)
        redirects.append((rva,orig,cave-BASE,1,0))
    for i,w in enumerate(flap.cave_words(BASE)):
        kind=1 if w>>26==2 else 0
        value=((w&0x03FFFFFF)<<2)-BASE if kind else w
        add(flap.CAVE+i*4,0,value,kind,1)
    redirects.append((flap.SITE,flap.ORIGINAL,flap.CAVE,1,0))
    for args in redirects:add(*args)
    add(*droplets.F2_SITE)
    # Common emitter gate supersedes the separate foam40 phase-data half-step.
    # Suppression diagnostic and rejected speed-probe words are excluded.
    selected={**spawn.PAIR,**spawn.DAMPING,**spawn.DROP_DAMPING,**spawn.EMITTER_GATE}
    for rva,(orig,replacement) in selected.items():add(rva,orig,replacement)
    if len({r["rva"] for r in rules})!=len(rules):raise RuntimeError("overlapping rules")
    for rva,expected in guards.items():
        if word(rva)!=expected:raise RuntimeError("guard mismatch")
        if any(r["rva"]==rva for r in rules):raise RuntimeError("guard overlaps edited word")
    # Rebase three independent supported memory locations; compare EVERY word
    # with the same tested runtime generator, including both config immediates.
    for base in (0x08810000,BASE,0x09400000):
        resolved={r["rva"]:(motion.jump(base+r["after"]) if r["kind"]==1 else
            motion.lui(1,base+r["after"]) if r["kind"]==2 else motion.ori(1,base+r["after"]) if r["kind"]==3 else r["after"]) for r in rules}
        for name,site in motion.SITES.items():
            for i,w in enumerate(motion.cave_words(name,base)):
                if resolved[site[2]+i*4]!=w:raise RuntimeError("rebase mismatch")
        for rva,orig,patched,cave,words in droplets.SITES[3:]:
            if resolved[rva]!=motion.jump(base+cave-BASE):raise RuntimeError("droplet redirect mismatch")
        for i,w in enumerate(flap.cave_words(base)):
            if resolved[flap.CAVE+i*4]!=w:raise RuntimeError("Butterfly cave rebase mismatch")
        if resolved[flap.SITE]!=motion.jump(base+flap.CAVE):raise RuntimeError("Butterfly redirect rebase mismatch")
    return rules,guards,static.EXPECTED_SHA256,extent

def main():
    ap=argparse.ArgumentParser(description=__doc__.splitlines()[0]);ap.add_argument("--name",default="WaterfallExperimental-v13");args=ap.parse_args()
    if not args.name.replace("-","").isalnum():raise ValueError("unsafe output name")
    build=HERE/"build"/args.name
    if build.exists():raise RuntimeError("refusing existing build")
    if not(SDK/"bin/psp-gcc.exe").is_file():raise RuntimeError("existing SDK unavailable")
    rules,guards,vanilla,extent=recipe(); build.mkdir(parents=True)
    source=build/"companion.c";shutil.copy2(HERE/"companion.c",source)
    header="/* Generated guarded recipe. Regenerate; never hand-edit. */\n"
    header+="#define TARGET_LOAD_EXTENT 0x%Xu\nstatic const Rule rules[]={\n"%extent
    header+="".join(" {0x%Xu,0x%08Xu,0x%08Xu,%du,%du},\n"%(r["rva"],r["before"],r["after"],r["kind"],r["cave"]) for r in rules)
    header+="};\nstatic const Guard guards[]={\n"+"".join(" {0x%Xu,0x%08Xu},\n"%(r,w) for r,w in sorted(guards.items()))+"};\n"
    (build/"recipe.generated.h").write_text(header,encoding="utf-8")
    env=os.environ.copy();env["PATH"]=str(SDK/"bin")+os.pathsep+env.get("PATH","")
    cc=SDK/"bin/psp-gcc.exe";pspsdk=SDK/"psp/sdk"
    flags=["-O2","-G0","-std=c11","-Wall","-Wextra","-Werror","-fno-strict-aliasing","-D_PSP_FW_VERSION=660","-I.","-I"+(SDK/"psp/include").as_posix(),"-I"+(pspsdk/"include").as_posix()]
    def run(command):
        result=subprocess.run([str(x) for x in command],cwd=build,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        if result.stdout:print(result.stdout,end="")
        if result.returncode:raise RuntimeError("build failed: "+str(command[0]))
    run([cc,*flags,"-c","companion.c","-o","companion.o"])
    run([cc,*flags,"-L"+(SDK/"psp/lib").as_posix(),"-L"+(pspsdk/"lib").as_posix(),"-specs="+(pspsdk/"lib/prxspecs").as_posix(),"-Wl,-q,-T"+(pspsdk/"lib/linkfile.prx").as_posix(),"-Wl,-zmax-page-size=128","companion.o",(pspsdk/"lib/prxexports.o").as_posix(),"-o","patch.elf"])
    symbols=subprocess.run([str(SDK/"bin/psp-nm.exe"),"patch.elf"],cwd=build,env=env,text=True,stdout=subprocess.PIPE,check=True).stdout
    heap=re.findall(r"(?m)^([0-9a-fA-F]+) D sce_newlib_heap_kb_size$",symbols)
    if len(heap)!=1:raise RuntimeError("missing explicit newlib heap limit")
    heap_rva=int(heap[0],16); linked=(build/"patch.elf").read_bytes()
    phoff=struct.unpack_from("<I",linked,28)[0];entsize,count=struct.unpack_from("<HH",linked,42)
    mapped=[]
    for i in range(count):
        kind,off,va,pa,filesz,memsz,flags,align=struct.unpack_from("<8I",linked,phoff+i*entsize)
        if kind==1 and va<=heap_rva and heap_rva+4<=va+filesz:mapped.append(off+heap_rva-va)
    if len(mapped)!=1 or struct.unpack_from("<I",linked,mapped[0])[0]!=64:
        raise RuntimeError("linked newlib heap must be exactly64KiB")
    run([SDK/"bin/psp-fixup-imports.exe","patch.elf"])
    run([SDK/"bin/psp-prxgen.exe","patch.elf","patch.prx"])
    package=build/"WaterfallExperimental";package.mkdir();shutil.copy2(build/"patch.prx",package/"patch.prx");shutil.copy2(HERE/"plugin.ini",package/"plugin.ini")
    manifest={"status":"BUILT_EXPERIMENTAL_NOT_PRX_RUNTIME_VALIDATED","profile":"C1 core external + droplets006 + alpha007 for mist/droplets + surface foam40 waves + common emitter gate + Butterfly flap only; Butterfly motion/steering uncorrected, separate WaterWaves unchanged",
              "vanillaSha256":vanilla,"ruleCount":len(rules),"guardCount":len(guards),"rebaseChecks":3,
              "package":str(package),"sourceSha256":digest(source),"builderSha256":digest(Path(__file__)),"recipeHeaderSha256":digest(build/"recipe.generated.h"),
              "prxSha256":digest(package/"patch.prx"),"prxBytes":(package/"patch.prx").stat().st_size,
              "newlibHeapKb":64,"newlibHeapRva":hex(heap_rva),
              "targetSegmentExtent":hex(extent),"debuggerAllocationExtent":"0x46b900",
              "inputs":{p:digest(REPO/p) for p in ("tools/runtime/apply-waterfall-004.py","tools/runtime/apply-waterfall-mist-motion.py","tools/runtime/apply-mist-spawn.py","tools/runtime/apply-butterfly-flap.py","research/scripts/analyze-waterfall-mist-halfangle.py")}}
    (build/"manifest.json").write_text(json.dumps(manifest,indent=1),encoding="utf-8")
    print(json.dumps(manifest,sort_keys=True))

if __name__=="__main__":main()
