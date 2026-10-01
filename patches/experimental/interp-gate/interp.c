/* InterpGate: helper module for the experimental LEVEL_01 60 FPS fixes (IG-v16 lean).
 * Loaded as a PSP plugin; it changes nothing by itself. tools/runtime/fixes.py writes
 * call redirects into the LEVEL_01 module (only when LEVEL_01 is resident) that reach
 * the stubs and wrappers below; those words vanish when another level is loaded.
 * IG-v16: no libc/startup code and no thread (module_start returns 0 = stay resident),
 * legacy half-rate/interpolation modes (G/GI/H/I, rejected), the C nav wrapper
 * (superseded by asm stubs) and the animdisp wrapper (rejected) were removed to keep
 * the memory footprint small (other levels, e.g. Dayni Moon, crashed on load with IG-v15a:
 * memory pressure suspected, UNKNOWN). Older sources: git history (IG-v1..v15a). */
#include <pspkernel.h>
#include <stdint.h>

PSP_MODULE_INFO("InterpGate", PSP_MODULE_USER, 0, 1);

typedef void (*PumpFn)(float);

static int plain_float(uint32_t w) {
    uint32_t e = (w >> 23) & 0xFFu;
    return w == 0u || w == 0x80000000u || (e >= 0x40u && e <= 0xBEu);   /* ~1e-19 .. ~1e19 */
}

/* Fixed-step helper wrappers. ig_fix[i*4+0] enable, +1 original address, +2 calls.
 * Slot 0 debris physics 0x191D7C (a0 moby, a1 phys, a2 params, f12): per call
 *   lifetime moby+0x70 -= step, phys v.y -= gravity, moby pos += phys v (OBSERVED).
 *   Keeping half of each change is the 30->60 Hz transform for this recurrence.
 *   A velocity component that changes sign (bounce) keeps its full change.
 *   Nothing is touched when the callee returns 0 (object destroyed).
  * (Slot 1, animated displacement 0x6C318, was REJECTED and removed in IG-v16.)
 * Old slot 1 note: 0x6C318 (a0 obj, a1 out float[3], a2, a3): adds a
 *   fixed per-call displacement to a1 (OBSERVED); half of the addition is kept.
 *   Its v0 (from 0x6C2B8) reaches callers and must be returned unchanged: IG-v6
 *   declared it void and froze the game thread when enabled (owner-observed). */
typedef int (*DebrisFn)(void *, float *, void *, float);
volatile uint32_t ig_fix[8] = {0u, 0u, 0u, 0u, 0u, 0u, 0u, 0u};

static float halve(float before, float after) { return before + (after - before) * 0.5f; }

int ig_debris(void *moby, float *phys, void *params, float f12) {
    DebrisFn f = (DebrisFn)(uintptr_t)ig_fix[1];
    float *pos = (float *)((char *)moby + 0x30), *life = (float *)((char *)moby + 0x70);
    float p0 = pos[0], p1 = pos[1], p2 = pos[2], v0 = phys[0], v1 = phys[1], v2 = phys[2], l = *life;
    int r;
    if (!ig_fix[0]) return f(moby, phys, params, f12);
    r = f(moby, phys, params, f12);
    if (!r) return r;
    ig_fix[2]++;
    *life = halve(l, *life);
    pos[0] = halve(p0, pos[0]); pos[1] = halve(p1, pos[1]); pos[2] = halve(p2, pos[2]);
    if (v0 * phys[0] >= 0.0f) phys[0] = halve(v0, phys[0]);
    if (v1 * phys[1] >= 0.0f) phys[1] = halve(v1, phys[1]);
    if (v2 * phys[2] >= 0.0f) phys[2] = halve(v2, phys[2]);
    return r;
}

/* Generic particle animator half-step (IG-v13; walker site 0x8CE54 `jalr t0` ->
 * `jal ig_pwrap_stub`, which stores the animator in ig_ptarget). Animator arguments
 * (OBSERVED 0xDE23C, 0x1A05F0): a0 vertex output, a1 first vertex index, a2 emitter-
 * instance list sentinel (node = *(a2+4), next = *(node+4)), a3 pool parameters.
 * Instance: +8 record array, +12 u16 first, +14 u16 count. Dead particles are
 * swap-removed inside the animator (last record copied over the dead slot).
 * ig_pfix: [0] enable, [1] unused, [2] calls corrected, [3] records corrected,
 *          [4] instances skipped (buffer full), [5] slots skipped (identity).
 * ig_pmap[i]: [0] animator address (0 = end), [1] record bytes, [2] enable,
 *          [3] learned mask of words that change (bit n = word n), [4] records corrected.
 * Per record word: a plain float that changed by at most 8.0 keeps half of its change.
 * A word mask is learned only from calls where no particle of the instance died, so a
 * slot is treated as the same particle only if all never-changing words are equal.
 * Adjacent float pairs/triples whose length the animator preserved (rotations of unit
 * vectors; IG-v8 flicker) are rescaled to that length after halving. */
