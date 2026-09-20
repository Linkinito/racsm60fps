# Ghidra timing reconstruction checkpoint — 2026-09-20

## Scope

This note records the main timing findings obtained from the first targeted Ghidra decompilation pass on the vanilla UCES00420 `LEVEL_01.PRX` (Pokitaru).

This is a research checkpoint, not a validated patch specification.

Evidence vocabulary follows `docs/methodology/EVIDENCE_LEVELS.md`.

## Context

The V2 investigation began from a historical four-part 60 FPS socle:

1. remove the conditional second VBlank wait;
2. change a shared frame delta from approximately `1/30` to `1/60`;
3. reduce a player inner loop from two iterations to one;
4. double the local player scalar at `0x2FBBC`.

The Ghidra pass clarifies why this historical combination fixed many behaviors while remaining non-universal.

---

## 1. Shared frame delta fan-out

### Function

- RVA `0x1517C`
- tentative name: `FrameUpdate_SharedDelta`

### Decompiler observation

Ghidra constant-propagates the same `0x3D088889` value to four calls:

- `FUN_00087A84(0x3D088889)`
- `FUN_0006B7F4(0x3D088889)`
- `FUN_0002FFF0(0x3D088889)`
- `FUN_0006B618(0x3D088889)`

The assembly establishes that this is one constructed float retained in `f20`, not four independent constant builders.

### Interpretation

`0x3D088889` is approximately `1/30`. The historical B1 edit changes the shared frame delta to approximately `1/60`.

Status:

- shared construction and four-way fan-out: `OBSERVED`
- semantics of all four consumers: still incomplete

---

## 2. Player outer update and two-pass inner simulation

### Function

- RVA `0x2FB8C`
- tentative name: `Player_UpdateOuter`

### Relevant decompiler structure

On the main branch where `player+0x95C & 0x8000` is set:

```c
substep = 0;
do {
    DAT_002B0208 = substep == 0;

    FUN_000353A4(player);
    FUN_00032004(player);
    FUN_0003BFF8(player);
    FUN_0003C88C(player);
    FUN_00032888(player);
    FUN_00039B74(dt, player);
    FUN_0001EBC4(dt, player);

    substep++;
} while (substep < 2);

DAT_002B0208 = 1;
```

`Player_UpdateTimingFields(dt, player)` at `0x360A4` runs before this loop.

### Consequences

The vanilla main path has:

- one outer update;
- one timing-fields update;
- two inner player passes.

The module-local flag `0x2B0208` has the sequence:

- first pass: `1`;
- second pass: `0`;
- post-loop: `1`.

Preferred description: `not-second-substep / first-or-post-loop gate`.

Status: `OBSERVED`.

---

## 3. Player timing fields are genuinely delta-driven

### Function

- RVA `0x360A4`
- name used in Ghidra: `Player_UpdateTimingFields`

### Decompiled behavior

```c
player->field_56C = dt;
player->field_570 = fmod_like(player->field_570, 0.0166669991f) + dt;
player->field_574 += dt;
player->field_578 = dt * 30.0f;
player->field_584 += dt;
player->field_588 += dt;
player->field_58C += dt;

if (state == 0 || state == 1 || state == 0x24)
    player->field_580 += dt;
else
    player->field_57C += dt;
```

### Important correction to the historical D socle

The historical local edit at `0x2FBBC` turns:

```asm
mov.s f20,f12
```

into:

```asm
add.s f20,f12,f12
```

If B1 already changed the incoming delta to `1/60`, this restores `f20` to `1/30` before `Player_UpdateTimingFields`.

If the outer cadence is actually 60 Hz, accumulators such as `+0x574`, `+0x584`, `+0x588`, `+0x58C`, `+0x57C/+0x580` would then integrate approximately twice as fast in wall time.

Therefore the historical local `x2` is too early for a clean split-domain design.

Status:

- function semantics: `OBSERVED`
- 60 Hz wall-time consequence: `INFERRED` pending A0/B0 outer-cadence measurement

---

## 4. `field_578 = dt * 30` is a normalized frame-step, not a generic timer

### Producer

`Player_UpdateTimingFields` writes:

```c
player->field_578 = dt * 30.0f;
```

### Consumer A — RVA `0x328A0`

