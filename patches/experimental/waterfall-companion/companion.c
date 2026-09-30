/* Experimental C1 add-on: droplets006 + alpha007 + surface foam40 + flap.
 * C1 is external. Shared emission corrected; separate WaterWaves unchanged.
 * Recipe is generated from the separately tested runtime components.
 * Original game assets and the existing core companion are never modified.
 */
#include <pspkernel.h>
#include <pspmodulemgr.h>
#include <pspthreadman.h>
#include <pspiofilemgr.h>
#include <stdint.h>
#include <string.h>

PSP_MODULE_INFO("WaterfallExperimental", PSP_MODULE_USER, 1, 13);
PSP_MAIN_THREAD_PARAMS(0x2Eu, 16u, PSP_THREAD_ATTR_USER);
PSP_MAIN_THREAD_NAME("waterfall_monitor");
/* Bound any retained newlib allocation; the SDK default claims nearly all
 * free user RAM. This add-on does not need a game-sized heap. */
PSP_HEAP_SIZE_KB(64);

typedef struct { uint32_t rva, before, after; unsigned char kind, cave; } Rule;
typedef struct { uint32_t rva, word; } Guard;
#include "recipe.generated.h"
static volatile int stopping;
static uint32_t bound_base;
static SceUID bound_id=-1;
static SceUID monitor_id=-1;
static int installed, disarmed, pending_restore, rollback_caves, query_warned, binding_warned;
static unsigned char owned[sizeof(rules)/sizeof(rules[0])];

static int append_text(char *line,unsigned *used,unsigned capacity,const char *text) {
    while(*text) {
        if(*used>=capacity) return 0;
        line[(*used)++]=*text++;
    }
    return 1;
}
static void log_status(const char *text) {
    /* Avoid newlib stdio: its first allocation may reserve the game's free
     * user RAM through the SDK's default heap policy. No allocation here. */
    static const char hex[]="0123456789ABCDEF";
    char line[320]; unsigned used=0,i;
    if(!append_text(line,&used,sizeof(line),text) ||
       !append_text(line,&used,sizeof(line)," base=")) return;
    for(i=0;i<8;i++) {
        if(used>=sizeof(line)) return;
        line[used++]=hex[(bound_base>>((7u-i)*4u))&15u];
    }
    if(!append_text(line,&used,sizeof(line)," profile=C1-core-external+droplets006+alpha007-mist-droplets+foam40-surface-waves+common-emitter+Butterfly-flap-only WaterWaves=unchanged\n")) return;
    SceUID fd=sceIoOpen("ms0:/PSP/PLUGINS/WaterfallExperimental/status.log",PSP_O_WRONLY|PSP_O_CREAT|PSP_O_APPEND,0777);
    if(fd>=0) { sceIoWrite(fd,line,used); sceIoClose(fd); }
}

