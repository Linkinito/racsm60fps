import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString()};
try {
 out.game=await req('game.status'); if(out.game.game?.id!=='UCES00420')throw Error('Wrong game');
 out.module=await req('memory.read_u32',{address:0x08841120}); if(out.module.value!==4)throw Error('Wrong module');
 const b=Buffer.from((await req('memory.read',{address:0x08957100+72576,size:1164,replacements:false})).base64,'base64');
 const base=b.readUInt32LE(1132); if(base!==0x0914bd00||b.readUInt16LE(1080)!==4||b.readUInt32LE(1160)!==1)throw Error('Binding changed');
 const ins=Buffer.from((await req('memory.read',{address:base+0xaddcc,size:8,replacements:false})).base64,'base64'); const dataAddress=((ins.readUInt32LE(0)&65535)*65536+ins.readInt16LE(4))>>>0; out.dataAddress=dataAddress; out.base=base;out.cpu=await req('cpu.status');out.pauseData=await req('memory.read',{address:dataAddress,size:128,replacements:false});
 const state=Buffer.from(out.pauseData.base64,'base64').readUInt32LE(12);out.screen=state;
 if(state>=1&&state<=38)out.updateTarget=await req('memory.read_u32',{address:base+0x1d6bf0+4*(state-1)});
 const menuIns=Buffer.from((await req('memory.read',{address:base+0xb25cc,size:12,replacements:false})).base64,'base64');out.menuAddress=((menuIns.readUInt32LE(0)&65535)*65536+menuIns.readInt16LE(8))>>>0;const mh=Buffer.from((await req('memory.read',{address:out.menuAddress,size:168,replacements:false})).base64,'base64');out.menuHeader=mh.toString('base64');out.menuCount=mh.readUInt32LE(4);out.selection=mh.readUInt32LE(8);if(out.menuCount>0&&out.menuCount<32){const list=Buffer.from((await req('memory.read',{address:mh.readUInt32LE(0),size:4*(out.menuCount+1),replacements:false})).base64,'base64');out.nodes=[];for(let i=0;i<out.menuCount;i++){const a=list.readUInt32LE(i*4);const n=Buffer.from((await req('memory.read',{address:a,size:228,replacements:false})).base64,'base64');out.nodes.push({address:a,text:n.readUInt32LE(0),direct:n[12],route:n.readUInt32LE(208),enabled:n[204],visible:n[205],base64:n.toString('base64')});}} if(out.updateTarget){out.targetRva='0x'+(out.updateTarget.value-base).toString(16);out.targetCode=await req('memory.read',{address:out.updateTarget.value,size:16,replacements:false});} fs.writeFileSync(path.join(root,'connection/menu-readonly-'+Date.now()+'.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));
}finally{ws.close();}


