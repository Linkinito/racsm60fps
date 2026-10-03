/* FlamerGate: level-independent Flamethrower damage-query gate (experimental).
 *
 * FG-v0 (live-validated 2026-10-03, observation only): a low priority thread
 * polls the module list every 250 ms; when the level module (rcp1) appears or
 * changes it scans the module text for masked signatures of the Flamethrower
 * weapon update, latch set, animation callback, latch clear and damage query,
 * derives the query call inside the callback, and publishes the results in
 * fg_state and a short log file.
 *
 * FG-v1 (superseded, never run): single query-call gate returning v0 on skip.
 *
 * FG-v2 (built, NOT runtime-validated): GPT's two-hook design
 * (research/v2/otto-flamer-static-20261003/REPORT.md, task B). When fg_ctl[0]
 * is 1 and the level runs C1 core (shared delta word = lui a0,0x3C88), two
 * guarded words are replaced: the callback's `jal query` by `jal fg_query_hook`
 * and the latch clear `sb zero,0x15(s0)` by `j fg_clear_hook`. With the level
 * frame counter C and parity P (fg_ctl[5]): on frames with (C&1)==P the latch
 * is cleared and the query runs; otherwise a firing callback keeps the latch
 * and the query returns the cached distance pvar+0x278 in f0 without running.
 * Leaving C1, mode 0 or a level change restores/forgets the words. Known
 * limits (GPT): query-owned visuals/RNG run at 30 Hz; the deferred secondary
 * damage companion is not gated; phase P must be chosen as (F0+1)&1 at the
 * first complete C1 callback to match A0 (tool-side, not automatic).
 *
 * FG-v4 (built, NOT runtime-validated): independent "extras" with their own
 * request mask wg[0] (bit 0 LaserTracer, bit 1 AgentsGlove), C1 only, phase
 * C/P shared with the Flamethrower gate (fg_ctl[5]). Live basis:
 * research/live-tests/quodrona/laser-001-20261003 and weapons-otto-001-20261003;
 * offline census research/scripts/scan-weapon-gate-sites.py (LEVEL_01..10, 23, 24).
 *  - Laser flag: the only reader of the first-substep flag (`lui a0; lbu a0;
 *    beq a0,zero; nop`) sees 0 on off-phase frames (ammo countdown at 30 Hz).
 *  - Laser damage: every `jalr t2` damage call of the beam update (pattern
 *    `lw t2,0x20(a1); lw a1,*(sp); move a0,s1; jalr t2; move t1,s0; move s0,v0`)
 *    becomes `jal wg_dmg_hook`: on-phase frames tail-jump to t2, off-phase
 *    frames return v0 = 0 without calling (return contract UNKNOWN, GPT task).
 *  - Agents: the two agent-lifetime step literals `lui a2,0xBF80` (-1.0 per
 *    update) become `lui a2,0xBF00` (-0.5 per update).
 *
 * FG-v5 (built, NOT runtime-validated): extras become a table of guarded
 * literal patches wg_lit[] (address, original word, new word, request bit) plus
 * the laser hooks. New bits: 2 = weapon delta (the `mov.s f12,f20` delay slot of
 * the player loop's weapon-update call, flag writer + 0x44, becomes
 * `add.s f12,f20,f20`: 2 x delta per C1 pass as A0's two passes; only when the
 * module's original loop limit is 2, so never LEVEL_02), 3 = BlasterShot
 * (speed and life formulas 30.0 -> 60.0, LEVEL_01 fixes.py `blastershot`,
 * signatures generated offline from LEVEL_01 into the ignored build). Every
 * literal write invalidates the instruction cache from the word before it
 * (delay slots are compiled with their branch).
 *
 * FG-v5.1: the laser flag gate runs on the opposite parity of the damage gate
 * (GPT, research/v2/laser-gate-static-20261003/REPORT.md: A0 first-pass state
 * and pair-end damage fall on opposite counter phases). Skipped damage calls
 * still return v0 = 0: on the normal path the target stays opaque, as after a
 * non-kill hit; never 3 (kill/XP path).
 *
 * Signatures are generated at build time from a local signature pack (game code
 * words) into the ignored build directory; this source contains no game bytes.
 * Evidence: research/live-tests/pokitaru/flamer-001-20261003/REPORT.md,
 * research/live-tests/quodrona/flamer-boss-001-20261003/REPORT.md,
 * research/live-tests/pokitaru/flamer-gate-fg0-20261003/REPORT.md. */
#include <pspkernel.h>
#include <pspiofilemgr.h>
#include <stdint.h>
#include "sigs.h"   /* generated: FG_SIG_COUNT, fg_sigs[], FG_SITE_*, FG_FC_COUNT, fg_fc_sigs[] */

PSP_MODULE_INFO("FlamerGate", PSP_MODULE_USER, 0, 8);

#define FG_MAGIC 0x30544746u  /* "FGT0": layout of fg_state unchanged since FG-v0 */
#define FG_VERSION 7u   /* FG-v5: extras as literal table + weapon delta + BlasterShot */
/* Companion site patterns (authored MIPS encodings, LEVEL_01/LEVEL_10 verified):
 * damage: lw a0,0x64(s0); andi a0,a0,8; bne a0,zero,<skip>; swc1 f22,0x2C(sp)
 * age:    lw a0,8(s3);    addiu a0,a0,-1; bne a0,zero,<epilogue>; sw a0,8(s3) */
