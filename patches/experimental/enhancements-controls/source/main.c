/*
 * RACSM Controls - PPSSPP proof of concept for Ratchet & Clank: Size Matters
 * UCES-00420 (Europe)
 *
 * Copyright (c) 2026
 * SPDX-License-Identifier: MIT
 *
 * This plugin is deliberately signature-gated.  It does not use fixed runtime
 * addresses and will only patch a loaded rcp1 gameplay module when both the
 * camera-input and controller-update functions are found exactly once.
 */

#include <pspctrl.h>
#include <pspiofilemgr.h>
#include <pspkernel.h>
#include <pspmodulemgr.h>
#include <pspsdk.h>
#include <pspthreadman.h>

#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

PSP_MODULE_INFO("RACSMControls", 0, 0, 1);
PSP_MAIN_THREAD_ATTR(PSP_THREAD_ATTR_USER);

#define PLUGIN_VERSION "0.1.0-poc"
#define PPSSPP_DEVCTL_IS_EMULATOR 0x00000003

#define CONFIG_PATH "ms0:/PSP/PLUGINS/RACSM_Controls/racsm_controls.ini"
#define LOG_PATH    "ms0:/PSP/PLUGINS/RACSM_Controls/racsm_controls.log"

/* PPSSPP's Extended PSP controls.  These are unused/reserved on a retail PSP. */
#define PPSSPP_CTRL_L2 0x00000400u
#define PPSSPP_CTRL_R2 0x00000800u

#define GAME_PAD_PREVIOUS_OFFSET 0x18u
#define CAMERA_FLAGS_OFFSET       0x41u
#define CAMERA_YAW_INPUT_OFFSET   0x274u
#define CAMERA_PITCH_INPUT_OFFSET 0x278u

#define USER_RAM_START 0x08800000u
#define USER_RAM_END   0x0A000000u

typedef struct {
    u32 mask;
    u32 value;
} SignatureWord;

typedef int (*CameraFunction)(void);

typedef struct {
    int camera_enabled;
    int deadzone;
    int invert_x;
    int invert_y;
    int sensitivity_x;
    int sensitivity_y;
    u32 l2_alias;
    u32 r2_alias;
    int debug_log;
} PluginConfig;

static const SignatureWord kCameraSignature[] = {
    { 0xFFFFFFFFu, 0x27BDFFD0u }, /* addiu sp, sp, -0x30 */
    { 0xFFFFFFFFu, 0xE7B40010u }, /* swc1  f20, 0x10(sp) */
    { 0xFFFFFFFFu, 0xAFB00014u },
    { 0xFFFFFFFFu, 0xAFB10018u },
    { 0xFFFFFFFFu, 0xAFB2001Cu },
    { 0xFFFFFFFFu, 0xAFBF0020u },
    { 0xFC000000u, 0x0C000000u }, /* jal, relocated target */
    { 0xFFFFFFFFu, 0x34041802u },
    { 0xFFFF0000u, 0x3C100000u }, /* lui s0, relocated high */
    { 0xFFFF0000u, 0x26100000u }, /* addiu s0, s0, relocated low */
};

static const SignatureWord kControllerSignature[] = {
    { 0xFFFFFFFFu, 0x27BDFFD0u },
    { 0xFFFFFFFFu, 0xAFB20018u },
    { 0xFFFF0000u, 0x3C120000u }, /* lui s2, relocated high */
    { 0xFFFFFFFFu, 0xAFB10014u },
    { 0xFFFF0000u, 0x26510000u }, /* addiu s1, s2, relocated low */
    { 0xFFFFFFFFu, 0x02202025u },
    { 0xFFFFFFFFu, 0xAFB00010u },
    { 0xFFFFFFFFu, 0xAFB3001Cu },
    { 0xFFFFFFFFu, 0xAFBF0020u },
    { 0xFC000000u, 0x0C000000u }, /* sceCtrlPeekBufferPositive */
    { 0xFFFFFFFFu, 0x34050001u },
    { 0xFFFF0000u, 0x3C130000u },
    { 0xFFFF0000u, 0x26730000u },
    { 0xFC000000u, 0x0C000000u },
    { 0xFFFFFFFFu, 0x02602025u },
    { 0xFC000000u, 0x0C000000u },
    { 0xFFFFFFFFu, 0x34040006u },
    { 0xFFFFFFFFu, 0x92240008u },
};

