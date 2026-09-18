import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),address:0x0914bd00+0x2ab54};
try{
 if((await req('game.status')).game?.id!=='UCES00420')throw Error('Wrong game');
 if((await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong module');
 const code=Buffer.from((await req('memory.read',{address:out.address,size:8,replacements:false})).base64,'base64');
 if(code.readUInt32LE(0)!==0x27bdffb0||code.readUInt32LE(4)!==0xe7b4003c)throw Error('Unexpected movement routine');
 out.before=await req('cpu.breakpoint.list');if(out.before.breakpoints.some(b=>b.address===out.address))throw Error('Breakpoint already exists');
 out.add=await req('cpu.breakpoint.add',{address:out.address,enabled:true,log:false});out.after=await req('cpu.breakpoint.list');
 out.cpu=await req('cpu.status');
 fs.writeFileSync(path.join(root,'connection/vehicle-breakpoint.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));
}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}
