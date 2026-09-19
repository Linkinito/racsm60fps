// Parent-only read-only debugger preflight; never changes emulation or memory.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';
const root=path.dirname(fileURLToPath(import.meta.url));
const port=Number(process.argv[2]);
if(!Number.isInteger(port)||port<1||port>65535) throw Error('Expected local debugger port');
const out={session:new Date().toISOString(),scope:'read-only preflight, not gameplay validation',
  gitHead:execFileSync('git',['rev-parse','HEAD'],{encoding:'utf8'}).trim(),requests:[]};
const ws=new WebSocket(`ws://127.0.0.1:${port}/debugger`,'debugger.ppsspp.org');
let serial=0;const pending=new Map();
ws.addEventListener('message',({data})=>{const r=JSON.parse(data);const p=pending.get(r.ticket);if(p){clearTimeout(p.timer);pending.delete(r.ticket);p.resolve(r);}});
async function req(event,fields={}){
  if(!['version','game.status','cpu.status','hle.module.list','memory.read_u32'].includes(event))throw Error('Read-only');
  const ticket=`pc-preflight-${++serial}`;
  const start=performance.now();
  const response=await new Promise((resolve,reject)=>{const timer=setTimeout(()=>{pending.delete(ticket);reject(Error(`Timeout ${event}`));},5000);pending.set(ticket,{resolve,reject,timer});ws.send(JSON.stringify({event,ticket,...fields}));});
  out.requests.push({event,fields,startMs:start,endMs:performance.now(),response});return response;
}
try{
  await new Promise((resolve,reject)=>{const t=setTimeout(()=>reject(Error('Connection timeout')),5000);ws.addEventListener('open',()=>{clearTimeout(t);resolve();},{once:true});ws.addEventListener('error',()=>{clearTimeout(t);reject(Error('WebSocket error'));},{once:true});});
  await req('version',{name:'Overcompensated PLAYER-CLOCK-001 preflight',version:'0.1'});
  const game=await req('game.status');
  await req('cpu.status');await req('hle.module.list');
  if(game.game?.id==='UCES00420')await req('memory.read_u32',{address:0x08841120});
}catch(e){out.error=String(e);process.exitCode=1;}
finally{for(const p of pending.values())clearTimeout(p.timer);ws.close();const file=path.join(root,`preflight-${Date.now()}.json`);fs.writeFileSync(file,JSON.stringify(out,null,2)+'\n');console.log(JSON.stringify({...out,file},null,2));}
