#!/usr/bin/env python3
"""Build guarded telemetry-only call probes from pinned Pokitaru/atlas inputs."""
import argparse,configparser,csv,hashlib,json,os,re,shutil,struct,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;REPO=HERE.parents[2]
SDK=REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/toolchains/pspdev-win'
REFERENCE=REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX'
ATLAS=REPO/'research/v2/c1-residual-timing-atlas/c1-residual-timing-atlas.csv'
LEGACY=REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.1/sources/profiler/callsite_redirect_plan.csv'
SHA='d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571'
BASE=0x09139D00
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def sections(raw):
    off=struct.unpack_from('<I',raw,32)[0];size,n,idx=struct.unpack_from('<HHH',raw,46)
    rows=[struct.unpack_from('<10I',raw,off+i*size) for i in range(n)]
    ss=rows[idx];strings=raw[ss[4]:ss[4]+ss[5]]
    return {strings[s[0]:].split(b'\0',1)[0].decode():s for s in rows}
def delay_safe(w,reg):
    """Refuse control transfers/unknown ISA or changes to latched JALR target."""
    op=w>>26;rs=(w>>21)&31;rt=(w>>16)&31;rd=(w>>11)&31;fn=w&63
    if w==0:return True
    if op==0 and fn in (0,2,3,4,6,7,10,11,16,18,32,33,34,35,36,37,38,39,42,43):written=rd
    elif op in (8,9,10,11,12,13,14,15,32,33,34,35,36,37,38):written=rt
    elif op in (40,41,42,43,46,49,57):written=0
    elif op==17 and rs in (4,6,16,17,20,21):written=0
    else:return False
    return written!=31 and (reg==0 or written!=reg)
def generate():
    raw=REFERENCE.read_bytes()
    if digest(REFERENCE)!=SHA:raise RuntimeError('vanilla hash mismatch')
    sec=sections(raw);text=sec['.text'];data=raw[text[4]:text[4]+text[5]]
    reloc=sec['.rel.text'];relocated={struct.unpack_from('<I',raw,i)[0] for i in range(reloc[4],reloc[4]+reloc[5],8)}
    def word(rva):return struct.unpack_from('<I',data,rva-text[3])[0]
    callbacks={}
    for row in csv.DictReader(ATLAS.open(encoding='utf-8-sig',newline='')):
        for item in row['update_functions'].split(';'):
            if not item.startswith('M01:'):continue
            rva=int(item.split(':')[1],16)
            if not 0<rva<len(data) or rva&3:raise RuntimeError('invalid atlas RVA')
            entry=callbacks.setdefault(rva,{'rva':rva,'aliases':[],'pvarOffset':0,'fields':[]})
            entry['aliases'].append({'class':row['class_name'],'family':row['primary_family'],'evidence':row['family_evidence']})
    # Only independently field-bound channels; positions remain raw context.
    known={'Lvl3Elevator':(0x54,[('progress',8),('progressIncrement',12)]),
           'Level01HelpManager':(0x58,[('cyclicHelpTimer',0x1C)]),
           'Acidbomb':(0x58,[('gravityLike08',8),('deltaTimer0C',12),('integration10',16),('integration14',20),('integration18',24),('deltaTimer34',0x34)])}
    for cb in callbacks.values():
        labels={a['class'] for a in cb['aliases']}
        for label,(off,fields) in known.items():
            if labels!={label}:continue
            # Require the exact lw ...,offset(a0) shape used by bound callbacks.
            if not any(word(cb['rva']+i)&0xFFE0FFFF==0x8C800000|off for i in range(0,96,4)):
                raise RuntimeError('bound pvar load not reproduced: '+label)
            cb['pvarOffset']=off;cb['fields']=[{'name':name,'offset':offset} for name,offset in fields]
    legacy={int(row['callsite_runtime'],16)-BASE:int(row['family_id'].split('-')[1]) for row in csv.DictReader(LEGACY.open(encoding='utf-8-sig',newline='')) if row['module_index']=='1'}
    sites=[];excluded=[]
    for rva in range(text[3],text[3]+text[5]-4,4):
        w,d=word(rva),word(rva+4);op=w>>26;reg=0;direct=0;reason=None
        if w&0xFC1FFFFF==0x0000F809:
            reg=(w>>21)&31
            if reg in (0,26,27,29,31):reason='unsupported-target-register'
        elif op==3:
            target=(w&0x03FFFFFF)<<2
            if rva not in legacy and target not in callbacks:continue
            if not 0<target<len(data):raise RuntimeError('external direct target')
            direct=target
        else:continue
        if rva+4 in relocated:reason='relocated-delay-slot'
        if not delay_safe(d,reg):reason='delay-changes-target-or-unsupported-ISA'
        if reason:excluded.append({'rva':rva,'reason':reason});continue
        sites.append({'rva':rva,'word':w,'delay':d,'direct':direct,'reg':reg,'family':legacy.get(rva,0)})
    if not sites or len(sites)>512 or len(callbacks)>512:raise RuntimeError('unexpected recorder scope')
    guards=[]
    for start in (0x151D78,0x150EF8,0x122C90):
        for rva in range(start,start+32,4):
            if rva not in relocated and rva not in {s['rva'] for s in sites}:
                guards.append({'rva':rva,'word':word(rva)})
    if len(guards)<12:raise RuntimeError('insufficient content guards')
    return sites,sorted(callbacks.values(),key=lambda c:c['rva']),guards,excluded
