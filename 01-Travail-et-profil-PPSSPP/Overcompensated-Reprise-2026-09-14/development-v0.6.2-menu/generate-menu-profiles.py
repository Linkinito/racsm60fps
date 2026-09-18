from pathlib import Path
import sys,struct,json,hashlib
R=Path(__file__).resolve().parent.parent;D=Path(__file__).resolve().parent
sys.path.insert(0,str(R/'research-2026-09-16/menus'))
from elf_menu import Elf,BIN
ref=Elf(R/'development-v0.6.1/verified-prx-inputs/LEVEL_04.PRX')
def norm(w):
 op=w>>26
 if op in (2,3):return w&0xfc000000
 if op not in (0,17,18,28,31):return w&0xffff0000
 return w
def normalized(b):return b''.join(struct.pack('<I',norm(w[0])) for w in struct.iter_unpack('<I',b[:len(b)//4*4]))
def findall(b,p):
 out=[];off=0
 while True:
  off=b.find(p,off)
  if off<0:return out
  if off%4==0:out.append(off)
  off+=1
rows=[]
for path in sorted((R/'development-v0.6.1/verified-prx-inputs').glob('LEVEL_*.PRX')):
 e=Elf(path);seg=next(s for s in e.ph if s[0]==1);data=e.read(0,seg[4]);nw=normalized(data);index=int(path.stem.split('_')[1]);contexts=[]
 for name,start,size,hi,lo in [('pause',0xb6494,0x104,0x1c,0x28),('challenge',0xb25ac,0x18c,0x20,0x28)]:
  hits=findall(nw,normalized(ref.read(start,size)));c={'context':name,'hits':hits}
  if len(hits)==1:
   a=hits[0];call=a+16;word=struct.unpack_from('<I',data,call)[0];assert word>>26==3
   c.update(input_call=call,input_target=(word&0x3ffffff)*4,menu_hi=a+hi,menu_lo=a+lo,guards=[{'offset':a+i*4,'word':norm(struct.unpack_from('<I',data,a+i*4)[0])} for i in range(12)])
  contexts.append(c)
 rows.append({'module':index,'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'contexts':contexts})
f=Elf(BIN/'FRONTEND.PRX');data=f.read(0,0x20000)
rows.append({'module':0,'sha256':hashlib.sha256((BIN/'FRONTEND.PRX').read_bytes()).hexdigest(),'contexts':[{'context':'frontend','hits':[0x19594],'input_call':0x19618,'input_target':0x4380,'menu_hi':0x1910c,'menu_lo':0x19114,'guards':[{'offset':0x19614+i*4,'word':norm(struct.unpack_from('<I',data,0x19614+i*4)[0])} for i in range(12)]}]})
(D/'analysis/menu-profiles.json').write_text(json.dumps(rows,indent=2));print(json.dumps([{ 'module':r['module'], 'matches':{c['context']:len(c['hits']) for c in r['contexts']}} for r in rows]))
