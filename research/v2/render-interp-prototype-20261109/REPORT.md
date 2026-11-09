---
kind: experiment
title: "RI-v1: gated pump 1 plus draw-side blending of moving records (Pokitaru, A0 savestate slot 4)"
date: 2026-11-09
authors: ["Claude (Sonnet 5.5)"]
status: draft
evidence: [OBSERVED, INFERRED, UNKNOWN]
summary: "First interpolation prototype that keeps logic at 30 Hz and blends record transforms only for display; displayed per-frame steps become uniform, visual acceptance and animation poses are open."
systems: [interpolation, timing, rendering]
levels: [Pokitaru]
variants: [A, B]
environment: "PPSSPP 1.20.4, savestate slot 4 (A0 words verified), rcp1 base 0x9139D00, no plugin of ours, FlamerGate resident (inert at the hooked sites)"
supersedes: []
related: [research/v2/render-interp-probe-20261109/REPORT.md, research/live-tests/pokitaru/session-2026-09-30/SESSION-LOG.md]
---

# What was built

`patches/experimental/render-interp/ri.c` (freestanding C, 2240 bytes) built by `build.py` for the live
base and written into the proven zero run 0x2C1818.. of LEVEL_01 by `tools/runtime/render-interp.py`.
Three `jal` redirects, no plugin:

- 0x15230 pump 1 only every second outer update, accumulated delta (the old G1 gate, in C).
- 0x15338 mode 2: before the real group pump 2, every live record (0x80-byte slots across all groups)
  that moved since the frame-start snapshot gets basis and position blended halfway (rows 0..2/4..6/8..10,
  position 12..14); jumps over 3 units and rotation steps over 0.8 are not blended.
- 0x13FB0 (call of 0x159DC): restore true values, take the frame-start snapshot, run the frame.
  Blended values therefore live only from pump 2 until the next frame start (draw reads them), logic never
  reads them. Plus the C1 core words (second vblank wait, delta 1/60, player substeps 1) as in pump-gate G1.
- Snapshot/backup memory: allocated once with the game's own sceKernelAllocPartitionMemory stub
  (EBOOT 0x883C3C0/0x883C3D0); 1516 slots, about 80 KB, never freed.

Runtime modes: 0 passthrough at 60 Hz, 1 gate only (old G1), 2 gate + blend. Counters via
`render-interp.py status`.

# Results (OBSERVED, 2026-11-09)

- Applied on the A0 savestate without error: alloc OK (init 1), runs/skips alternate (1429/1429), about
  62 frames per wall second, game kept running; 0-5 records blended per frame in this scene.
- Displayed step per frame, taken at the entry of the mesh draw function `FUN_000727D0` (count-calls,
  6000 stops, same method in each mode):
  - mode 1 (gate only): moving records step 0.0, 0.239, 0.0, 0.226, 0.0, ... (the known G1 judder).
  - mode 2: two slow records 0.05 and 0.055 on every frame; a third run 0.05 on every frame.
  Different records were moving in the two modes (scene moved on), so this shows the pattern, not a
  paired comparison.
- Visual smoothness, feel, and damage/collision behaviour: NOT assessed (owner needed).

# Safety check added (RI-v1b, OBSERVED)

Restore is now per word: a word is put back only if it still equals the blended value written; if
anything else wrote it between blend and restore the new value is kept and counter `others_wrote`
increments. Run on slot 4, mode 2: about 3000 frames (about 50 s wall) including about 20 s of scripted
walking (stick in five directions), 10584 records blended, `others_wrote` = 0, game running, no
debugger error. Same blob, rebuilt: remove (mode 0, wait, restore the A0 words, zero the cave) then apply
worked from the debugger. This covers only this scene and these inputs.

# RI-v1c: owner feedback and per-frame state hooks (2026-11-09)