#define FG_DMG_W0 0x8E040064u
#define FG_DMG_W1 0x30840008u
#define FG_DMG_W3 0xE7B6002Cu
#define FG_AGE_W0 0x8E640008u
#define FG_AGE_W1 0x2484FFFFu
#define FG_AGE_W3 0xAE640008u
#define FG_REACH_STORE 0xE60C0278u   /* swc1 f12,0x278(s0) */
#define FG_REACH_LOAD  0xC60E0278u   /* lwc1 f14,0x278(s0) */
#define FG_REACH_ADD_A 0x460C7300u   /* add.s f12,f14,f12 (observed on LEVEL_10) */
#define FG_REACH_ADD_B 0x460E6300u   /* add.s f12,f12,f14 */   /* FG-v2.1: code reads after icache invalidation (PPSSPP JIT emuhack words) */
#define FG_CLEAR_WORD 0xA2000015u      /* sb zero,0x15(s0) */
#define FG_DELTA_C1 0x3C043C88u        /* lui a0,0x3C88 (1/60) at the shared delta site */
/* FG-v4 extras (authored MIPS encodings) */
#define WG_SLTIU_A0_S1_1 0x2E240001u   /* sltiu a0,s1,1 (substep loop: first pass flag) */
#define WG_LASER_JALR    0x0140F809u   /* jalr t2 */
#define WG_AGENT_STEP    0x3C06BF80u   /* lui a2,0xBF80 (-1.0) */
#define WG_AGENT_HALF    0x3C06BF00u   /* lui a2,0xBF00 (-0.5) */
#define WG_MOVS_F12_F20  0x4600A306u   /* mov.s f12,f20 (weapon-update delta argument) */
#define WG_ADDS_F12_2X   0x4614A300u   /* add.s f12,f20,f20 */
#define WG_LOOP_LIMIT_2  0x2A240002u   /* slti a0,s1,2 (original two-pass player loop) */
#define WG_MAX_LIT 16u
#define FG_LOG "ms0:/PSP/PLUGINS/FlamerGate/log.txt"
#ifndef FG_DEFAULT_MODE
#define FG_DEFAULT_MODE 0u
#endif

/* Debugger-visible state (FG-v0 layout, keep in sync with tools/runtime/flamer-gate.py):
 *  0 magic, 1 version, 2 loops, 3 scans, 4 module uid, 5 text_addr, 6 text_size,
 *  7 status (0 idle, 1 scanning, 2 all sites unique, 3 incomplete),
 *  8..8+FG_SIG_COUNT-1 site addresses (0 = not unique), then match counts,
 *  then query-call address and its status (1 = jal to query found in callback). */
volatile uint32_t fg_state[8 + 2 * FG_SIG_COUNT + 2];

/* Control, written by tools over the debugger:
 *  0 requested mode (0 observe, 1 gate), 1 applied mode, 2 last error,
 *  3 apply count, 4 restore count, 5 requested run parity (0/1),
 *  6 frame-counter address (derived), 7 frame-counter status (1 = unique). */
volatile uint32_t fg_ctl[8];

/* Gate configuration and counters, read by stub.S (offsets fixed there):
 *  0 enabled, 1 frame-counter address, 2 run parity P, 3 original query target,
 *  4 query run count, 5 query skip count, 6 reach store run count, 7 reach store
 *  skip count, 8 latch clear count, 9 latch retain count, 10 reach-store site,
 *  11 unused, 12-14 damage run/skip/bypass, 15-17 age run/skip/bypass,
 *  18 damage site, 19 age site, 20 damage skip target, 21 age skip target,
 *  22 companion installed (1) / absent (0). */
volatile uint32_t fg_gate[24];

/* FG-v4 extras, debugger-visible (keep in sync with stub.S and tools/runtime/flamer-gate.py):
 *  0 requested mask (bit0 laser, bit1 agents), 1 applied mask, 2 last error, 3 apply count,
 *  4 restore count, 5 flag reader site, 6 flag address, 7..10 laser damage sites, 11 laser
 *  damage site count, 12 agent step site A, 13 agent step site B, 14 flag run, 15 flag skip,
 *  16 damage run, 17 damage skip, 18 frame-counter address, 19 run parity P,
 *  20 original reader word 0, 21 original reader word 1, 22 literal patch count (wg_lit),
 *  23 flag-gate parity Pstate = P ^ 1 (FG-v5.1).
 *  Request bits: 0 laser hooks, 1 agents lifetime, 2 weapon delta, 3 BlasterShot. */
#define WG_MAX_DMG 4u
volatile uint32_t wg[24];
/* Guarded literal patches: {address, original word, new word, request bit}; wg[22] = count. */
volatile uint32_t wg_lit[WG_MAX_LIT][4];
extern void wg_flag_hook(void);
extern uint32_t wg_flag_return[];
extern void wg_dmg_hook(void);
enum { WG_ERR_NONE = 0, WG_ERR_NOT_C1 = 1, WG_ERR_FC = 2, WG_ERR_LASER_SITES = 3, WG_ERR_LASER_WORD = 4,
       WG_ERR_AGENT_SITES = 5, WG_ERR_AGENT_WORD = 6, WG_ERR_VERIFY = 7, WG_ERR_RESTORE = 8 };

extern void fg_query_hook(void);
extern void fg_clear_hook(void);
extern uint32_t fg_clear_return[];
extern void fg_reach_hook(void);
extern uint32_t fg_reach_return[];
extern void fg_dmg_hook(void);
extern void fg_age_hook(void);
extern uint32_t fg_dmg_run_ret[], fg_dmg_skip_ret[], fg_age_run_ret[], fg_age_skip_ret[];

enum { FG_ERR_NONE = 0, FG_ERR_SITES = 1, FG_ERR_FC = 2, FG_ERR_WORD = 3, FG_ERR_RESTORE = 4,
       FG_ERR_NOT_C1 = 5, FG_ERR_CLEAR_WORD = 6, FG_ERR_VERIFY = 7, FG_ERR_REACH = 8 };

