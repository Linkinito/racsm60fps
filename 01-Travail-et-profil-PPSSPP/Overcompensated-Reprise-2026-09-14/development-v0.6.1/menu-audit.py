from pathlib import Path
import sys,struct,json
r=Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14')
sys.path.insert(0,str(r/'research-2026-09-16/menus'))
from elf_menu import Elf
e=Elf(r/'development-v0.6.1/verified-prx-inputs/LEVEL_04.PRX')
o=r/'development-v0.6.1/menu-audit';o.mkdir(exist_ok=True)
result={}
for name,addr in [('update',0xabb18),('render',0xac970),('current',0xac7f0),('begin',0xac018),('end',0xac0f8)]:
    code=e.read(0,0x1d0000); sites=[a for a in range(0,len(code)-3,4) if struct.unpack_from('<I',code,a)[0]==(0x0c000000|(addr>>2))]
    result[name]=[hex(a) for a in sites]
    (o/(name+'-callers.asm')).write_text('\n\n'.join(e.dis(max(0,a-64),144) for a in sites))
(o/'calls.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2))
