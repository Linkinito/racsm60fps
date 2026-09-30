/* D0 prototype. External C1 core; optional effects are separately attributable.
 * Passive on startup; no ISO/PRX asset, pooled constant or heap-scale allocation.
 */
#include <pspkernel.h>
#include <pspmodulemgr.h>
#include <pspthreadman.h>
#include <pspiofilemgr.h>
#include <stdint.h>
#include <string.h>

PSP_MODULE_INFO("D0Temporal", PSP_MODULE_USER, 0, 1);
PSP_MAIN_THREAD_PARAMS(0x2Eu,16u,PSP_THREAD_ATTR_USER);
PSP_MAIN_THREAD_NAME("d0_monitor");
PSP_HEAP_SIZE_KB(16);
typedef struct { uint32_t rva, word; } Guard;
#include "guards.generated.h"

/* ABI1: magic,abi,request,enemy_gate,installed,status,base,id,generation,error.
 * status0 passive,1 waiting,2 active,3 unresolved,4 core-off,5 refused.
 * request0/1/3; mask2 needs explicit unmeasured-wave gate0xD0000002.
 */
volatile uint32_t d0_control[10]={0x44305430u,1u,0u,0u,0u,0u,0u,0u,0u,0u};
const unsigned char d0_build_id[32]=BUILD_ID_BYTES;
extern volatile uint32_t d0_owned;
extern int d0_update(uint32_t base,uint32_t wanted);
static uint32_t bound_base;
static SceUID bound_id=-1, monitor_id=-1;
static volatile int stopping;

__attribute__((noinline)) uint32_t d0_read(uint32_t a) {
    uint32_t v;
    if(a<0x08800000u || a>0x09FFFFFCu || (a&3u)) return 0xFFFFFFFFu;
    v=*(volatile uint32_t *)(uintptr_t)a;
    if((v&0xFC000000u)==0x68000000u) {
        sceKernelIcacheInvalidateRange((const void *)(uintptr_t)a,4);
        v=*(volatile uint32_t *)(uintptr_t)a;
    }
    return v;
}
__attribute__((noinline)) int d0_write(uint32_t a,uint32_t v) {
    if(a<0x08800004u || a>0x09FFFFF4u || (a&3u)) return 0;
    *(volatile uint32_t *)(uintptr_t)a=v;
    sceKernelDcacheWritebackInvalidateRange((const void *)(uintptr_t)a,4);
    sceKernelIcacheInvalidateRange((const void *)(uintptr_t)(a-4),12);
    return d0_read(a)==v;
}
static int extent_ok(const SceKernelModuleInfo *p) {
    unsigned j; uint32_t end=0;
    if(p->text_addr<0x08800000u || p->text_addr>0x0A000000u-TARGET_EXTENT ||
       (p->text_addr&3u) || p->nsegment<1 || p->nsegment>4) return 0;
    for(j=0;j<(unsigned)p->nsegment;j++) {
        uint32_t a=(uint32_t)p->segmentaddr[j],s=(uint32_t)p->segmentsize[j];
        if(a<p->text_addr || a>0x0A000000u || s>0x0A000000u-a) return 0;
        if(a+s>end) end=a+s;
    }
    return end-p->text_addr==TARGET_EXTENT;
}
static int context_ok(uint32_t base) {
    unsigned i;
    for(i=0;i<GUARD_COUNT;i++) if(d0_read(base+guards[i].rva)!=guards[i].word) return 0;
    return 1;
}
static int core_kind(uint32_t base) {
    uint32_t wait=d0_read(base+0x96650u),dt=d0_read(base+0x151E0u);
    uint32_t loop=d0_read(base+0x2FCFCu),scalar=d0_read(base+0x2FBBCu);
    uint32_t original_wait=0x0C000000u|(((base+0x1BF424u)>>2)&0x03FFFFFFu);
    if(wait==0 && dt==0x3C043C88u && loop==0x2A240001u && scalar==0x46006506u) return 1;
    if((wait==0 || wait==original_wait) && (dt==0x3C043D08u || dt==0x3C043C88u) &&
       (loop==0x2A240001u || loop==0x2A240002u) && scalar==0x46006506u) return 0;
    return -1;
}
/* Return-1 query/content ambiguity;0 confirmed old ID absent;1 same binding.
 * No ownership is discarded on failed enumeration/query or changed content.
 */
