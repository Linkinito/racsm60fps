/* Passive D1 profile owner. Original assets and archived sources are untouched. */
#include <pspkernel.h>
#include <pspmodulemgr.h>
#include <pspthreadman.h>
#include <stdint.h>
#include <string.h>

PSP_MODULE_INFO("D1Global", PSP_MODULE_USER, 0, 1);
PSP_MAIN_THREAD_PARAMS(0x2Eu,16u,PSP_THREAD_ATTR_USER);
PSP_MAIN_THREAD_NAME("d1_monitor");
PSP_HEAP_SIZE_KB(16);
typedef struct { uint32_t rva,before,after,before_kind,after_kind,group; } Rule;
typedef struct { uint32_t rva,word,kind; } Guard;
typedef struct { uint32_t index,extent,count,guard_count; const Rule *rules; const Guard *guards; } Profile;
typedef struct { uint32_t rva,before,after,group; } D1Resolved;
#include "profiles.generated.h"
extern D1Resolved d1_rules[128];
extern uint32_t d1_count;
extern volatile uint32_t d1_owned;
extern int d1_update(uint32_t base,uint32_t wanted);

/* magic,abi,request,module-request,installed,status,base,id,generation,error,
 * module-index,rule-count. request0 A0/off,1 D1,2 C1. Explicit arm per residency.
 * status0 passive,1 waiting,2 applied,3 unresolved,5 refused.
 */
volatile uint32_t d1_control[12]={0x44314731u,1u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u};
const unsigned char d1_build_id[32]=BUILD_ID_BYTES;
static const Profile *bound_profile;
static uint32_t bound_base;
static SceUID bound_id=-1,monitor_id=-1;
static volatile int stopping;

