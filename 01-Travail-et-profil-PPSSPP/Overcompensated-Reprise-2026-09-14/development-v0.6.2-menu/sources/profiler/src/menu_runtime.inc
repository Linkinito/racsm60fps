/* Included by psp_plugin_runtime.c after the guarded memory helpers. */
#include "rcsm_menu.h"
#include "rcsm_menu_profiles.h"
#define RCSM_FPS_PATH "ms0:/PSP/PLUGINS/SizeMattersWrapperProfiler/Overcompensated.fps"
volatile uint32_t g_rcsm_menu_active_hooks=0u;
volatile uint32_t g_rcsm_menu_installed=0u;
volatile uint32_t g_rcsm_menu_open=0u;
volatile uint32_t g_rcsm_menu_last_context=0xffffffffu;
volatile uint32_t g_rcsm_fps_saved=0u;
typedef struct {
    const RcsmMenuProfile *profile;
    uint32_t base,menu,modal,original,redirect;
    RcsmMenu model;
    RcsmMenuNode entry,nodes[RCSM_MENU_ROWS];
    char status[64],hint[64];
} RcsmNativeMenu;
static RcsmNativeMenu g_menus[3];
extern void rcsm_menu_hook_0(void),rcsm_menu_hook_1(void),rcsm_menu_hook_2(void);
extern uint32_t rcsm_menu_original_0,rcsm_menu_original_1,rcsm_menu_original_2;
static void (*const g_menu_hooks[3])(void)={rcsm_menu_hook_0,rcsm_menu_hook_1,rcsm_menu_hook_2};
static uint32_t *const g_menu_originals[3]={&rcsm_menu_original_0,&rcsm_menu_original_1,&rcsm_menu_original_2};
static uint32_t menu_addr(const void *p){return (uint32_t)(uintptr_t)p;}
static int menu_range(uint32_t a,uint32_t n){return a>=0x08800000u && a<=0x0a000000u-n && !(a&3u);}
static int menu_resolve_pair(uint32_t base,uint32_t hi,uint32_t lo,int load,uint32_t *out) {
    uint32_t h,l;
    if(read_patch_word(base+hi,&h,NULL) || read_patch_word(base+lo,&l,NULL))return 0;
    if((h>>26)!=15u || (l>>26)!=(load?35u:9u) || ((h>>16)&31u)!=((l>>21)&31u))return 0;
    *out=((h&65535u)<<16)+(int16_t)(l&65535u);
    return menu_range(*out,load?4u:sizeof(RcsmMenuHeader));
}
static int menu_profile_ok(const RcsmMenuProfile *p,uint32_t base,uint32_t redirect) {
    unsigned i;uint32_t w;
    if(!menu_range(base,4u))return 0;
    for(i=0;i<p->guard_count;++i) {
        const RcsmMenuGuard *g=&p->guards[i];
        if(!menu_range(base+g->offset,4u) || read_patch_word(base+g->offset,&w,NULL))return 0;
        if(g->offset==p->call && redirect && w==redirect)continue;
        if((w&g->mask)!=g->word)return 0;
    }
    if(read_patch_word(base+p->call,&w,NULL))return 0;
    return w==rcsm_encode_jal(base+p->target) || (redirect && w==redirect);
}
static void menu_labels(RcsmNativeMenu *m) {
    const char *active=g_rcsm_applied_fps==30u?"Actif : 30 FPS":g_rcsm_applied_fps==60u?"Actif : 60 FPS":"Actif : menu principal";
    const char *hint=g_rcsm_requested_fps!=g_rcsm_applied_fps?"Recharger le jeu pour appliquer":"Mode applique au niveau";
    /* Persistent strings live in PRX memory, not on a hook's stack. */
    strcpy(m->status,active);
    strcpy(m->hint,hint);
    if(g_rcsm_fps_saved!=g_rcsm_requested_fps)strcpy(m->hint,"Enregistrement du choix...");
    m->nodes[1].w[0]=menu_addr(g_rcsm_requested_fps==30u?"30 FPS (choisi)":"30 FPS");
    m->nodes[2].w[0]=menu_addr(g_rcsm_requested_fps==60u?"60 FPS (choisi)":"60 FPS");
}
uint32_t rcsm_menu_hook_c(uint32_t kind,uint32_t keys) {
    RcsmNativeMenu *m;RcsmMenuHeader *h;uint32_t *list,choice;unsigned i;
    if(kind>=3u)return keys;
    m=&g_menus[kind];
    if(!m->profile || !menu_range(m->menu,sizeof(*h)))return keys;
    if(m->modal && *(volatile uint32_t *)(uintptr_t)m->modal)return keys;
    h=(RcsmMenuHeader *)(uintptr_t)m->menu;
    if(!rcsm_menu_owned(&m->model,h)) {
        /* A reconstructed menu owns its new header; never restore the old snapshot. */
        m->model.attached=m->model.opened=0;
        if(!h->w[1] || h->w[1]>RCSM_MENU_MAX_ORIGINAL || h->w[2]>=h->w[1] ||
           !menu_range(h->w[0],h->w[1]*4u))return keys;
        list=(uint32_t *)(uintptr_t)h->w[0];
        for(i=0;i<h->w[1];++i)if(!menu_range(list[i],sizeof(RcsmMenuNode)))return keys;
        if(!rcsm_menu_attach(&m->model,h,list))return keys;
    }
    menu_labels(m);
    choice=g_rcsm_requested_fps;
    keys=rcsm_menu_input(&m->model,h,keys,&choice);
    g_rcsm_requested_fps=choice;
    g_rcsm_menu_open=m->model.opened;
    g_rcsm_menu_last_context=kind;
    return keys;
}
static int menu_prepare(RcsmNativeMenu *m,const RcsmMenuProfile *p,uint32_t base) {
    uint32_t a,modal=0,nodes[RCSM_MENU_ROWS];unsigned i;
    const char *labels[RCSM_MENU_ROWS]={"OVERCOMPENSATED","30 FPS","60 FPS",m->status,m->hint,"Retour"};
    if(!menu_resolve_pair(base,p->menu_hi,p->menu_lo,0,&a))return 0;
    if(p->modal && !menu_resolve_pair(base,p->modal,p->modal+4u,1,&modal))return 0;
    memset(m,0,sizeof(*m));
    m->base=base;m->menu=a;m->modal=modal;
    m->original=rcsm_encode_jal(base+p->target);
    m->redirect=rcsm_encode_jal((uint32_t)(uintptr_t)g_menu_hooks[p->kind]);
    if(!rcsm_jal_reachable(base+p->call,(uint32_t)(uintptr_t)g_menu_hooks[p->kind]) ||
       !rcsm_jal_reachable(menu_addr(g_menu_originals[p->kind]),base+p->target))return 0;
    for(i=0;i<RCSM_MENU_ROWS;++i) {
        rcsm_menu_node(&m->nodes[i],menu_addr(labels[i]),i==1u||i==2u||i==5u);
        nodes[i]=menu_addr(&m->nodes[i]);
    }
    rcsm_menu_node(&m->entry,menu_addr("Overcompensated"),1);
    rcsm_menu_init(&m->model,menu_addr(m->model.root),menu_addr(m->model.child),menu_addr(&m->entry),nodes);
    *g_menu_originals[p->kind]=m->original;
    sync_game_code(menu_addr(g_menu_originals[p->kind]),4u,NULL);
    m->profile=p;
    return 1;
}
static void menu_monitor(const RcsmRuntimeDetection *detected) {
    unsigned i,installed=0;uint32_t index;int lock;
    if(g_config.mode!=RCSM_MODE_GLOBAL_60FPS || detected->module_api_status!=RCSM_MODULE_API_FOUND)return;
    index=detected->reference_profile?detected->reference_profile->module_index:0u;
    lock=sceKernelSuspendDispatchThread();if(lock<0)return;
    if(g_rcsm_menu_active_hooks){(void)sceKernelResumeDispatchThread(lock);return;}
    for(i=0;i<3u;++i) {
        RcsmNativeMenu *m=&g_menus[i];uint32_t word;
        if(!m->profile)continue;
        if(m->base!=detected->runtime_base || m->profile->module!=index) {
            /* Loader owns old module memory. No stale restores. */
            memset(m,0,sizeof(*m));continue;
        }
        if(!menu_profile_ok(m->profile,m->base,m->redirect))continue;
        if(!read_patch_word(m->base+m->profile->call,&word,NULL) && word==m->original) {
            /* Same-address reload restored native code: discard old menu state. */
            memset(m,0,sizeof(*m));
        }
    }
    for(i=0;i<g_rcsm_menu_profile_count;++i) {
        const RcsmMenuProfile *p=&g_rcsm_menu_profiles[i];RcsmNativeMenu *m=&g_menus[p->kind];
        if(p->module!=index || m->profile)continue;
        if(menu_profile_ok(p,detected->runtime_base,0u) && menu_prepare(m,p,detected->runtime_base)) {
            if(write_game_word(m->base+p->call,m->redirect,NULL)==0)
                sync_game_code(m->base+p->call,4u,NULL);
            else memset(m,0,sizeof(*m));
        }
    }
    for(i=0;i<3u;++i)if(g_menus[i].profile)installed|=1u<<i;
    g_rcsm_menu_installed=installed;
    (void)sceKernelResumeDispatchThread(lock);
}
static void menu_stop(void) {
    unsigned i;uint32_t base=0,word;int lock;
    if(query_level_module_base(&base)!=RCSM_MODULE_API_FOUND)return;
    lock=sceKernelSuspendDispatchThread();if(lock<0)return;
    if(g_rcsm_menu_active_hooks){(void)sceKernelResumeDispatchThread(lock);return;}
    for(i=0;i<3u;++i) {
        RcsmNativeMenu *m=&g_menus[i];
        if(!m->profile || m->base!=base || !menu_profile_ok(m->profile,base,m->redirect))continue;
        if(!read_patch_word(base+m->profile->call,&word,NULL) && word==m->redirect) {
            rcsm_menu_detach(&m->model,(RcsmMenuHeader *)(uintptr_t)m->menu);
            write_game_word(base+m->profile->call,m->original,NULL);
            sync_game_code(base+m->profile->call,4u,NULL);
        }
    }
    (void)sceKernelResumeDispatchThread(lock);
}
/* A separate sidecar leaves native game saves and the INI intact.
   This tiny preference is not an atomic game save: a partial write is rejected
   at next boot and falls back to the INI. No destination-replacing rename is
   assumed, since the PSP filesystem may reject an existing destination. */