static PluginConfig g_config = {
    1,   /* camera_enabled */
    24,  /* deadzone */
    0,   /* invert_x */
    0,   /* invert_y */
    100, /* sensitivity_x */
    100, /* sensitivity_y */
    0,   /* l2_alias */
    0,   /* r2_alias */
    1,   /* debug_log */
};

static volatile int g_running = 1;
static volatile int g_seen_l2 = 0;
static volatile int g_seen_r2 = 0;
static int g_reported_l2 = 0;
static int g_reported_r2 = 0;
static SceUID g_worker_thread = -1;

static SceUID g_active_module = -1;
static u32 g_active_text = 0;
static u32 g_camera_target = 0;
static u32 g_controller_stub = 0;
static u32 g_game_pad = 0;
static u32 g_camera_state = 0;
static u32 g_camera_original_words[2] = { 0, 0 };
static u32 g_controller_original_words[2] = { 0, 0 };
static SceUID g_ignored_module = -1;

static u32 g_camera_trampoline[3] __attribute__((aligned(16)));
static CameraFunction g_original_camera = NULL;

/* build_prx.mak omits the regular PRX CRT because this module exports its own
 * module_start. Newlib's abort path still references _exit, so provide the
 * minimal user-mode implementation needed by that path. */
void _exit(int status) __attribute__((noreturn));
void _exit(int status) {
    sceKernelExitDeleteThread(status);
    for (;;) {
    }
}

static void log_message(const char *format, ...) {
    char buffer[320];
    va_list args;
    int length;
    SceUID fd;

    if (!g_config.debug_log) {
        return;
    }

    va_start(args, format);
    length = vsnprintf(buffer, sizeof(buffer), format, args);
    va_end(args);

    if (length < 0) {
        return;
    }
    if (length > (int)sizeof(buffer) - 2) {
        length = (int)sizeof(buffer) - 2;
    }
    buffer[length++] = '\n';

    fd = sceIoOpen(LOG_PATH, PSP_O_WRONLY | PSP_O_CREAT | PSP_O_APPEND, 0777);
    if (fd >= 0) {
        sceIoWrite(fd, buffer, length);
        sceIoClose(fd);
    }
}

static char *trim(char *text) {
    char *end;
    while (*text && isspace((unsigned char)*text)) {
        ++text;
    }
    end = text + strlen(text);
    while (end > text && isspace((unsigned char)end[-1])) {
        --end;
    }
    *end = '\0';
    return text;
}

static int equal_ci(const char *left, const char *right) {
    while (*left && *right) {
        if (tolower((unsigned char)*left) != tolower((unsigned char)*right)) {
            return 0;
        }
        ++left;
        ++right;
    }
    return *left == '\0' && *right == '\0';
}

static int clamp_int(int value, int minimum, int maximum) {
    if (value < minimum) {
        return minimum;
    }
    if (value > maximum) {
        return maximum;
    }
    return value;
}

static u32 parse_alias(const char *name) {
    if (equal_ci(name, "OFF") || equal_ci(name, "NONE")) {
        return 0;
    }
    if (equal_ci(name, "SELECT")) {
        return PSP_CTRL_SELECT;
    }
    if (equal_ci(name, "START")) {
        return PSP_CTRL_START;
    }
    if (equal_ci(name, "UP")) {
        return PSP_CTRL_UP;
    }
    if (equal_ci(name, "RIGHT")) {
        return PSP_CTRL_RIGHT;
    }
    if (equal_ci(name, "DOWN")) {
        return PSP_CTRL_DOWN;
    }
    if (equal_ci(name, "LEFT")) {
        return PSP_CTRL_LEFT;
    }
    if (equal_ci(name, "L") || equal_ci(name, "LTRIGGER")) {
        return PSP_CTRL_LTRIGGER;
    }
    if (equal_ci(name, "R") || equal_ci(name, "RTRIGGER")) {
        return PSP_CTRL_RTRIGGER;
    }
    if (equal_ci(name, "L+R") || equal_ci(name, "CAMERA_CENTER")) {
        return PSP_CTRL_LTRIGGER | PSP_CTRL_RTRIGGER;
    }
    if (equal_ci(name, "TRIANGLE")) {
        return PSP_CTRL_TRIANGLE;
    }
    if (equal_ci(name, "CIRCLE")) {
        return PSP_CTRL_CIRCLE;
    }
    if (equal_ci(name, "CROSS")) {
        return PSP_CTRL_CROSS;
    }
    if (equal_ci(name, "SQUARE")) {
        return PSP_CTRL_SQUARE;
    }
    return 0;
}

