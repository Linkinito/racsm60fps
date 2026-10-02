# Live session 2026-10-02 evening (Pokitaru, owner + Claude)

Environment: PPSSPP 1.20.4 Vulkan, fresh start (previous 14 GB process closed), InterpGate IG-v19
(sha256 444b24e1…cbe0, matches build) + OCEnhance. Weapon: Blaster upgraded (Double Lacerators: two
projectiles per shot). Raw outputs: measurements/session-2026-10-02b/ (local).
Tools: tools/runtime/projectile-tracker.py (projectiles + ammo, throttled), blaster-probe.py.
Test aid: Blaster ammo stock set to 10000 (owner request, 04-ammo-set.json); not a parity change.

## Tooling incidents (resolved)

- Two debugger clients polling at once stalled the game and starved one client (no data). One
  connection only now.
- Back-to-back memory reads (no sleep) froze emulation. Polling throttled (50 ms tracker, 15 ms probe);
  emuSpeed (CPU ticks/s / 222 MHz) recorded: 0.93..1.00 during all accepted runs.

## Measurements (aim at open space, 12 s after the first shot)

| Run | Shots/s | Gap median | Projectile step per age unit | Speed (u/s) | Note |
|---|---|---|---|---|---|
| A0 | 4.134 | 0.267 s | 4.20 | ~126 | 2 projectiles/shot, dies at age ~5-6 |
| C1 | 1.842 | 0.517 s | 4.20 | ~255 | owner: animation rate fine, every other shot spawns nothing |
| C1+weapondt (word only) | 2.007 | 0.517 s | 4.20 | ~241 | delay-slot edit NOT executed (see below) |
| C1+domain8 (words only) | 1.844 | 0.517 s | 4.20 | ~247 | same |
| C1+domain8 after JIT refresh | **4.134** | 0.234 s | 4.20 | ~195 | **cadence = A0** |
| C1+weapondt (auto JIT refresh) | **4.139** | 0.234 s | 4.20 | ~194 | weapondt alone suffices for cadence |
| C1+weapondt+blastershot | **4.133** | 0.234 s | **2.10** | **125.7** | speed = A0 (125.9), max age 9 vs 5 |

Probe (C1+domain8 before refresh): refire cooldown pvar+4 fell 0.5 -> 0 in 0.5 s wall time and the
hold timer advanced in real time; gun state +0x45 cycled 0/4; fire bit 0x95C&0x20 open when the
cooldown reached 0. Breakpoints: Blaster_Update called from 0x1F2D0 (ra 0x1F2D8), WeaponUpdate from
the substep loop (ra 0x2FCF8), f12 = 1/60 although 0x2FCF4 read back `add.s f12,f20,f20`.

## Root cause of the "weapondt has no effect" result (TESTED)

PPSSPP keeps a branch and its delay slot translated together: a delay-slot word written through the
debugger reads back correctly but is not executed until the branch itself is rewritten (same effect
as waterfall-004, 2026-09-26). After rewriting 0x2FCE4 and 0x2FCF0 identically, WeaponUpdate got
f12 = 1/30 and the rate matched A0. The 2026-10-02 morning `weapondt` result and today's first two
runs are therefore NOT evidence against the fix. fixes.py now rewrites the preceding branch after any
delay-slot edit. Other fix sites in delay slots (possibly inactive in earlier tests): crabtimers
0x124650/0x124860/0x125368, frames30 0x14F218, frametimers 0x16D014, lunaidle1 0x154E74, k30calls
0x17A6D0, tbtimers 0x18531C, wfparity 0x151EDC (handled since waterfall-004), excluded ft0x4556C/0x575EC.

## Conclusions

- Domain 8 confirmed for the Blaster cadence: `domain8` (weapondt+substepdt+framescale) restores A0
  shots/s exactly (4.134 vs 4.134). Which of the three words is necessary is not yet bisected.
- NEW defect measured: BlasterShot advances 4.2 units per update in A0 and C1, so in C1 projectiles fly
  2x fast (~250 vs ~126 u/s) and live half as long; range per update count unchanged. `age70` alone
  would double lifetime and range; the per-update step must be halved too (not yet designed).

## Blaster parity result (TESTED, single run each, same position, owner aiming at open space)

`weapondt` + `blastershot` (0x117B70 and 0x118178: lui 30.0 -> 60.0 in the shot speed and lifetime
formulas `21 / (10 x 1/60 x 30)` and `10 x 1/60 x 30`) reproduces A0 cadence (4.133 vs 4.134 shots/s)
and projectile speed (125.7 vs 125.9 u/s) at 60 Hz; per-update step 2.1, life 10 updates. Remaining:
repeatability, impact/hit behaviour, damage, dual-gun visuals, other weapons; `substepdt`/`framescale`
effects on player timers not evaluated (not needed for the Blaster cadence).

## Ryno ("TELT") — A0 restored, Ryno stock set to 10000 (offset 0x2AEEC4 = entry 15 +0x40), RynoRocket tracked

| Run | Shots/s | Gap median | Rockets/shot | Step per age | Speed (u/s) | Life | Max age |
|---|---|---|---|---|---|---|---|
| A0 | 1.993 | 0.534/0.467 alternating (mean 0.500) | ~6 | 0.796 | 23.97 | 1.13 s | 35-36 |
| C1 (owner released early) | 1.732 | 0.466 | ~6 | 0.796 | 47.9 | 0.57 s | 35-36 |
| C1 repeat | 2.144 | 0.466 | ~6 | 0.796 | 47.8 | 0.57 s | 34-36 |
| C1+rynorocket | 2.010 | 0.465 | ~6 | 0.398 | **23.94** | **1.17 s** | 70-72 |