Owner on RI-v1b: smooth, but flicker every second frame in lights and long-distance fog, and the camera
turned 2x too fast while the stick was held. GPU stats (`gpu.stats.get`, Draw/Vertices per frame) showed a
small element alternating by 1 draw / about 14 vertices in modes 1 and 2 but not in mode 0.
Static finding (local decompilation): the main update resets per-frame state at its start which only pump 1
callbacks refill, so skipped frames lose it.
- Fog: `FUN_00088768` (reset) vs `FogMoby_Update` -> `FUN_00088720` (registration). Hook `ri_fog` skips the reset
  on skipped frames.
- Light-influence list (flags 0x40/0x80 and tint +0x68 on records): reset by `FUN_00067D94`/`FUN_00068070`
  inside `FUN_000159A0`, each gated by "frame counter changed". Hook `ri_lights` sets both gate variables
  (0x2B29FC, 0x2B2A00) to the current counter on skipped frames.
- Camera: the five owner-accepted manual camera words from tools/runtime/fixes.py (1/30 -> 1/60 literals,
  incl. the two negative caps) are now written by `apply` (verified original first) and restored by `remove`.
Owner result: fog flicker fixed; lights first reported not fixed, then reported fine after review
(unclear which build state was meant; no further change made). Camera result not yet reported.
Not examined: the per-frame primitive buffer reset by `FUN_0008DC14` (candidate for other pump-1-built draw
state), only read, not hooked.

# RI-v1e (2026-11-09, owner feedback on RI-v1d)

Owner: weapon lights still flicker, weapon cadence still looks framerate-bound, and everything needing a button
press (triangle at the teleporter or the shop) does not work. Savestate note: owner slot 4 = file `_3` (RI-v1d runs
before this used file `_4` by mistake, see memory note).
- Input: the game reads the pad with a latch once per frame (`FUN_00075454`; make 0x36EE90, break 0x36EE94, stick-as-
  direction edge 0x2B2BE4). Pump 1 objects only run on every second frame and miss events of the skipped frame.
  `ri_pump1` now accumulates make/break/direction edges on skipped frames and shows `current | accumulated` to pump 1
  only on the next update frame, putting the current values back right after (player code keeps current values).
  uiRelease (+0xC) is a level and is not merged (first version merged it and counted a merge every frame).
  Counter `pad_merges` reached 73 in about 3300 frames while the owner played; owner result pending.
- Weapon cadence: `weapondt` (accepted, TESTED earlier in this project: Blaster 4.133 vs 4.134 shots/s) is applied:
  delay slot 0x2FCF4 `mov.s f12,f20` -> `add.s f12,f20,f20`, with the preceding branch rewritten for the JIT.
  The BlasterShot/RynoRocket pump-1 fixes of fixes.py are NOT applied: pump 1 runs at the original 30 Hz with the
  accumulated delta, so those objects keep A0 steps (INFERRED).
- Weapon lights: the frame scratch pool offsets (0x2B2D18/1C, reset by `FUN_0007D510` every frame, allocator
  `FUN_0007D60C` at 0x3874F8) are put back after the real call on skipped frames, so data allocated by pump 1
  objects (and pointed to by the restored deferred draw entries) is not overwritten. Counter `scratch_kept`.
  This is the hypothesis for the weapon lights; the pool size (0x2000 words) could fill up (not measured).
- Cave now uses the whole zero run 0x2C1818..0x2C281C (blob 3.4 KB). The neighbouring zero run at 0x2C30A8 is NOT
  free (code references its start and a pointer into it), do not use it.

# RI-v1f (2026-11-09, owner feedback on RI-v1e)

Owner: shop Triangle works; teleporter Triangle does not and its prompt flickers; weapon cadence looks fine (to be
checked on continuous-fire weapons); weapon lights still flicker.
Method added: `tools/runtime/parity-diff.py` stops at ri_frame on 14 consecutive frames, reads the LEVEL_01
.data/.bss (0x2DD108..0x46B830), and lists words constant X after every update frame and constant Y after every
skipped frame. First run (RI-v1e): 86 words, among them the primitive count 0x302F20 (5 vs 4, so one direct
primitive was still missing on skipped frames) and a text/ID value at 0x322B2C (non-zero after update frames, 0 after
skipped frames).
- Prompt: `FUN_000A4BDC` (called by pump 1 objects) sets request counter DAT_002BC6A4 = 2; the HUD manager
  `FUN_000A47B8` (single call site 0x9DEAC in `FUN_0009DDD0`, argument = latch make) decrements it each frame and
  closes the prompt at 0 (`FUN_000A4A54` also clears 0x322B2C), and clears the confirm flag DAT_002BC6BC at every call.
  With pump 1 on every second frame the prompt was closed and rebuilt every second frame and the confirm flag
  was cleared before pump 1 could read it. `ri_help` (hook at 0x9DEAC) runs it on update frames only and ORs the
  button events of skipped frames into the next call (the original 30 Hz outer update also ran it once per update).
