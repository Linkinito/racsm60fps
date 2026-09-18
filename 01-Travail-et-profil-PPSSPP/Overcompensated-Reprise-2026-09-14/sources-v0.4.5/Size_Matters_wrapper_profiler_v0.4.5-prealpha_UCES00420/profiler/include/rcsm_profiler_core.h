#ifndef RCSM_PROFILER_CORE_H
#define RCSM_PROFILER_CORE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define RCSM_MAX_ACTIVE_CALLS 64u
#define RCSM_MAX_DETECTION_ANCHORS 32u
#define RCSM_PPSSPP_EMUHACK_OPCODE 0x68000000u
#define RCSM_PPSSPP_EMUHACK_MASK 0xFC000000u

typedef enum RcsmPolicy {
    RCSM_POLICY_VANILLA = 0,
    RCSM_POLICY_TWO_PASS = 1,
    RCSM_POLICY_ONE_PASS = 2,
    RCSM_POLICY_CUSTOM = 3
} RcsmPolicy;

typedef struct RcsmCallsiteProfile {
    uint32_t ra;
    uint16_t family_id;
    uint8_t policy;
    uint8_t flags;
} RcsmCallsiteProfile;

typedef struct RcsmModuleProfile {
    uint8_t module_index;
    uint8_t reserved;
    uint16_t callsite_count;
    const char *module_key;
    uint32_t two_pass_entry;
    uint32_t one_pass_inner;
    uint32_t suppression_site;
    uint32_t expected_entry_words[4];
    uint32_t expected_suppression_word; /* Raw PRX word before R_MIPS_26. */
    const uint32_t *expected_detection_words;
    const RcsmCallsiteProfile *callsites;
} RcsmModuleProfile;

typedef struct RcsmTraceStat {
    uint32_t hits;
    uint32_t first_sample;
    uint32_t last_sample;
    uint32_t active_vblanks;
    uint32_t same_vblank_hits;
    uint32_t max_hits_per_vblank;
    uint32_t current_vblank_hits;
    uint32_t gap_1_vblank;
    uint32_t gap_2_vblank;
    uint32_t gap_other_vblank;
} RcsmTraceStat;

typedef struct RcsmProfiler {
    const RcsmModuleProfile *profile;
    RcsmTraceStat stats[RCSM_MAX_ACTIVE_CALLS];
    uint32_t unknown_hits;
} RcsmProfiler;

typedef int (*RcsmReadWord)(uint32_t address, uint32_t *value, void *user);
typedef int (*RcsmWriteWord)(uint32_t address, uint32_t value, void *user);
typedef void (*RcsmSyncCode)(uint32_t address, uint32_t size, void *user);

typedef struct RcsmPatchResult {
    uint16_t examined;
    uint16_t modified;
    uint16_t mismatched;
    uint16_t rolled_back;
} RcsmPatchResult;

typedef struct RcsmRedirectState {
    uint16_t examined;
    uint16_t original;
    uint16_t redirected;
    uint16_t foreign;
    uint16_t unreadable;
} RcsmRedirectState;

typedef struct RcsmModuleMatch {
    const RcsmModuleProfile *profile;
    int32_t address_delta;
    unsigned equivalent_matches;
    unsigned candidate_count;
} RcsmModuleMatch;

const RcsmModuleProfile *rcsm_find_module_profile(uint8_t module_index);
int rcsm_profiles_equivalent(const RcsmModuleProfile *left, const RcsmModuleProfile *right);
const RcsmModuleProfile *rcsm_identify_module(RcsmReadWord reader, void *user, unsigned *equivalent_matches);
const RcsmModuleProfile *rcsm_identify_module_at_delta(
    RcsmReadWord reader,
    void *user,
    int32_t address_delta,
    unsigned *equivalent_matches
);
int rcsm_scan_module_deltas(
    RcsmReadWord reader,
    void *user,
    int32_t minimum_delta,
    int32_t maximum_delta,
    uint32_t step,
    RcsmModuleMatch *match
);
int rcsm_apply_address_delta(uint32_t reference_address, int32_t address_delta, uint32_t *runtime_address);
int rcsm_relocate_profile(
    const RcsmModuleProfile *reference_profile,
    int32_t address_delta,
    RcsmModuleProfile *runtime_profile,
    RcsmCallsiteProfile *runtime_callsites,
    size_t callsite_capacity
);
int rcsm_validate_profile(const RcsmModuleProfile *profile);
int rcsm_bind_profile(RcsmProfiler *profiler, const RcsmModuleProfile *profile);
int rcsm_record_hit(RcsmProfiler *profiler, uint32_t ra, uint32_t sample);
const RcsmTraceStat *rcsm_stat_at(const RcsmProfiler *profiler, size_t index);
uint32_t rcsm_encode_jal(uint32_t target);
uint32_t rcsm_encode_j(uint32_t target);
int rcsm_jal_reachable(uint32_t callsite, uint32_t target);
int rcsm_is_ppsspp_emuhack(uint32_t word);
int rcsm_install_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    RcsmWriteWord writer,
    RcsmSyncCode sync,
    void *user,
    RcsmPatchResult *result
);
int rcsm_remove_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    RcsmWriteWord writer,
    RcsmSyncCode sync,
    void *user,
    RcsmPatchResult *result
);
int rcsm_classify_callsite_redirects(
    const RcsmModuleProfile *profile,
    uint32_t hook_target,
    RcsmReadWord reader,
    void *user,
    RcsmRedirectState *state
);

#ifdef __cplusplus
}
#endif

#endif
