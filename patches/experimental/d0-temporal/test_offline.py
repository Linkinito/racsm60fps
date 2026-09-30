#!/usr/bin/env python3
"""Exercise linked MIPS d0_update code with adversarial IO, not a policy copy.

Only d0_read/d0_write are mocked. No PSP loader/scheduler/JIT acceptance implied.
"""
import argparse,hashlib,importlib.util,json,random,struct
from pathlib import Path
HERE=Path(__file__).resolve().parent
sp=importlib.util.spec_from_file_location('d0_builder',HERE/'build.py')
b=importlib.util.module_from_spec(sp);sp.loader.exec_module(b)
def signed(x,bits):return x-(1<<bits) if x&(1<<(bits-1)) else x
def image(raw):
    mem={}
    for s in b.sections(raw).values():
        if not s[2]&2:continue
        data=bytes(s[5]) if s[1]==8 else raw[s[4]:s[4]+s[5]]
        for i,v in enumerate(data):mem[s[3]+i]=v
    return mem
def run_engine(elf,manifest,base,initial,wanted,fault=None,foreign=None):
    mem=image(elf);sym=manifest['symbols'];game={base+r['rva']:r['after'] if initial&r['bit'] else r['before'] for r in manifest['rules']}
    def rd(addr):return sum(mem.get(addr+i,0)<<(8*i) for i in range(4))
    def wr(addr,v):
        for i in range(4):mem[addr+i]=(v>>(8*i))&255
    wr(sym['d0_owned'],initial)
    if foreign is not None:game[base+manifest['rules'][foreign]['rva']]=0xBAD0CAFE
    rng=random.Random(initial*16+wanted);g=[0]+[rng.getrandbits(32) for _ in range(31)]
    g[4]=base;g[5]=wanted;g[29]=0x09FF0000;g[31]=0x0FFFF000
    preserved={i:g[i] for i in [16,17,18,19,20,21,22,23,28,29,30]}
    pc=sym['d0_update'];writes=[];steps=0
    def simple(w):
        op=w>>26;rs=w>>21&31;rt=w>>16&31;rdn=w>>11&31;fn=w&63;imm=w&65535
        if w==0:pass
        elif op==9:g[rt]=(g[rs]+signed(imm,16))&0xFFFFFFFF
        elif op==15:g[rt]=imm<<16
        elif op==13:g[rt]=g[rs]|imm
        elif op==11:g[rt]=int(g[rs]<(signed(imm,16)&0xFFFFFFFF))
        elif op==35:g[rt]=rd((g[rs]+signed(imm,16))&0xFFFFFFFF)
        elif op==43:wr((g[rs]+signed(imm,16))&0xFFFFFFFF,g[rt])
        elif op==0 and fn==33:g[rdn]=(g[rs]+g[rt])&0xFFFFFFFF
        elif op==0 and fn==36:g[rdn]=g[rs]&g[rt]
        elif op==0 and fn==37:g[rdn]=g[rs]|g[rt]
        elif op==0 and fn==38:g[rdn]=g[rs]^g[rt]
        elif op==0 and fn==39:g[rdn]=~(g[rs]|g[rt])&0xFFFFFFFF
        elif op==0 and fn==10:
            if g[rt]==0:g[rdn]=g[rs]
        elif op==0 and fn==11:
            if g[rt]!=0:g[rdn]=g[rs]
        else:raise AssertionError('unsupported compiled ISA '+hex(w))
        g[0]=0
    while pc!=0x0FFFF000:
        steps+=1
        if steps>3000:raise AssertionError('compiled transaction did not return')
        if pc==sym['d0_read']:g[2]=game[g[4]];pc=g[31];continue
        if pc==sym['d0_write']:
            a,v=g[4],g[5];writes.append((a,v));n=len(writes)
            if fault and n==fault[0]:
                mode=fault[1]
                if mode=='delivered':game[a]=v
                elif mode=='foreign':game[a]=0xBAD0CAFE
                elif mode!='dropped':raise AssertionError('unknown fault')
                g[2]=0
            else:game[a]=v;g[2]=1
            pc=g[31];continue
        w=rd(pc);op=w>>26;rs=w>>21&31;rt=w>>16&31;fn=w&63
        target=None;likely=False;take=True
        if op in (4,5,20,21):
            take=(g[rs]==g[rt]) if op in (4,20) else (g[rs]!=g[rt]);likely=op>=20
            target=pc+4+4*signed(w&65535,16) if take else pc+8
        elif op in (2,3):
            target=((pc+4)&0xF0000000)|((w&0x03FFFFFF)<<2)
            if op==3:g[31]=pc+8
        elif op==0 and fn==8:target=g[rs]
        if target is None:simple(w);pc+=4
        else:
            if take or not likely:simple(rd(pc+4))
            pc=target
    assert all(g[i]==v for i,v in preserved.items()),'callee-saved context damaged'
    return signed(g[2],32),rd(sym['d0_owned']),game,writes,steps
