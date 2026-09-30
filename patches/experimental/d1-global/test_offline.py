#!/usr/bin/env python3
"""Execute linked D1 transaction MIPS with faulted IO, at three game bases."""
import argparse, hashlib, importlib.util, json, random, struct
from pathlib import Path
HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('d1_builder',HERE/'build.py')
b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
def signed(x,bits=32):return x-(1<<bits) if x&(1<<(bits-1)) else x
def run(elf,m,profile,base,initial,wanted,fault=None,foreign=None):
    mem={};sym=m['symbols']
    for s in b.sections(elf).values():
        if s[2]&2:
            data=bytes(s[5]) if s[1]==8 else elf[s[4]:s[4]+s[5]]
            mem.update({s[3]+i:v for i,v in enumerate(data)})
    def rd(a):return sum(mem.get(a+i,0)<<(8*i) for i in range(4))
    def wr(a,v):
        for i in range(4):mem[a+i]=(v>>(8*i))&255
    rows=[(r['rva'],b.relocate(r['before'],r['beforeKind'],base),b.relocate(r['after'],r['afterKind'],base),r['group']) for r in profile['rules']]
    def words(mode):return {base+rva:after if mode==1 or mode==2 and group==0 else before for rva,before,after,group in rows}
    game=words(initial)
    for i,row in enumerate(rows):
        for j,v in enumerate(row):wr(sym['d1_rules']+16*i+4*j,v)
    wr(sym['d1_count'],len(rows));wr(sym['d1_owned'],initial)
    if foreign is not None:game[base+rows[foreign][0]]=0xbad0cafe
    rng=random.Random(100*initial+wanted);g=[0]+[rng.getrandbits(32) for _ in range(31)]
    g[4]=base;g[5]=wanted;g[29]=0x09ff0000;g[31]=0x0ffff000
    preserved={i:g[i] for i in (16,17,18,19,20,21,22,23,28,29,30)}
    pc=sym['d1_update'];writes=[];steps=0
    def simple(w):
        op=w>>26;rs=w>>21&31;rt=w>>16&31;dest=w>>11&31;fn=w&63;imm=w&65535;shift=w>>6&31
        if w==0:pass
        elif op==9:g[rt]=(g[rs]+signed(imm,16))&0xffffffff
        elif op==15:g[rt]=imm<<16
        elif op==13:g[rt]=g[rs]|imm
        elif op==12:g[rt]=g[rs]&imm
        elif op==14:g[rt]=g[rs]^imm
        elif op==11:g[rt]=int(g[rs]<(signed(imm,16)&0xffffffff))
        elif op==35:g[rt]=rd((g[rs]+signed(imm,16))&0xffffffff)
        elif op==43:wr((g[rs]+signed(imm,16))&0xffffffff,g[rt])
        elif op==0 and fn==0:g[dest]=(g[rt]<<shift)&0xffffffff
        elif op==0 and fn==2:g[dest]=g[rt]>>shift
        elif op==0 and fn==33:g[dest]=(g[rs]+g[rt])&0xffffffff
        elif op==0 and fn==35:g[dest]=(g[rs]-g[rt])&0xffffffff
        elif op==0 and fn==36:g[dest]=g[rs]&g[rt]
        elif op==0 and fn==37:g[dest]=g[rs]|g[rt]
        elif op==0 and fn==38:g[dest]=g[rs]^g[rt]
        elif op==0 and fn==39:g[dest]=~(g[rs]|g[rt])&0xffffffff
        elif op==0 and fn==43:g[dest]=int(g[rs]<g[rt])
        elif op==0 and fn==10:
            if g[rt]==0:g[dest]=g[rs]
        elif op==0 and fn==11:
            if g[rt]!=0:g[dest]=g[rs]
        else:raise AssertionError('unsupported compiled ISA '+hex(w))
        g[0]=0
    while pc!=0x0ffff000:
        steps+=1
        if steps>30000:raise AssertionError('transaction did not return')
        if pc==sym['d1_read']:g[2]=game[g[4]];pc=g[31];continue
        if pc==sym['d1_write']:
            address,value=g[4],g[5];writes.append((address,value));n=len(writes)
            if fault and n==fault[0]:
                if fault[1]=='delivered':game[address]=value
                elif fault[1]=='foreign':game[address]=0xbad0cafe
                elif fault[1]!='dropped':raise AssertionError('unknown IO fault')
                g[2]=0
            else:game[address]=value;g[2]=1
            pc=g[31];continue
        w=rd(pc);op=w>>26;rs=w>>21&31;rt=w>>16&31;fn=w&63
        target=None;likely=False;take=True
        if op in (4,5,20,21):
            take=g[rs]==g[rt] if op in (4,20) else g[rs]!=g[rt];likely=op>=20
            target=pc+4+4*signed(w&65535,16) if take else pc+8
        elif op in (6,7):
            take=signed(g[rs])<=0 if op==6 else signed(g[rs])>0
            target=pc+4+4*signed(w&65535,16) if take else pc+8
        elif op in (2,3):
            target=((pc+4)&0xf0000000)|((w&0x03ffffff)<<2)
            if op==3:g[31]=pc+8
        elif op==0 and fn==8:target=g[rs]
        if target is None:simple(w);pc+=4
        else:
            if take or not likely:simple(rd(pc+4))
            pc=target
    assert all(g[i]==v for i,v in preserved.items()),'callee-saved context damaged'
    return signed(g[2]),rd(sym['d1_owned']),game,writes,steps,words(initial),words(wanted)

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--build',type=Path,required=True);ap.add_argument('--out',type=Path,required=True);a=ap.parse_args()
    if a.out.exists():raise ValueError('refusing result overwrite')
    m=json.loads((a.build/'manifest.json').read_bytes());elf=(a.build/'patch.elf').read_bytes()
    assert b.digest(a.build/'patch.prx')==m['prxSha256']
    assert all(b.digest(b.ROOT/p)==h for p,h in m['inputs'].items())
    cases=0;maximum=0
    for profile in m['profiles']:
        for base in (0x08810000,0x09139d00,0x09400000):
            for initial in (0,1,2):
                for wanted in (0,1,2):
                    result,owned,game,writes,steps,old,new=run(elf,m,profile,base,initial,wanted)
                    assert result==owned==wanted and game==new
                    cases+=1;maximum=max(maximum,steps)
                for i in (0,len(profile['rules'])//2,len(profile['rules'])-1):
                    result,owned,game,writes,steps,old,new=run(elf,m,profile,base,initial,1,foreign=i)
                    assert result==-1 and owned==initial and not writes
                    cases+=1
            for initial,wanted in ((0,1),(1,0),(1,2),(2,1)):
                normal=run(elf,m,profile,base,initial,wanted);count=len(normal[3])
                for n in sorted({1,max(1,count//2),count}):
                    for fault in ('dropped','delivered','foreign'):
                        result,owned,game,writes,steps,old,new=run(elf,m,profile,base,initial,wanted,(n,fault))
                        if fault=='foreign':
                            assert result==-3 and owned==3 and 0xbad0cafe in game.values()
                            for address,value in game.items():assert value in (old[address],0xbad0cafe)
                        else:assert result==-2 and owned==initial and game==old
                        cases+=1;maximum=max(maximum,steps)
    result=dict(status='OFFLINE_PASS_NOT_RUNTIME_ACCEPTED',cases=cases,bases=3,modules=2,maxInstructions=maximum,
        manifestSha256=b.digest(a.build/'manifest.json'),testSourceSha256=b.digest(Path(__file__)),
        limits='Compiled transaction/IO faults only; no PSP monitor, loader, scheduler, JIT or gameplay proof')
    a.out.parent.mkdir(parents=True,exist_ok=True);a.out.write_bytes((json.dumps(result,indent=2)+'\n').encode());print(json.dumps(result))
if __name__=='__main__':main()
