#include "rcsm_fps_choice.h"
#include <assert.h>
#include <stdio.h>
int main(void) {
    RcsmFpsChoice s = {60u,0u,0u};
    assert(rcsm_fps_pending(&s));
    assert(rcsm_fps_begin_module(&s)==60u);
    assert(!rcsm_fps_confirm(&s,30u));
    assert(s.applied==0u); /* An unverified installation is never advertised. */
    assert(rcsm_fps_confirm(&s,60u));
    assert(!rcsm_fps_pending(&s));
    assert(rcsm_fps_request(&s,30u));
    assert(s.applied==60u && s.selected==60u && rcsm_fps_pending(&s));
    assert(!rcsm_fps_request(&s,120u) && s.requested==30u);
    assert(rcsm_fps_request(&s,60u) && !rcsm_fps_pending(&s));
    assert(rcsm_fps_request(&s,30u));
    rcsm_fps_leave_module(&s);
    assert(s.applied==0u && s.selected==0u && s.requested==30u);
    assert(rcsm_fps_begin_module(&s)==30u && rcsm_fps_confirm(&s,30u));
    assert(!rcsm_fps_pending(&s));
    assert(rcsm_fps_request(&s,60u) && s.applied==30u);
    rcsm_fps_leave_module(&s);
    assert(rcsm_fps_begin_module(&s)==60u && s.applied==0u);
    assert(rcsm_fps_request(&s,30u)); /* Request arriving during installation. */
    assert(rcsm_fps_confirm(&s,60u) && rcsm_fps_pending(&s));
    assert(!rcsm_fps_request(NULL,30u));
    puts("fps_choice: PASS; deferred request, cancellation, failure and both directions");
    return 0;
}
