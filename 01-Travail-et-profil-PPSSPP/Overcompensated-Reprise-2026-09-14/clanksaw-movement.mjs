import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const snap=JSON.parse(fs.readFileSync(path.join(root,'connection/vehicle-live-capture.json')));
const out={time:new Date().toISOString(),test:'ClankSaw movement constants only',changes:[],CPU:'left suspended'};
const read=async(address,size)=>Buffer.from((await req('memory.read',{address,size,replacements:false})).base64,'base64');
try{
 const cpu=await req('cpu.status');if(!cpu.stepping||cpu.pc!==0x09176854)throw Error('Expected suspended movement entry');
 if((await req('game.status')).game?.id!=='UCES00420'||(await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong game/module');
 const table=await read(snap.args.a2,64),state=await read(snap.args.a0,64),obj=await read(snap.args.a1,128);
 if(!table.equals(Buffer.from(snap.parameters.base64,'base64'))||!state.equals(Buffer.from(snap.motion.base64,'base64'))||!obj.equals(Buffer.from(snap.object.base64,'base64')))throw Error('Snapshot changed');
 const desc=await read(snap.descriptorAddress,36);if(desc.readUInt32LE(28)!==0x0914bd00+0x12cf94)throw Error('Not ClankSaw');
 // Forward/reverse caps use distance per update; acceleration/braking use change of that value per update.
 // Leave angular response and collision/knockback values untouched for this first isolated movement test.
 for(const [off,factor,label] of [[0,.5,'forward cap'],[4,.5,'reverse cap'],[12,.25,'forward acceleration'],[16,.25,'reverse acceleration'],[20,.25,'braking'],[24,.25,'coasting deceleration']]){
 const before=table.readUInt32LE(off),value=table.readFloatLE(off)*factor,after=Buffer.alloc(4);after.writeFloatLE(value);
 out.changes.push({address:snap.args.a2+off,before,after:after.readUInt32LE(),label});}
 const velocity=Buffer.alloc(4);velocity.writeFloatLE(state.readFloatLE(0)*.5);out.changes.push({address:snap.args.a0,before:state.readUInt32LE(0),after:velocity.readUInt32LE(),label:'current forward velocity; restore only while still suspended in this snapshot'});
 fs.writeFileSync(path.join(root,'connection/clanksaw-movement-plan.json'),JSON.stringify(out,null,2));
 for(const c of out.changes){await req('memory.write_u32',{address:c.address,value:c.after});c.verified=(await read(c.address,4)).readUInt32LE()===c.after;if(!c.verified)throw Error('Readback failed');}
 out.success=true;
}catch(e){out.error=String(e);process.exitCode=1;}
finally{fs.writeFileSync(path.join(root,'connection/clanksaw-movement-result.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));ws.close();}
