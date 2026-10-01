/*
 * OCEnhance - optional camera/controls enhancements for Ratchet & Clank: Size Matters
 * (UCES00420) on PPSSPP. Priority 2: separable from the 60 FPS parity work, every
 * feature is off unless enabled in ocenhance.ini.
 *
 * Based on RACSM Controls 0.1.0-poc (MIT, patches/experimental/enhancements-controls):
 * same signature-gated camera-input hook (LEVEL_01 0x3060) and controller filter
 * (LEVEL_01 0x75454 -> sceCtrlPeekBufferPositive stub). Rewritten without libc (no
 * printf/malloc/newlib startup) to keep the resident footprint small: a heavy plugin
 * was the suspected cause of a crash when loading Dayni Moon (2026-10-01).
 *
 * Failsafe: nothing is written unless the loaded "rcp1" module contains each signature
 * exactly once (true for gameplay levels, false for FRONTEND). Patched words live in the
 * level module, so they disappear when the level unloads; the worker re-scans.
 *
 * Features (all INFERRED from static analysis; see docs/DECOMPILATION_FINDINGS.md):
 *  - right stick -> camera: Rx/Ry injected as R/L and D-pad during the camera-input call,
 *    scaled by stick amplitude (vertical needs camera flag +0x41 bit 3, forced in the call);
 *  - PPSSPP Dev-kit L2/R2: removed from the game's button word, optionally aliased;
 *  - view: vertical FOV, follow-camera distance and height constants, found per level by the
 *    pattern {FOV 0.5498, near 1.0, far 10000.0} with distance 5.0 at +0x30 and height
 *    1.14 at +0x3C (unique in the 15 level PRX checked; LEVEL_01 0x2AA3C0).
 * SPDX-License-Identifier: MIT
 */
#include <pspctrl.h>
#include <pspiofilemgr.h>
#include <pspkernel.h>
#include <pspmodulemgr.h>
#include <pspthreadman.h>

PSP_MODULE_INFO("OCEnhance", 0, 1, 0);

#define CONFIG_PATH "ms0:/PSP/PLUGINS/OCEnhance/ocenhance.ini"
#define LOG_PATH    "ms0:/PSP/PLUGINS/OCEnhance/ocenhance.log"
#define PPSSPP_DEVCTL_IS_EMULATOR 0x00000003
#define PPSSPP_CTRL_L2 0x00000400u
#define PPSSPP_CTRL_R2 0x00000800u
#define GAME_PAD_PREVIOUS_OFFSET 0x18u
#define CAMERA_FLAGS_OFFSET 0x41u
#define CAMERA_YAW_INPUT_OFFSET 0x274u
#define CAMERA_PITCH_INPUT_OFFSET 0x278u
#define USER_RAM_START 0x08800000u
#define USER_RAM_END 0x0A000000u

/* View constants: FOV 0.5498 rad, near 1.0, far 10000.0; distance 5.0 at +0x30 (copied to +0x34
 * by the camera init 0xCA24), height 1.14 at +0x3C (copy at +0x40). */
#define VIEW_FOV 0x3F0CBE4Cu
#define VIEW_NEAR 0x3F800000u
#define VIEW_FAR 0x461C4000u
#define VIEW_DIST 0x40A00000u
#define VIEW_HEIGHT 0x3F91EB85u

typedef struct { u32 mask, value; } SignatureWord;
typedef int (*CameraFunction)(void);

