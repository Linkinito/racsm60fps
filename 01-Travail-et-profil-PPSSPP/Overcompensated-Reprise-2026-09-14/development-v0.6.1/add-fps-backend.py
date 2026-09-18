from pathlib import Path
r=Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14/development-v0.6.1');p=r/'sources/profiler'
(p/'include/rcsm_fps_choice.h').write_text('''#ifndef RCSM_FPS_CHOICE_H
#define RCSM_FPS_CHOICE_H
#include <stdint.h>
typedef struct RcsmFpsChoice { uint32_t requested, selected, applied; } RcsmFpsChoice;
int rcsm_fps_request(RcsmFpsChoice *s, uint32_t fps);
uint32_t rcsm_fps_begin_module(RcsmFpsChoice *s);
int rcsm_fps_confirm(RcsmFpsChoice *s, uint32_t fps);
void rcsm_fps_leave_module(RcsmFpsChoice *s);
int rcsm_fps_pending(const RcsmFpsChoice *s);
#endif
''')
(p/'src/rcsm_fps_choice.c').write_text('''#include "rcsm_fps_choice.h"
#include <stddef.h>
int rcsm_fps_request(RcsmFpsChoice *s, uint32_t fps) {
    if (s == NULL || (fps != 30u && fps != 60u)) return 0;
    s->requested = fps;
    return 1;
}
uint32_t rcsm_fps_begin_module(RcsmFpsChoice *s) {
    if (s == NULL || (s->requested != 30u && s->requested != 60u)) return 0u;
    s->selected = s->requested;
    s->applied = 0u;
    return s->selected;
}
int rcsm_fps_confirm(RcsmFpsChoice *s, uint32_t fps) {
    if (s == NULL || (fps != 30u && fps != 60u) || s->selected != fps) return 0;
    s->applied = fps;
    return 1;
}
void rcsm_fps_leave_module(RcsmFpsChoice *s) {
    if (s != NULL) { s->selected = 0u; s->applied = 0u; }
}
int rcsm_fps_pending(const RcsmFpsChoice *s) {
    return s != NULL && s->requested != s->applied;
}
''')
(p/'tests/test_fps_choice.c').write_text('''#include "rcsm_fps_choice.h"
#include <assert.h>
#include <stdio.h>
int main(void) {
    RcsmFpsChoice s = {60u,0u,0u};
    assert(rcsm_fps_pending(&s));
    assert(rcsm_fps_begin_module(&s)==60u);
    assert(!rcsm_fps_confirm(&s,30u));
    assert(s.applied==0u); /* An unverified installation is never advertised. */
    assert(rcsm_fps_confirm(&s,60u));
    assert(!rcsm_fps_pending(&s));
    assert(rcsm_fps_request(&s,30u));
    assert(s.applied==60u && s.selected==60u && rcsm_fps_pending(&s));
    assert(!rcsm_fps_request(&s,120u) && s.requested==30u);
    assert(rcsm_fps_request(&s,60u) && !rcsm_fps_pending(&s));
    assert(rcsm_fps_request(&s,30u));
    rcsm_fps_leave_module(&s);
    assert(s.applied==0u && s.selected==0u && s.requested==30u);
    assert(rcsm_fps_begin_module(&s)==30u && rcsm_fps_confirm(&s,30u));
    assert(!rcsm_fps_pending(&s));
    assert(rcsm_fps_request(&s,60u) && s.applied==30u);
    rcsm_fps_leave_module(&s);
    assert(rcsm_fps_begin_module(&s)==60u && s.applied==0u);
    assert(rcsm_fps_request(&s,30u)); /* Request arriving during installation. */
    assert(rcsm_fps_confirm(&s,60u) && rcsm_fps_pending(&s));
    assert(!rcsm_fps_request(NULL,30u));
    puts("fps_choice: PASS; deferred request, cancellation, failure and both directions");
    return 0;
}
''')
f=p/'src/psp_plugin_runtime.c';s=f.read_text();s=s.replace('#include "rcsm_full_patch.h"','#include "rcsm_full_patch.h"\n#include "rcsm_fps_choice.h"')
s=s.replace('#define RCSM_VERSION "0.6.1-metalis-integration-dev.1"','#define RCSM_VERSION "0.6.1-metalis-integration-dev.2"\n\n/* Menu/debugger mailbox. Monitor is the sole owner of g_fps_choice. */\nvolatile uint32_t g_rcsm_requested_fps = 60u;\nvolatile uint32_t g_rcsm_applied_fps = 0u;\nvolatile uint32_t g_rcsm_fps_pending = 1u;\nstatic RcsmFpsChoice g_fps_choice = {60u, 0u, 0u};')
s=s.replace('} else if (string_equal_ci(key, "full_layers")) {','''} else if (string_equal_ci(key, "frame_rate")) {
        if (parse_u32(value, &parsed) && rcsm_fps_request(&g_fps_choice, parsed))
            g_rcsm_requested_fps = parsed;
        else ++g_config.config_errors;
    } else if (string_equal_ci(key, "full_layers")) {''')