/* Reach-store site (mod19 path) inside the callback, found structurally at scan
 * time and published in fg_gate[10]. */
static uint32_t fg_reach_site;

static void put_hex(char *p, uint32_t v) {
    for (int i = 7; i >= 0; --i) { uint32_t d = v & 0xFu; p[i] = (char)(d < 10 ? '0' + d : 'A' + d - 10); v >>= 4; }
}

static void log_line(const char *tag, uint32_t a, uint32_t b) {
    char line[40];
    int n = 0;
    while (tag[n] && n < 20) { line[n] = tag[n]; ++n; }
    line[n++] = ' '; put_hex(line + n, a); n += 8;
    line[n++] = ' '; put_hex(line + n, b); n += 8;
    line[n++] = '\n';
    SceUID fd = sceIoOpen(FG_LOG, PSP_O_WRONLY | PSP_O_CREAT | PSP_O_APPEND, 0666);
    if (fd >= 0) { sceIoWrite(fd, line, n); sceIoClose(fd); }
}

static int match_at(const uint32_t *code, const fg_sig_t *s) {
    for (uint32_t k = 0; k < s->n; ++k)
        if ((code[k] & s->m[k]) != (s->w[k] & s->m[k])) return 0;
    return 1;
}

/* Returns the number of matches (0, 1 or 2 = several); *addr is the site address of the first. */
static uint32_t find_sig(const uint32_t *text, uint32_t nwords, const fg_sig_t *s, uint32_t *addr) {
    uint32_t found = 0;
    uint32_t aw = s->w[s->anchor];
    for (uint32_t i = s->anchor; i + s->n - s->anchor <= nwords; ++i) {
        if (text[i] != aw) continue;
        const uint32_t *start = text + i - s->anchor;
        if (!match_at(start, s)) continue;
        if (found == 0) *addr = (uint32_t)(uintptr_t)(start + s->at);
        if (++found >= 2) break;
    }
    return found;
}

/* Data address formed by `lui rX,hi` ... `<op> rY,lo(rX)` where the low-half
 * instruction is at site; searches up to 10 words back for the lui. */
static uint32_t pair_address(const uint32_t *site) {
    uint32_t lo = site[0], rs = (lo >> 21) & 31u;
    for (int k = 1; k <= 10; ++k) {
        uint32_t w = site[-k];
        if ((w >> 26) == 0x0Fu && ((w >> 16) & 31u) == rs) {
            int32_t imm = (int32_t)(int16_t)(lo & 0xFFFFu);
            return (uint32_t)(((w & 0xFFFFu) << 16) + (uint32_t)imm);
        }
    }
    return 0;
}

static uint32_t branch_target(uint32_t addr) {
    const uint32_t w = *(const volatile uint32_t *)(uintptr_t)addr;
    int32_t off = (int32_t)(int16_t)(w & 0xFFFFu);
    return addr + 4u + (uint32_t)(off * 4);
}

/* True if any branch within +-0x800 bytes targets addr (a hook's delay-slot word must not be one). */
static int is_branch_target(uint32_t addr) {
    for (uint32_t a = addr - 0x800u; a < addr + 0x800u; a += 4u) {
        uint32_t w = *(const volatile uint32_t *)(uintptr_t)a, op = w >> 26;
        if ((op >= 0x04u && op <= 0x07u) || (op >= 0x14u && op <= 0x17u) || op == 0x01u)
            if (branch_target(a) == addr) return 1;
    }
    return 0;
}

static uint32_t jal_word(uint32_t target) { return 0x0C000000u | ((target >> 2) & 0x03FFFFFFu); }
static uint32_t j_word(uint32_t target) { return 0x08000000u | ((target >> 2) & 0x03FFFFFFu); }

static void sync_icache(uint32_t addr) {
    sceKernelDcacheWritebackRange((void *)(uintptr_t)(addr & ~63u), 128);
    sceKernelIcacheInvalidateRange((void *)(uintptr_t)(addr & ~63u), 128);
}

/* Read a code word as the game binary has it. Under PPSSPP's JIT the first word of
 * a compiled block holds an internal emuhack opcode in RAM; invalidating the
 * instruction cache for the range makes the emulator restore the original words.
 * Observed live 2026-10-03: the C1 guard word 0x14958 (block start after a jal)
 * read as a foreign value until invalidated. Harmless on hardware. */
static uint32_t read_code(uint32_t addr) {
    sceKernelIcacheInvalidateRange((void *)(uintptr_t)(addr & ~63u), 128);
    return *(volatile uint32_t *)(uintptr_t)addr;
}

static void add_lit(uint32_t addr, uint32_t orig, uint32_t repl, uint32_t bit) {
    uint32_t k = wg[22];
    if (k >= WG_MAX_LIT) return;
    wg_lit[k][0] = addr; wg_lit[k][1] = orig; wg_lit[k][2] = repl; wg_lit[k][3] = bit;
    wg[22] = k + 1u;
}

/* FG-v4: locate the LaserTracer flag reader, the beam damage calls and the agent
 * lifetime step literals. Each result must be unique (damage calls: 1..4 within
 * 0x2000 bytes), else that extra stays unavailable. */
