/* RenderInterp prototype RI-v1 (experimental, UCES00420 LEVEL_01 only, no plugin).
 * Freestanding code copied into a zero run of the LEVEL_01 module by tools/runtime/render-interp.py.
 * Three call redirects (all `jal` replacements, same calling convention):
 *   ri_pump1  at 0x15230 : group pump 1 only every second outer update (accumulated delta), mode >= 1
 *   ri_pump2  at 0x15338 : mode 2: blend moving records halfway between frame-start snapshot and
 *                          current value, then run the real pump 2; blended values stay until the next frame
 *   ri_frame  at 0x13FB0 : restores true record values, takes the frame-start snapshot, runs 0x159DC
 * Records: group root *(RI_ROOTVAR) -> +0x34 group array (0x50 each), +0x38 count; group +0xC records,
 * +0x3C count, +0x48 active byte; record stride 0x80, flag word +0x64 bit 0 = live (all OBSERVED in
 * the local decompilation of P_GroupPump2). Blended words: basis (0,1,2,4,5,6,8,9,10) and position
 * (12,13,14). Nothing is blended when the position moved more than RI_JUMP units (teleport/spawn).
 * Skinned animation poses are NOT blended (they stay at the logic rate). Symbols RI_* come from --defsym. */
typedef unsigned int u32;
typedef void (*Pump1Fn)(float);
typedef void (*VoidFn)(void);
typedef int (*FrameFn)(void);
extern char RI_PUMP1[], RI_PUMP2[], RI_FRAME[], RI_ROOTVAR[], RI_ALLOC[], RI_HEAD[], RI_FOGRESET[], RI_LIGHTS[], RI_GATE1[], RI_GATE2[], RI_COUNTER[], RI_PRIMRESET[], RI_PRIMCNT[], RI_PRIMLIST[], RI_FREE[], RI_SCRATCH[], RI_POOL1[], RI_POOL2[], RI_LATCH[], RI_DIREDGE[], RI_HELP[], RI_PRIMPTR[], RI_PRIMBASE[], RI_PRIMEND[], RI_PARTICLES[], RI_WEAPON[], RI_ITEMPOOL[], RI_NODES[], RI_STRIDES[], RI_FLUSH[], RI_L1CNT[], RI_L2CNT[], RI_L3CNT[], RI_DCNT[];
typedef int (*AllocFn)(int, const char *, int, unsigned, void *);
typedef void *(*HeadFn)(int);

#define NW 12
static const unsigned char WORDS[NW] = {0, 1, 2, 4, 5, 6, 8, 9, 10, 12, 13, 14};
#define BACKUP_CAP 256
#define ESZ (1 + 2 * NW)   /* entry: record address, true words, blended words */
#define RI_JUMP2 9.0f          /* (3 units)^2 */
#define RI_ROT 0.8f

/* state (initialised data so it is part of the copied blob); indices are used by the Python tool */
volatile u32 ri_st[32] __attribute__((section(".data"))) = {
    1,   /* 0 mode: 0 passthrough, 1 gate only, 2 gate + blend */
    0,   /* 1 phase */
    0,   /* 2 accum (float bits) */
    0,   /* 3 runs */
    0,   /* 4 skips */
    0,   /* 5 frames */
    0,   /* 6 blended records last frame */
    0,   /* 7 snapshot cap (slots) */
    0,   /* 8 init state: 0 none, 1 ok, 2 alloc failed */
    0,   /* 9 total blended */
    0,   /* 10 backup count */
    0,   /* 11 words written by others between blend and restore (kept) */
    0,   /* 12 fog resets skipped */
    0,   /* 13 light-list resets skipped */
    0,   /* 14 deferred-draw lists restored on skipped frames */
    0,   /* 15 partition block uid */
    0,   /* 16 free request (1) / done (2) */
    0, 0, 0,
    0,   /* 20 particle replays */
    0,   /* 21 weapon updates skipped */
    0, 0
};
#define OFF(b) 0
#define PRIM_MAX 0x80u
#define VWORDS 0x2000u
#define XWORDS 0x2000u
static u32 *plist __attribute__((section(".data"))) = 0;
static u32 *elist __attribute__((section(".data"))) = 0;
static u32 ecount __attribute__((section(".data"))) = 0;
static u32 *wlist __attribute__((section(".data"))) = 0;
static u32 *nlist __attribute__((section(".data"))) = 0;
static u32 *xbuf __attribute__((section(".data"))) = 0;
static u32 xk[16] __attribute__((section(".data")));
static u32 nxk __attribute__((section(".data"))) = 0;
static u32 *vold __attribute__((section(".data"))) = 0;
static u32 *vnew __attribute__((section(".data"))) = 0;
static u32 *mold __attribute__((section(".data"))) = 0;
static u32 *mnew __attribute__((section(".data"))) = 0;
static u32 *hl __attribute__((section(".data"))) = 0;   /* hybrid saved lists: [0..4] counts, then L1 48, L2 48, L3 32, deferred 0x80*5 words */
volatile u32 ri_cls[8] __attribute__((section(".data"))) = {0, 0, 0, 0, 0, 0, 0, 0};   /* class update addresses run at 60 Hz in mode 3 */
static u32 wcount __attribute__((section(".data"))) = 0;
static float *snap __attribute__((section(".data"))) = 0;
static u32 *backup __attribute__((section(".data"))) = 0;

