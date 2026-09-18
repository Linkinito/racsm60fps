from pathlib import Path
import json,subprocess,sys
r=Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14/development-v0.6.1');p=r/'sources/profiler'
f=p/'tools/validate_policy_config.py';s=f.read_text();key='    default_policy = section.get("default_policy", "two_pass").strip().lower()';assert key in s;s=s.replace(key,'''    try:
        frame_rate = int(section.get("frame_rate", "60"), 0)
    except ValueError:
        fail("frame_rate invalide")
    if frame_rate not in (30, 60):
        fail("frame_rate doit valoir 30 ou 60")
'''+key);s=s.replace('armed = mode in {"policy_module", "global_60fps"}','armed = mode in {"policy_module", "global_60fps"} and not (mode == "global_60fps" and frame_rate == 30)');s=s.replace('"mode": mode,','"mode": mode,\n        "requested_frame_rate": frame_rate,');f.write_text(s)
f=p/'RCSMProfiler.ini';s=f.read_text().replace('v0.6.0-global-experimental.1','v0.6.1-metalis-integration-dev.2');f.write_text(s)
configs=r/'test-configs';configs.mkdir(exist_ok=True);results=[]
for rate in (30,60,45):
    f=configs/f'frame-rate-{rate}.ini';f.write_text(s.replace('frame_rate = 60',f'frame_rate = {rate}'))
    result=subprocess.run([sys.executable,str(p/'tools/validate_policy_config.py'),str(f)],capture_output=True,text=True)
    assert (result.returncode==0)==(rate in (30,60)),result.stderr
    if result.returncode==0:
        out=json.loads(result.stdout);assert out['armed_callsites']==(0 if rate==30 else 493)
    results.append({'requested':rate,'accepted':result.returncode==0})
(r/'FPS_CONFIG_VALIDATION.json').write_text(json.dumps(results,indent=2))
print(results)
