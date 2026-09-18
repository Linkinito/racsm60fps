import fs from 'node:fs';
const d='C:/Users/linki/Documents/PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.2-menu';
const meta=JSON.parse(fs.readFileSync(d+'/runtime-dev1/runtime-symbols.json','utf8'));
const ws=new WebSocket('ws://127.0.0.1:60907/debugger','debugger.ppsspp.org');let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);m.event==='error'?p.reject(Error(m.message)):p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='menu-'+(++seq);const t=setTimeout(()=>reject(Error(event+' timeout')),5000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const read=async(a,n)=>Buffer.from((await req('memory.read',{address:a,size:n,replacements:false})).base64,'base64');
try{
 const out={time:new Date().toISOString(),game:await req('game.status'),cpu:await req('cpu.status')};if(out.game.game?.id!=='UCES00420')throw Error('Wrong game');
 const ram=await read(0x08800000,0x800000);let found=[];
 // A candidate must reference a valid FRONTEND base and redirect its verified input call to this plugin's own hook.
 for(let pb=0x08800000;pb<0x09000000;pb+=0x100){
  const a=pb+meta.symbols.g_menus-0x08800000;if(a<0||a+24>ram.length)continue;
  const base=ram.readUInt32LE(a+4),menu=ram.readUInt32LE(a+8),p=ram.readUInt32LE(a);
  if(base<0x08800000||base+0x1961c>=0x09000000||p<pb||p>pb+0x40000||menu<base||menu>base+0x300000)continue;
  const w=ram.readUInt32LE(base+0x19618-0x08800000),expected=(0x0c000000|((pb+meta.symbols.rcsm_menu_hook_0)>>>2))>>>0;
  if(w===expected)found.push({pb,base,menu});
 }
 if(found.length!==1)throw Error('Ambiguous binding: '+JSON.stringify(found));Object.assign(out,found[0]);
 for(const name of ['g_rcsm_requested_fps','g_rcsm_applied_fps','g_rcsm_fps_pending','g_rcsm_fps_saved','g_rcsm_menu_installed','g_rcsm_menu_open','g_rcsm_menu_last_context'])out[name]=(await read(out.pb+meta.symbols[name],4)).readUInt32LE();
 const h=await read(out.menu,0xa4);out.header=h.toString('base64');out.count=h.readUInt32LE(4);out.selection=h.readUInt32LE(8);out.nodes=[];
 if(out.count>24)throw Error('Invalid count');const list=await read(h.readUInt32LE(0),out.count*4);
 for(let i=0;i<out.count;i++){const a=list.readUInt32LE(i*4),n=await read(a,228);let txt=n[12]?(await read(n.readUInt32LE(0),64)).toString('utf8').split('\0')[0]:n.readUInt32LE(0);out.nodes.push({address:a,text:txt,route:n.readUInt32LE(208),rectangle:n.readUInt32LE(8),enabled:n[204]});}
 fs.writeFileSync(d+'/analysis/live-frontend-dev1.json',JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));
}finally{ws.close();}