The decompiler shows:

```c
dx = current_x - previous_x;
dy = current_y - previous_y;
dz = current_z - previous_z;

if (player->field_578 > 0.0f) {
    inv = 1.0f / player->field_578;
    player->field_28C = dx * inv;
    player->field_290 = dy * inv;
    player->field_294 = dz * inv;
}
```

This strongly indicates that `+0x578` normalizes per-update displacement to a 30 Hz reference step.

At 30 Hz:

- `dt = 1/30`;
- `dt*30 = 1`.

At 60 Hz:

- `dt = 1/60`;
- `dt*30 = 0.5`.

A half-sized displacement divided by `0.5` preserves the normalized velocity.

### Important rejected patch idea

A prior candidate idea was to globally change `dt*30` to `dt*60` so that `+0x578` stayed equal to `1.0` at 60 Hz.

`0x328A0` provides strong counter-evidence. Such a global change would likely halve the normalized velocity estimate.

Therefore:

> Do not globally force `player+0x578` to `1.0` at 60 Hz.

Status:

- normalization use in `0x328A0`: `OBSERVED`
- global `x60` producer fix: `REJECTED` as a general correction

---

## 5. The same normalized field is also reused by timer-like logic

### Consumer B — RVA `0x42C04`

This function manipulates `player+0x9D4` and `player+0x9D8`, both initialized to `10.0f` in several branches.

Some branches use:

```c
timer -= player->field_578;
```

while another branch uses:

```c
timer -= 1.0f;
```

In vanilla, `field_578 == 1.0`, so both forms have the same per-call magnitude.

With a true `1/60` outer delta and a one-pass player loop, `field_578 == 0.5`. The `field_578` branches would then decrement half as much per call while the literal `-1.0` branch would not.

This means the producer cannot be corrected globally without harming the velocity-normalization consumer. Timer-like consumers must be evaluated locally.

Suggested taxonomy split:

- `N-VEL`: normalized-step consumers where `0.5` at 60 Hz is likely correct;
- `N-TIMER`: consumers reusing the normalized step as a countdown magnitude and potentially requiring local compensation.

Status:

- mixed use: `OBSERVED`
- exact gameplay semantics of `+0x9D4/+0x9D8`: `UNKNOWN`

---

## 6. `0x39B74` contains several timing domains at once

### Function

- RVA `0x39B74`
- tentative name: `Player_Substep_39B74`

Within one player-substep function, Ghidra exposes all of the following:

1. consumers of `player+0x578`, including `0x42C04` and `0x328A0`;
2. an explicit incoming-delta consumer:
   - `FUN_00032588(dt, player)`;
3. pure per-call counters:
   - `player+0x2B4 += 1.0f`;
   - `player+0x97C -= 1`;
   - `player+0xA1C += 1.0f` in a state-dependent path;
4. hard-coded `1/60` calls:
   - `FUN_00016388(0x3C888889, ...)`;
   - `FUN_00016188(0x3C888889, ...)`;
5. a hard-coded `-1/30` expression:
   - `player+0xF7C = DAT_002B012C * -0.033333335f`.

This is direct evidence that a single update function mixes multiple timing semantics.

Status: `OBSERVED`.

---

## 7. `0x32588` proves one important incoming-delta contract

### Function

- RVA `0x32588`

### Decompiled behavior

The function subtracts the incoming float from:

- `player+0xA00`;
- `player+0xA08`;
- `player+0xA0C`;
- `player+0xA14`;
- `player+0xA18`;

and clamps several values to zero.

This is a clear delta-countdown family.

Under the vanilla two-pass model:

- about 60 substep calls per second;
- each call receives approximately `1/30`.

If a future 60 FPS design uses one player substep per outer frame, the substep call rate can remain approximately 60/s. To preserve the vanilla progression of these fields, `0x32588` still needs an A0-equivalent `1/30` input rather than `1/60`.

This strongly supports a split where the outer player timing path sees the true `1/60`, but selected substep consumers receive a locally reconstructed `1/30`.

Status:

- countdown behavior: `OBSERVED`
- exact 60 FPS correction: `INFERRED`, pending A0/B0/B1 runtime measurement

---

## 8. Weapon manager callback contract is now clear

### Function