- Ryno refire (24.0 per-call counter, weapon update in the substep loop) is ~7.6% fast in C1, not 2x:
  `rynorate` (24 -> 48) is REJECTED (it would halve the rate). Residual ~0.03 s per shot UNKNOWN
  (frame quantisation or a per-frame gate).
- The owner's "TELT fires too fast" impression matches the rockets flying 2x fast in C1.
- `rynorocket` (speed 0.8 -> 0.4 at 0x2D6A94, life 36 -> 72 at 0x2D6B94, homing turn caps halved
  0x2D6B80..8C) restores rocket speed, life and range. Random wobble kicks per call not converted.

## Ryno cadence residual: animation end latency (TESTED)

Frame-accurate traces (tools/runtime/ryno-probe.py, frame counter 0x2AF28C): A0 fires exactly every 15
frames (the earlier 0.534/0.467 alternation was a 66 ms sampling artefact), C1 every 28 frames. The refire
counter (24 calls) is not the limiter: the player stays in state 0x38 (shooting) until its animation ends
(FUN_000362E8 -> end bit 4 of the channel, consumed by 0x76314). The shot animation lasts L = 13/30 s
(0.43333, speed 1.0, OBSERVED). 0x76BCC (once per main update, after the player) raises bit 4 only when
`L < time` (strict), and readers see it on the next update: A0 13+1+1 = 15 frames, C1 26+1+1 = 28.
Any non-looping animation end therefore arrives 2 updates late: 2/30 s in A0, 2/60 s in C1.

`animlat` (InterpGate IG-v20, sha256 485f9412…dbde7; wrapper on the three 0x76BCC call sites 0x785B8,
0x78618, 0x78658) withholds a newly raised end bit of non-looping channels for 2 extra calls (pose stays
clamped at the end). PPSSPP restarted to load IG-v20; Ryno ammo refilled (test aid).

| Run (lite probe, 8 s) | Shots | Mean period | Seconds |
|---|---|---|---|
| A0, IG-v20 resident, fix off | 14 | 15.0 frames @30 Hz | 0.500 |
| C1 + animlat + rynorocket | 14 | 30.08 frames @60 Hz | 0.501 |

Ryno cadence is 1:1 with A0. Note: the full ryno-probe (14 reads per sample at 10 ms) slowed emulation
to 0.49; use --lite for cadence. animlat is global (every non-looping animation end: player actions,
weapons, entities): visual and gameplay regressions not yet checked; looping channels untouched.

## Weapons inventory (static, from ammo lookups FUN_0001F71C(id) per class)

2 Blaster, 3 BlitzGun (Tremblator), 4 Bombglove, 5 AgentsGlove, 6 BeeMineGlove, 7 ShieldCharger,
8 ShockRocket, 9 CrossbowGun, 10 Flamethrower, 11 LaserTracer, 12 SuckCannon, 13 Mootator, 15 Ryno
(+ 18 Polarizer gadget). Ammo stock = module + 0x2AE95C + id x 0x58 + 0x40 (Blaster/Ryno/Tremblator
confirmed live). Tools: projectile-tracker --weapon, ryno-probe --lite --weapon, set-ammo, ray-stats.

## Canon Tremblator (BlitzGun, id 3, level 1 = upgraded)

- Cadence (lite probe, frame-exact): A0 23.0 frames @30 Hz (0.767 s); C1 91 frames @60 Hz (2x slow);
  C1 + weapondt + animlat (+blitzshot): **46.0 frames @60 Hz = 1:1**. Cooldown pvar+4 -= dt in the
  substep weapon update (same as Blaster).
- Shock wave: 8 static BlitzGunShot records per shot + visible ray particles. A0: phase 3 at 13 frames,
  record gone at 14 (16/16 records, ray-stats). The records die through the segmented-ray state
  machine 0x5FACC (build all 9 segments in one call, hold `+0x24 += 1/30` per call, phase 2 until the
  segment count pv+0x54+2 reaches 0, state 3 -> destroy at 0x11CCD4, OBSERVED by conditional
  breakpoint) and, coincidentally, the age check against life table 0x2CE3E8 (9/14) which also sets the
  visible ray particle lifetime (callback 0xC9ED8, life -1 per call; table 100 -> rays lasted much
  longer, owner-observed; record death unchanged).
- Segments are records of pool animator 0x60100 (fade step 1/(seconds x 30.0): frames30 sites
  0x60378/0x603A4/0x603E4) that decrement the parent ray count when they die.
- Attempts (C1, frames @60 Hz, target phase 3 = 26, gone = 28):
  | Set | phase 3 | gone |
  |---|---|---|
  | C1 + weapondt + animlat + blitzshot | ~11-13 | ~14 |
  | + rayfix (ft0x5ffa0 + segfade) | ~22 | ~24 |
  | + rayhalf (IG-v21/22) + segfade | 24.45 | 25.45 (88 records) |
  | + rayhalf + segrate mode 2 | 23.77 | 24.85 (mode 2 did not restore the parent count) |
  | + rayhalf + segrate mode 3 (IG-v23) | 23.38 | 24.38 (first transitions 2 frames early) |
  Not yet 1:1. Remaining cause INFERRED: the BlitzGunShot entity itself (spawn state, age, first
  machine call) runs at 60 Hz. IG-v24 "30 Hz island" (blitzhalf class update at 30 Hz + raycb ray
  particle callback at 30 Hz + segrate mode 3, original table) is built and installed but NOT validly
  measured: the last autonomous runs (dirs 85-91) were taken with PPSSPP in the background, game fps
  varied 25..200 and a memory read timed out -> INVALID. PPSSPP restarted (2.8 GB before).
- Input injection works (PPSSPP `input.buttons.press` / `input.buttons.send`, circle = fire 0x2000).
  Measurements need the PPSSPP window in the foreground; ray-stats now records game fps and validity.
