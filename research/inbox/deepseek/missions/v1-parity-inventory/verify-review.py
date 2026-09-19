"""Read-only V1 checks; write derived review evidence next to this script."""
import csv
import hashlib
import json
from pathlib import Path
import struct
import sys
import zipfile

ROOT = Path(__file__).resolve().parents[5]
L = ROOT / '01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14'
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(L / 'analysis-deps'))
from capstone import Cs, CS_ARCH_MIPS, CS_MODE_MIPS32, CS_MODE_LITTLE_ENDIAN

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def rows(p):
    with p.open(encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))

prx = L / 'development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX'
b = prx.read_bytes()
h = struct.unpack_from('<16sHHIIIIIHHHHHH', b)
segments = [struct.unpack_from('<IIIIIIII', b, h[5] + i*h[9]) for i in range(h[10])]
md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS32 | CS_MODE_LITTLE_ENDIAN)
def offset(rva):
    s = next(s for s in segments if s[0] == 1 and s[2] <= rva < s[2]+s[4])
    return s[1] + rva-s[2]

def decode(word, rva):
    return [(i.mnemonic + ' ' + i.op_str).strip() for i in md.disasm(struct.pack('<I',word),rva)]

core = [('vblank',0x96650,0x0C06FD09,0),('delta',0x151E0,0x3C043D08,0x3C043C88),
        ('substeps',0x2FCFC,0x2A240002,0x2A240001),('physics',0x2FBBC,0x46006506,0x460C6500)]
report = {'scope':'Static file and recorded evidence checks, not gameplay validation',
          'prx_path':str(prx.relative_to(ROOT)), 'prx_sha256':sha(prx), 'segments':segments,
          'core':[], 'artifact_hashes':{}}
for name,rva,old,new in core:
    actual = struct.unpack_from('<I',b,offset(rva))[0]
    report['core'].append(dict(name=name,rva=hex(rva),file_offset=hex(offset(rva)),
        expected=hex(old),actual=hex(actual),matches=actual==old,patch=hex(new),
        original_decode=decode(old,rva),patched_decode=decode(new,rva)))
report['titanium_factor_decode'] = [decode(w,0x17B78C) for w in (0x3C044000,0x3C043F80)]
ledger=rows(L/'research-2026-09-18-global/patch_ledger.csv')
report['ledger_columns']=list(ledger[0])
report['ledger_count']=len(ledger)
report['iso_recorded_results']=[{'iso':x['iso'],'matching':x['matching'],'compared':x['compared'],
    'level02':next(m for m in x['modules'] if 'LEVEL_02' in m['path'])}
    for x in json.loads((L/'research-2026-09-18-global/iso_verification.json').read_text())]
report['supplemental_weapon_groups']={}
weapons=rows(L/'supplemental-files/known_weapon_patch_candidates.csv')
report['supplemental_weapon_columns']=list(weapons[0])
report['supplemental_weapon_count']=len(weapons)
for key in ('weapon','system'):
    if key in weapons[0]:
        report['supplemental_weapon_groups'][key]={v:sum(r[key]==v for r in weapons) for v in sorted({r[key] for r in weapons})}
for p in [OUT/'task.snapshot.md', ROOT/'research/tasks/v1-parity-inventory.md',
          L/'trace-validation/trace_L03_0004.csv', L/'trace-validation/trace_L03_0005.csv']:
    report['artifact_hashes'][str(p.relative_to(ROOT))]=sha(p)
integ=json.loads((L/'connection/dev061-integration-1789598570306.json').read_text(encoding='utf-8-sig'))
report['integration']={k:integ.get(k) for k in ('scope','base','pluginBase')}
report['integration'].update({k:len(integ[k]) for k in ('sites','callsites')})
report['integration']['all_sites_pass']=all(x['pass'] for x in integ['sites'])
pick=rows(L/'research-2026-09-18-global/audit-v063-pickup.csv')
report['pickup']={'rows':len(pick),'different':sum(r['same_as_metalis'].lower()=='false' for r in pick)}
report['transfer_gaps']=len(rows(L/'research-2026-09-18-global/metalis_transfer_gaps.csv'))
with zipfile.ZipFile(L/'archives/Pokitaru_60FPS_V1_two-builds.zip') as z:
    readme=z.read('pokitaru_v1/README_Pokitaru_V1.md').decode('utf-8-sig')
import re
archive_words=[]
for addr,old,new in re.findall(r'\| `0x([0-9A-F]+)` \| `0x([0-9A-F]+)` \| `0x([0-9A-F]+)` \|',readme):
    rva=int(addr,16)-0x09139D00
    archive_words.append({'rva':hex(rva),'old':old,'new':new,'binary_matches':struct.unpack_from('<I',b,offset(rva))[0]==int(old,16)})
report['archive_common_words']=archive_words
module1={int(r['rva'],16) for r in ledger if r['module']=='1'}
report['archive_words_missing_from_later_ledger']=[r for r in archive_words if int(r['rva'],16) not in module1]
# Explicit reviewer accounting; source rows retain the original report context.
excluded={6:'obsolete unlock, retained as negative history',8:'multiplayer coverage gap',
 9:'mode-switch diagnostic dependency',10:'policy inventory, not a distinct mechanic',
 24:'instance identity merged with E-VPI-023',27:'input-configuration dependency',
 36:'hook-lifetime diagnostic dependency',67:'duplicate of E-VPI-005',
 69:'optional framing feature',70:'broad coverage gap, not a distinct mechanic',
 72:'duplicate of E-VPI-035',77:'save-format knowledge outside parity'}
no_fix={7,50,64,65,73,74}
reported={1,15,28,32,34,35}
unknown={7,35,50,64,65,71,73,74,76}
items=[]
for line in (OUT/'workers/explorer.md').read_text().splitlines():
    match=re.match(r'\| VPI-(\d{3}) \|',line)
    if not match: continue
    n=int(match[1])
    items.append({'id':f'E-VPI-{n:03}', 'included':n not in excluded,
        'exclusion_reason':excluded.get(n,''), 'historical_candidate':n not in no_fix and n not in excluded,
        'reported_30fps_number':n in reported,'usable_reproducible_30fps_baseline':False,
        'essentially_unknown':n in unknown,'explorer_source_row':line})
assert len(items)==77 and len({r['id'] for r in items})==77
with (OUT/'reconciled-items.csv').open('w',encoding='utf-8',newline='') as f:
    w=csv.DictWriter(f,fieldnames=list(items[0]));w.writeheader();w.writerows(items)
report['review_counts']={key:sum(r[key] for r in items) for key in ('included','historical_candidate','reported_30fps_number','usable_reproducible_30fps_baseline','essentially_unknown')}
text=[]
for start,end in [(0x15140,0x15340),(0x2F900,0x2FD60),(0x96600,0x966C0),(0xE290,0xE400),(0x17B770,0x17B7B0)]:
    text.append(f'\n# RVA {start:08X}..{end:08X}; file SHA256 {sha(prx)}')
    for i in md.disasm(b[offset(start):offset(start)+(end-start)],start):
        text.append(f'{i.address:08X} {int.from_bytes(i.bytes,"little"):08X} {i.mnemonic:10s} {i.op_str}')
(OUT/'parent-socle-context.asm').write_text('\n'.join(text)+'\n',encoding='utf-8')
(OUT/'parent-checks.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
print(json.dumps(report,indent=2))
