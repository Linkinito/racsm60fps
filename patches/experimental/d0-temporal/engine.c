/* Shared instruction-local float-step policy. No game callback is skipped.
 * IO is supplied by the guarded PSP monitor; compiled offline tests mock it.
 */
#include <stdint.h>
typedef struct { uint32_t rva, before, after, bit; } Rule;
#include "recipe.generated.h"

volatile uint32_t d0_owned;
uint32_t d0_read(uint32_t address);
int d0_write(uint32_t address, uint32_t value);

static int rollback(uint32_t base, uint32_t initial) {
    unsigned i; int ok=1;
    for(i=RULE_COUNT;i>0;i--) {
        const Rule *r=&rules[i-1];
        uint32_t v,target;
        if(!((d0_owned|initial)&r->bit)) continue;
        v=d0_read(base+r->rva);
        target=(initial&r->bit)?r->after:r->before;
        if(v!=target && (v!=r->before && v!=r->after)) { ok=0; continue; }
        if(v!=target && !d0_write(base+r->rva,target)) { ok=0; continue; }
        if(d0_read(base+r->rva)!=target) { ok=0; continue; }
        d0_owned=(d0_owned&~r->bit)|(initial&r->bit);
    }
    return ok;
}

/* Caller holds suspended dispatch and has verified module/content/core guards.
 * Return >=0 installed mask, -1 preflight refusal/no writes, -2 rollback done,
 * -3 unresolved rollback/ownership retained. No foreign word is overwritten.
 */
int d0_update(uint32_t base, uint32_t wanted) {
    unsigned i; uint32_t initial=d0_owned;
    if(wanted&~3u) return -1;
    for(i=0;i<RULE_COUNT;i++) {
        const Rule *r=&rules[i];
        uint32_t expected=(initial&r->bit)?r->after:r->before;
        if(d0_read(base+r->rva)!=expected) return -1;
    }
    for(i=0;i<RULE_COUNT;i++) {
        const Rule *r=&rules[i]; uint32_t target;
        if((wanted&r->bit)==(initial&r->bit)) continue;
        if(d0_read(base+r->rva)!=((initial&r->bit)?r->after:r->before))
            return rollback(base,initial)?-2:-3;
        target=(wanted&r->bit)?r->after:r->before;
        d0_owned|=r->bit; /* Intent precedes IO: a failed ack may still write. */
        if(!d0_write(base+r->rva,target) || d0_read(base+r->rva)!=target)
            return rollback(base,initial)?-2:-3;
        d0_owned=(d0_owned&~r->bit)|(wanted&r->bit);
    }
    return (int)d0_owned;
}
