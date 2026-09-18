from pathlib import Path
import subprocess, tempfile, json, hashlib
root=Path(__file__).resolve().parent
project=root/'sources/profiler'
zig=root.parent/'toolchains/zig/zig-x86_64-windows-0.15.2/zig.exe'
def extract(path,name):
    s=path.read_text();start=s.index('static int prepare_full_patch(');end=s.index('\nstatic int full_binding_still_present',start)
    return s[start:end].replace('prepare_full_patch(',name+'(').replace('g_rcsm_cave_templates','g_test_templates')
old=extract(root.parent/'development-v0.6.3-generalisation/sources/profiler/src/psp_plugin_runtime.c','prepare_old')
new=extract(project/'src/psp_plugin_runtime.c','prepare_new')
header=r'''
#include <windows.h>
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "rcsm_full_patch.h"
typedef struct { const RcsmModuleProfile *profile; uint32_t runtime_base; } RcsmRuntimeBinding;
static uint32_t (*g_full_caves)[RCSM_CAVE_WORDS];
static uint32_t g_test_templates[RCSM_CAVE_COUNT][RCSM_CAVE_WORDS];
static RcsmFullState g_full;
static struct { unsigned full_layers; } g_config={15u};
static void sync_game_code(uint32_t a,size_t n,void *u){(void)a;(void)n;(void)u;}
'''
main=r'''
int main(void){
    RcsmRuntimeBinding binding={0};
    g_full_caves=VirtualAlloc((void *)(uintptr_t)0x09F00000u,65536,MEM_RESERVE|MEM_COMMIT,PAGE_READWRITE);
    assert(g_full_caves != NULL && (uintptr_t)g_full_caves==0x09F00000u);
    binding.profile=rcsm_find_module_profile(4u);
    binding.runtime_base=0x09000000u;
    assert(binding.profile!=NULL);
    memcpy(g_test_templates,g_rcsm_cave_templates,sizeof(g_test_templates));
    assert(g_test_templates[7][34]==0x3C043F00u);
    assert(prepare_old(&binding)==0);
    assert(prepare_new(&binding)==1);
    assert(g_full.count==167u && g_full_caves[7][34]==0x3C043F00u);
    printf("PASS: actual generated Metalis template: old runtime rejects, new runtime prepares 167 entries\n");
    g_test_templates[7][34]=0x3C043F80u;
    assert(prepare_old(&binding)==1);
    assert(prepare_new(&binding)==1 && g_full_caves[7][34]==0x3C043F00u);
    printf("PASS: legacy 1.0 template normalises to 0.5\n");
    g_test_templates[7][34]=0x3C044000u;
    assert(prepare_new(&binding)==0);
    printf("PASS: unexpected 2.0 template is rejected\n");
    VirtualFree(g_full_caves,0,MEM_RELEASE);
    return 0;
}
'''
with tempfile.TemporaryDirectory(dir=root) as temp:
    harness=Path(temp)/'cave_guard.c';exe=Path(temp)/'cave_guard.exe'
    harness.write_text(header+old+new+main)
    cmd=[str(zig),'cc','-std=c11','-Wall','-Wextra','-Werror','-Iinclude','-Igenerated',str(harness),'src/rcsm_full_patch.c','src/rcsm_profiler_core.c','generated/full_patch.generated.c','generated/wrapper_profiles.generated.c','-o',str(exe)]
    p=subprocess.run(cmd,cwd=project,text=True,capture_output=True)
    if p.returncode:raise RuntimeError(p.stdout+p.stderr)
    p=subprocess.run([str(exe)],text=True,capture_output=True,check=True)
report={'status':'PASS','scope':'host test of exact extracted old/new prepare_full_patch functions, real generated tables and real rcsm_full_prepare; only PSP cache sync is a no-op; no game process touched','runtime_sha256':hashlib.sha256((project/'src/psp_plugin_runtime.c').read_bytes()).hexdigest(),'result':p.stdout.splitlines()}
(root/'METALIS_CAVE_GUARD_VALIDATION.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
