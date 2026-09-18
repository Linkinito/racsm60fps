from pathlib import Path
import json,sys,struct
D=Path(__file__).resolve().parent;R=D.parent
sys.path.insert(0,str(R/'research-2026-09-16/menus'))
from elf_menu import Elf,BIN
rows=json.loads((D/'analysis/menu-profiles.json').read_text())
out=['/* Generated from original UCES00420 PRXs. Do not hand-edit. */','#include "rcsm_menu_profiles.h"','const RcsmMenuProfile g_rcsm_menu_profiles[] = {']
for row in rows:
 e=Elf(BIN/'FRONTEND.PRX' if row['module']==0 else R/f"development-v0.6.1/verified-prx-inputs/LEVEL_{row['module']:02d}.PRX")
 for c in row['contexts']:
  assert len(c['hits'])==1
  kind={'frontend':0,'pause':1,'challenge':2}[c['context']]
  modal=0
  if kind==0: modal=0x17c8c
  if kind==2:
   w=struct.unpack('<I',e.read(c['hits'][0]+0x24,4))[0];assert w>>26==3
   modal=(w&0x3ffffff)*4
  if modal:
   words=struct.unpack('<4I',e.read(modal,16))
   assert words[0]&0xffff0000==0x3c040000 and words[1]&0xffff0000==0x8c820000 and words[2:]==(0x03e00008,0x0002102b)
  guards=list(c['guards'])
  # Require complete handler match, not only its prologue. Relocations alone are masked.
  if kind!=0:
   size=0x104 if kind==1 else 0x18c
   guards=[]
   for off in range(c['hits'][0],c['hits'][0]+size,4):
    word=struct.unpack('<I',e.read(off,4))[0]
    # Branch displacements, constants and stack offsets remain exact.
    op=word>>26; mask=0xffffffff
    if op in (2,3):mask=0xfc000000
    elif op==15:mask=0xffff0000
    # Relocated addiu/lw use register != sp; only address-building immediates.
    elif op in (9,35) and ((word>>21)&31)!=29:mask=0xffff0000
    guards.append({'offset':off,'word':word&mask,'mask':mask})
  else:
   guards=[]
   for off in list(range(0x190b0,0x19128,4))+list(range(0x19614,0x1964c,4)):
    word=struct.unpack('<I',e.read(off,4))[0];op=word>>26
    mask=0xfc000000 if op in (2,3) else 0xffff0000 if op in (15,9,35) and ((word>>21)&31)!=29 else 0xffffffff
    guards.append({'offset':off,'word':word&mask,'mask':mask})
  out.append('{%du,%du,0x%xu,0x%xu,0x%xu,0x%xu,0x%xu,%du,{'%(row['module'],kind,c['input_call'],c['input_target'],c['menu_hi'],c['menu_lo'],modal,len(guards)))
  out += ['{0x%xu,0x%xu,0x%xu},'%(g['offset'],g['word'],g['mask']) for g in guards]
  out.append('}},')
out+=['};','const unsigned g_rcsm_menu_profile_count=sizeof(g_rcsm_menu_profiles)/sizeof(g_rcsm_menu_profiles[0]);']
(D/'sources/profiler/generated/menu_profiles.generated.c').write_text('\n'.join(out)+'\n')
# Derive a full register-preserving post-input bridge from the audited profiler bridge.
s=(D/'sources/profiler/src/profiler_hook.S').read_text(encoding='utf-8-sig')
constants=s[s.index('    .equ RCSM_FRAME_SIZE'):s.index('    .extern g_rcsm_plugin_gp')]
save=s[s.index('    sw      $at, RCSM_AT'):s.index('    /* The game owns $gp')]
restore=s[s.index('    lwc1    $f0,'):s.index('    .end rcsm_profiler_hook_common')]
restore=restore.replace('    lw      $ra, RCSM_COMMON_RA($sp)','    lw      $ra, 0x120($sp)').replace('    jr      $ra\n    nop','    jr      $ra\n    addiu   $sp, $sp, 0x130')
asm='/* Original input executes with game GP. C sees plugin GP. Only v0 is changed. */\n.set noreorder\n.set noat\n.text\n.align 4\n'+constants
for kind in range(3):
 asm+=f'''
.globl rcsm_menu_hook_{kind}
.ent rcsm_menu_hook_{kind}
rcsm_menu_hook_{kind}:
    addiu $sp, $sp, -0x130
    sw $ra, 0x120($sp)
    sw $k0, 0x128($sp)
    sw $k1, 0x12c($sp)
    lui $k0, %hi(g_rcsm_menu_active_hooks)
    lw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    addiu $k1, $k1, 1
    sw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    lw $k0, 0x128($sp)
    lw $k1, 0x12c($sp)
.globl rcsm_menu_original_{kind}
rcsm_menu_original_{kind}:
    jal 0
    nop
    sw $k0, 0x128($sp)
    ori $k0, $zero, {kind}
    sw $k0, 0x124($sp)
    lw $k0, 0x128($sp)
    j rcsm_menu_hook_common
    nop
.end rcsm_menu_hook_{kind}
'''
asm+='\n.ent rcsm_menu_hook_common\nrcsm_menu_hook_common:\n'+save+'''
    lui $k0, %hi(g_rcsm_plugin_gp)
    lw $gp, %lo(g_rcsm_plugin_gp)($k0)
    lw $a0, 0x124($sp)
    lw $a1, RCSM_V0($sp)
    jal rcsm_menu_hook_c
    nop
    sw $v0, RCSM_V0($sp)
    lui $k0, %hi(g_rcsm_menu_active_hooks)
    lw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
    addiu $k1, $k1, -1
    sw $k1, %lo(g_rcsm_menu_active_hooks)($k0)
'''+restore+'\n.end rcsm_menu_hook_common\n'
(D/'sources/profiler/src/menu_hook.S').write_text(asm)
print('Generated',len(rows),'module menu profiles and three GP-aware bridges')
