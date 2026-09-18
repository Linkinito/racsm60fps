import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
try {
 const status=await req('cpu.status');if(!status.stepping)throw Error('CPU not suspended');
 if((await req('game.status')).game?.id!=='UCES00420'||(await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong game/module');
 const plan=JSON.parse(fs.readFileSync(path.join(root,'metalis-global-audit/arena-batch-plan.json')));
 for(const c of plan.changes){const v=Buffer.from((await req('memory.read',{address:c.address,size:4,replacements:false})).base64,'base64').readUInt32LE();if(v!==c.after)throw Error('Patch changed: '+c.label);}
 if((await req('cpu.breakpoint.list')).breakpoints.length||(await req('memory.breakpoint.list')).breakpoints.length)throw Error('Unexpected breakpoint');
 ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,150));const after=await req('cpu.status');
 fs.writeFileSync(path.join(root,'connection/arena-batch-resume.json'),JSON.stringify({time:new Date().toISOString(),after},null,2));console.log(JSON.stringify(after));
}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}
