#include "rcsm_profiler_core.h"
#include "wrapper_profiles.generated.h"

#include <string.h>

const RcsmModuleProfile *rcsm_find_module_profile(uint8_t module_index) {
    size_t index;
    for (index = 0; index < g_rcsm_module_profile_count; ++index) {
        if (g_rcsm_module_profiles[index].module_index == module_index) {
            return &g_rcsm_module_profiles[index];
        }
    }
    return NULL;
}

int rcsm_profiles_equivalent(const RcsmModuleProfile *left, const RcsmModuleProfile *right) {
    size_t index;
    if (left == NULL || right == NULL || left->callsite_count != right->callsite_count) {
        return 0;
    }
    for (index = 0; index < left->callsite_count; ++index) {
        const RcsmCallsiteProfile *a = &left->callsites[index];
        const RcsmCallsiteProfile *b = &right->callsites[index];
        if (a->ra != b->ra || a->family_id != b->family_id || a->policy != b->policy) {
            return 0;
        }
    }
    return 1;
}

int rcsm_validate_profile(const RcsmModuleProfile *profile) {
    size_t index;
    if (profile == NULL || profile->callsites == NULL || profile->expected_detection_words == NULL) {
        return 0;
    }
    if (profile->callsite_count == 0u || profile->callsite_count > RCSM_MAX_ACTIVE_CALLS) {
        return 0;
    }
    if ((profile->two_pass_entry & 3u) != 0u || (profile->one_pass_inner & 3u) != 0u ||
        (profile->suppression_site & 3u) != 0u) {
        return 0;
    }
    for (index = 0; index < profile->callsite_count; ++index) {
        const RcsmCallsiteProfile *entry = &profile->callsites[index];
        if (entry->family_id == 0u || entry->family_id > 59u || entry->policy > RCSM_POLICY_CUSTOM) {
            return 0;
        }
        if (entry->ra < 8u || (entry->ra & 3u) != 0u) {
            return 0;
        }
        if (index > 0u && profile->callsites[index - 1u].ra >= entry->ra) {
            return 0;
        }
    }
    return 1;
}

int rcsm_apply_address_delta(uint32_t reference_address, int32_t address_delta, uint32_t *runtime_address) {
    int64_t relocated;
    if (runtime_address == NULL || (reference_address & 3u) != 0u || (address_delta & 3) != 0) {
        return 0;
    }
    relocated = (int64_t)(uint64_t)reference_address + (int64_t)address_delta;
    if (relocated < 0 || relocated > (int64_t)UINT32_MAX || (((uint32_t)relocated) & 3u) != 0u) {
        return 0;
    }
    *runtime_address = (uint32_t)relocated;
    return 1;
}

int rcsm_relocate_profile(
    const RcsmModuleProfile *reference_profile,
    int32_t address_delta,
    RcsmModuleProfile *runtime_profile,
    RcsmCallsiteProfile *runtime_callsites,
    size_t callsite_capacity
) {
    size_t index;
    if (!rcsm_validate_profile(reference_profile) || runtime_profile == NULL || runtime_callsites == NULL ||
        callsite_capacity < reference_profile->callsite_count) {
        return 0;
    }
    *runtime_profile = *reference_profile;
    if (!rcsm_apply_address_delta(reference_profile->two_pass_entry, address_delta, &runtime_profile->two_pass_entry) ||
        !rcsm_apply_address_delta(reference_profile->one_pass_inner, address_delta, &runtime_profile->one_pass_inner) ||
        !rcsm_apply_address_delta(reference_profile->suppression_site, address_delta, &runtime_profile->suppression_site)) {
        return 0;
    }
    for (index = 0u; index < reference_profile->callsite_count; ++index) {
        runtime_callsites[index] = reference_profile->callsites[index];
        if (!rcsm_apply_address_delta(
                reference_profile->callsites[index].ra,
                address_delta,
                &runtime_callsites[index].ra)) {
            return 0;
        }
    }
    runtime_profile->callsites = runtime_callsites;
    return rcsm_validate_profile(runtime_profile);
}