- RVA `0x1EBC4`
- strong tentative name: `Player_WeaponUpdate`

The function contains the source strings:

- `WEAPON_Update`
- `Could not create selected weapon`

Near RVA `0x1F27C..0x1F2D4`, the current weapon callback path is:

```asm
lw    a0,0x59C(s0)       ; current weapon object
lw    a1,0x40(a0)
lw    a1,0x1C(a1)        ; update callback
...
jalr  a1
mov.s f12,f20
```

Logical callback contract:

- `a0` = current weapon object;
- `f12` = the manager's current scalar/delta.

Individual weapon callbacks may ignore `f12`.

Status: `OBSERVED`.

---

## 9. Flamethrower update is strongly per-call oriented

### Main callback

- RVA `0x13B8F0`
- tentative name: `Flamethrower_Update`

While active it increments several float counters by `1.0f`, compares one against a threshold, and conditionally consumes ammunition/state.

It calls `0x13BBEC`.

### Emitter/helper `0x13BBEC`

This helper contains a global countdown:

```c
DAT_002D1AFC -= 1.0f;
if (DAT_002D1AFC <= 0.0f) {
    DAT_002D1AFC = DAT_002D1AF8;
    ...
}
```

It also performs repeated pseudo-random sampling and creates effect objects.

A historical `3 -> 6` patch site belongs to:

```c
random_result % 3 != 0
```

not to a deterministic `frame_counter % 3`.

Therefore the old description "one event every three frames changed to every six frames" is superseded.

### Created effect callback

`0x13B5F8` creates an object and assigns:

```c
object->callback = FUN_0013B20C;
```

`0x13B20C` updates positions, trajectory-like values, life/fade countdowns, color/alpha-like fields, and destroys the object on expiry.

Tentative name:

- `FlamethrowerEffect_Update`

The `%3` result selects a variant/index passed into the object creation path. The exact causal relationship between `%3 -> %6` and historical doubled Burner damage remains unknown.

Status:

- per-call counters and random modulo: `OBSERVED`
- direct damage semantics of `%3`: `REJECTED` as previously assumed
- causal relationship to historical damage fix: `UNKNOWN`

---

## 10. LaserTracer has its own local 30/60-aware timing subsystem

### Progression caveat

LaserTracer is a late-game weapon. It is active in the current Pokitaru save only because it was unlocked via a memory cheat. Its code exists in `LEVEL_01.PRX`, but active Pokitaru runtime observations involving LaserTracer are not representative of normal vanilla progression.

### Descriptor and update

The descriptor identifies:

- name: `LaserTracer`;
- source path containing `LaserTracer.cpp`;
- callback around RVA `0x148CEC`, strongly identified as `LaserTracer_Update`.

### Local rate variable

Raw data at `DAT_002D2C04`:

```text
00 00 F0 41
```

which is little-endian `0x41F00000 = 30.0f`.

Only one direct XRef reads this value, from the timing initializer.

No code writer has been identified.

### Timing initializer

- RVA `0x14CA70`
- tentative name: `TracerTiming_Init`

Ghidra initially did not disassemble this region automatically.
Manual disassembly reveals a valid function.

Decompiler result includes:

```c
dt = 1.0f / rate;
rate_copy = rate;

...
coef20 = dt * 20.0f;

if (rate == 60.0f)
    damping20 = 0x3F376E98;
else
    damping20 = 0x3F036F4E;

...
coef40 = dt * 40.0f;

if (rate == 60.0f)
    damping40 = 0x3F036F4E;
else
    damping40 = 0x3E86F633;
```

The hard-coded values match exponential damping-style coefficients:

- `0x3F376E98` ≈ `exp(-20/60)`;
- `0x3F036F4E` ≈ `exp(-20/30)` and `exp(-40/60)`;
- `0x3E86F633` ≈ `exp(-40/30)`.

This is strong evidence that the subsystem was explicitly authored to support both 30 and 60 update rates.

### Indirect initialization

No direct `jal 0x14CA70` was found.

A raw pointer to `0x0014CA70` exists once at:

- `0x002DD1F8`

This strongly suggests indirect invocation through a data table / initialization table, pending table-owner reconstruction.

### Scope of the subsystem

XRefs to derived timing constants are concentrated in functions around approximately:

