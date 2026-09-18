import fs from 'node:fs';
const root='C:/Users/linki/Documents/PPSSPP/Overcompensated-Reprise-2026-09-14';
const original=fs.readFileSync(root+'/wf029-inspect.mjs','utf8').split('const out=')[0];
const body=`const out={time:new Date().toISOString()};
try {
 out.game=await req('game.status'); if(out.game.game?.id!=='UCES00420')throw Error('Wrong game');
 out.module=await req('memory.read_u32',{address:0x08841120}); if(out.module.value!==4)throw Error('Wrong module');
 const b=Buffer.from((await req('memory.read',{address:0x08957100+72576,size:1164,replacements:false})).base64,'base64');
 const base=b.readUInt32LE(1132); if(base!==0x0914bd00||b.readUInt16LE(1080)!==4||b.readUInt32LE(1160)!==1)throw Error('Binding changed');
 out.base=base;out.cpu=await req('cpu.status');out.pauseData=await req('memory.read',{address:base+0x183a90,size:128,replacements:false});
 const state=Buffer.from(out.pauseData.base64,'base64').readUInt32LE(12);out.screen=state;
 if(state>=1&&state<=38)out.updateTarget=await req('memory.read_u32',{address:base+0x1d6bf0+4*(state-1)});
 fs.writeFileSync(path.join(root,'connection/menu-readonly-'+Date.now()+'.json'),JSON.stringify(out,null,2));console.log(JSON.stringify(out,null,2));
}finally{ws.close();}`;
fs.writeFileSync(root+'/menu-readonly.mjs',original+body);