static void scan_extras(uint32_t text_addr, uint32_t text_size) {
    const uint32_t *text = (const uint32_t *)(uintptr_t)text_addr;
    uint32_t nwords = text_size / 4u;
    for (int k = 5; k <= 13; ++k) wg[k] = 0u;
    wg[22] = 0u;
    /* flag writer: sltiu a0,s1,1 ; sb a0,lo(s2) with a preceding lui s2,hi */
    uint32_t flag = 0, nw = 0;
    for (uint32_t i = 12; i + 1 < nwords; ++i)
        if (text[i] == WG_SLTIU_A0_S1_1 && (text[i + 1] & 0xFFFF0000u) == 0xA2440000u) {
            uint32_t a = pair_address(text + i + 1);
            if (a) { flag = a; ++nw; }
        }
    if (nw != 1u) flag = 0;
    /* flag reader: lui a0,hi ; lbu a0,lo(a0) ; beq a0,zero,* ; nop  with the same address */
    uint32_t nr = 0, reader = 0;
    if (flag)
        for (uint32_t i = 1; i + 3 < nwords; ++i)
            if ((text[i] & 0xFFFF0000u) == 0x3C040000u && (text[i + 1] & 0xFFFF0000u) == 0x90840000u
                && (text[i + 2] & 0xFFFF0000u) == 0x10800000u && text[i + 3] == 0u
                && pair_address(text + i + 1) == flag) { ++nr; reader = text_addr + 4u * i; }
    if (nr != 1u) reader = 0;
    wg[5] = reader; wg[6] = reader ? flag : 0u;
    log_line("wg-flag", reader ? reader - text_addr : 0xFFFFFFFFu, (nw << 8) | nr);
    /* beam damage calls */
    uint32_t nd = 0, first = 0, ok = 1;
    for (uint32_t i = 3; i + 3 < nwords; ++i) {
        const uint32_t *p = text + i;
        if (p[0] == WG_LASER_JALR && p[-3] == 0x8CAA0020u && (p[-2] & 0xFFFF0000u) == 0x8FA50000u
            && p[-1] == 0x02202025u && p[1] == 0x02004825u && p[2] == 0x00408025u && p[3] == 0x34040003u) {
            uint32_t a = text_addr + 4u * i;
            if (nd == 0) first = a;
            if (nd >= WG_MAX_DMG || a - first >= 0x2000u) ok = 0;
            else wg[7 + nd] = a;
            ++nd;
        }
    }
    if (!ok || nd == 0) { for (int k = 7; k <= 10; ++k) wg[k] = 0u; nd = 0; }
    wg[11] = nd;
    log_line("wg-laserDmg", nd ? first - text_addr : 0xFFFFFFFFu, nd);
    /* agent lifetime: lwc1 f12,0x70(a0); mtc1 zero,f13; sw ra,0x10(sp); c.le.s f12,f13; nop;
     * bc1f +8; lui a2,0xBF80 (A) ... lui a2,0xBF80 (B); mtc1 a2,f13; add.s f12,f12,f13; swc1 f12,0x70(a0) */
    uint32_t na = 0, sa = 0, sb = 0;
    for (uint32_t i = 0; i + 19 < nwords; ++i) {
        const uint32_t *p = text + i;
        if (p[0] == 0xC48C0070u && p[1] == 0x44806800u && p[2] == 0xAFBF0010u && p[3] == 0x460D603Eu
            && p[4] == 0u && p[5] == 0x45000008u && p[6] == WG_AGENT_STEP) {
            for (uint32_t j = 7; j < 16; ++j)
                if (p[j] == WG_AGENT_STEP && p[j + 1] == 0x44866800u && p[j + 2] == 0x460D6300u && p[j + 3] == 0xE48C0070u) {
                    ++na; sa = text_addr + 4u * (i + 6); sb = text_addr + 4u * (i + j);
                }
        }
    }
    wg[12] = (na == 1u) ? sa : 0u; wg[13] = (na == 1u) ? sb : 0u;
    log_line("wg-agentLife", na == 1u ? sa - text_addr : 0xFFFFFFFFu, na);
    if (na == 1u) { add_lit(sa, WG_AGENT_STEP, WG_AGENT_HALF, 1u); add_lit(sb, WG_AGENT_STEP, WG_AGENT_HALF, 1u); }
    /* weapon delta: flag writer + 0x44 = mov.s f12,f20 after a jal; original loop limit at writer + 0x4C */
    {
        uint32_t wd = 0;
        for (uint32_t i = 12; i + 20 < nwords; ++i)
            if (text[i] == WG_SLTIU_A0_S1_1 && (text[i + 1] & 0xFFFF0000u) == 0xA2440000u
                && text[i + 17] == WG_MOVS_F12_F20 && (text[i + 16] >> 26) == 0x03u && text[i + 19] == WG_LOOP_LIMIT_2) {
                wd = wd ? 0xFFFFFFFFu : text_addr + 4u * (i + 17);
            }
        if (wd && wd != 0xFFFFFFFFu) add_lit(wd, WG_MOVS_F12_F20, WG_ADDS_F12_2X, 2u);
        log_line("wg-weaponDelta", (wd && wd != 0xFFFFFFFFu) ? wd - text_addr : 0xFFFFFFFFu, wd ? 1u : 0u);
    }
#ifdef WG_LSIG_COUNT
    /* offline-generated literal signatures (sigs.h) */
    for (uint32_t s2 = 0; s2 < WG_LSIG_COUNT; ++s2) {
        uint32_t addr = 0, n = find_sig(text, nwords, &wg_lsigs[s2].sig, &addr);
        if (n == 1u && *(const uint32_t *)(uintptr_t)addr == wg_lsigs[s2].orig)
            add_lit(addr, wg_lsigs[s2].orig, wg_lsigs[s2].repl, wg_lsigs[s2].bit);
        log_line(wg_lsigs[s2].sig.name, n == 1u ? addr - text_addr : 0xFFFFFFFFu, n);
    }
#endif
}