static int okptr(u32 p) { return p >= 0x08800000u && p < 0x0A000000u; }
static int okw(u32 w) { return ((w >> 23) & 0xFFu) < 150u; }   /* finite and below 2^23 */

static void forslots(int mode) {              /* mode 0 snapshot, 1 blend */
    u32 root = *(volatile u32 *)(u32)RI_ROOTVAR, slot = 0, g, k, n, cnt, arr, w;
    if (!okptr(root)) return;
    arr = *(volatile u32 *)(root + 0x34); cnt = *(volatile u32 *)(root + 0x38);
    if (!okptr(arr) || cnt > 1024u) return;
    for (g = 0; g < cnt; g++) {
        u32 gd = arr + g * 0x50u, recs = *(volatile u32 *)(gd + 0xC);
        n = *(volatile u32 *)(gd + 0x3C);
        if (!okptr(recs) || n > 4096u) continue;
        for (k = 0; k < n; k++, slot++) {
            volatile float *r;
            float *s;
            if (slot >= ri_st[7]) return;
            r = (volatile float *)(recs + k * 0x80u); s = snap + slot * NW;
            if (mode == 0) { for (w = 0; w < NW; w++) s[w] = r[WORDS[w]]; continue; }
            if (!(*(volatile u32 *)(recs + k * 0x80u + 0x64) & 1u) || !*(volatile unsigned char *)(gd + 0x48)) continue;
            {
                float d2 = 0.0f, mx = 0.0f; int moved = 0, bad = 0;
                for (w = 0; w < NW; w++) {
                    float a = s[w], b = r[WORDS[w]], d;
                    if (!okw(*(u32 *)&a) || !okw(*(u32 *)&b)) { bad = 1; break; }
                    d = b - a; if (d != 0.0f) moved = 1;
                    if (w >= 9) d2 += d * d; else { if (d < 0.0f) d = -d; if (d > mx) mx = d; }
                }
                if (bad || !moved || d2 > RI_JUMP2 || mx > RI_ROT || ri_st[10] >= BACKUP_CAP) continue;
                {
                    u32 *e = backup + ri_st[10] * ESZ;
                    e[0] = (u32)r;
                    for (w = 0; w < NW; w++) {
                        float b = r[WORDS[w]], m = (s[w] + b) * 0.5f;
                        e[1 + w] = *(u32 *)&b; e[1 + NW + w] = *(u32 *)&m; r[WORDS[w]] = m;
                    }
                    ri_st[10]++;
                }
            }
        }
    }
}

static void restore(void) {
    u32 i, w;
    for (i = 0; i < ri_st[10]; i++) {
        u32 *e = backup + i * ESZ;
        volatile u32 *r = (volatile u32 *)e[0];
        for (w = 0; w < NW; w++) {
            if (r[WORDS[w]] == e[1 + NW + w]) r[WORDS[w]] = e[1 + w];   /* untouched since the blend: put the true value back */
            else ri_st[11]++;                                          /* someone wrote it meanwhile: keep that value */
        }
    }
    ri_st[10] = 0;
}