static void load_config(void) {
    SceUID fd;
    char contents[2048];
    int bytes_read;
    char *cursor;

    fd = sceIoOpen(CONFIG_PATH, PSP_O_RDONLY, 0777);
    if (fd < 0) {
        return;
    }
    bytes_read = sceIoRead(fd, contents, sizeof(contents) - 1);
    sceIoClose(fd);
    if (bytes_read <= 0) {
        return;
    }
    contents[bytes_read] = '\0';
    cursor = contents;

    while (*cursor) {
        char *key;
        char *value;
        char *separator;
        char *line_end = strchr(cursor, '\n');

        if (line_end) {
            *line_end = '\0';
        }

        key = trim(cursor);
        if (*key == '\0' || *key == ';' || *key == '#' || *key == '[') {
            goto next_line;
        }

        separator = strchr(key, '=');
        if (!separator) {
            goto next_line;
        }
        *separator = '\0';
        value = trim(separator + 1);
        key = trim(key);

        if (equal_ci(key, "camera_enabled")) {
            g_config.camera_enabled = atoi(value) != 0;
        } else if (equal_ci(key, "deadzone")) {
            g_config.deadzone = clamp_int(atoi(value), 0, 126);
        } else if (equal_ci(key, "invert_x")) {
            g_config.invert_x = atoi(value) != 0;
        } else if (equal_ci(key, "invert_y")) {
            g_config.invert_y = atoi(value) != 0;
        } else if (equal_ci(key, "sensitivity_x")) {
            g_config.sensitivity_x = clamp_int(atoi(value), 10, 300);
        } else if (equal_ci(key, "sensitivity_y")) {
            g_config.sensitivity_y = clamp_int(atoi(value), 10, 300);
        } else if (equal_ci(key, "l2")) {
            g_config.l2_alias = parse_alias(value);
        } else if (equal_ci(key, "r2")) {
            g_config.r2_alias = parse_alias(value);
        } else if (equal_ci(key, "debug_log")) {
            g_config.debug_log = atoi(value) != 0;
        }

next_line:
        if (!line_end) {
            break;
        }
        cursor = line_end + 1;
    }
}

static int valid_user_address(u32 address, u32 size) {
    if (address < USER_RAM_START || address >= USER_RAM_END) {
        return 0;
    }
    if (size > USER_RAM_END - address) {
        return 0;
    }
    return 1;
}

static int match_signature(u32 address, const SignatureWord *signature, int count) {
    int index;
    for (index = 0; index < count; ++index) {
        u32 instruction = _lw(address + (u32)index * 4u);
        if ((instruction & signature[index].mask) != signature[index].value) {
            return 0;
        }
    }
    return 1;
}

static u32 find_unique_signature(u32 text, u32 size,
                                 const SignatureWord *signature, int signature_count,
                                 int *matches) {
    u32 offset;
    u32 found = 0;
    u32 signature_size = (u32)signature_count * 4u;

    *matches = 0;
    if (!valid_user_address(text, size) || size < signature_size) {
        return 0;
    }

    for (offset = 0; offset <= size - signature_size; offset += 4u) {
        u32 address = text + offset;
        if (match_signature(address, signature, signature_count)) {
            found = address;
            ++*matches;
            if (*matches > 1) {
                return 0;
            }
        }
    }

    return *matches == 1 ? found : 0;
}

static u32 decode_lui_addiu(u32 lui_instruction, u32 addiu_instruction) {
    u32 high = (lui_instruction & 0xFFFFu) << 16;
    s32 low = (s16)(addiu_instruction & 0xFFFFu);
    return high + (u32)low;
}

static u32 decode_jump_target(u32 instruction_address, u32 instruction) {
    return ((instruction_address + 4u) & 0xF0000000u)
        | ((instruction & 0x03FFFFFFu) << 2);
}

static u32 make_jump(u32 target) {
    return 0x08000000u | ((target >> 2) & 0x03FFFFFFu);
}

static float axis_strength(u8 raw, int inverted) {
    int delta = (int)raw - 128;
    int magnitude;
    float strength;

    if (inverted) {
        delta = -delta;
    }
    magnitude = delta < 0 ? -delta : delta;
    if (magnitude <= g_config.deadzone) {
        return 0.0f;
    }
    if (magnitude > 127) {
        magnitude = 127;
    }

    strength = (float)(magnitude - g_config.deadzone)
        / (float)(127 - g_config.deadzone);
    return delta < 0 ? -strength : strength;
}