static uint32_t read_word(uint32_t a) {
    if(a<0x08800000u || a>0x09FFFFFCu || (a&3u)) return 0xFFFFFFFFu;
    uint32_t v=*(volatile uint32_t *)(uintptr_t)a;
    /* Restore a PPSSPP JIT marker before exact comparison, never wildcard it. */
    if((v&0xFC000000u)==0x68000000u) {
        sceKernelIcacheInvalidateRange((const void *)(uintptr_t)a,4);
        v=*(volatile uint32_t *)(uintptr_t)a;
    }
    return v;
}
static int write_word(uint32_t a,uint32_t value) {
    if(a<0x08800000u || a>0x09FFFFFCu || (a&3u)) return 0;
    *(volatile uint32_t *)(uintptr_t)a=value;
    sceKernelDcacheWritebackInvalidateRange((const void *)(uintptr_t)a,4);
    sceKernelIcacheInvalidateRange((const void *)(uintptr_t)a,4);
    /* The changed andi is a branch delay slot. Flush the branch pair together
     * on install AND restore; word-only debugger writes left stale JIT code. */
    if(a==bound_base+0x151EDCu) sceKernelIcacheInvalidateRange((const void *)(uintptr_t)(a-4),8);
    return read_word(a)==value;
}
static uint32_t patched(const Rule *r,uint32_t base) {
    if(r->kind==1) return 0x08000000u|(((base+r->after)>>2)&0x03FFFFFFu);
    if(r->kind==2) return 0x3C010000u|((base+r->after)>>16);
    if(r->kind==3) return 0x34210000u|((base+r->after)&0xFFFFu);
    return r->after;
}
static int resolve(uint32_t *base,SceUID *id) {
    SceUID ids[32]; int count=0,found=0,i;
    if(sceKernelGetModuleIdList(ids,sizeof(ids),&count)<0 || count>32) return 0;
    for(i=0;i<count;i++) {
        SceKernelModuleInfo info; unsigned j; uint32_t end=0;
        memset(&info,0,sizeof(info)); info.size=sizeof(info);
        if(sceKernelQueryModuleInfo(ids[i],&info)<0 || strcmp(info.name,"rcp1")) continue;
        if(info.text_addr<0x08800000u || info.text_addr>0x09B94700u || (info.text_addr&3u) || info.nsegment<1 || info.nsegment>4) continue;
        for(j=0;j<(unsigned)info.nsegment;j++) {
            uint32_t a=(uint32_t)info.segmentaddr[j], size=(uint32_t)info.segmentsize[j];
            if(a<info.text_addr || a>0x0A000000u || size>0x0A000000u-a) { end=0; break; }
            if(a+size>end) end=a+size;
        }
        if(end-info.text_addr!=TARGET_LOAD_EXTENT) continue;
        if(found) return 0;
        found=1; *base=info.text_addr; *id=ids[i];
    }
    return found;
}
static int context_ok(uint32_t base) {
    unsigned i;
    for(i=0;i<sizeof(guards)/sizeof(guards[0]);i++)
        if(read_word(base+guards[i].rva)!=guards[i].word) return 0;
    return 1;
}
static int waterfall_pools_ready(uint32_t base) {
    uint32_t first=read_word(base+0x2D48A8u),second=read_word(base+0x2D48ACu);
    return first<64u && second<64u && first!=second && read_word(base+0x2D4A18u)<=3u;
}
/* Successful module enumeration can establish that a specific old ID is gone.
 * A query error or changed mapping cannot; preserve ownership in those cases. */
static int binding_status(void) {
    SceUID ids[32]; int count=0,i; SceKernelModuleInfo info;
    if(sceKernelGetModuleIdList(ids,sizeof(ids),&count)<0 || count>32) return -1;
    for(i=0;i<count;i++) if(ids[i]==bound_id) break;
    if(i==count) return 0;
    memset(&info,0,sizeof(info)); info.size=sizeof(info);
    if(sceKernelQueryModuleInfo(bound_id,&info)<0 || strcmp(info.name,"rcp1") || info.text_addr!=bound_base || info.nsegment<1 || info.nsegment>4) return -1;
    {
        unsigned j; uint32_t end=0;
        for(j=0;j<(unsigned)info.nsegment;j++) {
            uint32_t a=(uint32_t)info.segmentaddr[j],size=(uint32_t)info.segmentsize[j];
            if(a<bound_base || a>0x0A000000u || size>0x0A000000u-a) return -1;
            if(a+size>end) end=a+size;
        }
        if(end-bound_base!=TARGET_LOAD_EXTENT) return -1;
    }
    return context_ok(bound_base)?1:-1;
}
static int c1_ok(uint32_t base) {
    return read_word(base+0x96650u)==0 && read_word(base+0x151E0u)==0x3C043C88u &&
        read_word(base+0x2FCFCu)==0x2A240001u && read_word(base+0x2FBBCu)==0x46006506u;
}
/* Under suspended dispatch. Caves remain resident on normal removal so a
 * previously preempted game thread may safely finish its trampoline. */
