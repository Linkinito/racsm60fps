#ifndef RCSM_FPS_CHOICE_H
#define RCSM_FPS_CHOICE_H
#include <stdint.h>
typedef struct RcsmFpsChoice { uint32_t requested, selected, applied; } RcsmFpsChoice;
int rcsm_fps_request(RcsmFpsChoice *s, uint32_t fps);
uint32_t rcsm_fps_begin_module(RcsmFpsChoice *s);
int rcsm_fps_confirm(RcsmFpsChoice *s, uint32_t fps);
void rcsm_fps_leave_module(RcsmFpsChoice *s);
int rcsm_fps_pending(const RcsmFpsChoice *s);
#endif
