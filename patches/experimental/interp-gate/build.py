#!/usr/bin/env python3
"""Build the InterpGate experimental plugin with the existing local PSP SDK."""
import argparse, hashlib, json, os, re, shutil, subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent; REPO = HERE.parents[2]
SDK = REPO/'01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/toolchains/pspdev-win'

def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def main():
    ap = argparse.ArgumentParser(description=__doc__); ap.add_argument('--name', required=True)
    a = ap.parse_args()
    if not a.name.replace('-', '').isalnum(): raise ValueError('unsafe name')
    build = HERE/'build'/a.name
    if build.exists(): raise RuntimeError('refusing existing build')
    build.mkdir(parents=True); shutil.copy2(HERE/'interp.c', build/'interp.c')
    env = os.environ.copy(); env['PATH'] = str(SDK/'bin')+os.pathsep+env.get('PATH', '')
    cc = SDK/'bin/psp-gcc.exe'; pspsdk = SDK/'psp/sdk'
    flags = ['-O2', '-G0', '-std=c11', '-Wall', '-Wextra', '-Werror', '-fno-strict-aliasing', '-fno-math-errno',
             '-D_PSP_FW_VERSION=660', '-I.', '-I'+(SDK/'psp/include').as_posix(), '-I'+(pspsdk/'include').as_posix()]
    def run(cmd):
        r = subprocess.run([str(x) for x in cmd], cwd=build, env=env, text=True,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if r.stdout: print(r.stdout, end='')
        if r.returncode: raise RuntimeError('build failed: '+str(cmd[0]))
    shutil.copy2(HERE/'stub.S', build/'stub.S')
    run([cc, *flags, '-c', 'interp.c', '-o', 'interp.o'])
    run([cc, '-G0', '-c', 'stub.S', '-o', 'stub.o'])
    run([cc, *flags, '-L'+(SDK/'psp/lib').as_posix(), '-L'+(pspsdk/'lib').as_posix(),
         '-specs='+(pspsdk/'lib/prxspecs').as_posix(), '-Wl,-q,-T'+(pspsdk/'lib/linkfile.prx').as_posix(),
         '-Wl,-zmax-page-size=128', '-nostdlib', '-nostartfiles', 'interp.o', 'stub.o', (pspsdk/'lib/prxexports.o').as_posix(), '-lpspmodinfo', '-lgcc', '-o', 'patch.elf'])
    nm = subprocess.run([str(SDK/'bin/psp-nm.exe'), 'patch.elf'], cwd=build, env=env, text=True,
                        stdout=subprocess.PIPE, check=True).stdout
    symbols = {}
    for name in ('ig_fix', 'ig_debris', 'ig_phys', 'ig_pfix', 'ig_pwrap_stub', 'ig_particles', 'ig_disp', 'ig_disp_stub0', 'ig_disp_stub1', 'ig_disp_stub2', 'ig_disp_stub3', 'ig_disp_stub4', 'ig_tel', 'ig_tel_pump', 'ig_watch', 'ig_pmap', 'ig_pa_speed', 'ig_cnt', 'ig_saved', 'ig_clock', 'ig_sp', 'ig_upd', 'ig_spawn', 'ig_spawn_stub0', 'ig_spawn_stub1', 'ig_anim', 'ig_animadv', 'ig_seg', 'ig_seghalf', 'ig_chalf', 'ig_classhalf', 'ig_cb', 'ig_cbhalf'):
        m = re.findall(r'(?m)^([0-9a-fA-F]+) [A-Za-z] %s$' % name, nm)
        if len(m) != 1: raise RuntimeError('missing symbol '+name)
        symbols[name] = int(m[0], 16)
    heads = subprocess.run([str(SDK/'bin/psp-objdump.exe'), '-h', 'patch.elf'], cwd=build, env=env, text=True,
                           stdout=subprocess.PIPE, check=True).stdout
    if re.search(r'\.lib\.stub\s+0*[1-9a-f]', heads): run([SDK/'bin/psp-fixup-imports.exe', 'patch.elf'])   # IG-v16 imports nothing
    run([SDK/'bin/psp-prxgen.exe', 'patch.elf', 'patch.prx'])
    package = build/'InterpGate'; package.mkdir()
    shutil.copy2(build/'patch.prx', package/'patch.prx'); shutil.copy2(HERE/'plugin.ini', package/'plugin.ini')
    manifest = {'status': 'BUILT_EXPERIMENTAL_NOT_RUNTIME_VALIDATED', 'symbols': symbols,
                'sourceSha256': digest(build/'interp.c'), 'builderSha256': digest(__file__),
                'prxSha256': digest(package/'patch.prx'), 'prxBytes': (package/'patch.prx').stat().st_size}
    (build/'manifest.json').write_text(json.dumps(manifest, indent=1), encoding='utf-8')
    print(json.dumps(manifest))

if __name__ == '__main__':
    main()