static void scan(uint32_t text_addr, uint32_t text_size) {
    const uint32_t *text = (const uint32_t *)(uintptr_t)text_addr;
    uint32_t nwords = text_size / 4u, unique = 0;
    fg_state[7] = 1u;
    for (uint32_t s = 0; s < FG_SIG_COUNT; ++s) {
        uint32_t addr = 0, n = find_sig(text, nwords, &fg_sigs[s], &addr);
        fg_state[8 + s] = (n == 1u) ? addr : 0u;
        fg_state[8 + FG_SIG_COUNT + s] = n;
        unique += (n == 1u);
        log_line(fg_sigs[s].name, n == 1u ? addr - text_addr : 0xFFFFFFFFu, n);
    }
    /* Query call: the jal inside the callback whose target is the query entry. */
    uint32_t cb = fg_state[8 + FG_SITE_CALLBACK], q = fg_state[8 + FG_SITE_QUERY], call = 0;
    if (cb && q) {
        const uint32_t *p = (const uint32_t *)(uintptr_t)cb;
        uint32_t want = jal_word(q);
        for (uint32_t k = 0; k < 0x400u / 4u; ++k) if (p[k] == want) { call = cb + 4u * k; break; }
    }
    /* mod19 reach store: `lwc1 f14,0x278(s0)`, then within 3 words an add.s f12 of
     * f12/f14 and `swc1 f12,0x278(s0)`; must be unique inside the callback. */
    fg_reach_site = 0;
    if (cb) {
        const uint32_t *p = (const uint32_t *)(uintptr_t)cb;
        uint32_t found = 0, at = 0;
        for (uint32_t k = 3; k < 0xC00u / 4u; ++k) {
            uint32_t add = p[k - 1];
            int add_ok = (add == FG_REACH_ADD_A) || (add == FG_REACH_ADD_B);
            if (p[k] == FG_REACH_STORE && add_ok && (p[k - 2] == FG_REACH_LOAD || p[k - 3] == FG_REACH_LOAD)) {
                ++found; at = cb + 4u * k;
            }
        }
        fg_reach_site = (found == 1u) ? at : 0u;
        log_line("reachStore", fg_reach_site ? fg_reach_site - text_addr : 0xFFFFFFFFu, found);
    }
    fg_gate[10] = fg_reach_site;
    /* Companion: unique damage and age patterns in the module, age after damage
     * within 0x200 bytes; skip targets are the original branch targets. */
    {
        uint32_t nd = 0, na = 0, ds = 0, as = 0;
        for (uint32_t i = 0; i + 3 < nwords; ++i) {
            const uint32_t *p = text + i;
            if (p[0] == FG_DMG_W0 && p[1] == FG_DMG_W1 && (p[2] >> 16) == 0x1480u && p[3] == FG_DMG_W3) { ++nd; ds = text_addr + 4u * i; }
            if (p[0] == FG_AGE_W0 && p[1] == FG_AGE_W1 && (p[2] >> 16) == 0x1480u && p[3] == FG_AGE_W3) { ++na; as = text_addr + 4u * i; }
        }
        uint32_t ok = (nd == 1u && na == 1u && as > ds && as - ds < 0x200u);
        fg_gate[18] = ok ? ds : 0u; fg_gate[19] = ok ? as : 0u;
        fg_gate[20] = ok ? branch_target(ds + 8u) : 0u;
        fg_gate[21] = ok ? branch_target(as + 8u) : 0u;
        log_line("companion", ok ? ds - text_addr : 0xFFFFFFFFu, ok ? as - text_addr : (nd << 8) | na);
    }
    fg_state[8 + 2 * FG_SIG_COUNT] = call;
    fg_state[8 + 2 * FG_SIG_COUNT + 1] = call ? 1u : 0u;
    log_line("queryCall", call ? call - text_addr : 0xFFFFFFFFu, call ? 1u : 0u);
    /* Level frame counter: first reference window that matches uniquely. */
    uint32_t fc = 0;
    for (uint32_t s = 0; s < FG_FC_COUNT && !fc; ++s) {
        uint32_t addr = 0;
        if (find_sig(text, nwords, &fg_fc_sigs[s], &addr) == 1u)
            fc = pair_address((const uint32_t *)(uintptr_t)addr);
    }
    fg_ctl[6] = fc;
    fg_ctl[7] = fc ? 1u : 0u;
    log_line("frameCounter", fc ? fc - text_addr : 0xFFFFFFFFu, fc ? 1u : 0u);
    fg_state[3] += 1u;
    fg_state[7] = (unique == FG_SIG_COUNT && call) ? 2u : 3u;
    scan_extras(text_addr, text_size);
}

/* Branch/jump detection (same rules as tools/runtime/count-multi.py). */
static int is_branch_or_jump(uint32_t w) {
    uint32_t op = w >> 26, rt = (w >> 16) & 31u, fn = w & 0x3Fu;
    if (op == 0x02u || op == 0x03u || (op >= 0x04u && op <= 0x07u) || (op >= 0x14u && op <= 0x17u)) return 1;
    if (op == 0x00u && (fn == 0x08u || fn == 0x09u)) return 1;
    if (op == 0x01u && (rt <= 0x03u || (rt >= 0x10u && rt <= 0x13u))) return 1;
    if (op == 0x11u && ((w >> 21) & 31u) == 0x08u) return 1;
    return 0;
}

static int level_is_c1(void) {
    uint32_t gd = fg_state[8 + FG_SITE_SHAREDDELTA];
    return gd && read_code(gd) == FG_DELTA_C1;
}