static float absolute_float(float value) {
    return value < 0.0f ? -value : value;
}

static u32 inject_camera_buttons(u32 buttons, float x, float y) {
    if (x != 0.0f) {
        buttons &= ~(PSP_CTRL_LTRIGGER | PSP_CTRL_RTRIGGER);
        buttons |= x > 0.0f ? PSP_CTRL_RTRIGGER : PSP_CTRL_LTRIGGER;
    }
    if (y != 0.0f) {
        buttons &= ~(PSP_CTRL_UP | PSP_CTRL_DOWN);
        buttons |= y > 0.0f ? PSP_CTRL_DOWN : PSP_CTRL_UP;
    }
    return buttons;
}

static void observe_extended_buttons(u32 buttons) {
    if ((buttons & PPSSPP_CTRL_L2) != 0) {
        g_seen_l2 = 1;
    }
    if ((buttons & PPSSPP_CTRL_R2) != 0) {
        g_seen_r2 = 1;
    }
}

static int controller_peek_hook(SceCtrlData *samples, int count) {
    int result = sceCtrlPeekBufferPositive(samples, count);
    int index;
    int samples_to_process;

    if (result <= 0 || samples == NULL || count <= 0) {
        return result;
    }

    samples_to_process = result < count ? result : count;
    for (index = 0; index < samples_to_process; ++index) {
        u32 physical = samples[index].Buttons;
        observe_extended_buttons(physical);

        /* Do not leak the reserved bits into Size Matters' transition masks. */
        samples[index].Buttons = physical & ~(PPSSPP_CTRL_L2 | PPSSPP_CTRL_R2);
        if ((physical & PPSSPP_CTRL_L2) != 0) {
            samples[index].Buttons |= g_config.l2_alias;
        }
        if ((physical & PPSSPP_CTRL_R2) != 0) {
            samples[index].Buttons |= g_config.r2_alias;
        }
    }

    return result;
}

static int camera_hook(void) {
    CameraFunction original = g_original_camera;
    SceCtrlData pad;
    float x;
    float y;
    volatile u32 *current_buttons;
    volatile u32 *previous_buttons;
    volatile u8 *camera_flags;
    u32 saved_current;
    u32 saved_previous;
    u8 saved_flags;
    int result;

    if (!original) {
        return 0;
    }

    if (!g_config.camera_enabled
        || !valid_user_address(g_game_pad, GAME_PAD_PREVIOUS_OFFSET + sizeof(SceCtrlData))
        || !valid_user_address(g_camera_state, CAMERA_PITCH_INPUT_OFFSET + sizeof(float))) {
        return original();
    }

    memset(&pad, 0, sizeof(pad));
    if (sceCtrlPeekBufferPositive(&pad, 1) <= 0) {
        return original();
    }

    observe_extended_buttons(pad.Buttons);
    x = axis_strength(pad.Rx, g_config.invert_x);
    y = axis_strength(pad.Ry, g_config.invert_y);
    if (x == 0.0f && y == 0.0f) {
        return original();
    }

    current_buttons = (volatile u32 *)(g_game_pad + 4u);
    previous_buttons = (volatile u32 *)(g_game_pad + GAME_PAD_PREVIOUS_OFFSET + 4u);
    camera_flags = (volatile u8 *)(g_camera_state + CAMERA_FLAGS_OFFSET);

    saved_current = *current_buttons;
    saved_previous = *previous_buttons;
    saved_flags = *camera_flags;

    *current_buttons = inject_camera_buttons(saved_current, x, y);
    *previous_buttons = inject_camera_buttons(saved_previous, x, y);
    if (y != 0.0f) {
        *camera_flags = saved_flags | 0x08u;
    }

    result = original();

    *current_buttons = saved_current;
    *previous_buttons = saved_previous;
    *camera_flags = saved_flags;

    if (x != 0.0f) {
        volatile float *yaw = (volatile float *)(g_camera_state + CAMERA_YAW_INPUT_OFFSET);
        *yaw *= absolute_float(x) * ((float)g_config.sensitivity_x / 100.0f);
    }
    if (y != 0.0f) {
        volatile float *pitch = (volatile float *)(g_camera_state + CAMERA_PITCH_INPUT_OFFSET);
        *pitch *= absolute_float(y) * ((float)g_config.sensitivity_y / 100.0f);
    }
    return result;
}

