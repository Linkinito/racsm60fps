import sys,pathlib,importlib.util,csv,json,bisect,re,struct
ROOT=pathlib.Path(__file__).resolve().parents[2];OUT=pathlib.Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'research-2026-09-18-global'));sys.path.insert(0,str(ROOT/'analysis-deps'))
from audit_patch_sites import Elf,REF,hx
from capstone import Cs,CS_ARCH_MIPS,CS_MODE_MIPS32,CS_MODE_LITTLE_ENDIAN
md=Cs(CS_ARCH_MIPS,CS_MODE_MIPS32|CS_MODE_LITTLE_ENDIAN);md.skipdata=True
CLASSES='Acidbomb AcidbombEpoxy AgentController AgentOfDoom AgentsBomb AgentsGlove AgentsGrenade AgentsLaser AgentsRocket BeeMine BeeMineGlove Blaster BlasterShot BlitzGun BlitzGunShot Bombglove CrossbowGun CrossbowShot CrossbowShard ElectroBall ElectroshockWave Flamethrower LaserTracer Mootator MobyIce NapalmBubble Polarizer PowerupAmmo Ryno RynoRocket ShieldCharger ShieldChargerBolt ShockRocket ShockRocketShot ShrinkBeam Spitfire Sproutomatic SuckCannon SuckCannonComet SuckCannonManager TripleWaveBeacon Wrench GrappleSwingshot GravityCrystal HeliPack ThrusterPack Hypershot StaticTurretGlove MiniTurret MiniTurretBall MiniTurretGlove'.split()
rows=list(csv.DictReader((ROOT/'development-v0.6.3-generalisation/sources/tables/object_descriptors.csv').open(encoding='utf-8-sig')))
for k in [1,24]:
 e=Elf(REF/f'LEVEL_{k:02d}.PRX')
 starts={e.lo,e.hi}
 for i,w in enumerate(e.words):
  if w&0xffff0000==0x27bd0000 and w&0x8000:starts.add(e.lo+4*i)
  if w>>26==3:starts.add((w&0x3ffffff)<<2)
 for r in rows:
  if int(r['module_index'])==k:
   starts.update(int(x,16) for x in r['callback_rvas'].split(';'))
 starts=sorted(x for x in starts if e.lo<=x<=e.hi)
 selected=[r for r in rows if int(r['module_index'])==k and r['object_name'] in CLASSES]
 for r in selected:
  lines=[]
  for cb in r['callback_rvas'].split(';'):
   a=int(cb,16);end=starts[bisect.bisect_right(starts,a)]
   lines.append(f'\nCALLBACK {hx(a)} end {hx(end)} ordinal {r["callback_rvas"].split(";").index(cb)}\n')
   s,o=e.locate(a)
   lines.extend(f'{i.address:08X} {int.from_bytes(i.bytes,"little"):08X} {i.mnemonic:10} {i.op_str}' for i in md.disasm(e.b[o:o+end-a],a))
  (OUT/f'L{k:02d}-{r["object_name"]}.asm').write_text('\n'.join(lines),encoding='utf-8')
 print(k,len(selected))
(OUT/'weapon-classes.json').write_text(json.dumps(CLASSES))
