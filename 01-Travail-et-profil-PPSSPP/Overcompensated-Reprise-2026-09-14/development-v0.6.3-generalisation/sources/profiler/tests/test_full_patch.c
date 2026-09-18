#include "rcsm_full_patch.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

typedef struct Memory {
    uint32_t address[RCSM_FULL_CAPACITY], word[RCSM_FULL_CAPACITY];
    unsigned count, writes, syncs, fail_write;
} Memory;
static int index_of(Memory *m, uint32_t address) {
    unsigned i;
    for (i=0; i<m->count; ++i) if (m->address[i] == address) return (int)i;
    return -1;
}
static int read_word(uint32_t a, uint32_t *v, void *u) {
    Memory *m=u; int i=index_of(m,a);
    if (i < 0) return -1;
    *v=m->word[i]; return 0;
}
static int write_word(uint32_t a, uint32_t v, void *u) {
    Memory *m=u; int i=index_of(m,a);
    assert(i >= 0);
    ++m->writes;
    if (m->fail_write && m->writes == m->fail_write) return -1;
    m->word[i]=v; return 0;
}
static void sync_code(uint32_t a, uint32_t n, void *u) {
    Memory *m=u;
    assert(index_of(m,a) >= 0 && n == 4);
    ++m->syncs;
}
static void initialize(Memory *m, const RcsmFullState *s) {
    unsigned i;
    memset(m,0,sizeof(*m)); m->count=s->count;
    for (i=0; i<s->count; ++i) {
        m->address[i]=s->entries[i].address;
        m->word[i]=(s->entries[i].flags & RCSM_FULL_CONTINUOUS) ? 0 : s->entries[i].original;
    }
}
static void original_memory(const Memory *m, const RcsmFullState *s, int constants_initialized) {
    unsigned i;
    for (i=0; i<s->count; ++i)
        assert(m->word[i] == (((s->entries[i].flags & RCSM_FULL_CONTINUOUS) && !constants_initialized) ? 0 : s->entries[i].original));
}
int main(void) {
    const int32_t deltas[]={-0x200000,0,0x6000,0x34000,0x400000};
    const uint32_t caves[]={0x08860000,0x08860100,0x08860200,0x08860300,
                            0x08860400,0x08860500,0x08860600,0x08860700};
    unsigned scenarios=0, rollback_positions=0;
    size_t mi,di;
    unsigned mask;
    for (mi=0; mi<g_rcsm_full_module_count; ++mi) {
        const RcsmFullModule *module=&g_rcsm_full_modules[mi];
        for (di=0; di<sizeof(deltas)/sizeof(deltas[0]); ++di) {
          for (mask=1; mask<=15; mask+=2) {
            RcsmFullState s;
            Memory m;
            unsigned i,constants=0,static_count=0;
            uint32_t base=(uint32_t)((int32_t)0x09139D00+deltas[di]);
            assert(rcsm_full_prepare(&s,module->module_index,base,caves,mask));
            initialize(&m,&s);
            assert(rcsm_full_preflight(&s,read_word,&m) && m.writes == 0);
            /* Hard-coded Metalis unlock address/target from LEVEL_04.PRX. */
            if (module->module_index == 4) {
                int ix=index_of(&m,base+0x0009A054);
                assert(ix >= 0);
                assert(m.word[ix] == rcsm_encode_jal(base+0x001D2CE4));
            }
            assert(rcsm_full_install(&s,read_word,write_word,sync_code,&m));
            assert(rcsm_full_health(&s,read_word,&m) == 1);
            for (i=0; i<s.count; ++i) {
                if (s.entries[i].flags & RCSM_FULL_CONTINUOUS) {
                    ++constants;
                    assert(m.word[i] == 0); /* Wait for the game initializer. */
                    m.word[i]=s.entries[i].original;
                } else {
                    ++static_count;
                    assert(m.word[i] == s.entries[i].patched);
                    assert(s.entries[i].owned);
                }
            }
            assert(s.entries[s.count-1].flags & RCSM_FULL_UNLOCK);
            assert(s.waiting_constants == constants);
            assert(rcsm_full_maintain(&s,read_word,write_word,sync_code,&m) == constants);
            assert(s.waiting_constants == 0);
            { unsigned before=m.writes;
              assert(rcsm_full_maintain(&s,read_word,write_word,sync_code,&m) == 0);
              assert(before == m.writes);
            }
            assert(rcsm_full_restore(&s,read_word,write_word,sync_code,&m) == s.count);
            original_memory(&m,&s,1);

            /* One foreign word rejects the whole installation without writes. */
            assert(rcsm_full_prepare(&s,module->module_index,base,caves,mask));
            initialize(&m,&s); m.word[s.count-1]^=1;
            assert(!rcsm_full_install(&s,read_word,write_word,sync_code,&m));
            assert(m.writes == 0 && s.bad_address == m.address[s.count-1]);

            /* Foreign writes after installation are diagnosed and preserved. */
            initialize(&m,&s);
            assert(rcsm_full_install(&s,read_word,write_word,sync_code,&m));
            m.word[s.count-1]=0xDEADBEEF;
            assert(rcsm_full_health(&s,read_word,&m) == -1);
            (void)rcsm_full_restore(&s,read_word,write_word,sync_code,&m);
            assert(m.word[s.count-1] == 0xDEADBEEF);

            /* A partial same-level reload is distinguishable from a foreign patch. */
            assert(rcsm_full_prepare(&s,module->module_index,base,caves,mask));
            initialize(&m,&s);
            assert(rcsm_full_install(&s,read_word,write_word,sync_code,&m));
            m.word[s.count-1]=s.entries[s.count-1].original;
            assert(rcsm_full_health(&s,read_word,&m) == 0);
            (void)rcsm_full_restore(&s,read_word,write_word,sync_code,&m);
            original_memory(&m,&s,0);

            /* Every static write can fail: earlier writes must be rolled back. */
            if (di == 2 && mask == 15) {
                unsigned fault;
                for (fault=1; fault<=static_count; ++fault) {
                    assert(rcsm_full_prepare(&s,module->module_index,base,caves,mask));
                    initialize(&m,&s); m.fail_write=fault;
                    assert(!rcsm_full_install(&s,read_word,write_word,sync_code,&m));
                    assert(!s.installed);
                    original_memory(&m,&s,0);
                    ++rollback_positions;
                }
            }
            ++scenarios;
          }
        }
    }
    {
        RcsmFullState s;
        assert(!rcsm_full_prepare(&s,16,0x09139D00,caves,15));
        assert(!rcsm_full_prepare(&s,1,0x09139D01,caves,15));
        assert(!rcsm_full_prepare(&s,1,0x09FFFFFC,caves,15));
        assert(!rcsm_full_prepare(&s,1,0x09139D00,caves,0));
    }
    printf("full_patch: PASS; %u module/delta/layer scenarios; %u injected write failures\n",scenarios,rollback_positions);
    return 0;
}
