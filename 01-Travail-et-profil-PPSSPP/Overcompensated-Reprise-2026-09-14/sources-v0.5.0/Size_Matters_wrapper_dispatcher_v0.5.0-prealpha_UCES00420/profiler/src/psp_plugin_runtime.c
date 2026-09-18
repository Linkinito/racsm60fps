/*
 * RCSM wrapper profiler runtime for Ratchet & Clank: Size Matters, UCES00420.
 *
 * PPSSPP-first user-mode PRX.  The default configuration is DETECT_ONLY and
 * therefore performs no game-code writes.  POLICY_MODULE adds an experimental
 * dispatcher: every known callsite in one explicitly allowed module remains
 * observable while its route is selected as TWO_PASS or ONE_PASS by the INI.
 * CUSTOM is represented in traces but deliberately falls back to TWO_PASS
 * until a dedicated handler exists.  All code writes are preflighted by the
 * portable core and followed by D/I cache synchronization.
 */

#include <pspctrl.h>
#include <pspdisplay.h>
#include <pspiofilemgr.h>
#include <pspkernel.h>
#include <pspmodulemgr.h>
#include <pspthreadman.h>
#include <psputils.h>

#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include "rcsm_format.h"
#include "rcsm_profiler_core.h"
#include "wrapper_profiles.generated.h"

#define RCSM_VERSION "0.5.0-prealpha"
#define RCSM_CONFIG_PATH "ms0:/PSP/PLUGINS/SizeMattersWrapperProfiler/RCSMProfiler.ini"
#define RCSM_LOG_PATH "ms0:/PSP/PLUGINS/SizeMattersWrapperProfiler/status.log"
#define RCSM_TRACE_PREFIX "ms0:/PSP/PLUGINS/SizeMattersWrapperProfiler/trace"
#define RCSM_DEFAULT_SINGLE_RA 0x091840C0u
#define RCSM_DEFAULT_FOCUS_FAMILY 19u
#define RCSM_MIN_POLL_US 50000u
#define RCSM_MAX_POLL_US 2000000u
#define RCSM_MAX_STABLE_POLLS 20u
#define RCSM_HOOK_DRAIN_US 20000u
#define RCSM_HOOK_DRAIN_ATTEMPTS 50u
#define RCSM_HEALTH_PERIOD_POLLS 10u
#define RCSM_LEVEL_MODULE_NAME "rcp1"
#define RCSM_MAX_MODULE_IDS 32u
#define RCSM_FALLBACK_MIN_DELTA (-0x00200000)
#define RCSM_FALLBACK_MAX_DELTA 0x00400000
#define RCSM_FALLBACK_DELTA_STEP 0x00001000u
#define RCSM_MODULE_API_FOUND 1
#define RCSM_MODULE_API_INVALID 2
#define RCSM_MODULE_API_AMBIGUOUS 3
#define RCSM_MAX_FAMILY_ID 59u
#define RCSM_MAX_RA_OVERRIDES RCSM_MAX_ACTIVE_CALLS
#define RCSM_POLICY_UNSPECIFIED 0xFFu
#define RCSM_CONFIG_BUFFER_SIZE 2048u

PSP_MODULE_INFO("RCSMProfiler", PSP_MODULE_USER, 0, 4);
PSP_MAIN_THREAD_PARAMS(0x2Fu, 16u, PSP_THREAD_ATTR_USER);
PSP_MAIN_THREAD_NAME("rcsm_profiler_monitor");

/* Equivalent explicite de PSP_DISABLE_NEWLIB(), compatible avec -Werror. */
void __libcglue_init(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
}

void __libcglue_deinit(void) {
}

typedef enum RcsmRuntimeMode {
    RCSM_MODE_DETECT_ONLY = 0,
    RCSM_MODE_SINGLE_POKITARU = 1,
    RCSM_MODE_FULL_MODULE = 2,
    RCSM_MODE_FOCUSED_POKITARU = 3,
    RCSM_MODE_POLICY_MODULE = 4
} RcsmRuntimeMode;

typedef struct RcsmRaPolicyOverride {
    uint32_t reference_ra;
    uint8_t policy;
} RcsmRaPolicyOverride;

typedef struct RcsmRuntimeConfig {
    RcsmRuntimeMode mode;
    uint32_t single_ra;
    uint32_t focus_family;
    uint32_t allowed_module;
    uint32_t poll_us;
    uint32_t stable_polls;
    int export_on_transition;
    int controls_enabled;
    int instrumentation_enabled;
    uint8_t default_policy;
    uint8_t family_policies[RCSM_MAX_FAMILY_ID + 1u];
    RcsmRaPolicyOverride ra_overrides[RCSM_MAX_RA_OVERRIDES];
    uint16_t ra_override_count;
    uint16_t config_errors;
} RcsmRuntimeConfig;

typedef enum RcsmResolutionSource {
    RCSM_RESOLUTION_NONE = 0,
    RCSM_RESOLUTION_MODULE_API = 1,
    RCSM_RESOLUTION_FALLBACK_SCAN = 2
} RcsmResolutionSource;

typedef struct RcsmRuntimeDetection {
    const RcsmModuleProfile *reference_profile;
    int32_t address_delta;
    uint32_t runtime_base;
    unsigned equivalent_matches;
    unsigned scan_candidates;
    int module_api_status;
    RcsmResolutionSource source;
    uint32_t entry_guard_word;
    int entry_guard_is_emuhack;
} RcsmRuntimeDetection;

typedef struct RcsmRuntimeBinding {
    const RcsmModuleProfile *reference_profile;
    const RcsmModuleProfile *profile;
    RcsmModuleProfile runtime_profile;
    RcsmCallsiteProfile runtime_callsites[RCSM_MAX_ACTIVE_CALLS];
    RcsmCallsiteProfile focused_callsites[RCSM_MAX_ACTIVE_CALLS];
    RcsmModuleProfile patch_view;
    int32_t address_delta;
    uint32_t runtime_base;
    uint32_t two_pass_hook_target;
    uint32_t one_pass_hook_target;
    uint32_t capture_start;
    unsigned equivalent_matches;
    RcsmResolutionSource resolution_source;
    int jit_entry_seen;
    int installed;
} RcsmRuntimeBinding;

/* Referenced from profiler_hook.S. */
uint32_t g_rcsm_plugin_gp = 0u;

volatile uint32_t g_rcsm_vblank_sample = 0u;
volatile uint32_t g_rcsm_recording_enabled = 0u;
volatile uint32_t g_rcsm_active_hook_count = 0u;
volatile uint32_t g_rcsm_active_module_index = 0u;
volatile uint32_t g_rcsm_equivalent_profile_matches = 0u;
volatile uint32_t g_rcsm_installed_callsite_count = 0u;
volatile uint32_t g_rcsm_last_patch_error = 0u;

static volatile int g_stop_requested = 0;
static SceUID g_monitor_thread = -1;
static SceUID g_vblank_thread = -1;
static RcsmProfiler g_profiler;
static RcsmRuntimeBinding g_binding;
static RcsmTraceStat g_snapshot_stats[RCSM_MAX_ACTIVE_CALLS];
static uint32_t g_snapshot_unknown_hits = 0u;
static uint32_t g_trace_sequence = 0u;
static RcsmRuntimeDetection g_last_detection;

extern void rcsm_profiler_hook_l01(void);
extern void rcsm_profiler_hook_l01_one(void);
extern void rcsm_profiler_hook_l02(void);
extern void rcsm_profiler_hook_l02_one(void);
extern void rcsm_profiler_hook_l03(void);
extern void rcsm_profiler_hook_l03_one(void);
extern void rcsm_profiler_hook_l04(void);
extern void rcsm_profiler_hook_l04_one(void);
extern void rcsm_profiler_hook_l05(void);
extern void rcsm_profiler_hook_l05_one(void);
extern void rcsm_profiler_hook_l06(void);
extern void rcsm_profiler_hook_l06_one(void);
extern void rcsm_profiler_hook_l07(void);
extern void rcsm_profiler_hook_l07_one(void);
extern void rcsm_profiler_hook_l08(void);
extern void rcsm_profiler_hook_l08_one(void);
extern void rcsm_profiler_hook_l09(void);
extern void rcsm_profiler_hook_l09_one(void);
extern void rcsm_profiler_hook_l10(void);
extern void rcsm_profiler_hook_l10_one(void);
extern void rcsm_profiler_hook_l15(void);
extern void rcsm_profiler_hook_l15_one(void);
extern void rcsm_profiler_hook_l21(void);
extern void rcsm_profiler_hook_l21_one(void);
extern void rcsm_profiler_hook_l22(void);
extern void rcsm_profiler_hook_l22_one(void);
extern void rcsm_profiler_hook_l23(void);
extern void rcsm_profiler_hook_l23_one(void);
extern void rcsm_profiler_hook_l24(void);
extern void rcsm_profiler_hook_l24_one(void);

