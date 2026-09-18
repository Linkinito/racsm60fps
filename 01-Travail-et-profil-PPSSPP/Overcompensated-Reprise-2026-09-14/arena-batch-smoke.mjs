import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString()};
try{
 if(!(await req('cpu.status')).stepping)throw Error('Expected suspended CPU');ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,300));ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,100));out.cpu=await req('cpu.status');if(!out.cpu.stepping)throw Error('Failed to suspend');
 const plan=JSON.parse(fs.readFileSync(path.join(root,'metalis-global-audit/arena-batch-plan.json')));out.mismatches=[];
 for(const c of plan.changes){const v=Buffer.from((await req('memory.read',{address:c.address,size:4,replacements:false})).base64,'base64').readUInt32LE();if(v!==c.after)out.mismatches.push({label:c.label,address:c.address,observed:v});}
 out.pluginInstalled=(await req('memory.read_u32',{address:0x08957100+72576+1160})).value;out.verified=out.mismatches.length===0&&out.pluginInstalled===1;
 fs.writeFileSync(path.join(root,'connection/arena-batch-smoke.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));
}catch(e){console.error(String(e));process.exitCode=1;ws.send(JSON.stringify({event:'cpu.stepping'}));}finally{ws.close();}
