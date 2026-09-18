from elf_menu import *
e=Elf(BIN/'straddle.junk')
for s in e.syms:
 if s['value']==0x15c34 or 'Cycle' in s['name'] or 'PAUSE' in s['name'] and 'Main' in s['name']:
  print(s)
  if s['info']&15==2:(OUT/(re.sub('[^A-Za-z0-9_-]','_',s['name'])+'.asm')).write_text(e.dis(s['value'],s['size']))
def norm(w):
 op=w>>26
 if op in (2,3):return w&0xfc000000
 if op not in (0,17,18,28,31):return w&0xffff0000
 return w
wanted=[s for s in e.syms if ('PAUSEMENU_' in s['name'] or 'PAUSEMODE_Updatev' in s['name'] or s['value']==0x15c34 or 'LEVELSTARTUP_Updatev' in s['name']) and s['info']&15==2 and s['size']>=32]
res=[]
for name in ['LEVEL_04.PRX','FRONTEND.PRX']:
 p=Elf(BIN/name);seg=next(s for s in p.ph if s[0]==1);ws=list(struct.unpack('<'+'I'*(seg[4]//4),p.b[seg[1]:seg[1]+seg[4]//4*4]));nw=[norm(w) for w in ws];index={}
 for i,w in enumerate(nw):index.setdefault(w,[]).append(i)
 for s in wanted:
  src=e.read(s['value'],s['size']);pat=[norm(w) for w in struct.unpack('<'+'I'*(len(src)//4),src)];n=min(len(pat),64);hits=[i for i in index.get(pat[0],[]) if nw[i:i+n]==pat[:n]]
  row=dict(module=name,symbol=s['name'],symbol_address=hex(s['value']),size=s['size'],prefix_words=n,matches=[hex(seg[2]+i*4) for i in hits]);res.append(row)
  if len(hits)==1:
   a=seg[2]+hits[0]*4;(OUT/(name+'_'+re.sub('[^A-Za-z0-9_-]','_',s['name'])+'.asm')).write_text(p.dis(a,s['size']))
(OUT/'signature-matches.json').write_text(json.dumps(res,indent=2));print(json.dumps(res,indent=2))