extern uint32_t rcsm_profiler_tail_l01;
extern uint32_t rcsm_profiler_tail_l01_one;
extern uint32_t rcsm_profiler_tail_l02;
extern uint32_t rcsm_profiler_tail_l02_one;
extern uint32_t rcsm_profiler_tail_l03;
extern uint32_t rcsm_profiler_tail_l03_one;
extern uint32_t rcsm_profiler_tail_l04;
extern uint32_t rcsm_profiler_tail_l04_one;
extern uint32_t rcsm_profiler_tail_l05;
extern uint32_t rcsm_profiler_tail_l05_one;
extern uint32_t rcsm_profiler_tail_l06;
extern uint32_t rcsm_profiler_tail_l06_one;
extern uint32_t rcsm_profiler_tail_l07;
extern uint32_t rcsm_profiler_tail_l07_one;
extern uint32_t rcsm_profiler_tail_l08;
extern uint32_t rcsm_profiler_tail_l08_one;
extern uint32_t rcsm_profiler_tail_l09;
extern uint32_t rcsm_profiler_tail_l09_one;
extern uint32_t rcsm_profiler_tail_l10;
extern uint32_t rcsm_profiler_tail_l10_one;
extern uint32_t rcsm_profiler_tail_l15;
extern uint32_t rcsm_profiler_tail_l15_one;
extern uint32_t rcsm_profiler_tail_l21;
extern uint32_t rcsm_profiler_tail_l21_one;
extern uint32_t rcsm_profiler_tail_l22;
extern uint32_t rcsm_profiler_tail_l22_one;
extern uint32_t rcsm_profiler_tail_l23;
extern uint32_t rcsm_profiler_tail_l23_one;
extern uint32_t rcsm_profiler_tail_l24;
extern uint32_t rcsm_profiler_tail_l24_one;

static RcsmRuntimeConfig g_config = {
    .mode = RCSM_MODE_DETECT_ONLY,
    .single_ra = RCSM_DEFAULT_SINGLE_RA,
    .focus_family = RCSM_DEFAULT_FOCUS_FAMILY,
    .allowed_module = 0u,
    .poll_us = 100000u,
    .stable_polls = 3u,
    .export_on_transition = 1,
    .controls_enabled = 1,
    .instrumentation_enabled = 1,
    .default_policy = RCSM_POLICY_TWO_PASS,
};

static const char *runtime_mode_name(RcsmRuntimeMode mode) {
    switch (mode) {
        case RCSM_MODE_POLICY_MODULE:
            return "policy_module";
        case RCSM_MODE_FOCUSED_POKITARU:
            return "focused_pokitaru";
        case RCSM_MODE_SINGLE_POKITARU:
            return "single_pokitaru";
        case RCSM_MODE_FULL_MODULE:
            return "full_module";
        case RCSM_MODE_DETECT_ONLY:
        default:
            return "detect_only";
    }
}

static const char *resolution_source_name(RcsmResolutionSource source) {
    switch (source) {
        case RCSM_RESOLUTION_MODULE_API:
            return "module_api";
        case RCSM_RESOLUTION_FALLBACK_SCAN:
            return "fallback_scan";
        case RCSM_RESOLUTION_NONE:
        default:
            return "none";
    }
}

static uint32_t capture_gp(void) {
    uint32_t value;
    __asm__ volatile("move %0, $gp" : "=r"(value));
    return value;
}

static int write_all(SceUID fd, const char *data, size_t size) {
    size_t offset = 0u;
    while (offset < size) {
        int written = sceIoWrite(fd, data + offset, (SceSize)(size - offset));
        if (written <= 0) {
            return 0;
        }
        offset += (size_t)written;
    }
    return 1;
}

static void log_line(const char *format, ...) __attribute__((format(printf, 1, 2)));

static void log_line(const char *format, ...) {
    char buffer[320];
    size_t length;
    SceUID fd;
    va_list args;
    va_start(args, format);
    length = rcsm_vformat(buffer, sizeof(buffer) - 1u, format, args);
    va_end(args);
    if (length > sizeof(buffer) - 2u) {
        length = sizeof(buffer) - 2u;
    }
    buffer[length++] = '\n';
    buffer[length] = '\0';
    fd = sceIoOpen(RCSM_LOG_PATH, PSP_O_WRONLY | PSP_O_CREAT | PSP_O_APPEND, 0666);
    if (fd >= 0) {
        (void)write_all(fd, buffer, length);
        (void)sceIoClose(fd);
    }
}

static char ascii_lower(char value) {
    if (value >= 'A' && value <= 'Z') {
        return (char)(value + ('a' - 'A'));
    }
    return value;
}

static int string_equal_ci(const char *left, const char *right) {
    while (*left != '\0' && *right != '\0') {
        if (ascii_lower(*left) != ascii_lower(*right)) {
            return 0;
        }
        ++left;
        ++right;
    }
    return *left == '\0' && *right == '\0';
}

static char *trim_ascii(char *text) {
    char *end;
    while (*text == ' ' || *text == '\t' || *text == '\r' || *text == '\n') {
        ++text;
    }
    end = text + strlen(text);
    while (end > text && (end[-1] == ' ' || end[-1] == '\t' || end[-1] == '\r' || end[-1] == '\n')) {
        --end;
    }
    *end = '\0';
    return text;
}

static int parse_bool(const char *value, int fallback) {
    if (string_equal_ci(value, "true") || string_equal_ci(value, "yes") || strcmp(value, "1") == 0) {
        return 1;
    }
    if (string_equal_ci(value, "false") || string_equal_ci(value, "no") || strcmp(value, "0") == 0) {
        return 0;
    }
    return fallback;
}

static int parse_u32(const char *text, uint32_t *value) {
    uint32_t result = 0u;
    unsigned base = 10u;
    int digits = 0;
    if (text == NULL || value == NULL) {
        return 0;
    }
    if (text[0] == '0' && (text[1] == 'x' || text[1] == 'X')) {
        base = 16u;
        text += 2;
    }
    while (*text != '\0') {
        unsigned digit;
        if (*text >= '0' && *text <= '9') {
            digit = (unsigned)(*text - '0');
        } else if (*text >= 'a' && *text <= 'f') {
            digit = 10u + (unsigned)(*text - 'a');
        } else if (*text >= 'A' && *text <= 'F') {
            digit = 10u + (unsigned)(*text - 'A');
        } else {
            return 0;
        }
        if (digit >= base || result > (0xFFFFFFFFu - digit) / base) {
            return 0;
        }
        result = result * base + digit;
        ++digits;
        ++text;
    }
    if (!digits) {
        return 0;
    }
    *value = result;
    return 1;
}

static const char *policy_name(uint8_t policy) {
    switch (policy) {
        case RCSM_POLICY_ONE_PASS:
            return "one_pass";
        case RCSM_POLICY_CUSTOM:
            return "custom";
        case RCSM_POLICY_TWO_PASS:
            return "two_pass";
        case RCSM_POLICY_VANILLA:
        default:
            return "vanilla";
    }
}

static uint8_t effective_policy(uint8_t policy) {
    return policy == RCSM_POLICY_ONE_PASS ? RCSM_POLICY_ONE_PASS : RCSM_POLICY_TWO_PASS;
}

static int parse_policy(const char *value, uint8_t *policy) {
    if (value == NULL || policy == NULL) {
        return 0;
    }
    if (string_equal_ci(value, "one_pass")) {
        *policy = RCSM_POLICY_ONE_PASS;
        return 1;
    }
    if (string_equal_ci(value, "two_pass") || string_equal_ci(value, "vanilla")) {
        *policy = RCSM_POLICY_TWO_PASS;
        return 1;
    }
    if (string_equal_ci(value, "custom")) {
        *policy = RCSM_POLICY_CUSTOM;
        return 1;
    }
    return 0;
}

static void initialize_policy_config(void) {
    size_t index;
    for (index = 0u; index <= RCSM_MAX_FAMILY_ID; ++index) {
        g_config.family_policies[index] = RCSM_POLICY_UNSPECIFIED;
    }
    g_config.ra_override_count = 0u;
    g_config.config_errors = 0u;
}