static const SignatureWord kCameraSignature[] = {
    {0xFFFFFFFFu, 0x27BDFFD0u}, {0xFFFFFFFFu, 0xE7B40010u}, {0xFFFFFFFFu, 0xAFB00014u},
    {0xFFFFFFFFu, 0xAFB10018u}, {0xFFFFFFFFu, 0xAFB2001Cu}, {0xFFFFFFFFu, 0xAFBF0020u},
    {0xFC000000u, 0x0C000000u}, {0xFFFFFFFFu, 0x34041802u}, {0xFFFF0000u, 0x3C100000u},
    {0xFFFF0000u, 0x26100000u},
};
static const SignatureWord kControllerSignature[] = {
    {0xFFFFFFFFu, 0x27BDFFD0u}, {0xFFFFFFFFu, 0xAFB20018u}, {0xFFFF0000u, 0x3C120000u},
    {0xFFFFFFFFu, 0xAFB10014u}, {0xFFFF0000u, 0x26510000u}, {0xFFFFFFFFu, 0x02202025u},
    {0xFFFFFFFFu, 0xAFB00010u}, {0xFFFFFFFFu, 0xAFB3001Cu}, {0xFFFFFFFFu, 0xAFBF0020u},
    {0xFC000000u, 0x0C000000u}, {0xFFFFFFFFu, 0x34050001u}, {0xFFFF0000u, 0x3C130000u},
    {0xFFFF0000u, 0x26730000u}, {0xFC000000u, 0x0C000000u}, {0xFFFFFFFFu, 0x02602025u},
    {0xFC000000u, 0x0C000000u}, {0xFFFFFFFFu, 0x34040006u}, {0xFFFFFFFFu, 0x92240008u},
};

static struct {
    int right_stick, deadzone, invert_x, invert_y, sensitivity_x, sensitivity_y;
    u32 l2_alias, r2_alias;
    float fov_deg, cam_distance, cam_height;      /* 0 = unchanged */
    int debug_log;
} g_cfg = {0, 24, 0, 0, 100, 100, 0, 0, 0.0f, 0.0f, 0.0f, 0};

static volatile int g_running = 1;
static SceUID g_worker = -1, g_active_module = -1, g_ignored_module = -1;
static u32 g_camera_target, g_controller_stub, g_game_pad, g_camera_state, g_view;
static u32 g_camera_words[2], g_controller_words[2];
static u32 g_view_words[5];                       /* original FOV, dist, dist copy, height, height copy */
static u32 g_camera_trampoline[3] __attribute__((aligned(16)));
static CameraFunction g_original_camera;

/* ---- freestanding helpers (no libc) ---- */
void *memset(void *d, int c, unsigned n) { unsigned char *p = d; while (n--) *p++ = (unsigned char)c; return d; }
void *memcpy(void *d, const void *s, unsigned n) { unsigned char *p = d; const unsigned char *q = s; while (n--) *p++ = *q++; return d; }
static int is_space(char c) { return c == ' ' || c == '\t' || c == '\r' || c == '\n'; }
static char lower(char c) { return c >= 'A' && c <= 'Z' ? (char)(c + 32) : c; }
static int eq_ci(const char *a, const char *b) {
    while (*a && *b) { if (lower(*a) != lower(*b)) return 0; a++; b++; }
    return !*a && !*b;
}
static int streq(const char *a, const char *b) { while (*a && *a == *b) { a++; b++; } return *a == *b; }
static char *trim(char *t) {
    char *e;
    while (*t && is_space(*t)) t++;
    for (e = t; *e; e++) {}
    while (e > t && is_space(e[-1])) e--;
    *e = 0;
    return t;
}
static float parse_float(const char *s) {                 /* [-]digits[.digits] */
    float v = 0.0f, scale = 0.1f; int neg = 0;
    if (*s == '-') { neg = 1; s++; }
    while (*s >= '0' && *s <= '9') v = v * 10.0f + (float)(*s++ - '0');
    if (*s == '.') for (s++; *s >= '0' && *s <= '9'; s++) { v += (float)(*s - '0') * scale; scale *= 0.1f; }
    return neg ? -v : v;
}
static int parse_int(const char *s) { return (int)parse_float(s); }
static int clamp(int v, int lo, int hi) { return v < lo ? lo : v > hi ? hi : v; }
static u32 fbits(float f) { union { float f; u32 u; } x; x.f = f; return x.u; }

static void log_line(const char *text, u32 value) {
    char buf[96]; int n = 0, i; SceUID fd;
    if (!g_cfg.debug_log) return;
    while (*text && n < 80) buf[n++] = *text++;
    buf[n++] = ' ';
    for (i = 7; i >= 0; i--) buf[n++] = "0123456789ABCDEF"[(value >> (i * 4)) & 0xF];
    buf[n++] = '\n';
    fd = sceIoOpen(LOG_PATH, PSP_O_WRONLY | PSP_O_CREAT | PSP_O_APPEND, 0777);
    if (fd >= 0) { sceIoWrite(fd, buf, n); sceIoClose(fd); }
}