static void init(void) {
    u32 root = *(volatile u32 *)(u32)RI_ROOTVAR, arr, cnt, g, total = 0, size;
    int uid;
    ri_st[8] = 2;
    if (!okptr(root)) return;
    arr = *(volatile u32 *)(root + 0x34); cnt = *(volatile u32 *)(root + 0x38);
    if (!okptr(arr) || cnt > 1024u) return;
    for (g = 0; g < cnt; g++) total += *(volatile u32 *)(arr + g * 0x50u + 0x3C);
    total += total / 4u + 64u;
    size = total * NW * 4u + BACKUP_CAP * ESZ * 4u + PRIM_MAX * 5u * 4u * 3u + 0x300u + 0x500u + 0x18500u + 64u;
    uid = ((AllocFn)(u32)RI_ALLOC)(2, "RI", 0, size, 0);
    if (uid < 0) return;
    ri_st[15] = (u32)uid;
    snap = (float *)((HeadFn)(u32)RI_HEAD)(uid);
    if (!okptr((u32)snap)) return;
    backup = (u32 *)(snap + total * NW);
    plist = backup + BACKUP_CAP * ESZ;
    elist = plist + PRIM_MAX * 5u;
    wlist = elist + PRIM_MAX * 5u;
    nlist = wlist + PRIM_MAX * 5u;
    hl = nlist + 0xC0u;
    vold = hl + 0x140u; vnew = vold + VWORDS; mold = vnew + VWORDS; mnew = mold + 120u; xbuf = mnew + 120u;
    ri_st[7] = total; ri_st[8] = 1; ri_st[10] = 0;
}

/* Button latch (sceCtrlReadLatch result, read once per frame by FUN_00075454): make 0x36EE90, break 0x36EE94,
 * (uiRelease at +0xC is a level, not an event, and is not merged) and the stick-as-direction edge 0x2B2BE4 hold an event only for the frame it happened.
 * Pump 1 objects (teleporter, shop...) only run on every second frame, so events of the skipped frame are
 * accumulated and shown to pump 1 on the next update frame; the player (every frame) never sees the merged
 * copy (current values are put back right after pump 1). Held state is not touched. */
static u32 acc_make, acc_break, acc_dir;

/* Direct draw entries (FUN_0008DB74, 5 words each, array at *RI_PRIMBASE, last-entry pointer in 0x2DD330) pushed
 * while pump 1 runs are remembered and appended again on the following skipped frame (their vertices live in the
 * other half of the double-buffered vertex area and stay valid until the next update frame). */
static void __attribute__((noinline)) copyw(volatile u32 *d, const volatile u32 *sr, u32 n) { while (n--) *d++ = *sr++; }

static u32 capture_to(u32 p0, u32 *dst) {
    u32 p1 = *(volatile u32 *)(u32)RI_PRIMPTR, n;
    if (p1 <= p0 || !dst) return 0;
    n = (p1 - p0) / 0x14u;
    if (n > PRIM_MAX) return 0;
    copyw(dst, (volatile u32 *)(p0 + 0x14u), n * 5u);
    return n;
}

static void replay_from(const u32 *src, u32 count) {
    u32 i, w, base = *(volatile u32 *)(u32)RI_PRIMBASE, end = *(volatile u32 *)(u32)RI_PRIMEND;
    for (i = 0; i < count; i++) {
        u32 cur = *(volatile u32 *)(u32)RI_PRIMPTR, nw;
        if (cur >= end) break;
        nw = cur + 0x14u;
        for (w = 0; w < 5u; w++) *(volatile u32 *)(nw + w * 4u) = src[i * 5u + w];
        *(volatile unsigned short *)(nw + 8u) = (unsigned short)((nw - base) / 0x14u);
        *(volatile u32 *)(u32)RI_PRIMPTR = nw;
    }
}


/* Hybrid mode 3: pump 1 runs on every frame; entity callbacks of classes not in ri_cls[] run only on update frames
 * (with the accumulated delta in ri_st[27]); everything they register (three callback lists, the deferred draw list,
 * direct draw entries) is captured per callback and appended again after pump 1 on skipped frames. Classes in ri_cls[]
 * run at 60 Hz (their per-class fixes must be applied by the tool). */
