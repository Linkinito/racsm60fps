from pathlib import Path
D=Path(__file__).resolve().parent;P=D/'sources/profiler'
p=P/'src/psp_plugin_runtime.c';s=p.read_text(encoding='utf-8-sig')
s=s.replace('0.6.1-metalis-integration-dev.2','0.6.2-native-menu-dev.1')
s=s.replace('static int prepare_full_patch(', '#include "menu_runtime.inc"\n\nstatic int prepare_full_patch(',1)
s=s.replace('        detected_valid = resolve_current_module(&detected);','        menu_save_choice();\n        detected_valid = resolve_current_module(&detected);\n        menu_monitor(&detected);',1)
s=s.replace('    log_line("stop version=%s", RCSM_VERSION);','    menu_stop();\n    log_line("stop version=%s", RCSM_VERSION);',1)
s=s.replace('    load_config();','    load_config();\n    if(g_config.mode==RCSM_MODE_GLOBAL_60FPS)menu_load_choice();',1);p.write_text(s)
p=P/'tools/run_host_checks.py';s=p.read_text(encoding='utf-8-sig').replace("    suites={","    suites={\n        'test_menu':['src/rcsm_menu.c'],",1);p.write_text(s)
p=P/'Makefile';s=p.read_text(encoding='utf-8-sig').replace('OBJS = ','OBJS = src/rcsm_menu.o src/menu_hook.o generated/menu_profiles.generated.o ',1);p.write_text(s)
p=D/'build-windows.py';s=p.read_text(encoding='utf-8-sig').replace("sources=[","sources=['src/rcsm_menu.c','src/menu_hook.S','generated/menu_profiles.generated.c',",1);p.write_text(s)
