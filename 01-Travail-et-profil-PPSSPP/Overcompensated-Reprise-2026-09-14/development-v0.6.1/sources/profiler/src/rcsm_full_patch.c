#include "rcsm_full_patch.h"
#include <string.h>

#define REFERENCE_BASE 0x09139D00u
static int valid_address(uint32_t a) {
    return a >= 0x08800000u && a <= 0x09FFFFFCu && (a & 3u) == 0u;
}
const RcsmFullModule *rcsm_full_module(uint8_t index) {
    size_t i;
    for (i=0; i<g_rcsm_full_module_count; ++i)
        if (g_rcsm_full_modules[i].module_index == index) return &g_rcsm_full_modules[i];
    return NULL;
}
static int move_jump(uint32_t word, int32_t delta, uint32_t *result) {
    uint32_t target;
    if ((word >> 26u) != 2u && (word >> 26u) != 3u) return 0;
    if (!rcsm_apply_address_delta((word & 0x03FFFFFFu) << 2u, delta, &target) ||
        !valid_address(target)) return 0;
    *result = (word & 0xFC000000u) | (target >> 2u);
    return 1;
}
int rcsm_full_prepare(RcsmFullState *s, uint8_t index, uint32_t base,
                      const uint32_t caves[RCSM_CAVE_COUNT], unsigned layers) {
    const RcsmFullModule *m = rcsm_full_module(index);
    size_t i;
    int32_t delta = (int32_t)base - (int32_t)REFERENCE_BASE;
    if (s == NULL) return 0;
    memset(s, 0, sizeof(*s));
    if (m == NULL || !valid_address(base) || caves == NULL ||
        m->count > RCSM_FULL_CAPACITY || (layers & 1u) == 0u || (layers & ~15u)) return 0;
    for (i=0; i<m->count; ++i) {
        const RcsmFullWord *w = &m->words[i];
        RcsmFullEntry *e;
        if (!(w->layer & layers)) continue;
        e = &s->entries[s->count++];
        if (w->offset > 0x09FFFFFCu-base) return 0;
        e->address = base+w->offset;
        e->original = w->original;
        e->patched = w->patched;
        e->flags = w->flags;
        if (!valid_address(e->address)) return 0;
        if ((w->flags & RCSM_FULL_OLD_JUMP) && !move_jump(w->original,delta,&e->original)) return 0;
        if ((w->flags & RCSM_FULL_NEW_JUMP) && !move_jump(w->patched,delta,&e->patched)) return 0;
        if (w->flags & RCSM_FULL_CAVE_JUMP) {
            if (w->patched >= RCSM_CAVE_COUNT || !valid_address(caves[w->patched]) ||
                !rcsm_jal_reachable(e->address,caves[w->patched])) return 0;
            e->patched = rcsm_encode_j(caves[w->patched]);
        }
    }
    return s->count != 0;
}
int rcsm_full_preflight(RcsmFullState *s, RcsmReadWord read, void *user) {
    size_t i;
    if (s == NULL || read == NULL || s->count == 0 || s->installed) return 0;
    for (i=0; i<s->count; ++i) {
        RcsmFullEntry *e=&s->entries[i];
        uint32_t word=0;
        if (e->flags & RCSM_FULL_CONTINUOUS) continue;
        if (read(e->address,&word,user) != 0 || word != e->original) {
            s->bad_address=e->address; s->bad_word=word;
            return 0;
        }
    }
    return 1;
}
unsigned rcsm_full_restore(RcsmFullState *s, RcsmReadWord read, RcsmWriteWord write,
                          RcsmSyncCode sync, void *user) {
    size_t i;
    unsigned restored=0;
    if (s == NULL || read == NULL || write == NULL || sync == NULL) return 0;
    /* VBlank is the last installed static correction, so it is restored first. */
    for (i=s->count; i>0; --i) {
        RcsmFullEntry *e=&s->entries[i-1];
        uint32_t word;
        if (e->owned && read(e->address,&word,user) == 0 && word == e->patched &&
            write(e->address,e->original,user) == 0) {
            sync(e->address,4u,user); ++restored;
            e->owned=0;
        }
    }
    s->installed=0;
    return restored;
}
unsigned rcsm_full_maintain(RcsmFullState *s, RcsmReadWord read, RcsmWriteWord write,
                           RcsmSyncCode sync, void *user) {
    size_t i;
    unsigned updated=0;
    if (s == NULL || !s->installed || read == NULL || write == NULL || sync == NULL) return 0;
    s->waiting_constants=0;
    for (i=0; i<s->count; ++i) {
        RcsmFullEntry *e=&s->entries[i];
        uint32_t word;
        if (!(e->flags & RCSM_FULL_CONTINUOUS)) continue;
        if (read(e->address,&word,user) != 0) { ++s->waiting_constants; continue; }
        if (word == e->patched) continue;
        /* The game's initializer owns zero/unrecognized values. Never overwrite them. */
        if (word != e->original) { ++s->waiting_constants; continue; }
        if (write(e->address,e->patched,user) == 0) {
            e->owned=1; sync(e->address,4u,user); ++updated;
        } else ++s->waiting_constants;
    }
    return updated;
}
int rcsm_full_install(RcsmFullState *s, RcsmReadWord read, RcsmWriteWord write,
                     RcsmSyncCode sync, void *user) {
    size_t i;
    if (write == NULL || sync == NULL || !rcsm_full_preflight(s,read,user)) return 0;
    for (i=0; i<s->count; ++i) {
        RcsmFullEntry *e=&s->entries[i];
        uint32_t check=0;
        if (e->flags & RCSM_FULL_CONTINUOUS) continue;
        if (write(e->address,e->patched,user) != 0) {
            s->bad_address=e->address;
            (void)rcsm_full_restore(s,read,write,sync,user); return 0;
        }
        e->owned=1;
        sync(e->address,4u,user);
        if (read(e->address,&check,user) != 0 || check != e->patched) {
            s->bad_address=e->address; s->bad_word=check;
            (void)rcsm_full_restore(s,read,write,sync,user); return 0;
        }
        ++s->writes;
    }
    s->installed=1;
    (void)rcsm_full_maintain(s,read,write,sync,user);
    return 1;
}
int rcsm_full_health(RcsmFullState *s, RcsmReadWord read, void *user) {
    size_t i;
    int status=1;
    if (s == NULL || read == NULL || !s->installed) return 1;
    for (i=0; i<s->count; ++i) {
        RcsmFullEntry *e=&s->entries[i];
        uint32_t word=0;
        if (e->flags & RCSM_FULL_CONTINUOUS) continue;
        if (read(e->address,&word,user) != 0 || (word != e->patched && word != e->original)) {
            s->bad_address=e->address; s->bad_word=word; return -1;
        }
        if (word != e->patched) status=0;
    }
    return status;
}
