from pathlib import Path
D=Path(__file__).resolve().parent
p=D/'sources/profiler/src/menu_runtime.inc';s=p.read_text(encoding='utf-8-sig')
s=s.replace('unsigned i,installed=0;uint32_t index;int lock;', 'unsigned i,installed=0;uint32_t index,previous=g_rcsm_menu_installed;int lock;')
s=s.replace('    g_rcsm_menu_installed=installed;\n    (void)sceKernelResumeDispatchThread(lock);','    g_rcsm_menu_installed=installed;\n    (void)sceKernelResumeDispatchThread(lock);\n    if(installed!=previous)log_line("menu hooks mask=%u module=%u base=0x%08X hook0=0x%08X",installed,(unsigned)index,(unsigned)detected->runtime_base,(unsigned)(uintptr_t)rcsm_menu_hook_0);')
p.write_text(s)
p=D/'prepare-live-verifier.py';s=(D.parent/'development-v0.6.1/prepare-live-verifier.py').read_text().replace("d=r/'development-v0.6.1'","d=r/'development-v0.6.2-menu'").replace('0.6.1-metalis-integration-dev.2','0.6.2-native-menu-dev.1').replace("root+'/development-v0.6.1/runtime-symbols.json'","root+'/development-v0.6.2-menu/runtime-symbols.json'").replace('dev061-integration-','dev062-integration-');p.write_text(s)
