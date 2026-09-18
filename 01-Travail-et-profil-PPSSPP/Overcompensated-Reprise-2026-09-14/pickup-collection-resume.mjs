import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const files=fs.readdirSync(path.join(root,'connection')).filter(f=>/^pickup-collection-\d+\.json$/.test(f)).sort();const name=files.at(-1);const plan=JSON.parse(fs.readFileSync(path.join(root,'connection',name),'utf8'));
const word=async address=>Buffer.from((await req('memory.read',{address,size:4,replacements:false})).base64,'base64').readUInt32LE();
try{
 if(plan.status!=='applied_verified_CPU_suspended'||!(await req('cpu.status')).stepping||await word(0x08841120)!==4)throw Error('Wrong state');
 for(const c of plan.changes)if(await word(c.address)!==c.after)throw Error('Patch mismatch');
 ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,200));
 const out={time:new Date().toISOString(),plan:name,cpu:await req('cpu.status'),installed:await word(plan.plugin+72576+1160),persistent:true};
 for(const c of plan.changes.filter(c=>!c.dynamic))if(await word(c.address)!==c.after)out.persistent=false;
 fs.writeFileSync(path.join(root,'connection/pickup-collection-resume.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));
}finally{ws.close();}