- Direct draw entries: `FUN_0008DB74` pushes 5-word entries (array 0x302F1C, last-entry pointer 0x2DD330); those pushed
  during pump 1 are copied after the call and appended again on the next skipped frame (`prim_replays`), fixing
  the missing 5th primitive.
Result of parity-diff after this build: remaining parity words are double-buffer flags/pointers and +-0.0 floats only;
the primitive count no longer differs and 0x322B2C no longer differs. Heap-resident state was not scanned. Owner
result for the teleporter prompt and the weapon lights: pending.

# RI-v1g (2026-11-09, owner feedback on RI-v1f)

Owner: the teleporter now works; its animation runs twice as fast (1 s instead of 2 s); weapon lights still flicker
(Lacerators, rockets, maybe Bovinator).
- Teleporter animation: `teleporterfx` in fixes.py documents Teleporter particle effects with literal 1/30 steps per call,
  advanced by the particle walker `FUN_0008CC18` (once per frame after pump 2). In the RI design pump 1 objects
  already run at the original rate, so the remaining 2x source is the walker. `ri_particles` (hook at 0x15348) now
  runs it on update frames only and replays its draw entries on skipped frames (same mechanism as pump 1; entries
  captured after the call because the walker increments the vertex count of its last entry). Particles then move at
  30 Hz and are drawn every frame (no interpolation of their motion). Counter `particle_replays` stayed at 0 in the
  test scene (the walker pushed no direct entries there), so the replay path itself is untested.
- Weapon lights: not diagnosed further; parity-diff after this build shows only buffer toggles, parity flags and a
  16-float block at 0x304A40..0x304A78 that differs between parities (role UNKNOWN, possibly a double-buffered matrix).
  Needs an owner scene with the weapon firing (or an injected fire input) to capture parity words during the effect.

# RI-v1h (2026-11-09, owner feedback on RI-v1g)

Owner: teleporter fixed (animation "not perfect, felt designed for 30 fps"); halo, wall/enemy lighting and muzzle flash
of Lacerators, rockets and perhaps Bovinator still flicker.
Measurements with the Blaster firing found nothing: parity-diff over .data/.bss and segment 0 data (0x2A0000..0x46B830)
and over the 1162 records showed only double-buffer toggles, HUD counters (0x2C0E70/71) and the RI cave itself; GPU
draw/vertex counts per frame showed no parity alternation (score < 1 in 47 windows); `gpu.buffer.*` screenshots are not
available ("Could not download output"). `particle_replays` reached 5174 while the owner fired, so the particle replay
path does run.
Hypothesis (INFERRED, not shown): these effects are spawned by the player weapon update, which ran on every frame, while
the paths that draw them (pump 1 objects, particle walker) run on update frames only, so an effect spawned on a skipped
frame is first shown one frame later and short effects blink. `ri_weapon` (hook at the jal 0x2FCF0, target read from
the module) now runs `P_Player_WeaponUpdate` on update frames only with (dt + accumulated dt) x 2 (A0: two calls of the
full frame delta per 30 Hz frame; this replaces the `weapondt` word) and shows it the button events of skipped frames.
Mode 0 keeps the original per-frame call. Cadence effect untested. Blob 3944 bytes of 4100 (integer exponent test instead
of float compares to fit).

# RI-v1i (2026-11-09, owner feedback on RI-v1h)

