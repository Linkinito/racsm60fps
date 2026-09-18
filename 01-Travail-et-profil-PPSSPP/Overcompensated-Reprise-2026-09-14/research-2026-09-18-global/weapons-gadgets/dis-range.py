import pathlib,sys,bisect
ROOT=pathlib.Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT/'research-2026-09-18-global'));sys.path.insert(0,str(ROOT/'analysis-deps'))
from audit_patch_sites import Elf,REF
from capstone import *
k=int(sys.argv[1]);a=int(sys.argv[2],16);n=int(sys.argv[3],16) if len(sys.argv)>3 else 0x800;e=Elf(REF/f'LEVEL_{k:02d}.PRX');s,o=e.locate(a);md=Cs(CS_ARCH_MIPS,CS_MODE_MIPS32|CS_MODE_LITTLE_ENDIAN);md.skipdata=True
print('\n'.join(f'{i.address:08X} {int.from_bytes(i.bytes,"little"):08X} {i.mnemonic:10} {i.op_str}' for i in md.disasm(e.b[o:o+n],a)))
