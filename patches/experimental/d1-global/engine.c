/* Reversible profile transaction. The monitor supplies resolved, pinned words.
 * Modes: 0 original A0, 1 D1 inferred wrapper policy, 2 C1 core comparison.
 * No injected game caves or game pointers into this plugin are required.
 */
#include <stdint.h>
#define D1_CAPACITY 128u
typedef struct { uint32_t rva, before, after, group; } D1Resolved;
D1Resolved d1_rules[D1_CAPACITY];
uint32_t d1_count;
volatile uint32_t d1_owned;
uint32_t d1_read(uint32_t address);
int d1_write(uint32_t address, uint32_t value);

static uint32_t expected(const D1Resolved *r, uint32_t mode) {
    return mode==1u || (mode==2u && r->group==0u) ? r->after : r->before;
}
static int rollback(uint32_t base,uint32_t initial) {
    unsigned i; int ok=1;
    for(i=d1_count;i>0;i--) {
        const D1Resolved *r=&d1_rules[i-1];
        uint32_t current=d1_read(base+r->rva),target=expected(r,initial);
        if(current!=r->before && current!=r->after) {ok=0;continue;}
        if(current!=target && !d1_write(base+r->rva,target)) {ok=0;continue;}
        if(d1_read(base+r->rva)!=target) ok=0;
    }
    if(ok) d1_owned=initial;
    return ok;
}

/* -1 preflight refusal, -2 failed change rolled back, -3 ownership unresolved.
 * Caller suspends dispatch and verifies identity inside the suspended window.
 */
int d1_update(uint32_t base,uint32_t wanted) {
    unsigned i; uint32_t initial=d1_owned;
    if(wanted>2u || initial>2u || !d1_count || d1_count>D1_CAPACITY) return -1;
    for(i=0;i<d1_count;i++)
        if(d1_read(base+d1_rules[i].rva)!=expected(&d1_rules[i],initial)) return -1;
    for(i=0;i<d1_count;i++) {
        const D1Resolved *r=&d1_rules[i];
        uint32_t old=expected(r,initial),target=expected(r,wanted);
        if(old==target) continue;
        if(d1_read(base+r->rva)!=old) return rollback(base,initial)?-2:-3;
        d1_owned=3u; /* Retain intent if an acknowledged write was not delivered. */
        if(!d1_write(base+r->rva,target) || d1_read(base+r->rva)!=target)
            return rollback(base,initial)?-2:-3;
    }
    d1_owned=wanted;
    return (int)wanted;
}
