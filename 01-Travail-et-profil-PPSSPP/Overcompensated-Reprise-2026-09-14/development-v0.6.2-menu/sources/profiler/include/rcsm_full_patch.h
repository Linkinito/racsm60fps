#ifndef RCSM_FULL_PATCH_H
#define RCSM_FULL_PATCH_H
#include "rcsm_profiler_core.h"
#define RCSM_CAVE_COUNT 8u
#define RCSM_CAVE_WORDS 64u
#define RCSM_FULL_CAPACITY 192u
#define RCSM_FULL_CONTINUOUS 1u
#define RCSM_FULL_OLD_JUMP 2u
#define RCSM_FULL_CAVE_JUMP 4u
#define RCSM_FULL_NEW_JUMP 8u
#define RCSM_FULL_CODE 16u
#define RCSM_FULL_UNLOCK 32u

typedef struct RcsmFullWord {
    uint32_t offset, original, patched;
    uint8_t flags, layer;
} RcsmFullWord;
typedef struct RcsmFullModule {
    uint8_t module_index;
    uint16_t count;
    const RcsmFullWord *words;
    uint32_t cave_return_offsets[RCSM_CAVE_COUNT];
} RcsmFullModule;
typedef struct RcsmFullEntry {
    uint32_t address, original, patched;
    uint8_t flags, owned;
} RcsmFullEntry;
typedef struct RcsmFullState {
    RcsmFullEntry entries[RCSM_FULL_CAPACITY];
    uint16_t count, writes, waiting_constants;
    uint32_t bad_address, bad_word;
    int installed;
} RcsmFullState;
extern const RcsmFullModule g_rcsm_full_modules[];
extern const size_t g_rcsm_full_module_count;
extern const uint32_t g_rcsm_cave_templates[RCSM_CAVE_COUNT][RCSM_CAVE_WORDS];
extern const uint32_t g_rcsm_legacy_cave_addresses[RCSM_CAVE_COUNT];
extern const uint8_t g_rcsm_cave_return_indices[RCSM_CAVE_COUNT];
const RcsmFullModule *rcsm_full_module(uint8_t index);
int rcsm_full_prepare(RcsmFullState *s, uint8_t index, uint32_t base,
                      const uint32_t caves[RCSM_CAVE_COUNT], unsigned layers);
int rcsm_full_preflight(RcsmFullState *s, RcsmReadWord read, void *user);
int rcsm_full_install(RcsmFullState *s, RcsmReadWord read, RcsmWriteWord write,
                     RcsmSyncCode sync, void *user);
unsigned rcsm_full_restore(RcsmFullState *s, RcsmReadWord read, RcsmWriteWord write,
                          RcsmSyncCode sync, void *user);
unsigned rcsm_full_maintain(RcsmFullState *s, RcsmReadWord read, RcsmWriteWord write,
                           RcsmSyncCode sync, void *user);
/* 1: unchanged; 0: original words seen (reload); -1: foreign instruction/data. */
int rcsm_full_health(RcsmFullState *s, RcsmReadWord read, void *user);
#endif
