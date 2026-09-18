"""Read-only, reproducible audit against SHA-256 pinned original PRX images.

Emits a ledger and conservative transfer candidates; never writes game memory.
"""
import csv, hashlib, json, re, struct, collections, bisect
from pathlib import Path

OUT = Path(__file__).resolve().parent
ROOT = OUT.parent
SRC = ROOT/'development-v0.6.3-generalisation/sources'
REF = ROOT/'development-v0.6.3-generalisation/prx-reference'
BASE = 0x09139D00

def hx(n): return f'0x{n:08X}'
def write_csv(name, rows):
    if not rows: return
    fields = list(dict.fromkeys(k for row in rows for k in row))
    with (OUT/name).open('w',newline='',encoding='utf-8-sig') as f:
        w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)

class Elf:
    def __init__(self,p):
        self.path=p;self.b=p.read_bytes();h=struct.unpack_from('<16sHHIIIIIHHHHHH',self.b)
        assert h[0][:7]==b'\x7fELF\x01\x01\x01' and h[2]==8
        self.ph=[struct.unpack_from('<8I',self.b,h[5]+i*h[9]) for i in range(h[10])]
        self.sh=[struct.unpack_from('<10I',self.b,h[6]+i*h[11]) for i in range(h[12])]
        ns=self.sh[h[13]];names=self.b[ns[4]:ns[4]+ns[5]]
        self.named={names[s[0]:].split(b'\0')[0].decode():s for s in self.sh}
        self.reloc={}
        for s in self.sh:
            if s[1]==0x700000A0:
                for off in range(s[4],s[4]+s[5],8):
                    a,info=struct.unpack_from('<II',self.b,off);self.reloc[a]=info
        self.text=self.named['.text'];self.lo=self.text[3];self.hi=self.lo+self.text[5]
        self.words=list(struct.unpack('<%dI'%(self.text[5]//4),self.b[self.text[4]:self.text[4]+self.text[5]]))
        self.norm=[]
        for i,w in enumerate(self.words):
            rel=self.reloc.get(self.lo+4*i)
            # Only relocation-controlled operands are removed. All opcodes,
            # registers, branch offsets and non-relocated immediates retained.
            if rel is not None:
                t=rel&255
                if t==4:w&=0xfc000000
                elif t in (5,6):w&=0xffff0000
                else:w=0
            self.norm.append(w)
        self.normbytes=struct.pack('<%dI'%len(self.norm),*self.norm)
    def locate(self,a):
        for s in self.sh:
            if s[2]&2 and s[3]<=a<a+4<=s[3]+s[5]:
                return s,s[4]+a-s[3]
        raise ValueError(hx(a))
    def word(self,a):
        s,o=self.locate(a);return 0 if s[1]==8 else struct.unpack_from('<I',self.b,o)[0]
    def runtime(self,a,base):
        w=self.word(a);t=self.reloc.get(a,0)&255
        if t==4:return (w&0xfc000000)|((((w&0x3ffffff)<<2)+base)>>2&0x3ffffff)
        return w if t==0 else None
    def normalized_window(self,a,radius=24):
        lo=max(self.lo,a-radius*4);hi=min(self.hi,a+(radius+1)*4)
        return lo,self.normbytes[lo-self.lo:hi-self.lo]

def main():
    manifest=json.loads((SRC/'provenance/experience_v021_manifest.json').read_text())
    images={int(k):Elf(REF/f'LEVEL_{int(k):02}.PRX') for k in manifest['input_verification']['prx_hashes']}
    hashes=[]
    for k,e in images.items():
        digest=hashlib.sha256(e.b).hexdigest();assert digest==manifest['input_verification']['prx_hashes'][str(k)]
        hashes.append(dict(module=k,path=str(e.path),sha256=digest,bytes=len(e.b),status='PASS'))
    levels={int(r['module_index']):r['level'].replace('Quadrona','Quodrona') for r in csv.DictReader((SRC/'tables/object_descriptors.csv').open(encoding='utf-8-sig'))}
    descriptors=collections.defaultdict(list)
    for d in csv.DictReader((SRC/'tables/object_descriptors.csv').open(encoding='utf-8-sig')):
        for cb in d['callback_rvas'].split(';'):
            if cb.strip():descriptors[int(d['module_index'])].append((int(cb,16),d['object_name']))
    for ds in descriptors.values():ds.sort()
    def nearest(k,a):
        ds=descriptors[k];i=bisect.bisect_right([p[0] for p in ds],a)-1
        return (ds[i][1],a-ds[i][0]) if i>=0 else ('',0)
    legacy={}
    for p in manifest['patches']:
        if p['kind']!='cave_return' and p['layer']!='WRAPPER':legacy[(p['module_index'],int(p['address'],16)-BASE)]=p
    extras={}
    met=json.loads((SRC/'profiler/generated/metalis-experiments.json').read_text())['changes']
    for file in ['metalis-experiments.json','generalisation-experiments.json']:
        doc=json.loads((SRC/'profiler/generated'/file).read_text())
        for c in doc['changes']:extras[(c.get('module_index',doc.get('module_index',4)),c['rva'])]=(c,file)
    generated=(SRC/'profiler/generated/full_patch.generated.c').read_text()
    ledger=[];occupied={};errors=[]
    for key,body in re.findall(r'static const RcsmFullWord kFull(\d+)\[\] = \{(.*?)\n\};',generated,re.S):
        k=int(key);e=images[k]
        for match in re.findall(r'\{0x([0-9A-F]+)u, 0x([0-9A-F]+)u, 0x([0-9A-F]+)u, (\d+)u, (\d+)u\}',body):
            a,old,new=[int(v,16) for v in match[:3]];flags,layer=map(int,match[3:]);s,o=e.locate(a);raw=e.word(a)
            p=legacy.get((k,a),{});extra,src=extras.get((k,a),({},'experience_v021_manifest.json'))
            expected=int(p['file_vanilla'],16) if p else extra.get('original')
            ok=raw==expected
            if not ok:errors.append((k,hx(a),raw,expected))
            obj,dist=nearest(k,a)
            row=dict(module=k,level=levels.get(k,''),rva=hx(a),file_offset='' if s[1]==8 else hx(o),section=next(n for n,v in e.named.items() if v==s),file_word=hx(raw),reference_base=hx(BASE),reference_address_NOT_live=hx(BASE+a),runtime_vanilla_word_at_reference_base=hx(old),patched_encoded=hx(new),patch_interpretation='jump to plugin-owned cave '+str(new) if flags&4 else 'relocated module jump' if flags&8 else 'literal word',flags=flags,layer=layer,mechanic=extra.get('label',p.get('mechanic','')),source=src,binary_check='PASS' if ok else 'FAIL',continuous=bool(flags&1),runtime_activation='EXCLUDED in v063 runtime' if k in (15,21) else 'configuration-dependent',validation=extra.get('validation','historical; no new gameplay validation'),evidence=extra.get('evidence','provenance manifest'),nearest_callback_NOT_proven_owner=obj,callback_distance_bytes=dist)
            ledger.append(row);occupied[k,a]=row
    assert not errors,errors
    write_csv('patch_ledger.csv',ledger);write_csv('prx_hashes.csv',hashes)
    # Recheck all 493 callsite words independently from source CSV and PRX.
    calls=[]
    for r in csv.DictReader((SRC/'tables/wrapper_callsites.csv').open(encoding='utf-8-sig')):
        k=int(r['module_index']);a=int(r['callsite_rva'],16);e=images[k];raw=e.word(a)
        assert raw==0x0c000000|((int(r['wrapper_entry_runtime'],16)-BASE)>>2)
        calls.append(dict(module=k,level=levels[k],family=r['family_id'],rva=hx(a),file_offset=hx(e.locate(a)[1]),file_word=hx(raw),runtime_formula='base + RVA; JAL requires R_MIPS_26 relocation',reference_address_NOT_live=hx(BASE+a),binary_check='PASS',owner_rva=r['owner_rva'],default_policy=r['profiler_default_policy']))
    write_csv('wrapper_ledger.csv',calls)
    candidates=[];unmatched=[]
    for c in met:
        a=c['rva'];e=images[4]
        if a>=e.hi:continue
        lo,needle=e.normalized_window(a,24)
        for k,target in images.items():
            if k==4:continue
            positions=[];start=0
            while True:
                pos=target.normbytes.find(needle,start)
                if pos<0:break
                if pos%4==0:positions.append(target.lo+pos+a-lo)
                start=pos+1
            if len(positions)!=1:
                unmatched.append(dict(source_rva=hx(a),mechanic=c['label'],target_module=k,match_count=len(positions),status='absent_or_not_unique; no transfer'));continue
            ta=positions[0]
            if target.word(ta)!=c['original']:continue
            previous=occupied.get((k,ta));obj,dist=nearest(k,ta)
            candidates.append(dict(module=k,level=levels[k],rva=hx(ta),file_offset=hx(target.locate(ta)[1]),original=hx(c['original']),proposed=hx(c['patched']),source_module=4,source_rva=hx(a),mechanic=c['label'],proof='unique 49-word window; only PRX relocation operands normalized',signature_sha256=hashlib.sha256(needle).hexdigest(),window_start=hx(ta-(a-lo)),window_bytes=len(needle),status='already_same' if previous and int(previous['patched_encoded'],16)==c['patched'] else 'CONFLICT' if previous else 'new_static_candidate',validation='not tested in-game at target',nearest_callback_NOT_proven_owner=obj,callback_distance_bytes=dist))
    write_csv('metalis_transfers.csv',candidates);write_csv('metalis_transfer_gaps.csv',unmatched)
    cavewords=re.search(r'g_rcsm_cave_templates.*?= \{(.*?)\n\};',generated,re.S).group(1)
    caveaudit=[]
    for ci,arr in enumerate(re.findall(r'\{(.*?)\}',cavewords,re.S)):
        for wi,w in enumerate(re.findall(r'0x([0-9A-F]+)u',arr)):
            caveaudit.append(dict(cave_index=ci,word_index=wi,byte_offset=hx(wi*4),word='0x'+w,address_kind='plugin allocation; no vanilla game address',original='not applicable; injected code'))
    write_csv('injected_caves.csv',caveaudit)
    summary=dict(prx_verified=len(images),patch_words_verified=len(ledger),wrapper_calls_verified=len(calls),cave_words=len(caveaudit),metalis_transfer_candidates=len(candidates),new_metalis_transfers=sum(c['status']=='new_static_candidate' for c in candidates),transfer_conflicts=sum(c['status']=='CONFLICT' for c in candidates),patches_by_module=dict(collections.Counter(r['module'] for r in ledger)),transfers_by_module=dict(collections.Counter(r['module'] for r in candidates)),live_validation=False)
    (OUT/'patch_audit_summary.json').write_text(json.dumps(summary,indent=2));print(json.dumps(summary,indent=2))

if __name__=='__main__':main()
