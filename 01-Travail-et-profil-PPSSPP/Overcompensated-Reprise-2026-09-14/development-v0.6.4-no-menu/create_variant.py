from pathlib import Path
import shutil, hashlib, json
root=Path(__file__).resolve().parent
old=root.parent/'development-v0.6.3-generalisation'
assert root.name=='development-v0.6.4-no-menu'
exclude={'rcsm_menu.c','menu_hook.S','menu_runtime.inc','rcsm_menu.h','rcsm_menu_profiles.h','menu_profiles.generated.c','test_menu.c'}
def ignore(d,names):
    return [n for n in names if n in exclude or Path(n).suffix in {'.o','.elf','.prx'} or n=='__pycache__']
shutil.copytree(old/'sources',root/'sources',ignore=ignore,dirs_exist_ok=True)
p=root/'sources/profiler/src/psp_plugin_runtime.c'
s=p.read_text()
s=s.replace('0.6.3-generalisation-dev.2','0.6.4-no-menu-dev.1')
s=s.replace('/* Menu/debugger mailbox. Monitor is the sole owner of g_fps_choice. */','/* Startup INI selects FPS. These symbols expose telemetry only: no runtime toggle. */')
for line in ['#include "menu_runtime.inc"\n','        menu_save_choice();\n','        menu_monitor(&detected);\n','    menu_stop();\n','    if(g_config.mode==RCSM_MODE_GLOBAL_60FPS)menu_load_choice();\n']:
    assert line in s,repr(line)
    s=s.replace(line,'')
block='''        uint32_t requested = g_rcsm_requested_fps;
        if (requested != g_fps_choice.requested) {
            if (g_config.mode == RCSM_MODE_GLOBAL_60FPS && rcsm_fps_request(&g_fps_choice, requested))
                log_line("frame_rate requested=%u; deferred until verified module reload", (unsigned)requested);
            else g_rcsm_requested_fps = g_fps_choice.requested;
        }
'''
assert block in s
s=s.replace(block,'')
assert 'menu_' not in s and 'Overcompensated.fps' not in s
s=s.replace('''        /* Metalis collision countdown must use the same half-step as motion.
           Other modules retain the original template until separately audited. */''','''        /* Accept the legacy and the already-generalised half-step template.
           The latter is present in the generated v0.6.3 tables. */''')
s=s.replace('if (g_full_caves[i][34] != 0x3C043F80u) return 0;',
            'if (g_full_caves[i][34] != 0x3C043F80u &&\n                g_full_caves[i][34] != 0x3C043F00u) return 0;')
p.write_text(s)
p=root/'sources/profiler/Makefile'
s=p.read_text().replace('src/rcsm_menu.o src/menu_hook.o generated/menu_profiles.generated.o ','')
p.write_text(s)
p=root/'sources/profiler/tools/run_host_checks.py'
s=p.read_text().replace("        'test_menu':['src/rcsm_menu.c'],\n",'')
p.write_text(s)
s=(old/'build-windows.py').read_text().replace("'src/rcsm_menu.c','src/menu_hook.S','generated/menu_profiles.generated.c',",'')
(root/'build-windows.py').write_text(s)
p=root/'sources/profiler/RCSMProfiler.ini'
s=p.read_text().replace('0.6.3-generalisation-dev.2','0.6.4-no-menu-dev.1').replace('; Applied on plugin start or a verified module reload, never mid-round.','; Startup INI only: menu toggle and sidecar preference have been removed.')
p.write_text(s)
proof={}
for rel in ['src/rcsm_full_patch.c','generated/full_patch.generated.c','src/rcsm_profiler_core.c','src/profiler_hook.S','generated/wrapper_profiles.generated.c','generated/wrapper_profiles.generated.h']:
    a=old/'sources/profiler'/rel;b=root/'sources/profiler'/rel
    assert a.read_bytes()==b.read_bytes(),rel
    proof[rel]=hashlib.sha256(b.read_bytes()).hexdigest()
(root/'UNCHANGED_60FPS_TABLES.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'variant':str(root),'unchanged':proof,'removed_menu_sources':sorted(exclude)},indent=2))