#define L1E ((volatile u32 *)((u32)RI_L1CNT + 4u))
#define L2E ((volatile u32 *)((u32)RI_L2CNT + 4u))
#define L3E ((volatile u32 *)((u32)RI_L3CNT + 4u))
#define DEE ((volatile u32 *)(u32)RI_PRIMLIST)
#define HI __attribute__((section(".hitext")))
static void lcap(volatile u32 *cnt, volatile u32 *ent, u32 w, u32 cap, u32 before, u32 *dst, u32 *n) {
    u32 now = *cnt;
    if (now <= before || now > cap) return;
    if (*n + (now - before) > cap) return;
    copyw(dst + *n * w, ent + before * w, (now - before) * w); *n += now - before;
}
HI static void lapp(volatile u32 *cnt, volatile u32 *ent, u32 w, u32 cap, const u32 *src, u32 n) {
    u32 c = *cnt;
    if (c + n > cap) n = cap > c ? cap - c : 0;
    copyw(ent + c * w, src, n * w); *cnt = c + n;
}
__attribute__((noinline)) static void pcap(u32 p0) {
    u32 p1 = *(volatile u32 *)(u32)RI_PRIMPTR, n;
    if (p1 > p0) { n = (p1 - p0) / 0x14u; if (ecount + n <= PRIM_MAX) { copyw(elist + ecount * 5u, (volatile u32 *)(p0 + 0x14u), n * 5u); ecount += n; } }
}
HI void ri_entity(void *e, void (*cb)(void *, float), float dt) {
    u32 i, a1, a2, a3, ad, p0;
    if (ri_st[0] == 0u || ri_st[8] != 1u) { cb(e, dt); return; }
    for (i = 0; i < 8u; i++) if (ri_cls[i] == (u32)cb) { cb(e, dt); return; }
    if (ri_st[1] == 0u) return;
    a1 = *(volatile u32 *)(u32)RI_L1CNT; a2 = *(volatile u32 *)(u32)RI_L2CNT; a3 = *(volatile u32 *)(u32)RI_L3CNT;
    ad = *(volatile u32 *)(u32)RI_DCNT; p0 = *(volatile u32 *)(u32)RI_PRIMPTR;
    cb(e, *(float *)&ri_st[27]);
    lcap((volatile u32 *)(u32)RI_L1CNT, L1E, 3u, 16u, a1, hl + 5, &hl[0]);
    lcap((volatile u32 *)(u32)RI_L2CNT, L2E, 3u, 16u, a2, hl + 53, &hl[1]);
    lcap((volatile u32 *)(u32)RI_L3CNT, L3E, 2u, 16u, a3, hl + 101, &hl[2]);
    lcap((volatile u32 *)(u32)RI_DCNT, DEE, 5u, PRIM_MAX, ad, hl + 133, &hl[3]);
    pcap(p0);
}
static void hybrid_pump1(float dt) {
    volatile u32 *l = (volatile u32 *)(u32)RI_LATCH, *dir = (volatile u32 *)(u32)RI_DIREDGE;
    u32 m = l[0], b = l[1], d = *dir;
    ri_st[1] ^= 1u;
    if (ri_st[1] == 0u) { float a = dt; ri_st[2] = *(u32 *)&a; ri_st[4]++; acc_make |= m; acc_break |= b; acc_dir |= d; }
    else {
        float t = dt + *(float *)&ri_st[2]; ri_st[27] = *(u32 *)&t; ri_st[3]++;
        hl[0] = hl[1] = hl[2] = hl[3] = 0; ecount = 0;
        l[0] = m | acc_make; l[1] = b | acc_break; *dir = d | acc_dir; acc_make = acc_break = acc_dir = 0;
    }
    ((Pump1Fn)(u32)RI_PUMP1)(dt);
    if (ri_st[1] == 0u) {
        lapp((volatile u32 *)(u32)RI_L1CNT, L1E, 3u, 16u, hl + 5, hl[0]);
        lapp((volatile u32 *)(u32)RI_L2CNT, L2E, 3u, 16u, hl + 53, hl[1]);
        lapp((volatile u32 *)(u32)RI_L3CNT, L3E, 2u, 16u, hl + 101, hl[2]);
        lapp((volatile u32 *)(u32)RI_DCNT, DEE, 5u, PRIM_MAX, hl + 133, hl[3]);
        replay_from(elist, ecount);
    }
    l[0] = m; l[1] = b; *dir = d;
}


