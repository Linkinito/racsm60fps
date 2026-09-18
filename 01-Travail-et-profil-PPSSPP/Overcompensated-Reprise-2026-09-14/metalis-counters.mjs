import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString()};
try{
 out.game=await req('game.status');if(out.game.game?.id!=='UCES00420')throw Error('Wrong game');
 out.before=await req('cpu.status');
 if(!out.before.stepping){ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,200));}
 out.paused=await req('cpu.status');if(!out.paused.stepping)throw Error('CPU not suspended');
 out.module=await req('memory.read_u32',{address:0x08841120});if(out.module.value!==4)throw Error('Wrong module');
 out.call=await req('memory.read',{address:0x0917764c,size:16,replacements:false});
 out.hooks=await req('memory.read',{address:0x0895b754,size:56,replacements:false});
 const base=0x0895b754-18004;out.base=base;
 out.binding=await req('memory.read',{address:base+72576,size:1164});
 out.active=await req('memory.read_u32',{address:base+65808});
 out.index=await req('memory.read_u32',{address:base+65804});
 out.profiler=await req('memory.read',{address:base+73740,size:2568});
 fs.writeFileSync(path.join(root,'connection/metalis-counters.json'),JSON.stringify(out,null,2));
 const b=Buffer.from(out.binding.base64,'base64');
 const stats=Buffer.from(out.profiler.base64,'base64'); const rows=[];
 for(let i=0;i<b.readUInt16LE(10);i++){const o=4+i*40; rows.push({i,family:b.readUInt16LE(56+i*8+4),policy:b[56+i*8+6],ra:'0x'+b.readUInt32LE(56+i*8).toString(16),hits:stats.readUInt32LE(o),first:stats.readUInt32LE(o+4),last:stats.readUInt32LE(o+8),activeVblanks:stats.readUInt32LE(o+12)});}
 console.log(JSON.stringify({active:out.active,index:out.index,rows},null,2));
 if(!out.before.stepping){ws.send(JSON.stringify({event:'cpu.resume'})); await new Promise(r=>setTimeout(r,150));}}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}