static u32 parse_alias(const char *n) {
    static const struct { const char *name; u32 mask; } t[] = {
        {"SELECT", PSP_CTRL_SELECT}, {"START", PSP_CTRL_START}, {"UP", PSP_CTRL_UP}, {"RIGHT", PSP_CTRL_RIGHT},
        {"DOWN", PSP_CTRL_DOWN}, {"LEFT", PSP_CTRL_LEFT}, {"L", PSP_CTRL_LTRIGGER}, {"R", PSP_CTRL_RTRIGGER},
        {"L+R", PSP_CTRL_LTRIGGER | PSP_CTRL_RTRIGGER}, {"CAMERA_CENTER", PSP_CTRL_LTRIGGER | PSP_CTRL_RTRIGGER},
        {"TRIANGLE", PSP_CTRL_TRIANGLE}, {"CIRCLE", PSP_CTRL_CIRCLE}, {"CROSS", PSP_CTRL_CROSS}, {"SQUARE", PSP_CTRL_SQUARE}};
    unsigned i;
    for (i = 0; i < sizeof(t) / sizeof(t[0]); i++) if (eq_ci(n, t[i].name)) return t[i].mask;
    return 0;
}

static void load_config(void) {
    static char buf[2048];
    char *cur; int got; SceUID fd = sceIoOpen(CONFIG_PATH, PSP_O_RDONLY, 0777);
    if (fd < 0) return;
    got = sceIoRead(fd, buf, sizeof(buf) - 1); sceIoClose(fd);
    if (got <= 0) return;
    buf[got] = 0;
    for (cur = buf; *cur;) {
        char *end = cur, *key, *val, *eqp;
        while (*end && *end != '\n') end++;
        if (*end) *end++ = 0;
        key = trim(cur); cur = end;
        if (!*key || *key == ';' || *key == '#' || *key == '[') continue;
        for (eqp = key; *eqp && *eqp != '='; eqp++) {}
        if (!*eqp) continue;
        *eqp = 0; val = trim(eqp + 1); key = trim(key);
        if (eq_ci(key, "right_stick")) g_cfg.right_stick = parse_int(val) != 0;
        else if (eq_ci(key, "deadzone")) g_cfg.deadzone = clamp(parse_int(val), 0, 126);
        else if (eq_ci(key, "invert_x")) g_cfg.invert_x = parse_int(val) != 0;
        else if (eq_ci(key, "invert_y")) g_cfg.invert_y = parse_int(val) != 0;
        else if (eq_ci(key, "sensitivity_x")) g_cfg.sensitivity_x = clamp(parse_int(val), 10, 300);
        else if (eq_ci(key, "sensitivity_y")) g_cfg.sensitivity_y = clamp(parse_int(val), 10, 300);
        else if (eq_ci(key, "l2")) g_cfg.l2_alias = parse_alias(val);
        else if (eq_ci(key, "r2")) g_cfg.r2_alias = parse_alias(val);
        else if (eq_ci(key, "fov_deg")) g_cfg.fov_deg = parse_float(val);
        else if (eq_ci(key, "cam_distance")) g_cfg.cam_distance = parse_float(val);
        else if (eq_ci(key, "cam_height")) g_cfg.cam_height = parse_float(val);
        else if (eq_ci(key, "debug_log")) g_cfg.debug_log = parse_int(val) != 0;
    }
    if (g_cfg.fov_deg != 0.0f && (g_cfg.fov_deg < 20.0f || g_cfg.fov_deg > 60.0f)) g_cfg.fov_deg = 0.0f;
    if (g_cfg.cam_distance != 0.0f && (g_cfg.cam_distance < 2.0f || g_cfg.cam_distance > 15.0f)) g_cfg.cam_distance = 0.0f;
    if (g_cfg.cam_height != 0.0f && (g_cfg.cam_height < 0.3f || g_cfg.cam_height > 4.0f)) g_cfg.cam_height = 0.0f;
}