void ri_pump1(float dt) {
    if (ri_st[0] == 0u || ri_st[8] != 1u) { ((Pump1Fn)(u32)RI_PUMP1)(dt); return; }
    hybrid_pump1(dt);
}

void ri_pump2(void) {
    if (ri_st[0] >= 2u && ri_st[8] == 1u) { forslots(1); }
    ((VoidFn)(u32)RI_PUMP2)();
}

typedef int (*FreeFn)(int);
int ri_frame(void) {
    if (ri_st[16] == 1u) {                 /* tool asked to release the memory block before removal */
        if (ri_st[8] == 1u) { restore(); ri_st[8] = 3u; ((FreeFn)(u32)RI_FREE)((int)ri_st[15]); }
        ri_st[0] = 0u; ri_st[16] = 2u;
    }
    if (ri_st[8] == 0u) init();
    if (ri_st[8] == 1u) { restore(); if (ri_st[0] >= 2u) forslots(0); }
    ri_st[5]++;
    return ((FrameFn)(u32)RI_FRAME)();
}

/* State that pump 1 callbacks (re)register every call but that the main update resets every frame would be
 * missing on the frames where pump 1 is skipped (flicker). Two such cases found (OBSERVED in the local
 * decompilation, flicker reported by the owner): fog override (reset by 0x88768, set by FogMoby via 0x88720)
 * and the moby light-influence list (reset by 0x67D94/0x68070 inside 0x159A0, each gated by "frame counter
 * changed"). On a skipped frame the fog reset is not run and the two gate variables are set to the current
 * counter so the light-list reset is skipped as well. will-run-next: ri_pump1 toggles phase, so pump 1 runs
 * when the stored phase is 0. */
static int skip_frame(void) { return ri_st[0] >= 1u && ri_st[1] == 1u; }

void ri_fog(void) {
    if (skip_frame() && !OFF(1)) return;
    ((VoidFn)(u32)RI_FOGRESET)();
}

void ri_lights(void) {
    if (skip_frame() && !OFF(2)) {
        u32 n = *(volatile u32 *)(u32)RI_COUNTER;
        *(volatile u32 *)(u32)RI_GATE1 = n; *(volatile u32 *)(u32)RI_GATE2 = n;
    }
    ((VoidFn)(u32)RI_LIGHTS)();
}

/* Deferred draw list (FUN_0008E1C8 pushes {key, callback, argument} entries of 0x14 bytes at 0x303144,
 * count at 0x303B44; callers include GlowCard_Update, i.e. the light glows) is emptied by FUN_0008DC14 at the
 * start of every frame but only refilled by pump 1 callbacks. On a skipped frame the previous list is saved
 * before the real reset and put back afterwards. OBSERVED: the sorted primitive count 0x302F20 alternated 3/0
 * between frames with the gate on. Other pushers that run every frame would be drawn twice on such frames
 * (counter ri_st[14] tells how often the restore ran; duplicates not examined). */
#define NODE_WORDS 161u        /* 0x303B48..0x303DCC: node free list, id table, see FUN_0008DC14 */
void ri_prim(void) {
    if (skip_frame() && ri_st[8] == 1u) {
        volatile u32 *nd = (volatile u32 *)(u32)RI_NODES, *ip = (volatile u32 *)(u32)RI_ITEMPOOL;
        u32 i0 = ip[0], i1 = ip[1];
        copyw(nlist, nd, NODE_WORDS);
        ((VoidFn)(u32)RI_PRIMRESET)();
        copyw(nd, nlist, NODE_WORDS);
        ip[0] = i0; ip[1] = i1;                 /* per-frame item pool (FUN_00090118/90214): bytes left, next item */
        return;
    }
    ((VoidFn)(u32)RI_PRIMRESET)();
}

/* RI-v1j: ri_scratch (keep the frame scratch pool offsets on skipped frames) was removed for code size; the pool is used at
 * 80/8192 words and the hook did not change the flicker. */

