import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString()};
try{
 out.cpu=await req('cpu.status');out.breakpoints=await req('cpu.breakpoint.list');
 if(out.cpu.stepping&&out.cpu.pc===0x09176854){
 out.regs=await req('cpu.getAllRegs');const g=out.regs.categories.find(c=>c.id===0);const reg=n=>{const i=g.registerNames.findIndex(s=>s.replace('$','')===n);if(i<0)throw Error('Register missing '+n);return g.uintValues[i];};
 out.args={a0:reg('a0'),a1:reg('a1'),a2:reg('a2'),ra:reg('ra')};
 for(const [name,address,size] of [['motion',out.args.a0,64],['object',out.args.a1,128],['parameters',out.args.a2,64]])out[name]=await req('memory.read',{address,size,replacements:false});
 const object=Buffer.from(out.object.base64,'base64');out.descriptorAddress=object.readUInt32LE(0x40);out.descriptor=await req('memory.read',{address:out.descriptorAddress,size:80});
 fs.writeFileSync(path.join(root,'connection/enemy-ram-live-capture.json'),JSON.stringify(out,null,2));
 await req('cpu.breakpoint.remove',{address:out.cpu.pc});out.captured=true;
 }
 console.log(JSON.stringify({...out,regs:undefined},null,2));
}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}