static int restore(int failed_install) {
    unsigned i; int ok=1;
    if(!context_ok(bound_base)) { pending_restore=1; return 0; }
    /* First remove all redirects and data. A failed redirect rollback must
     * never be followed by destruction of a cave it can still reach. */
    for(i=sizeof(rules)/sizeof(rules[0]);i>0;i--) {
        const Rule *r=&rules[i-1]; uint32_t a=bound_base+r->rva;
        uint32_t current;
        if(!owned[i-1] || r->cave) continue;
        current=read_word(a);
        if(current==r->before) { owned[i-1]=0; continue; }
        if(current!=patched(r,bound_base) || !write_word(a,r->before)) { ok=0; continue; }
        owned[i-1]=0;
    }
    if(failed_install && ok) {
        /* No game thread ran during this failed install and every redirect
         * was restored. These caves are unreachable and safe to retry. */
        rollback_caves=1;
        for(i=sizeof(rules)/sizeof(rules[0]);i>0;i--) {
            const Rule *r=&rules[i-1]; uint32_t a=bound_base+r->rva;
            if(!owned[i-1] || !r->cave) continue;
            if(read_word(a)!=patched(r,bound_base) || !write_word(a,r->before)) { ok=0; continue; }
            owned[i-1]=0;
        }
    } else if(failed_install) rollback_caves=0;
    installed=0;
    pending_restore=!ok;
    if(ok) rollback_caves=0;
    return ok;
}
static int install(uint32_t base,SceUID id) {
    unsigned i;
    /* Caller resolved the module immediately before suspending dispatch.
     * Only bounded memory guards execute in this critical section. */
    if(!c1_ok(base) || !context_ok(base) || !waterfall_pools_ready(base)) return 0;
    for(i=0;i<sizeof(rules)/sizeof(rules[0]);i++)
        if(read_word(base+rules[i].rva)!=rules[i].before) return 0;
    bound_base=base; bound_id=id; memset(owned,0,sizeof(owned));
    for(i=0;i<sizeof(rules)/sizeof(rules[0]);i++) {
        const Rule *r=&rules[i]; uint32_t a=base+r->rva;
        /* Track intent before readback: partial failures still need rollback. */
        owned[i]=1;
        if(!write_word(a,patched(r,base))) { restore(1); return -1; }
    }
    installed=1; pending_restore=0;
    return 1;
}

int main(int argc,char **argv) {
    (void)argc; (void)argv;
    monitor_id=sceKernelGetThreadId();
    log_status("waiting-for-LEVEL01-and-C1");
    while(!stopping) {
        uint32_t base=0; SceUID id=-1;
        if(installed || pending_restore) {
            int binding=binding_status();
            if(binding==0) {
                installed=0; pending_restore=0; rollback_caves=0; disarmed=0; query_warned=0; binding_warned=0;
                memset(owned,0,sizeof(owned));
                log_status("confirmed-old-module-unloaded-ownership-expired");
            } else if(binding<0) {
                if(!binding_warned) log_status("binding-unresolved-ownership-retained-no-writes");
                binding_warned=1; sceKernelDelayThread(100000); continue;
            } else {
              if(binding_warned) {
                log_status("binding-recovered-ownership-retained"); binding_warned=0;
              }
              if(pending_restore || !c1_ok(bound_base)) {
                int dispatch=sceKernelSuspendDispatchThread();
                int ok=restore(rollback_caves);
                sceKernelResumeDispatchThread(dispatch); disarmed=1;
                if(ok || !query_warned) log_status(ok?"removed-caves-retained":"restoration-conflict-ownership-retained");
                query_warned=!ok;
                if(!ok) { sceKernelDelayThread(100000); continue; }
              }
            }
        }
        if(resolve(&base,&id)) {
            if(installed && (base!=bound_base || id!=bound_id)) {
                /* The previous binding was verified above, so preserve it and
                 * refuse installation into a second ambiguous rcp1 module. */
                if(!query_warned) log_status("different-module-ownership-retained-no-writes");
                query_warned=1; sceKernelDelayThread(100000); continue;
            }
            if(installed && !c1_ok(base)) {
                int dispatch=sceKernelSuspendDispatchThread();
                int ok=restore(0);
                sceKernelResumeDispatchThread(dispatch); disarmed=1;
                log_status(ok?"removed-after-core-change-caves-retained":"removal-conflict-manual-restart-required");
            } else if(!installed && !disarmed && c1_ok(base) && context_ok(base) && waterfall_pools_ready(base)) {
                int dispatch=sceKernelSuspendDispatchThread();
                int result=install(base,id);
                sceKernelResumeDispatchThread(dispatch);
                if(result>0) log_status("installed-experimental-add-on");
                else { disarmed=1; log_status(result<0?"install-failed-rollback-attempted":"preflight-refused-no-writes"); }
            }
        }
        sceKernelDelayThread(100000);
    }
    sceKernelExitDeleteThread(0);
    return 0;
}
int module_stop(SceSize args,void *argp) {
    int binding=1,dispatch,ok=1;
    (void)args; (void)argp;
    if(installed || pending_restore) binding=binding_status();
    if(binding<0) { log_status("stop-refused-binding-unresolved"); return -1; }
    stopping=1;
    dispatch=sceKernelSuspendDispatchThread();
    if((installed || pending_restore) && binding==1) ok=restore(rollback_caves);
    sceKernelResumeDispatchThread(dispatch);
    if(!ok) { stopping=0; log_status("stop-refused-restoration-conflict"); return -1; }
    if(monitor_id>=0 && monitor_id!=sceKernelGetThreadId()) sceKernelTerminateDeleteThread(monitor_id);
    return 0;
}
