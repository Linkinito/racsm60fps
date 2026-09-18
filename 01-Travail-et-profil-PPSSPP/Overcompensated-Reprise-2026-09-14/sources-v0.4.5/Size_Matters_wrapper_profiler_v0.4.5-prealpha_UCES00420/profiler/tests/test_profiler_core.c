#include "rcsm_profiler_core.h"
#include "wrapper_profiles.generated.h"

#include <assert.h>
#include <stdio.h>
#include <string.h>

typedef struct TestMemory {
    const RcsmModuleProfile *profile;
    int32_t address_delta;
    uint32_t entry_word_0_override;
} TestMemory;

typedef struct PatchMemory {
    uint32_t addresses[RCSM_MAX_ACTIVE_CALLS];
    uint32_t words[RCSM_MAX_ACTIVE_CALLS];
    size_t count;
    size_t syncs;
    size_t writes;
    size_t fail_write_at;
} PatchMemory;

static int read_test_word(uint32_t address, uint32_t *value, void *user) {
    const TestMemory *memory = (const TestMemory *)user;
    size_t index;
    for (index = 0; index < g_rcsm_detection_anchor_count; ++index) {
        uint32_t runtime_address = 0u;
        assert(rcsm_apply_address_delta(
            g_rcsm_detection_addresses[index], memory->address_delta, &runtime_address
        ));
        if (runtime_address == address) {
            *value = memory->profile->expected_detection_words[index];
            return 0;
        }
    }
    for (index = 0; index < 4u; ++index) {
        uint32_t runtime_address = 0u;
        assert(rcsm_apply_address_delta(
            memory->profile->two_pass_entry + (uint32_t)(index * 4u),
            memory->address_delta,
            &runtime_address
        ));
        if (runtime_address == address) {
            *value = index == 0u && memory->entry_word_0_override != 0u
                ? memory->entry_word_0_override
                : memory->profile->expected_entry_words[index];
            return 0;
        }
    }
    {
        uint32_t runtime_suppression = 0u;
        uint32_t runtime_inner = 0u;
        assert(rcsm_apply_address_delta(
            memory->profile->suppression_site, memory->address_delta, &runtime_suppression
        ));
        assert(rcsm_apply_address_delta(
            memory->profile->one_pass_inner, memory->address_delta, &runtime_inner
        ));
        if (runtime_suppression == address) {
            *value = rcsm_encode_jal(runtime_inner);
            return 0;
        }
    }
    return -1;
}

static int read_patch_word(uint32_t address, uint32_t *value, void *user) {
    PatchMemory *memory = (PatchMemory *)user;
    size_t index;
    for (index = 0; index < memory->count; ++index) {
        if (memory->addresses[index] == address) {
            *value = memory->words[index];
            return 0;
        }
    }
    return -1;
}

static int write_patch_word(uint32_t address, uint32_t value, void *user) {
    PatchMemory *memory = (PatchMemory *)user;
    size_t index;
    ++memory->writes;
    if (memory->fail_write_at != 0u && memory->writes == memory->fail_write_at) {
        return -1;
    }
    for (index = 0; index < memory->count; ++index) {
        if (memory->addresses[index] == address) {
            memory->words[index] = value;
            return 0;
        }
    }
    return -1;
}

static void sync_patch_word(uint32_t address, uint32_t size, void *user) {
    PatchMemory *memory = (PatchMemory *)user;
    (void)address;
    assert(size == 4u);
    ++memory->syncs;
}

