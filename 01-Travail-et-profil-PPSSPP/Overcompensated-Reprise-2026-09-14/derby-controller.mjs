import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString()};
try{
 const inventory=JSON.parse(fs.readFileSync(path.join(root,'connection/metalis-active-objects.json')));
 const c=inventory.objects.find(o=>o.name==='VehicleController');const data=Buffer.from((await req('memory.read',{address:c.pvars,size:128})).base64,'base64');out.controller=c;out.count=data[0x44];out.enabled=data[0x46];out.vehicles=[];
 if(out.count>8)throw Error('Unexpected controller count');
 for(let i=0;i<out.count;i++){const object=data.readUInt32LE(i*8);const obj=Buffer.from((await req('memory.read',{address:object,size:128})).base64,'base64');const descriptor=obj.readUInt32LE(0x40);out.vehicles.push({object,name:inventory.objects.find(o=>o.descriptor===descriptor)?.name,descriptor,pvars:obj.readUInt32LE(0x58),controllerMethods:data.readUInt32LE(i*8+4),flags:obj.readUInt32LE(0x64)});}
 fs.writeFileSync(path.join(root,'connection/derby-controller-live.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));
}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}
