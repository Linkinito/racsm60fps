#!/usr/bin/env python3
"""Build the OCEnhance plugin (freestanding, no libc) with the local PSP SDK."""
import argparse, hashlib, json, os, re, shutil, subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent; REPO = HERE.parents[2]
SDK = REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/toolchains/pspdev-win'

def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def main():
    ap = argparse.ArgumentParser(description=__doc__); ap.add_argument('--name', required=True)
    a = ap.parse_args()
    if not a.name.replace('-', '').replace('.', '').isalnum(): raise ValueError('unsafe name')
    build = HERE/'build'/a.name
    if build.exists(): raise RuntimeError('refusing existing build')
    build.mkdir(parents=True)
    for f in ('ocenhance.c', 'exports.exp'): shutil.copy2(HERE/f, build/f)
    env = os.environ.copy(); env['PATH'] = str(SDK/'bin')+os.pathsep+env.get('PATH', '')
    cc = SDK/'bin/psp-gcc.exe'; pspsdk = SDK/'psp/sdk'
    flags = ['-Os', '-G0', '-std=c11', '-Wall', '-Wextra', '-Werror', '-fno-strict-aliasing', '-fno-math-errno',
             '-fno-builtin', '-ffreestanding', '-D_PSP_FW_VERSION=660', '-I.', '-I'+(SDK/'psp/include').as_posix(),
             '-I'+(pspsdk/'include').as_posix()]
    def run(cmd, out=None):
        r = subprocess.run([str(x) for x in cmd], cwd=build, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if out: (build/out).write_text(r.stdout, encoding='utf-8')
        elif r.stdout: print(r.stdout, end='')
        if r.returncode: raise RuntimeError('build failed: '+str(cmd[0]))
    run([SDK/'bin/psp-build-exports.exe', '-b', 'exports.exp'], out='exports.c')
    run([cc, *flags, '-c', 'ocenhance.c', '-o', 'ocenhance.o'])
    run([cc, *flags, '-c', 'exports.c', '-o', 'exports.o'])
    run([cc, *flags, '-L'+(SDK/'psp/lib').as_posix(), '-L'+(pspsdk/'lib').as_posix(),
         '-specs='+(pspsdk/'lib/prxspecs').as_posix(), '-Wl,-q,-T'+(pspsdk/'lib/linkfile.prx').as_posix(),
         '-Wl,-zmax-page-size=128', '-nostdlib', '-nostartfiles', 'ocenhance.o', 'exports.o',
         '-lpspctrl', '-lpspuser', '-lpspkernel', '-lpspmodinfo', '-lgcc', '-o', 'patch.elf'])
    run([SDK/'bin/psp-fixup-imports.exe', 'patch.elf'])
    run([SDK/'bin/psp-prxgen.exe', 'patch.elf', 'patch.prx'])
    pkg = build/'OCEnhance'; pkg.mkdir()
    shutil.copy2(build/'patch.prx', pkg/'patch.prx'); shutil.copy2(HERE/'plugin.ini', pkg/'plugin.ini')
    shutil.copy2(HERE/'ocenhance.ini', pkg/'ocenhance.ini')
    size = subprocess.run([str(SDK/'bin/psp-size.exe'), 'patch.elf'], cwd=build, env=env, text=True, stdout=subprocess.PIPE, check=True).stdout
    manifest = {'status': 'BUILT_EXPERIMENTAL_NOT_RUNTIME_VALIDATED', 'sourceSha256': digest(build/'ocenhance.c'),
                'builderSha256': digest(__file__), 'prxSha256': digest(pkg/'patch.prx'), 'prxBytes': (pkg/'patch.prx').stat().st_size,
                'size': size.splitlines()[-1].split()[:4]}
    (build/'manifest.json').write_text(json.dumps(manifest, indent=1), encoding='utf-8')
    print(json.dumps(manifest))

if __name__ == '__main__':
    main()
