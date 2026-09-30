/* Experimental telemetry only. No core, coefficients, or callback gating.
 * One-word JAL/JALR redirects preserve the original delay slot and callee.
 * Generated guards bind only the pinned UCES00420 LEVEL_01 image.
 */
#include <pspkernel.h>
#include <pspmodulemgr.h>
#include <pspthreadman.h>
#include <pspiofilemgr.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>

PSP_MODULE_INFO("FamilyRecorder", PSP_MODULE_USER, 1, 0);
PSP_MAIN_THREAD_PARAMS(0x2Eu, 16u, PSP_THREAD_ATTR_USER);
PSP_HEAP_SIZE_KB(16);
typedef struct {uint32_t rva,word,delay,direct,reg,family;} Site;
typedef struct {uint32_t rva,pvar_offset,fields[6];} Callback;
typedef struct {uint32_t rva,word;} Guard;
#include "sites.generated.h"
const unsigned char recorder_build_id[32]=BUILD_ID_BYTES;
#define MAGIC 0x31524652u
#define RING_SIZE 128u
/* First two words are also consumed by hook.S; keep their ABI fixed. */
typedef struct {uint32_t direct,reg_offset,id,code[8],owned,hits,matched;} Hook;
typedef struct {uint32_t callback,site,hit,lo,hi,a0,a1,a2,a3,ra,f12,
    object0,object1,pvar,valid,fields[6],position[3];} Event;
typedef struct {uint32_t magic,version,request,stride,status,base,epoch,
    installed,events,dropped,io_error,sequence,clock_lo,clock_hi,trace_number;} Control;
volatile Control recorder_control={MAGIC,2,0,8,0,0,0,0,0,0,0,0,0,0,0};
static Hook hooks[SITE_COUNT];
static uint32_t callback_hits[CALLBACK_COUNT];
static Event ring[RING_SIZE],output[RING_SIZE];
static uint32_t counters[SITE_COUNT*2+CALLBACK_COUNT];
static unsigned used;
static SceUID module_id=-1,fd=-1;
static int installed,ever_installed,blocked;
static volatile int stopping;
static SceUID monitor_id=-1;
extern void recorder_hook(void);
_Static_assert(offsetof(Hook,direct)==0 && offsetof(Hook,reg_offset)==4,"hook ABI");
_Static_assert(sizeof(Event)==96,"trace ABI");

