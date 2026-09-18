import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),test:'ClankSaw angular step x0.5'},address=0x09438ba0;let pausedByUs=false;
try {
 if((await req('game.status')).game?.id!=='UCES00420'||(await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong game/module');
 out.cpuBefore=await req('cpu.status');if(!out.cpuBefore.stepping){ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,150));pausedByUs=true;}
 if(!(await req('cpu.status')).stepping)throw Error('CPU not suspended');
 const plan=JSON.parse(fs.readFileSync(path.join(root,'connection/clanksaw-movement-result.json')));
 for(const c of plan.changes.slice(0,6))if((await req('memory.read_u32',{address:c.address})).value!==c.after)throw Error('Movement table no longer matches');
 const snap=JSON.parse(fs.readFileSync(path.join(root,'connection/vehicle-live-capture.json')));
 if((await req('memory.read_u32',{address:snap.args.a1+0x40})).value!==snap.descriptorAddress||(await req('memory.read_u32',{address:snap.descriptorAddress+0x1c})).value!==0x09278c94)throw Error('Vehicle identity changed');
 const original=Buffer.from(snap.parameters.base64,'base64').readUInt32LE(8),current=(await req('memory.read_u32',{address})).value;
 if(current!==original)throw Error('Angular step already changed');
 const b=Buffer.alloc(4);b.writeUInt32LE(original);out.before=b.readFloatLE();b.writeFloatLE(out.before*.5);out.after=b.readFloatLE();out.address=address;out.originalWord=original;out.newWord=b.readUInt32LE();
 fs.writeFileSync(path.join(root,'connection/clanksaw-rotation-plan.json'),JSON.stringify(out,null,2));
 await req('memory.write_u32',{address,value:out.newWord});out.verified=(await req('memory.read_u32',{address})).value===out.newWord;if(!out.verified)throw Error('Readback failed');
 if(pausedByUs){ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,150));}
 out.cpuAfter=await req('cpu.status');out.success=true;
}catch(e){out.error=String(e);process.exitCode=1;}
finally{fs.writeFileSync(path.join(root,'connection/clanksaw-rotation-result.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));ws.close();}
