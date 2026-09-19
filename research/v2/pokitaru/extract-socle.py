"""Deterministic static player-clock extracts. No game or emulator writes."""
from pathlib import Path
import hashlib, json, struct, sys
ROOT=Path(__file__).resolve().parents[3]
L=ROOT/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14'
sys.path.insert(0,str(L/'analysis-deps'))
from capstone import Cs, CS_ARCH_MIPS, CS_MODE_MIPS32, CS_MODE_LITTLE_ENDIAN
OUT=Path(__file__).resolve().parent
prx=L/'development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX'
b=prx.read_bytes(); digest=hashlib.sha256(b).hexdigest()
assert digest=='d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571'
h=struct.unpack_from('<16sHHIIIIIHHHHHH',b)
ph=[struct.unpack_from('<IIIIIIII',b,h[5]+i*h[9]) for i in range(h[10])]
def off(a):
    s=next(s for s in ph if s[0]==1 and s[2]<=a<s[2]+s[4]);return s[1]+a-s[2]
md=Cs(CS_ARCH_MIPS,CS_MODE_MIPS32|CS_MODE_LITTLE_ENDIAN)
ranges=[(0x2FB8C,0x30180),(0x360A4,0x36240),(0x39B74,0x39CC0),
 (0x1EBC4,0x1ED40),(0x965A0,0x966E0),(0x1BF424,0x1BF43C)]
lines=[f'# Source SHA256 {digest}; addresses are unrelocated module RVAs; bounds are extraction windows.']
for a,z in ranges:
    lines.append(f'\n# {a:08X}..{z:08X}')
    for i in md.disasm(b[off(a):off(a)+z-a],a):
        lines.append(f'{i.address:08X} {int.from_bytes(i.bytes,"little"):08X} {i.mnemonic:10s} {i.op_str}')
(OUT/'socle-dataflow.asm').write_text('\n'.join(lines)+'\n',encoding='utf8')
targets={0x2FB8C,0x2FFF0,0x360A4,0x39B74,0x1EBC4,0x1517C}
calls=[]
for a in range(0,0x1BF400,4):
    w=struct.unpack_from('<I',b,off(a))[0]
    if w>>26==3 and (w&0x3FFFFFF)*4 in targets:
        calls.append({'rva':hex(a),'target':hex((w&0x3FFFFFF)*4),
            'context':[f'{i.address:08X} {i.mnemonic} {i.op_str}' for i in md.disasm(b[off(max(0,a-20)):off(a)+12],max(0,a-20))]})
(OUT/'socle-callers.json').write_text(json.dumps({'source':str(prx.relative_to(ROOT)),
    'sha256':digest,'scan_scope':'aligned direct JAL candidates only; no indirect calls; data false positives possible',
    'calls':calls},indent=2)+'\n',encoding='utf8')
print(json.dumps(calls,indent=2))