static uint32_t word(uint32_t a) {
    uint32_t v=*(volatile uint32_t *)(uintptr_t)a;
    if((v&0xFC000000u)==0x68000000u) {
        sceKernelIcacheInvalidateRange((const void *)(uintptr_t)a,4);
        v=*(volatile uint32_t *)(uintptr_t)a;
    }
    return v;
}
static uint32_t jump(uint32_t a,int link) {return (link?0x0C000000u:0x08000000u)|((a>>2)&0x03FFFFFFu);}
static uint32_t original(unsigned i) {return sites[i].direct?jump(recorder_control.base+sites[i].direct,1):sites[i].word;}
static uint32_t redirected(unsigned i) {return jump((uint32_t)(uintptr_t)hooks[i].code,1);}
static int put(uint32_t a,uint32_t v) {
    *(volatile uint32_t *)(uintptr_t)a=v;
    sceKernelDcacheWritebackInvalidateRange((const void *)(uintptr_t)a,4);
    sceKernelIcacheInvalidateRange((const void *)(uintptr_t)a,8);
    return word(a)==v;
}
static int context(uint32_t base) {
    unsigned i;
    for(i=0;i<GUARD_COUNT;i++) if(word(base+guards[i].rva)!=guards[i].word) return 0;
    return 1;
}
static int owned_context(void) {
    unsigned i;
    if(!context(recorder_control.base)) return 0;
    for(i=0;i<SITE_COUNT;i++) if(hooks[i].owned &&
        (word(recorder_control.base+sites[i].rva)!=redirected(i) ||
         word(recorder_control.base+sites[i].rva+4)!=sites[i].delay)) return 0;
    return 1;
}
static int arm(uint32_t base) {
    uint32_t w=word(base+0x96650u),d=word(base+0x151E0u),l=word(base+0x2FCFCu);
    if(word(base+0x2FBBCu)!=0x46006506u) return 0;
    if(w==jump(base+0x1BF424u,1) && d==0x3C043D08u && l==0x2A240002u) return 1;
    if(w==0 && d==0x3C043C88u && l==0x2A240001u) return 2;
    return 0;
}
static int module(uint32_t *base,SceUID *id) {
    SceUID ids[32];int n=0,k,found=0;
    if(sceKernelGetModuleIdList(ids,sizeof(ids),&n)<0 || n>32) return -1;
    for(k=0;k<n;k++) {
        SceKernelModuleInfo m;unsigned j;uint32_t end=0;
        memset(&m,0,sizeof(m));m.size=sizeof(m);
        if(sceKernelQueryModuleInfo(ids[k],&m)<0) return -1;
        if(strcmp(m.name,"rcp1")) continue;
        if(found || m.text_addr<0x08800000u || m.text_addr>0x09B94700u || m.nsegment<1 || m.nsegment>4) return -1;
        for(j=0;j<(unsigned)m.nsegment;j++) {
            uint32_t a=(uint32_t)m.segmentaddr[j],s=(uint32_t)m.segmentsize[j];
            if(a<m.text_addr || a>=0x0A000000u || s>0x0A000000u-a) return -1;
            if(a+s>end) end=a+s;
        }
        if(end-m.text_addr!=0x46B830u) return -1;
        *base=m.text_addr;*id=ids[k];found=1;
    }
    return found;
}
static int callback_index(uint32_t rva) {
    unsigned l=0,r=CALLBACK_COUNT;
    while(l<r) {unsigned mid=(l+r)/2;if(callbacks[mid].rva<rva) l=mid+1;else r=mid;}
    return l<CALLBACK_COUNT && callbacks[l].rva==rva?(int)l:-1;
}
static int readable(uint32_t a,unsigned bytes) {return !(a&3u) && a>=0x08800000u && a<=0x0A000000u-bytes;}
void recorder_hit(const uint32_t *frame,Hook *h) {
    uint32_t dest,id=h->id;int cb,dispatch;Event e;unsigned j;
    if(recorder_control.request<1 || recorder_control.request>2 || !recorder_control.installed || recorder_control.status!=1) return;
    dispatch=sceKernelSuspendDispatchThread();
    if(recorder_control.request<1 || recorder_control.request>2 || !recorder_control.installed || recorder_control.status!=1) {sceKernelResumeDispatchThread(dispatch);return;}
    dest=h->direct?h->direct:frame[h->reg_offset/4u];
    h->hits++;cb=callback_index(dest-recorder_control.base);
    if(cb>=0) {h->matched++;callback_hits[cb]++;}
    /* Count every invocation, sample a deterministic subset. Unknown targets
     * on indirect paths are counted separately, not mistaken for atlas coverage. */
    if(recorder_control.request!=2 || (cb<0 && sites[id].family==0) ||
       recorder_control.stride<1 || recorder_control.stride>1024 ||
       (h->hits!=1 && h->hits%recorder_control.stride!=0)) {sceKernelResumeDispatchThread(dispatch);return;}
    if(used==RING_SIZE) {recorder_control.dropped++;sceKernelResumeDispatchThread(dispatch);return;}
    memset(&e,0,sizeof(e));e.callback=cb>=0?(uint32_t)cb:0xFFFFFFFFu;e.site=id;e.hit=h->hits;
    {uint64_t t=sceKernelGetSystemTimeWide();e.lo=(uint32_t)t;e.hi=(uint32_t)(t>>32);}
    e.a0=frame[4];e.a1=frame[5];e.a2=frame[6];e.a3=frame[7];e.ra=frame[31];e.f12=frame[44];
    if(readable(e.a0,0x60u)) {
        const volatile uint32_t *obj=(const volatile uint32_t *)(uintptr_t)e.a0;
        e.object0=obj[0];e.object1=obj[1];e.valid|=1;
        /* Position semantics are only accepted for separately bound callbacks. */
        if(cb>=0 && callbacks[cb].pvar_offset) {
            e.pvar=obj[callbacks[cb].pvar_offset/4];
            for(j=0;j<3;j++) e.position[j]=obj[0x30u/4+j];
            if(readable(e.pvar,0x80u)) {
                e.valid|=2;
                for(j=0;j<6;j++) if(callbacks[cb].fields[j]!=0xFFFFFFFFu)
                    e.fields[j]=*(volatile uint32_t *)(uintptr_t)(e.pvar+callbacks[cb].fields[j]);
            }
        }
    }
    ring[used++]=e;recorder_control.events++;
    sceKernelResumeDispatchThread(dispatch);
}
static int remove_hooks(void) {
    unsigned i;int ok=1;
    if(!context(recorder_control.base)) return 0;
    recorder_control.installed=0;
    for(i=0;i<SITE_COUNT;i++) if(hooks[i].owned) {
        uint32_t a=recorder_control.base+sites[i].rva,v=word(a);
        if(v==original(i)) {hooks[i].owned=0;continue;}
        if(v!=redirected(i) || !put(a,original(i))) {ok=0;continue;}
        hooks[i].owned=0;
    }
    if(ok) installed=0;
    return ok;
}
static int install_hooks(uint32_t base,SceUID id) {
    unsigned i;uint32_t common=(uint32_t)(uintptr_t)&recorder_hook;
    if(!context(base) || !arm(base)) return 0;
    recorder_control.base=base;module_id=id;
    for(i=0;i<SITE_COUNT;i++) {
        uint32_t stub=(uint32_t)(uintptr_t)hooks[i].code;
        if(((base+sites[i].rva+4u)^stub)&0xF0000000u || ((stub+24u)^common)&0xF0000000u) return 0;
        if(sites[i].direct && ((base+sites[i].rva+4u)^(base+sites[i].direct))&0xF0000000u) return 0;
        if(word(base+sites[i].rva)!=original(i) || word(base+sites[i].rva+4)!=sites[i].delay) return 0;
    }
    for(i=0;i<SITE_COUNT;i++) {
        Hook *h=&hooks[i];uint32_t ptr=(uint32_t)(uintptr_t)h;
        h->direct=sites[i].direct?base+sites[i].direct:0;h->reg_offset=sites[i].reg*4;h->id=i;
        h->code[0]=0x27BDFFF0u;h->code[1]=0xAFBA0000u;h->code[2]=0xAFBB0004u;
        h->code[3]=0x3C1A0000u|(ptr>>16);h->code[4]=0x375A0000u|(ptr&0xFFFFu);
        h->code[5]=jump(common,0);h->code[6]=0;h->code[7]=0;
        sceKernelDcacheWritebackInvalidateRange(h->code,sizeof(h->code));
        sceKernelIcacheInvalidateRange(h->code,sizeof(h->code));
    }
    for(i=0;i<SITE_COUNT;i++) {
        hooks[i].owned=1;ever_installed=1;installed=1;
        if(!put(base+sites[i].rva,redirected(i))) {remove_hooks();return 0;}
    }
    recorder_control.installed=1;recorder_control.status=1;recorder_control.epoch++;
    return 1;
}
static int write_all(const void *data,unsigned size) {
    const unsigned char *bytes=data;
    while(size) {int n=sceIoWrite(fd,bytes,size);if(n<=0 || (unsigned)n>size) return 0;bytes+=n;size-=(unsigned)n;}
    return 1;
}
static void export_chunk(uint32_t state) {
    uint32_t header[27],count,i;uint64_t t;int dispatch,result;
    dispatch=sceKernelSuspendDispatchThread();count=used;
    memcpy(output,ring,count*sizeof(Event));used=0;
    for(i=0;i<SITE_COUNT;i++) {counters[2*i]=hooks[i].hits;counters[2*i+1]=hooks[i].matched;}
    memcpy(counters+SITE_COUNT*2,callback_hits,sizeof(callback_hits));
    t=sceKernelGetSystemTimeWide();
    recorder_control.clock_lo=(uint32_t)t;recorder_control.clock_hi=(uint32_t)(t>>32);
    header[0]=MAGIC;header[1]=2;header[2]=sizeof(header)+sizeof(counters)+count*sizeof(Event);
    header[3]=recorder_control.sequence++;header[4]=recorder_control.epoch;header[5]=recorder_control.base;
    header[6]=state;header[7]=recorder_control.status;header[8]=SITE_COUNT;header[9]=CALLBACK_COUNT;
    header[10]=count;header[11]=recorder_control.dropped;header[12]=(uint32_t)t;header[13]=(uint32_t)(t>>32);
    header[14]=recorder_control.request;header[15]=recorder_control.stride;header[16]=GUARD_COUNT;header[17]=96;
    memcpy(header+18,recorder_build_id,32);header[26]=recorder_control.trace_number;
    sceKernelResumeDispatchThread(dispatch);
    result=write_all(header,sizeof(header)) && write_all(counters,sizeof(counters)) && (!count || write_all(output,count*sizeof(Event)));
    if(!result) {recorder_control.io_error=1;recorder_control.request=0;blocked=1;}
}
int main(int argc,char **argv) {
    unsigned attempt,previous=0xFFFFFFFFu;char path[]="ms0:/PSP/PLUGINS/FamilyRecorder/trace-000.bin";
    (void)argc;(void)argv;monitor_id=sceKernelGetThreadId();
    /* Unique append-free evidence file. No allocation or newlib stdio. */
    for(attempt=0;attempt<1000;attempt++) {
        unsigned at=sizeof(path)-8;
        path[at]=(char)('0'+attempt/100);path[at+1]=(char)('0'+attempt/10%10);path[at+2]=(char)('0'+attempt%10);
        fd=sceIoOpen(path,PSP_O_WRONLY|PSP_O_CREAT|PSP_O_EXCL,0777);if(fd>=0) break;
    }
    if(fd<0) {recorder_control.io_error=1;return 0;}
    recorder_control.trace_number=attempt;
    while(!stopping) {
        uint32_t base=0,state=0;SceUID id=-1;int found=module(&base,&id);
        if(recorder_control.stride<1 || recorder_control.stride>1024 || recorder_control.request>3) {recorder_control.request=0;blocked=1;}
        if(installed) {
            if(found==0) {unsigned i;installed=0;recorder_control.installed=0;for(i=0;i<SITE_COUNT;i++) hooks[i].owned=0;blocked=1;recorder_control.status=4;}
            /* Changed contents do not establish ownership of the old mapping.
             * Refuse writes, retain stubs, invalidate capture and require a full
             * emulator restart. Never claim successful cleanup in this state. */
            else if(found<0 || id!=module_id || base!=recorder_control.base || !owned_context()) {recorder_control.status=3;blocked=1;}
            else {
                state=(uint32_t)arm(base);
                if(!state || recorder_control.request==0 || recorder_control.request==3 || blocked) {
                    int dispatch=sceKernelSuspendDispatchThread();int ok=remove_hooks();sceKernelResumeDispatchThread(dispatch);
                    recorder_control.status=ok?0:3;if(!ok) blocked=1;
                }
            }
        }
        if(!installed && !blocked && recorder_control.request>=1 && recorder_control.request<=2 && found==1) {
            int dispatch=sceKernelSuspendDispatchThread();int ok=install_hooks(base,id);sceKernelResumeDispatchThread(dispatch);
            if(!ok) {recorder_control.status=installed?3:2;blocked=installed;recorder_control.request=0;} else state=(uint32_t)arm(base);
        }
        if(found==1 && context(base)) state=(uint32_t)arm(base);
        if(recorder_control.request || recorder_control.request!=previous || recorder_control.status==3) export_chunk(state);
        previous=recorder_control.request;sceKernelDelayThread(100000);
    }
    return 0;
}
int module_stop(SceSize args,void *argp) {
    (void)args;(void)argp;
    /* A preempted game thread may still be inside a plugin stub. Keep this
     * module resident once used; fully closing PPSSPP is the unload boundary. */
    if(ever_installed) return -1;
    stopping=1;
    if(monitor_id>=0 && monitor_id!=sceKernelGetThreadId()) sceKernelTerminateDeleteThread(monitor_id);
    if(fd>=0) sceIoClose(fd);
    return 0;
}