typedef int (*AnimFn)(void *, int, void *, void *);
volatile uint32_t ig_ptarget;
volatile uint32_t ig_pfix[8];
#define PMAPS 64u
volatile uint32_t ig_pmap[PMAPS][5];
#define SNAPW 8192u
#define PNODES 64u
static uint32_t psnap[SNAPW];
static uint32_t pnode_base[PNODES], pnode_off[PNODES]; static uint16_t pnode_first[PNODES], pnode_count[PNODES];

static float fabs_(float x) { return x < 0.0f ? -x : x; }

static void renorm(volatile uint32_t *now, const uint32_t *was, uint32_t done, unsigned i, unsigned n, uint32_t *used) {
    union { uint32_t u; float f; } h[3], a[3], b[3];
    float la = 0.0f, lb = 0.0f, lh = 0.0f, sc;
    unsigned j;
    for (j = 0; j < n; j++) {
        if (!(done >> (i + j) & 1u)) return;
        a[j].u = was[i + j]; h[j].u = now[i + j];
    }
    for (j = 0; j < n; j++) {
        b[j].f = a[j].f + (h[j].f - a[j].f) * 2.0f;      /* animator result before halving */
        la += a[j].f * a[j].f; lb += b[j].f * b[j].f; lh += h[j].f * h[j].f;
    }
    if (la < 1e-4f || fabs_(la - lb) > 0.01f * la || lh < 1e-12f) return;
    sc = __builtin_sqrtf(lb / lh);
    for (j = 0; j < n; j++) { h[j].f *= sc; now[i + j] = h[j].u; }
    *used |= ((1u << n) - 1u) << i;
}

int ig_particles(void *out, int first, void *head, void *params) {
    AnimFn anim = (AnimFn)(uintptr_t)ig_ptarget;
    volatile uint32_t *map = 0;
    uint32_t node, n = 0, k = 0, i, j, words, w;
    int r;
    if (ig_pfix[0])
        for (i = 0; i < PMAPS && ig_pmap[i][0]; i++)
            if (ig_pmap[i][0] == ig_ptarget) { if (ig_pmap[i][2]) map = ig_pmap[i]; break; }
    if (!map || map[1] < 8u || map[1] > 128u || (map[1] & 3u)) return anim(out, first, head, params);
    words = map[1] / 4u;
    for (node = *(volatile uint32_t *)((char *)head + 4); node && node != (uint32_t)(uintptr_t)head && n < PNODES;
         node = *(volatile uint32_t *)(uintptr_t)(node + 4), n++) {
        uint32_t base = *(volatile uint32_t *)(uintptr_t)(node + 8);
        uint16_t pf = *(volatile uint16_t *)(uintptr_t)(node + 12), pc = *(volatile uint16_t *)(uintptr_t)(node + 14);
        if (k + (uint32_t)pc * words > SNAPW || base < 0x08800000u || base >= 0x0A000000u) { ig_pfix[4]++; pc = 0; }
        pnode_base[n] = base; pnode_first[n] = pf; pnode_count[n] = pc; pnode_off[n] = k;
        for (i = 0; i < (uint32_t)pc * words; i++) psnap[k + i] = ((volatile uint32_t *)(uintptr_t)(base + map[1] * pf))[i];
        k += (uint32_t)pc * words;
    }
    r = anim(out, first, head, params);
    ig_pfix[2]++;
    for (j = 0, node = *(volatile uint32_t *)((char *)head + 4); j < n && node && node != (uint32_t)(uintptr_t)head;
         j++, node = *(volatile uint32_t *)(uintptr_t)(node + 4)) {
        uint32_t base = pnode_base[j], pf = pnode_first[j], pc = pnode_count[j];
        uint32_t nf = *(volatile uint16_t *)(uintptr_t)(node + 12), nc = *(volatile uint16_t *)(uintptr_t)(node + 14);
        int clean = (*(volatile uint32_t *)(uintptr_t)(node + 8) == base) && nf == pf && nc >= pc;
        if (*(volatile uint32_t *)(uintptr_t)(node + 8) != base) continue;
        for (i = 0; i < pc; i++) {
            volatile uint32_t *rec = (volatile uint32_t *)(uintptr_t)(base + map[1] * (pf + i));
            const uint32_t *was = &psnap[pnode_off[j] + i * words];
            uint32_t changed = 0u, done = 0u, used = 0u;
            if (pf + i < nf || pf + i >= nf + nc) continue;
            for (w = 0; w < words; w++) if (rec[w] != was[w]) changed |= 1u << w;
            if (clean) map[3] |= changed;
            else if ((changed & ~map[3]) != 0u || map[3] == 0u) { ig_pfix[5]++; continue; }
            for (w = 0; w < words; w++) {
                union { uint32_t u; float f; } a, b;
                if (!(changed >> w & 1u)) continue;
                a.u = was[w]; b.u = rec[w];
                if (!plain_float(a.u) || !plain_float(b.u) || fabs_(b.f - a.f) > 8.0f) continue;
                b.f = a.f + (b.f - a.f) * 0.5f; rec[w] = b.u; done |= 1u << w;
            }
            for (w = 0; w + 3 <= words; w++) if (!(used >> w & 7u)) renorm(rec, was, done, w, 3, &used);
            for (w = 0; w + 2 <= words; w++) if (!(used >> w & 3u)) renorm(rec, was, done, w, 2, &used);
            if (done) { ig_pfix[3]++; map[4]++; }
        }
    }
    return r;
}

