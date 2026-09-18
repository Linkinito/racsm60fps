from pathlib import Path
import struct,hashlib,json
out=Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14\research-2026-09-16\saves')
plain=Path(r'C:\Users\linki\Downloads\SECURE_CURRENT_DECRYPTED.bin').read_bytes()
ram=Path(r'C:\Users\linki\Downloads\Ratchet & Clank - Size Matters (Europe) (PSN)\RAM.dump').read_bytes()
candidates=[]
pos=0
while True:
 pos=ram.find(b'RE00',pos)
 if pos<0:break
 base=pos-0x1c40
 if base>=0 and base+0x56f20<=len(ram) and all(ram[base+0x1c40+n*0x4000:base+0x1c44+n*0x4000]==b'RE00' for n in range(14)):
  b=ram[base:base+0x56f20];candidates.append({'ram_offset':hex(base),'sha256':hashlib.sha256(b).hexdigest(),'bolts':struct.unpack_from('<I',b,0x1c28)[0]});(out/f'ram-save-{base:x}.bin').write_bytes(b)
 pos+=4
old=ram[int(candidates[0]['ram_offset'],16):int(candidates[0]['ram_offset'],16)+0x56f20]
report={'plaintext_sha256':hashlib.sha256(plain).hexdigest(),'size':len(plain),'bolts':struct.unpack_from('<I',plain,0x1c28)[0],'skill_bytes':plain[0x8f7:0x8fd].hex(),'ram_candidates':candidates,'slots':[],'zero_candidate_current':not any(plain[0x3e4ec:0x536e0]),'zero_candidate_old':not any(old[0x3e4ec:0x536e0])}
for n in range(14):
 a=0x1c40+n*0x4000;b=plain[a:a+0x4000];o=old[a:a+0x4000];report['slots'].append({'slot':n,'offset':hex(a),'fields':struct.unpack_from('<II',b,4),'nonzero':sum(x!=0 for x in b),'changed_bytes':sum(x!=y for x,y in zip(b,o)),'last_nonzero':hex(max(i for i,x in enumerate(b) if x))})
report['disk_saves']=[]
for f in Path(r'C:\Users\linki\Documents\PPSSPP\PSP\SAVEDATA').glob('UCES00420*/SECURE.BIN'):
 b=f.read_bytes();report['disk_saves'].append({'path':str(f),'size':len(b),'sha256':hashlib.sha256(b).hexdigest()})
(out/'verified-format.json').write_text(json.dumps(report,indent=2),encoding='utf-8');print(json.dumps(report,indent=2))
