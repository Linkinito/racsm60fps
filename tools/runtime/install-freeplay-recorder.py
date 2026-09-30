#!/usr/bin/env python3
"""Install an offline-checked observational PRX, backing up related mappings.

Requires PPSSPP fully closed. Disables only the named corrective companions for
the A0/core-only C1 discovery pair. Original PRXs/ISO and other settings untouched.
All backups and deployment evidence remain local in the requested output folder.
"""
import argparse,hashlib,json,re,shutil,subprocess
from pathlib import Path
REPO=Path(__file__).resolve().parents[2]
PLUGINS=Path('C:/Users/linki/Documents/PPSSPP/PSP/PLUGINS')
def sha(data):return hashlib.sha256(data).hexdigest()
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--build',type=Path,required=True);p.add_argument('--tests',type=Path,required=True);p.add_argument('--out',type=Path,required=True);p.add_argument('--replace-sha');a=p.parse_args()
    if a.out.exists():raise RuntimeError('refusing deployment/backup overwrite')
    process=subprocess.run(['powershell','-NoProfile','-Command',"@(Get-Process -Name PPSSPP* -ErrorAction SilentlyContinue).Count"],capture_output=True,text=True,check=True)
    if process.stdout.strip()!='0':raise RuntimeError('PPSSPP must be fully closed')
    m=json.loads((a.build/'manifest.json').read_bytes());tests=json.loads(a.tests.read_bytes())
    if tests['status']!='OFFLINE_PASS_NOT_RUNTIME_ACCEPTED' or tests['manifestSha256']!=sha((a.build/'manifest.json').read_bytes()):raise RuntimeError('offline acceptance does not match build')
    for name,expected in {**m['inputs'],**tests['sourceHashes']}.items():
        if sha((REPO/name).read_bytes())!=expected:raise RuntimeError('input/method changed: '+name)
    binary=(a.build/'FamilyRecorder/patch.prx').read_bytes();mapping=(a.build/'FamilyRecorder/plugin.ini').read_bytes()
    if sha(binary)!=m['prxSha256'] or mapping.count(b'UCES00420 = true')!=1:raise RuntimeError('package mismatch')
    # Deployment boots idle. No probe can be installed without the separate
    # allowlisted controller request; certify that in the actual linked image.
    import importlib.util,struct
    spec=importlib.util.spec_from_file_location('install_recorder_build',REPO/'patches/experimental/family-recorder/build.py');builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(builder)
    elf=(a.build/'patch.elf').read_bytes();address=m['symbols']['recorder_control'];sections=builder.sections(elf)
    section=next(s for s in sections.values() if s[1]!=8 and s[3]<=address<address+60<=s[3]+s[5])
    initial=struct.unpack_from('<15I',elf,section[4]+address-section[3])
    if initial!=(0x31524652,2,0,8,0,0,0,0,0,0,0,0,0,0,0):raise RuntimeError('linked recorder is not disabled by default')
    target=PLUGINS/'FamilyRecorder'
    previous=None
    if target.exists():
        if not a.replace_sha or not re.fullmatch('[0-9a-f]{64}',a.replace_sha):raise RuntimeError('existing recorder requires an exact binary hash for upgrade')
        previous=((target/'patch.prx').read_bytes(),(target/'plugin.ini').read_bytes())
        if sha(previous[0])!=a.replace_sha:raise RuntimeError('installed binary differs from requested upgrade')
    elif a.replace_sha:raise RuntimeError('requested upgrade but no recorder installed')
    changes=[]
    for name in ('WaterfallExperimental','SizeMattersWrapperProfiler','Lvl3ElevatorExperimental'):
        path=PLUGINS/name/'plugin.ini'
        if not path.exists():continue
        before=path.read_bytes();after,n=re.subn(rb'(?m)^(UCES00420[ \t]*=[ \t]*)true[ \t]*(?=\r?$)',rb'\g<1>false',before)
        if n>1:raise RuntimeError('ambiguous companion mapping')
        changes.append((path,before,after))
    a.out.mkdir(parents=True);record={'status':'FAILED','prxSha256':m['prxSha256'],'methodSha256':sha(Path(__file__).read_bytes()),'changes':[],'testsSha256':sha(a.tests.read_bytes()),'linkedInitialControl':initial,'probeActivation':'DISABLED; separate allowlisted request required'}
    try:
        for path,before,after in changes:
            backup=a.out/(path.parent.name+'-plugin.ini');backup.write_bytes(before)
            if path.read_bytes()!=before:raise RuntimeError('mapping changed externally')
            path.write_bytes(after)
            if path.read_bytes()!=after:raise RuntimeError('mapping readback failed')
            record['changes'].append({'path':str(path),'backup':str(backup),'beforeSha256':sha(before),'afterSha256':sha(after)})
        if previous:
            (a.out/'previous-patch.prx').write_bytes(previous[0]);(a.out/'previous-plugin.ini').write_bytes(previous[1])
            if (target/'patch.prx').read_bytes()!=previous[0] or (target/'plugin.ini').read_bytes()!=previous[1]:raise RuntimeError('recorder changed externally')
        else:target.mkdir()
        (target/'patch.prx').write_bytes(binary);(target/'plugin.ini').write_bytes(mapping)
        if (target/'patch.prx').read_bytes()!=binary or (target/'plugin.ini').read_bytes()!=mapping:raise RuntimeError('deployment readback failed')
        record['status']='DEPLOYED_IDLE_NOT_RUNTIME_ACCEPTED'
    except BaseException as error:
        record['error']=str(error)
        for path,before,after in changes:
            if path.exists() and path.read_bytes()==after:path.write_bytes(before)
        # Keep an incomplete new package as evidence, but make it inactive.
        if previous:
            if (target/'patch.prx').read_bytes()==binary:(target/'patch.prx').write_bytes(previous[0])
            if (target/'plugin.ini').read_bytes()==mapping:(target/'plugin.ini').write_bytes(previous[1])
        elif (target/'plugin.ini').exists() and (target/'plugin.ini').read_bytes()==mapping:(target/'plugin.ini').write_bytes(mapping.replace(b'UCES00420 = true',b'UCES00420 = false'))
        raise
    finally:(a.out/'deployment.json').write_text(json.dumps(record,indent=1),encoding='utf-8')
    print(json.dumps({'status':record['status'],'target':str(target),'prxSha256':m['prxSha256']}))
if __name__=='__main__':main()
