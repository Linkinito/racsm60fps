#ifndef RCSM_MENU_PROFILES_H
#define RCSM_MENU_PROFILES_H
#include <stdint.h>
typedef struct { uint32_t offset,word,mask; } RcsmMenuGuard;
typedef struct {
 uint32_t module,kind,call,target,menu_hi,menu_lo,modal;
 unsigned guard_count;
 RcsmMenuGuard guards[100];
} RcsmMenuProfile;
extern const RcsmMenuProfile g_rcsm_menu_profiles[];
extern const unsigned g_rcsm_menu_profile_count;
#endif
