import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),objects:[]};
try{
 if((await req('game.status')).game?.id!=='UCES00420'||(await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong game/module');
 out.cpuBefore=await req('cpu.status'); if(!out.cpuBefore.stepping){ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,120));} if(!(await req('cpu.status')).stepping)throw Error('CPU stop failed'); const start=0x09400000,end=0x0a000000;
 const response=await req('memory.read',{address:start,size:end-start});const data=Buffer.from(response.base64,'base64');
 const classes=JSON.parse(fs.readFileSync(path.join(root,'connection/metalis-classes.json'),'utf8').replace(/^\uFEFF/,''));
 const lookup=new Map();for(const c of classes){const cb=c.callback_rvas.split(';').map(v=>parseInt(v.trim(),16)+0x0914bd00);if(cb.length>=3)lookup.set(cb[2],{name:c.object_name,cb});}
 for(let i=28;i<data.length-8;i+=4){const item=lookup.get(data.readUInt32LE(i));if(!item||data.readUInt32LE(i-8)!==item.cb[0]||data.readUInt32LE(i-4)!==item.cb[1])continue;
 const descriptor=start+i-28,object=data.readUInt32LE(i-16);let valid=false;
 if(object>=start&&object+0x80<=end)valid=data.readUInt32LE(object-start+0x40)===descriptor;
 if(valid){const o=object-start;out.objects.push({name:item.name,descriptor,object,update:item.cb[2],state:data[o+0x45],timer:data.readFloatLE(o+0x70),pvars:data.readUInt32LE(o+0x58),props:data.readUInt32LE(o+0x54)});}}
 fs.writeFileSync(path.join(root,'connection/pickup-paused-inventory.json'),JSON.stringify(out,null,2));console.log(JSON.stringify({...out,objects:out.objects.filter(o=>/Health|Ammo|Nano|Powerup|Pickup/i.test(o.name))},null,2));
}catch(e){console.error(String(e));process.exitCode=1;}finally{ws.close();}

