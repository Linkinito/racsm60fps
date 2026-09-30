// Atomic Butterfly entry snapshots using the reviewed observer transaction.
// Field/trajectory evidence, not framebuffer or matched-seed gameplay parity.
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import {fileURLToPath} from 'node:url';
import {PpssppClient} from './lib/ppsspp-client.mjs';
import {inspectIdentity, readWord} from './lib/state.mjs';
import {autoBindProfile} from './lib/binding.mjs';

const args=process.argv.slice(2);
const option=(key,fallback)=>args.includes(key)?args[args.indexOf(key)+1]:fallback;
const output=path.resolve(option('--out',''));
const expected=option('--state','A0');
const stops=Number(option('--stops','132'));
const delay=Number(option('--delay-ms','25'));
const site=option('--site','entry');
if(!['entry','flap'].includes(site)) throw new Error('invalid snapshot site');
const breakpointRva=site==='entry'?0x122820:0x122C8C;
const objectRegister=site==='entry'?'a0':'s0';
if(!args.includes('--out') || fs.existsSync(output)) throw new Error('new output required');
if(!['A0','C1'].includes(expected) || !Number.isInteger(stops) || stops<2 || stops>512 || delay<0 || delay>1000) throw new Error('invalid bounds');
const client=new PpssppClient({port:Number(option('--port','60907')),timeoutMs:3000,clientName:'butterfly-channels'});
const rawRequest=client.request.bind(client);
const digest=(data)=>crypto.createHash('sha256').update(data).digest('hex');
const report={utc:new Date().toISOString(),methodSha256:digest(fs.readFileSync(fileURLToPath(import.meta.url))),
  result:'FAILED',expectedState:expected,snapshotSite:site,breakpointRva,limitations:['Unmatched random trajectories across arms','Atomic stopped snapshots; no render capture','No whole-game parity inference'],samples:[],bindEvents:[]};
let armedSnapshot=false;
const pointer=(value,size)=>Number.isInteger(value) && value>=0x08800000 && value+size<=0x0A000000 && (value&3)===0;
const memory=async(address,size)=>{
  const reply=await rawRequest('memory.read',{address,size,replacements:false});
  const bytes=Buffer.from(reply.base64??'','base64');
  if(bytes.length!==size) throw new Error('short memory read');
  return bytes;
};
client.request=async(event,fields={})=>{
  const reply=await rawRequest(event,fields);
  if(event==='cpu.getAllRegs' && armedSnapshot) {
    armedSnapshot=false;
    const gpr=(reply.categories??[]).find(item=>item.name==='GPR');
    if(!gpr) throw new Error('missing GPRs');
    const index=gpr.registerNames.findIndex(name=>String(name).replace(/^\$/,'').toLowerCase()===objectRegister);
    const object=gpr.uintValues[index]>>>0;
    if(!pointer(object,128)) throw new Error('invalid Butterfly object');
    const objectBytes=await memory(object,128);
    const pvar=objectBytes.readUInt32LE(0x54);
    if(!pointer(pvar,112)) throw new Error('invalid Butterfly pvar');
    const pvarBytes=await memory(pvar,112);
    const cpu=await rawRequest('cpu.status');
    if(!cpu.stepping || cpu.pc!==report.identityBefore.module.address+breakpointRva) throw new Error('snapshot lost true stop');
    report.samples.push({object,pvar,ticks:cpu.ticks,pc:cpu.pc,objectBase64:objectBytes.toString('base64'),pvarBase64:pvarBytes.toString('base64')});
  }
  return reply;
};
try {
  await client.connect();
  report.identityBefore=await inspectIdentity(client);
  const identity=report.identityBefore;
  if(!identity.identityValid || identity.state!==expected || identity.module.size!==0x46B900) throw new Error('wrong identity');
  const base=identity.module.address;
  const guards={0x122820:0x27BDFF00,0x122830:0x8E110054,0x122C8C:0xC60C0070,0x122C90:0xC62D005C};
  report.context={};
  for(const [rva,word] of Object.entries(guards)) {
    const actual=await readWord(client,base+Number(rva));report.context[rva]=actual;
    if(actual!==word) throw new Error('Butterfly context mismatch');
  }
  report.flapWord=await readWord(client,base+0x122C98);
  report.configWords={};
  for(const rva of [0x2CED8C,0x2CEDBC])report.configWords[rva]=await readWord(client,base+rva);
  const profile={name:'butterfly-'+site,binding:{breakpointRva,registers:{object:objectRegister}}};
  for(let i=0;i<stops;i++) {
    if(i%8===0) {
      const now=await inspectIdentity(client);
      if(!now.identityValid || now.state!==expected || now.module.address!==base || now.module.size!==identity.module.size) throw new Error('identity changed');
    }
    armedSnapshot=true;
    const binding=await autoBindProfile({client,identity,profile,hitTimeoutMs:5000,
      onEvent:(event,payload)=>report.bindEvents.push({sample:i,event,payload})});
    if(report.samples.length!==i+1 || !binding.cleanup.breakpointRemoved || !binding.cleanup.cpuResumed) throw new Error('capture/cleanup incomplete');
    if(delay) await new Promise(resolve=>setTimeout(resolve,delay));
  }
  report.identityAfter=await inspectIdentity(client);
  if(report.identityAfter.state!==expected || report.identityAfter.module.address!==base) throw new Error('final identity changed');
  report.flapWordAfter=await readWord(client,base+0x122C98);
  if(report.flapWordAfter!==report.flapWord) throw new Error('flap hook changed');
  report.contextAfter={};report.configWordsAfter={};
  for(const [rva,word] of Object.entries(guards)) {
    report.contextAfter[rva]=await readWord(client,base+Number(rva));
    if(report.contextAfter[rva]!==word) throw new Error('final context changed');
  }
  for(const rva of [0x2CED8C,0x2CEDBC]) {
    report.configWordsAfter[rva]=await readWord(client,base+rva);
    if(report.configWordsAfter[rva]!==report.configWords[rva]) throw new Error('steering config changed');
  }
  report.result='PASS';
} catch(error) {
  report.error={message:error.message,cleanup:error.cleanup??null};process.exitCode=1;
} finally {
  if(client.connected) {
    try {report.finalCpu=await rawRequest('cpu.status');report.finalBreakpoints=await rawRequest('cpu.breakpoint.list');}
    catch(error) {report.finalCheckError=error.message;}
    client.close();
  }
  fs.mkdirSync(path.dirname(output),{recursive:true});fs.writeFileSync(output,JSON.stringify(report,null,1));
  console.log(JSON.stringify({result:report.result,samples:report.samples.length,objects:new Set(report.samples.map(s=>s.object)).size,error:report.error??null}));
}