/* ---- signatures ---- */
static int valid(u32 a, u32 size) { return a >= USER_RAM_START && a < USER_RAM_END && size <= USER_RAM_END - a; }
static u32 find_unique(u32 text, u32 size, const SignatureWord *sig, int count) {
    u32 off, found = 0, bytes = (u32)count * 4u; int matches = 0, i;
    if (!valid(text, size) || size < bytes) return 0;
    for (off = 0; off <= size - bytes; off += 4u) {
        for (i = 0; i < count && (_lw(text + off + (u32)i * 4u) & sig[i].mask) == sig[i].value; i++) {}
        if (i == count) { found = text + off; if (++matches > 1) return 0; }
    }
    return matches == 1 ? found : 0;
}
static u32 lui_addiu(u32 lui, u32 addiu) { return ((lui & 0xFFFFu) << 16) + (u32)(s32)(s16)(addiu & 0xFFFFu); }
static u32 jump_target(u32 at, u32 ins) { return ((at + 4u) & 0xF0000000u) | ((ins & 0x03FFFFFFu) << 2); }
static u32 make_j(u32 target) { return 0x08000000u | ((target >> 2) & 0x03FFFFFFu); }

/* ---- controls ---- */
static float axis(u8 raw, int inverted) {
    int d = (int)raw - 128, m;
    if (inverted) d = -d;
    m = d < 0 ? -d : d;
    if (m <= g_cfg.deadzone) return 0.0f;
    if (m > 127) m = 127;
    return (d < 0 ? -1.0f : 1.0f) * (float)(m - g_cfg.deadzone) / (float)(127 - g_cfg.deadzone);
}
static u32 inject(u32 b, float x, float y) {
    if (x != 0.0f) { b &= ~(PSP_CTRL_LTRIGGER | PSP_CTRL_RTRIGGER); b |= x > 0.0f ? PSP_CTRL_RTRIGGER : PSP_CTRL_LTRIGGER; }
    if (y != 0.0f) { b &= ~(PSP_CTRL_UP | PSP_CTRL_DOWN); b |= y > 0.0f ? PSP_CTRL_DOWN : PSP_CTRL_UP; }
    return b;
}

static int controller_peek_hook(SceCtrlData *s, int count) {
    int r = sceCtrlPeekBufferPositive(s, count), i;
    if (r <= 0 || !s || count <= 0) return r;
    for (i = 0; i < (r < count ? r : count); i++) {
        u32 p = s[i].Buttons;
        s[i].Buttons = p & ~(PPSSPP_CTRL_L2 | PPSSPP_CTRL_R2);     /* reserved bits never reach the game */
        if (p & PPSSPP_CTRL_L2) s[i].Buttons |= g_cfg.l2_alias;
        if (p & PPSSPP_CTRL_R2) s[i].Buttons |= g_cfg.r2_alias;
    }
    return r;
}

static int camera_hook(void) {
    CameraFunction original = g_original_camera;
    SceCtrlData pad; float x, y; int r;
    volatile u32 *cur, *prev; volatile u8 *flags; u32 sc, sp; u8 sf;
    if (!original) return 0;
    if (!g_cfg.right_stick) return original();
    memset(&pad, 0, sizeof(pad));
    if (sceCtrlPeekBufferPositive(&pad, 1) <= 0) return original();
    x = axis(pad.Rx, g_cfg.invert_x); y = axis(pad.Ry, g_cfg.invert_y);
    if (x == 0.0f && y == 0.0f) return original();
    cur = (volatile u32 *)(g_game_pad + 4u); prev = (volatile u32 *)(g_game_pad + GAME_PAD_PREVIOUS_OFFSET + 4u);
    flags = (volatile u8 *)(g_camera_state + CAMERA_FLAGS_OFFSET);
    sc = *cur; sp = *prev; sf = *flags;
    *cur = inject(sc, x, y); *prev = inject(sp, x, y);
    if (y != 0.0f) *flags = sf | 0x08u;
    r = original();
    *cur = sc; *prev = sp; *flags = sf;
    if (x != 0.0f) *(volatile float *)(g_camera_state + CAMERA_YAW_INPUT_OFFSET) *= (x < 0 ? -x : x) * (float)g_cfg.sensitivity_x / 100.0f;
    if (y != 0.0f) *(volatile float *)(g_camera_state + CAMERA_PITCH_INPUT_OFFSET) *= (y < 0 ? -y : y) * (float)g_cfg.sensitivity_y / 100.0f;
    return r;
}