/* Help/prompt manager FUN_000A47B8 (HUD, once per frame, argument = latch make): a request made by a pump 1 object
 * (FUN_000A4BDC sets DAT_002BC6A4 = 2) lasts two calls, so on frames where pump 1 is skipped the prompt was closed
 * and re-created every second frame and its confirm flag (DAT_002BC6BC, cleared at each call) was lost.
 * Like the original 30 Hz outer update, it now runs on update frames only; button events of skipped frames are
 * added to the next call. */
typedef void (*HelpFn)(u32);
static u32 acc_help;
void ri_help(u32 b) {
    if (ri_st[0] >= 1u && ri_st[1] == 0u && !OFF(32)) { acc_help |= b; return; }
    b |= acc_help; acc_help = 0;
    ((HelpFn)(u32)RI_HELP)(b);
}

/* Particle walker (FUN_0008CC18, called once per frame after pump 2; advances every particle with fixed per-call
 * steps and pushes the draw entries). Like pump 1 it now runs on update frames only (original 30 Hz rate, so the
 * teleporter effects, which ran twice as fast, are back to their 2 s) and its draw entries are replayed on the
 * skipped frame so the particles are still drawn every frame (they move at 30 Hz). Entries are captured after the
 * call (the walker also increments the vertex count of its last entry). */
typedef int (*WalkFn)(int, int, int);
/* Vertex mixing for every direct draw entry of the world-space types 6, 7, 8 (position = last three floats of the vertex,
 * stride table at 0x2B66B0; walker batches and sprites made by the deferred draw callbacks alike), run right after the flush
 * of the sorted list (FUN_0008E2D4). An entry is "30 Hz" when on a skipped frame its vertices equal those of the previous
 * update frame (learned per key, re-learned every skipped frame). On an update frame the true vertices of every eligible entry
 * are saved; 30 Hz entries are drawn at the mean of the previous update's nearest vertex and the new one (match radius 4
 * units, index first, then a window of +-16 vertices: a full scan cost about 12 M instructions per update on a 684-vertex batch); on the next skipped frame the true values are written back before the flush. */
