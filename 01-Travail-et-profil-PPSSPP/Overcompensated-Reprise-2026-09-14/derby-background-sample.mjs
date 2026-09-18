import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),samples:[]};const start=0x09660000,size=0x30000;
try{
 if(!(await req('cpu.status')).stepping)throw Error('Expected suspended CPU');
 const inventory=JSON.parse(fs.readFileSync(path.join(root,'connection/metalis-active-objects.json')));const lookup=new Map(inventory.objects.filter(o=>/Enemy.*Torso|Obstacle|VehicleMine|VehicleMissile|DestructionDerby/.test(o.name)).map(o=>[o.descriptor,o.name]));
 async function sample(){const data=Buffer.from((await req('memory.read',{address:start,size})).base64,'base64');const rows=[];
 for(let i=0x40;i<data.length-0x40;i+=4){const descriptor=data.readUInt32LE(i),name=lookup.get(descriptor);if(!name)continue;const o=i-0x40,flags=data.readUInt32LE(o+0x64);if((flags&6)!==0)continue;const pos=[0x30,0x34,0x38].map(x=>data.readFloatLE(o+x));if(!pos.every(Number.isFinite))continue;rows.push({name,address:start+o,flags,state:data[o+0x45],pos,timer:data.readFloatLE(o+0x70),pvars:data.readUInt32LE(o+0x58)});}
 return {cpu:await req('cpu.status'),rows};}
 out.samples.push(await sample());ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,1200));ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,100));if(!(await req('cpu.status')).stepping)throw Error('Could not suspend');out.samples.push(await sample());
 const old=new Map(out.samples[0].rows.map(o=>[o.address,o]));out.changes=out.samples[1].rows.flatMap(o=>{const p=old.get(o.address);if(!p)return[];const moved=o.pos.some((v,i)=>v!==p.pos[i]),dt=o.timer-p.timer;return moved||dt!==0||o.state!==p.state?[{name:o.name,address:o.address,timerDelta:dt,moved,state:[p.state,o.state]}]:[];});
 fs.writeFileSync(path.join(root,'connection/derby-background-sample.json'),JSON.stringify(out,null,2));console.log(JSON.stringify({beforeCount:out.samples[0].rows.length,afterCount:out.samples[1].rows.length,changes:out.changes,CPU:'suspended'},null,2));
}catch(e){console.error(String(e));process.exitCode=1;ws.send(JSON.stringify({event:'cpu.stepping'}));}finally{ws.close();}