/* ---- view constants ---- */
static u32 find_view(const SceKernelModuleInfo *info) {
    int s; u32 found = 0; int matches = 0;
    for (s = 0; s < info->nsegment && s < 4; s++) {
        u32 a = info->segmentaddr[s], n = info->segmentsize[s], off;
        if (!valid(a, n) || n < 0x44u) continue;
        for (off = 0; off <= n - 0x44u; off += 4u) {
            u32 p = a + off;
            if (_lw(p) == VIEW_FOV && _lw(p + 4u) == VIEW_NEAR && _lw(p + 8u) == VIEW_FAR &&
                _lw(p + 0x30u) == VIEW_DIST && _lw(p + 0x3Cu) == VIEW_HEIGHT) { found = p; matches++; }
        }
    }
    return matches == 1 ? found : 0;
}
static void apply_view(u32 v) {
    static const u32 offs[5] = {0x00u, 0x30u, 0x34u, 0x3Cu, 0x40u};
    int i;
    for (i = 0; i < 5; i++) g_view_words[i] = _lw(v + offs[i]);
    if (g_cfg.fov_deg != 0.0f) _sw(fbits(g_cfg.fov_deg * 3.14159265f / 180.0f), v);
    if (g_cfg.cam_distance != 0.0f) {
        _sw(fbits(g_cfg.cam_distance), v + 0x30u);
        if (g_view_words[2] == VIEW_DIST) _sw(fbits(g_cfg.cam_distance), v + 0x34u);   /* init copy */
    }
    if (g_cfg.cam_height != 0.0f) {
        _sw(fbits(g_cfg.cam_height), v + 0x3Cu);
        if (g_view_words[4] == VIEW_HEIGHT) _sw(fbits(g_cfg.cam_height), v + 0x40u);
    }
    g_view = v;
}

/* ---- module handling ---- */
static void flush(void) { sceKernelDcacheWritebackAll(); sceKernelIcacheInvalidateAll(); }
static void clear_state(void) {
    g_active_module = -1; g_camera_target = g_controller_stub = g_game_pad = g_camera_state = g_view = 0;
    g_original_camera = 0;
}

static int patch_module(SceUID id, const SceKernelModuleInfo *info) {
    u32 cam = find_unique(info->text_addr, info->text_size, kCameraSignature, sizeof(kCameraSignature) / sizeof(kCameraSignature[0]));
    u32 ctl = find_unique(info->text_addr, info->text_size, kControllerSignature, sizeof(kControllerSignature) / sizeof(kControllerSignature[0]));
    u32 camstate, pad, call, stub, view;
    if (!cam || !ctl) return 0;                                   /* not a gameplay level: touch nothing */
    camstate = lui_addiu(_lw(cam + 0x20u), _lw(cam + 0x24u));
    pad = lui_addiu(_lw(ctl + 0x08u), _lw(ctl + 0x10u));
    call = _lw(ctl + 0x24u);
    if ((call & 0xFC000000u) != 0x0C000000u) return 0;
    stub = jump_target(ctl + 0x24u, call);
    if (!valid(camstate, CAMERA_PITCH_INPUT_OFFSET + 4u) || !valid(pad, GAME_PAD_PREVIOUS_OFFSET + sizeof(SceCtrlData)) || !valid(stub, 8u)) return 0;
    g_camera_state = camstate; g_game_pad = pad;
    if (g_cfg.right_stick && ((cam + 4u) & 0xF0000000u) == ((u32)camera_hook & 0xF0000000u)) {
        g_camera_words[0] = _lw(cam); g_camera_words[1] = _lw(cam + 4u);
        g_camera_trampoline[0] = g_camera_words[0];
        g_camera_trampoline[1] = make_j(cam + 8u);
        g_camera_trampoline[2] = g_camera_words[1];
        g_original_camera = (CameraFunction)(void *)g_camera_trampoline;
        _sw(make_j((u32)camera_hook), cam); _sw(0, cam + 4u);
        g_camera_target = cam;
    }
    if ((g_cfg.l2_alias || g_cfg.r2_alias || g_cfg.right_stick) && ((stub + 4u) & 0xF0000000u) == ((u32)controller_peek_hook & 0xF0000000u)) {
        g_controller_words[0] = _lw(stub); g_controller_words[1] = _lw(stub + 4u);
        _sw(make_j((u32)controller_peek_hook), stub); _sw(0, stub + 4u);
        g_controller_stub = stub;
    }
    if ((g_cfg.fov_deg != 0.0f || g_cfg.cam_distance != 0.0f || g_cfg.cam_height != 0.0f) && (view = find_view(info)) != 0)
        apply_view(view);
    flush();
    g_active_module = id;
    log_line("patched level text", info->text_addr);
    log_line(" camera", g_camera_target);
    log_line(" controller", g_controller_stub);
    log_line(" view", g_view);
    return 1;
}