#define MAXE 24u
static u32 nold __attribute__((section(".data"))) = 0, nnew __attribute__((section(".data"))) = 0, n30 __attribute__((section(".data"))) = 0;
static u32 k30[16] __attribute__((section(".data")));
static u32 pstride(u32 key) { u32 t = (key >> 2) & 15u; return (t == 1u || (t >= 6u && t <= 8u)) ? *(volatile u32 *)((u32)RI_STRIDES + t * 4u) / 4u : 0u; }
HI static int isdup(u32 vp) { return xbuf && (vp & 0x0FFFFFFFu) - ((u32)xbuf & 0x0FFFFFFFu) < XWORDS * 4u; }
HI static u32 ordof(volatile u32 *arr, u32 k) { u32 i, o = 0; for (i = 0; i < k; i++) if (arr[i * 5u] == arr[k * 5u] && !isdup(arr[i * 5u + 3u])) o++; return o; }
HI static int is30(u32 key) { u32 i; for (i = 0; i < n30; i++) if (k30[i] == key) return 1; return 0; }
HI static void set30(u32 key, int on) {
    u32 i;
    for (i = 0; i < n30; i++) if (k30[i] == key) { if (!on) k30[i] = k30[--n30]; return; }
    if (on && n30 < 16u) k30[n30++] = key;
}
static void punmix(void) {
    u32 k;
    for (k = 0; k < nnew; k++) copyw((volatile u32 *)mnew[k * 5u + 3u], vnew + mnew[k * 5u + 2u], mnew[k * 5u + 4u]);
}
/* mix the vertices at vp (live, to be modified) whose true new values are nv with the nearest vertex of ov (cnt new, on old) */
HI __attribute__((noinline)) static void mixv(u32 vp, const u32 *nv, const u32 *ov, u32 cnt, u32 on, u32 st) {
    u32 v, u, j;
    if (st == 4u) {                      /* type 1: screen-space sprites, word 2 = s16 x | s16 y << 16 */
        for (v = 0; v < cnt; v++) {
            u32 nw = nv[v * 4u + 2u], ow;
            int nx = (short)nw, ny = (short)(nw >> 16), bi = -1, bd = 576, dx, dy, d;
            if (v < on) { ow = ov[v * 4u + 2u]; dx = (short)ow - nx; dy = (short)(ow >> 16) - ny; if (dx * dx + dy * dy <= 4) bi = (int)v; }
            if (bi < 0) for (u = (v > 16u ? v - 16u : 0u); u < on && u <= v + 16u; u++) { ow = ov[u * 4u + 2u]; dx = (short)ow - nx; dy = (short)(ow >> 16) - ny; d = dx * dx + dy * dy; if (d < bd) { bd = d; bi = (int)u; } }
            ri_st[20]++;
            if (bi >= 0) { ow = ov[bi * 4u + 2u]; ri_st[14]++; ((volatile u32 *)vp)[v * 4u + 2u] = (u32)((((short)ow + nx) >> 1) & 0xFFFF) | ((u32)((((short)(ow >> 16) + ny) >> 1)) << 16); }
        }
        return;
    }
    {
        const float *ob = (const float *)(ov + st - 3u);
        for (v = 0; v < cnt; v++) {
            const float *b = (const float *)(nv + v * st + st - 3u);
            u32 best = on;
            float bd = 16.0f, d2;
#define D2(U) ((ob[(U) * st] - b[0]) * (ob[(U) * st] - b[0]) + (ob[(U) * st + 1u] - b[1]) * (ob[(U) * st + 1u] - b[1]) + (ob[(U) * st + 2u] - b[2]) * (ob[(U) * st + 2u] - b[2]))
            if (v < on && (d2 = D2(v)) < 0.25f) best = v;
            else for (u = (v > 16u ? v - 16u : 0u); u < on && u <= v + 16u; u++) if ((d2 = D2(u)) < bd) { bd = d2; best = u; }
            ri_st[20]++;
            if (best < on) { ri_st[14]++; for (j = 0; j < 3u; j++) { float h = (ob[best * st + j] + b[j]) * 0.5f; ((volatile u32 *)vp)[v * st + st - 3u + j] = *(u32 *)&h; } }
        }
    }
}
HI static u32 half(u32 c) { return ((c >> 1) & 0x7F000000u) | (c & 0x00FFFFFFu); }
HI __attribute__((noinline)) static void flushU(void) {
    u32 k, off = 0, q, v, *t, n, last = *(volatile u32 *)(u32)RI_PRIMPTR;
    volatile u32 *arr = (volatile u32 *)*(volatile u32 *)(u32)RI_PRIMBASE;
    t = vold; vold = vnew; vnew = t; t = mold; mold = mnew; mnew = t; nold = nnew; nnew = 0;
    n = last >= (u32)arr ? (last - (u32)arr) / 0x14u + 1u : 0u;
    if (n > 128u) n = 0;
    for (k = 0; k < n && nnew < MAXE; k++) {
        u32 key = arr[k * 5u], st = pstride(key), cnt = (arr[k * 5u + 2u] >> 16) & 0xFFFFu, vp = arr[k * 5u + 3u], *m = mnew + nnew * 5u, ord;
        if (!st || !cnt || off + cnt * st > VWORDS || isdup(vp)) continue;
        ord = ordof(arr, k);
        copyw(vnew + off, (volatile u32 *)vp, cnt * st);
        m[0] = key; m[1] = ord; m[2] = off; m[3] = vp; m[4] = cnt * st;
        if (is30(key)) for (q = 0; q < nold; q++) if (mold[q * 5u] == key && mold[q * 5u + 1u] == ord) {
            mixv(vp, vnew + off, vold + mold[q * 5u + 2u], cnt, mold[q * 5u + 4u] / st, st);
            break;
        }
        for (q = 0; q < nxk; q += 2u) if (xk[q] == key && xk[q + 1u] == ord)       /* cross-faded: the original gets half alpha too */
            for (v = 0; v < cnt; v++) ((volatile u32 *)vp)[v * st + 1u] = half(((volatile u32 *)vp)[v * st + 1u]);
        off += cnt * st; nnew++;
    }
}
/* Cross-fade of sprite-sheet frames (type 6, word 0 = [u16 u, v], word 1 = colour): before the flush, for every 30 Hz entry
 * whose uv words differ from the previous update's, a copy with the OLD uv words and half alpha is pushed (positions mixed like
 * the original); the original gets half alpha after the flush (flushU). Alpha blending is only exact for additive batches. */
