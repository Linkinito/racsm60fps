#include "rcsm_profiler_core.h"

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PSP_USER_RAM_BASE 0x08800000u

typedef struct DumpMemory {
    unsigned char *bytes;
    size_t size;
    int32_t address_delta;
    uint32_t emuhack_reference_address;
    uint32_t emuhack_word;
} DumpMemory;

static int read_dump_word(uint32_t address, uint32_t *value, void *user) {
    const DumpMemory *memory = (const DumpMemory *)user;
    size_t offset;
    int64_t reference_address;
    if (memory == NULL || value == NULL || (address & 3u) != 0u) {
        return -1;
    }
    reference_address = (int64_t)(uint64_t)address - (int64_t)memory->address_delta;
    if (reference_address < PSP_USER_RAM_BASE || reference_address > UINT32_MAX) {
        return -1;
    }
    if ((uint32_t)reference_address == memory->emuhack_reference_address) {
        *value = memory->emuhack_word;
        return 0;
    }
    offset = (size_t)((uint32_t)reference_address - PSP_USER_RAM_BASE);
    if (offset > memory->size || memory->size - offset < sizeof(*value)) {
        return -1;
    }
    memcpy(value, memory->bytes + offset, sizeof(*value));
    if (memory->address_delta != 0 &&
        ((*value & 0xFC000000u) == 0x08000000u || (*value & 0xFC000000u) == 0x0C000000u)) {
        uint32_t reference_target = (((uint32_t)reference_address + 4u) & 0xF0000000u) |
                                    ((*value & 0x03FFFFFFu) << 2u);
        int64_t runtime_target = (int64_t)(uint64_t)reference_target + memory->address_delta;
        if (reference_target >= PSP_USER_RAM_BASE && reference_target < 0x0A000000u &&
            runtime_target >= PSP_USER_RAM_BASE && runtime_target < 0x0A000000u) {
            *value = (*value & 0xFC000000u) |
                     ((((uint32_t)runtime_target) >> 2u) & 0x03FFFFFFu);
        }
    }
    return 0;
}

static DumpMemory load_dump(
    const char *path,
    int32_t address_delta,
    uint32_t emuhack_reference_address,
    uint32_t emuhack_word
) {
    DumpMemory memory = {
        NULL,
        0u,
        address_delta,
        emuhack_reference_address,
        emuhack_word
    };
    FILE *handle = fopen(path, "rb");
    long length;
    assert(handle != NULL);
    assert(fseek(handle, 0, SEEK_END) == 0);
    length = ftell(handle);
    assert(length > 0);
    assert(fseek(handle, 0, SEEK_SET) == 0);
    memory.size = (size_t)length;
    memory.bytes = (unsigned char *)malloc(memory.size);
    assert(memory.bytes != NULL);
    assert(fread(memory.bytes, 1u, memory.size, handle) == memory.size);
    assert(fclose(handle) == 0);
    return memory;
}

static void verify_dump(
    const char *path,
    uint8_t expected_module,
    size_t expected_callsites,
    int32_t address_delta,
    int emulate_jit_entry
) {
    const RcsmModuleProfile *expected_profile = rcsm_find_module_profile(expected_module);
    DumpMemory memory;
    const RcsmModuleProfile *profile;
    RcsmModuleProfile runtime_profile;
    RcsmCallsiteProfile runtime_callsites[RCSM_MAX_ACTIVE_CALLS];
    RcsmModuleMatch scan;
    unsigned matches = 0u;
    size_t index;
    size_t matching_callsites = 0u;
    assert(expected_profile != NULL);
    memory = load_dump(
        path,
        address_delta,
        emulate_jit_entry ? expected_profile->two_pass_entry : 0u,
        emulate_jit_entry ? 0x682BACB6u : 0u
    );
    profile = rcsm_identify_module_at_delta(
        read_dump_word, &memory, address_delta, &matches
    );
    assert(profile != NULL);
    assert(profile->module_index == expected_module);
    assert(profile->callsite_count == expected_callsites);
    assert(matches >= 1u);
    assert(rcsm_relocate_profile(
        profile,
        address_delta,
        &runtime_profile,
        runtime_callsites,
        RCSM_MAX_ACTIVE_CALLS
    ));
    if (address_delta != 0) {
        assert(rcsm_identify_module(read_dump_word, &memory, &matches) == NULL);
        assert(rcsm_scan_module_deltas(
            read_dump_word, &memory, 0, 0x10000, 0x1000u, &scan
        ));
        assert(scan.profile == profile);
        assert(scan.address_delta == address_delta);
    }
    for (index = 0u; index < runtime_profile.callsite_count; ++index) {
        uint32_t observed = 0u;
        uint32_t site = runtime_profile.callsites[index].ra - 8u;
        assert(read_dump_word(site, &observed, &memory) == 0);
        if (observed == rcsm_encode_jal(runtime_profile.two_pass_entry)) {
            ++matching_callsites;
        }
    }
    assert(matching_callsites == expected_callsites);
    free(memory.bytes);
}

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "usage: %s LEVEL_01_RAM.dump LEVEL_02_RAM.dump\n", argv[0]);
        return 2;
    }
    verify_dump(argv[1], 1u, 55u, 0, 0);
    verify_dump(argv[2], 2u, 57u, 0, 0);
    verify_dump(argv[1], 1u, 55u, 0x6000, 0);
    verify_dump(argv[2], 2u, 57u, 0x6000, 0);
    verify_dump(argv[1], 1u, 55u, 0x7000, 0);
    verify_dump(argv[2], 2u, 57u, 0x7000, 0);
    verify_dump(argv[1], 1u, 55u, 0x7000, 1);
    puts("{\"status\":\"PASS\",\"runtime_scenarios\":7,\"deltas\":[0,24576,28672],\"ppsspp_jit_entry\":\"0x682BACB6\",\"modules\":[1,2],\"callsites\":[55,57]}");
    return 0;
}