Owner: weapon lights (halo, wall/enemy lighting, muzzle flash of Lacerators, rockets, perhaps Bovinator) still flicker after
RI-v1h, so the "effects spawned on skipped frames" hypothesis is not the (only) cause (RI-v1h kept, effect unmeasured).
More captures (parity-diff over 0x2A0000..0x46B830 and per-record live-flag/flag-word parity over the 1162 slots) while the
owner fired and while an injected `circle` hold fired (circle = fire, 39 particle replays in 1.5 s; NOTE: `input.buttons.send`
with `{}` does not release buttons, release by sending each button false): no new parity word, no slot alive only after one
frame type, per-frame item pool (`0x2B2D18/1C`) used only 80/288 words of 8192.
Static finding: `FUN_00090118`/`FUN_00090214` (callers include weapon-area classes 0x12CDEC, 0x16EAB4, 0x174738, 0x17AFCC,
0x1963B4, 0x6681C) allocate 0x20/0x28-byte draw items from a second per-frame pool (bytes left 0x2DD338, next item
0x2DD33C, area from 0x303DCC), reset to 0x800 bytes by `FUN_0008DC14` together with a node free list and an id table
(0x303B48..0x303DCC). Those items are pointed to by the deferred draw entries that RI restores on skipped frames, but the
reset made later allocations overwrite them (and returned their nodes to the free list). `ri_prim` now also saves and puts
back that block (161 words) and the two pool words around the real reset on skipped frames. Hypothesis only; no measurement
shows these items are the flickering lights. Blob 4068 bytes of 4100.

# RI-v1j (2026-11-09): crash, safer remove, RNG measurement

CRASH (my error, owner reported "le jeu vient de planter"): while replacing the weapon hook (`ri_weapon`, call 0x2FCF0)
by the old `weapondt` word, `remove` of the new tool no longer restored 0x2FCF0 and zeroed the cave, so the game called
into zeroed memory (PC left in the cave, CPU stopped). Recovery: reload owner slot 4 (file `_3`) and re-apply.
Fix: `apply` records the original word of every site (`tmp/render-interp-last.json` field `originals`), `remove` restores
exactly those, then refuses to zero the cave while any `jal` in 0x1517C..0x15400 or at 0x2FCF0/0x9DEAC/0x13FB0 still
points into it.
Removed for size/no effect: `ri_weapon` (weapon update on update frames only; `weapondt` word again) and `ri_scratch`.
Added: `ri_flush` (hook at the call of `FUN_0008E2D4`, RVA 0x15350) measuring rand() use (newlib state at
*(0x2DB90C)+0x58, changes every frame) in the deferred draw callbacks, with runtime switch `ri_st[22]` that replays the
previous update frame's generator state on skipped frames. Measured while firing (circle held, 360 frames): the flush
consumed no random numbers (update frames 0, skipped frames 0), so rand() in the flush is NOT the cause of the weapon-light
flicker. Blob 3980 bytes of 4100.
Open question for the owner (A/B in mode 0): does the flicker also exist in plain mode 0 (60 Hz, no gating, no blending)?

# RI-v1k bisect result (owner-observed, 2026-11-09)

Owner: weapon-light flicker is present in mode 1 as well as mode 2 and absent in mode 0 (60 Hz, no gating; projectiles are
then twice too fast, as expected for the uncorrected 60 Hz state). `bisect-cycle.py` (fire held, 20 s per step, beeps =
step number, ammo refilled each step with set-ammo.py after the Blaster stock had run out in the first attempt, whose early
steps are void): flicker on steps 1-5 (all hooks on; particle gating off; deferred list + pump-1 replay off; fog + light
gates off; every maskable hook off), none in step 6 (mode 0). Owner's impression, not a measurement.
Reading (INFERRED): the cause is the pump 1 half-rate gating itself plus something not covered by the maskable hooks, not
the blending, the list restores, the walker gating, the help gating or the pad merge. Not maskable and therefore untested:
`weapondt`, the C1 core words and camera words (also in mode 0, so unlikely), the frame-start restore/snapshot (no effect in
mode 1) and the flush probe (no effect with the switch off).
Candidate next design (not started): run pump 1 on every frame as in mode 0 but skip the entity callbacks (per-record call at
0x6B9B8) of classes that are safe at 30 Hz, and run weapon, projectile and light classes every frame with the existing
accepted per-class fixes (e.g. BlasterShot speed/life words, RynoRocket words in tools/runtime/fixes.py), so effects spawned
and drawn by those classes keep a 60 Hz update. Cost: a class table and the per-call policy hook; risk: pump 1's per-record
state machine then runs at 60 Hz.