HI __attribute__((noinline)) static void preU(void) {
    u32 k, q, v, n, nd = 0, xo = 0, last = *(volatile u32 *)(u32)RI_PRIMPTR, e[5];
    volatile u32 *arr = (volatile u32 *)*(volatile u32 *)(u32)RI_PRIMBASE;
    nxk = 0;
    if (!xbuf || !ri_st[21]) return;
    n = last >= (u32)arr ? (last - (u32)arr) / 0x14u + 1u : 0u;
    if (n > 128u) return;
    for (k = 0; k < n && nd < 8u; k++) {
        u32 key = arr[k * 5u], cnt = (arr[k * 5u + 2u] >> 16) & 0xFFFFu, vp = arr[k * 5u + 3u], ord;
        if (((key >> 2) & 15u) != 6u || !cnt || xo + cnt * 5u > XWORDS || isdup(vp) || !is30(key)) continue;
        ord = ordof(arr, k);
        for (q = 0; q < nnew; q++) if (mnew[q * 5u] == key && mnew[q * 5u + 1u] == ord && mnew[q * 5u + 4u] == cnt * 5u) {
            const u32 *ov = vnew + mnew[q * 5u + 2u];
            u32 *d = xbuf + xo, chg = 0;
            for (v = 0; v < cnt && !chg; v++) if (ov[v * 5u] != ((volatile u32 *)vp)[v * 5u]) chg = 1;
            if (!chg) break;
            copyw(d, (volatile u32 *)vp, cnt * 5u);
            for (v = 0; v < cnt; v++) { d[v * 5u] = ov[v * 5u]; d[v * 5u + 1u] = half(d[v * 5u + 1u]); }
            mixv((u32)d, d, ov, cnt, cnt, 5u);
            e[0] = key; e[1] = arr[k * 5u + 1u]; e[2] = arr[k * 5u + 2u]; e[3] = (u32)d | (vp & 0xF0000000u); e[4] = arr[k * 5u + 4u];
            replay_from(e, 1);
            xk[nxk++] = key; xk[nxk++] = ord; xo += cnt * 5u; nd++;
            break;
        }
    }
}
HI __attribute__((noinline)) static void flushS(void) {
    u32 k, q, w, n, last = *(volatile u32 *)(u32)RI_PRIMPTR;
    volatile u32 *arr = (volatile u32 *)*(volatile u32 *)(u32)RI_PRIMBASE;
    n = last >= (u32)arr ? (last - (u32)arr) / 0x14u + 1u : 0u;
    if (n > 128u) n = 0;
    for (k = 0; k < n; k++) {
        u32 key = arr[k * 5u], st = pstride(key), ord = ordof(arr, k), cnt = (arr[k * 5u + 2u] >> 16) & 0xFFFFu;
        if (!st || isdup(arr[k * 5u + 3u])) continue;
        for (q = 0; q < nnew; q++) if (mnew[q * 5u] == key && mnew[q * 5u + 1u] == ord) {
            int same = mnew[q * 5u + 4u] == cnt * st;
            for (w = 0; same && w < cnt * st; w++) if (((volatile u32 *)arr[k * 5u + 3u])[w] != vnew[mnew[q * 5u + 2u] + w]) same = 0;
            set30(key, same);
            break;
        }
    }
}
HI void ri_flush(void) {
    if (ri_st[0] < 2u || ri_st[8] != 1u) { ((VoidFn)(u32)RI_FLUSH)(); return; }
    if (ri_st[1] == 0u) { punmix(); ((VoidFn)(u32)RI_FLUSH)(); flushS(); }
    else { preU(); ((VoidFn)(u32)RI_FLUSH)(); flushU(); }
}

int ri_particles(int a, int b, int c) {
    int r;
    u32 p0;
    int sk = ri_st[0] >= 1u && ri_st[1] == 0u;
    if (sk) { replay_from(wlist, wcount); return 0; }
    p0 = *(volatile u32 *)(u32)RI_PRIMPTR;
    r = ((WalkFn)(u32)RI_PARTICLES)(a, b, c);
    wcount = capture_to(p0, wlist);
    return r;
}

/* RI-v1j: the weapon update hook (ri_weapon, update frames only) was removed again for code size: it did not change the
 * flicker; the accepted `weapondt` word patch (tool) is used instead. */