static int copy_list_token(const char **cursor, char *token, size_t capacity) {
    const char *start;
    const char *end;
    size_t length;
    if (cursor == NULL || *cursor == NULL || token == NULL || capacity < 2u) {
        return -1;
    }
    while (**cursor == ' ' || **cursor == '\t' || **cursor == ',') {
        ++*cursor;
    }
    if (**cursor == '\0') {
        token[0] = '\0';
        return 0;
    }
    start = *cursor;
    while (**cursor != '\0' && **cursor != ',') {
        ++*cursor;
    }
    end = *cursor;
    while (end > start && (end[-1] == ' ' || end[-1] == '\t')) {
        --end;
    }
    length = (size_t)(end - start);
    if (length == 0u || length >= capacity) {
        return -1;
    }
    memcpy(token, start, length);
    token[length] = '\0';
    return 1;
}

static void set_family_policy(uint32_t family_id, uint8_t policy) {
    uint8_t previous;
    if (family_id == 0u || family_id > RCSM_MAX_FAMILY_ID) {
        ++g_config.config_errors;
        return;
    }
    previous = g_config.family_policies[family_id];
    if (previous != RCSM_POLICY_UNSPECIFIED && previous != policy) {
        ++g_config.config_errors;
        return;
    }
    g_config.family_policies[family_id] = policy;
}

static void parse_family_policy_list(const char *value, uint8_t policy) {
    const char *cursor = value;
    char token[16];
    int status;
    while ((status = copy_list_token(&cursor, token, sizeof(token))) != 0) {
        uint32_t family_id = 0u;
        if (status < 0 || !parse_u32(token, &family_id)) {
            ++g_config.config_errors;
            return;
        }
        set_family_policy(family_id, policy);
    }
}

static void set_ra_policy(uint32_t reference_ra, uint8_t policy) {
    size_t index;
    if (reference_ra < 0x08800000u || reference_ra > 0x09FFFFFCu || (reference_ra & 3u) != 0u) {
        ++g_config.config_errors;
        return;
    }
    for (index = 0u; index < g_config.ra_override_count; ++index) {
        if (g_config.ra_overrides[index].reference_ra == reference_ra) {
            if (g_config.ra_overrides[index].policy != policy) {
                ++g_config.config_errors;
            }
            return;
        }
    }
    if (g_config.ra_override_count >= RCSM_MAX_RA_OVERRIDES) {
        ++g_config.config_errors;
        return;
    }
    g_config.ra_overrides[g_config.ra_override_count].reference_ra = reference_ra;
    g_config.ra_overrides[g_config.ra_override_count].policy = policy;
    ++g_config.ra_override_count;
}

static void parse_ra_policy_list(const char *value, uint8_t policy) {
    const char *cursor = value;
    char token[24];
    int status;
    while ((status = copy_list_token(&cursor, token, sizeof(token))) != 0) {
        uint32_t reference_ra = 0u;
        if (status < 0 || !parse_u32(token, &reference_ra)) {
            ++g_config.config_errors;
            return;
        }
        set_ra_policy(reference_ra, policy);
    }
}

static void apply_config_pair(const char *key, const char *value) {
    uint32_t parsed;
    uint8_t policy;
    if (string_equal_ci(key, "mode")) {
        if (string_equal_ci(value, "detect_only")) {
            g_config.mode = RCSM_MODE_DETECT_ONLY;
        } else if (string_equal_ci(value, "single_pokitaru")) {
            g_config.mode = RCSM_MODE_SINGLE_POKITARU;
        } else if (string_equal_ci(value, "focused_pokitaru")) {
            g_config.mode = RCSM_MODE_FOCUSED_POKITARU;
        } else if (string_equal_ci(value, "full_module")) {
            g_config.mode = RCSM_MODE_FULL_MODULE;
        } else if (string_equal_ci(value, "policy_module")) {
            g_config.mode = RCSM_MODE_POLICY_MODULE;
        } else {
            ++g_config.config_errors;
        }
    } else if (string_equal_ci(key, "single_ra") && parse_u32(value, &parsed)) {
        g_config.single_ra = parsed;
    } else if (string_equal_ci(key, "focus_family") && parse_u32(value, &parsed)) {
        if (parsed >= 1u && parsed <= 59u) {
            g_config.focus_family = parsed;
        }
    } else if (string_equal_ci(key, "allowed_module") && parse_u32(value, &parsed)) {
        if (parsed == 0u || (parsed <= 0xFFu && rcsm_find_module_profile((uint8_t)parsed) != NULL)) {
            g_config.allowed_module = parsed;
        }
    } else if (string_equal_ci(key, "poll_us") && parse_u32(value, &parsed)) {
        if (parsed >= RCSM_MIN_POLL_US && parsed <= RCSM_MAX_POLL_US) {
            g_config.poll_us = parsed;
        }
    } else if (string_equal_ci(key, "stable_polls") && parse_u32(value, &parsed)) {
        if (parsed >= 1u && parsed <= RCSM_MAX_STABLE_POLLS) {
            g_config.stable_polls = parsed;
        }
    } else if (string_equal_ci(key, "export_on_transition")) {
        g_config.export_on_transition = parse_bool(value, g_config.export_on_transition);
    } else if (string_equal_ci(key, "controls_enabled")) {
        g_config.controls_enabled = parse_bool(value, g_config.controls_enabled);
    } else if (string_equal_ci(key, "instrumentation_enabled")) {
        g_config.instrumentation_enabled = parse_bool(value, g_config.instrumentation_enabled);
    } else if (string_equal_ci(key, "default_policy")) {
        if (parse_policy(value, &policy)) {
            g_config.default_policy = policy;
        } else {
            ++g_config.config_errors;
        }
    } else if (string_equal_ci(key, "one_pass_families")) {
        parse_family_policy_list(value, RCSM_POLICY_ONE_PASS);
    } else if (string_equal_ci(key, "two_pass_families")) {
        parse_family_policy_list(value, RCSM_POLICY_TWO_PASS);
    } else if (string_equal_ci(key, "custom_families")) {
        parse_family_policy_list(value, RCSM_POLICY_CUSTOM);
    } else if (string_equal_ci(key, "one_pass_ras")) {
        parse_ra_policy_list(value, RCSM_POLICY_ONE_PASS);
    } else if (string_equal_ci(key, "two_pass_ras")) {
        parse_ra_policy_list(value, RCSM_POLICY_TWO_PASS);
    } else if (string_equal_ci(key, "custom_ras")) {
        parse_ra_policy_list(value, RCSM_POLICY_CUSTOM);
    }
}

static void load_config(void) {
    char buffer[RCSM_CONFIG_BUFFER_SIZE];
    int size;
    SceUID fd;
    initialize_policy_config();
    fd = sceIoOpen(RCSM_CONFIG_PATH, PSP_O_RDONLY, 0);
    if (fd < 0) {
        log_line("config missing; safe defaults mode=detect_only");
        return;
    }
    size = sceIoRead(fd, buffer, sizeof(buffer) - 1u);
    (void)sceIoClose(fd);
    if (size <= 0) {
        log_line("config unreadable or empty; safe defaults mode=detect_only");
        return;
    }
    buffer[size] = '\0';
    {
        char *cursor = buffer;
        while (*cursor != '\0') {
            char *line = cursor;
            char *equals;
            while (*cursor != '\0' && *cursor != '\n') {
                ++cursor;
            }
            if (*cursor == '\n') {
                *cursor++ = '\0';
            }
            line = trim_ascii(line);
            if (*line == '\0' || *line == ';' || *line == '#' || *line == '[') {
                continue;
            }
            equals = strchr(line, '=');
            if (equals == NULL) {
                continue;
            }
            *equals++ = '\0';
            apply_config_pair(trim_ascii(line), trim_ascii(equals));
        }
    }
    if (g_config.mode == RCSM_MODE_POLICY_MODULE && g_config.allowed_module == 0u) {
        ++g_config.config_errors;
    }
    if (g_config.config_errors != 0u) {
        log_line(
            "config rejected errors=%u; forcing safe mode=detect_only",
            (unsigned)g_config.config_errors
        );
        g_config.mode = RCSM_MODE_DETECT_ONLY;
    }
}

static int read_game_word(uint32_t address, uint32_t *value, void *user) {
    (void)user;
    if (value == NULL || address < 0x08800000u || address > 0x09FFFFFCu || (address & 3u) != 0u) {
        return -1;
    }
    *value = *(volatile const uint32_t *)(uintptr_t)address;
    return 0;
}