def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--build',type=Path,required=True);ap.add_argument('--out',type=Path,required=True);a=ap.parse_args()
    if a.out.exists():raise ValueError('refusing result overwrite')
    m=json.loads((a.build/'manifest.json').read_bytes());elf=(a.build/'patch.elf').read_bytes()
    assert b.digest(a.build/'patch.prx')==m['prxSha256']
    assert all(b.digest(b.ROOT/p)==sha for p,sha in m['inputs'].items())
    cases=0;maxsteps=0
    for base in [0x08810000,0x09139D00,0x09400000]:
        for initial in range(4):
            for wanted in range(4):
                result,owned,game,writes,steps=run_engine(elf,m,base,initial,wanted)
                assert result==owned==wanted
                assert game=={base+r['rva']:r['after'] if wanted&r['bit'] else r['before'] for r in m['rules']}
                cases+=1;maxsteps=max(maxsteps,steps)
            for foreign in range(2):
                result,owned,game,writes,steps=run_engine(elf,m,base,initial,initial,foreign=foreign)
                assert result==-1 and owned==initial and not writes and game[base+m['rules'][foreign]['rva']]==0xBAD0CAFE
                cases+=1
        for initial,wanted in [(0,3),(3,0),(1,3),(3,1)]:
            for n in range(1,(initial^wanted).bit_count()+1):
                for mode in ['dropped','delivered']:
                    result,owned,game,writes,steps=run_engine(elf,m,base,initial,wanted,(n,mode))
                    assert result==-2 and owned==initial
                    assert game=={base+r['rva']:r['after'] if initial&r['bit'] else r['before'] for r in m['rules']}
                    cases+=1;maxsteps=max(maxsteps,steps)
        result,owned,game,writes,steps=run_engine(elf,m,base,0,3,(1,'foreign'))
        assert result==-3 and owned==1 and len(writes)==1 and game[base+m['rules'][0]['rva']]==0xBAD0CAFE
        cases+=1
        result,owned,game,writes,steps=run_engine(elf,m,base,0,4)
        assert result==-1 and owned==0 and not writes;cases+=1
    original=(m['rules'][0]['before']&65535)<<16|0x8889
    candidate=(m['rules'][0]['after']&65535)<<16|0x8889
    unpack=lambda v:struct.unpack('<f',struct.pack('<I',v))[0]
    assert original==0x3D088889 and candidate==0x3C888889 and unpack(candidate)*2==unpack(original)
    result={'status':'OFFLINE_PASS_NOT_RUNTIME_ACCEPTED','compiledEngineCases':cases,'maxInstructions':maxsteps,
            'gameBases':3,'rules':2,'guards':len(m['guards']),'candidateBits':hex(candidate),'heapKb':m['heapKb'],
            'manifestSha256':b.digest(a.build/'manifest.json'),'testSourceSha256':b.digest(Path(__file__)),
            'limits':'Linked instruction model mocks IO only. Does not test PSP module loader, monitor scheduling, cache invalidation, actual field cadence, gameplay transition or parity.'}
    a.out.parent.mkdir(parents=True,exist_ok=True);a.out.write_bytes((json.dumps(result,indent=2)+'\n').encode())
    print(json.dumps(result))
if __name__=='__main__':main()