# RI-v1l hybrid pump 1 (2026-11-09, started after the bisect)

Design now used for every mode >= 1 (the old "skip the whole pump 1" path was removed to fit the cave): group pump 1 runs on
every frame; the entity callback call (`jalr a1` at 0x6B9B8, a0 set in its delay slot, f12 = delta) is redirected to
`ri_entity`. Classes whose update address is in `ri_cls[8]` run every frame at 60 Hz; all other classes run only on update
frames with the accumulated delta. What a skipped 30 Hz callback would have registered is captured on update frames
around each callback (pump 2 callback list 0x2E0C30, draw callback list 0x2E0CF4, list 0x2E0DB8, deferred draw list 0x303144,
direct draw entries) and appended again after pump 1 on skipped frames. Code is split in two caves: main 0x2C1818 (3656 B)
and 0x2B7700 (800 B, zero padding before the first pointer into that run at 0x2B7B2C, same plausibility level as the
first cave). `render-interp.py cls --rvas ...` sets the 60 Hz classes, `bshot 1|0` applies the accepted BlasterShot
speed/life words (0x117B70, 0x118178; objects that run at 60 Hz). Untested by the owner when written: with the table
empty this replaces the earlier G1 behaviour (pump 1's per-record state machine, group callbacks and 0x6DF94 fade ramps
now run at 60 Hz; the fade ramps use a 1/30 literal and are 2x fast, unfixed).
Test started: classes at 60 Hz = BlasterShot (0x118130) with its two words, Blaster equipped, ammo 10000.

# Switches (command line, owner decision 2026-11-09: no button combo)

- `python tools/runtime/render-interp.py mode 0` : 60 Hz without gating or blending (pump 1 and everything else every frame;
  BlasterShot words stay applied, they are right for a 60 Hz pump 1); `mode 2` : hybrid pump 1 + blending; `mode 1` : hybrid
  without blending.
- `cls --rvas 0x118130,...` : classes that run at 60 Hz in the hybrid; `bshot 1|0` : BlasterShot 60 Hz words.
- `remove` : back to the original 30 fps state (every site word restored from the originals recorded at apply, caves zeroed,
  memory block released). A button combo that tried to do this in game was written and dropped.

# Weapon classes at 60 Hz (2026-11-09)

Owner naming (docs/WEAPONS_PARITY, research/v2/weapons-oc60-20261008): "Lacerators" = the Blaster (weapon 2, shots =
BlasterShot 0x118130), rockets = Ryno (weapon 15, RynoRocket 0x169698), Bovinator = Mootator (id 12, not added).
`cls --rvas 0x118130,0x169698` plus `bshot 1` and `ryno 1` (accepted rynorocket words of fixes.py: speed 0x2D6A94, life
0x2D6B94, four homing turn caps 0x2D6B80..8C; they assume a 60 Hz rocket) put both projectile classes at 60 Hz. The Blaster
and Ryno weapon objects themselves (0x116A00, 0x168C28) and the Ryno random wobble kicks are not in the table. Visual
result pending. Ammo for weapons 2 and 15 set to 10000 (test aid).

# Particle vertex mixing (2026-11-09)

