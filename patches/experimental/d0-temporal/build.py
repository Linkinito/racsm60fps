#!/usr/bin/env python3
"""Build passive D0 temporal prototype using the existing read-only PSP SDK."""
import argparse,hashlib,json,os,re,shutil,struct,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent; ROOT=HERE.parents[2]
SDK=ROOT/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/toolchains/pspdev-win'
REF=ROOT/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX'
PIN='d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571'
RULES=[{'name':'help_elapsed_1C','rva':0x150F0C,'before':0x3C043D08,'after':0x3C043C88,'bit':1,
        'eligibility':'Measured residual and source consumer; experimental causal test pending'},
       {'name':'enemywave_fixed_countdown','rva':0x137F5C,'before':0x3C043D08,'after':0x3C043C88,'bit':2,
        'eligibility':'Static fixed-step path only; unmeasured runtime cadence, explicit opt-in gate'}]
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def sections(raw):
    off=struct.unpack_from('<I',raw,32)[0];size,n,idx=struct.unpack_from('<HHH',raw,46)
    ss=[struct.unpack_from('<10I',raw,off+i*size) for i in range(n)]
    pool=raw[ss[idx][4]:ss[idx][4]+ss[idx][5]]
    return {pool[s[0]:].split(b'\0',1)[0].decode():s for s in ss}
def target_recipe():
    raw=REF.read_bytes()
    if digest(REF)!=PIN:raise ValueError('pinned target hash mismatch')
    ph=struct.unpack_from('<I',raw,28)[0];sz,n=struct.unpack_from('<HH',raw,42)
    segs=[struct.unpack_from('<8I',raw,ph+i*sz) for i in range(n)]
    segs=[s for s in segs if s[0]==1]
    extent=max(s[2]+s[5] for s in segs)
    if min(s[2] for s in segs)!=0 or extent!=0x46B830:raise ValueError('target extent')
    def word(rva):
        matches=[s[1]+rva-s[2] for s in segs if s[2]<=rva and rva+4<=s[2]+s[4]]
        if len(matches)!=1:raise ValueError('unbacked word')
        return struct.unpack_from('<I',raw,matches[0])[0]
    sec=sections(raw);rel=sec['.rel.text']
    relocated={struct.unpack_from('<I',raw,i)[0] for i in range(rel[4],rel[4]+rel[5],8)}
    sites={r['rva'] for r in RULES}
    for r in RULES:
        if word(r['rva'])!=r['before'] or r['rva'] in relocated:raise ValueError('rule reference/relocation')
    expected={0x150F10:0xC62C001C,0x150F14:0x34848889,0x150F18:0x44846800,
              0x150F1C:0x460D6300,0x150F24:0xE62C001C,
              0x137F60:0x44807000,0x137F64:0xC62C000C,0x137F68:0x34848889,
              0x137F6C:0x44846800,0x137F70:0x460D6301,0x137F80:0xE62C000C,
              0x137FFC:0xC62D000C,0x138004:0x460C6B01,0x138014:0xE62C000C}
    for rva,w in expected.items():
        if word(rva)!=w:raise ValueError('dataflow anchor mismatch '+hex(rva))
    spans=[(0x150EF8,0x150F88),(0x137D9C,0x137DE8),(0x137F50,0x137F84),(0x137FFC,0x138018)]
    guards=[{'rva':rva,'word':word(rva)} for rva in sorted({r for a,b in spans for r in range(a,b,4)}-sites-relocated)]
    if len(guards)<24:raise ValueError('insufficient content guards')
    return guards,extent