static void restore_sites(void) {
    uint32_t call = fg_state[8 + 2 * FG_SIG_COUNT], q = fg_state[8 + FG_SITE_QUERY];
    uint32_t cl = fg_state[8 + FG_SITE_LATCHCLEAR];
    volatile uint32_t *cls = (volatile uint32_t *)(uintptr_t)cl, *qs = (volatile uint32_t *)(uintptr_t)call;
    int foreign = 0;
    if (cl) {
        uint32_t w = read_code(cl);
        if (w == j_word((uint32_t)(uintptr_t)fg_clear_hook)) { *cls = FG_CLEAR_WORD; sync_icache(cl); }
        else if (w != FG_CLEAR_WORD) foreign = 1;
    }
    if (call) {
        uint32_t w = read_code(call);
        if (w == jal_word((uint32_t)(uintptr_t)fg_query_hook)) { *qs = jal_word(q); sync_icache(call); }
        else if (w != jal_word(q)) foreign = 1;
    }
    if (fg_gate[22]) {
        uint32_t ds = fg_gate[18], as = fg_gate[19];
        uint32_t w = read_code(ds);
        if (w == j_word((uint32_t)(uintptr_t)fg_dmg_hook)) { *(volatile uint32_t *)(uintptr_t)ds = FG_DMG_W0; sync_icache(ds); }
        else if (w != FG_DMG_W0) foreign = 1;
        w = read_code(as);
        if (w == j_word((uint32_t)(uintptr_t)fg_age_hook)) { *(volatile uint32_t *)(uintptr_t)as = FG_AGE_W0; sync_icache(as); }
        else if (w != FG_AGE_W0) foreign = 1;
        fg_gate[22] = 0u;
    }
    if (fg_reach_site) {
        volatile uint32_t *rs = (volatile uint32_t *)(uintptr_t)fg_reach_site;
        uint32_t w = read_code(fg_reach_site);
        if (w == j_word((uint32_t)(uintptr_t)fg_reach_hook)) { *rs = FG_REACH_STORE; sync_icache(fg_reach_site); }
        else if (w != FG_REACH_STORE) foreign = 1;
    }
    fg_gate[0] = 0u;
    fg_ctl[1] = 0u; fg_ctl[4] += 1u;
    if (foreign) fg_ctl[2] = FG_ERR_RESTORE;
    log_line("gate-off", fg_gate[4], fg_gate[5]);
}

/* Install (mode 1, C1 only) or remove the two hooks; all checks before any write. */
static void reconcile(void) {
    uint32_t call = fg_state[8 + 2 * FG_SIG_COUNT], q = fg_state[8 + FG_SITE_QUERY];
    uint32_t cl = fg_state[8 + FG_SITE_LATCHCLEAR];
    fg_gate[2] = fg_ctl[5] & 1u;
    int c1 = level_is_c1();
    if (fg_ctl[1] == 1u) {
        if (fg_ctl[0] != 1u || !c1) restore_sites();
        return;
    }
    if (fg_ctl[0] != 1u) return;
    if (fg_state[7] != 2u || !call || !cl) { fg_ctl[2] = FG_ERR_SITES; return; }
    if (!fg_ctl[6]) { fg_ctl[2] = FG_ERR_FC; return; }
    if (!c1) { fg_ctl[2] = FG_ERR_NOT_C1; return; }
    volatile uint32_t *qs = (volatile uint32_t *)(uintptr_t)call, *cls = (volatile uint32_t *)(uintptr_t)cl;
    uint32_t qw = read_code(call);
    if (qw != jal_word(q)) { fg_ctl[2] = FG_ERR_WORD; log_line("gate-refused-q", qw, jal_word(q)); return; }
    uint32_t cw = read_code(cl), prev = read_code(cl - 4u), next = read_code(cl + 4u);
    /* next must be lbu a0,imm(rs): it becomes the j's delay slot */
    if (cw != FG_CLEAR_WORD || (next >> 26) != 0x24u || ((next >> 16) & 31u) != 4u
        || is_branch_or_jump(prev) || is_branch_or_jump(next)) {
        fg_ctl[2] = FG_ERR_CLEAR_WORD; log_line("gate-refused-c", cw, next); return;
    }
    uint32_t rsite = fg_reach_site;
    if (!rsite) { fg_ctl[2] = FG_ERR_REACH; log_line("gate-refused-r", 0, 0); return; }
    uint32_t rw = read_code(rsite), rprev = read_code(rsite - 4u), rnext = read_code(rsite + 4u);
    if (rw != FG_REACH_STORE || is_branch_or_jump(rprev) || is_branch_or_jump(rnext)) {
        fg_ctl[2] = FG_ERR_REACH; log_line("gate-refused-r", rw, rnext); return;
    }
    fg_gate[1] = fg_ctl[6]; fg_gate[3] = q;
    fg_gate[4] = 0u; fg_gate[5] = 0u; fg_gate[8] = 0u; fg_gate[9] = 0u;
    fg_gate[6] = 0u; fg_gate[7] = 0u; fg_gate[10] = rsite;
    fg_clear_return[0] = j_word(cl + 8u);
    sync_icache((uint32_t)(uintptr_t)fg_clear_return);
    fg_gate[0] = 1u;
    read_code(call); *qs = jal_word((uint32_t)(uintptr_t)fg_query_hook); sync_icache(call);
    read_code(cl); *cls = j_word((uint32_t)(uintptr_t)fg_clear_hook); sync_icache(cl);
    fg_reach_return[0] = j_word(rsite + 8u);
    sync_icache((uint32_t)(uintptr_t)fg_reach_return);
    read_code(rsite); *(volatile uint32_t *)(uintptr_t)rsite = j_word((uint32_t)(uintptr_t)fg_reach_hook);
    sync_icache(rsite);
    /* Companion (optional): both sites must hold their original words, the hooked
     * word must not follow a branch, and the delay-slot word must not be a branch target. */
    {
        uint32_t ds = fg_gate[18], as = fg_gate[19];
        for (int k = 12; k <= 17; ++k) fg_gate[k] = 0u;
        if (ds && as && read_code(ds) == FG_DMG_W0 && read_code(as) == FG_AGE_W0
            && !is_branch_or_jump(read_code(ds - 4u)) && !is_branch_or_jump(read_code(as - 4u))
            && !is_branch_target(ds + 4u) && !is_branch_target(as + 4u)) {
            fg_dmg_run_ret[0] = j_word(ds + 8u);
            fg_dmg_skip_ret[0] = j_word(fg_gate[20]);
            fg_age_run_ret[0] = j_word(as + 8u);
            fg_age_skip_ret[0] = j_word(fg_gate[21]);
            sync_icache((uint32_t)(uintptr_t)fg_dmg_run_ret); sync_icache((uint32_t)(uintptr_t)fg_dmg_skip_ret);
            sync_icache((uint32_t)(uintptr_t)fg_age_run_ret); sync_icache((uint32_t)(uintptr_t)fg_age_skip_ret);
            read_code(ds); *(volatile uint32_t *)(uintptr_t)ds = j_word((uint32_t)(uintptr_t)fg_dmg_hook); sync_icache(ds);
            read_code(as); *(volatile uint32_t *)(uintptr_t)as = j_word((uint32_t)(uintptr_t)fg_age_hook); sync_icache(as);
            fg_gate[22] = 1u;
            log_line("companion-on", ds, as);
        } else {
            fg_gate[22] = 0u;
            log_line("companion-absent", ds, as);
        }
    }
    fg_ctl[1] = 1u; fg_ctl[3] += 1u;
    /* Verify both hooks survived the cache invalidation (a block recompiled between
     * read and write could have its original word restored over the hook). */
    if (read_code(call) != jal_word((uint32_t)(uintptr_t)fg_query_hook)
        || read_code(cl) != j_word((uint32_t)(uintptr_t)fg_clear_hook)
        || read_code(rsite) != j_word((uint32_t)(uintptr_t)fg_reach_hook)
        || (fg_gate[22] && (read_code(fg_gate[18]) != j_word((uint32_t)(uintptr_t)fg_dmg_hook)
                            || read_code(fg_gate[19]) != j_word((uint32_t)(uintptr_t)fg_age_hook)))) {
        restore_sites();
        fg_ctl[2] = FG_ERR_VERIFY;
        log_line("gate-verify-failed", call, cl);
        return;
    }
    fg_ctl[2] = FG_ERR_NONE;
    log_line("gate-on", call, fg_gate[2]);
}