Owner: Ryno rocket trails and the Static Barrier animation still look 30 fps (particles update at 30 Hz with the walker, which
runs on update frames only). Live sample of the walker's draw entries while firing: entry words = {key, ., index | count<<16,
vertex pointer (0x49... uncached mirror), .}, vertex stride from the table at 0x2B66B0 by type = (key >> 2) & 15: type 1
stride 16 (screen-space, 16-bit positions: not touched), type 6 stride 20 ([u16 u,v][color][float x,y,z]), type 8 stride 24
([float u,v][color][float x,y,z]); strides of types 2-5, 7, 9-15 not sampled (type 7 assumed like 6, untested).
`pmix` (update frame, after the walker): copies the true vertices of types 6-8 (16 KB buffer, 16 entries), and when the previous
update had the same key and vertex count at the same entry index, writes the mean of old and new position into the live
vertices (per axis only if it moved < 4 units); `punmix` (skipped frame) writes the true values back before the entries are
replayed. So updates show N-0.5 and the skipped frame N, as for objects. Births/deaths change the count and disable the mix
for that entry. Memory block grows to about 110 KB; the 16-entry cap, the 16 KB buffer and the index matching are untested
limits. Code now fills both caves (main 4076/4100 B, second 976/1064 B); `ri_prim` lost its dead deferred-list save (hybrid mode
captures it per callback). Counters 14 and 20 were removed. Owner result pending.

# Vanilla / mode 1 / mode 2 particle comparison (2026-11-09, owner: "artifacts / same")

`tools/runtime/particle-sample.py` stops at the entry of the flush `FUN_0008E2D4` (once per frame, also in A0), reads the
pending direct draw entries and logs, for types 6-8, vertex count and centroid; 160 consecutive frames per state, fire held
(circle) on the equipped weapon (not controlled). Median frame time 33.3 ms in A0 and about 14 ms in modes 1 and 2.
Result is NOT a clean A/B: the three runs show different particle sets (different counts and speeds), the same key appears
twice per frame in places (my matching by key and count then mixes entries), and the fire state differed. What it does show
for the largest world batch (type 8, key 0x50412061, 122-144 vertices): in mode 2 its centroid steps alternate 0 / small
(0.0, 0.032, 0.0, 0.028, ...) and its vertex count changes between consecutive updates (124, 122, 124...), i.e. the position mix
does not apply on most updates because `pmix` requires the same count at the same index as the previous update. So the mix
is mostly inactive on particle batches that gain or lose particles. A nearest-neighbour match would be needed (code space
in both caves is exhausted, so it would need a third location, e.g. code copied into the heap block). The owner's remark that
the remaining 30 fps look may come from smoke "animations" is consistent with this and with the walker design: sprite frame,
alpha and size also change only at the 30 Hz walker update and are not mixed at all (UNKNOWN which type holds them).

# RI-v1m nearest-neighbour particle mix (2026-11-09)

`pmix` no longer needs the same vertex count: for each entry with the same key as the previous update's entry at the same
index, every new vertex is mixed with its nearest old vertex of that entry (the vertex with the same index first when closer
than 0.5 units, otherwise a full scan; match radius 4 units, mixed position = mean). Second cave extended to 0x2B7700..0x2B8100
(it was an 18 KB zero run with no pointer into it found: the four word hits in the module are numbers inside other tables; code
references only at both ends; still the same "probably unused padding" assumption as the other caves). Blob 4076 + 1236 bytes.
Live check (fire held 8 s, 475 frames, 59 fps): 493798 particle vertices seen, 488731 got a neighbour (99%, includes static
particles whose distance is zero). Visual result pending. Counters: `particle_vertices_seen` / `particle_vertices_mixed`.

# RI-v1n mix of every world-space draw entry (2026-11-09, owner: trails and barrier particles still 30 fps)

`tools/runtime/particle-who.py` (stop right after the flush call, 0x15358, so the final entries after any RI mixing are
seen; 240 frames, fire held on the equipped weapon) lists per entry key the share of frames with zero centroid movement.
Before: the walker batch type 8 (0x50412061, 144 vertices) 0.0 (already smooth with the index-based mix), but a 6-vertex
type 6 entry that is NOT a walker entry (0x5027f019, a sprite quad from the deferred draw callbacks / pump 1 objects) 0.50
(strict alternation, the 30 fps look; longest zero run 1). The earlier sampler stopped at the flush entry and could not see
entries created inside the flush or any post-flush mixing; its A/B was therefore incomplete.
Change: the mixing moved to a hook after the flush (`ri_flush`, call at 0x15350): every direct draw entry of types 6, 7, 8 is
saved on update frames and, if it is "30 Hz" (its vertices on a skipped frame equal the previous update's: learned per key
each skipped frame, so 60 Hz entries are never mixed), drawn at the mean of the nearest old vertex and the new one; true
values are written back before the next skipped frame's flush. Result with the same sampler: 0x5027f019 0.50 -> 0.00,
0x50412061 0.00 (kept), two nearly static type 6 batches 0.07 and 0.67 (mean step 0.002, no visible motion).
Limits: types other than 6-8 (HUD type 1, strides 10-16) are not touched; sprite frame, alpha and size are not mixed; entries
beyond 24 per frame or 16K words are skipped. Caves: main 4012/4100 B, second 2244/2560 B. Visual result pending.

