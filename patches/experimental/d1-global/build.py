#!/usr/bin/env python3
"""Build a passive broad wrapper candidate from pinned existing module recipes."""
import argparse, hashlib, importlib.util, json, os, re, shutil, struct, subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent; ROOT=HERE.parents[2]
LEGACY=ROOT/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.4-no-menu/sources/profiler'
SDK=ROOT/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/toolchains/pspdev-win'
REFERENCES=ROOT/'patches/experimental/lvl3-elevator-halfstep/recipe.json'
TABLE=LEGACY/'generated/wrapper_profiles.generated.c'
CORE={1:(0x96650,0x151E0,0x2FCFC,0x2FBBC),3:(0x9630C,0x14FD4,0x2E0A4,0x2DF64)}
# Bounded non-doubling historical lead: keep WF-002's original route initially.
TWO_PASS_FAMILIES={2}

def digest(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def sections(raw):
    off=struct.unpack_from('<I',raw,32)[0];size,n,idx=struct.unpack_from('<HHH',raw,46)
    rows=[struct.unpack_from('<10I',raw,off+i*size) for i in range(n)]
    pool=raw[rows[idx][4]:rows[idx][4]+rows[idx][5]]
    return {pool[r[0]:].split(b'\0',1)[0].decode():r for r in rows}
def relocate(word,kind,base):
    return (word&0xfc000000)|(((base+((word&0x03ffffff)<<2))>>2)&0x03ffffff) if kind else word
def make_profiles():
    text=TABLE.read_text(encoding='utf-8-sig'); result=[]; sources=[TABLE,REFERENCES]
    refs=json.loads(REFERENCES.read_bytes())['modules']
    inventory=[]
    pattern=r'\{(\d+)u, 0u, (\d+)u, "(LEVEL_\d+)", (0x[0-9A-F]+)u, (0x[0-9A-F]+)u,'
    for match in re.finditer(pattern,text):
        index,count,name,two,one=match.groups();index=int(index);count=int(count)
        inventory.append({'module':name,'compiledCallsites':count,'status':'SELECTED' if index in CORE else 'EXCLUDED_LEGACY_CRASH' if index in (15,21) else 'NOT_ENROLLED_FIRST_BUILD'})
        if index not in CORE: continue
        ref=next(r for r in refs if r['module']==name+'.PRX');path=ROOT/ref['source'];sources.append(path)
        if digest(path)!=ref['sha256']: raise ValueError('reference hash mismatch '+name)
        raw=path.read_bytes();sec=sections(raw)
        ph=struct.unpack_from('<I',raw,28)[0];size,n=struct.unpack_from('<HH',raw,42)
        loads=[struct.unpack_from('<8I',raw,ph+i*size) for i in range(n)]
        loads=[p for p in loads if p[0]==1]
        extent=max(p[2]+p[5] for p in loads)
        if min(p[2] for p in loads)!=0:raise ValueError('nonzero image origin')
        def word(rva):
            matches=[p[1]+rva-p[2] for p in loads if p[2]<=rva and rva+4<=p[2]+p[4]]
            if len(matches)!=1: raise ValueError('not file-backed '+hex(rva))
            return struct.unpack_from('<I',raw,matches[0])[0]
        reloc=sec['.rel.text'];relocs={struct.unpack_from('<I',raw,i)[0] for i in range(reloc[4],reloc[4]+reloc[5],8)}
        rules=[];guards={};sites=[]
        def guard(rva):
            w=word(rva);kind=int(rva in relocs)
            # Relocated HI/LO delay words retain their opcode/register guard;
            # their loader-resolved address immediate is deliberately masked.
            if kind and w>>26 not in (2,3): kind=2
            guards[rva]={'rva':rva,'word':w,'kind':kind}
        def add(rva,before,after,group,label,after_kind=0):
            if word(rva)!=before: raise ValueError('before-word mismatch '+label)
            kind=int(rva in relocs)
            if kind and before>>26 not in (2,3): raise ValueError('unsupported rule relocation')
            rules.append(dict(rva=rva,before=before,after=after,beforeKind=kind,afterKind=after_kind,group=group,label=label))
            guard(rva+4)
        wait,delta,loop,scalar=CORE[index]
        if word(wait)>>26!=3:raise ValueError('wait call missing')
        add(wait,word(wait),0,0,'core_wait')
        add(delta,0x3c043d08,0x3c043c88,0,'core_delta')
        add(loop,0x2a240002,0x2a240001,0,'core_player_pass')
        guard(scalar)
        if word(scalar)!=0x46006506:raise ValueError('C1 scalar changed')
        two=int(two,16)-0x09139d00;one=int(one,16)-0x09139d00
        if two-one!=0xcc:raise ValueError('unexpected helper/wrapper separation')
        for rva in range(one,two+0x80,4):guard(rva)
        block=re.search(r'kModule%dCallsites\[\] = \{(.*?)\n\};'%index,text,re.S).group(1)
        rows=re.findall(r'\{(0x[0-9A-F]+)u, (\d+)u, RCSM_POLICY_VANILLA, 0u\}',block)
        if len(rows)!=count:raise ValueError('callsite count')
        for ra,family in rows:
            rva=int(ra,16)-0x09139d00-8;family=int(family)
            before=0x0c000000|(two>>2);after=0x0c000000|(one>>2)
            if word(rva)!=before or rva not in relocs:raise ValueError('wrapper call/relocation mismatch '+hex(rva))
            delay=word(rva+4)
            if delay>>26 in (1,2,3,4,5,6,7,20,21,22,23) or (delay>>26==0 and delay&63 in (8,9)):
                raise ValueError('control transfer in delay slot')
            policy='two_pass' if family in TWO_PASS_FAMILIES else 'one_pass'
            sites.append(dict(rva=rva,family=family,policy=policy,before=before,after=before if policy=='two_pass' else after,delay=delay))
            if policy=='one_pass':add(rva,before,after,1,'WF-%03d'%family,1)
            else:guard(rva);guard(rva+4)
        # Retain measured local corrections as explicit, separable group2 rules.
        edit=ref['edits'][0];rva=int(edit['rva'],0)
        add(rva,int(edit['before_word'],0),int(edit['after_word'],0),2,'elevator_initializer')
        for c in edit['context']:
            address=rva+int(c['delta'],0)
            if word(address)!=int(c['word'],0):raise ValueError('elevator context')
            guard(address)
        if index==1:
            add(0x150f0c,0x3c043d08,0x3c043c88,2,'help_elapsed')
            for rva in (0x150f10,0x150f14,0x150f18,0x150f1c,0x150f24):guard(rva)
        addresses={r['rva'] for r in rules}
        if len(addresses)!=len(rules) or len(rules)>128:raise ValueError('overlap/capacity')
        for rva in addresses:guards.pop(rva,None)
        result.append(dict(index=index,module=name,extent=extent,reference=ref['source'],referenceSha256=ref['sha256'],
            twoPassRva=two,onePassRva=one,rules=rules,guards=sorted(guards.values(),key=lambda g:g['rva']),sites=sites))
    if {p['index'] for p in result}!={1,3} or len(inventory)!=15:raise ValueError('profile inventory')
    return result,inventory,sources

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--name',required=True);a=ap.parse_args()
    if not re.fullmatch('[A-Za-z0-9-]+',a.name):raise ValueError('unsafe build name')
    out=HERE/'build'/a.name
    if out.exists():raise ValueError('refusing existing build')
    profiles,inventory,sources=make_profiles();out.mkdir(parents=True)
    cc=SDK/'bin/psp-gcc.exe';version=subprocess.check_output([str(cc),'-dumpfullversion'],text=True).strip()
    if not re.fullmatch(r'\d+\.\d+\.\d+',version):raise ValueError('compiler version')
    tools=[SDK/'bin'/n for n in ('psp-gcc.exe','psp-as.exe','psp-ld.exe','psp-prxgen.exe','psp-fixup-imports.exe')]
    tools += [SDK/f'libexec/gcc/psp/{version}/cc1.exe',SDK/f'lib/gcc/psp/{version}/libgcc.a',SDK/'psp/lib/libc.a']
    inputs={str(p.relative_to(ROOT)):digest(p) for p in sources+[Path(__file__),HERE/'runtime.c',HERE/'engine.c',HERE/'plugin.ini']+tools}
    bid=hashlib.sha256(json.dumps(inputs,sort_keys=True,separators=(',',':')).encode()).hexdigest()
    header='#define BUILD_ID_BYTES {'+','.join('0x%02x'%v for v in bytes.fromhex(bid))+'}\n'
    for p in profiles:
        header+='static const Rule rules%d[]={\n'%p['index']
        header+=''.join(' {'+','.join('0x%xu'%r[k] for k in ('rva','before','after','beforeKind','afterKind','group'))+'},\n' for r in p['rules'])+'};\n'
        header+='static const Guard guards%d[]={\n'%p['index']
        header+=''.join(' {0x%xu,0x%xu,%du},\n'%(g['rva'],g['word'],g['kind']) for g in p['guards'])+'};\n'
    header+='#define PROFILE_COUNT %du\nstatic const Profile profiles[]={\n'%len(profiles)
    header+=''.join(' {%du,0x%xu,%du,%du,rules%d,guards%d},\n'%(p['index'],p['extent'],len(p['rules']),len(p['guards']),p['index'],p['index']) for p in profiles)+'};\n'
    (out/'profiles.generated.h').write_bytes(header.encode())
    for name in ('runtime.c','engine.c'):shutil.copyfile(HERE/name,out/name)
    env=os.environ.copy();env['PATH']=str(SDK/'bin')+os.pathsep+env.get('PATH','');psp=SDK/'psp/sdk'
    flags=['-O2','-G0','-Wall','-Wextra','-Werror','-fno-strict-aliasing','-D_PSP_FW_VERSION=660','-I.','-I'+(SDK/'psp/include').as_posix(),'-I'+(psp/'include').as_posix()]
    def run(cmd):
        p=subprocess.run(list(map(str,cmd)),cwd=out,env=env,capture_output=True,text=True)
        if p.returncode:raise RuntimeError(p.stdout+p.stderr)
        return p.stdout
    for name in ('runtime','engine'):run([cc,*flags,'-std=c11','-c',name+'.c','-o',name+'.o'])
    run([cc,*flags,'-L'+(SDK/'psp/lib').as_posix(),'-L'+(psp/'lib').as_posix(),'-specs='+(psp/'lib/prxspecs').as_posix(),'-Wl,-q,-T'+(psp/'lib/linkfile.prx').as_posix(),'-Wl,-zmax-page-size=128','runtime.o','engine.o',psp/'lib/prxexports.o','-o','patch.elf'])
    nm=run([SDK/'bin/psp-nm.exe','patch.elf']);symbols={name:int(rva,16) for rva,kind,name in re.findall(r'(?m)^([0-9a-fA-F]+) (\w) (\w+)$',nm)}
    elf=(out/'patch.elf').read_bytes();sec=sections(elf)
    def value(address):
        s=next(v for v in sec.values() if v[1]!=8 and v[3]<=address< v[3]+v[5])
        return struct.unpack_from('<I',elf,s[4]+address-s[3])[0]
    if value(symbols['sce_newlib_heap_kb_size'])!=16:raise ValueError('heap gate')
    if [value(symbols['d1_control']+4*i) for i in range(12)]!=[0x44314731,1]+[0]*10:raise ValueError('passive ABI gate')
    run([SDK/'bin/psp-fixup-imports.exe','patch.elf']);run([SDK/'bin/psp-prxgen.exe','patch.elf','patch.prx'])
    package=out/'D1Global';package.mkdir()
    for path in (out/'patch.prx',HERE/'plugin.ini'):shutil.copyfile(path,package/path.name)
    m=dict(status='BUILT_PASSIVE_NOT_RUNTIME_ACCEPTED',buildId=bid,profiles=profiles,inventory=inventory,
        policy=dict(default='one_pass',twoPassFamilies=sorted(TWO_PASS_FAMILIES),basis='INFERRED broad candidate; WF-002 historical non-doubling exception'),
        core='Current C1 three-word core; old scalar and other full_layers NOT imported',
        symbols={k:symbols[k] for k in ('d1_control','d1_build_id','d1_update','d1_owned','d1_rules','d1_count','d1_read','d1_write')},
        heapKb=16,prxSha256=digest(out/'patch.prx'),prxBytes=(out/'patch.prx').stat().st_size,inputs=inputs)
    (out/'manifest.json').write_bytes((json.dumps(m,indent=2)+'\n').encode())
    print(json.dumps({'build':str(out),'modules':[(p['module'],len(p['rules']),len(p['guards'])) for p in profiles],'sha256':m['prxSha256']}))
if __name__=='__main__':main()