def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--name',default='v1');a=ap.parse_args()
    if not re.fullmatch('[A-Za-z0-9-]+',a.name):raise ValueError('unsafe build name')
    config=configparser.ConfigParser();config.read(HERE/'plugin.ini')
    if dict(config['options'])!={'version':'1','type':'prx','filename':'patch.prx'} or config['games'].get('uces00420')!='true':raise RuntimeError('invalid PPSSPP loader descriptor')
    out=HERE/'build'/a.name
    if out.exists():raise RuntimeError('refusing existing build')
    sites,callbacks,guards,excluded=generate();out.mkdir(parents=True)
    tools=[SDK/'bin'/name for name in ('psp-gcc.exe','psp-as.exe','psp-ld.exe','psp-fixup-imports.exe','psp-prxgen.exe')]
    version=subprocess.check_output([str(SDK/'bin/psp-gcc.exe'),'-dumpfullversion'],text=True).strip()
    if not re.fullmatch(r'\d+\.\d+\.\d+',version):raise RuntimeError('unexpected compiler version')
    # This portable SDK retains baked /pspdev-win query paths; locate its
    # already-installed compiler components inside the authorized SDK root.
    tools.extend([SDK/f'libexec/gcc/psp/{version}/cc1.exe',SDK/f'lib/gcc/psp/{version}/libgcc.a'])
    tools.extend([SDK/'psp/lib/libc.a',SDK/'psp/sdk/lib/prxexports.o',SDK/'psp/sdk/lib/prxspecs',SDK/'psp/sdk/lib/linkfile.prx'])
    inputs={str(p.relative_to(REPO)):digest(p) for p in (REFERENCE,ATLAS,LEGACY,HERE/'recorder.c',HERE/'hook.S',HERE/'plugin.ini',Path(__file__),*tools)}
    build_id=hashlib.sha256(json.dumps(inputs,sort_keys=True,separators=(',',':')).encode()).hexdigest()
    header='/* Generated from hash-pinned reference and existing atlas. */\n'
    header+='#define BUILD_ID_BYTES {'+','.join('0x%02X'%b for b in bytes.fromhex(build_id))+'}\n'
    header+=f'#define SITE_COUNT {len(sites)}u\n#define CALLBACK_COUNT {len(callbacks)}u\n#define GUARD_COUNT {len(guards)}u\n'
    header+='static const Site sites[]={\n'+''.join(' {%s},\n'%','.join('0x%Xu'%s[k] for k in ('rva','word','delay','direct','reg','family')) for s in sites)+'};\n'
    header+='static const Callback callbacks[]={\n'+''.join(' {0x%Xu,0x%Xu,{%s}},\n'%(c['rva'],c['pvarOffset'],','.join('0x%Xu'%v for v in [f['offset'] for f in c['fields']]+[0xFFFFFFFF]*(6-len(c['fields'])))) for c in callbacks)+'};\n'
    header+='static const Guard guards[]={\n'+''.join(' {0x%Xu,0x%Xu},\n'%(g['rva'],g['word']) for g in guards)+'};\n'
    (out/'sites.generated.h').write_text(header,encoding='utf-8')
    for name in ('recorder.c','hook.S'):shutil.copy2(HERE/name,out/name)
    env=os.environ.copy();env['PATH']=str(SDK/'bin')+os.pathsep+env.get('PATH','');psp=SDK/'psp/sdk';cc=SDK/'bin/psp-gcc.exe'
    flags=['-O2','-G0','-Wall','-Wextra','-Werror','-fno-strict-aliasing','-D_PSP_FW_VERSION=660','-I.','-I'+(SDK/'psp/include').as_posix(),'-I'+(psp/'include').as_posix()]
    def run(cmd,quiet=False):
        p=subprocess.run(list(map(str,cmd)),cwd=out,env=env,capture_output=True,text=True)
        if not quiet and (p.stdout or p.stderr):print(p.stdout+p.stderr,end='')
        if p.returncode:raise RuntimeError('build failed: '+str(cmd[0]))
        return p.stdout
    run([cc,*flags,'-std=c11','-c','recorder.c','-o','recorder.o']);run([cc,*flags,'-c','hook.S','-o','hook.o'])
    run([cc,*flags,'-L'+(SDK/'psp/lib').as_posix(),'-L'+(psp/'lib').as_posix(),'-specs='+(psp/'lib/prxspecs').as_posix(),'-Wl,-q,-T'+(psp/'lib/linkfile.prx').as_posix(),'-Wl,-zmax-page-size=128','recorder.o','hook.o',psp/'lib/prxexports.o','-o','patch.elf'])
    nm=run([SDK/'bin/psp-nm.exe','patch.elf'],quiet=True)
    symbols={name:int(rva,16) for rva,kind,name in re.findall(r'(?m)^([0-9a-fA-F]+) (\w) (\w+)$',nm)}
    elf=(out/'patch.elf').read_bytes();s=sections(elf);heap=symbols['sce_newlib_heap_kb_size'];section=next(v for v in s.values() if v[1]!=8 and v[3]<=heap<v[3]+v[5])
    if struct.unpack_from('<I',elf,section[4]+heap-section[3])[0]!=16:raise RuntimeError('heap gate failed')
    run([SDK/'bin/psp-fixup-imports.exe','patch.elf']);run([SDK/'bin/psp-prxgen.exe','patch.elf','patch.prx'])
    package=out/'FamilyRecorder';package.mkdir();shutil.copy2(out/'patch.prx',package/'patch.prx');shutil.copy2(HERE/'plugin.ini',package/'plugin.ini')
    manifest={'status':'BUILT_NOT_RUNTIME_ACCEPTED','schema':2,'buildId':build_id,'sites':sites,'callbacks':callbacks,'guards':guards,'excludedSites':excluded,'symbols':{k:symbols[k] for k in ('recorder_control','recorder_hook','recorder_hook_end','recorder_hit','recorder_build_id')},'heapKb':16,'prxSha256':digest(out/'patch.prx'),'inputs':inputs,'coverageLimit':'Instrumented calls prove invoked callback aliases, not every class or every mechanic. Unhooked paths remain UNKNOWN. Physics field semantics/lifecycle and emulated clock require live acceptance.'}
    (out/'manifest.json').write_text(json.dumps(manifest,indent=1),encoding='utf-8')
    print(json.dumps({'build':str(out),'sites':len(sites),'callbacks':len(callbacks),'excluded':len(excluded),'prxSha256':manifest['prxSha256']}))
if __name__=='__main__':main()
