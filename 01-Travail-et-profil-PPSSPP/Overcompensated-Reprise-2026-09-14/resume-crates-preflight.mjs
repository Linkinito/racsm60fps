import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),changes:[]};
const json=p=>JSON.parse(fs.readFileSync(path.join(root,p),'utf8').replace(/^\uFEFF/,''));
const mem=async(address,size)=>Buffer.from((await req('memory.read',{address,size,replacements:false})).base64,'base64');
const word=async a=>(await mem(a,4)).readUInt32LE();
try{
 if((await req('game.status')).game?.id!=='UCES00420'||await word(0x08841120)!==4)throw Error('Wrong game/module');
 out.cpuBefore=await req('cpu.status');if(!out.cpuBefore.stepping){ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,150));}
 if(!(await req('cpu.status')).stepping)throw Error('Not suspended');
 // Log gives candidate addresses only; binding and code independently validate them.
 const log=fs.readFileSync('C:/Users/linki/Documents/PPSSPP/PSP/PLUGINS/SizeMattersWrapperProfiler/status.log','utf8');
 const matches=[...log.matchAll(/module armed key=LEVEL_04 .*two_hook=(0x[0-9A-F]+).*base=(0x[0-9A-F]+)/g)];if(!matches.length)throw Error('No module log');
 const last=matches.at(-1),base=parseInt(last[2]),plugin=parseInt(last[1])-18004;out.base=base;out.plugin=plugin;
 const bind=await mem(plugin+72576,1164); console.log(JSON.stringify({tail:[...Array(21)].map((_,i)=>[1080+i*4,bind.readUInt32LE(1080+i*4)]),index:await word(plugin+65804),count:await word(plugin+65808)}));
 if(bind.readUInt32LE(1132)!==base||bind.readUInt32LE(1136)!==plugin+18004||bind.readUInt32LE(1160)!==1||await word(plugin+65804)!==4||bind.readUInt16LE(1082)!==36)throw Error('Binding mismatch');
 if(await word(base+0x2b94c)!==((0x0c000000|((plugin+18004)>>>2))>>>0))throw Error('WF029 route mismatch');
 if(await word(base+0x3430)!==0x3c043c88)throw Error('Global timing patch missing');
 const add=(c)=>out.changes.push({...c,address:base+c.rva});
 for(const c of json('research-2026-09-16/metalis/prior-arena-static-rvas.json').changes)add({...c,group:'prior-arena'});
 for(const c of json('connection/clanksaw-movement-plan.json').changes.filter(c=>!c.label.startsWith('current')))add({...c,rva:c.address-0x0914bd00,group:'prior-player'});
 const rot=json('connection/clanksaw-rotation-plan.json');add({rva:rot.address-0x0914bd00,before:rot.originalWord,after:rot.newWord,label:'Clank turn',group:'prior-player'});
 for(const c of json('research-2026-09-16/metalis/crate-candidates.json').changes)add({...c,group:'new-crates'});
 for(const c of out.changes){c.current=await word(c.address);if(c.current!==c.before&&c.current!==c.after)throw Error('Unexpected '+c.label+' at '+c.address.toString(16)+' value '+c.current.toString(16));c.needsWrite=c.current===c.before;}
 if(new Set(out.changes.map(c=>c.address)).size!==out.changes.length)throw Error('Duplicate address');
 const start=0x09400000,end=0x0a000000,data=await mem(start,end-start),classes=json('connection/metalis-classes.json'),lookup=new Map(),descs=new Map(),controllers=[];
 for(const c of classes){const cb=c.callback_rvas.split(';').map(v=>parseInt(v.trim(),16)+base);if(cb.length>=3)lookup.set(cb[2],{name:c.object_name,cb});}
 for(let i=28;i<data.length-8;i+=4){const item=lookup.get(data.readUInt32LE(i));if(!item||data.readUInt32LE(i-8)!==item.cb[0]||data.readUInt32LE(i-4)!==item.cb[1])continue;const descriptor=start+i-28;descs.set(descriptor,item.name);const object=data.readUInt32LE(i-16);if(item.name==='VehicleController'&&object>=start&&object+128<end&&data.readUInt32LE(object-start+0x40)===descriptor)controllers.push({object,descriptor,pvars:data.readUInt32LE(object-start+0x58)});}
 out.controllers=[];
 for(const c of controllers){if(c.pvars<start||c.pvars+128>=end)continue;const p=c.pvars-start,count=data[p+0x44],enabled=data[p+0x46];if(count<1||count>8||!enabled)continue;const vehicles=[];for(let i=0;i<count;i++){const object=data.readUInt32LE(p+i*8);if(object<start||object+128>=end)throw Error('Actor pointer');const descriptor=data.readUInt32LE(object-start+0x40),pvars=data.readUInt32LE(object-start+0x58);vehicles.push({object,descriptor,pvars,name:descs.get(descriptor)});}out.controllers.push({...c,count,enabled,vehicles});}
 out.status='preflight_ok_CPU_suspended';
}catch(e){out.error=String(e);out.status='preflight_failed_CPU_state_check_required';process.exitCode=1;}
finally{const dest=path.join(root,'connection/resume-crates-preflight-'+Date.now()+'.json');fs.writeFileSync(dest,JSON.stringify(out,null,2));console.log(JSON.stringify({file:dest,status:out.status,error:out.error,base:out.base,plugin:out.plugin,sites:out.changes.length,pending:out.changes.filter(c=>c.needsWrite).length,controllers:out.controllers},null,2));ws.close();}


