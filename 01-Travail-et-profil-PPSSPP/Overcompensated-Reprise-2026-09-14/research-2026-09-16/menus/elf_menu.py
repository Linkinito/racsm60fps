import struct,pathlib,json,hashlib,sys,re
ROOT=pathlib.Path(__file__).resolve().parents[2]
BIN=pathlib.Path(r'C:\Users\linki\Downloads\Ratchet & Clank - Size Matters (Europe) (PSN)\Data\BACKUP\BIN')
OUT=pathlib.Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'analysis-deps'))
from capstone import *
class Elf:
 def __init__(self,p):
  self.b=p.read_bytes();h=struct.unpack_from('<16sHHIIIIIHHHHHH',self.b);self.ph=[struct.unpack_from('<IIIIIIII',self.b,h[5]+i*h[9]) for i in range(h[10])];self.sh=[struct.unpack_from('<IIIIIIIIII',self.b,h[6]+i*h[11]) for i in range(h[12])];self.syms=[]
  for s in self.sh:
   if s[1]!=2:continue
   st=self.sh[s[6]];strings=self.b[st[4]:st[4]+st[5]]
   for o in range(s[4],s[4]+s[5],s[9]):
    n,v,z,info,other,idx=struct.unpack_from('<IIIBBH',self.b,o);name=strings[n:].split(b'\0',1)[0].decode('utf-8','replace');self.syms.append(dict(name=name,value=v,size=z,info=info,section=idx))
 def read(self,a,n):
  for s in self.ph:
   if s[0]==1 and s[2]<=a<s[2]+s[4]:return self.b[s[1]+a-s[2]:s[1]+a-s[2]+n]
  for s in self.sh:
   if s[3]<=a<s[3]+s[5] and s[1]!=8:return self.b[s[4]+a-s[3]:s[4]+a-s[3]+n]
  return b''
 def dis(self,a,n):
  md=Cs(CS_ARCH_MIPS,CS_MODE_MIPS32|CS_MODE_LITTLE_ENDIAN);md.skipdata=True
  return '\n'.join(f'{i.address:08X} {i.bytes.hex()} {i.mnemonic:10} {i.op_str}' for i in md.disasm(self.read(a,n),a))
if __name__=='__main__':
 e=Elf(BIN/'straddle.junk');(OUT/'symbols.json').write_text(json.dumps(e.syms,indent=2));s=[s for s in e.syms if re.search('PAUSEMENU|PAUSEMODE|LEVELSTARTUP|[Bb]link|[Pp]ulse|[Ff]lash',s['name'])];(OUT/'menu-symbols.json').write_text(json.dumps(s,indent=2));print(json.dumps(s,indent=2))
 for x in s:
  if x['size'] and x['info']&15==2:(OUT/(re.sub('[^A-Za-z0-9_-]','_',x['name'])+'.asm')).write_text(e.dis(x['value'],x['size']))
