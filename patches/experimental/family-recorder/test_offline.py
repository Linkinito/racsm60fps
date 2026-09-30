#!/usr/bin/env python3
"""Adversarial compiled-hook context tests and malformed stream checks.

This is a bounded MIPS instruction model, not PPSSPP runtime acceptance.
The mocked C callee clobbers all saved registers and checks the original frame.
"""
import argparse,hashlib,importlib.util,json,random,struct,tempfile
from pathlib import Path
HERE=Path(__file__).resolve().parent;REPO=HERE.parents[2]
def load(path,name):
    s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
builder=load(HERE/'build.py','recorder_build_test');analyzer=load(REPO/'tools/runtime/analyze-freeplay.py','recorder_analyzer_test')
def test_hook(build,manifest,reg,seed):
    rng=random.Random(seed);base=0x09300000;dest=0x09200000;stub=base+0x40000;meta=base+0x41000
    elf=(build/'patch.elf').read_bytes();sec=builder.sections(elf)['.text'];start=manifest['symbols']['recorder_hook'];end=manifest['symbols']['recorder_hook_end']
    mem={base+start+i:struct.unpack_from('<I',elf,sec[4]+start-sec[3]+i)[0] for i in range(0,end-start,4)}
    code=[0x27BDFFF0,0xAFBA0000,0xAFBB0004,0x3C1A0000|(meta>>16),0x375A0000|(meta&0xFFFF),0x08000000|((base+start)>>2),0,0]
    mem.update({stub+4*i:w for i,w in enumerate(code)});mem[meta]=dest if reg==0 else 0;mem[meta+4]=reg*4
    g=[0]+[rng.getrandbits(32) for _ in range(31)];g[29]=0x09F00000;g[31]=0x091A0008
    if reg:g[reg]=dest
    f=[rng.getrandbits(32) for _ in range(32)];original=g[:];original_f=f[:];hi=rng.getrandbits(32);lo=rng.getrandbits(32);fcr=rng.getrandbits(32);original_special=(hi,lo,fcr)
    mock_calls=0;pc=stub;steps=0
    def signed(x):return x-65536 if x&0x8000 else x
    def execute(address,w,delay=False):
        nonlocal hi,lo,fcr,mock_calls
        op=w>>26;rs=(w>>21)&31;rt=(w>>16)&31;rd=(w>>11)&31;fn=w&63;imm=w&65535;branch=False;target=None
        if w==0:pass
        elif op==9:g[rt]=(g[rs]+signed(imm))&0xFFFFFFFF
        elif op==15:g[rt]=imm<<16
        elif op==13:g[rt]=g[rs]|imm
        elif op==43:mem[(g[rs]+signed(imm))&0xFFFFFFFF]=g[rt]
        elif op==35:g[rt]=mem[(g[rs]+signed(imm))&0xFFFFFFFF]
        elif op==57:mem[(g[rs]+signed(imm))&0xFFFFFFFF]=f[rt]
        elif op==49:f[rt]=mem[(g[rs]+signed(imm))&0xFFFFFFFF]
        elif op==17 and rs==2:g[rt]=fcr
        elif op==17 and rs==6:fcr=g[rt]
        elif op==0 and fn==33:g[rd]=(g[rs]+g[rt])&0xFFFFFFFF
        elif op==0 and fn==16:g[rd]=hi
        elif op==0 and fn==18:g[rd]=lo
        elif op==0 and fn==17:hi=g[rs]
        elif op==0 and fn==19:lo=g[rs]
        elif op==0 and fn==8:branch=True;target=g[rs]
        elif op in (4,5):
            branch=True;take=(g[rs]==g[rt]) if op==4 else (g[rs]!=g[rt]);target=address+4+4*signed(imm) if take else address+8
        elif op in (2,3):
            branch=True;target=((address+4)&0xF0000000)|((w&0x03FFFFFF)<<2)
            if op==3:g[31]=address+8;target=base+manifest['symbols']['recorder_hit']
        else:raise AssertionError('unsupported test ISA '+hex(w))
        g[0]=0
        if delay and branch:raise AssertionError('branch in generated delay slot')
        return branch,target,op==3
    while pc!=dest:
        steps+=1
        if steps>300:raise AssertionError('hook failed to reach original callee exactly once')
        branch,target,call=execute(pc,mem[pc])
        if branch:
            execute(pc+4,mem[pc+4],True)
            if call:
                assert g[5]==meta
                frame=g[4];assert [mem[frame+i*4] for i in range(32)]==original
                assert [mem[frame+128+i*4] for i in range(32)]==original_f
                assert tuple(mem[frame+i] for i in (256,260,264))==original_special
                return_to=g[31];saved_sp=g[29];mock_calls+=1
                g[1:]=[rng.getrandbits(32) for _ in range(31)];g[29]=saved_sp
                f[:]=[rng.getrandbits(32) for _ in range(32)];hi=lo=fcr=0xBADF00D;pc=return_to
            else:pc=target
        else:pc+=4
    assert mock_calls==1 and g==original and f==original_f and (hi,lo,fcr)==original_special
    return steps