/* Asm-stub call counters (ig_cnt[0] PathAnimal speed) and originals of runtime-
 * initialised data halved by fixes.py: ig_saved[2i] address, [2i+1] original word. */
volatile uint32_t ig_cnt[16];
volatile uint32_t ig_saved[32];

/* Displacement-halving asm stubs (stub.S): 8 slots of 8 words. */
volatile uint32_t ig_disp[64];

/* Telemetry (IG-v12). The pump-1 call at 0x15230 becomes `jal ig_tel_pump`; once per
 * main update, before pump 1, every watch is sampled. Game memory is only read.
 * Per-update change statistics let a host tool compute rates per game second
 * (sum of the delta passed to pump 1), identical units in A0 (30 Hz) and C1 (60 Hz).
 * Watch kinds: 1 f32, 2 s32, 3 s16, 4 f32 vec3 (distance per update).
 * A change larger than jump_limit counts as a jump (respawn, timer reload) and is
 * excluded from the sums; an upward jump is also recorded as a reload. */
typedef struct {
    uint32_t addr, kind, n, changes;
    float last[3], sum_abs, max_step;
    uint32_t reloads;
    float last_reload, max_reload;
    uint32_t jumps;
    float sum_signed, min_reload, jump_limit;
} Watch;
#define WATCHES 64u
/* magic 'IGT1', enable, pump-1 address, updates, dt sum, last dt, reset request, abi */
typedef struct { uint32_t magic, enable, pump, updates; float dt_sum, dt_last; uint32_t reset, abi; } Tel;
volatile Tel ig_tel = {0x31544749u, 0u, 0u, 0u, 0.0f, 0.0f, 0u, 1u};
volatile Watch ig_watch[WATCHES];

static int finite_bits(uint32_t w) { return ((w >> 23) & 0xFFu) != 0xFFu; }

static void tel_sample(void) {
    unsigned i, j;
    for (i = 0; i < WATCHES; i++) {
        volatile Watch *w = &ig_watch[i];
        uint32_t k = w->kind, a = w->addr;
        float v[3] = {0.0f, 0.0f, 0.0f}, d;
        if (k == 0u || k > 4u || a < 0x08800000u || a >= 0x0A000000u - 16u || (a & (k == 3u ? 1u : 3u))) continue;
        if (k == 1u || k == 4u) {
            for (j = 0; j < (k == 4u ? 3u : 1u); j++) {
                union { uint32_t u; float f; } x;
                x.u = ((volatile uint32_t *)(uintptr_t)a)[j];
                if (!finite_bits(x.u)) goto next;
                v[j] = x.f;
            }
        } else if (k == 2u) v[0] = (float)*(volatile int32_t *)(uintptr_t)a;
        else v[0] = (float)*(volatile int16_t *)(uintptr_t)a;
        if (w->n++ == 0u) { w->last[0] = v[0]; w->last[1] = v[1]; w->last[2] = v[2]; continue; }
        if (k == 4u) {
            float dx = v[0] - w->last[0], dy = v[1] - w->last[1], dz = v[2] - w->last[2];
            d = __builtin_sqrtf(dx * dx + dy * dy + dz * dz);
        } else d = v[0] - w->last[0];
        w->last[0] = v[0]; w->last[1] = v[1]; w->last[2] = v[2];
        if (d == 0.0f) continue;
        {
            float ad = d < 0.0f ? -d : d;
            if (w->jump_limit > 0.0f && ad > w->jump_limit) {
                w->jumps++;
                if (k != 4u && d > 0.0f) {
                    w->reloads++; w->last_reload = v[0];
                    if (v[0] > w->max_reload) w->max_reload = v[0];
                    if (w->min_reload == 0.0f || v[0] < w->min_reload) w->min_reload = v[0];
                }
                continue;
            }
            w->changes++; w->sum_abs += ad; w->sum_signed += d;
            if (ad > w->max_step) w->max_step = ad;
        }
    next:;
    }
}