const RcsmModuleProfile *rcsm_identify_module_at_delta(
    RcsmReadWord reader,
    void *user,
    int32_t address_delta,
    unsigned *equivalent_matches
) {
    uint32_t observed[RCSM_MAX_DETECTION_ANCHORS];
    const RcsmModuleProfile *first = NULL;
    size_t profile_index;
    size_t anchor_index;
    unsigned matches = 0u;

    if (equivalent_matches != NULL) {
        *equivalent_matches = 0u;
    }
    if (reader == NULL || g_rcsm_detection_anchor_count > RCSM_MAX_DETECTION_ANCHORS) {
        return NULL;
    }
    for (anchor_index = 0; anchor_index < g_rcsm_detection_anchor_count; ++anchor_index) {
        uint32_t runtime_address;
        if (!rcsm_apply_address_delta(
                g_rcsm_detection_addresses[anchor_index], address_delta, &runtime_address) ||
            reader(runtime_address, &observed[anchor_index], user) != 0) {
            return NULL;
        }
    }
    for (profile_index = 0; profile_index < g_rcsm_module_profile_count; ++profile_index) {
        const RcsmModuleProfile *profile = &g_rcsm_module_profiles[profile_index];
        uint32_t word;
        int match = 1;
        for (anchor_index = 0; anchor_index < g_rcsm_detection_anchor_count; ++anchor_index) {
            if (observed[anchor_index] != profile->expected_detection_words[anchor_index]) {
                match = 0;
                break;
            }
        }
        if (!match) {
            continue;
        }
        for (anchor_index = 0; anchor_index < 4u; ++anchor_index) {
            uint32_t runtime_entry;
            if (!rcsm_apply_address_delta(
                    profile->two_pass_entry + (uint32_t)(anchor_index * 4u),
                    address_delta,
                    &runtime_entry) ||
                reader(runtime_entry, &word, user) != 0 ||
                (word != profile->expected_entry_words[anchor_index] &&
                 !(anchor_index == 0u && rcsm_is_ppsspp_emuhack(word)))) {
                match = 0;
                break;
            }
        }
        /* expected_suppression_word is the raw PRX word before R_MIPS_26.
           Memory contains the relocated jal, so compare with its runtime
           encoding instead of the file image. */
        if (match) {
            uint32_t runtime_suppression;
            uint32_t runtime_inner;
            if (!rcsm_apply_address_delta(profile->suppression_site, address_delta, &runtime_suppression) ||
                !rcsm_apply_address_delta(profile->one_pass_inner, address_delta, &runtime_inner) ||
                reader(runtime_suppression, &word, user) != 0 || word != rcsm_encode_jal(runtime_inner)) {
                match = 0;
            }
        }
        if (!match) {
            continue;
        }
        if (first == NULL) {
            first = profile;
        } else if (!rcsm_profiles_equivalent(first, profile)) {
            return NULL;
        }
        ++matches;
    }
    if (equivalent_matches != NULL) {
        *equivalent_matches = matches;
    }
    return first;
}

const RcsmModuleProfile *rcsm_identify_module(RcsmReadWord reader, void *user, unsigned *equivalent_matches) {
    return rcsm_identify_module_at_delta(reader, user, 0, equivalent_matches);
}

int rcsm_scan_module_deltas(
    RcsmReadWord reader,
    void *user,
    int32_t minimum_delta,
    int32_t maximum_delta,
    uint32_t step,
    RcsmModuleMatch *match
) {
    int64_t delta;
    RcsmModuleMatch local = {NULL, 0, 0u, 0u};
    if (match != NULL) {
        *match = local;
    }
    if (reader == NULL || step == 0u || (step & 3u) != 0u || minimum_delta > maximum_delta ||
        (minimum_delta & 3) != 0 || (maximum_delta & 3) != 0) {
        return 0;
    }
    for (delta = minimum_delta; delta <= maximum_delta; delta += (int64_t)step) {
        unsigned matches = 0u;
        const RcsmModuleProfile *profile = rcsm_identify_module_at_delta(
            reader, user, (int32_t)delta, &matches
        );
        if (profile != NULL) {
            ++local.candidate_count;
            if (local.profile == NULL) {
                local.profile = profile;
                local.address_delta = (int32_t)delta;
                local.equivalent_matches = matches;
            }
        }
    }
    if (local.candidate_count != 1u) {
        local.profile = NULL;
        local.equivalent_matches = 0u;
    }
    if (match != NULL) {
        *match = local;
    }
    return local.candidate_count == 1u;
}

