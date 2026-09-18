import fs from 'node:fs';
import path from 'node:path';
const root='C:/Users/linki/Documents/PPSSPP/Overcompensated-Reprise-2026-09-14';
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),scope:'request/cancel only, no frequency or actor changes'};
const meta=JSON.parse(fs.readFileSync(root+'/development-v0.6.1/runtime-symbols.json','utf8'));
const pb=144011520,base=152358144;let touched=false;
const word=async a=>Buffer.from((await req('memory.read',{address:a,size:4,replacements:false})).base64,'base64').readUInt32LE();
const state=async()=>({requested:await word(pb+meta.symbols.g_rcsm_requested_fps),applied:await word(pb+meta.symbols.g_rcsm_applied_fps),pending:await word(pb+meta.symbols.g_rcsm_fps_pending)});
try {
 const b=Buffer.from((await req('memory.read',{address:pb+meta.symbols.g_binding,size:1164,replacements:false})).base64,'base64');
 if(b.readUInt32LE(1132)!==base||b.readUInt16LE(1080)!==4||b.readUInt32LE(1160)!==1)throw Error('Binding changed');
 out.before=await state(); if(JSON.stringify(out.before)!==JSON.stringify({requested:60,applied:60,pending:0}))throw Error('Unexpected FPS state');
 touched=true;await req('memory.write_u32',{address:pb+meta.symbols.g_rcsm_requested_fps,value:30});
 await new Promise(r=>setTimeout(r,700));out.queued=await state();
 if(out.queued.requested!==30||out.queued.applied!==60||out.queued.pending!==1)throw Error('Deferred choice failed');
} catch(e){out.error=String(e);process.exitCode=1;} finally {
 if(touched){await req('memory.write_u32',{address:pb+meta.symbols.g_rcsm_requested_fps,value:60});await new Promise(r=>setTimeout(r,700));out.restored=await state();}
 out.pass=!out.error&&out.restored?.requested===60&&out.restored?.applied===60&&out.restored?.pending===0;
 fs.writeFileSync(root+'/connection/dev061-fps-mailbox-'+Date.now()+'.json',JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));ws.close();
}
