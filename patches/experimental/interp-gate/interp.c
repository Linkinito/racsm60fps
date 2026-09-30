/* InterpGate: experimental LEVEL_01 per-entity half-rate update with position
 * interpolation (option A test). No game words are changed by this module; the
 * debugger tool tools/runtime/interp-gate.py installs two call redirects:
 *   0x15230 jal pump1   -> jal ig_pump    (outer parity, accumulated delta)
 *   0x6B9B8 jalr a1     -> jal ig_entity  (a0 entity, a1 callback, f12 delta)
 * Modes: 0 passthrough (C1), 1 half-rate entities (G), 2 half-rate + interpolation (GI),
 *        3 half-step (H): 60 Hz update, then every changed float word of the entity
 *          record and of the regions at +0x58/+0x54 keeps half of its change.
 *        4 integer rule (I): 60 Hz update; in the same regions, a word that changed by
 *          exactly +1/-1 keeps its change only on every second outer update.
 *        5 H + I.
 * Position at entity +0x30/+0x34/+0x38 is INFERRED from the pump distance check.
 */
#include <pspkernel.h>
#include <stdint.h>

PSP_MODULE_INFO("InterpGate", PSP_MODULE_USER, 0, 1);
PSP_MAIN_THREAD_PARAMS(0x2Eu, 16u, PSP_THREAD_ATTR_USER);
PSP_HEAP_SIZE_KB(16);

typedef void (*PumpFn)(float);
typedef void (*EntityFn)(void *, float);

/* magic, abi, mode, pump1, parity, lastDeltaBits, runs, skips, interps,
 * teleports, tableFull, generation */
volatile uint32_t ig_state[12] = {0x49475431u, 1u, 0u, 0u, 0u, 0u, 0u, 0u, 0u, 0u, 0u, 0u};

#define SLOTS 2048u
#define PROBES 16u
typedef struct { uint32_t key, gen; float x, y, z; } Slot;
static Slot table[SLOTS];
static float last_dt, run_dt;

static Slot *lookup(uint32_t key, int create) {
    uint32_t i, h = (key >> 7) & (SLOTS - 1u);
    for (i = 0; i < PROBES; i++) {
        Slot *s = &table[(h + i) & (SLOTS - 1u)];
        if (s->key == key) return s;
        if (create && (s->key == 0 || s->gen + 4u < ig_state[11])) { s->key = key; s->gen = 0; return s; }
    }
    return 0;
}

void ig_pump(float dt) {
    PumpFn pump = (PumpFn)(uintptr_t)ig_state[3];
    if (ig_state[2] == 1u || ig_state[2] == 2u) {
        ig_state[4] ^= 1u;
        if (ig_state[4] == 0u) { run_dt = last_dt + dt; ig_state[11]++; }
        last_dt = dt;
    } else if (ig_state[2] >= 4u) {
        ig_state[4] ^= 1u; run_dt = dt;                 /* parity for the integer rule */
    } else {
        ig_state[4] = 0u; run_dt = dt;
    }
    pump(dt);
}

/* Mode 3 regions: entity record, pointer +0x58 (0x200 bytes), pointer +0x54 (0x100 bytes).
 * Region sizes are INFERRED upper bounds; only words changed by this update are touched. */
#define REC_WORDS 32u
#define A_WORDS 128u
#define B_WORDS 64u
static uint32_t snap_rec[REC_WORDS], snap_a[A_WORDS], snap_b[B_WORDS];

