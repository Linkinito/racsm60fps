#include "rcsm_fps_choice.h"
#include <stddef.h>
int rcsm_fps_request(RcsmFpsChoice *s, uint32_t fps) {
    if (s == NULL || (fps != 30u && fps != 60u)) return 0;
    s->requested = fps;
    return 1;
}
uint32_t rcsm_fps_begin_module(RcsmFpsChoice *s) {
    if (s == NULL || (s->requested != 30u && s->requested != 60u)) return 0u;
    s->selected = s->requested;
    s->applied = 0u;
    return s->selected;
}
int rcsm_fps_confirm(RcsmFpsChoice *s, uint32_t fps) {
    if (s == NULL || (fps != 30u && fps != 60u) || s->selected != fps) return 0;
    s->applied = fps;
    return 1;
}
void rcsm_fps_leave_module(RcsmFpsChoice *s) {
    if (s != NULL) { s->selected = 0u; s->applied = 0u; }
}
int rcsm_fps_pending(const RcsmFpsChoice *s) {
    return s != NULL && s->requested != s->applied;
}
