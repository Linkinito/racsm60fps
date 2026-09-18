import struct,hashlib,json
from pathlib import Path
from audit_patch_sites import ROOT, OUT, REF, Elf
GAME=Path(r'C:\Users\linki\Downloads\Ratchet & Clank - Size Matters (Europe) (PSN)')
def files(iso):
    f=iso.open('rb');f.seek(16*2048);p=f.read(2048);assert p[1:6]==b'CD001'
    root=p[156:];todo=[('',struct.unpack_from('<I',root,2)[0],struct.unpack_from('<I',root,10)[0])];result={}
    while todo:
        prefix,sector,length=todo.pop();f.seek(sector*2048);data=f.read(length);i=0
        while i<len(data):
            n=data[i]
            if not n:i=(i//2048+1)*2048;continue
            r=data[i:i+n];i+=n
            name=r[33:33+r[32]]
            if name in (b'\0',b'\1'):continue
            name=name.decode('ascii','replace').split(';')[0];path=prefix+'/'+name
            extent=struct.unpack_from('<I',r,2)[0];size=struct.unpack_from('<I',r,10)[0]
            if r[25]&2:todo.append((path,extent,size))
            else:result[path]=(extent*2048,size)
    return f,result
if __name__=='__main__':
    expected={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in REF.glob('*.PRX')};reports=[]
    for iso in GAME.glob('*.iso'):
        f,entries=files(iso);rows=[]
        for path,(offset,size) in entries.items():
            name=path.rsplit('/',1)[-1]
            if name in expected:
                f.seek(offset);digest=hashlib.sha256(f.read(size)).hexdigest()
                rows.append(dict(path=path,offset=offset,bytes=size,sha256=digest,reference_match=digest==expected[name]))
        f.close();reports.append(dict(iso=str(iso),bytes=iso.stat().st_size,matching=sum(r['reference_match'] for r in rows),compared=len(rows),modules=rows))
    (OUT/'iso_verification.json').write_text(json.dumps(reports,indent=2));print(json.dumps([{k:v for k,v in r.items() if k!='modules'} for r in reports],indent=2))
