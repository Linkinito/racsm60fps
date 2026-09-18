from elf_menu import *
p=Elf(BIN/'LEVEL_04.PRX')
(OUT/'pause-update-metalis.asm').write_text(p.dis(0xadd40,0x280))
(OUT/'pause-cycles.json').write_text(json.dumps([dict(rva=hex(a),hex=p.read(a,40).hex(),floats=struct.unpack('<7f',p.read(a,28)),tail=struct.unpack('<3I',p.read(a+28,12))) for a in [0x2cf7bc,0x2cf7e4]],indent=2))
print((OUT/'pause-cycles.json').read_text())
# Identify references to data structures from LUI/addiu/lwc1 pairs, saves evidence for later lifetime audit.
