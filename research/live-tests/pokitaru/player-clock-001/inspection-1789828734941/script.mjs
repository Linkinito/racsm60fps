// Parent-only read-only inspection. Candidate module identity is not assumed.
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import {fileURLToPath} from 'node:url';
import {execFileSync} from 'node:child_process';
const self=fileURLToPath(import.meta.url);
const port=Number(process.argv[2]);
if(!Number.isInteger(port)||port<1||port>65535) throw Error('Expected debugger port');
const sha=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const dirty=execFileSync('git',['ls-files','--modified','--others','--exclude-standard'],{encoding:'utf8'}).trim().split(/\r?\n/).filter(Boolean);
const out={utc:new Date().toISOString(),gitHead:execFileSync('git',['rev-parse','HEAD'],{encoding:'utf8'}).trim(),scriptSha256:sha(self),dirtyFiles:dirty.map(p=>({path:p,sha256:fs.existsSync(p)?sha(p):null})),
  scope:'Read-only code inspection, not A0 validation or cadence measurement',
  userReportedProvenance:'Normal boot from a save, currently Pokitaru, vanilla (2026-09-19 owner reply); not independently verified.',requests:[]};
const ws=new WebSocket(`ws://127.0.0.1:${port}/debugger`,'debugger.ppsspp.org');
let serial=0; const pending=new Map();
ws.addEventListener('message',({data})=>{const r=JSON.parse(data);const p=pending.get(r.ticket);if(p){clearTimeout(p.timer);pending.delete(r.ticket);p.resolve(r);}});
async function req(event,fields={}){
  if(!['version','game.status','cpu.status','hle.module.list','memory.read_u32','memory.disasm'].includes(event))throw Error('Read-only allowlist');
  const ticket=`pc-code-${++serial}`,startMs=performance.now();
  const response=await new Promise((resolve,reject)=>{const timer=setTimeout(()=>{pending.delete(ticket);reject(Error(`Timeout ${event}`));},5000);pending.set(ticket,{resolve,reject,timer});ws.send(JSON.stringify({event,ticket,...fields}));});
  out.requests.push({event,fields,startMs,endMs:performance.now(),response});
  if(response.event==='error')throw Error(JSON.stringify(response));
  return response;
}
try{
  await new Promise((resolve,reject)=>{const t=setTimeout(()=>reject(Error('Connection timeout')),5000);ws.addEventListener('open',()=>{clearTimeout(t);resolve();},{once:true});ws.addEventListener('error',()=>{clearTimeout(t);reject(Error('WebSocket error'));},{once:true});});
  await req('version',{name:'PLAYER-CLOCK-001 read-only code inspection',version:'0.1'});
  const game=await req('game.status');
  if(game.game?.id!=='UCES00420')throw Error('Unexpected game');
  await req('cpu.status');
  const modules=await req('hle.module.list');
  const candidates=modules.modules.filter(m=>m.name==='rcp1'&&m.isActive);
  if(candidates.length!==1)throw Error('Ambiguous candidate module');
  const module=candidates[0]; out.candidateModule=module;
  out.words=[];
  for(const rva of [0x151E0,0x2FCFC,0x2FBBC,0x96650,0x30014,0x30018]){
    if(rva+4>module.size)throw Error('Read outside reported module');
    const r=await req('memory.read_u32',{address:module.address+rva,replacements:false});
    if(!Number.isInteger(r.value))throw Error('Missing word');
    const disasm=await req('memory.disasm',{address:module.address+rva,count:1,replacements:false});
    const address=module.address+rva;
    const line=disasm.lines?.find(l=>l.address<=address&&address<l.address+l.addressSize);
    const encoding=line?.type==='macro'?line.macroEncoding?.[(address-line.address)/4]:line?.encoding;
    if(!Number.isInteger(encoding))throw Error('Missing decoded instruction');
    out.words.push({rva:`0x${rva.toString(16)}`,address:`0x${address.toString(16)}`,memoryWord:`0x${r.value.toString(16).padStart(8,'0')}`,decodedWord:`0x${(encoding>>>0).toString(16).padStart(8,'0')}`});
  }
  await req('cpu.status'); await req('hle.module.list');
  out.restoration='No input, state load, pause/resume, breakpoint or memory-write requests issued.';
  out.limits='Unsynchronized reads may briefly suspend CPU internally. memory.disasm with replacements:false exposes decoded instructions separately from memory.read_u32, which can expose emulator-internal words. Selected words do not establish full module/ISO identity, vanilla routes, active config/plugins, or save lineage.';
}catch(e){out.error=String(e);process.exitCode=1;}
finally{
  for(const p of pending.values())clearTimeout(p.timer);
  ws.close();
  const dir=path.join(path.dirname(self),`inspection-${Date.now()}`);fs.mkdirSync(dir);
  fs.copyFileSync(self,path.join(dir,'script.mjs'));
  fs.writeFileSync(path.join(dir,'record.json'),JSON.stringify(out,null,2)+'\n');
  console.log(JSON.stringify({directory:dir,error:out.error,words:out.words,restoration:out.restoration},null,2));
}
