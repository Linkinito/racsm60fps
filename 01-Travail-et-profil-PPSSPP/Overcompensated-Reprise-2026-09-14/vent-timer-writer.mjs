import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),address:157720416+0x70};let armed=false;
try{
 if(!(await req('cpu.status')).stepping)throw Error('Expected suspended CPU');
 const existing=await req('memory.breakpoint.list');if(existing.breakpoints?.length||existing.memchecks?.length)throw Error('Existing memory breakpoints require review');
 await req('memory.breakpoint.add',{address:out.address,size:4,write:true,read:false,enabled:true,log:false});armed=true;
 ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,350));out.cpu=await req('cpu.status');
 if(!out.cpu.stepping){ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,100));throw Error('Watchpoint did not hit promptly');}
 out.regs=await req('cpu.getAllRegs');out.code=await req('memory.read',{address:out.cpu.pc-32,size:80,replacements:false});
 fs.writeFileSync(path.join(root,'connection/vent-timer-writer.json'),JSON.stringify(out,null,2));console.log(JSON.stringify({cpu:out.cpu,address:out.address,code:Buffer.from(out.code.base64,'base64').toString('hex')},null,2));
}catch(e){console.error(String(e));process.exitCode=1;}finally{if(armed)await req('memory.breakpoint.remove',{address:out.address,size:4});ws.close();}