static int is_user(uint32_t p) { return p >= 0x08800000u && p < 0x0A000000u - 0x200u && !(p & 3u); }
static int plain_float(uint32_t w) {
    uint32_t e = (w >> 23) & 0xFFu;
    return w == 0u || w == 0x80000000u || (e >= 0x40u && e <= 0xBEu);   /* ~1e-19 .. ~1e19 */
}
static void half_step(volatile uint32_t *now, const uint32_t *before, unsigned n) {
    unsigned i;
    for (i = 0; i < n; i++) {
        union { uint32_t u; float f; } a, b;
        a.u = before[i]; b.u = now[i];
        if (a.u == b.u || !plain_float(a.u) || !plain_float(b.u)) continue;
        if (b.f - a.f > 4.0f || a.f - b.f > 4.0f) { ig_state[9]++; continue; }
        b.f = a.f + (b.f - a.f) * 0.5f; now[i] = b.u; ig_state[8]++;
    }
}
static int is_step_int(uint32_t a, uint32_t b) {
    uint32_t d = b - a;
    if (d != 1u && d != 0xFFFFFFFFu) return 0;
    /* plain small integers only (not floats, not pointers) */
    return (a < 0x01000000u || a > 0xFF000000u) && (b < 0x01000000u || b > 0xFF000000u);
}
static void int_rule(volatile uint32_t *now, const uint32_t *before, unsigned n) {
    unsigned i;
    if (ig_state[4] == 0u) return;                       /* even update: keep */
    for (i = 0; i < n; i++)
        if (is_step_int(before[i], now[i])) { now[i] = before[i]; ig_state[10]++; }
}
static void half_step_update(void *entity, EntityFn update, float dt) {
    volatile uint32_t *rec = (volatile uint32_t *)entity;
    uint32_t pa = rec[0x58/4], pb = rec[0x54/4]; unsigned i;
    int ha = is_user(pa), hb = is_user(pb) && pb != pa;
    for (i = 0; i < REC_WORDS; i++) snap_rec[i] = rec[i];
    if (ha) for (i = 0; i < A_WORDS; i++) snap_a[i] = ((volatile uint32_t *)(uintptr_t)pa)[i];
    if (hb) for (i = 0; i < B_WORDS; i++) snap_b[i] = ((volatile uint32_t *)(uintptr_t)pb)[i];
    uint32_t mode = ig_state[2];
    update(entity, dt);
    ig_state[6]++;
    if (mode != 4u) {
        half_step(rec, snap_rec, REC_WORDS);
        if (ha && rec[0x58/4] == pa) half_step((volatile uint32_t *)(uintptr_t)pa, snap_a, A_WORDS);
        if (hb && rec[0x54/4] == pb) half_step((volatile uint32_t *)(uintptr_t)pb, snap_b, B_WORDS);
    }
    if (mode >= 4u) {
        int_rule(rec, snap_rec, REC_WORDS);
        if (ha && rec[0x58/4] == pa) int_rule((volatile uint32_t *)(uintptr_t)pa, snap_a, A_WORDS);
        if (hb && rec[0x54/4] == pb) int_rule((volatile uint32_t *)(uintptr_t)pb, snap_b, B_WORDS);
    }
}

void ig_entity(void *entity, EntityFn update, float dt) {
    float *pos = (float *)((char *)entity + 0x30);
    uint32_t mode = ig_state[2];
    Slot *s;
    if (mode == 0u) { update(entity, dt); return; }
    if (mode >= 3u) { half_step_update(entity, update, dt); return; }
    if (ig_state[4] != 0u) {                /* skip frame: show true position */
        ig_state[7]++;
        if (mode == 2u && (s = lookup((uint32_t)(uintptr_t)entity, 0)) && s->gen == ig_state[11]) {
            pos[0] = s->x; pos[1] = s->y; pos[2] = s->z;
        }
        return;
    }
    {
        float ax = pos[0], ay = pos[1], az = pos[2], dx, dy, dz;
        ig_state[6]++;
        update(entity, run_dt);
        if (mode != 2u) return;
        dx = pos[0] - ax; dy = pos[1] - ay; dz = pos[2] - az;
        if (dx * dx + dy * dy + dz * dz > 25.0f) { ig_state[9]++; return; }   /* teleport: no blend */
        if (!(s = lookup((uint32_t)(uintptr_t)entity, 1))) { ig_state[10]++; return; }
        s->x = pos[0]; s->y = pos[1]; s->z = pos[2]; s->gen = ig_state[11];
        pos[0] = ax + dx * 0.5f; pos[1] = ay + dy * 0.5f; pos[2] = az + dz * 0.5f;
        ig_state[8]++;
    }
}

