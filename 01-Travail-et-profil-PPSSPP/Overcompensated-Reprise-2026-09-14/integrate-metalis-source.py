import pathlib,shutil,json,struct,re
r=pathlib.Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14'); dst=r/'development-v0.6.1'
assert not dst.exists(), 'Working copy already exists; do not overwrite'
shutil.copytree(r/'sources-v0.6.0'/'sources',dst/'sources',ignore=shutil.ignore_patterns('*.o','patch.elf','patch.prx','__pycache__'))
p=dst/'sources'/'profiler'
rows=[]
for filename in ['resume-crates-result-1789592738689.json','pickup-collection-1789593231151.json']:
 j=json.loads((r/'connection'/filename).read_text(encoding='utf-8-sig'))
 for c in j['changes']:
  if c.get('dynamic'):continue
  rows.append(dict(rva=c['address']-j['base'],original=c['before'],patched=c['after'],label=c['label'],evidence=filename,validation='experimental_gameplay_qualitative' if c.get('group')=='new-crates' or filename.startswith('pickup') else 'experimental_partial'))
assert len(rows)==54 and len({x['rva'] for x in rows})==54
registry={'module_index':4,'status':'experimental_not_release_validated','changes':sorted(rows,key=lambda c:c['rva']),'cave7_word34':{'original':0x3c043f80,'patched':0x3c043f00,'scope':'module4 only','validation':'user reports debris looks normal'}}
(p/'generated'/'metalis-experiments.json').write_text(json.dumps(registry,indent=2)+'\n')
g=p/'tools'/'generate_full_patch.py';s=g.read_text()
needle="    calls = list(csv.DictReader"
pos=s.index(needle)
insert='''    # Local experimental Metalis additions. Verify the original game words;
    # dynamic actor speeds are deliberately not part of this persistent table.
    extra = json.loads((root/'profiler/generated/metalis-experiments.json').read_text())
    assert extra['module_index'] == 4
    for c in extra['changes']:
        off, old, new = c['rva'], c['original'], c['patched']
        assert images[4].word(off) == old, f'Experimental original mismatch {off:#x}'
        assert off not in images[4].relocations, f'Unexpected relocation {off:#x}'
        assert not any(x[0] == off for x in patches[4]), f'Experimental conflict {off:#x}'
        code = 16 if off < 0x1D0000 else 0
        patches[4].append((off, old, new, code, 2))
    assert len(patches[4]) <= 192
'''
s=s[:pos]+insert+s[pos:];s=s.replace("'wrapper_calls_checked': checked_calls", "'experimental_metalis_writes': len(extra['changes']), 'wrapper_calls_checked': checked_calls")
g.write_text(s)
h=p/'include'/'rcsm_full_patch.h';s=h.read_text().replace('#define RCSM_FULL_CAPACITY 128u','#define RCSM_FULL_CAPACITY 192u');h.write_text(s)
f=p/'src'/'psp_plugin_runtime.c';s=f.read_text();needle='        sync_game_code(addresses[i],sizeof(g_full_caves[i]),NULL);'
assert s.count(needle)==1
s=s.replace(needle,'''        /* Metalis collision countdown must use the same half-step as motion.
           Other modules retain the original template until separately audited. */
        if (m->module_index == 4u && i == 7u) {
            if (g_full_caves[i][34] != 0x3C043F80u) return 0;
            g_full_caves[i][34] = 0x3C043F00u;
        }
'''+needle)
s=s.replace('0.6.0-global-experimental.1','0.6.1-metalis-integration-dev.1');f.write_text(s)
print('Working copy:',dst,'persistent added sites:',len(rows),'capacity:192')