__attribute__((noinline)) uint32_t d1_read(uint32_t address) {
    uint32_t value;
    if(address<0x08800000u || address>0x09FFFFFCu || (address&3u)) return 0xFFFFFFFFu;
    value=*(volatile uint32_t *)(uintptr_t)address;
    if((value&0xFC000000u)==0x68000000u) {
        sceKernelIcacheInvalidateRange((const void *)(uintptr_t)address,4);
        value=*(volatile uint32_t *)(uintptr_t)address;
    }
    return value;
}
__attribute__((noinline)) int d1_write(uint32_t address,uint32_t value) {
    if(address<0x08800004u || address>0x09FFFFF4u || (address&3u)) return 0;
    *(volatile uint32_t *)(uintptr_t)address=value;
    sceKernelDcacheWritebackInvalidateRange((const void *)(uintptr_t)address,4);
    sceKernelIcacheInvalidateRange((const void *)(uintptr_t)(address-4),12);
    return d1_read(address)==value;
}
static uint32_t resolved(uint32_t base,uint32_t word,uint32_t kind) {
    return kind ? (word&0xFC000000u)|(((base+((word&0x03FFFFFFu)<<2))>>2)&0x03FFFFFFu) : word;
}
static int extent_ok(const SceKernelModuleInfo *info,const Profile *profile) {
    unsigned i;uint32_t end=0;
    if(info->text_addr<0x08800000u || info->text_addr>0x0A000000u-profile->extent ||
       (info->text_addr&3u) || info->nsegment<1 || info->nsegment>4) return 0;
    for(i=0;i<(unsigned)info->nsegment;i++) {
        uint32_t a=(uint32_t)info->segmentaddr[i],s=(uint32_t)info->segmentsize[i];
        if(a<info->text_addr || a>0x0A000000u || s>0x0A000000u-a) return 0;
        if(a+s>end) end=a+s;
    }
    return end-info->text_addr==profile->extent;
}
static int context_ok(uint32_t base,const Profile *profile) {
    unsigned i;
    for(i=0;i<profile->guard_count;i++) {
        const Guard *g=&profile->guards[i];
        uint32_t actual=d1_read(base+g->rva);
        if(g->kind==2u) {if((actual&0xFFFF0000u)!=(g->word&0xFFFF0000u)) return 0;}
        else if(actual!=resolved(base,g->word,g->kind)) return 0;
    }
    return 1;
}
static int enumerate(SceUID *ids,int *count) {
    *count=0;
    return sceKernelGetModuleIdList(ids,32*sizeof(*ids),count)>=0 && *count>=0 && *count<=32;
}
/* 0 only when the old ID is confirmed absent; ambiguity retains ownership. */
static int binding_status(void) {
    SceUID ids[32];int count,i;SceKernelModuleInfo info;
    if(!enumerate(ids,&count)) return -1;
    for(i=0;i<count;i++) if(ids[i]==bound_id) break;
    if(i==count) return 0;
    memset(&info,0,sizeof(info));info.size=sizeof(info);
    if(sceKernelQueryModuleInfo(bound_id,&info)<0 || strcmp(info.name,"rcp1") ||
       info.text_addr!=bound_base || !extent_ok(&info,bound_profile) ||
       !context_ok(bound_base,bound_profile)) return -1;
    return 1;
}
static int resolve_target(uint32_t index,uint32_t *base,SceUID *id,const Profile **profile) {
    SceUID ids[32];int count,i,found=0;unsigned p;
    if(!enumerate(ids,&count)) return 0;
    for(i=0;i<count;i++) {
        SceKernelModuleInfo info;memset(&info,0,sizeof(info));info.size=sizeof(info);
        if(sceKernelQueryModuleInfo(ids[i],&info)<0) return 0;
        if(strcmp(info.name,"rcp1")) continue;
        if(++found>1) return 0;
        for(p=0;p<PROFILE_COUNT;p++) {
            if(profiles[p].index!=index || !extent_ok(&info,&profiles[p]) ||
               !context_ok(info.text_addr,&profiles[p])) continue;
            *base=info.text_addr;*id=ids[i];*profile=&profiles[p];
        }
    }
    return found==1 && *profile!=0;
}
static void publish(uint32_t status,uint32_t error) {
    d1_control[4]=d1_owned;d1_control[5]=status;d1_control[6]=bound_base;
    d1_control[7]=(uint32_t)bound_id;d1_control[9]=error;
    d1_control[10]=bound_profile?bound_profile->index:0;d1_control[11]=d1_count;
}
static void unbind(void) {
    d1_owned=0;d1_count=0;bound_base=0;bound_id=-1;bound_profile=0;
}
static void prepare_rules(void) {
    unsigned i;d1_count=bound_profile->count;
    for(i=0;i<d1_count;i++) {
        const Rule *r=&bound_profile->rules[i];
        d1_rules[i].rva=r->rva;d1_rules[i].group=r->group;
        d1_rules[i].before=resolved(bound_base,r->before,r->before_kind);
        d1_rules[i].after=resolved(bound_base,r->after,r->after_kind);
    }
}
static int transaction(uint32_t wanted) {
    int dispatch=sceKernelSuspendDispatchThread(),result;
    if(dispatch<0) {publish(3,6);return -4;}
    if(binding_status()!=1) result=-4;
    else result=d1_update(bound_base,wanted);
    sceKernelResumeDispatchThread(dispatch);
    if(result>=0) d1_control[8]++;
    else d1_control[2]=0;
    publish(result==-4 || result==-3 || (result==-1 && d1_owned)?3u:
            result<0?5u:result?2u:0u,result<0?(uint32_t)(-result):0u);
    return result;
}
int main(int argc,char **argv) {
    (void)argc;(void)argv;monitor_id=sceKernelGetThreadId();
    while(!stopping) {
        uint32_t wanted=d1_control[2],index=d1_control[3];
        if(wanted>2u) {publish(5,1);sceKernelDelayThread(100000);continue;}
        if(bound_id>=0) {
            int binding=binding_status();
            if(binding<0) {publish(3,3);sceKernelDelayThread(100000);continue;}
            if(binding==0) {unbind();d1_control[2]=0;wanted=0;publish(0,0);}
            else if(wanted && index!=bound_profile->index) {publish(5,5);sceKernelDelayThread(100000);continue;}
            else if(transaction(wanted)>=0 && !wanted) {unbind();publish(0,0);}
        }
        if(bound_id<0 && wanted) {
            uint32_t base=0;SceUID id=-1;const Profile *profile=0;
            if(resolve_target(index,&base,&id,&profile)) {
                bound_base=base;bound_id=id;bound_profile=profile;prepare_rules();
                transaction(wanted);
            } else publish(1,0);
        }
        sceKernelDelayThread(100000);
    }
    sceKernelExitThread(0);return 0;
}
int module_stop(SceSize args,void *argp) {
    SceUInt timeout=1000000;int binding;
    (void)args;(void)argp;stopping=1;
    if(monitor_id<0 || monitor_id==sceKernelGetThreadId() ||
       sceKernelWaitThreadEnd(monitor_id,&timeout)<0) {publish(3,7);return -1;}
    if(bound_id>=0) {
        binding=binding_status();
        if(binding<0 || (binding==1 && transaction(0)<0)) {publish(3,8);return -1;}
        unbind();d1_control[2]=0;publish(0,0);
    }
    if(sceKernelDeleteThread(monitor_id)<0) {publish(3,9);return -1;}
    monitor_id=-1;return 0;
}
