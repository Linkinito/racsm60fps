#include "rcsm_menu.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static void context(unsigned count) {
    RcsmMenu s;RcsmMenuHeader h={{0}}, original;uint32_t list[24],nodes[6]={200,204,208,212,216,220};
    uint32_t choice=60,i;
    for(i=0;i<count;++i)list[i]=1000+4*i;
    h.w[0]=100;h.w[1]=count;h.w[2]=count-1;h.w[5]=10;h.w[26]=17;
    h.w[32]=23;original=h;
    rcsm_menu_init(&s,500,600,700,nodes);
    assert(rcsm_menu_attach(&s,&h,list));
    assert(!memcmp(s.root,list,count*4));assert(s.root[count]==700);assert(s.root[count+1]==0);
    assert(rcsm_menu_input(&s,&h,0x40,&choice)==0x40);
    h.w[2]=count;
    assert(!rcsm_menu_input(&s,&h,0x4000,&choice));assert(s.opened&&h.w[2]==2);
    assert(!rcsm_menu_input(&s,&h,0x10,&choice));assert(h.w[2]==1);
    assert(!rcsm_menu_input(&s,&h,0x4000,&choice));assert(choice==30);
    assert(!rcsm_menu_input(&s,&h,0x40,&choice));assert(h.w[2]==2);
    assert(!rcsm_menu_input(&s,&h,0x4000,&choice));assert(choice==60);
    assert(!rcsm_menu_input(&s,&h,0x1000,&choice));assert(!s.opened&&h.w[2]==count);
    assert(h.w[5]==original.w[5]&&h.w[26]==17&&h.w[32]==23);
    assert(!rcsm_menu_input(&s,&h,0x4000,&choice));
    assert(!rcsm_menu_input(&s,&h,0x40,&choice));assert(h.w[2]==5);
    assert(!rcsm_menu_input(&s,&h,0x4000,&choice));assert(!s.opened);
    h.w[2]=count-1;
    assert(rcsm_menu_input(&s,&h,0x4000,&choice)==0x4000);
    assert(!memcmp(&h,&original,sizeof(h)));assert(!s.attached);
    assert(rcsm_menu_attach(&s,&h,list));
    assert(rcsm_menu_input(&s,&h,8,&choice)==8);assert(!memcmp(&h,&original,sizeof(h)));
    assert(rcsm_menu_attach(&s,&h,list));
    h.w[0]=1234;h.w[1]=3;original=h;
    assert(!rcsm_menu_detach(&s,&h));assert(!memcmp(&h,&original,sizeof(h)));
    /* Rebuilt vanilla header can be attached; foreign owned counts cannot. */
    h.w[0]=100;h.w[1]=count;h.w[2]=0;
    assert(rcsm_menu_attach(&s,&h,list));
    h.w[1]++;original=h;
    assert(!rcsm_menu_attach(&s,&h,list));assert(!memcmp(&h,&original,sizeof(h)));
}
int main(void) {
    RcsmMenuNode node;RcsmMenu s;RcsmMenuHeader h={{0}};uint32_t nodes[6]={1,2,3,4,5,6},list[24]={0};unsigned i;
    for(i=1;i<=24;++i)context(i); /* Includes main, seven-item pause, two-item challenge. */
    rcsm_menu_node(&node,0x09001234,1);
    assert(node.w[0]==0x09001234&&node.w[3]==1&&node.w[0xcc/4]==0x101);
    assert(node.w[2]==0xffffffffu&&node.w[0xc8/4]==0xffffffffu);
    rcsm_menu_init(&s,500,600,700,nodes);
    assert(!rcsm_menu_attach(&s,&h,list));
    h.w[0]=100;h.w[1]=25;assert(!rcsm_menu_attach(&s,&h,list));
    h.w[1]=1;assert(!rcsm_menu_attach(&s,&h,list));
    puts("PASS native menu ownership, routing, three contexts, 24 list sizes, rebuild and bounds");
    return 0;
}