int main(void) {
    size_t module_index;
    size_t total = 0u;
    size_t maximum = 0u;
    RcsmProfiler profiler;

    assert(g_rcsm_module_profile_count == 15u);
    assert(g_rcsm_total_callsite_count == 493u);
    assert(g_rcsm_detection_anchor_count > 0u);
    assert(g_rcsm_detection_anchor_count <= RCSM_MAX_DETECTION_ANCHORS);
    assert(g_rcsm_detection_anchor_count == 1u);
    assert(g_rcsm_reference_level_base == 0x09139D00u);
    assert(g_rcsm_detection_addresses[0] == 0x09148800u);
    assert(g_rcsm_module_profiles[0].expected_detection_words[0] == 0xC60E0000u);
    assert(g_rcsm_module_profiles[1].expected_detection_words[0] == 0xC6000008u);

    for (module_index = 0; module_index < g_rcsm_module_profile_count; ++module_index) {
        const RcsmModuleProfile *profile = &g_rcsm_module_profiles[module_index];
        const RcsmModuleProfile *identified;
        TestMemory memory = {profile, 0, 0u};
        unsigned matches = 0u;
        size_t callsite_index;
        assert(rcsm_validate_profile(profile));
        assert(rcsm_find_module_profile(profile->module_index) == profile);
        assert(profile->expected_suppression_word != rcsm_encode_jal(profile->one_pass_inner));
        identified = rcsm_identify_module(read_test_word, &memory, &matches);
        assert(identified != NULL);
        assert(matches >= 1u);
        assert(rcsm_profiles_equivalent(identified, profile));
        total += profile->callsite_count;
        if (profile->callsite_count > maximum) {
            maximum = profile->callsite_count;
        }
        for (callsite_index = 0; callsite_index < profile->callsite_count; ++callsite_index) {
            assert(profile->callsites[callsite_index].family_id >= 1u);
            assert(profile->callsites[callsite_index].family_id <= 59u);
            assert(profile->callsites[callsite_index].policy == RCSM_POLICY_VANILLA);
        }
    }
    assert(total == 493u);
    assert(maximum == 57u);
    assert(rcsm_is_ppsspp_emuhack(0x680B029Au));
    assert(rcsm_is_ppsspp_emuhack(0x682BACB6u));
    assert(rcsm_is_ppsspp_emuhack(0x6BFFFFFFu));
    assert(!rcsm_is_ppsspp_emuhack(0x27BDFFC0u));
    assert(!rcsm_is_ppsspp_emuhack(0x6C000000u));

    /* PPSSPP remplace le premier mot d'un bloc compilé par un marqueur
       0x68xxxxxx. Les trois autres mots du prologue et le jal interne restent
       exigés à l'identique, de sorte qu'un mot étranger reste refusé. */
    {
        const RcsmModuleProfile *reference = rcsm_find_module_profile(1u);
        unsigned matches = 0u;
        TestMemory jit_memory = {reference, 0x7000, 0x682BACB6u};
        TestMemory foreign_memory = {reference, 0x7000, 0x70000000u};
        assert(reference != NULL);
        assert(rcsm_identify_module_at_delta(
            read_test_word, &jit_memory, 0x7000, &matches
        ) == reference);
        assert(matches == 1u);
        assert(rcsm_identify_module_at_delta(
            read_test_word, &foreign_memory, 0x7000, &matches
        ) == NULL);
        assert(matches == 0u);
    }

    /* Reproduit exactement l'effet observateur de la v0.4.1 : le PRX de
       profilage occupe 0x6000 octets et rcp1 est chargé 0x6000 plus haut. */
    {
        const int32_t delta = 0x6000;
        const RcsmModuleProfile *reference = rcsm_find_module_profile(1u);
        RcsmModuleProfile runtime;
        RcsmCallsiteProfile relocated[RCSM_MAX_ACTIVE_CALLS];
        RcsmModuleMatch scan;
        TestMemory memory = {reference, delta, 0u};
        const RcsmModuleProfile *identified;
        unsigned matches = 0u;
        size_t index;
        assert(reference != NULL);
        assert(rcsm_identify_module(read_test_word, &memory, &matches) == NULL);
        identified = rcsm_identify_module_at_delta(read_test_word, &memory, delta, &matches);
        assert(identified == reference);
        assert(matches == 1u);
        assert(rcsm_scan_module_deltas(
            read_test_word, &memory, 0, 0x10000, 0x1000u, &scan
        ));
        assert(scan.profile == reference);
        assert(scan.address_delta == delta);
        assert(scan.candidate_count == 1u);
        assert(rcsm_relocate_profile(
            reference, delta, &runtime, relocated, RCSM_MAX_ACTIVE_CALLS
        ));
        assert(runtime.two_pass_entry == reference->two_pass_entry + (uint32_t)delta);
        assert(runtime.one_pass_inner == reference->one_pass_inner + (uint32_t)delta);
        assert(runtime.suppression_site == reference->suppression_site + (uint32_t)delta);
        for (index = 0u; index < runtime.callsite_count; ++index) {
            assert(runtime.callsites[index].ra == reference->callsites[index].ra + (uint32_t)delta);
        }
        assert(rcsm_encode_j(runtime.two_pass_entry) ==
               (0x08000000u | ((runtime.two_pass_entry >> 2u) & 0x03FFFFFFu)));
    }
    {
        uint32_t address = 0u;
        assert(rcsm_apply_address_delta(0x09139D00u, -0x1000, &address));
        assert(address == 0x09138D00u);
        assert(!rcsm_apply_address_delta(0x09139D00u, 1, &address));
        assert(!rcsm_apply_address_delta(0xFFFFFFFCu, 4, &address));
    }

    assert(rcsm_bind_profile(&profiler, rcsm_find_module_profile(1u)));
    {
        uint32_t ra = profiler.profile->callsites[0].ra;
        int slot = rcsm_record_hit(&profiler, ra, 100u);
        assert(slot == 0);
        assert(rcsm_record_hit(&profiler, ra, 100u) == 0);
        assert(rcsm_record_hit(&profiler, ra, 102u) == 0);
        assert(rcsm_record_hit(&profiler, ra, 102u) == 0);
        assert(rcsm_record_hit(&profiler, ra, 102u) == 0);
        assert(rcsm_record_hit(&profiler, ra, 103u) == 0);
        assert(rcsm_record_hit(&profiler, ra, 110u) == 0);
        assert(profiler.stats[0].hits == 7u);
        assert(profiler.stats[0].first_sample == 100u);
        assert(profiler.stats[0].last_sample == 110u);
        assert(profiler.stats[0].active_vblanks == 4u);
        assert(profiler.stats[0].same_vblank_hits == 3u);
        assert(profiler.stats[0].max_hits_per_vblank == 3u);
        assert(profiler.stats[0].current_vblank_hits == 1u);
        assert(profiler.stats[0].gap_1_vblank == 1u);
        assert(profiler.stats[0].gap_2_vblank == 1u);
        assert(profiler.stats[0].gap_other_vblank == 1u);
    }
    assert(rcsm_record_hit(&profiler, 0xDEADBEEFu, 130u) == -1);
    assert(profiler.unknown_hits == 1u);
    assert(rcsm_stat_at(&profiler, profiler.profile->callsite_count) == NULL);

    {
        const RcsmModuleProfile *reference = rcsm_find_module_profile(1u);
        RcsmModuleProfile runtime;
        RcsmCallsiteProfile relocated[RCSM_MAX_ACTIVE_CALLS];
        const RcsmModuleProfile *profile = &runtime;
        const int32_t delta = 0x6000;
        const uint32_t hook_target = 0x08810000u;
        uint32_t original_word;
        const uint32_t hook_word = rcsm_encode_jal(hook_target);
        RcsmPatchResult result;
        RcsmRedirectState state;
        PatchMemory memory;
        size_t index;
        assert(reference != NULL);
        assert(rcsm_relocate_profile(
            reference, delta, &runtime, relocated, RCSM_MAX_ACTIVE_CALLS
        ));
        original_word = rcsm_encode_jal(profile->two_pass_entry);
        memset(&memory, 0, sizeof(memory));
        memory.count = profile->callsite_count;
        for (index = 0; index < memory.count; ++index) {
            memory.addresses[index] = profile->callsites[index].ra - 8u;
            memory.words[index] = original_word;
            assert(rcsm_jal_reachable(memory.addresses[index], hook_target));
        }
        assert(rcsm_install_callsite_redirects(
            profile, hook_target, read_patch_word, write_patch_word, sync_patch_word, &memory, &result
        ));
        assert(result.examined == profile->callsite_count);
        assert(result.modified == profile->callsite_count);
        assert(memory.syncs == profile->callsite_count);
        for (index = 0; index < memory.count; ++index) {
            assert(memory.words[index] == hook_word);
        }
        assert(rcsm_classify_callsite_redirects(profile, hook_target, read_patch_word, &memory, &state));
        assert(state.examined == profile->callsite_count);
        assert(state.redirected == profile->callsite_count);
        assert(state.original == 0u);
        assert(state.foreign == 0u);
        assert(state.unreadable == 0u);
        assert(rcsm_remove_callsite_redirects(
            profile, hook_target, read_patch_word, write_patch_word, sync_patch_word, &memory, &result
        ));
        assert(result.modified == profile->callsite_count);
        for (index = 0; index < memory.count; ++index) {
            assert(memory.words[index] == original_word);
        }
        assert(rcsm_classify_callsite_redirects(profile, hook_target, read_patch_word, &memory, &state));
        assert(state.original == profile->callsite_count);
        assert(state.redirected == 0u);

        /* One mismatched word must block the complete installation preflight. */
        memory.words[0] = 0u;
        memory.syncs = 0u;
        assert(!rcsm_install_callsite_redirects(
            profile, hook_target, read_patch_word, write_patch_word, sync_patch_word, &memory, &result
        ));
        assert(result.mismatched == 1u);
        assert(result.modified == 0u);
        assert(memory.syncs == 0u);
        for (index = 1; index < memory.count; ++index) {
            assert(memory.words[index] == original_word);
        }
        assert(!rcsm_classify_callsite_redirects(profile, hook_target, read_patch_word, &memory, &state));
        assert(state.foreign == 1u);

        /* Une panne d'écriture après trois sites doit restaurer ces trois
           mots, sans laisser une installation partielle. */
        memory.words[0] = original_word;
        memory.syncs = 0u;
        memory.writes = 0u;
        memory.fail_write_at = 4u;
        assert(!rcsm_install_callsite_redirects(
            profile, hook_target, read_patch_word, write_patch_word, sync_patch_word, &memory, &result
        ));
        assert(result.modified == 3u);
        assert(result.rolled_back == 3u);
        assert(memory.syncs == 6u);
        for (index = 0; index < memory.count; ++index) {
            assert(memory.words[index] == original_word);
        }
        memory.fail_write_at = 0u;

        assert(!rcsm_install_callsite_redirects(
            profile, profile->two_pass_entry, read_patch_word, write_patch_word, sync_patch_word, &memory, &result
        ));
    }

    printf("{\"status\":\"PASS\",\"modules\":%zu,\"callsites\":%zu,\"max_active\":%zu,\"anchors\":%zu,\"callsite_redirects\":\"PASS\"}\n",
           g_rcsm_module_profile_count, total, maximum, g_rcsm_detection_anchor_count);
    return 0;
}