/* FG-v4 extras: restore every word we own; unknown words are left alone and reported. */
static void restore_extras(void) {
    int foreign = 0;
    uint32_t r = wg[5];
    if (wg[1] & 1u) {
        if (r) {
            uint32_t w0 = read_code(r);
            if (w0 == j_word((uint32_t)(uintptr_t)wg_flag_hook)) {
                *(volatile uint32_t *)(uintptr_t)(r + 4u) = wg[21];
                *(volatile uint32_t *)(uintptr_t)r = wg[20];
                sync_icache(r);
            } else if (w0 != wg[20]) foreign = 1;
        }
        for (uint32_t k = 0; k < wg[11]; ++k) {
            uint32_t a = wg[7 + k], w = read_code(a);
            if (w == jal_word((uint32_t)(uintptr_t)wg_dmg_hook)) { *(volatile uint32_t *)(uintptr_t)a = WG_LASER_JALR; sync_icache(a); }
            else if (w != WG_LASER_JALR) foreign = 1;
        }
    }
    for (uint32_t k = 0; k < wg[22]; ++k) {
        if (!(wg[1] & (1u << wg_lit[k][3]))) continue;
        uint32_t a = wg_lit[k][0], w = read_code(a);
        if (w == wg_lit[k][2]) { *(volatile uint32_t *)(uintptr_t)a = wg_lit[k][1]; sync_icache(a - 4u); }
        else if (w != wg_lit[k][1]) foreign = 1;
    }
    if (wg[1]) { wg[4] += 1u; log_line("wg-off", wg[1], wg[15]); }
    wg[1] = 0u;
    if (foreign) wg[2] = WG_ERR_RESTORE;
}