static int query_level_module_base(uint32_t *runtime_base) {
    SceUID modules[RCSM_MAX_MODULE_IDS];
    uint32_t candidate_base = 0u;
    int module_count = 0;
    int queried_modules = 0;
    int first_query_error = 0;
    int found = 0;
    int result;
    int index;
    if (runtime_base == NULL) {
        return -1;
    }
    *runtime_base = 0u;
    result = sceKernelGetModuleIdList(modules, (int)sizeof(modules), &module_count);
    if (result < 0) {
        return result;
    }
    if (module_count < 0) {
        return -1;
    }
    if (module_count > (int)RCSM_MAX_MODULE_IDS) {
        module_count = (int)RCSM_MAX_MODULE_IDS;
    }
    for (index = 0; index < module_count; ++index) {
        SceKernelModuleInfo info;
        uint64_t text_end;
        memset(&info, 0, sizeof(info));
        info.size = sizeof(info);
        result = sceKernelQueryModuleInfo(modules[index], &info);
        if (result < 0) {
            if (first_query_error == 0) {
                first_query_error = result;
            }
            continue;
        }
        ++queried_modules;
        if (strcmp(info.name, RCSM_LEVEL_MODULE_NAME) != 0) {
            continue;
        }
        text_end = (uint64_t)info.text_addr + (uint64_t)info.text_size;
        if (info.text_addr < 0x08800000u || info.text_addr > 0x09FFFFFCu ||
            (info.text_addr & 3u) != 0u || info.text_size == 0u || text_end > 0x0A000000u) {
            return RCSM_MODULE_API_INVALID;
        }
        if (found != 0 && candidate_base != info.text_addr) {
            return RCSM_MODULE_API_AMBIGUOUS;
        }
        candidate_base = info.text_addr;
        ++found;
    }
    if (found != 0) {
        *runtime_base = candidate_base;
        return RCSM_MODULE_API_FOUND;
    }
    if (queried_modules == 0 && module_count != 0 && first_query_error < 0) {
        return first_query_error;
    }
    return 0;
}

static int resolve_current_module(RcsmRuntimeDetection *resolved) {
    RcsmRuntimeDetection detection;
    RcsmModuleMatch scan_match;
    uint32_t runtime_base = 0u;
    int64_t delta;
    int api_status;
    memset(&detection, 0, sizeof(detection));
    memset(&scan_match, 0, sizeof(scan_match));
    api_status = query_level_module_base(&runtime_base);
    detection.module_api_status = api_status;
    if (api_status == RCSM_MODULE_API_FOUND) {
        detection.source = RCSM_RESOLUTION_MODULE_API;
        detection.runtime_base = runtime_base;
        delta = (int64_t)(uint64_t)runtime_base - (int64_t)(uint64_t)g_rcsm_reference_level_base;
        if (delta >= -2147483647LL - 1LL && delta <= 2147483647LL && (delta & 3LL) == 0LL) {
            detection.address_delta = (int32_t)delta;
            detection.reference_profile = rcsm_identify_module_at_delta(
                read_game_word,
                NULL,
                detection.address_delta,
                &detection.equivalent_matches
            );
        }
    } else if (api_status > RCSM_MODULE_API_FOUND) {
        detection.source = RCSM_RESOLUTION_MODULE_API;
    } else if (api_status < 0 && rcsm_scan_module_deltas(
            read_game_word,
            NULL,
            RCSM_FALLBACK_MIN_DELTA,
            RCSM_FALLBACK_MAX_DELTA,
            RCSM_FALLBACK_DELTA_STEP,
            &scan_match)) {
        detection.source = RCSM_RESOLUTION_FALLBACK_SCAN;
        detection.reference_profile = scan_match.profile;
        detection.address_delta = scan_match.address_delta;
        detection.equivalent_matches = scan_match.equivalent_matches;
        detection.scan_candidates = scan_match.candidate_count;
        (void)rcsm_apply_address_delta(
            g_rcsm_reference_level_base,
            detection.address_delta,
            &detection.runtime_base
        );
    } else if (api_status < 0) {
        detection.scan_candidates = scan_match.candidate_count;
    }
    if (detection.reference_profile != NULL) {
        uint32_t runtime_entry;
        if (rcsm_apply_address_delta(
                detection.reference_profile->two_pass_entry,
                detection.address_delta,
                &runtime_entry) &&
            read_game_word(runtime_entry, &detection.entry_guard_word, NULL) == 0) {
            detection.entry_guard_is_emuhack = rcsm_is_ppsspp_emuhack(detection.entry_guard_word);
        }
    }
    g_last_detection = detection;
    if (resolved != NULL) {
        *resolved = detection;
    }
    return detection.reference_profile != NULL;
}

static void log_unmatched_snapshot(void) {
    RcsmRuntimeDetection detection = g_last_detection;
    const RcsmModuleProfile *pokitaru = rcsm_find_module_profile(1u);
    uint32_t probe_word = 0xFFFFFFFFu;
    uint32_t entry_word = 0xFFFFFFFFu;
    uint32_t suppression_word = 0xFFFFFFFFu;
    uint32_t probe_address = g_rcsm_detection_anchor_count != 0u
        ? g_rcsm_detection_addresses[0]
        : 0u;
    uint32_t entry_address = pokitaru != NULL ? pokitaru->two_pass_entry : 0u;
    uint32_t suppression_address = pokitaru != NULL ? pokitaru->suppression_site : 0u;
    (void)resolve_current_module(&detection);
    if (detection.runtime_base != 0u) {
        (void)rcsm_apply_address_delta(probe_address, detection.address_delta, &probe_address);
        (void)rcsm_apply_address_delta(entry_address, detection.address_delta, &entry_address);
        (void)rcsm_apply_address_delta(suppression_address, detection.address_delta, &suppression_address);
    }
    if (probe_address != 0u) {
        (void)read_game_word(probe_address, &probe_word, NULL);
    }
    if (pokitaru != NULL) {
        (void)read_game_word(entry_address, &entry_word, NULL);
        (void)read_game_word(suppression_address, &suppression_word, NULL);
    }
    log_line(
        "manual export ignored: no recognized module resolver=%s api=%d base=0x%08X delta=%d candidates=%u probe=0x%08X/0x%08X L1_entry=0x%08X/0x%08X L1_suppression=0x%08X/0x%08X",
        resolution_source_name(detection.source),
        detection.module_api_status,
        (unsigned)detection.runtime_base,
        (int)detection.address_delta,
        detection.scan_candidates,
        (unsigned)probe_address,
        (unsigned)probe_word,
        (unsigned)entry_address,
        (unsigned)entry_word,
        (unsigned)suppression_address,
        (unsigned)suppression_word
    );
}

static int write_game_word(uint32_t address, uint32_t value, void *user) {
    (void)user;
    if (address < 0x08800000u || address > 0x09FFFFFCu || (address & 3u) != 0u) {
        return -1;
    }
    *(volatile uint32_t *)(uintptr_t)address = value;
    return 0;
}

static void sync_game_code(uint32_t address, uint32_t size, void *user) {
    const void *region = (const void *)(uintptr_t)address;
    (void)user;
    sceKernelDcacheWritebackInvalidateRange(region, size);
    sceKernelIcacheInvalidateRange(region, size);
}

static uint32_t hook_address_for_module(uint8_t module_index, uint8_t policy) {
    int one_pass = effective_policy(policy) == RCSM_POLICY_ONE_PASS;
    switch (module_index) {
        case 1u:  return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l01_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l01;
        case 2u:  return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l02_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l02;
        case 3u:  return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l03_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l03;
        case 4u:  return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l04_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l04;
        case 5u:  return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l05_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l05;
        case 6u:  return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l06_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l06;
        case 7u:  return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l07_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l07;
        case 8u:  return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l08_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l08;
        case 9u:  return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l09_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l09;
        case 10u: return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l10_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l10;
        case 15u: return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l15_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l15;
        case 21u: return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l21_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l21;
        case 22u: return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l22_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l22;
        case 23u: return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l23_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l23;
        case 24u: return one_pass ? (uint32_t)(uintptr_t)&rcsm_profiler_hook_l24_one : (uint32_t)(uintptr_t)&rcsm_profiler_hook_l24;
        default:  return 0u;
    }
}