int rcsm_bind_profile(RcsmProfiler *profiler, const RcsmModuleProfile *profile) {
    if (profiler == NULL || !rcsm_validate_profile(profile)) {
        return 0;
    }
    memset(profiler, 0, sizeof(*profiler));
    profiler->profile = profile;
    return 1;
}

int rcsm_record_hit(RcsmProfiler *profiler, uint32_t ra, uint32_t sample) {
    size_t low = 0u;
    size_t high;
    RcsmTraceStat *stat;
    if (profiler == NULL || profiler->profile == NULL) {
        return -1;
    }
    high = profiler->profile->callsite_count;
    while (low < high) {
        size_t middle = low + (high - low) / 2u;
        uint32_t candidate = profiler->profile->callsites[middle].ra;
        if (candidate < ra) {
            low = middle + 1u;
        } else {
            high = middle;
        }
    }
    if (low >= profiler->profile->callsite_count || profiler->profile->callsites[low].ra != ra) {
        if (profiler->unknown_hits != 0xFFFFFFFFu) {
            ++profiler->unknown_hits;
        }
        return -1;
    }
    stat = &profiler->stats[low];
    if (stat->hits == 0u) {
        stat->hits = 1u;
        stat->first_sample = sample;
        stat->last_sample = sample;
        stat->active_vblanks = 1u;
        stat->max_hits_per_vblank = 1u;
        stat->current_vblank_hits = 1u;
        return (int)low;
    }
    if (stat->hits != 0xFFFFFFFFu) {
        ++stat->hits;
    }
    if (sample == stat->last_sample) {
        if (stat->same_vblank_hits != 0xFFFFFFFFu) {
            ++stat->same_vblank_hits;
        }
        if (stat->current_vblank_hits != 0xFFFFFFFFu) {
            ++stat->current_vblank_hits;
        }
        if (stat->current_vblank_hits > stat->max_hits_per_vblank) {
            stat->max_hits_per_vblank = stat->current_vblank_hits;
        }
    } else {
        uint32_t gap = sample - stat->last_sample;
        if (stat->active_vblanks != 0xFFFFFFFFu) {
            ++stat->active_vblanks;
        }
        if (gap == 1u) {
            if (stat->gap_1_vblank != 0xFFFFFFFFu) {
                ++stat->gap_1_vblank;
            }
        } else if (gap == 2u) {
            if (stat->gap_2_vblank != 0xFFFFFFFFu) {
                ++stat->gap_2_vblank;
            }
        } else if (stat->gap_other_vblank != 0xFFFFFFFFu) {
            ++stat->gap_other_vblank;
        }
        stat->current_vblank_hits = 1u;
    }
    stat->last_sample = sample;
    return (int)low;
}

const RcsmTraceStat *rcsm_stat_at(const RcsmProfiler *profiler, size_t index) {
    if (profiler == NULL || profiler->profile == NULL || index >= profiler->profile->callsite_count) {
        return NULL;
    }
    return &profiler->stats[index];
}

uint32_t rcsm_encode_jal(uint32_t target) {
    return 0x0C000000u | ((target >> 2u) & 0x03FFFFFFu);
}

uint32_t rcsm_encode_j(uint32_t target) {
    return 0x08000000u | ((target >> 2u) & 0x03FFFFFFu);
}

int rcsm_jal_reachable(uint32_t callsite, uint32_t target) {
    return (target & 3u) == 0u && ((callsite + 4u) & 0xF0000000u) == (target & 0xF0000000u);
}

int rcsm_is_ppsspp_emuhack(uint32_t word) {
    return (word & RCSM_PPSSPP_EMUHACK_MASK) == RCSM_PPSSPP_EMUHACK_OPCODE;
}