/* Install (C1 only) or remove the requested extras; all checks before any write. */
static void reconcile_extras(void) {
    uint32_t want = wg[0] & 0xFu;
    int c1 = level_is_c1();
    wg[19] = fg_ctl[5] & 1u;
    wg[23] = wg[19] ^ 1u;   /* FG-v5.1: Pstate = Pdamage ^ 1 (research/v2/laser-gate-static-20261003) */
    if (wg[1]) {
        if (want != wg[1] || !c1) restore_extras();
        return;
    }
    if (!want) return;
    if (!c1) { wg[2] = WG_ERR_NOT_C1; return; }
    if (!fg_ctl[6]) { wg[2] = WG_ERR_FC; return; }
    wg[18] = fg_ctl[6];
    if (want & 1u) {
        uint32_t r = wg[5];
        if (!r || !wg[11]) { wg[2] = WG_ERR_LASER_SITES; return; }
        uint32_t w0 = read_code(r), w1 = read_code(r + 4u), w2 = read_code(r + 8u), w3 = read_code(r + 12u);
        if ((w0 & 0xFFFF0000u) != 0x3C040000u || (w1 & 0xFFFF0000u) != 0x90840000u
            || (w2 & 0xFFFF0000u) != 0x10800000u || w3 != 0u || is_branch_or_jump(read_code(r - 4u))
            || is_branch_target(r + 4u)) { wg[2] = WG_ERR_LASER_WORD; log_line("wg-refused-flag", w0, w1); return; }
        for (uint32_t k = 0; k < wg[11]; ++k) {
            uint32_t a = wg[7 + k];
            if (read_code(a) != WG_LASER_JALR || is_branch_or_jump(read_code(a - 4u))) {
                wg[2] = WG_ERR_LASER_WORD; log_line("wg-refused-dmg", a, read_code(a)); return;
            }
        }
        wg[20] = w0; wg[21] = w1;
    }
    for (uint32_t b = 1; b < 4u; ++b) {
        if (!(want & (1u << b))) continue;
        uint32_t found = 0;
        for (uint32_t k = 0; k < wg[22]; ++k) {
            if (wg_lit[k][3] != b) continue;
            ++found;
            uint32_t w = read_code(wg_lit[k][0]);
            if (w != wg_lit[k][1] || is_branch_or_jump(w)) {
                wg[2] = WG_ERR_AGENT_WORD; log_line("wg-refused-lit", wg_lit[k][0], w); return;
            }
        }
        if (!found) { wg[2] = WG_ERR_AGENT_SITES; log_line("wg-missing-lit", b, 0); return; }
    }
    for (int k = 14; k <= 17; ++k) wg[k] = 0u;
    if (want & 1u) {
        uint32_t r = wg[5];
        wg_flag_return[0] = j_word(r + 8u);
        sync_icache((uint32_t)(uintptr_t)wg_flag_return);
        read_code(r);
        *(volatile uint32_t *)(uintptr_t)(r + 4u) = 0u;   /* delay slot of the j: nop (the hook redoes the load) */
        *(volatile uint32_t *)(uintptr_t)r = j_word((uint32_t)(uintptr_t)wg_flag_hook);
        sync_icache(r);
        for (uint32_t k = 0; k < wg[11]; ++k) {
            uint32_t a = wg[7 + k];
            read_code(a); *(volatile uint32_t *)(uintptr_t)a = jal_word((uint32_t)(uintptr_t)wg_dmg_hook); sync_icache(a);
        }
    }
    for (uint32_t k = 0; k < wg[22]; ++k) {
        if (!(want & (1u << wg_lit[k][3]))) continue;
        uint32_t a = wg_lit[k][0];
        read_code(a); *(volatile uint32_t *)(uintptr_t)a = wg_lit[k][2]; sync_icache(a - 4u);
    }
    wg[1] = want; wg[3] += 1u;
    int bad = 0;
    if (want & 1u) {
        if (read_code(wg[5]) != j_word((uint32_t)(uintptr_t)wg_flag_hook) || read_code(wg[5] + 4u) != 0u) bad = 1;
        for (uint32_t k = 0; k < wg[11]; ++k)
            if (read_code(wg[7 + k]) != jal_word((uint32_t)(uintptr_t)wg_dmg_hook)) bad = 1;
    }
    for (uint32_t k = 0; k < wg[22]; ++k)
        if ((want & (1u << wg_lit[k][3])) && read_code(wg_lit[k][0]) != wg_lit[k][2]) bad = 1;
    if (bad) { restore_extras(); wg[2] = WG_ERR_VERIFY; log_line("wg-verify-failed", want, 0); return; }
    wg[2] = WG_ERR_NONE;
    log_line("wg-on", want, wg[19]);
}

static int fg_thread(SceSize args, void *argp) {
    (void)args; (void)argp;
    uint32_t last_uid = 0, last_text = 0;
    for (;;) {
        SceUID ids[64];
        int count = 0;
        fg_state[2] += 1u;
        if (sceKernelGetModuleIdList(ids, (int)sizeof(ids), &count) >= 0) {
            uint32_t uid = 0, text = 0, size = 0;
            for (int i = 0; i < count && i < 64; ++i) {
                SceKernelModuleInfo info;
                info.size = sizeof(info);
                if (sceKernelQueryModuleInfo(ids[i], &info) < 0) continue;
                if (info.name[0] == 'r' && info.name[1] == 'c' && info.name[2] == 'p' && info.name[3] == '1' && info.name[4] == 0) {
                    uid = (uint32_t)ids[i]; text = info.text_addr; size = info.text_size;
                }
            }
            if (uid && (uid != last_uid || text != last_text)) {
                /* New level code: any previous patch vanished with the old module. */
                fg_gate[0] = 0u; fg_ctl[1] = 0u; wg[1] = 0u;
                sceKernelDelayThread(500000);  /* let the level finish loading/relocating */
                fg_state[4] = uid; fg_state[5] = text; fg_state[6] = size;
                log_line("rcp1", text, size);
                scan(text, size);
                last_uid = uid; last_text = text;
            } else if (!uid && last_uid) {
                fg_gate[0] = 0u; fg_ctl[1] = 0u; wg[1] = 0u;
                last_uid = 0; last_text = 0; fg_state[7] = 0u;
                log_line("rcp1-gone", 0, 0);
            }
            if (uid && uid == last_uid) { reconcile(); reconcile_extras(); }
        }
        sceKernelDelayThread(250000);
    }
    return 0;
}

int module_start(SceSize args, void *argp) {
    (void)args; (void)argp;
    fg_state[0] = FG_MAGIC; fg_state[1] = FG_VERSION;
    fg_ctl[0] = FG_DEFAULT_MODE; fg_ctl[5] = 1u;
    log_line("FlamerGate-FG-v5.1", FG_DEFAULT_MODE, FG_SIG_COUNT);
    SceUID th = sceKernelCreateThread("FlamerGate", fg_thread, 0x6F, 0x1000, 0, NULL);
    if (th >= 0) sceKernelStartThread(th, 0, NULL);
    return 0;
}
