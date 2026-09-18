import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const plan=JSON.parse(fs.readFileSync(path.join(root,'connection/resume-crates-preflight-1789592677697.json'),'utf8'));
const out={time:new Date().toISOString(),base:plan.base,plugin:plan.plugin,changes:[],status:'preflight'};let wrote=false,ran=false;
const word=async address=>Buffer.from((await req('memory.read',{address,size:4,replacements:false})).base64,'base64').readUInt32LE();
const stop=async()=>{ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,120));if(!(await req('cpu.status')).stepping)throw Error('CPU not suspended');};
const save=()=>fs.writeFileSync(path.join(root,'connection/resume-crates-result-'+stamp+'.json'),JSON.stringify(out,null,2));const stamp=Date.now();
try{
 if(plan.status!=='preflight_ok_CPU_suspended'||!(await req('cpu.status')).stepping)throw Error('Preflight required');
 if((await req('game.status')).game?.id!=='UCES00420'||await word(0x08841120)!==4||await word(plan.plugin+72576+1132)!==plan.base||await word(plan.plugin+72576+1160)!==1)throw Error('Session changed');
 for(const c of plan.changes){if(await word(c.address)!==c.current)throw Error('Value changed '+c.label);if(c.needsWrite)out.changes.push({...c,before:c.current});}
 if(plan.controllers.length!==1)throw Error('Controller ambiguous');
 for(const v of plan.controllers[0].vehicles){if(!['ClankSawTorso','EnemyElectroTorso','EnemyRamTorso'].includes(v.name))throw Error('Unexpected actor');if(await word(v.object+0x40)!==v.descriptor||await word(v.object+0x58)!==v.pvars)throw Error('Actor changed');const before=await word(v.pvars),b=Buffer.alloc(4);b.writeUInt32LE(before);const speed=b.readFloatLE();if(!Number.isFinite(speed)||Math.abs(speed)>20)throw Error('Unexpected current speed');b.writeFloatLE(speed*.5);out.changes.push({address:v.pvars,before,after:b.readUInt32LE(),label:v.name+' current forward velocity',dynamic:true});}
 save();wrote=true;
 for(const c of out.changes){await req('memory.write_u32',{address:c.address,value:c.after});if(await word(c.address)!==c.after)throw Error('Write check '+c.label);c.verified=true;}
 out.status='applied_CPU_suspended';save();
 ran=true;ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,200));await stop();
 for(const c of plan.changes)if(await word(c.address)!==c.after)throw Error('Persistence failed '+c.label);
 if(await word(plan.plugin+72576+1160)!==1)throw Error('Plugin disarmed');
 out.persistentSites=plan.changes.length;out.status='verified_resumed_to_user_pause';save();ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,120));out.cpuAfter=await req('cpu.status');
 if(out.cpuAfter.stepping)throw Error('CPU did not resume');
}catch(e){out.error=String(e);process.exitCode=1;out.status=ran?'error_after_execution_check_CPU_state':'failed_before_execution';if(wrote&&!ran){out.rollback=[];for(const c of [...out.changes].reverse()){try{await req('memory.write_u32',{address:c.address,value:c.before});out.rollback.push({address:c.address,ok:await word(c.address)===c.before});}catch(x){out.rollback.push({address:c.address,error:String(x)});}}}
}finally{save();console.log(JSON.stringify({file:'connection/resume-crates-result-'+stamp+'.json',status:out.status,error:out.error,writes:out.changes.length,persistentSites:out.persistentSites,cpuAfter:out.cpuAfter,rollback:out.rollback},null,2));ws.close();}

