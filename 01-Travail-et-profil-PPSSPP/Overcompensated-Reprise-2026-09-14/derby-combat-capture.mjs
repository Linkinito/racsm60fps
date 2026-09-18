import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const rootBase=0x0914bd00,points=[0x2ab54,0x1a30b4,0x1a259c],armed=[],out={time:new Date().toISOString(),captures:[]};
const delay=ms=>new Promise(r=>setTimeout(r,ms));
try{
 if((await req('game.status')).game?.id!=='UCES00420'||(await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong game/module');
 if((await req('cpu.breakpoint.list')).breakpoints.length)throw Error('Existing breakpoints');
 const cpu=await req('cpu.status');if(cpu.stepping)throw Error('Expected internal pause with running CPU');
 for(const rva of points){const address=rootBase+rva;const word=Buffer.from((await req('memory.read',{address,size:4,replacements:false})).base64,'base64').readUInt32LE();if(word!==0x27bdffb0)throw Error('Unexpected entry');await req('cpu.breakpoint.add',{address,enabled:true,log:false});armed.push(address);}
 await req('input.buttons.send',{buttons:{start:true}});
 for(let n=0;n<24;n++){
 let cpu;const deadline=Date.now()+2000;do{await delay(10);cpu=await req('cpu.status');}while(!cpu.stepping&&Date.now()<deadline);
 if(!cpu.stepping||!armed.includes(cpu.pc))throw Error('No expected breakpoint');
 await req('input.buttons.send',{buttons:{start:false}});
 const regs=await req('cpu.getAllRegs'),g=regs.categories.find(c=>c.id===0),reg=n=>g.uintValues[g.registerNames.findIndex(s=>s.replace('$','')===n)];
 const args=Object.fromEntries(['a0','a1','a2','a3','ra'].map(n=>[n,reg(n)]));const cap={pc:cpu.pc,ticks:cpu.ticks,args};
 for(const [name,a,size] of [['a0',args.a0,160],['a1',args.a1,128],['a2',args.a2,128]])if(a>=0x08800000&&a+size<=0x0a000000)cap[name]=await req('memory.read',{address:a,size,replacements:false});
 out.captures.push(cap);if(n<23)ws.send(JSON.stringify({event:'cpu.resume'}));
 }
 out.success=true;
}catch(e){out.error=String(e);process.exitCode=1;ws.send(JSON.stringify({event:'cpu.stepping'}));await delay(100);}
finally{await req('input.buttons.send',{buttons:{start:false}});for(const address of armed)await req('cpu.breakpoint.remove',{address});out.cpu=await req('cpu.status');fs.writeFileSync(path.join(root,'connection/derby-combat-capture.json'),JSON.stringify(out,null,2));console.log(JSON.stringify({success:out.success,error:out.error,count:out.captures.length,sites:[...new Set(out.captures.map(c=>'0x'+(c.pc-rootBase).toString(16)))],cpu:out.cpu},null,2));ws.close();}
