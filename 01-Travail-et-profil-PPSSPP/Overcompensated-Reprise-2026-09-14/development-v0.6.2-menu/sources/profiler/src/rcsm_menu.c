#include "rcsm_menu.h"
#include <string.h>
_Static_assert(sizeof(RcsmMenuHeader)==0xa4, "PSP menu header");
_Static_assert(sizeof(RcsmMenuNode)==0xe4, "PSP menu node");
void rcsm_menu_init(RcsmMenu *s,uint32_t root,uint32_t child,uint32_t entry,const uint32_t *nodes) {
    unsigned i;
    memset(s,0,sizeof(*s));
    s->root_address=root; s->child_address=child; s->entry_address=entry;
    for(i=0;i<RCSM_MENU_ROWS;++i) s->child[i]=nodes[i];
}
int rcsm_menu_owned(const RcsmMenu *s,const RcsmMenuHeader *h) {
    return s->attached && h->w[0]==(s->opened?s->child_address:s->root_address) &&
        h->w[1]==(s->opened?RCSM_MENU_ROWS:s->original_count+1u);
}
int rcsm_menu_attach(RcsmMenu *s,RcsmMenuHeader *h,const uint32_t *list) {
    uint32_t n=h->w[1],i;
    if(rcsm_menu_owned(s,h))return 1;
    s->attached=s->opened=0;
    if(!list || !n || n>RCSM_MENU_MAX_ORIGINAL || h->w[2]>=n ||
       !h->w[0] || h->w[0]==s->root_address || h->w[0]==s->child_address)return 0;
    for(i=0;i<n;++i)if(!list[i] || list[i]==s->entry_address)return 0;
    s->original_list=h->w[0]; s->original_count=n;
    memcpy(s->root,list,n*sizeof(uint32_t));
    s->root[n]=s->entry_address; s->root[n+1u]=0;
    h->w[0]=s->root_address; h->w[1]=n+1u; s->attached=1;
    return 1;
}
int rcsm_menu_detach(RcsmMenu *s,RcsmMenuHeader *h) {
    int owned=rcsm_menu_owned(s,h);
    if(owned) {
        if(s->opened)*h=s->parent;
        h->w[0]=s->original_list; h->w[1]=s->original_count;
        if(h->w[2]>=s->original_count)h->w[2]=0;
    }
    s->attached=s->opened=0;
    return owned;
}
static uint32_t next_row(uint32_t row,int down) {
    /* Status, heading and reload hint are not selectable. */
    if(down)return row==1u?2u:row==2u?5u:1u;
    return row==5u?2u:row==2u?1u:5u;
}
uint32_t rcsm_menu_input(RcsmMenu *s,RcsmMenuHeader *h,uint32_t keys,uint32_t *choice) {
    if(!rcsm_menu_owned(s,h))return keys;
    if(s->opened) {
        if((keys&RCSM_MENU_BACK) || ((keys&RCSM_MENU_CONFIRM) && h->w[2]==5u)) {
            *h=s->parent; s->opened=0;
        } else if(keys&RCSM_MENU_CONFIRM) {
            if(h->w[2]==1u)*choice=30u;
            if(h->w[2]==2u)*choice=60u;
        } else if(keys&0x10u)h->w[2]=next_row(h->w[2],0);
        else if(keys&0x40u)h->w[2]=next_row(h->w[2],1);
        return 0; /* Never dispatch own rows to a vanilla screen/quit route. */
    }
    if(keys&RCSM_MENU_BACK) {
        rcsm_menu_detach(s,h);
        return keys;
    }
    if(keys&RCSM_MENU_CONFIRM) {
        if(h->w[2]==s->original_count) {
            s->parent=*h;
            h->w[0]=s->child_address;h->w[1]=RCSM_MENU_ROWS;
            h->w[2]=*choice==30u?1u:2u;
            h->w[5]=0; /* Native simple-list rendering, no inherited scrolling. */
            h->w[0x68/4]=0;
            memset(&h->w[0x80/4],0,0x24);
            s->opened=1;
            return 0;
        }
        rcsm_menu_detach(s,h); /* Preserve every vanilla action and route. */
    }
    return keys;
}
void rcsm_menu_node(RcsmMenuNode *n,uint32_t text,int enabled) {
    unsigned i;
    memset(n,0,sizeof(*n));
    for(i=0;i<4;++i) {
        n->w[i*12+1]=0xffffffffu;
        n->w[i*12+2]=0xffffffffu;
        n->w[i*12+5]=0xffffffffu;
    }
    n->w[0]=text;n->w[3]=1u; /* Direct string, not a localization index. */
    n->w[0xc0/4]=n->w[0xc4/4]=0x3f800000u;
    n->w[0xc8/4]=0xffffffffu;
    n->w[0xcc/4]=0x100u+(enabled?1u:0u);
    n->w[0xd0/4]=0x4f564552u; /* Never reaches vanilla route dispatch. */
}
