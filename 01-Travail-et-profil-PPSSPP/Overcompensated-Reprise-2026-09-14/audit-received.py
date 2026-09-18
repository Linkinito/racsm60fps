from pathlib import Path
import hashlib, json, subprocess, sys, zipfile

root = Path(__file__).resolve().parent
v5 = root / 'sources-v0.5.0/Size_Matters_wrapper_dispatcher_v0.5.0-prealpha_UCES00420'
v6 = root / 'sources-v0.6.0'
out = root / 'received-validation'
out.mkdir(exist_ok=True)
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
report = {'hash_checks': [], 'policies': [], 'trace_contract_tests': [], 'game_modules': []}
for line in (v6/'SHA256SUMS.txt').read_text().splitlines():
    expected, relative = line.split(maxsplit=1)
    p = (v6/relative).resolve()
    if not p.is_relative_to(v6.resolve()): raise RuntimeError('Manifest path outside package')
    report['hash_checks'].append({'file':'v6/'+relative, 'match':p.exists() and sha(p)==expected})
m5=json.loads((v5/'RELEASE_MANIFEST.json').read_text())
for p in v5.rglob('patch.prx'):
    report['hash_checks'].append({'file':str(p.relative_to(root)), 'match':sha(p)==m5['build']['patch_prx_sha256']})
for item in m5['ready_zips']:
    p=v5/'install/ready_zips'/item['file']
    report['hash_checks'].append({'file':str(p.relative_to(root)), 'match':sha(p)==item['sha256']})
for label, package, configs in [('v5',v5,list((v5/'profiler').rglob('RCSMProfiler.ini'))),('v6',v6/'sources',[v6/'PSP/PLUGINS/SizeMattersWrapperProfiler/RCSMProfiler.ini', *sorted((v6/'diagnostics').glob('*.ini'))])]:
    for i, config in enumerate(configs):
        result=subprocess.run([sys.executable,str(package/'profiler/tools/validate_policy_config.py'),str(config)],capture_output=True,text=True)
        (out/f'{label}-policy-{i}.json').write_text(result.stdout or result.stderr,encoding='utf-8')
        data=json.loads(result.stdout) if result.returncode==0 else {'error':result.stderr}
        data.pop('routes',None)
        report['policies'].append(data)
    r=subprocess.run([sys.executable,str(package/'profiler/tests/test_trace_parser.py')],capture_output=True,text=True)
    report['trace_contract_tests'].append({'version':label,'exit_code':r.returncode,'stdout':r.stdout,'stderr':r.stderr})
audit=json.loads((v6/'sources/BINARY_AUDIT.json').read_text())
game=Path('C:/Users/linki/Downloads/Ratchet & Clank - Size Matters (Europe) (PSN)/Data')
for index,expected in audit['prx_sha256'].items():
    names={f'LEVEL_{int(index):02}.PRX',f'LEVEL_{int(index):02}_clean.PRX'}
    candidates=[]
    for p in game.rglob('*'):
        if p.is_file() and p.name in names: candidates.append({'file':str(p),'match':sha(p)==expected})
    with zipfile.ZipFile(game/'BIN.zip') as z:
        for info in z.infolist():
            if Path(info.filename).name in names:
                candidates.append({'file':'BIN.zip::'+info.filename,'match':hashlib.sha256(z.read(info)).hexdigest()==expected})
    report['game_modules'].append({'module':int(index),'expected':expected,'candidates':candidates,'matching_source_found':any(x['match'] for x in candidates)})
report['provenance_manifest_match']=sha(v6/'sources/provenance/experience_v021_manifest.json')==audit['source_manifest_sha256']
report['summary']={'hash_checks':len(report['hash_checks']),'hash_failures':sum(not x['match'] for x in report['hash_checks']),'module_sources_matched':sum(x['matching_source_found'] for x in report['game_modules']),'policies_tested':len(report['policies']),'policy_failures':sum(x.get('status')!='PASS' for x in report['policies']),'trace_test_failures':sum(x['exit_code']!=0 for x in report['trace_contract_tests']),'pspdev_rebuild':'not performed; toolchain not found on PATH','host_c_suites':'not rerun; compiler not found on PATH'}
(out/'audit.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
print(json.dumps(report['summary'],indent=2))
print(json.dumps(report['trace_contract_tests'],indent=2))
print('Mismatches:',json.dumps([x for x in report['hash_checks'] if not x['match']]))
print('Unmatched modules:',json.dumps([x for x in report['game_modules'] if not x['matching_source_found']]))
