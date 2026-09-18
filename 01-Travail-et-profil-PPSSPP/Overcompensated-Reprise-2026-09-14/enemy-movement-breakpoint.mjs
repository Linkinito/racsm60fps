import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString()};
try{
 if((await req('game.status')).game?.id!=='UCES00420'||(await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong game/module');
 const ctrl=JSON.parse(fs.readFileSync(path.join(root,'connection/derby-controller-live.json')));const enemy=ctrl.vehicles.find(v=>v.name==='EnemyRamTorso');if(!enemy)throw Error('Missing enemy reference');
 if((await req('memory.read_u32',{address:enemy.object+0x40})).value!==enemy.descriptor)throw Error('Enemy changed');
 const address=0x09176854;
 const b=Buffer.from((await req('memory.read',{address,size:8,replacements:false})).base64,'base64');if(b.readUInt32LE()!==0x27bdffb0||b.readUInt32LE(4)!==0xe7b4003c)throw Error('Code changed');
 const list=await req('cpu.breakpoint.list');if(list.breakpoints.some(p=>p.address===address))throw Error('Breakpoint exists');
 out.address=address;out.condition='a1 == 0x'+enemy.object.toString(16);out.enemy=enemy;
 await req('cpu.breakpoint.add',{address,enabled:true,log:false,condition:out.condition});out.verified=await req('cpu.breakpoint.list');
 fs.writeFileSync(path.join(root,'connection/enemy-movement-breakpoint.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));
}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}