static volatile uint32_t *tail_jump_for_module(uint8_t module_index, uint8_t policy) {
    int one_pass = effective_policy(policy) == RCSM_POLICY_ONE_PASS;
    switch (module_index) {
        case 1u:  return one_pass ? &rcsm_profiler_tail_l01_one : &rcsm_profiler_tail_l01;
        case 2u:  return one_pass ? &rcsm_profiler_tail_l02_one : &rcsm_profiler_tail_l02;
        case 3u:  return one_pass ? &rcsm_profiler_tail_l03_one : &rcsm_profiler_tail_l03;
        case 4u:  return one_pass ? &rcsm_profiler_tail_l04_one : &rcsm_profiler_tail_l04;
        case 5u:  return one_pass ? &rcsm_profiler_tail_l05_one : &rcsm_profiler_tail_l05;
        case 6u:  return one_pass ? &rcsm_profiler_tail_l06_one : &rcsm_profiler_tail_l06;
        case 7u:  return one_pass ? &rcsm_profiler_tail_l07_one : &rcsm_profiler_tail_l07;
        case 8u:  return one_pass ? &rcsm_profiler_tail_l08_one : &rcsm_profiler_tail_l08;
        case 9u:  return one_pass ? &rcsm_profiler_tail_l09_one : &rcsm_profiler_tail_l09;
        case 10u: return one_pass ? &rcsm_profiler_tail_l10_one : &rcsm_profiler_tail_l10;
        case 15u: return one_pass ? &rcsm_profiler_tail_l15_one : &rcsm_profiler_tail_l15;
        case 21u: return one_pass ? &rcsm_profiler_tail_l21_one : &rcsm_profiler_tail_l21;
        case 22u: return one_pass ? &rcsm_profiler_tail_l22_one : &rcsm_profiler_tail_l22;
        case 23u: return one_pass ? &rcsm_profiler_tail_l23_one : &rcsm_profiler_tail_l23;
        case 24u: return one_pass ? &rcsm_profiler_tail_l24_one : &rcsm_profiler_tail_l24;
        default:  return NULL;
    }
}

static int prepare_tail_jump(const RcsmModuleProfile *runtime_profile, uint8_t policy) {
    volatile uint32_t *tail;
    uint32_t tail_address;
    uint32_t destination;
    uint32_t observed;
    if (runtime_profile == NULL) {
        return 0;
    }
    tail = tail_jump_for_module(runtime_profile->module_index, policy);
    if (tail == NULL) {
        return 0;
    }
    tail_address = (uint32_t)(uintptr_t)tail;
    destination = effective_policy(policy) == RCSM_POLICY_ONE_PASS
        ? runtime_profile->one_pass_inner
        : runtime_profile->two_pass_entry;
    observed = *tail;
    if ((observed & 0xFC000000u) != 0x08000000u ||
        !rcsm_jal_reachable(tail_address, destination)) {
        return 0;
    }
    *tail = rcsm_encode_j(destination);
    sync_game_code(tail_address, 4u, NULL);
    return *tail == rcsm_encode_j(destination);
}

/* Hot path called by profiler_hook.S.  No allocation, formatting, file I/O,
   syscall, lock or floating-point operation is permitted here. */
__attribute__((noinline)) void rcsm_profiler_hook_c(uint32_t ra) {
    (void)__sync_fetch_and_add(&g_rcsm_active_hook_count, 1u);
    if (g_rcsm_recording_enabled != 0u) {
        (void)rcsm_record_hit(&g_profiler, ra, g_rcsm_vblank_sample);
    }
    (void)__sync_fetch_and_sub(&g_rcsm_active_hook_count, 1u);
}

static int wait_hooks_idle(void) {
    unsigned attempt;
    g_rcsm_recording_enabled = 0u;
    sceKernelDelayThread(RCSM_HOOK_DRAIN_US);
    for (attempt = 0u; attempt < RCSM_HOOK_DRAIN_ATTEMPTS; ++attempt) {
        if (g_rcsm_active_hook_count == 0u) {
            return 1;
        }
        sceKernelDelayThread(1000u);
    }
    return g_rcsm_active_hook_count == 0u;
}

static int callsite_was_installed(const RcsmRuntimeBinding *binding, uint32_t ra) {
    size_t index;
    if (binding == NULL || !binding->installed) {
        return 0;
    }
    for (index = 0u; index < binding->patch_view.callsite_count; ++index) {
        if (binding->patch_view.callsites[index].ra == ra) {
            return 1;
        }
    }
    return 0;
}

static void count_policy_routes(
    const RcsmModuleProfile *profile,
    unsigned *two_pass_count,
    unsigned *one_pass_count,
    unsigned *custom_fallback_count
);

static int export_trace(const RcsmRuntimeBinding *binding, const char *reason, int resume_recording) {
    char path[192];
    char line[640];
    uint32_t end_sample;
    size_t index;
    SceUID fd;
    int ok = 1;
    unsigned two_pass_count;
    unsigned one_pass_count;
    unsigned custom_fallback_count;
    const RcsmModuleProfile *profile;
    const RcsmModuleProfile *reference_profile;
    if (binding == NULL || binding->profile == NULL || binding->reference_profile == NULL ||
        g_profiler.profile != binding->profile) {
        return 0;
    }
    if (!wait_hooks_idle()) {
        log_line("trace refused: hook drain timeout module=%u", (unsigned)binding->profile->module_index);
        return 0;
    }
    end_sample = g_rcsm_vblank_sample;
    memcpy(g_snapshot_stats, g_profiler.stats, sizeof(g_snapshot_stats));
    g_snapshot_unknown_hits = g_profiler.unknown_hits;
    profile = binding->profile;
    reference_profile = binding->reference_profile;
    if (binding->installed) {
        count_policy_routes(
            &binding->patch_view,
            &two_pass_count,
            &one_pass_count,
            &custom_fallback_count
        );
    } else {
        two_pass_count = 0u;
        one_pass_count = 0u;
        custom_fallback_count = 0u;
    }
    ++g_trace_sequence;
    (void)rcsm_format(
        path,
        sizeof(path),
        RCSM_TRACE_PREFIX "_L%02u_%04u.json",
        (unsigned)profile->module_index,
        (unsigned)g_trace_sequence
    );
    fd = sceIoOpen(path, PSP_O_WRONLY | PSP_O_CREAT | PSP_O_TRUNC, 0666);
    if (fd < 0) {
        log_line("trace open failed path=%s error=0x%08X", path, (unsigned)fd);
        if (resume_recording && binding->installed && !g_stop_requested &&
            g_config.instrumentation_enabled) {
            g_rcsm_recording_enabled = 1u;
        }
        return 0;
    }
#define RCSM_WRITE_LITERAL(text) do { \
        static const char literal[] = text; \
        if (!write_all(fd, literal, sizeof(literal) - 1u)) { ok = 0; } \
    } while (0)
    RCSM_WRITE_LITERAL("{\n");
    (void)rcsm_format(line, sizeof(line), "  \"schema\": \"rcsm-wrapper-trace/5\",\n");
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(line, sizeof(line), "  \"game_id\": \"UCES00420\",\n");
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(line, sizeof(line), "  \"plugin_version\": \"%s\",\n", RCSM_VERSION);
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(line, sizeof(line), "  \"target_environment\": \"PPSSPP 1.19.3 / Windows 11\",\n");
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(line, sizeof(line), "  \"mode\": \"%s\",\n", runtime_mode_name(g_config.mode));
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(line, sizeof(line), "  \"reason\": \"%s\",\n", reason);
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(line, sizeof(line), "  \"module_index\": %u,\n", (unsigned)profile->module_index);
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(line, sizeof(line), "  \"module_key\": \"%s\",\n", profile->module_key);
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(line, sizeof(line), "  \"sample_unit\": \"vblank\",\n");
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(
        line,
        sizeof(line),
        "  \"policy\": {\"default\": \"%s\", \"instrumentation_enabled\": %s, \"two_pass_callsites\": %u, \"one_pass_callsites\": %u, \"custom_fallback_callsites\": %u},\n",
        policy_name(g_config.default_policy),
        g_config.instrumentation_enabled ? "true" : "false",
        two_pass_count,
        one_pass_count,
        custom_fallback_count
    );
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(
        line,
        sizeof(line),
        "  \"capture\": {\"start_sample\": %u, \"end_sample\": %u, \"installed_callsites\": %u, \"equivalent_profile_matches\": %u, \"reference_base\": \"0x%08X\", \"runtime_base\": \"0x%08X\", \"address_delta\": %d, \"resolution_source\": \"%s\"},\n",
        (unsigned)binding->capture_start,
        (unsigned)end_sample,
        binding->installed ? (unsigned)binding->patch_view.callsite_count : 0u,
        (unsigned)binding->equivalent_matches,
        (unsigned)g_rcsm_reference_level_base,
        (unsigned)binding->runtime_base,
        (int)binding->address_delta,
        resolution_source_name(binding->resolution_source)
    );
    ok = ok && write_all(fd, line, strlen(line));
    (void)rcsm_format(line, sizeof(line), "  \"unknown_hits\": %u,\n", (unsigned)g_snapshot_unknown_hits);
    ok = ok && write_all(fd, line, strlen(line));
    RCSM_WRITE_LITERAL("  \"entries\": [\n");
    for (index = 0u; index < profile->callsite_count; ++index) {
        const RcsmCallsiteProfile *callsite = &profile->callsites[index];
        const RcsmCallsiteProfile *reference_callsite = &reference_profile->callsites[index];
        const RcsmTraceStat *stat = &g_snapshot_stats[index];
        (void)rcsm_format(
            line,
            sizeof(line),
            "    {\"ra\": \"0x%08X\", \"runtime_ra\": \"0x%08X\", \"family_id\": \"WF-%03u\", \"installed\": %s, \"configured_policy\": \"%s\", \"effective_policy\": \"%s\", \"custom_fallback\": %s, \"hits\": %u, \"first_sample\": %u, \"last_sample\": %u, \"active_vblanks\": %u, \"same_vblank_hits\": %u, \"max_hits_per_vblank\": %u, \"gap_1_vblank\": %u, \"gap_2_vblank\": %u, \"gap_other_vblank\": %u}%s\n",
            (unsigned)reference_callsite->ra,
            (unsigned)callsite->ra,
            (unsigned)reference_callsite->family_id,
            callsite_was_installed(binding, callsite->ra) ? "true" : "false",
            policy_name(callsite->policy),
            policy_name(effective_policy(callsite->policy)),
            callsite->policy == RCSM_POLICY_CUSTOM ? "true" : "false",
            (unsigned)stat->hits,
            (unsigned)stat->first_sample,
            (unsigned)stat->last_sample,
            (unsigned)stat->active_vblanks,
            (unsigned)stat->same_vblank_hits,
            (unsigned)stat->max_hits_per_vblank,
            (unsigned)stat->gap_1_vblank,
            (unsigned)stat->gap_2_vblank,
            (unsigned)stat->gap_other_vblank,
            index + 1u == profile->callsite_count ? "" : ","
        );
        ok = ok && write_all(fd, line, strlen(line));
    }
    RCSM_WRITE_LITERAL("  ]\n}\n");
