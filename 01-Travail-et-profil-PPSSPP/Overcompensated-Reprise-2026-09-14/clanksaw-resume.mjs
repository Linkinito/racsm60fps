import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
try {
 const cpu=await req('cpu.status');
 if(!cpu.stepping||cpu.pc!==0x09176854)throw Error('Unexpected CPU state; no resume sent');
 if((await req('game.status')).game?.id!=='UCES00420'||(await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong game/module');
 const plan=JSON.parse(fs.readFileSync(path.join(root,'connection/clanksaw-movement-result.json')));
 for(const c of plan.changes){if((await req('memory.read_u32',{address:c.address})).value!==c.after)throw Error('Test value changed; no resume sent');}
 ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,200));
 const after=await req('cpu.status');fs.writeFileSync(path.join(root,'connection/clanksaw-resume.json'),JSON.stringify({time:new Date().toISOString(),after},null,2));console.log(JSON.stringify(after));
}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}