/* Returning from main would reach newlib exit() -> sceKernelExitGame. */
/* Ground-navigation move (LEVEL_01 0x2A8F0): a0 nav, a1 moby, a2 const float[3]
 * per-call displacement (direction * speed per frame), a3, t0 flags, f12.
 * The callee only reads a2 (OBSERVED), so a halved copy is passed.
 * ig_move[0] enable, [1] original function address, [2] calls. */
typedef int (*MoveFn)(void *, void *, const float *, uint32_t, uint32_t, float);
volatile uint32_t ig_move[4] = {0u, 0u, 0u, 0u};
int ig_nav_move(void *nav, void *moby, const float *disp, uint32_t a3, uint32_t t0, float f12) {
    MoveFn move = (MoveFn)(uintptr_t)ig_move[1];
    float half[4];
    if (!ig_move[0]) return move(nav, moby, disp, a3, t0, f12);
    half[0] = disp[0] * 0.5f; half[1] = disp[1] * 0.5f; half[2] = disp[2] * 0.5f; half[3] = disp[3];
    ig_move[2]++;
    return move(nav, moby, half, a3, t0, f12);
}

/* Fixed-step helper wrappers. ig_fix[i*4+0] enable, +1 original address, +2 calls.
 * Slot 0 debris physics 0x191D7C (a0 moby, a1 phys, a2 params, f12): per call
 *   lifetime moby+0x70 -= step, phys v.y -= gravity, moby pos += phys v (OBSERVED).
 *   Keeping half of each change is the 30->60 Hz transform for this recurrence.
 *   A velocity component that changes sign (bounce) keeps its full change.
 *   Nothing is touched when the callee returns 0 (object destroyed).
 * Slot 1 animated displacement 0x6C318 (a0 obj, a1 out float[3], a2, a3): adds a
 *   fixed per-call displacement to a1 (OBSERVED); half of the addition is kept.
 *   Its v0 (from 0x6C2B8) reaches callers and must be returned unchanged: IG-v6
 *   declared it void and froze the game thread when enabled (owner-observed). */
typedef int (*DebrisFn)(void *, float *, void *, float);
typedef int (*VecFn)(void *, float *, uint32_t, uint32_t);
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

int ig_anim_disp(void *obj, float *out, uint32_t a2, uint32_t a3) {
    VecFn f = (VecFn)(uintptr_t)ig_fix[5];
    float o0 = out[0], o1 = out[1], o2 = out[2];
    int r = f(obj, out, a2, a3);
    if (!ig_fix[4]) return r;
    ig_fix[6]++;
    out[0] = halve(o0, out[0]); out[1] = halve(o1, out[1]); out[2] = halve(o2, out[2]);
    return r;
}

/* Particle animator half-step (walker site 0x8CE54). ig_pfix: [0] enable,
 * [1] animator address to correct (waterfall 0xDE23C), [2] calls, [3] particles.
 * Animator arguments (OBSERVED 0xDE23C): a0 vertex output, a1 first vertex index,
 * a2 emitter-instance list sentinel (node = *(a2+4), next = *(node+4)),
 * a3 pool parameters. Instance: +8 particle array, +12 u16 first, +14 u16 count;
 * particle record 80 bytes. Fields changed per call by 0xDE23C and halved here:
 * pos +0x00..+0x08, vel +0x0C..+0x14, spin +0x18, age +0x20, dir +0x2C/+0x30,
 * life +0x48. Slots are stable (ring advances by first/count only, INFERRED). */
typedef int (*AnimFn)(void *, int, void *, void *);
volatile uint32_t ig_ptarget;
volatile uint32_t ig_pfix[4] = {0u, 0u, 0u, 0u};
#define PMAX 1536u
static const unsigned char pfield[11] = {0, 1, 2, 3, 4, 5, 6, 8, 11, 12, 18};
static float psnap[PMAX][11];
static uint32_t pident[PMAX][3];                 /* +0x1C gravity, +0x3C spin speed, +0x44 drag */
static uint32_t pnode_base[64]; static uint16_t pnode_first[64], pnode_count[64];

