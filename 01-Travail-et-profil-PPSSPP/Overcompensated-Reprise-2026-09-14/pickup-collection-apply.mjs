import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),changes:[],status:'preflight'},stamp=Date.now();let written=false;
const mem=async(address,size)=>Buffer.from((await req('memory.read',{address,size,replacements:false})).base64,'base64');const word=async a=>(await mem(a,4)).readUInt32LE();
const json=p=>JSON.parse(fs.readFileSync(path.join(root,p),'utf8').replace(/^\uFEFF/,''));
const save=()=>fs.writeFileSync(path.join(root,'connection/pickup-collection-'+stamp+'.json'),JSON.stringify(out,null,2));
try{
 const prior=json('connection/resume-crates-result-1789592738689.json'),base=prior.base,plugin=prior.plugin;out.base=base;out.plugin=plugin;
 if(!(await req('cpu.status')).stepping||(await req('game.status')).game?.id!=='UCES00420'||await word(0x08841120)!==4||await word(plugin+72576+1132)!==base||await word(plugin+72576+1160)!==1)throw Error('Session guard');
 const add=(rva,before,after,label)=>out.changes.push({address:base+rva,rva,before,after,label});
 add(0x1352fc,0x3c04bf80,0x3c04bf00,'Nanotech attraction timer -1 -> -0.5');
 add(0x1340a4,0x3c05bf80,0x3c05bf00,'Nanotech fade timer -1 -> -0.5');
 for(const [rva,before,factor,label] of [[0x2e3544,0x3dccccce,.5,'pickup initial speed'],[0x2e3554,0x3d75c290,.25,'pickup acceleration'],[0x2e3558,0x3eaaaaab,.5,'pickup max speed'],[0x2e355c,0x3da3d70a,null,'pickup steering below cap'],[0x2e3560,0x3e4ccccd,null,'pickup steering at cap']]){const b=Buffer.alloc(4);b.writeUInt32LE(before);const old=b.readFloatLE(),v=factor===null?1-Math.sqrt(1-old):old*factor;b.writeFloatLE(v);add(rva,before,b.readUInt32LE(),label);out.changes.at(-1).originalFloat=old;out.changes.at(-1).newFloat=v;}
 for(const c of out.changes)if(await word(c.address)!==c.before)throw Error('Unexpected '+c.label);
 for(const c of prior.changes.filter(c=>!c.dynamic))if(await word(c.address)!==c.after)throw Error('Prior patch missing');
 const inventory=json('connection/pickup-paused-inventory.json');
 const nano=inventory.objects.find(o=>o.name==='DerbyPowerupHealth');if(!nano||await word(nano.object+0x40)!==nano.descriptor||await word(nano.object+0x58)!==nano.pvars)throw Error('Nanotech changed');
 const n=await mem(nano.object,128),np=await mem(nano.pvars,128);out.nano={...nano,state:n[0x45],attractionTime:np.readFloatLE(0x44),fadeTime:np.readFloatLE(0x48),target:np.readUInt32LE(0x78)};
 if(out.nano.state!==2)throw Error('Nanotech no longer in collection state');
 const target=await mem(out.nano.target,128);out.nano.targetDescriptor=target.readUInt32LE(0x40);
 if(out.nano.targetDescriptor!==inventory.objects.find(o=>o.name==='ClankSawTorso')?.descriptor)throw Error('Nanotech target not player');
 // Convert only current pickup speeds with valid descriptor/state and this confirmed player target.
 const descriptor=inventory.objects.find(o=>o.name==='DerbyPowerup')?.descriptor;if(!descriptor)throw Error('No pickup descriptor');
 const start=0x09400000,end=0x0a000000,data=await mem(start,end-start),seen=new Set();
 for(let i=0x40;i<data.length-0x40;i+=4){if(data.readUInt32LE(i)!==descriptor)continue;const o=i-0x40;if(data[o+0x45]!==3)continue;const pv=data.readUInt32LE(o+0x58);if(pv<start||pv+32>=end||seen.has(pv)||data.readUInt32LE(pv-start+0x14)!==out.nano.target)continue;const before=data.readUInt32LE(pv-start+0xc),b=Buffer.alloc(4);b.writeUInt32LE(before);const v=b.readFloatLE();if(!Number.isFinite(v)||v<0||v>2)throw Error('Unexpected pickup speed');b.writeFloatLE(v*.5);out.changes.push({address:pv+0xc,before,after:b.readUInt32LE(),label:'current player-bound pickup speed',dynamic:true,object:start+o,pvars:pv});seen.add(pv);}
 save();written=true;
 for(const c of out.changes){await req('memory.write_u32',{address:c.address,value:c.after});if(await word(c.address)!==c.after)throw Error('Write mismatch');c.verified=true;}
 out.status='applied_verified_CPU_suspended';
}catch(e){out.error=String(e);out.status='failed_CPU_suspended';process.exitCode=1;if(written){out.rollback=[];for(const c of [...out.changes].reverse()){await req('memory.write_u32',{address:c.address,value:c.before});out.rollback.push({address:c.address,ok:await word(c.address)===c.before});}}}
finally{save();console.log(JSON.stringify(out,null,2));ws.close();}