/* Particle spawn density (IG-v15). Emitters written for 30 Hz allocate a fixed count
 * per update, i.e. twice the particles at 60 Hz. ig_spawn wraps the core allocator
 * 0x8C47C; a call site (caller ra) that also spawned in the previous main update is a
 * continuous emitter and keeps half of its requested count (fractional remainder
 * carried per site); one-off bursts keep their full count. A zero result mimics the
 * allocator's pool-full path (*out = 0, return 0), which every caller handles.
 * ig_sp: [0] enable, [1] allocator address, [2] calls, [3] particles withheld,
 * [4] continuous calls, [5] sites table full. */
typedef int (*AllocFn)(int *, void *, uint32_t, int);
volatile uint32_t ig_sp[8];
volatile uint32_t ig_upd;
#define SPSITES 128u
static struct { uint32_t site, last, cont; float acc; } spsite[SPSITES];

int ig_spawn(int *out, void *pool, uint32_t a2, int count, uint32_t site) {
    AllocFn alloc = (AllocFn)(uintptr_t)ig_sp[1];
    unsigned i, h;
    if (!ig_sp[0] || count <= 0) return alloc(out, pool, a2, count);
    ig_sp[2]++;
    h = (site >> 2) & (SPSITES - 1u);
    for (i = 0; i < 8u; i++) {
        unsigned j = (h + i) & (SPSITES - 1u);
        if (spsite[j].site == site || spsite[j].site == 0u) { h = j; break; }
    }
    if (i == 8u) { ig_sp[5]++; return alloc(out, pool, a2, count); }
    if (spsite[h].site != site) { spsite[h].site = site; spsite[h].last = ig_upd - 2u; spsite[h].acc = 0.0f; }
    if (spsite[h].last != ig_upd) {
        spsite[h].cont = spsite[h].last + 1u == ig_upd;
        spsite[h].last = ig_upd;
        if (!spsite[h].cont) spsite[h].acc = 0.0f;
    }
    if (spsite[h].cont) {
        int n;
        ig_sp[4]++;
        spsite[h].acc += (float)count * 0.5f;
        n = (int)spsite[h].acc;
        spsite[h].acc -= (float)n;
        ig_sp[3] += (uint32_t)(count - n);
        if (n <= 0) { *out = 0; return 0; }
        count = n;
    }
    return alloc(out, pool, a2, count);
}

/* Half-rate frame clock (IG-v14). ig_clock[1] = address of the LEVEL_01 frame counter
 * (0x2AF28C, +1 per frame); ig_clock[0] = counter / 2, refreshed before pump 1 of every
 * main update. fixes.py --fix clock rewrites lui/lw pairs of selected clock users
 * (research/v2/decomp-summary/level01-clock-sites.json) to load ig_clock[0] instead. */
volatile uint32_t ig_clock[2];

void ig_tel_pump(float dt) {
    PumpFn pump = (PumpFn)(uintptr_t)ig_tel.pump;
    uint32_t ca = ig_clock[1];
    if (ca >= 0x08800000u && ca < 0x0A000000u && !(ca & 3u)) ig_clock[0] = *(volatile uint32_t *)(uintptr_t)ca >> 1;
    ig_upd++;
    if (ig_tel.reset) {
        unsigned i;
        for (i = 0; i < WATCHES; i++) {
            volatile Watch *w = &ig_watch[i];
            w->n = w->changes = w->reloads = w->jumps = 0u;
            w->sum_abs = w->max_step = w->last_reload = w->max_reload = w->sum_signed = w->min_reload = 0.0f;
        }
        ig_tel.updates = 0u; ig_tel.dt_sum = 0.0f; ig_tel.reset = 0u;
    }
    if (ig_tel.enable) {
        tel_sample();
        ig_tel.updates++; ig_tel.dt_sum += dt; ig_tel.dt_last = dt;
    }
    pump(dt);
}

/* No main thread: returning 0 keeps the module resident. */
int module_start(SceSize args, void *argp) { (void)args; (void)argp; return 0; }
int module_stop(SceSize args, void *argp) { (void)args; (void)argp; return 0; }