needle='''    wants_patch = prepare_patch_view(&g_binding);
    if (!wants_patch) {'''
assert needle in s
s=s.replace(needle,'''    wants_patch = prepare_patch_view(&g_binding);
    if (g_config.mode == RCSM_MODE_GLOBAL_60FPS && wants_patch) {
        (void)rcsm_fps_begin_module(&g_fps_choice);
        if (g_fps_choice.selected == 30u) {
            RcsmRedirectState state;
            int clean;
            dispatch_state = sceKernelSuspendDispatchThread();
            if (dispatch_state < 0) return 0;
            clean = full_binding_still_present() && prepare_full_patch(&g_binding) &&
                rcsm_full_preflight(&g_full, read_patch_word, NULL) &&
                rcsm_classify_policy_redirects(&g_binding.patch_view,
                    hook_address_for_module(profile->module_index, RCSM_POLICY_TWO_PASS),
                    hook_address_for_module(profile->module_index, RCSM_POLICY_ONE_PASS),
                    read_patch_word, NULL, &state) &&
                state.original == g_binding.patch_view.callsite_count;
            (void)sceKernelResumeDispatchThread(dispatch_state);
            if (!clean) {
                log_line("30 fps refused: original patch sites not verified key=%s", profile->module_key);
                return 0;
            }
            (void)rcsm_fps_confirm(&g_fps_choice, 30u);
            log_line("frame_rate applied=30 requested=%u key=%s game_writes=0",
                     (unsigned)g_fps_choice.requested, profile->module_key);
            wants_patch = 0;
        }
    }
    if (!wants_patch) {''')
s=s.replace('    g_binding.installed = 1;','''    g_binding.installed = 1;
    if (g_config.mode == RCSM_MODE_GLOBAL_60FPS)
        (void)rcsm_fps_confirm(&g_fps_choice, 60u);''')
# Reset published status only when retiring a binding; requests remain queued.
s=s.replace('''static void deactivate_profile(int restore_if_still_active, const char *reason) {
    RcsmPatchResult patch''','''static void deactivate_profile(int restore_if_still_active, const char *reason) {
    RcsmPatchResult patch''')
needle='''    memset(&g_binding, 0, sizeof(g_binding));
    memset(&g_full, 0, sizeof(g_full));'''
assert s.count(needle)==1
s=s.replace(needle,'''    rcsm_fps_leave_module(&g_fps_choice);
    g_rcsm_applied_fps = 0u;
    memset(&g_binding, 0, sizeof(g_binding));
    memset(&g_full, 0, sizeof(g_full));''')
s=s.replace('''        RcsmRuntimeDetection detected;
        int detected_valid = resolve_current_module(&detected);''','''        RcsmRuntimeDetection detected;
        int detected_valid;
        uint32_t requested = g_rcsm_requested_fps;
        if (requested != g_fps_choice.requested) {
            if (g_config.mode == RCSM_MODE_GLOBAL_60FPS && rcsm_fps_request(&g_fps_choice, requested))
                log_line("frame_rate requested=%u; deferred until verified module reload", (unsigned)requested);
            else g_rcsm_requested_fps = g_fps_choice.requested;
        }
        detected_valid = resolve_current_module(&detected);''')
s=s.replace('''        process_controls(&previous_buttons);''','''        g_rcsm_applied_fps = g_fps_choice.applied;
        g_rcsm_fps_pending = (uint32_t)rcsm_fps_pending(&g_fps_choice);
        process_controls(&previous_buttons);''')
f.write_text(s)
f=p/'Makefile';s=f.read_text().replace('OBJS =','OBJS = src/rcsm_fps_choice.o ');assert 'rcsm_fps_choice.o' in s;f.write_text(s)
f=r/'build-windows.py';s=f.read_text().replace("sources=['src/psp_plugin_runtime.c'","sources=['src/rcsm_fps_choice.c','src/psp_plugin_runtime.c'");f.write_text(s)
f=p/'tools/run_host_checks.py';s=f.read_text().replace('suites={',"suites={\n        'test_fps_choice':['src/rcsm_fps_choice.c'],");f.write_text(s)
f=p/'tools/validate_prx.py';s=f.read_text().replace('0.6.1-metalis-integration-dev.1','0.6.1-metalis-integration-dev.2');f.write_text(s)
f=p/'RCSMProfiler.ini';s=f.read_text().replace('mode = global_60fps','mode = global_60fps\n; Applied on plugin start or a verified module reload, never mid-round.\nframe_rate = 60');f.write_text(s)
print('FPS backend added; no native menu hook installed')
