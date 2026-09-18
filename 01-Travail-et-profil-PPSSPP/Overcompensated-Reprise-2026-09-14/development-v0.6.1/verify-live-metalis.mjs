import fs from 'node:fs';
import path from 'node:path';
const root='C:/Users/linki/Documents/PPSSPP/Overcompensated-Reprise-2026-09-14';
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),scope:'read-only integration check; not gameplay validation'};
try {
 const meta=JSON.parse(fs.readFileSync(root+'/development-v0.6.1/runtime-symbols.json','utf8'));
 const log=fs.readFileSync('C:/Users/linki/Documents/PPSSPP/PSP/PLUGINS/SizeMattersWrapperProfiler/status.log','utf8');
 const starts=[...log.matchAll(/start version=([^ ]+)/g)];if(starts.at(-1)?.[1]!==meta.version)throw Error('New plugin not running: restart PPSSPP and load Metalis from the game save');
 const tail=log.slice(starts.at(-1).index); const arm=[...tail.matchAll(/module armed key=LEVEL_04[^\n]+/g)].at(-1)?.[0];if(!arm)throw Error('No Metalis activation found in current plugin session');
 const base=parseInt(/ base=0x([0-9A-F]+)/.exec(arm)[1],16), two=parseInt(/two_hook=0x([0-9A-F]+)/.exec(arm)[1],16), one=parseInt(/one_hook=0x([0-9A-F]+)/.exec(arm)[1],16);
 const pb=two-meta.symbols.rcsm_profiler_hook_l04;
 if(pb+meta.symbols.rcsm_profiler_hook_l04_one!==one)throw Error('Inconsistent plugin base');
 out.game=await req('game.status');if(out.game.game?.id!=='UCES00420')throw Error('Wrong game');
 if((await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong module');
 out.base=base;out.pluginBase=pb;
 const read=async(address,size)=>Buffer.from((await req('memory.read',{address,size,replacements:false})).base64,'base64');
 const binding=await read(pb+meta.symbols.g_binding,1164);
 if(binding.readUInt32LE(1132)!==base||binding.readUInt16LE(1080)!==4||binding.readUInt32LE(1160)!==1)throw Error('Active binding mismatch');
 const mem=await read(base,0x310000);const delta=base-0x09139d00;
 const jump=(w)=>((w&0xfc000000)|(((((w&0x03ffffff)*4)+delta)>>>2)&0x03ffffff))>>>0;
 out.sites=meta.metalis.map(e=>{let expected=e.patched;if(e.flags&8)expected=jump(expected);if(e.flags&4)expected=(0x08000000|((pb+meta.symbols.g_full_caves+256*e.patched)>>>2))>>>0; const observed=mem.readUInt32LE(e.offset);return {rva:e.offset,expected,observed,pass:expected===observed,continuous:!!(e.flags&1)};});
 const count=binding.readUInt16LE(1082);out.callsites=[];
 for(let i=0;i<count;i++){const off=56+8*i,ra=binding.readUInt32LE(off),policy=binding[off+6],expected=(0x0c000000|((policy===2?one:two)>>>2))>>>0,observed=mem.readUInt32LE(ra-8-base);out.callsites.push({ra,policy,expected,observed,pass:observed===expected});}
 out.cave7Word34=(await read(pb+meta.symbols.g_full_caves+7*256+34*4,4)).readUInt32LE();
 for(const name of ['g_rcsm_requested_fps','g_rcsm_applied_fps','g_rcsm_fps_pending'])out[name]=(await read(pb+meta.symbols[name],4)).readUInt32LE();
 out.pass=out.sites.every(e=>e.pass)&&out.callsites.length===36&&out.callsites.every(e=>e.pass)&&out.cave7Word34===0x3c043f00&&out.g_rcsm_applied_fps===60;
 console.log(JSON.stringify({pass:out.pass,sites:out.sites.filter(e=>e.pass).length,totalSites:out.sites.length,callsites:out.callsites.filter(e=>e.pass).length,applied:out.g_rcsm_applied_fps,base,pluginBase:pb},null,2));
 if(!out.pass)process.exitCode=1;
}catch(e){out.error=String(e);console.error(String(e));process.exitCode=1;}finally{fs.writeFileSync(root+'/connection/dev061-integration-'+Date.now()+'.json',JSON.stringify(out,null,2));ws.close();}