static int install_camera_hook(u32 target) {
    u32 hook_address = (u32)camera_hook;
    u32 trampoline_address = (u32)g_camera_trampoline;

    if (((target + 4u) & 0xF0000000u) != (hook_address & 0xF0000000u)
        || ((trampoline_address + 4u) & 0xF0000000u) != ((target + 8u) & 0xF0000000u)) {
        return 0;
    }

    g_camera_original_words[0] = _lw(target);
    g_camera_original_words[1] = _lw(target + 4u);

    g_camera_trampoline[0] = g_camera_original_words[0];
    g_camera_trampoline[1] = make_jump(target + 8u);
    g_camera_trampoline[2] = g_camera_original_words[1];
    g_original_camera = (CameraFunction)g_camera_trampoline;

    _sw(make_jump(hook_address), target);
    _sw(0, target + 4u);
    g_camera_target = target;
    return 1;
}

static int install_controller_hook(u32 stub) {
    u32 hook_address = (u32)controller_peek_hook;

    if (((stub + 4u) & 0xF0000000u) != (hook_address & 0xF0000000u)
        || !valid_user_address(stub, 8u)) {
        return 0;
    }

    g_controller_original_words[0] = _lw(stub);
    g_controller_original_words[1] = _lw(stub + 4u);
    _sw(make_jump(hook_address), stub);
    _sw(0, stub + 4u);
    g_controller_stub = stub;
    return 1;
}

static void flush_caches(void) {
    sceKernelDcacheWritebackAll();
    sceKernelIcacheInvalidateAll();
}

static void clear_inactive_state(void) {
    g_active_module = -1;
    g_active_text = 0;
    g_camera_target = 0;
    g_controller_stub = 0;
    g_game_pad = 0;
    g_camera_state = 0;
    g_original_camera = NULL;
}

static int patch_gameplay_module(SceUID module_id, const SceKernelModuleInfo *info) {
    int camera_matches;
    int controller_matches;
    u32 camera_function;
    u32 controller_function;
    u32 camera_pointer;
    u32 pad_pointer;
    u32 peek_call;
    u32 peek_stub;
    int controller_hooked = 0;

    camera_function = find_unique_signature(info->text_addr, info->text_size,
        kCameraSignature, (int)(sizeof(kCameraSignature) / sizeof(kCameraSignature[0])),
        &camera_matches);
    controller_function = find_unique_signature(info->text_addr, info->text_size,
        kControllerSignature, (int)(sizeof(kControllerSignature) / sizeof(kControllerSignature[0])),
        &controller_matches);

    if (camera_matches != 1 || controller_matches != 1) {
        return 0;
    }

    camera_pointer = decode_lui_addiu(_lw(camera_function + 0x20u),
                                      _lw(camera_function + 0x24u));
    pad_pointer = decode_lui_addiu(_lw(controller_function + 0x08u),
                                   _lw(controller_function + 0x10u));
    peek_call = _lw(controller_function + 0x24u);
    if ((peek_call & 0xFC000000u) != 0x0C000000u) {
        log_message("controller JAL validation failed at %08X", controller_function + 0x24u);
        return 0;
    }
    peek_stub = decode_jump_target(controller_function + 0x24u, peek_call);

    if (!valid_user_address(camera_pointer, CAMERA_PITCH_INPUT_OFFSET + sizeof(float))
        || !valid_user_address(pad_pointer, GAME_PAD_PREVIOUS_OFFSET + sizeof(SceCtrlData))
        || !valid_user_address(peek_stub, 8u)) {
        log_message("pointer validation failed camera=%08X pad=%08X stub=%08X",
                    camera_pointer, pad_pointer, peek_stub);
        return 0;
    }

    g_camera_state = camera_pointer;
    g_game_pad = pad_pointer;

    if (!install_camera_hook(camera_function)) {
        clear_inactive_state();
        log_message("camera hook installation failed at %08X", camera_function);
        return 0;
    }

    controller_hooked = install_controller_hook(peek_stub);

    flush_caches();
    g_active_module = module_id;
    g_active_text = info->text_addr;
    log_message("patched rcp1 uid=%d text=%08X camera=%08X pad=%08X%s",
                module_id, info->text_addr, camera_function, pad_pointer,
                controller_hooked ? " controller-filter=on" : " controller-filter=off");
    if (!controller_hooked) {
        log_message("warning: L2/R2 controller hook was not installed");
    }
    return 1;
}

static int active_module_is_loaded(const SceUID *modules, int count) {
    int index;
    if (g_active_module < 0) {
        return 0;
    }
    for (index = 0; index < count; ++index) {
        if (modules[index] == g_active_module) {
            return 1;
        }
    }
    return 0;
}

