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
 out.profiler=await req('memory.read_u32',{address:base+73740});
 fs.writeFileSync(path.join(root,'connection/wf029-before.json'),JSON.stringify(out,null,2));
 const b=Buffer.from(out.binding.base64,'base64');
 console.log(JSON.stringify({...out,binding:undefined,hooks:Buffer.from(out.hooks.base64,'base64').toString('hex'),call:Buffer.from(out.call.base64,'base64').toString('hex'),bindingHead:b.subarray(0,64).toString('hex'),bindingTail:b.subarray(1080).toString('hex'),wf29:[...Array(64).keys()].filter(i=>b.readUInt16LE(56+i*8+4)===29).map(i=>({i,address:base+72576+56+i*8,ra:b.readUInt32LE(56+i*8),policy:b[56+i*8+6]}))},null,2));
}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}
