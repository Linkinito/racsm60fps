import csv, hashlib, importlib.util, json, math, pathlib, re, struct
ROOT = pathlib.Path(__file__).resolve().parents[1]
OUT = pathlib.Path(__file__).resolve().parent
SRC = ROOT/'development-v0.6.3-generalisation/sources/profiler'
spec = importlib.util.spec_from_file_location('historic_generator', SRC/'tools/generate_full_patch.py')
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
metalis = json.loads((SRC/'generated/metalis-experiments.json').read_text())
gen = json.loads((SRC/'generated/generalisation-experiments.json').read_text())
ref = {x['label']:x for x in metalis['changes'] if x['label'].startswith('pickup')}
f32 = lambda x: struct.unpack('<f', struct.pack('<I', x))[0]
hx = lambda x: f'0x{x:08X}'
images = {}
rows=[]
for e in gen['changes']:
    idx = e['module_index']
    if idx not in images: images[idx] = m.Elf(ROOT/f'development-v0.6.3-generalisation/prx-reference/LEVEL_{idx:02d}.PRX')
    raw = images[idx].word(e['rva'])
    assert raw == e['original'], (idx,e['rva'])
    target = ref[e['label']]['patched']
    rows.append(dict(module=f'LEVEL_{idx:02d}', label=e['label'], rva=hx(e['rva']), vanilla_word=hx(raw), vanilla_float=f32(raw), v063_word=hx(e['patched']), v063_float=f32(e['patched']), metalis_reference_word=hx(target), metalis_reference_float=f32(target), same_as_metalis=e['patched']==target, vanilla_verified=True, validation='static_only_not_gameplay'))
with (OUT/'audit-v063-pickup.csv').open('w',newline='',encoding='utf-8-sig') as f:
    w=csv.DictWriter(f,fieldnames=rows[0].keys()); w.writeheader(); w.writerows(rows)
caves = []
csrc = (SRC/'generated/full_patch.generated.c').read_text()
for line in csrc.splitlines():
    words=re.findall(r'0x([0-9A-Fa-f]{8})u',line)
    if line.strip().startswith('{0x') and len(words)==64: caves.append([int(w,16) for w in words])
runtime = (SRC/'src/psp_plugin_runtime.c').read_text()
assert len(caves)==8
assert re.search(r'if\s*\(m->module_index\s*==\s*4u\s*&&\s*i\s*==\s*7u\)',runtime)
assert 'if (g_full_caves[i][34] != 0x3C043F80u) return 0;' in runtime
summary = {
 'scope':'Read-only historical source/binary audit; no new in-game execution',
 'conversation':{'title':'Revoir le travail effectué','id':'01a0b0ad-babe-79e1-a191-76793e7c4a84','turns_read':10,'pagination_complete':True},
 'new_pickup_rows':len(rows),'originals_verified_against_prx':sum(r['vanilla_verified'] for r in rows),
 'rows_differing_from_metalis':sum(not r['same_as_metalis'] for r in rows),
 'differing_labels':sorted({r['label'] for r in rows if not r['same_as_metalis']}),
 'metalis_runtime_cave_guard':{'template_word':hx(caves[7][34]),'guard_requires':'0x3C043F80','condition_fails':caves[7][34]!=0x3C043F80,'consequence':'prepare_full_patch returns 0 for module4 in historical v0.6.3; 60fps installation refused and 30fps confirmation refused'},
 'original_prx_sha256':{f'LEVEL_{i:02d}':hashlib.sha256(x.data).hexdigest() for i,x in images.items()},
 'source_sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [SRC/'generated/generalisation-experiments.json',SRC/'generated/metalis-experiments.json',SRC/'generated/full_patch.generated.c',SRC/'src/psp_plugin_runtime.c']}
}
(OUT/'audit-historique-preuves.json').write_text(json.dumps(summary,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in summary.items() if k not in ['source_sha256','original_prx_sha256']},indent=2,ensure_ascii=False))