#undef RCSM_WRITE_LITERAL
    (void)sceIoClose(fd);
    log_line(
        "trace %s path=%s module=%u entries=%u",
        ok ? "saved" : "write_failed",
        path,
        (unsigned)profile->module_index,
        (unsigned)profile->callsite_count
    );
    if (resume_recording && binding->installed && !g_stop_requested &&
        g_config.instrumentation_enabled) {
        g_rcsm_recording_enabled = 1u;
    }
    return ok;
}

static uint8_t configured_policy_for_callsite(const RcsmCallsiteProfile *reference_callsite) {
    uint8_t policy;
    size_t index;
    if (reference_callsite == NULL) {
        return RCSM_POLICY_TWO_PASS;
    }
    policy = g_config.default_policy;
    if (reference_callsite->family_id <= RCSM_MAX_FAMILY_ID &&
        g_config.family_policies[reference_callsite->family_id] != RCSM_POLICY_UNSPECIFIED) {
        policy = g_config.family_policies[reference_callsite->family_id];
    }
    for (index = 0u; index < g_config.ra_override_count; ++index) {
        if (g_config.ra_overrides[index].reference_ra == reference_callsite->ra) {
            policy = g_config.ra_overrides[index].policy;
            break;
        }
    }
    return policy;
}

static int apply_runtime_policies(RcsmRuntimeBinding *binding) {
    uint8_t family_seen[RCSM_MAX_FAMILY_ID + 1u];
    uint8_t ra_seen[RCSM_MAX_RA_OVERRIDES];
    size_t index;
    unsigned custom_count = 0u;
    if (binding == NULL || binding->reference_profile == NULL || binding->profile == NULL) {
        return 0;
    }
    if (g_config.mode != RCSM_MODE_POLICY_MODULE ||
        binding->profile->module_index != g_config.allowed_module) {
        return 1;
    }
    memset(family_seen, 0, sizeof(family_seen));
    memset(ra_seen, 0, sizeof(ra_seen));
    for (index = 0u; index < binding->profile->callsite_count; ++index) {
        const RcsmCallsiteProfile *reference_callsite = &binding->reference_profile->callsites[index];
        uint8_t policy = configured_policy_for_callsite(reference_callsite);
        size_t override_index;
        binding->runtime_callsites[index].policy = policy;
        if (policy == RCSM_POLICY_CUSTOM) {
            ++custom_count;
        }
        if (reference_callsite->family_id <= RCSM_MAX_FAMILY_ID) {
            family_seen[reference_callsite->family_id] = 1u;
        }
        for (override_index = 0u; override_index < g_config.ra_override_count; ++override_index) {
            if (g_config.ra_overrides[override_index].reference_ra == reference_callsite->ra) {
                ra_seen[override_index] = 1u;
            }
        }
    }
    for (index = 1u; index <= RCSM_MAX_FAMILY_ID; ++index) {
        if (g_config.family_policies[index] != RCSM_POLICY_UNSPECIFIED && family_seen[index] == 0u) {
            log_line(
                "policy config refused key=%s absent_family=WF-%03u",
                binding->profile->module_key,
                (unsigned)index
            );
            return 0;
        }
    }
    for (index = 0u; index < g_config.ra_override_count; ++index) {
        if (ra_seen[index] == 0u) {
            log_line(
                "policy config refused key=%s absent_reference_ra=0x%08X",
                binding->profile->module_key,
                (unsigned)g_config.ra_overrides[index].reference_ra
            );
            return 0;
        }
    }
    if (custom_count != 0u) {
        log_line(
            "custom policies use safe two_pass fallback key=%s callsites=%u",
            binding->profile->module_key,
            custom_count
        );
    }
    return 1;
}

static void count_policy_routes(
    const RcsmModuleProfile *profile,
    unsigned *two_pass_count,
    unsigned *one_pass_count,
    unsigned *custom_fallback_count
) {
    size_t index;
    unsigned two_pass = 0u;
    unsigned one_pass = 0u;
    unsigned custom_fallback = 0u;
    if (profile != NULL) {
        for (index = 0u; index < profile->callsite_count; ++index) {
            if (profile->callsites[index].policy == RCSM_POLICY_ONE_PASS) {
                ++one_pass;
            } else {
                ++two_pass;
                if (profile->callsites[index].policy == RCSM_POLICY_CUSTOM) {
                    ++custom_fallback;
                }
            }
        }
    }
    if (two_pass_count != NULL) {
        *two_pass_count = two_pass;
    }
    if (one_pass_count != NULL) {
        *one_pass_count = one_pass;
    }
    if (custom_fallback_count != NULL) {
        *custom_fallback_count = custom_fallback;
    }
}

static int prepare_patch_view(RcsmRuntimeBinding *binding) {
    const RcsmModuleProfile *profile;
    RcsmModuleProfile *view;
    size_t index;
    size_t focused_count = 0u;
    uint32_t runtime_single_ra;
    if (binding == NULL || binding->profile == NULL) {
        return 0;
    }
    profile = binding->profile;
    view = &binding->patch_view;
    *view = *profile;
    if (g_config.mode == RCSM_MODE_POLICY_MODULE) {
        return g_config.allowed_module == profile->module_index;
    }
    if (g_config.mode == RCSM_MODE_FULL_MODULE) {
        return g_config.allowed_module == 0u || g_config.allowed_module == profile->module_index;
    }
    if (g_config.mode == RCSM_MODE_FOCUSED_POKITARU) {
        if (profile->module_index != 1u ||
            (g_config.allowed_module != 0u && g_config.allowed_module != profile->module_index)) {
            return 0;
        }
        for (index = 0u; index < profile->callsite_count; ++index) {
            if (profile->callsites[index].family_id == g_config.focus_family) {
                if (focused_count >= RCSM_MAX_ACTIVE_CALLS) {
                    return 0;
                }
                binding->focused_callsites[focused_count++] = profile->callsites[index];
            }
        }
        if (focused_count == 0u) {
            return 0;
        }
        view->callsites = binding->focused_callsites;
        view->callsite_count = focused_count;
        return 1;
    }
    if (g_config.mode != RCSM_MODE_SINGLE_POKITARU || profile->module_index != 1u ||
        !rcsm_apply_address_delta(g_config.single_ra, binding->address_delta, &runtime_single_ra)) {
        return 0;
    }
    for (index = 0u; index < profile->callsite_count; ++index) {
        if (profile->callsites[index].ra == runtime_single_ra) {
            view->callsites = &profile->callsites[index];
            view->callsite_count = 1u;
            return 1;
        }
    }
    return 0;
}