def test_stream(manifest):
    ns,nc=len(manifest['sites']),len(manifest['callbacks']);counts=[0]*(2*ns+nc)
    def chunk(seq,time,arm,status=1):
        counts[2*ns]=seq*60
        head=[analyzer.MAGIC,2,108+4*len(counts),seq,1,0x09139D00,arm,status,ns,nc,0,0,time,0,1,8,22,96]+list(struct.unpack('<8I',bytes.fromhex(manifest['buildId'])))+[7]
        return struct.pack('<27I',*head)+struct.pack('<%dI'%len(counts),*counts)
    with tempfile.TemporaryDirectory() as directory:
        path=Path(directory)/'trace.bin';valid=chunk(0,1000000,1)+chunk(1,2000000,1)+chunk(2,3000000,2)+chunk(3,4000000,2)
        path.write_bytes(valid);decoded=analyzer.read_trace(path,manifest);summary=analyzer.summarize(decoded,manifest)
        assert summary['validWindows']==2 and summary['exposureSeconds']=={'A0':1,'C1':1}
        assert summary['coverage'][0]['arms']['A0']['hits']==60 and summary['coverage'][0]['arms']['C1']['hits']==60
        path.write_bytes(valid+b'RFR');assert analyzer.read_trace(path,manifest)['truncatedTail']
        path.write_bytes(chunk(0,2000000,1)+chunk(1,1000000,1))
        try:analyzer.read_trace(path,manifest);raise AssertionError('backward clock admitted')
        except ValueError:pass
        damaged=bytearray(valid);struct.pack_into('<I',damaged,8,1);path.write_bytes(damaged)
        try:analyzer.read_trace(path,manifest);raise AssertionError('malformed dimensions admitted')
        except ValueError:pass
        damaged=bytearray(valid);damaged[72]^=1;path.write_bytes(damaged)
        try:analyzer.read_trace(path,manifest);raise AssertionError('wrong build admitted')
        except ValueError:pass
        path.write_bytes(chunk(0,1000000,1)+chunk(1,2000000,1,3));assert analyzer.summarize(analyzer.read_trace(path,manifest),manifest)['validWindows']==0
        site=next(i for i,s in enumerate(manifest['sites']) if s['reg'])
        e=[0,site,1,500000,0,0x09700000,0,0,0,0x09139D00+manifest['sites'][site]['rva']+8,0,1,2,0x09600000,3]+[0]*9
        sample=bytearray(chunk(0,1000000,1));struct.pack_into('<I',sample,8,len(sample)+96);struct.pack_into('<I',sample,40,1);sample+=struct.pack('<24I',*e)
        path.write_bytes(sample);assert len(analyzer.read_trace(path,manifest)['samples'])==1
        e[9]=0;path.write_bytes(sample[:-96]+struct.pack('<24I',*e))
        try:analyzer.read_trace(path,manifest);raise AssertionError('wrong callsite RA admitted')
        except ValueError:pass
def main():
    p=argparse.ArgumentParser();p.add_argument('--build',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    if a.out.exists():raise RuntimeError('refusing evidence overwrite')
    m=json.loads((a.build/'manifest.json').read_bytes());regs=sorted({s['reg'] for s in m['sites']});cases=0;maxsteps=0
    for reg in regs:
        for seed in range(16):maxsteps=max(maxsteps,test_hook(a.build,m,reg,seed));cases+=1
    for s in m['sites']:assert builder.delay_safe(s['delay'],s['reg']) and (s['word']>>26==3 or s['word']&0xFC1FFFFF==0xF809)
    assert not builder.delay_safe(0x24840001,4) and not builder.delay_safe(0x0C001234,0)
    test_stream(m)
    sources=(Path(__file__),REPO/'tools/runtime/analyze-freeplay.py',REPO/'tools/runtime/record-freeplay.py')
    result={'status':'OFFLINE_PASS_NOT_RUNTIME_ACCEPTED','manifestSha256':hashlib.sha256((a.build/'manifest.json').read_bytes()).hexdigest(),'sourceHashes':{str(f.relative_to(REPO)):hashlib.sha256(f.read_bytes()).hexdigest() for f in sources},'compiledHookAdversarialCases':cases,'maxInstructions':maxsteps,'siteGuards':len(m['sites']),'streamChecks':'dimension,sequence,truncation,backward-time,arm/status segmentation','limits':'Instruction model does not establish PPSSPP lifecycle, semantic ownership, clock calibration or overhead.'}
    a.out.parent.mkdir(parents=True,exist_ok=True);a.out.write_text(json.dumps(result,indent=1),encoding='utf-8');print(json.dumps(result))
if __name__=='__main__':main()
