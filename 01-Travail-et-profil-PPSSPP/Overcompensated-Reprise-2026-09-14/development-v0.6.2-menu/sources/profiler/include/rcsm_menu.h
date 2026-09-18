#ifndef RCSM_MENU_H
#define RCSM_MENU_H
#include <stdint.h>
#define RCSM_MENU_MAX_ORIGINAL 24u
#define RCSM_MENU_ROWS 6u
#define RCSM_MENU_CONFIRM 0x4000u
#define RCSM_MENU_BACK 0x1008u
/* Raw PSP layout: addresses are 32-bit even in host simulations. */
typedef struct { uint32_t w[41]; } RcsmMenuHeader;
typedef struct { uint32_t w[57]; } RcsmMenuNode;
typedef struct {
    uint32_t root_address, child_address, entry_address;
    uint32_t root[RCSM_MENU_MAX_ORIGINAL+2u], child[RCSM_MENU_ROWS+1u];
    uint32_t original_list, original_count;
    RcsmMenuHeader parent;
    unsigned attached, opened;
} RcsmMenu;
void rcsm_menu_init(RcsmMenu *, uint32_t, uint32_t, uint32_t, const uint32_t *);
int rcsm_menu_owned(const RcsmMenu *, const RcsmMenuHeader *);
int rcsm_menu_attach(RcsmMenu *, RcsmMenuHeader *, const uint32_t *);
int rcsm_menu_detach(RcsmMenu *, RcsmMenuHeader *);
uint32_t rcsm_menu_input(RcsmMenu *, RcsmMenuHeader *, uint32_t, uint32_t *);
void rcsm_menu_node(RcsmMenuNode *, uint32_t, int);
#endif
