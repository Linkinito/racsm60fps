import pathlib,struct,json,hashlib,math
r=pathlib.Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14');o=r/'research-2026-09-16'/'metalis';o.mkdir(parents=True,exist_ok=True)
p=pathlib.Path(r'C:\Users\linki\Downloads\Ratchet & Clank - Size Matters (Europe) (PSN)\Data\BACKUP\BIN\LEVEL_04.PRX');b=p.read_bytes()
changes=[]
for label,a,old,new in [('TeleporterHealth countdown',0x13579c,0x3c04bf80,0x3c04bf00),('TeleporterPowerup countdown',0x135cf0,0x3c04bf80,0x3c04bf00),('Teleport emitter elapsed seconds',0x67060,0x3c063d08,0x3c063c88)]:
 actual=struct.unpack_from('<I',b,116+a)[0];assert actual==old,(label,hex(actual))
 changes.append(dict(label=label,rva=a,before=old,after=new,verified_against_original=True))
plan=dict(status='STAGED_NOT_APPLIED_NOT_VISUALLY_VALIDATED',game='UCES00420',module=4,sha256=hashlib.sha256(b).hexdigest(),changes=changes,conditions=['Verify fresh module base; never reuse previous absolute addresses','Require v0.6 global 60fps active and CPU suspended','Read original instructions with replacements:false','Preflight all words before any write; snapshot; readback; rollback only changed words on failure','Do not change 30-to-frame conversion at 1359C4 or 135F18: countdown already halved','67060 is shared emitter timing: scope wider than two crate teleporters; full VFX lifetime remains to audit'])
(o/'crate-candidates.json').write_text(json.dumps(plan,indent=2))
# Preserve previous static experiments as relocation-independent evidence, not an auto-apply program.
oldplan=json.loads((r/'metalis-global-audit/arena-batch-plan.json').read_text(encoding='utf-8-sig'))
prior=[]
for c in oldplan['changes']:
 c=dict(c);c['rva']=c.pop('address')-0x0914bd00;prior.append(c)
(o/'prior-arena-static-rvas.json').write_text(json.dumps(dict(status='HISTORICAL_EXPERIMENT_NOT_PERSISTENT',previous_base='0x0914BD00',changes=prior,warning='Dynamic enemy velocities intentionally excluded. Player movement and rotation are in separate connection snapshots; do not infer actors persist across restart.'),indent=2))
# Minimal numerical model of a known flight: no game renderer or collision engine emulation.
def fly(dt,tick):
 y,v,g,T=1.0,0.0,-0.02,10.0
 for i in range(1,100):
  y+=v*dt+0.5*g*dt*dt;v+=g*dt;T-=tick
  if T<=0:return dict(iterations=i,seconds=i/(30/dt),height=y,velocity=v)
res={'model':'y0=1,v0=0,g=-.02 per original tick; analytic ground contact T=10 ticks','original30':fly(1,1),'current60_mixed_ticks':fly(.5,1),'candidate60_consistent':fly(.5,.5),'scope':'Illustrates only the countdown/trajectory mismatch; not proof of live game collision or debris lifetime.'}
assert abs(res['original30']['height'])<1e-12 and abs(res['candidate60_consistent']['height'])<1e-12
assert abs(res['current60_mixed_ticks']['height']-.75)<1e-12
(o/'debris-countdown-model.json').write_text(json.dumps(res,indent=2))
print(json.dumps({'verified_new_words':len(changes),'historical_static_sites':len(prior),'model':res},indent=2))
