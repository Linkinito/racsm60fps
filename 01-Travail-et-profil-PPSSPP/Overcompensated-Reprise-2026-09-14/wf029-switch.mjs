import fs from 'node:fs';import path from 'node:path';import {fileURLToPath} from 'node:url';
const root=path.dirname(fileURLToPath(import.meta.url)), mode=process.argv[2]||'apply';
if(!['apply','rollback'].includes(mode))throw Error('Use apply or rollback');
const prior=JSON.parse(fs.readFileSync(path.join(root,'connection/wf029-before.json'))),b=Buffer.from(prior.binding.base64,'base64');
const base=prior.base,binding=base+72576,entry=binding+56+9*8,site=0x0917764c,two=0x0895b754,one=0x0895b770;
const jal=t=>(0x0c000000|((t>>>2)&0x03ffffff))>>>0;
if(b.readUInt32LE(1124)!==binding+56||b.readUInt32LE(4)!==binding+8||b.readUInt32LE(128)!==site+8||b.readUInt16LE(132)!==29||b[134]!==1)throw Error('Saved layout mismatch');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map(),out={time:new Date().toISOString(),mode,site,entry,steps:[]};
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29patch-'+(++seq),t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const read=async(a,n)=>Buffer.from((await req('memory.read',{address:a,size:n,replacements:false})).base64,'base64');
let started=false;
try{
 if((await req('game.status')).game?.id!=='UCES00420')throw Error('Wrong game');
 if(!(await req('cpu.status')).stepping){ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,200));}
 if(!(await req('cpu.status')).stepping)throw Error('CPU not suspended');
 if((await req('memory.read_u32',{address:0x08841120})).value!==4)throw Error('Wrong module');
 if((await req('memory.read_u32',{address:base+65808})).value!==0)throw Error('Hook still active');
 const now=await read(binding,1164);if(now.readUInt32LE(1132)!==0x0914bd00||now.readUInt32LE(1136)!==two||now.readUInt32LE(1140)!==one||now.readUInt32LE(1160)!==1)throw Error('Binding changed');
 if(now.readUInt32LE(1124)!==binding+56||now.readUInt32LE(128)!==site+8||now.readUInt16LE(132)!==29)throw Error('Table changed');
 const expectedPolicy=mode==='apply'?1:2,newPolicy=mode==='apply'?2:1,expectedCode=jal(mode==='apply'?two:one),newCode=jal(mode==='apply'?one:two);
 if(now[134]!==expectedPolicy||(await read(site,4)).readUInt32LE()!==expectedCode)throw Error('Unexpected current values');
 // Both writes happen while CPU is suspended. Keep the active policy table and instruction consistent.
 started=true;out.steps.push(await req('memory.write_u8',{address:entry+6,value:newPolicy}));
 out.steps.push(await req('memory.write_u32',{address:site,value:newCode}));
 if((await read(entry+6,1))[0]!==newPolicy||(await read(site,4)).readUInt32LE()!==newCode)throw Error('Readback failed');
 out.verifiedSuspended=true;fs.writeFileSync(path.join(root,'connection/wf029-'+mode+'-result.json'),JSON.stringify(out,null,2));
 // Resume only emulator execution; do not send any game input or dismiss the game pause menu.
 ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,1200));
 out.cpu=await req('cpu.status');out.policy=(await read(entry+6,1))[0];out.code=(await read(site,4)).readUInt32LE();out.installed=(await req('memory.read_u32',{address:binding+1160})).value;
 if(out.policy!==newPolicy||out.code!==newCode||out.installed!==1)throw Error('Post-resume verification failed');
 out.success=true;
}catch(e){out.error=String(e);out.partialWritePossible=started;process.exitCode=1;ws.send(JSON.stringify({event:'cpu.stepping'}));}
finally{fs.writeFileSync(path.join(root,'connection/wf029-'+mode+'-result.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));ws.close();}
