"""Portable Windows equivalent of the checked PSPSDK build.mak PRX rules."""
from pathlib import Path
import os, subprocess, hashlib, json
root=Path(__file__).resolve().parent
sdk=root.parent/'toolchains/pspdev-win'
project=root/'sources/profiler'
env=os.environ.copy()
env['PSPDEV']=sdk.as_posix()
env['PATH']=str(sdk/'bin')+os.pathsep+env['PATH']
pspsdk=sdk/'psp/sdk'
def run(args):
    p=subprocess.run([str(x) for x in args],cwd=project,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    print(p.stdout,end='')
    if p.returncode: raise SystemExit(p.returncode)
cc=sdk/'bin/psp-gcc.exe'
flags=['-O2','-G0','-std=c11','-Wall','-Wextra','-Werror','-fno-strict-aliasing','-D_PSP_FW_VERSION=660','-Iinclude','-Igenerated','-I.', '-I'+(sdk/'psp/include').as_posix(),'-I'+(pspsdk/'include').as_posix()]
sources=['src/rcsm_menu.c','src/menu_hook.S','generated/menu_profiles.generated.c','src/rcsm_fps_choice.c','src/psp_plugin_runtime.c','src/profiler_hook.S','src/rcsm_profiler_core.c','src/rcsm_format.c','src/rcsm_full_patch.c','generated/wrapper_profiles.generated.c','generated/full_patch.generated.c']
objects=[]
for source in sources:
    obj=str(Path(source).with_suffix('.o'))
    print('Compile',source,flush=True)
    run([cc,*flags,'-c',source,'-o',obj])
    objects.append(obj)
run([cc,*flags,'-L.', '-L'+(sdk/'psp/lib').as_posix(),'-L'+(pspsdk/'lib').as_posix(),'-specs='+ (pspsdk/'lib/prxspecs').as_posix(),'-Wl,-q,-T'+(pspsdk/'lib/linkfile.prx').as_posix(),'-Wl,-zmax-page-size=128',*objects,(pspsdk/'lib/prxexports.o').as_posix(),'-lpspdebug','-lpspdisplay','-lpspge','-lpspctrl','-lpspnet','-lpspnet_apctl','-o','patch.elf'])
run([sdk/'bin/psp-fixup-imports.exe','patch.elf'])
run([sdk/'bin/psp-prxgen.exe','patch.elf','patch.prx'])
report={'toolchain_archive_sha256':'037f902acd90cfcf4711aeee6462479a6d0eabee6faf93ff44fe1081e653d512','compiler':'psp-gcc 15.2.0 Windows dmang-dev v2','outputs':{p:{'size':(project/p).stat().st_size,'sha256':hashlib.sha256((project/p).read_bytes()).hexdigest()} for p in ['patch.elf','patch.prx']},'installed':False}
(root/'BUILD_WINDOWS.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