# Owner: still 30 fps after RI-v1n; `draw-who.py` finding (2026-11-09)

Owner: trails and the particles around the barrier still look 30 fps. `tools/runtime/draw-who.py` (all vertex types, raw vertex
bytes hashed per entry, 200 frames, circle held on the weapon equipped at that moment, Ryno and barrier NOT equipped) shows
the world-space entries (types 6, 8) now smooth (identical share 0.00-0.01) but several **type 1** entries (stride 16:
[u16 u,v][color][s16 x,y][z]: screen-space "through mode" sprites, 2 vertices per sprite) alternate strictly between changed and
identical frames (alternation 0.68-0.92; e.g. key 0xA05F3204 764 vertices, 0xC04F1105 108, 0xA88630C4 6, 0xA8387044 2).
Candidates for the owner's effects (screen-space particle sprites or HUD pieces); not confirmed: it is unknown whether the Ryno
trail or the barrier particles use them. The type 1 entries are not mixed (RI mixes types 6-8 only). Needs a capture with
the Ryno / barrier effect on screen.

# RI-v1o: Ryno/barrier capture, buffer size, second crash (2026-11-09)

Capture with the owner's Ryno or barrier equipped (circle held): besides the type 1 screen-space sprites a **type 6 world entry
with 684 vertices** (key 0x882670D9, all 300 frames) alternated strictly (identical share 0.5, alternation 1.0) although RI mixes
type 6: the mix buffer (16 KB) was already full of other entries, so it was skipped. Buffer doubled (VWORDS 0x2000 = 32 KB each
for old/new; block about 190 KB); not yet re-measured on that effect.
CRASH 2 (second `remove` crash): `remove` paused the CPU at an arbitrary place, restored the hooks and zeroed the caves; when the
pause fell inside a call that had entered through a hook, its return address pointed into the cave (zeros) and the game stopped
at the cave. Fix: `remove` now restores the hook words, resumes for 1.5 s so in-flight calls complete, then pauses again, refuses
to zero if the PC is inside a cave, and clears the caves. Applying over a running game is not affected.
Recovery: owner slot 4 (file `_3`) reloaded and `ri-hybrid.py on`.

# RI-v1p type 1 sprites (2026-11-09)

Re-measured after the buffer doubling (draw-who, 300 frames, circle held, weapon equipped at that moment): the 684-vertex type 6
entry 0x882670D9 is now smooth (alternation 0.00). Remaining strict alternation came from type 1 entries (screen-space sprites,
16-byte vertices, word 2 = s16 x | s16 y << 16): 0xC04F1105 0.87, 0xC04F1104 0.86, 0xA88630C4 0.92, 0xA8387044 0.85, 0xA0873204 0.62.
Type 1 is now mixed too (nearest old vertex by pixel distance, same index first when within 2 px, radius 24 px, mean of the two
positions; colours and texture coordinates untouched): alternation 0.44, 0.13, 0.15, 0.22, 0.13. Two short-lived entries
(0xA05F3204 656 vertices, 0xB82A7045 / 0xB8387045, 18 frames each) still alternate (0.86, 0.67): too short to be learned as 30 Hz
or their vertex count changes every frame. Caves: main 4076/4100, second 2476/2560 B. Whether type 1 entries are the owner's
trails / barrier particles or HUD pieces is still not shown. Owner result pending.

# Sprite frames confirmed at 30 Hz (2026-11-09, owner hypothesis: smoke = pre-animated sprites with fixed duration)

