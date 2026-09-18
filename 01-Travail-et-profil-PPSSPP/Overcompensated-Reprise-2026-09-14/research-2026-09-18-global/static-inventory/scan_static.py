"""Read-only 15-PRX callback and scalar RMW inventory. No generated patch is applied."""
from __future__ import annotations
import sys,pathlib,struct,hashlib,csv,json,bisect,re,collections,math,time
ROOT=pathlib.Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14')
OUT=pathlib.Path(__file__).resolve().parent
REF=ROOT/'development-v0.6.3-generalisation/prx-reference'
sys.path.insert(0,str(ROOT/'sources-v0.4.5/Size_Matters_wrapper_profiler_v0.4.5-prealpha_UCES00420/tools'))
sys.path.insert(0,str(ROOT/'analysis-deps'))
import build_reference_corpus as base
import build_wrapper_family_catalog as cat
from capstone import Cs,CS_ARCH_MIPS,CS_MODE_MIPS32,CS_MODE_LITTLE_ENDIAN
MD=Cs(CS_ARCH_MIPS,CS_MODE_MIPS32|CS_MODE_LITTLE_ENDIAN);MD.skipdata=True
HX=lambda n:f'0x{n:08X}' if n is not None else ''
REG=cat.REGISTERS
LEVELS=dict(base.LEVEL_NAMES);LEVELS[10]='Quodrona';LEVELS[24]='High Impact Treehouse'
MODULES=[1,2,3,4,5,6,7,8,9,10,15,21,22,23,24]
def csvout(name,rows):
 rows=list(rows);fields=list(dict.fromkeys(k for r in rows for k in r))
 with (OUT/name).open('w',encoding='utf-8-sig',newline='') as f:
  w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
def jsonout(name,v):(OUT/name).write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
def s16(w):return (w&65535)-65536 if w&32768 else w&65535
def normal(w,rel):
 if rel==4:return w&0xfc000000
 if rel in (5,6):return w&0xffff0000
 if rel==2:return 0
 return w
def fbits(n):return struct.unpack('<f',struct.pack('<I',n&0xffffffff))[0]
def fhex(v):return HX(struct.unpack('<I',struct.pack('<f',v))[0])
def fmt(v):return f'{v:.9g}' if isinstance(v,float) else str(v)
def category(name):
 n=name.lower()
 rules=[('Vehicules et minijeux',('torso','vehicle','airboard','skyboard','derby','giantclank','clankball','clankhammer')),
 ('Armes, projectiles et degats',('weapon','blaster','blitz','bomb','agent','beemine','shield','shockrocket','crossbow','flame','laser','acid','mine','cannon','ryno','turret','projectile','dart','moot','rocket','mortar')),
 ('Gadgets et outils',('hypershot','polarizer','sprout','sprinkler','clankzapper','gadget','shrink','electroly')),
 ('Ennemis et boss',('enemy','boss','shark','crab','robot','creature','mungo','pygmy','soldier','nurse','flyinghypo','ratchetclone','luna','otto','guard','bird','scarab','plant','pest','technomite')),
 ('Pieges et mecanismes',('obstacle','door','bridge','crank','platform','elevator','lift','boulder','column','movedobject','saw','grind','trigger','vent','wind')),
 ('Caisses, pickups et bonus',('breakable','crate','bolt','titanium','pickup','health','powerup','collect','ammo','boxbreaker')),
 ('Joueur, acteurs et accessoires',('player','hero','ratchet','clank','npc','microbot','botflinger','sheep','pathanimal','qwar')),
 ('Effets, particules et environnement',('effect','particle','water','fx','spark','glow','fire','poison','butterfly','sky','cloud','smoke')),
 ('Camera et presentation',('camera','hud','menu','cutscene','anim','sound','audio'))]
 for label,keys in rules:
  if any(k in n for k in keys):return label
 return 'Autres objets et controleurs'