static int activate_profile(const RcsmRuntimeDetection *detection) {
    RcsmPatchResult patch = {0u, 0u, 0u, 0u};
    const RcsmModuleProfile *profile;
    int wants_patch;
    uint32_t two_pass_hook_target;
    uint32_t one_pass_hook_target;
    unsigned two_pass_count;
    unsigned one_pass_count;
    unsigned custom_fallback_count;
    if (detection == NULL || detection->reference_profile == NULL) {
        return 0;
    }
    memset(&g_binding, 0, sizeof(g_binding));
    g_binding.reference_profile = detection->reference_profile;
    g_binding.address_delta = detection->address_delta;
    g_binding.runtime_base = detection->runtime_base;
    g_binding.equivalent_matches = detection->equivalent_matches;
    g_binding.resolution_source = detection->source;
    g_binding.jit_entry_seen = detection->entry_guard_is_emuhack;
    if (!rcsm_relocate_profile(
            detection->reference_profile,
            detection->address_delta,
            &g_binding.runtime_profile,
            g_binding.runtime_callsites,
            RCSM_MAX_ACTIVE_CALLS)) {
        g_rcsm_last_patch_error = 1u;
        return 0;
    }
    profile = &g_binding.runtime_profile;
    g_binding.profile = profile;
    if (!apply_runtime_policies(&g_binding)) {
        g_rcsm_last_patch_error = 3u;
        return 0;
    }
    if (!rcsm_bind_profile(&g_profiler, profile)) {
        g_rcsm_last_patch_error = 1u;
        return 0;
    }
    g_binding.capture_start = g_rcsm_vblank_sample;
    g_rcsm_active_module_index = profile->module_index;
    g_rcsm_equivalent_profile_matches = detection->equivalent_matches;
    wants_patch = prepare_patch_view(&g_binding);
    if (!wants_patch) {
        log_line(
            "module detected key=%s index=%u matches=%u mode=%s writes=0 resolver=%s base=0x%08X delta=%d entry=0x%08X jit=%u",
            profile->module_key,
            (unsigned)profile->module_index,
            detection->equivalent_matches,
            runtime_mode_name(g_config.mode),
            resolution_source_name(detection->source),
            (unsigned)detection->runtime_base,
            (int)detection->address_delta,
            (unsigned)detection->entry_guard_word,
            (unsigned)detection->entry_guard_is_emuhack
        );
        return 1;
    }
    two_pass_hook_target = hook_address_for_module(profile->module_index, RCSM_POLICY_TWO_PASS);
    one_pass_hook_target = hook_address_for_module(profile->module_index, RCSM_POLICY_ONE_PASS);
    g_binding.two_pass_hook_target = two_pass_hook_target;
    g_binding.one_pass_hook_target = one_pass_hook_target;
    if (two_pass_hook_target == 0u || one_pass_hook_target == 0u ||
        !prepare_tail_jump(profile, RCSM_POLICY_TWO_PASS) ||
        !prepare_tail_jump(profile, RCSM_POLICY_ONE_PASS) ||
        !rcsm_install_policy_redirects(
            &g_binding.patch_view,
            two_pass_hook_target,
            one_pass_hook_target,
            read_game_word,
            write_game_word,
            sync_game_code,
            NULL,
            &patch)) {
        RcsmPatchResult cleanup;
        (void)rcsm_remove_policy_redirects(
            &g_binding.patch_view,
            two_pass_hook_target,
            one_pass_hook_target,
            read_game_word,
            write_game_word,
            sync_game_code,
            NULL,
            &cleanup
        );
        g_rcsm_last_patch_error = 2u;
        log_line(
            "install refused key=%s two_hook=0x%08X one_hook=0x%08X base=0x%08X delta=%d examined=%u modified=%u mismatched=%u rollback=%u",
            profile->module_key,
            (unsigned)two_pass_hook_target,
            (unsigned)one_pass_hook_target,
            (unsigned)detection->runtime_base,
            (int)detection->address_delta,
            (unsigned)patch.examined,
            (unsigned)patch.modified,
            (unsigned)patch.mismatched,
            (unsigned)patch.rolled_back
        );
        return 0;
    }
    g_binding.installed = 1;
    g_rcsm_installed_callsite_count = g_binding.patch_view.callsite_count;
    g_rcsm_recording_enabled = g_config.instrumentation_enabled ? 1u : 0u;
    count_policy_routes(
        &g_binding.patch_view,
        &two_pass_count,
        &one_pass_count,
        &custom_fallback_count
    );
    log_line(
        "module armed key=%s index=%u mode=%s callsites=%u two_pass=%u one_pass=%u custom_fallback=%u two_hook=0x%08X one_hook=0x%08X resolver=%s base=0x%08X delta=%d entry=0x%08X jit=%u",
        profile->module_key,
        (unsigned)profile->module_index,
        runtime_mode_name(g_config.mode),
        (unsigned)g_binding.patch_view.callsite_count,
        two_pass_count,
        one_pass_count,
        custom_fallback_count,
        (unsigned)two_pass_hook_target,
        (unsigned)one_pass_hook_target,
        resolution_source_name(detection->source),
        (unsigned)detection->runtime_base,
        (int)detection->address_delta,
        (unsigned)detection->entry_guard_word,
        (unsigned)detection->entry_guard_is_emuhack
    );
    return 1;
}

static void deactivate_profile(int restore_if_still_active, const char *reason) {
    RcsmPatchResult patch = {0u, 0u, 0u, 0u};
    if (g_binding.profile == NULL) {
        return;
    }
    (void)wait_hooks_idle();
    if (g_config.export_on_transition || strcmp(reason, "manual") == 0) {
        (void)export_trace(&g_binding, reason, 0);
        g_rcsm_recording_enabled = 0u;
    }
    if (restore_if_still_active && g_binding.installed) {
        (void)rcsm_remove_policy_redirects(
            &g_binding.patch_view,
            g_binding.two_pass_hook_target,
            g_binding.one_pass_hook_target,
            read_game_word,
            write_game_word,
            sync_game_code,
            NULL,
            &patch
        );
        log_line(
            "redirects removed key=%s modified=%u mismatched=%u reason=%s",
            g_binding.profile->module_key,
            (unsigned)patch.modified,
            (unsigned)patch.mismatched,
            reason
        );
    }
    memset(&g_binding, 0, sizeof(g_binding));
    memset(&g_profiler, 0, sizeof(g_profiler));
    g_rcsm_active_module_index = 0u;
    g_rcsm_equivalent_profile_matches = 0u;
    g_rcsm_installed_callsite_count = 0u;
    g_rcsm_recording_enabled = 0u;
}

static int reference_profiles_same(const RcsmModuleProfile *left, const RcsmModuleProfile *right) {
    if (left == right) {
        return 1;
    }
    return left != NULL && right != NULL && rcsm_profiles_equivalent(left, right) &&
           left->two_pass_entry == right->two_pass_entry;
}

static int detections_same(const RcsmRuntimeDetection *left, const RcsmRuntimeDetection *right) {
    return left != NULL && right != NULL && left->reference_profile != NULL &&
           right->reference_profile != NULL && left->address_delta == right->address_delta &&
           reference_profiles_same(left->reference_profile, right->reference_profile);
}

static int detection_matches_binding(
    const RcsmRuntimeDetection *detection,
    const RcsmRuntimeBinding *binding
) {
    return detection != NULL && binding != NULL && binding->reference_profile != NULL &&
           detection->reference_profile != NULL && detection->address_delta == binding->address_delta &&
           reference_profiles_same(detection->reference_profile, binding->reference_profile);
}

typedef enum RcsmHealthResult {
    RCSM_HEALTH_FOREIGN = -1,
    RCSM_HEALTH_RELOAD = 0,
    RCSM_HEALTH_OK = 1
} RcsmHealthResult;

