import fs from 'node:fs';
const [port, requestFile, outputFile] = process.argv.slice(2);
const requests=JSON.parse(fs.readFileSync(requestFile,'utf8').replace(/^\uFEFF/,''));
const ws=new WebSocket(`ws://127.0.0.1:${Number(port)}/debugger`,'debugger.ppsspp.org');
let seq=0;const pending=new Map();
ws.onmessage=({data})=>{const m=JSON.parse(data),p=pending.get(m.ticket);if(p){clearTimeout(p.t);pending.delete(m.ticket);p.resolve(m);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const req=(event,fields={})=>new Promise((resolve,reject)=>{const ticket='audit-'+(++seq);const t=setTimeout(()=>{pending.delete(ticket);reject(Error(event+' timeout'));},15000);pending.set(ticket,{resolve,reject,t});ws.send(JSON.stringify({event,ticket,...fields}));});
const out={time:new Date().toISOString(),responses:[]};
try{
 for(const r of requests){
  const {event,saveBase64,_delayMs,_noReply,...fields}=r; if(_noReply){ws.send(JSON.stringify({event,...fields}));if(_delayMs)await new Promise(r=>setTimeout(r,_delayMs));continue;} if(_delayMs)await new Promise(r=>setTimeout(r,_delayMs));
  const result=await req(event,fields);
  if(saveBase64){let b64=result.base64;if(!b64&&result.uri)b64=result.uri.split(',')[1];if(b64){fs.writeFileSync(saveBase64,Buffer.from(b64,'base64'));delete result.base64;delete result.uri;result.savedTo=saveBase64;}}
  out.responses.push({request:r,result});
 }
}catch(e){out.error=String(e);process.exitCode=1;}finally{for(const p of pending.values())clearTimeout(p.t);ws.close();fs.writeFileSync(outputFile,JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));}
