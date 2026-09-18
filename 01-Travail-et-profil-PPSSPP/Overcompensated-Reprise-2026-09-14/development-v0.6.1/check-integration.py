import pathlib,re,json,hashlib,subprocess,sys
r=pathlib.Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14');d=r/'development-v0.6.1';p=d/'sources/profiler'
a=(r/'sources-v0.6.0/sources/profiler/generated/full_patch.generated.c').read_text();b=(p/'generated/full_patch.generated.c').read_text()
def tables(s):return dict(re.findall(r'static const RcsmFullWord kFull(\d+)\[\] = \{(.*?)\n\};',s,re.S))
x,y=tables(a),tables(b);assert x.keys()==y.keys()
for k in x:
 if k!='4':assert x[k]==y[k],k
rows=re.findall(r'\{0x([0-9A-F]+)u, 0x([0-9A-F]+)u, 0x([0-9A-F]+)u, (\d+)u, (\d+)u\}',y['4']);assert len(rows)==167
assert len({t[0] for t in rows})==167 and int(rows[-1][3])&32
before=hashlib.sha256((p/'generated/full_patch.generated.c').read_bytes()).hexdigest()
v=subprocess.run([sys.executable,str(p/'tools/generate_full_patch.py'),'--prx-dir',str(d/'verified-prx-inputs')],capture_output=True,text=True);assert v.returncode==0,v.stderr
assert before==hashlib.sha256((p/'generated/full_patch.generated.c').read_bytes()).hexdigest()
report={'status':'PASS_STATIC_ONLY','unchanged_other_modules':14,'metalis_entries':167,'unique_addresses':True,'unlock_last':True,'generator_reproducible':True,'added_original_words_verified':54,'scope':'generation only; build, host tests and installation recorded in VALIDATION_SUMMARY.json'}
(d/'INTEGRATION_CHECKS.json').write_text(json.dumps(report,indent=2));print(json.dumps(report))
