#!/usr/bin/env python3
"""Install the new passive D0 package only, with PPSSPP fully closed.

Does not disable/replace any existing plugin or game asset. Refuses existing D0.
"""
import argparse,hashlib,importlib.util,json,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
TARGET=Path('C:/Users/linki/Documents/PPSSPP/PSP/PLUGINS/D0Temporal')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def closed():
    p=subprocess.run(['powershell','-NoProfile','-Command',"@(Get-Process -Name PPSSPP* -ErrorAction SilentlyContinue).Count"],capture_output=True,text=True,check=True)
    if p.stdout.strip()!='0':raise RuntimeError('PPSSPP must be fully closed')
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--build',type=Path,required=True)
    p.add_argument('--tests',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    if a.out.exists() or TARGET.exists():raise ValueError('refusing existing deployment/package')
    closed();m=json.loads((a.build/'manifest.json').read_bytes());t=json.loads(a.tests.read_bytes())
    if t['status']!='OFFLINE_PASS_NOT_RUNTIME_ACCEPTED' or t['manifestSha256']!=sha(a.build/'manifest.json'):raise ValueError('offline/build mismatch')
    for name,h in m['inputs'].items():
        if sha(ROOT/name)!=h:raise ValueError('changed source/input '+name)
    if sha(ROOT/'patches/experimental/d0-temporal/test_offline.py')!=t['testSourceSha256']:raise ValueError('test method changed')
    package=a.build/'D0Temporal'
    if sha(package/'patch.prx')!=m['prxSha256'] or (package/'plugin.ini').read_bytes()!=(ROOT/'patches/experimental/d0-temporal/plugin.ini').read_bytes():raise ValueError('package mismatch')
    spec=importlib.util.spec_from_file_location('d0_install_build',ROOT/'patches/experimental/d0-temporal/build.py')
    b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
    elf=(a.build/'patch.elf').read_bytes();control=m['symbols']['d0_control']
    s=next(v for v in b.sections(elf).values() if v[1]!=8 and v[3]<=control and control+40<=v[3]+v[5])
    initial=struct.unpack_from('<10I',elf,s[4]+control-s[3])
    if initial!=(0x44305430,1,0,0,0,0,0,0,0,0):raise ValueError('linked image is not passive')
    a.out.mkdir(parents=True);record={'status':'FAILED','target':str(TARGET),'prxSha256':m['prxSha256'],
       'testsSha256':sha(a.tests),'methodSha256':sha(Path(__file__)),'linkedInitialControl':initial,
       'otherMappings':'UNCHANGED','activation':'OFF; separate control request required'}
    try:
        closed();TARGET.mkdir()
        with (TARGET/'patch.prx').open('xb') as f:f.write((package/'patch.prx').read_bytes())
        if sha(TARGET/'patch.prx')!=m['prxSha256']:raise ValueError('binary readback')
        closed()
        with (TARGET/'plugin.ini').open('xb') as f:f.write((package/'plugin.ini').read_bytes())
        if (TARGET/'plugin.ini').read_bytes()!=(package/'plugin.ini').read_bytes():raise ValueError('mapping readback')
        record['status']='DEPLOYED_PASSIVE_NOT_RUNTIME_ACCEPTED'
    except BaseException as e:
        record['error']=str(e)
        # Preserve incomplete evidence. Only disable our exact new descriptor.
        descriptor=TARGET/'plugin.ini'
        if descriptor.exists() and descriptor.read_bytes()==(package/'plugin.ini').read_bytes():
            descriptor.write_bytes(descriptor.read_bytes().replace(b'UCES00420 = true',b'UCES00420 = false'))
        raise
    finally:(a.out/'deployment.json').write_bytes((json.dumps(record,indent=2)+'\n').encode())
    print(json.dumps(record))
if __name__=='__main__':main()