int rcsm_install_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    RcsmWriteWord writer,
    RcsmSyncCode sync,
    void *user,
    RcsmPatchResult *result
) {
    RcsmPatchResult local = {0u, 0u, 0u, 0u};
    uint32_t original_word;
    uint32_t hook_word;
    size_t index;
    if (result != NULL) {
        *result = local;
    }
    if (!rcsm_validate_profile(profile) || reader == NULL || writer == NULL ||
        hook_target == 0u || hook_target == profile->two_pass_entry) {
        return 0;
    }
    original_word = rcsm_encode_jal(profile->two_pass_entry);
    hook_word = rcsm_encode_jal(hook_target);

    /* Preflight every site before the first write: all-or-nothing on mismatch. */
    for (index = 0; index < profile->callsite_count; ++index) {
        uint32_t word = 0u;
        uint32_t site = profile->callsites[index].ra - 8u;
        ++local.examined;
        if (!rcsm_jal_reachable(site, hook_target) || reader(site, &word, user) != 0 || word != original_word) {
            ++local.mismatched;
        }
    }
    if (local.mismatched != 0u) {
        if (result != NULL) {
            *result = local;
        }
        return 0;
    }

    for (index = 0; index < profile->callsite_count; ++index) {
        uint32_t site = profile->callsites[index].ra - 8u;
        if (writer(site, hook_word, user) != 0) {
            size_t rollback;
            for (rollback = 0; rollback < index; ++rollback) {
                uint32_t previous_site = profile->callsites[rollback].ra - 8u;
                if (writer(previous_site, original_word, user) == 0) {
                    ++local.rolled_back;
                    if (sync != NULL) {
                        sync(previous_site, 4u, user);
                    }
                }
            }
            if (result != NULL) {
                *result = local;
            }
            return 0;
        }
        ++local.modified;
        if (sync != NULL) {
            sync(site, 4u, user);
        }
    }
    if (result != NULL) {
        *result = local;
    }
    return 1;
}

int rcsm_remove_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    RcsmWriteWord writer,
    RcsmSyncCode sync,
    void *user,
    RcsmPatchResult *result
) {
    RcsmPatchResult local = {0u, 0u, 0u, 0u};
    uint32_t original_word;
    uint32_t hook_word;
    size_t index;
    if (result != NULL) {
        *result = local;
    }
    if (!rcsm_validate_profile(profile) || reader == NULL || writer == NULL ||
        hook_target == 0u || hook_target == profile->two_pass_entry) {
        return 0;
    }
    original_word = rcsm_encode_jal(profile->two_pass_entry);
    hook_word = rcsm_encode_jal(hook_target);
    for (index = 0; index < profile->callsite_count; ++index) {
        uint32_t word = 0u;
        uint32_t site = profile->callsites[index].ra - 8u;
        ++local.examined;
        if (reader(site, &word, user) != 0) {
            ++local.mismatched;
            continue;
        }
        if (word == original_word) {
            continue;
        }
        if (word != hook_word || writer(site, original_word, user) != 0) {
            ++local.mismatched;
            continue;
        }
        ++local.modified;
        if (sync != NULL) {
            sync(site, 4u, user);
        }
    }
    if (result != NULL) {
        *result = local;
    }
    return local.mismatched == 0u;
}

int rcsm_classify_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    void *user,
    RcsmRedirectState *state
) {
    RcsmRedirectState local = {0u, 0u, 0u, 0u, 0u};
    uint32_t original_word;
    uint32_t hook_word;
    size_t index;
    if (state != NULL) {
        *state = local;
    }
    if (!rcsm_validate_profile(profile) || reader == NULL ||
        hook_target == 0u || hook_target == profile->two_pass_entry) {
        return 0;
    }
    original_word = rcsm_encode_jal(profile->two_pass_entry);
    hook_word = rcsm_encode_jal(hook_target);
    for (index = 0; index < profile->callsite_count; ++index) {
        uint32_t word = 0u;
        uint32_t site = profile->callsites[index].ra - 8u;
        ++local.examined;
        if (reader(site, &word, user) != 0) {
            ++local.unreadable;
        } else if (word == original_word) {
            ++local.original;
        } else if (word == hook_word) {
            ++local.redirected;
        } else {
            ++local.foreign;
        }
    }
    if (state != NULL) {
        *state = local;
    }
    return local.foreign == 0u && local.unreadable == 0u;
}