static int module_is_loaded(SceUID module_id, const SceUID *modules, int count) {
    int index;
    if (module_id < 0) {
        return 0;
    }
    for (index = 0; index < count; ++index) {
        if (modules[index] == module_id) {
            return 1;
        }
    }
    return 0;
}

static void scan_modules(void) {
    SceUID modules[64];
    int count = 0;
    int index;

    if (sceKernelGetModuleIdList(modules, sizeof(modules), &count) < 0) {
        return;
    }
    if (count > (int)(sizeof(modules) / sizeof(modules[0]))) {
        count = (int)(sizeof(modules) / sizeof(modules[0]));
    }

    if (active_module_is_loaded(modules, count)) {
        return;
    }
    if (g_active_module >= 0) {
        log_message("gameplay module unloaded uid=%d", g_active_module);
        clear_inactive_state();
    }
    if (!module_is_loaded(g_ignored_module, modules, count)) {
        g_ignored_module = -1;
    }

    for (index = 0; index < count; ++index) {
        SceKernelModuleInfo info;
        memset(&info, 0, sizeof(info));
        info.size = sizeof(info);
        if (sceKernelQueryModuleInfo(modules[index], &info) < 0) {
            continue;
        }
        if (strcmp(info.name, "rcp1") != 0) {
            continue;
        }
        if (modules[index] == g_ignored_module) {
            continue;
        }
        if (patch_gameplay_module(modules[index], &info)) {
            return;
        }
        /* FRONTEND.PRX has the same module name but neither gameplay
         * signature. Remember it so the worker does not rescan ~2 MiB four
         * times per second while sitting in the title screen. */
        g_ignored_module = modules[index];
    }
}

static int worker_thread(SceSize args, void *argp) {
    (void)args;
    (void)argp;

    while (g_running) {
        scan_modules();

        if (g_seen_l2 && !g_reported_l2) {
            g_reported_l2 = 1;
            log_message("PPSSPP Dev-kit L2 detected");
        }
        if (g_seen_r2 && !g_reported_r2) {
            g_reported_r2 = 1;
            log_message("PPSSPP Dev-kit R2 detected");
        }

        sceKernelDelayThread(250000);
    }

    sceKernelExitDeleteThread(0);
    return 0;
}

static void restore_hooks_if_loaded(void) {
    int restored = 0;

    if (g_camera_target != 0
        && valid_user_address(g_camera_target, 8u)
        && _lw(g_camera_target) == make_jump((u32)camera_hook)) {
        _sw(g_camera_original_words[0], g_camera_target);
        _sw(g_camera_original_words[1], g_camera_target + 4u);
        restored = 1;
    }
    if (g_controller_stub != 0
        && valid_user_address(g_controller_stub, 8u)
        && _lw(g_controller_stub) == make_jump((u32)controller_peek_hook)) {
        _sw(g_controller_original_words[0], g_controller_stub);
        _sw(g_controller_original_words[1], g_controller_stub + 4u);
        restored = 1;
    }
    if (restored) {
        flush_caches();
    }
}

int module_start(SceSize args, void *argp) {
    (void)args;
    (void)argp;

    if (sceIoDevctl("kemulator:", PPSSPP_DEVCTL_IS_EMULATOR,
                   NULL, 0, NULL, 0) != 0) {
        return 0;
    }

    load_config();
    sceCtrlSetSamplingMode(PSP_CTRL_MODE_ANALOG);
    log_message("RACSM Controls %s started camera=%d deadzone=%d L2=%08X R2=%08X",
                PLUGIN_VERSION, g_config.camera_enabled, g_config.deadzone,
                g_config.l2_alias, g_config.r2_alias);

    g_worker_thread = sceKernelCreateThread("racsm_controls_worker", worker_thread,
                                            0x18, 0x4000,
                                            PSP_THREAD_ATTR_USER, NULL);
    if (g_worker_thread >= 0) {
        sceKernelStartThread(g_worker_thread, 0, NULL);
    } else {
        log_message("worker thread creation failed: %d", g_worker_thread);
    }
    return 0;
}

int module_stop(SceSize args, void *argp) {
    (void)args;
    (void)argp;

    g_running = 0;
    if (g_worker_thread >= 0) {
        sceKernelWaitThreadEnd(g_worker_thread, NULL);
        g_worker_thread = -1;
    }
    restore_hooks_if_loaded();
    return 0;
}
