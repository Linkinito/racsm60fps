"""Bounded read-only static verification for parent arbitration; no runtime."""
from pathlib import Path
import hashlib, json, re, struct

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
sha = lambda b: hashlib.sha256(b).hexdigest()
result = {'scope': 'Selected current files and branch/ELF anchors only; no corpus scan or runtime', 'scriptSha256': sha(Path(__file__).read_bytes())}
result['reports'] = {}
for role in ('explorer', 'mapper', 'skeptic'):
    data = (HERE/'workers'/f'{role}.md').read_bytes()
    handoff = json.loads((HERE/'workers'/f'{role}-handoff.json').read_text(encoding='utf-8-sig'))
    assert handoff['sourceSha256'].lower() == sha(data)
    result['reports'][role] = {'size': len(data), 'sha256': sha(data), 'handoffHashMatches': True}
explorer = (HERE/'workers/explorer.md').read_text(encoding='utf-8-sig')
registry = explorer.split('full registry):**',1)[1].split('```',2)[1]
result['l01RegistryRows'] = len(re.findall(r'\b[A-Za-z_][A-Za-z0-9_]*\s+0x[0-9A-Fa-f]+',registry))
source = ROOT/'02-Jeu-et-dumps/Data/BIN/LEVEL_01.PRX'
data = source.read_bytes()
assert sha(data) == 'd10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571'
h = struct.unpack_from('<16sHHIIIIIHHHHHH',data)
segments = [struct.unpack_from('<IIIIIIII',data,h[5]+i*h[9]) for i in range(h[10])]
def offset(rva, size=4):
    matches = [s for s in segments if s[0]==1 and s[2]<=rva and rva+size<=s[2]+s[4]]
    assert len(matches)==1
    s=matches[0]
    return s[1]+rva-s[2]
word = lambda rva: struct.unpack_from('<I',data,offset(rva))[0]
result['level01'] = {'path':str(source.relative_to(ROOT)), 'sha256':sha(data), 'segments':[{'offset':hex(s[1]),'vaddr':hex(s[2]),'filesz':hex(s[4]),'memsz':hex(s[5])} for s in segments if s[0]==1], 'limiterWords':{hex(rva):hex(word(rva)) for rva in range(0x96620,0x9666c,4)}, 'rateBranch':hex(word(0x14cb18)), 'initPointer':{'rva':'0x2dd1f8','fileOffset':hex(offset(0x2dd1f8)),'word':hex(word(0x2dd1f8))}}
w=word(0x96648)
imm=w&65535
if imm>=32768: imm-=65536
result['level01']['branchDecode']={'opcode':w>>26,'rs':(w>>21)&31,'rt':(w>>16)&31,'target':hex(0x96648+4+imm*4),'meaning':'BNE skips second WAIT on inequality; equality falls through'}
assert w>>26==5 and 0x96648+4+imm*4==0x96658
source2=ROOT/'02-Jeu-et-dumps/Data/BIN/LEVEL_02.PRX'
d2=source2.read_bytes()
h2=struct.unpack_from('<16sHHIIIIIHHHHHH',d2)
segs2=[struct.unpack_from('<IIIIIIII',d2,h2[5]+i*h2[9]) for i in range(h2[10])]
rva=0x34160
s=next(s for s in segs2 if s[0]==1 and s[2]<=rva and rva+4<=s[2]+s[4])
result['level02']={'path':str(source2.relative_to(ROOT)),'sha256':sha(d2),'loopRva':hex(rva),'loopWord':hex(struct.unpack_from('<I',d2,s[1]+rva-s[2])[0])}
assert result['level02']['sha256']=='0037689a926197969231795c4d6b05980e5e94558394617b21e8b8bcd79bc8aa'
assert result['level02']['loopWord']=='0x2a240002'
(HERE/'parent-static-checks.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(result,indent=2))