static int listed(SceUID id, const SceUID *ids, int n) { int i; if (id < 0) return 0; for (i = 0; i < n; i++) if (ids[i] == id) return 1; return 0; }

static void scan(void) {
    SceUID ids[64]; int n = 0, i;
    if (sceKernelGetModuleIdList(ids, sizeof(ids), &n) < 0) return;
    if (n > 64) n = 64;
    if (listed(g_active_module, ids, n)) return;
    if (g_active_module >= 0) { log_line("level unloaded", (u32)g_active_module); clear_state(); }
    if (!listed(g_ignored_module, ids, n)) g_ignored_module = -1;
    for (i = 0; i < n; i++) {
        SceKernelModuleInfo info;
        memset(&info, 0, sizeof(info)); info.size = sizeof(info);
        if (ids[i] == g_ignored_module || sceKernelQueryModuleInfo(ids[i], &info) < 0 || !streq(info.name, "rcp1")) continue;
        if (patch_module(ids[i], &info)) return;
        g_ignored_module = ids[i];                               /* FRONTEND: same name, no signatures */
    }
}

static int worker(SceSize args, void *argp) {
    (void)args; (void)argp;
    while (g_running) { scan(); sceKernelDelayThread(100000); }
    sceKernelExitDeleteThread(0);
    return 0;
}

int module_start(SceSize args, void *argp) {
    (void)args; (void)argp;
    if (sceIoDevctl("kemulator:", PPSSPP_DEVCTL_IS_EMULATOR, 0, 0, 0, 0) != 0) return 0;   /* PPSSPP only */
    load_config();
    if (!g_cfg.right_stick && !g_cfg.l2_alias && !g_cfg.r2_alias && g_cfg.fov_deg == 0.0f &&
        g_cfg.cam_distance == 0.0f && g_cfg.cam_height == 0.0f) return 0;                  /* nothing enabled */
    if (g_cfg.right_stick) sceCtrlSetSamplingMode(PSP_CTRL_MODE_ANALOG);
    log_line("OCEnhance 1.0 started", 0);
    g_worker = sceKernelCreateThread("ocenhance_worker", worker, 0x18, 0x2000, PSP_THREAD_ATTR_USER, 0);
    if (g_worker >= 0) sceKernelStartThread(g_worker, 0, 0);
    return 0;
}

int module_stop(SceSize args, void *argp) {
    (void)args; (void)argp;
    g_running = 0;
    if (g_worker >= 0) { sceKernelWaitThreadEnd(g_worker, 0); g_worker = -1; }
    if (g_camera_target && _lw(g_camera_target) == make_j((u32)camera_hook)) { _sw(g_camera_words[0], g_camera_target); _sw(g_camera_words[1], g_camera_target + 4u); }
    if (g_controller_stub && _lw(g_controller_stub) == make_j((u32)controller_peek_hook)) { _sw(g_controller_words[0], g_controller_stub); _sw(g_controller_words[1], g_controller_stub + 4u); }
    flush();
    return 0;
}