def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--name',required=True);a=ap.parse_args()
    if not re.fullmatch(r'[A-Za-z0-9-]+',a.name):raise ValueError('unsafe build name')
    out=HERE/'build'/a.name
    if out.exists():raise ValueError('refusing existing output')
    guards,extent=target_recipe();out.mkdir(parents=True)
    cc=SDK/'bin/psp-gcc.exe';version=subprocess.check_output([str(cc),'-dumpfullversion'],text=True).strip()
    if not re.fullmatch(r'\d+\.\d+\.\d+',version):raise ValueError('compiler version')
    toolpaths=[SDK/'bin'/n for n in ('psp-gcc.exe','psp-as.exe','psp-ld.exe','psp-prxgen.exe','psp-fixup-imports.exe')]
    toolpaths += [SDK/f'libexec/gcc/psp/{version}/cc1.exe',SDK/f'lib/gcc/psp/{version}/libgcc.a',SDK/'psp/lib/libc.a']
    inputs={str(p.relative_to(ROOT)):digest(p) for p in [Path(__file__),HERE/'d0.c',HERE/'engine.c',HERE/'plugin.ini',REF,*toolpaths]}
    bid=hashlib.sha256(json.dumps(inputs,sort_keys=True,separators=(',',':')).encode()).hexdigest()
    recipe='#define RULE_COUNT 2u\nstatic const Rule rules[]={\n'
    recipe+=''.join(' {0x%Xu,0x%Xu,0x%Xu,0x%Xu},\n'%(r['rva'],r['before'],r['after'],r['bit']) for r in RULES)+'};\n'
    (out/'recipe.generated.h').write_bytes(recipe.encode())
    header='#define TARGET_EXTENT 0x%Xu\n#define GUARD_COUNT %du\n'%(extent,len(guards))
    header+='#define BUILD_ID_BYTES {'+','.join('0x%02X'%v for v in bytes.fromhex(bid))+'}\n'
    header+='static const Guard guards[]={\n'+''.join(' {0x%Xu,0x%Xu},\n'%(g['rva'],g['word']) for g in guards)+'};\n'
    (out/'guards.generated.h').write_bytes(header.encode())
    for name in ('d0.c','engine.c'):shutil.copyfile(HERE/name,out/name)
    env=os.environ.copy();env['PATH']=str(SDK/'bin')+os.pathsep+env.get('PATH','');psp=SDK/'psp/sdk'
    flags=['-O2','-G0','-Wall','-Wextra','-Werror','-fno-strict-aliasing','-D_PSP_FW_VERSION=660','-I.','-I'+(SDK/'psp/include').as_posix(),'-I'+(psp/'include').as_posix()]
    def run(cmd):
        p=subprocess.run(list(map(str,cmd)),cwd=out,env=env,capture_output=True,text=True)
        if p.returncode:raise RuntimeError(p.stdout+p.stderr)
        return p.stdout
    for name in ('d0','engine'):run([cc,*flags,'-std=c11','-c',name+'.c','-o',name+'.o'])
    run([cc,*flags,'-L'+(SDK/'psp/lib').as_posix(),'-L'+(psp/'lib').as_posix(),'-specs='+(psp/'lib/prxspecs').as_posix(),'-Wl,-q,-T'+(psp/'lib/linkfile.prx').as_posix(),'-Wl,-zmax-page-size=128','d0.o','engine.o',psp/'lib/prxexports.o','-o','patch.elf'])
    nm=run([SDK/'bin/psp-nm.exe','patch.elf'])
    symbols={name:int(rva,16) for rva,kind,name in re.findall(r'(?m)^([0-9a-fA-F]+) (\w) (\w+)$',nm)}
    elf=(out/'patch.elf').read_bytes();sec=sections(elf)
    def value(addr):
        s=next(v for v in sec.values() if v[1]!=8 and v[3]<=addr< v[3]+v[5])
        return struct.unpack_from('<I',elf,s[4]+addr-s[3])[0]
    if value(symbols['sce_newlib_heap_kb_size'])!=16:raise ValueError('heap gate')
    if [value(symbols['d0_control']+4*i) for i in range(10)]!=[0x44305430,1,0,0,0,0,0,0,0,0]:raise ValueError('passive ABI gate')
    run([SDK/'bin/psp-fixup-imports.exe','patch.elf']);run([SDK/'bin/psp-prxgen.exe','patch.elf','patch.prx'])
    package=out/'D0Temporal';package.mkdir();shutil.copyfile(out/'patch.prx',package/'patch.prx');shutil.copyfile(HERE/'plugin.ini',package/'plugin.ini')
    m={'status':'BUILT_PASSIVE_NOT_RUNTIME_ACCEPTED','profile':'D0 = external C1 + scoped float-step candidate; no cascade/wing additions',
       'buildId':bid,'rules':RULES,'guards':guards,'targetExtent':extent,'heapKb':16,
       'symbols':{k:symbols[k] for k in ('d0_control','d0_build_id','d0_update','d0_owned','d0_read','d0_write')},
       'prxSha256':digest(out/'patch.prx'),'prxBytes':(out/'patch.prx').stat().st_size,'inputs':inputs,
       'excluded':['EnemyWave dynamic-f12 branch137FFC','Polarizer consumer unknown','integer event/resource counters','delta-aware countdowns','nonlinear pursuit','cascade/wing additions','other LEVEL modules']}
    (out/'manifest.json').write_bytes((json.dumps(m,indent=2)+'\n').encode())
    print(json.dumps({'build':str(out),'rules':len(RULES),'guards':len(guards),'prxSha256':m['prxSha256'],'status':m['status']}))
if __name__=='__main__':main()