static int binding_status(void) {
    SceUID ids[32]; int count=0,i; SceKernelModuleInfo p;
    if(sceKernelGetModuleIdList(ids,sizeof(ids),&count)<0 || count<0 || count>32) return -1;
    for(i=0;i<count;i++) if(ids[i]==bound_id) break;
    if(i==count) return 0;
    memset(&p,0,sizeof(p));p.size=sizeof(p);
    if(sceKernelQueryModuleInfo(bound_id,&p)<0 || strcmp(p.name,"rcp1") ||
       p.text_addr!=bound_base || !extent_ok(&p) || !context_ok(bound_base)) return -1;
    return 1;
}
static int resolve(uint32_t *base,SceUID *id) {
    SceUID ids[32]; int count=0,i,found=0;
    if(sceKernelGetModuleIdList(ids,sizeof(ids),&count)<0 || count<0 || count>32) return 0;
    for(i=0;i<count;i++) {
        SceKernelModuleInfo p; memset(&p,0,sizeof(p));p.size=sizeof(p);
        if(sceKernelQueryModuleInfo(ids[i],&p)<0) return 0;
        if(strcmp(p.name,"rcp1") || !extent_ok(&p)) continue;
        if(found) return 0;
        found=1;*base=p.text_addr;*id=ids[i];
    }
    return found;
}
static void publish(uint32_t status,uint32_t error) {
    d0_control[4]=d0_owned;d0_control[5]=status;
    d0_control[6]=bound_base;d0_control[7]=(uint32_t)bound_id;
    d0_control[9]=error;
}
static int transaction(uint32_t wanted) {
    int dispatch=sceKernelSuspendDispatchThread(),result,core;
    core=core_kind(bound_base);
    if(binding_status()!=1 || !context_ok(bound_base) || core<0) result=-4;
    else result=d0_update(bound_base,core==1?wanted:0);
    sceKernelResumeDispatchThread(dispatch);
    if(result>=0) d0_control[8]++;
    else d0_control[2]=0; /* Failed changes require an explicit new request. */
    publish(result==-4 || result==-3 || (result==-1 && d0_owned)?3u:
            result<0?5u:core==0?4u:result?2u:0u,result<0?(uint32_t)(-result):0u);
    return result;
}
int main(int argc,char **argv) {
    (void)argc;(void)argv;monitor_id=sceKernelGetThreadId();
    while(!stopping) {
        uint32_t wanted=d0_control[2],base=0; SceUID id=-1;
        int binding;
        if(wanted!=0 && wanted!=1 && wanted!=3) { publish(5,1);sceKernelDelayThread(100000);continue; }
        if((wanted&2u) && d0_control[3]!=0xD0000002u) { publish(5,2);sceKernelDelayThread(100000);continue; }
        if(bound_id>=0) {
            binding=binding_status();
            if(binding<0) { publish(3,3);sceKernelDelayThread(100000);continue; }
            if(binding==0) { d0_owned=0;bound_id=-1;bound_base=0;d0_control[2]=0;wanted=0;publish(0,0); }
            else transaction(wanted); /* Also verifies every owned word. */
        }
        if(bound_id<0 && wanted) {
            if(resolve(&base,&id) && context_ok(base)) {
                bound_base=base;bound_id=id;
                transaction(wanted);
            } else publish(1,0);
        } else if(bound_id<0) publish(0,0);
        sceKernelDelayThread(100000);
    }
    sceKernelExitThread(0);return 0;
}
int module_stop(SceSize args,void *argp) {
    SceUInt timeout=1000000;
    (void)args;(void)argp;
    /* Stop-and-join first: no monitor can reinstall or race final restoration.
     * A failed join refuses unloading and retains the module/ownership.
     */
    stopping=1;
    if(monitor_id<0 || monitor_id==sceKernelGetThreadId() ||
       sceKernelWaitThreadEnd(monitor_id,&timeout)<0) { publish(3,6);return -1; }
    if(bound_id>=0 && d0_owned) {
        int binding=binding_status();
        if(binding<0 || (binding==1 && transaction(0)<0)) { publish(3,7);return -1; }
        if(binding==0) d0_owned=0;
    }
    if(sceKernelDeleteThread(monitor_id)<0) { publish(3,8);return -1; }
    monitor_id=-1;
    return 0;
}
