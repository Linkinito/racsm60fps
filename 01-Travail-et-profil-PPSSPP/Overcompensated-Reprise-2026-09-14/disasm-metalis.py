import sys,pathlib,struct,hashlib
r=pathlib.Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14');sys.path.insert(0,str(r/'analysis-deps'));from capstone import *
p=pathlib.Path(r'C:\Users\linki\Downloads\Ratchet & Clank - Size Matters (Europe) (PSN)\Data\BACKUP\BIN\LEVEL_04.PRX'); b=p.read_bytes();print('SHA256',hashlib.sha256(b).hexdigest());h=struct.unpack_from('<16sHHIIIIIHHHHHH',b);ph=[struct.unpack_from('<IIIIIIII',b,h[5]+i*h[9]) for i in range(h[10])];print('segments',ph)
md=Cs(CS_ARCH_MIPS,CS_MODE_MIPS32|CS_MODE_LITTLE_ENDIAN)
def dump(a,n):
 s=next(s for s in ph if s[0]==1 and s[2]<=a<s[2]+s[4]);o=s[1]+a-s[2];return '\n'.join(f'{i.address:08X} {i.bytes.hex()} {i.mnemonic:9s} {i.op_str}' for i in md.disasm(b[o:o+n],a))
targets=[(0x2b91c,124),(0xe088,260),(0x192e70,0x286c),(0x12a6a0,0x448),(0x12ba2c,0x484)]
for a,n in targets:
 t=dump(a,n);(r/f'connection/disasm-{a:x}.txt').write_text(t)
 if a<0x30000:print(t)
 else:print(hex(a),'lines',len(t.splitlines()),'saved')
