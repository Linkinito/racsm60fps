#!/usr/bin/env python3
"""Portable transaction and trace checks. Does not run PPSSPP or the game."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--cc',default='gcc')
    ap.add_argument('--sanitize',action='store_true')
    args=ap.parse_args()
    root=Path(__file__).resolve().parents[1]
    reports=[]
    suites={
        'test_full_patch':['src/rcsm_full_patch.c','generated/full_patch.generated.c','src/rcsm_profiler_core.c','generated/wrapper_profiles.generated.c'],
        'test_profiler_core':['src/rcsm_profiler_core.c','generated/wrapper_profiles.generated.c'],
        'test_format':['src/rcsm_format.c'],
    }
    with tempfile.TemporaryDirectory() as temp:
        for suite, sources in suites.items():
            exe=Path(temp)/suite
            cmd=[args.cc,'-std=c11','-Wall','-Wextra','-Werror','-Iinclude','-Igenerated']
            if args.sanitize: cmd+=['-g','-fsanitize=address,undefined']
            cmd += [f'tests/{suite}.c',*sources,'-o',str(exe)]
            subprocess.run(cmd,cwd=root,check=True,capture_output=True,text=True)
            env=os.environ.copy()
            # This sandbox is traced; LeakSanitizer cannot inspect /proc threads.
            # ASan bounds checks and UBSan remain enabled. Tests allocate no heap.
            if args.sanitize: env['ASAN_OPTIONS']='detect_leaks=0'
            r=subprocess.run([str(exe)],cwd=root,env=env,check=True,capture_output=True,text=True)
            reports.append({'suite':suite,'status':'PASS','output':r.stdout.strip()})
        r=subprocess.run([sys.executable,'tests/test_trace_parser.py'],cwd=root,check=True,capture_output=True,text=True)
        reports.append({'suite':'test_trace_parser','status':'PASS','output':r.stdout.strip()})
    result={'status':'PASS','scope':'host simulation and trace parsing; no PPSSPP gameplay',
            'asan_ubsan':args.sanitize,'suites':reports}
    (root.parent/'HOST_VALIDATION.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))

if __name__=='__main__': main()