- `0x145xxx`;
- `0x146xxx`;
- `0x147xxx`;
- `0x148xxx`;
- `0x14Bxxx`;
- `0x14Cxxx`.

This region overlaps the identified LaserTracer implementation and its helpers.

Therefore the previous hypothesis that `DAT_002D2C04` is a game-wide master clock is superseded.

Preferred interpretation:

> local LaserTracer/tracer-family configurable update-rate subsystem.

Status:

- static rate=30 and explicit 30/60 branch: `OBSERVED`;
- local-subsystem scope: `CORROBORATED` by XRef geography;
- whole-game master-clock interpretation: `SUPERSEDED`.

---

## 11. Four consecutive per-tier configuration blocks

The initializer writes the same derived `dt * 12` value to:

- `0x2D360C`;
- `0x2D385C`;
- `0x2D3AAC`;
- `0x2D3CFC`.

Each address differs by exactly `0x250`.

LaserTracer code selects:

```c
config = &DAT_002D360C + min(index,3) * 0x250;
```

This strongly suggests:

```c
TracerConfig configs[4];
```

with four records of size `0x250`, likely corresponding to weapon tiers/variants or another four-way configuration dimension.

Exact semantic identity remains to be established.

Status: `CORROBORATED`.

---

## 12. Revised timing taxonomy

The earlier timing taxonomy remains useful but should be refined.

### O — outer explicit delta

True time-like delta consumers that integrate an outer-frame scalar.

### S — logical substep domain

Systems whose vanilla call count depends on the two-pass player loop.

### D — explicit delta within substeps

Example: `0x32588`.

### N-VEL — normalized frame-step used for velocity normalization

Example: `0x328A0` using `dt*30`.

### N-TIMER — normalized frame-step reused as countdown magnitude

Example: parts of `0x42C04`.

### C — pure per-call work

Examples: `+1`, `-1`, fixed amount per callback.

### F30 / F60 — hard-coded fixed step

Explicit `1/30`, `1/60`, `-1/30`, etc.

### R — local configurable rate-aware subsystem

Example: LaserTracer/tracer timing with explicit `rate == 60`.

### E — event/state-gated

Call rate or effect depends primarily on state/event transitions.

### V — VBlank / frame synchronization

Frame limiter and display synchronization.

### H — wrapper / call-composition

Call graph structure changes effective invocation count.

### U — unresolved

No timing semantics established yet.

---

## 13. Current patch-design implication

A cleaner candidate design is now:

1. unlock the outer frame limiter;
2. use a true shared `1/60` outer delta where appropriate;
3. reduce the vanilla two-pass player loop to one pass if runtime cadence confirms the outer rate doubled;
4. keep outer timing fields on the true `1/60`;
5. reconstruct A0-equivalent `1/30` only for selected substep delta consumers such as the path feeding `0x32588`;
6. preserve `player+0x578 = dt*30` globally, because `0x328A0` needs the real normalized half-step at 60 Hz;
7. compensate only timer-like `+0x578` consumers if runtime parity shows they need it;
8. keep hard-coded `1/60` substep consumers unchanged when their call frequency is restored to the vanilla ~60/s;
9. separately classify non-player systems rather than assuming the player-clock solution generalizes.

This remains a hypothesis until A0/B0/B1 runtime measurements validate the cadence premises.

---

## 14. Highest-priority unresolved questions

1. Does B0 actually double `Player_UpdateOuter` from approximately 30 to approximately 60 calls/s in the controlled test scene?
2. Which other object/NPC/weapon/camera/script update loops are driven by the same outer cadence?
3. How many object classes use explicit delta vs fixed-step vs per-call timing?
4. Which subsystems contain latent configurable 30/60 support like LaserTracer?
5. Which historical x2 symptoms map cleanly to one of the refined timing domains?
6. What is the exact owner/dispatcher for object descriptors and update callbacks?
7. What is the causal path behind the historical Burner `%3 -> %6` correction?
8. Are animation clocks tied to object callbacks, player substeps, or separate animation systems?
9. Which damage systems apply per callback, per collision overlap, per timer, or per emitted object?
10. Which level scripts and hazards are frame-counted?

These questions motivate the next breadth-first global timing-atlas mission.
