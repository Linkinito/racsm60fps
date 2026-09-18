import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const plan=JSON.parse(fs.readFileSync(path.join(root,'metalis-global-audit/arena-batch-plan.json'))),out={time:new Date().toISOString(),coverage:plan.coverage,changes:[],status:'preflight'};let started=false;
const read=async a=>Buffer.from((await req('memory.read',{address:a,size:4,replacements:false})).base64,'base64').readUInt32LE();
try{
 if((await req('game.status')).game?.id!=='UCES00420'||(await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong game/module');
 if(!(await req('cpu.status')).stepping)throw Error('CPU must be suspended');
 for(const c of plan.changes){const v=await read(c.address);if(v!==c.before)throw Error('Preflight mismatch '+c.label+' '+v.toString(16));out.changes.push({...c});}
 const ctrl=JSON.parse(fs.readFileSync(path.join(root,'connection/derby-controller-live.json')));
 for(const v of ctrl.vehicles.filter(v=>v.name.startsWith('Enemy'))){if(await read(v.object+0x40)!==v.descriptor||await read(v.object+0x58)!==v.pvars)throw Error('Actor changed');const before=await read(v.pvars),b=Buffer.alloc(4);b.writeUInt32LE(before);const f=b.readFloatLE();if(!Number.isFinite(f)||Math.abs(f)>20)throw Error('Unexpected speed');b.writeFloatLE(f*.5);out.changes.push({address:v.pvars,before,after:b.readUInt32LE(),label:'current '+v.name+' speed; dynamic value, rollback only before execution'});}
 fs.writeFileSync(path.join(root,'connection/arena-batch-before.json'),JSON.stringify(out,null,2));started=true;
 for(const c of out.changes){await req('memory.write_u32',{address:c.address,value:c.after});if(await read(c.address)!==c.after)throw Error('Write verification failed '+c.label);c.verified=true;}
 out.status='applied_CPU_suspended';
}catch(e){out.error=String(e);process.exitCode=1;if(started){out.rollback=[];for(const c of [...out.changes].reverse()){try{await req('memory.write_u32',{address:c.address,value:c.before});out.rollback.push({address:c.address,ok:await read(c.address)===c.before});}catch(x){out.rollback.push({address:c.address,error:String(x)});}}out.status='failed_rollback_attempted';}}
finally{fs.writeFileSync(path.join(root,'connection/arena-batch-result.json'),JSON.stringify(out,null,2));console.log(JSON.stringify({status:out.status,error:out.error,count:out.changes.length,verified:out.changes.filter(c=>c.verified).length,rollback:out.rollback},null,2));ws.close();}