static RcsmHealthResult check_redirect_health(void) {
    RcsmRedirectState state;
    if (!g_binding.installed) {
        return RCSM_HEALTH_OK;
    }
    if (!rcsm_classify_policy_redirects(
            &g_binding.patch_view,
            g_binding.two_pass_hook_target,
            g_binding.one_pass_hook_target,
            read_game_word,
            NULL,
            &state)) {
        log_line(
            "health failure key=%s original=%u two_hook=%u one_hook=%u wrong_route=%u foreign=%u unreadable=%u",
            g_binding.profile->module_key,
            (unsigned)state.original,
            (unsigned)state.redirected_two_pass,
            (unsigned)state.redirected_one_pass,
            (unsigned)state.wrong_route,
            (unsigned)state.foreign,
            (unsigned)state.unreadable
        );
        return RCSM_HEALTH_FOREIGN;
    }
    if (state.redirected == g_binding.patch_view.callsite_count) {
        return RCSM_HEALTH_OK;
    }
    log_line(
        "health changed key=%s original=%u two_hook=%u one_hook=%u; treating as same-level reload",
        g_binding.profile->module_key,
        (unsigned)state.original,
        (unsigned)state.redirected_two_pass,
        (unsigned)state.redirected_one_pass
    );
    return RCSM_HEALTH_RELOAD;
}

static void reset_capture(void) {
    if (g_binding.profile == NULL) {
        return;
    }
    if (!wait_hooks_idle()) {
        log_line("reset refused: hook drain timeout");
        return;
    }
    (void)rcsm_bind_profile(&g_profiler, g_binding.profile);
    g_binding.capture_start = g_rcsm_vblank_sample;
    if (g_binding.installed && g_config.instrumentation_enabled) {
        g_rcsm_recording_enabled = 1u;
    }
    log_line("capture reset key=%s sample=%u", g_binding.profile->module_key, (unsigned)g_binding.capture_start);
}

static void process_controls(uint32_t *previous_buttons) {
    SceCtrlData pad;
    uint32_t buttons;
    uint32_t export_combo = PSP_CTRL_LTRIGGER | PSP_CTRL_RTRIGGER | PSP_CTRL_SELECT;
    uint32_t reset_combo = PSP_CTRL_LTRIGGER | PSP_CTRL_RTRIGGER | PSP_CTRL_START;
    if (!g_config.controls_enabled || previous_buttons == NULL ||
        sceCtrlPeekBufferPositive(&pad, 1) <= 0) {
        return;
    }
    buttons = pad.Buttons;
    if ((buttons & export_combo) == export_combo && (*previous_buttons & export_combo) != export_combo) {
        if (g_binding.profile == NULL) {
            log_unmatched_snapshot();
        } else {
            (void)export_trace(&g_binding, "manual", 1);
        }
    }
    if ((buttons & reset_combo) == reset_combo && (*previous_buttons & reset_combo) != reset_combo) {
        reset_capture();
    }
    *previous_buttons = buttons;
}

static int vblank_thread(SceSize args, void *argp) {
    (void)args;
    (void)argp;
    while (!g_stop_requested) {
        if (sceDisplayWaitVblankStart() >= 0 && g_rcsm_vblank_sample != 0xFFFFFFFFu) {
            ++g_rcsm_vblank_sample;
        }
    }
    sceKernelExitThread(0);
    return 0;
}

static void monitor_loop(void) {
    RcsmRuntimeDetection candidate;
    RcsmRuntimeDetection blocked;
    int candidate_valid = 0;
    int blocked_valid = 0;
    uint32_t previous_buttons = 0u;
    uint32_t stable_count = 0u;
    uint32_t health_counter = 0u;
    memset(&candidate, 0, sizeof(candidate));
    memset(&blocked, 0, sizeof(blocked));
    log_line(
        "start version=%s target=PPSSPP-1.19.3-Windows11 trace_schema=5 mode=%s default_policy=%s allowed_module=%u instrumentation=%u ra_overrides=%u poll_us=%u stable=%u reference_base=0x%08X resolver=module_api+fallback_scan",
        RCSM_VERSION,
        runtime_mode_name(g_config.mode),
        policy_name(g_config.default_policy),
        (unsigned)g_config.allowed_module,
        (unsigned)(g_config.instrumentation_enabled != 0),
        (unsigned)g_config.ra_override_count,
        (unsigned)g_config.poll_us,
        (unsigned)g_config.stable_polls,
        (unsigned)g_rcsm_reference_level_base
    );
    while (!g_stop_requested) {
        RcsmRuntimeDetection detected;
        int detected_valid = resolve_current_module(&detected);
        if (g_binding.profile != NULL &&
            detection_matches_binding(&detected, &g_binding) &&
            detected.entry_guard_is_emuhack && !g_binding.jit_entry_seen) {
            uint32_t runtime_entry = 0u;
            (void)rcsm_apply_address_delta(
                g_binding.reference_profile->two_pass_entry,
                g_binding.address_delta,
                &runtime_entry
            );
            g_binding.jit_entry_seen = 1;
            log_line(
                "PPSSPP JIT marker accepted key=%s address=0x%08X word=0x%08X; remaining guards valid",
                g_binding.profile->module_key,
                (unsigned)runtime_entry,
                (unsigned)detected.entry_guard_word
            );
        }
        if (g_binding.profile != NULL &&
            !(detected.module_api_status < 0 && detected.runtime_base == 0u) &&
            !detection_matches_binding(&detected, &g_binding)) {
            /* Once a different fingerprint is visible, the level loader owns
               these addresses.  Do not restore words from the old PRX. */
            deactivate_profile(0, "module_transition");
            candidate_valid = 0;
            stable_count = 0u;
            blocked_valid = 0;
            health_counter = 0u;
        }
        if (g_binding.profile == NULL) {
            if (!detected_valid) {
                candidate_valid = 0;
                stable_count = 0u;
                blocked_valid = 0;
            } else if (blocked_valid && detections_same(&detected, &blocked)) {
                candidate_valid = 0;
                stable_count = 0u;
            } else if (!candidate_valid || !detections_same(&detected, &candidate)) {
                candidate = detected;
                candidate_valid = 1;
                stable_count = 1u;
            } else if (stable_count < g_config.stable_polls) {
                ++stable_count;
            }
            if (candidate_valid && stable_count >= g_config.stable_polls) {
                if (!activate_profile(&candidate)) {
                    blocked = candidate;
                    blocked_valid = 1;
                }
                candidate_valid = 0;
                stable_count = 0u;
            }
        } else {
            ++health_counter;
            if (health_counter >= RCSM_HEALTH_PERIOD_POLLS) {
                health_counter = 0u;
                RcsmHealthResult health = check_redirect_health();
                if (health != RCSM_HEALTH_OK) {
                    RcsmRuntimeDetection failed;
                    memset(&failed, 0, sizeof(failed));
                    failed.reference_profile = g_binding.reference_profile;
                    failed.address_delta = g_binding.address_delta;
                    failed.runtime_base = g_binding.runtime_base;
                    failed.equivalent_matches = g_binding.equivalent_matches;
                    failed.source = g_binding.resolution_source;
                    deactivate_profile(1, "redirect_health_change");
                    /* A clean original/hook mixture is the signature of a
                       same-level reload. Re-detect and re-arm only after the
                       usual stability window. Foreign or unreadable words
                       fail closed for the rest of this module residency. */
                    if (health == RCSM_HEALTH_FOREIGN) {
                        blocked = failed;
                        blocked_valid = 1;
                    } else {
                        blocked_valid = 0;
                    }
                    candidate_valid = 0;
                    stable_count = 0u;
                }
            }
        }
        process_controls(&previous_buttons);
        sceKernelDelayThread(g_config.poll_us);
    }
    if (g_binding.profile != NULL) {
        RcsmRuntimeDetection detected;
        (void)resolve_current_module(&detected);
        deactivate_profile(detection_matches_binding(&detected, &g_binding), "plugin_stop");
    }
    log_line("stop version=%s", RCSM_VERSION);
}

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;
    g_rcsm_plugin_gp = capture_gp();
    g_stop_requested = 0;
    g_monitor_thread = sceKernelGetThreadId();
    load_config();
    g_vblank_thread = sceKernelCreateThread(
        "rcsm_vblank_clock", vblank_thread, 0x2Eu, 0x800u, PSP_THREAD_ATTR_USER, NULL
    );
    if (g_vblank_thread >= 0) {
        (void)sceKernelStartThread(g_vblank_thread, 0, NULL);
    }
    monitor_loop();
    sceKernelExitThread(0);
    return 0; /* Unreachable; keeps the C signature explicit. */
}

int module_stop(SceSize args, void *argp) {
    (void)args;
    (void)argp;
    g_stop_requested = 1;
    if (g_monitor_thread >= 0) {
        (void)sceKernelWaitThreadEnd(g_monitor_thread, NULL);
        (void)sceKernelDeleteThread(g_monitor_thread);
    }
    if (g_vblank_thread >= 0) {
        (void)sceKernelWaitThreadEnd(g_vblank_thread, NULL);
        (void)sceKernelDeleteThread(g_vblank_thread);
    }
    return 0;
}
