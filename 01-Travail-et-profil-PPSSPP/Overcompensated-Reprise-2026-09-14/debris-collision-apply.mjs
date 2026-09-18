import fs from 'node:fs';
import path from 'node:path';
const root=path.dirname(new URL(import.meta.url).pathname).replace(/^\/([A-Za-z]:)/,'$1');
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='wf29-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),status:'preflight',userValidated:['crate respawn delay','teleport animation']},stamp=Date.now();let beforeCPU,written=false;
const mem=async(address,size)=>Buffer.from((await req('memory.read',{address,size,replacements:false})).base64,'base64');
const word=async a=>(await mem(a,4)).readUInt32LE();
const save=()=>fs.writeFileSync(path.join(root,'connection/debris-collision-'+stamp+'.json'),JSON.stringify(out,null,2));
try{
 if((await req('game.status')).game?.id!=='UCES00420'||await word(0x08841120)!==4)throw Error('Wrong game/module');
 beforeCPU=await req('cpu.status');out.cpuBefore=beforeCPU;
 if(!beforeCPU.stepping){ws.send(JSON.stringify({event:'cpu.stepping'}));await new Promise(r=>setTimeout(r,120));}
 if(!(await req('cpu.status')).stepping)throw Error('CPU not suspended');
 const prior=JSON.parse(fs.readFileSync(path.join(root,'connection/resume-crates-result-1789592738689.json'),'utf8'));
 const base=prior.base,plugin=prior.plugin;out.base=base;out.plugin=plugin;
 if(await word(plugin+72576+1132)!==base||await word(plugin+72576+1160)!==1||await word(plugin+65804)!==4)throw Error('Binding changed');
 for(const c of prior.changes.filter(c=>!c.dynamic))if(await word(c.address)!==c.after)throw Error('Previous experiment absent: '+c.label);
 const jump=await word(base+0x27ea0);if(jump>>>26!==2)throw Error('No cave jump');
 const cave=(((base+0x27ea4)&0xf0000000)|((jump&0x03ffffff)<<2))>>>0;
 if(cave<plugin||cave+256>plugin+0x20000)throw Error('Cave outside expected plugin allocation');
 const source=fs.readFileSync(path.join(root,'sources-v0.6.0/sources/profiler/generated/full_patch.generated.c'),'utf8');
 const block=source.split('const uint32_t g_rcsm_cave_templates')[1].split('};')[0];
 const rows=[...block.matchAll(/\{((?:0x[0-9A-Fa-f]+u,?\s*)+)\}/g)];if(rows.length!==8)throw Error('Template parse');
 const expected=[...rows[7][1].matchAll(/0x([0-9A-Fa-f]+)u/g)].map(m=>parseInt(m[1],16));if(expected.length!==64||expected[34]!==0x3c043f80)throw Error('Unexpected template');
 expected[36]=(0x08000000|((base+0x27f0c)>>>2))>>>0;
 const bytes=await mem(cave,256);for(let i=0;i<64;i++)if(bytes.readUInt32LE(i*4)!==expected[i])throw Error('Cave signature mismatch word '+i);
 for(const [rva,w] of [[0x27ea4,0],[0x27f38,0],[0x27f5c,0x46006346],[0x27f68,0x460d7341]])if(await word(base+rva)!==w)throw Error('Collision code mismatch '+rva.toString(16));
 out.cave=cave;out.originalCave=bytes.toString('base64');out.change={address:cave+34*4,before:0x3c043f80,after:0x3c043f00};save();
 written=true;await req('memory.write_u32',{address:out.change.address,value:out.change.after});
 if(await word(out.change.address)!==out.change.after)throw Error('Readback failed');
 out.status='applied_verified';
}catch(e){out.error=String(e);out.status='failed';process.exitCode=1;if(written){await req('memory.write_u32',{address:out.change.address,value:out.change.before});out.rolledBack=await word(out.change.address)===out.change.before;}}
finally{
 if(beforeCPU&&!beforeCPU.stepping){ws.send(JSON.stringify({event:'cpu.resume'}));await new Promise(r=>setTimeout(r,160));out.cpuAfter=await req('cpu.status');}
 if(out.status==='applied_verified'){out.persisted=await word(out.change.address)===out.change.after;out.installed=await word(out.plugin+72576+1160);}
 save();console.log(JSON.stringify({...out,originalCave:undefined},null,2));ws.close();
}