static void menu_load_choice(void) {
    char b[4]={0};SceUID fd=sceIoOpen(RCSM_FPS_PATH,PSP_O_RDONLY,0);int n;
    if(fd<0)return;
    n=sceIoRead(fd,b,sizeof(b));sceIoClose(fd);
    if(n==3 && b[2]=='\n' && b[1]=='0' && (b[0]=='3'||b[0]=='6')) {
        uint32_t fps=b[0]=='3'?30u:60u;
        if(rcsm_fps_request(&g_fps_choice,fps)){g_rcsm_requested_fps=fps;g_rcsm_fps_saved=fps;}
    }
}
static void menu_save_choice(void) {
    uint32_t fps=g_fps_choice.requested;const char *data=fps==30u?"30\n":"60\n";SceUID fd;int n,closed;
    if(g_config.mode!=RCSM_MODE_GLOBAL_60FPS || g_rcsm_fps_saved==fps)return;
    fd=sceIoOpen(RCSM_FPS_PATH,PSP_O_WRONLY|PSP_O_CREAT|PSP_O_TRUNC,0666);if(fd<0)return;
    n=sceIoWrite(fd,data,3);closed=sceIoClose(fd);
    if(n==3 && closed>=0) {
        g_rcsm_fps_saved=fps;log_line("menu frame_rate saved=%u",(unsigned)fps);
    }
}