int ig_particles(void *out, int first, void *head, void *params) {
    AnimFn anim = (AnimFn)(uintptr_t)ig_ptarget;
    uint32_t node, n = 0, k = 0, i, f, j;
    int r;
    if (!ig_pfix[0] || ig_ptarget != ig_pfix[1]) return anim(out, first, head, params);
    for (node = *(volatile uint32_t *)((char *)head + 4); node && node != (uint32_t)(uintptr_t)head && n < 64;
         node = *(volatile uint32_t *)(uintptr_t)(node + 4), n++) {
        uint32_t base = *(volatile uint32_t *)(uintptr_t)(node + 8);
        uint16_t pf = *(volatile uint16_t *)(uintptr_t)(node + 12), pc = *(volatile uint16_t *)(uintptr_t)(node + 14);
        if (k + pc > PMAX || base < 0x08800000u || base >= 0x0A000000u) { pc = 0; }
        pnode_base[n] = base; pnode_first[n] = pf; pnode_count[n] = pc;
        for (i = 0; i < pc; i++, k++) {
            volatile float *rec = (volatile float *)(uintptr_t)(base + 80u * (pf + i));
            for (f = 0; f < 11; f++) psnap[k][f] = rec[pfield[f]];
            pident[k][0] = ((volatile uint32_t *)rec)[7]; pident[k][1] = ((volatile uint32_t *)rec)[15]; pident[k][2] = ((volatile uint32_t *)rec)[17];
        }
    }
    r = anim(out, first, head, params);
    ig_pfix[2]++;
    for (j = 0, k = 0; j < n; j++) {
        uint32_t base = pnode_base[j]; uint16_t pf = pnode_first[j], pc = pnode_count[j];
        /* A dying particle is replaced by the last one (80-byte copy at 0xDE458) and
         * first/count shrink: only slots still live and holding the same particle
         * (unchanged per-particle constants) are corrected (IG-v9 mixed particles). */
        uint32_t node = 0, m, nf = 0, nc = 0;
        for (m = 0, node = *(volatile uint32_t *)((char *)head + 4); m < j && node; m++) node = *(volatile uint32_t *)(uintptr_t)(node + 4);
        if (node) { nf = *(volatile uint16_t *)(uintptr_t)(node + 12); nc = *(volatile uint16_t *)(uintptr_t)(node + 14); }
        for (i = 0; i < pc; i++, k++) {
            volatile float *rec = (volatile float *)(uintptr_t)(base + 80u * (pf + i));
            volatile uint32_t *w = (volatile uint32_t *)rec;
            if (pf + i < nf || pf + i >= nf + nc || w[7] != pident[k][0] || w[15] != pident[k][1] || w[17] != pident[k][2]) { ig_pfix[3]--; continue; }
            float nx = rec[11], ny = rec[12], hx, hy, want, have;
            for (f = 0; f < 11; f++) rec[pfield[f]] = psnap[k][f] + (rec[pfield[f]] - psnap[k][f]) * 0.5f;
            /* dir +0x2C/+0x30 is rotated per call: a halved change shortens it and
             * collapsed sprites flickered (IG-v8, owner-observed). Keep its length. */
            hx = rec[11]; hy = rec[12]; want = nx * nx + ny * ny; have = hx * hx + hy * hy;
            if (have > 1e-12f && want > 0.0f) {
                float scale = 1.0f, x = want / have;   /* sqrt by 4 Newton steps near 1 */
                { unsigned q; for (q = 0; q < 4; q++) scale = 0.5f * (scale + x / scale); }
                rec[11] = hx * scale; rec[12] = hy * scale;
            }
        }
        ig_pfix[3] += pc;
    }
    return r;
}

int main(void) { sceKernelExitThread(0); return 0; }
