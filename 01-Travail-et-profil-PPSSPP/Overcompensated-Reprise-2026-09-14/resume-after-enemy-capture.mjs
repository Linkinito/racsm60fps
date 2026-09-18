import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
try{
 const cpu=await req('cpu.status');const bp=await req('cpu.breakpoint.list');const mbp=await req('memory.breakpoint.list');console.log(JSON.stringify({cpu,breakpoints:bp,memoryBreakpoints:mbp}));
 if(cpu.stepping){ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,100));console.log(JSON.stringify(await req('cpu.status')));}
}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}