Measured on 200 consecutive frames (stop after the flush call, circle held): for the three type 6 batches (684, 96 and 480
vertices; word 0 = [u16 u, u16 v]) the texture-coordinate word of a vertex changes on exactly 50% of the frames with strict
alternation (1.00), i.e. a sprite-sheet frame advance at every update frame, never in between; the colour word (alpha fade)
changes on 7-9% of the vertices, also strictly every other frame. The type 8 batch (float uv) and the single quad
0x5027F019 do not change uv. So the positions and sizes are now mixed (smooth) but the sprite frames themselves still change at
30 Hz. Interpolating them is not a numeric mix: it would need a cross-fade (a second quad with the old frame and half alpha at
the update frame, order and blend mode of the batch unknown) and is not implemented. A colour/alpha mix (per byte of the
colour word, nearest-vertex match as for positions) would cover the fades only (7-9% of the vertices).

# RI-v1q sprite cross-fade, experimental (2026-11-09, owner asked to try)

Switch: `ri-hybrid.py xfade1|xfade0` (`render-interp.py xfade 1|0`, state word ri_st[21]); `ri-hybrid.py on` leaves it OFF (owner: it brought flicker back).
Mechanism (type 6 entries only, i.e. word 0 = [u16 u, u16 v], word 1 = colour): `preU` (before the flush, update frames) looks at every
30 Hz entry (same key and ordinal as in the previous update, same vertex count) whose uv words differ from the previous update's;
for it, a copy with the OLD uv words, half alpha and positions mixed like the original is pushed as an extra draw entry (up to 8
per frame, 32 KB buffer, entries tagged by their vertex address so they are ignored by the matching code); `flushU` then halves
the original's alpha. The skipped frame writes the true values back (existing `punmix`). Intended result: an update frame shows
old and new sprite frame at half weight, the skipped frame the new frame. Exact only for additive blending; with src-alpha blending
the update frame is a little more opaque/translucent than the skipped one (possible new brightness alternation: UNKNOWN, owner to
judge, switch off if worse). Second cave extended to 0x2B7700..0x2B9000 (3956 of 6400 B used), main 4048/4100. Ran 240 frames with
fire held without error; no visual check by me. Entry ordering after the flush's sort for the extra entries is not verified.

# RI-v1r cost (2026-11-09, owner: "it tanks the framerate")

Measured (fire held, 8 s each, `gpu.stats.get` fps and RI frame counter): mode 0 60.0 frames/s; mode 2 without cross-fade 45.5;
with cross-fade 43.7 (PPSSPP fps dips to 11). The mixing, not the cross-fade, cost about 25%: the nearest-vertex search did a full
scan per new vertex (a 684-vertex batch: about 468 K distance evaluations per update). The search now looks only at old vertices
within +-16 indices of the new vertex (after the same-index fast path). Re-measured: mode 2 with cross-fade 59.9, without 59.9,
mode 0 59.9. Smoothness re-checked with draw-who (see below in this section if lines changed). Particles reordered by more than
16 slots between two updates (swap-removal after many deaths) are no longer matched.

# Known limits / UNKNOWN

- Animation poses (limbs of skinned characters) are not blended. Whether they judder is UNKNOWN: the
  animation channel advance (callers around 0x785B8..0x78658, with delta 1/60 after the C1 core words) is
  probably called outside pump 1, i.e. at 60 Hz (INFERRED from older notes, not verified here).
- G1 side effects remain: Blaster cooldown longer, everything inside pump 1 at logic-rate granularity.
- Player and other per-frame records get a constant half-frame display lag (INFERRED from the design).
- Particles, camera and HUD are not touched (camera runs at 60 Hz already in this setup).
- Records that appear/disappear between snapshot and blend are handled only by the jump threshold.
- Not run: A/B/C numeric parity; no claim of gameplay parity.

# Re-run

python tools/runtime/render-interp.py apply --mode 2 | mode 0|1|2 | status | remove
(requires the A0 word state at the sites and a zero cave; remove sets mode 0, waits, restores A0 words).
