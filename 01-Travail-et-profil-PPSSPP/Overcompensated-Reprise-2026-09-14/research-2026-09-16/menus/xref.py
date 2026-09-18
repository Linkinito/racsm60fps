from elf_menu import *
p=Elf(BIN/'LEVEL_04.PRX');seg=next(s for s in p.ph if s[0]==1);ws=struct.unpack('<'+'I'*(seg[4]//4),p.b[seg[1]:seg[1]+seg[4]//4*4]);hits=[i*4 for i,w in enumerate(ws) if w>>26==3 and (w&0x3ffffff)*4==0xa6a34];print([hex(x) for x in hits]);(OUT/'cycle-callers.asm').write_text('\n\n'.join(p.dis(a-24,64) for a in hits))
e=Elf(BIN/'straddle.junk')
for s in e.syms:
 if ('PAUSE' in s['name'] or 'MENU' in s['name']) and ('G_' in s['name'] or 'Main' in s['name']):print(s)