def gw(w):
 op=w>>26;rt=w>>16&31;rd=w>>11&31
 if op==0:return rd if (w&63) in (0,2,3,4,6,7,9,16,18,32,33,34,35,36,37,38,39,42,43) else None
 if op==17:return rt if (w>>21&31) in (0,2) else None
 if op in (8,9,10,11,12,13,14,15,32,33,34,35,36,37,38,48):return rt
 if op==3:return 31
 return None
def fw(w):
 if w>>26==49:return w>>16&31
 if w>>26==17:
  rs=w>>21&31
  if rs==4:return w>>11&31
  if rs in (16,17,20,21) and (w&63)<48:return w>>6&31
 return None
def branch(w):return w>>26 in (1,2,3,4,5,6,7) or (w>>26==17 and (w>>21&31)==8) or (w>>26==0 and (w&63) in (8,9))
wrap=collections.defaultdict(dict)
for r in csv.DictReader((ROOT/'development-v0.6.3-generalisation/sources/tables/wrapper_family_members.csv').open(encoding='utf-8-sig')):
 wrap[int(r['module_index'])][int(r['owner_rva'],16)]=r['family_id']
all_desc=[];all_cb=[];all_fun=[];all_sites=[];manifest=[];summary=[];started=time.time()
for module in MODULES:
 p=REF/f'LEVEL_{module:02d}.PRX';e=base.Elf32(p.read_bytes(),p.name);t=e.by_name['.text']
 raw=e.section_bytes('.text');words=struct.unpack('<'+'I'*(len(raw)//4),raw[:len(raw)//4*4]);lo=t.address;hi=lo+len(raw)
 rd=lambda a:words[(a-lo)//4] if lo<=a<hi else e.read_u32(a)
 rel={int(r['rva']):int(r['type']) for r in e.relocations()}
 desc,bycb=cat.recover_object_descriptors(e);calls=[];targets=set()
 for j,w in enumerate(words):
  a=lo+j*4
  if w>>26==3 and rel.get(a)==4:
   target=(w&0x3ffffff)<<2
   if lo<=target<hi:calls.append((a,target));targets.add(target)
 pro=set(base.detect_prologues(e));pointers=set()
 for a,k in rel.items():
  if k==2:
   try:v=e.read_u32(a)
   except ValueError:continue
   if lo<=v<hi and v%4==0:pointers.add(v)
 entries=sorted(a for a in ({e.entry_point}|targets|pro|pointers|set(bycb)) if lo<=a<hi and a%4==0)
 ends={a:entries[k+1] if k+1<len(entries) else hi for k,a in enumerate(entries)}
 def owner(a):
  k=bisect.bisect_right(entries,a)-1
  return entries[k] if k>=0 else None
 forward=collections.defaultdict(set);callmap=collections.defaultdict(list)
 for a,target in calls:forward[owner(a)].add(target);callmap[owner(a)].append((a,target))
 an=collections.defaultdict(dict);reachmap={}
 for d in desc:
  for ordinal,start in enumerate(d['callbacks']):
   q=collections.deque([(start,0,(start,))]);seen={start}
   while q:
    f,depth,path=q.popleft();key=(d['object_name'],ordinal)
    if key not in an[f] or depth<an[f][key][0]:an[f][key]=(depth,path)
    if depth==3:continue
    for target in forward.get(f,()):
     if target not in seen:seen.add(target);q.append((target,depth+1,path+(target,)))
   reachmap[(d['object_name'],ordinal)]=seen
 refs=cat.collect_address_references(e);refmap={r.site_rva:r for r in refs}
 strings=cat.collect_strings(e);ss=[s.start for s in strings];sem=collections.defaultdict(list)
 for r in refs:
  s=cat.find_string(strings,ss,r.target_rva)
  if s and s.kind in ('source_path','symbolic_name','pvar_schema'):sem[owner(r.site_rva)].append(s.text)
 info={}
 for f in entries:
  b=e.read_vaddr(f,ends[f]-f);ww=struct.unpack('<'+'I'*(len(b)//4),b[:len(b)//4*4])
  norm=struct.pack('<'+'I'*len(ww),*(normal(w,rel.get(f+k*4)) for k,w in enumerate(ww)))
  inf=dict(module=module,level=LEVELS[module],function_rva=HX(f),function_end_rva_estimate=HX(ends[f]),file_offset=HX(e.file_offset(f)),first_vanilla_word=HX(rd(f)),byte_size_estimate=ends[f]-f,relocation_normalized_sha256=hashlib.sha256(norm).hexdigest(),raw_sha256=hashlib.sha256(b).hexdigest(),boundary_evidence=';'.join(k for k,yes in [('prologue',f in pro),('JAL_target',f in targets),('relocated_pointer',f in pointers),('descriptor_callback',f in bycb)] if yes),direct_objects='; '.join(sorted({d['object_name'] for d in bycb.get(f,[])})),objects_within_3_calls='; '.join(sorted({name for name,_ in an[f]})),source_strings='; '.join(sorted(set(sem[f])))[:3000],known_wrapper_family=wrap[module].get(f,''),direct_calls=len(callmap[f]),indirect_calls=sum(w>>26==0 and (w&63)==9 for w in ww),scalar_fp_arithmetic=sum(w>>26==17 and (w>>21&31)==16 and (w&63)<=3 for w in ww),float_rmw_candidates=0,integer_rmw_candidates=0,fixed_step_candidates=0)
  info[f]=inf;all_fun.append(inf)
 def il(a):
  ds=list(MD.disasm(e.read_vaddr(a,4),a))
  return HX(a)+' '+HX(rd(a))+' '+(ds[0].mnemonic+' '+ds[0].op_str if ds else '?')
 def window(a,b):return ' | '.join(il(x) for x in range(a,b,4))
 def gc(r,before,start,depth=0):
  if r==0:return (0,())
  if depth>8:return None
  for a in range(before-4,max(start-4,before-512),-4):
   w=rd(a)
   if w>>26==3 and r not in range(16,24):return None
   if gw(w)!=r:continue
   op=w>>26;rs=w>>21&31;rt=w>>16&31
   if rel.get(a) in (2,4,5,6):return None
   if op==15:return ((w&65535)<<16,(a,))
   if op in (9,13):
    c=gc(rs,a,start,depth+1)
    if c:return (((c[0]+s16(w) if op==9 else c[0]|(w&65535))&0xffffffff),c[1]+(a,))
   if op==0 and (w&63) in (33,37) and (rs==0 or rt==0):return gc(rt if rs==0 else rs,a,start,depth+1)
   return None
  return None
 def fs(r,before,start,depth=0):
  if depth>8:return None
  for a in range(before-4,max(start-4,before-1024),-4):
   w=rd(a)
   if w>>26==3 and r<20:return None
   if fw(w)!=r:continue
   op=w>>26;rs=w>>21&31
   if op==49:
    ref=refmap.get(a)
    if ref:
     try:
      bits=e.read_u32(ref.target_rva);v=fbits(bits)
      if math.isfinite(v):return dict(kind='constant',value=v,sites=(a,),constant_rva=ref.target_rva,word=bits)
     except ValueError:pass
    return dict(kind='memory',base=rs,offset=s16(w),sites=(a,))
   if op==17 and rs==4:
    c=gc(w>>16&31,a,start)
    if c:
     v=fbits(c[0])
     if math.isfinite(v):return dict(kind='constant',value=v,sites=c[1]+(a,),constant_rva=None,word=c[0])
   if op==17 and rs==16 and (w&63)==6:return fs(w>>11&31,a,start,depth+1)
   return None
  return None
 def store(fr,after,end,br=None,off=None):
  aliases={fr}
  for a in range(after+4,min(end,after+260),4):
   w=rd(a)
   if w>>26==57 and (w>>16&31) in aliases and (br is None or ((w>>21&31)==br and s16(w)==off)):return a,w
   if w>>26==17 and (w>>21&31)==16 and (w&63)==6 and (w>>11&31) in aliases:aliases.add(w>>6&31)
   else:
    wr=fw(w)
    if wr in aliases:aliases.remove(wr)
   if not aliases or w>>26==3 or (br is not None and gw(w)==br):return None
  return None
 def origin(r,before,start,depth=0):
  if depth>5:return REG[r]
  for a in range(before-4,max(start-4,before-512),-4):
   w=rd(a)
   if gw(w)!=r:continue
   op=w>>26;rs=w>>21&31;rt=w>>16&31
   if op==0 and (w&63) in (33,37) and (rs==0 or rt==0):return origin(rt if rs==0 else rs,a,start,depth+1)
   if op==35:return origin(rs,a,start,depth+1)+'->'+{0x58:'pvars',0x54:'props',0x40:'descriptor'}.get(s16(w),f'load[{s16(w):+#x}]')
   return REG[r]
  return REG[r]+'(entry)'
 rows=[]
 def common(f,a,kind,operation,load,br,off,st,delta=''):
  meta=info[f];start=min(a,load or a);nb=sum(branch(rd(x)) for x in range(start,st[0],4))
  return dict(module=module,level=LEVELS[module],candidate_kind=kind,function_rva=HX(f),arithmetic_rva=HX(a),arithmetic_file_offset=HX(e.file_offset(a)),vanilla_word=HX(rd(a)),operation=operation,memory_load_rva=HX(load),memory_base=REG[br] if br is not None else '',memory_origin_heuristic=origin(br,load,f) if br is not None and load is not None else '',field_offset=f'{off:+#x}' if off is not None else '',store_rva=HX(st[0]),store_vanilla_word=HX(st[1]),fixed_delta_per_call=delta,direct_objects=meta['direct_objects'],objects_within_3_calls=meta['objects_within_3_calls'],known_wrapper_family=meta['known_wrapper_family'],source_strings=meta['source_strings'],evidence_confidence='local_straight_line' if not nb else 'linear_slice_only',branches_or_calls_in_linear_slice=nb,status='STATIC_CANDIDATE_NOT_APPLIED_NOT_LIVE_VALIDATED',runtime_address_rule='current verified module text base + RVA',context=window(max(f,start-8),min(ends[f],a+36)))
 for f in entries:
  end=ends[f];meta=info[f]
  for a in range(f,end,4):
   w=rd(a);op=w>>26
   if op==17 and (w>>21&31)==16 and (w&63) in (0,1,2):
    fn=w&63;frs=w>>11&31;frt=w>>16&31;fd=w>>6&31
    src=[fs(frs,a,f),fs(frt,a,f)]
    const=[(k,s) for k,s in enumerate(src) if s and s['kind']=='constant']
    fixed=[(k,s) for k,s in const if abs(s['value']) in (0.5,1.0,2.0,0.25) or (0<abs(s['value'])<=0.1)]
    mems=[(k,s) for k,s in enumerate(src) if s and s['kind']=='memory' and s['base'] not in (0,28,29)]
    rmw=None
    for k,s in mems:
     st=store(fd,a,end,s['base'],s['offset'])
     if st and not any(gw(rd(x))==s['base'] for x in range(s['sites'][0]+4,a,4)):rmw=(k,s,st);break
    if not fixed and not rmw:continue
    st=rmw[2] if rmw else store(fd,a,end)
    if not st or (fn==2 and not rmw):continue
    kind='float_read_modify_write' if rmw else 'float_constant_arithmetic_store'
    relevant=next((s for k,s in fixed if not rmw or k!=rmw[0]),None)
    if rmw and relevant and fn in (0,1):kind='float_fixed_step_read_modify_write'
    if rmw and fn==2:kind='float_multiplicative_read_modify_write'
    mem=rmw[1] if rmw else None;delta=None
    if relevant and fn in (0,1):
     k=next(k for k,s in fixed if s is relevant)
     if fn==0:delta=relevant['value']
     elif k==1:delta=-relevant['value']
    row=common(f,a,kind,('add.s','sub.s','mul.s')[fn],mem['sites'][0] if mem else None,mem['base'] if mem else None,mem['offset'] if mem else None,st,fmt(delta) if delta is not None else '')
    proposal=''
    if delta is not None and abs(delta)==1.0:
     if relevant['constant_rva'] is not None:proposal='CANDIDATE ONLY: '+HX(relevant['constant_rva'])+' '+fhex(relevant['value'])+' -> '+fhex(relevant['value']*.5)+'; audit every reader'
     elif len(relevant['sites'])==2 and rd(relevant['sites'][0])>>26==15:
      old=rd(relevant['sites'][0]);new=(old&0xffff0000)|((int(fhex(relevant['value']*.5),16)>>16)&65535)
      proposal='CANDIDATE ONLY: '+HX(relevant['sites'][0])+' '+HX(old)+' -> '+HX(new)+'; audit all uses and tick ownership'
    row.update(constant_value=fmt(relevant['value']) if relevant else '',constant_bits=HX(relevant['word']) if relevant else '',constant_rva=HX(relevant['constant_rva']) if relevant else '',constant_definition_rvas=';'.join(HX(x) for x in relevant['sites']) if relevant else '',constant_definition_words=';'.join(HX(rd(x)) for x in relevant['sites']) if relevant else '',static_proposal=proposal)
    if relevant:
     begin=min(relevant['sites']);nb=sum(branch(rd(x)) for x in range(begin,st[0],4));row['branches_or_calls_in_linear_slice']=max(nb,row['branches_or_calls_in_linear_slice'])
     if nb:row['evidence_confidence']='linear_slice_only'
    rows.append(row);meta['float_rmw_candidates']+=bool(rmw);meta['fixed_step_candidates']+=kind=='float_fixed_step_read_modify_write'
   elif op==9 and abs(s16(w))==1:
    rs=w>>21&31;rt=w>>16&31
    if rs in (0,29) or rt in (0,29):continue
    load=None
    for q in range(a-4,max(f-4,a-68),-4):
     v=rd(q)
     if gw(v)==rs:
      if v>>26 in (32,33,35,36,37):load=(q,v)
      break
    if not load:continue
    br=load[1]>>21&31;off=s16(load[1])
    if br in (0,28,29):continue
    st=None
    for q in range(a+4,min(end,a+100),4):
     v=rd(q)
     if v>>26 in (40,41,43) and (v>>16&31)==rt and (v>>21&31)==br and s16(v)==off:st=(q,v);break
     if gw(v) in (rt,br) or v>>26==3:break
    if not st:continue
    row=common(f,a,'integer_unit_read_modify_write','addiu',load[0],br,off,st,s16(w))
    row['static_proposal']='NO AUTOMATIC SCALING: distinguish frame timer, ammo, iteration, refcount; integer timer requires gate or accumulator'
    rows.append(row);meta['integer_rmw_candidates']+=1
 all_sites.extend(rows);byfun=collections.defaultdict(list)
 for r in rows:byfun[int(r['function_rva'],16)].append(r)
 for d in desc:
  reach=set()
  for ordinal,start in enumerate(d['callbacks']):
   seen=reachmap[(d['object_name'],ordinal)];reach.update(seen);related=[r for f in seen for r in byfun.get(f,[])]
   all_cb.append(dict(module=module,level=LEVELS[module],object_name=d['object_name'],category=category(d['object_name']),descriptor_rva=HX(d['descriptor_rva']),callback_ordinal=ordinal,callback_rva=HX(start),callback_file_offset=HX(e.file_offset(start)),vanilla_first_word=HX(rd(start)),function_end_rva_estimate=HX(ends[start]),is_empty_return=e.read_vaddr(start,8)==bytes.fromhex('0800e00300000000'),reachable_functions_depth3=len(seen),candidate_sites_depth3=len(related),direct_candidate_sites=len(byfun[start]),known_wrapper_family=wrap[module].get(start,''),role_status='ordinal 2 typically update; other callbacks kept for interaction/animation timing',runtime_address_rule='current verified module text base + callback RVA'))
  own={r['arithmetic_rva'] for f in reach for r in byfun[f]};fixed={r['arithmetic_rva'] for f in reach for r in byfun[f] if r['candidate_kind']=='float_fixed_step_read_modify_write'}
  all_desc.append(dict(module=module,level=LEVELS[module],object_name=d['object_name'],category=category(d['object_name']),descriptor_rva=HX(d['descriptor_rva']),descriptor_file_offset=HX(e.file_offset(d['descriptor_rva'])),name_pointer_vanilla_word=HX(e.read_u32(d['descriptor_rva'])),object_name_rva=HX(d['object_name_rva']),callback_count=len(d['callbacks']),callback_rvas='; '.join(HX(x) for x in d['callbacks']),callback_pointer_file_offsets='; '.join(HX(e.file_offset(d['descriptor_rva']+4+k*4)) for k in range(len(d['callbacks']))),pvar_schema=d['pvar_schema'],candidate_sites_depth3=len(own),fixed_step_sites_depth3=len(fixed),static_presence_only='compiled descriptor; no assertion spawned or active',runtime_address_rule='current verified module text base + RVA'))
 manifest.append(dict(module=module,level=LEVELS[module],path=str(p),sha256=hashlib.sha256(e.data).hexdigest(),bytes=len(e.data),text_rva=HX(lo),text_file_offset=HX(t.offset),text_size=t.size,descriptor_count=len(desc),function_boundaries='heuristic: prologues/JAL targets/relocated pointers/callbacks'))
 s=dict(module=module,level=LEVELS[module],objects=len(desc),callbacks=sum(len(d['callbacks']) for d in desc),function_candidates=len(entries),candidate_sites=len(rows),candidate_functions=len({r['function_rva'] for r in rows}),outside_wrapper_family=sum(not r['known_wrapper_family'] for r in rows),**dict(collections.Counter(r['candidate_kind'] for r in rows)))
 summary.append(s);print(json.dumps(s),flush=True)
 csvout(f'level-{module:02d}-candidates.csv',rows)
 jsonout(f'level-{module:02d}-graph.json',dict(functions={HX(f):[HX(t) for t in sorted(ts)] for f,ts in forward.items()},callbacks=desc))
 csvout('objects-by-level.csv',all_desc);csvout('callbacks-by-level.csv',all_cb);csvout('coverage-by-level.csv',summary)
csvout('functions-by-level.csv',all_fun);csvout('candidate-sites.csv',all_sites)
csvout('fixed-step-float-rmw.csv',(r for r in all_sites if r['candidate_kind']=='float_fixed_step_read_modify_write'))
csvout('integer-unit-rmw.csv',(r for r in all_sites if r['candidate_kind']=='integer_unit_read_modify_write'))
jsonout('vanilla-reference-manifest.json',manifest)
jsonout('counts.json',dict(levels=len(summary),objects=len(all_desc),unique_object_names=len({r['object_name'] for r in all_desc}),callbacks=len(all_cb),functions=len(all_fun),candidate_sites=len(all_sites),candidate_kinds=dict(collections.Counter(r['candidate_kind'] for r in all_sites)),candidate_sites_outside_wrapper_families=sum(not r['known_wrapper_family'] for r in all_sites),elapsed_seconds=round(time.time()-started,2)))
print((OUT/'counts.json').read_text(),flush=True)
