I have enough verified material. Here is my report.

---

# DeepSeek Mapper — STATIC-60FPS-COMPLETE-AUDIT-001 — mapper report (partial, evidence-first)

**Role:** mapper (structural reverse engineering / timing-mechanism + pre-patch dataset)
**Session provenance:** repo `C:\Users\linki\Documents\PPSSPP\RAC_60FPS`, branch `v2-research`, HEAD `289964fac799ce88dc73bb904a5f44e8dc9c0de1` (working tree dirty with pre-existing owner edits — untouched by me).
**Environment:** filesystem read-only, approval `never`. No python, node, or `pwsh` accessible; only PowerShell 5.1 in **ConstrainedLanguage** mode. All binary work below was done with `Get-Content -Encoding Byte` + hand-decoded MIPS words and 4-byte-aligned pattern scans. **No file was written, no patch applied, no runtime/PPSSPP access, no memory dump inspected.**
**Mission status:** **PARTIAL.** `UNEXAMINED != 0`. The canonical 534-name per-class audit was *not* completed in this session; see §9 for an honest coverage accounting and why.

---

## 1. Structural map

**Module set (`02-Jeu-et-dumps\Data\BIN\`, 21 PRXs).** `FRONTEND.PRX` + 20 level modules
`LEVEL_01…LEVEL_10`, `LEVEL_15…LEVEL_24`. Content hashes verified with `certutil -hashfile SHA256`; `LEVEL_01.PRX` = `d10a81d0…6571`, matching the documented reference hash. `Data\BIN\*` is byte-identical to `Data\BACKUP\BIN\*` for every module sampled, including `LEVEL_02.PRX` ↔ `LEVEL_02_clean.PRX` (both `0037689a…c8aa`). **The stale-contaminated-LEVEL_02 pitfall does not apply to the current working set.**

**Two structural generations of level module** (`OBSERVED`, PT_LOAD headers):

| Generation | Modules | seg1 `p_vaddr` |
|---|---|---|
| A | FRONTEND, L01–L10, L15, L21–L24 | `filesz0 + 8` (e.g. L01: filesz `0x2DD104`, vaddr `0x2DD108`, off `0x2DD178`) |
| B | L16–L20 | `filesz0` exactly (e.g. L16: filesz `0x2BBB20`, vaddr `0x2BBB20`, off `0x2BBB98`) |

Segment 0 is `p_offset=0x74, p_vaddr=0` in **all 21** modules, so `file_offset = RVA + 0x74` is valid for segment 0 only. This is a concrete confirmation of why *universal* RVA+0x74 was rejected: the gap before segment 1 differs by generation (`+0x74` vs `+0x78`), and segment 1's vaddr/filesz relationship differs too. Any candidate touching data near the segment-0/1 boundary must use the per-module PT_LOAD, not a constant.

**Identical module pair:** `LEVEL_15.PRX` and `LEVEL_21.PRX` are byte-identical in size and in every pattern hit I scanned — a re-used module, not two independently compiled copies.

**Layering observed from static call structure** (L01 as the reference instance):

- *Frame/sync layer*: a per-module function containing the frame-counter/VBlank gate (§3.1). One instance per module.
- *Shared frame-update layer*: function RVA `0x1517C` in L01, which constructs one float (`0x3D088889` ≈ 1/30) in `f20` and fans it to four callees (`0x87A84`, `0x6B7F4`, `0x2FFF0`, `0x6B618`) plus several non-`f12` consumers.
- *Player outer update layer*: `0x2FFF0` → `0x2FB8C` (`Player_UpdateOuter`), which calls `0x360A4` (`Player_UpdateTimingFields`) once, then runs a conditional two-pass inner simulation loop.
- *Player substep layer*: loop body = `0x353A4, 0x32004, 0x3BFF8, 0x3C88C, 0x32888, 0x39B74(dt), 0x1EBC4(dt)`.
- *Class-object layer*: per-class update callbacks reached by pointer tables / `jalr` (no direct `jal` caller), i.e. dispatch ownership remains the central blocker for every class-level C1 verdict.

---

## 2. Relevant functions, addresses, data (re-verified this session)

All words below were read from `Data\BIN\LEVEL_01.PRX` at `file_offset = RVA + 0x74`. `OBSERVED`.

| RVA | word | decode | role |
|---|---|---|---|
| `0x151E0` | `0x3C043D08` | `lui a0,0x3D08` | shared-delta producer, B1 anchor |
| `0x151E4` | `0x34848889` | `ori a0,a0,0x8889` | completes `0x3D088889` ≈ 1/30 |
| `0x151E8` | `0x0C0221DA` | `jal 0x88768` | **confirms** the accepted `0x1517C → 0x88768` lineage (not `0x884A4`) |
| `0x2FBBC` | `0x46006506` | `mov.s f20,f12` (cop1.fmt.S, fs=12, fd=20, funct=6) | player local scalar site |
| `0x2FCF8` | `0x26310001` | `addiu s1,s1,1` | player substep counter |
| `0x2FCFC` | `0x2A240002` | `slti a0,s1,2` | player substep limit (C1 site) |
| `0x360E8` | `0x3C0441F0` | `lui a0,0x41F0` | `30.0f` used by `+0x578 = dt*30` |
| `0x96638` | `0x0C06FD0B` | `jal 0x1BF42C` | first (unconditional) sync/frame call |
| `0x96648` | `0x14440003` | `bne v0,a0,+3` | frame-counter gate |
| `0x96650` | `0x0C06FD09` | `jal 0x1BF424` | **conditional second wait** (B0/“VBlank unlock” site) |
| `0x2D2C04` (data) | bytes `00 00 F0 41` | `0x41F00000` = `30.0f` | LaserTracer local rate |
| `0x14CA70` | `0x3C043F80 … 0x46106B43` | `1.0f`; `lwc1 f12,0x2C04(a0)`; `div.s f13,f13,f12` | `dt = 1.0f / rate` |
| `0x14CA88 / 0x14CA90` | stores to `0x2D2C08 / 0x2D2C0C` | reciprocal `dt`, rate copy | derived LaserTracer constants |
| `0x14CA94` | `0x3C043D88` / `0x34848889` | literal **`1/60`** built inside the tracer initializer | hard-coded 1/60 regardless of rate |
| `0x148CEC` | `0x27BDFFC0` | function prologue | `LaserTracer_Update` callback head |
| `0x1BC424`-class stubs | `0x03E00008 / 0x00000000` | `jr ra; nop` | 2-word import stubs (`0x1BF424`, `0x1BF42C` in L01) |

**New structural observations (this session, `OBSERVED`):**

- The `1/30` construction `lui a0,0x3D08 ; ori a0,a0,0x8889` occurs **49×** in `LEVEL_01.PRX` alone and 30–55× in every other module. This is direct byte evidence against any single-timing-domain reading of `1/30` (the project already rejects "all 1/30 literals belong to one domain"; my count sharpens it).
- Literal **`1/60`** constructions (`lui a0,0x3C88 ; ori a0,a0,0x8889`) exist **exactly twice in every module** in vanilla, e.g. L01 `0x39EB4` and `0x4000C` (both inside/adjacent to the `0x39B74` player-substep region). So hard-coded `1/60` is vanilla, not a patch artifact.
- `30.0f` (`lui a0,0x41F0`) appears 3× in L01: `0x34A5C`, `0x360E8`, `0x36664`.
- A **second** `addiu s1,s1,1 ; slti a0,s1,2` loop exists at RVA `0x1A2778` in L01, independent of the player loop. Direct disassembly shows it walks **two consecutive 0x18-byte structures** (`s0 += 0x18`) around `jal 0x1A2470`, then returns. It is *not* a substep multiplier. This is concrete evidence that a bare `slti …,2` loop tail is **not** a unique player-loop identifier.

---

## 3. Candidate timing mechanisms

### 3.1 Per-module frame gate / second-VBlank wait (new cross-module table)

Detector: aligned idiom `lw a0, G(s0) ; addiu a0,a0,1 ; bne v0,a0,+3 ; nop ; jal W`. Every module has **exactly one** such site. All `W` targets decode to 2-word `jr ra; nop` stubs. `OBSERVED` (bytes); `INFERRED` (that `W` is the wait/`sceDisplayWaitVblank`-class import).

| Module | gate `lw` RVA | frame-counter global | wait-stub RVA | **candidate jal RVA** | file off | original word |
|---|---:|---:|---:|---:|---:|---|
| FRONTEND | `0xD398` | `0x116D74` | `0x305F4` | `0xD3A8` | `0xD41C` | `0x0C00C17D` |
| LEVEL_01 | `0x96640` | `0x2B6E58` | `0x1BF424` | `0x96650` | `0x966C4` | `0x0C06FD09` |
| LEVEL_02 | `0x9C468` | `0x2DE2D8` | `0x1D4E2C` | `0x9C478` | `0x9C4EC` | `0x0C07538B` |
| LEVEL_03 | `0x962FC` | `0x2DB3E8` | `0x1D3AC8` | `0x9630C` | `0x96380` | `0x0C074EB2` |
| LEVEL_04 | `0x9A044` | `0x2D9CA8` | `0x1D2CE4` | `0x9A054` | `0x9A0C8` | `0x0C074B39` |
| LEVEL_05 | `0x952DC` | `0x2A44B8` | `0x1AE490` | `0x952EC` | `0x95360` | `0x0C06B924` |
| LEVEL_06 | `0x9132C` | `0x2A6AD8` | `0x1B0168` | `0x9133C` | `0x913B0` | `0x0C06C05A` |
| LEVEL_07 | `0x98038` | `0x2C6858` | `0x1CF588` | `0x98048` | `0x980BC` | `0x0C073D62` |
| LEVEL_08 | `0x9F25C` | `0x2F5B48` | `0x1FD420` | `0x9F26C` | `0x9F2E0` | `0x0C07F508` |
| LEVEL_09 | `0x938A8` | `0x2A1388` | `0x1AAFF0` | `0x938B8` | `0x9392C` | `0x0C06ABFC` |
| LEVEL_10 | `0x96F50` | `0x2CE768` | `0x1C79F8` | `0x96F60` | `0x96FD4` | `0x0C071E7E` |
| LEVEL_15 | `0x7D370` | `0x2216F8` | `0x12E8A0` | `0x7D380` | `0x7D3F4` | `0x0C04BA28` |
| LEVEL_16 | `0x876D8` | `0x29E2E8` | `0x18E214` | `0x876E8` | `0x8775C` | `0x0C063885` |
| LEVEL_17 | `0x861E8` | `0x281978` | `0x1821E4` | `0x861F8` | `0x8626C` | `0x0C060879` |
| LEVEL_18 | `0x86C8C` | `0x291498` | `0x191730` | `0x86C9C` | `0x86D10` | `0x0C0645CC` |
| LEVEL_19 | `0x882B8` | `0x29C258` | `0x18CBE4` | `0x882C8` | `0x8833C` | `0x0C0632F9` |
| LEVEL_20 | `0x7974C` | `0x21C758` | `0x10EB5C` | `0x7975C` | `0x797D0` | `0x0C043AD7` |
| LEVEL_21 | `0x7D370` | `0x2216F8` | `0x12E8A0` | `0x7D380` | `0x7D3F4` | `0x0C04BA28` |
| LEVEL_22 | `0x87F08` | `0x2385D8` | `0x134670` | `0x87F18` | `0x87F8C` | `0x0C04D19C` |
| LEVEL_23 | `0x8D710` | `0x299E88` | `0x194EB0` | `0x8D720` | `0x8D794` | `0x0C0653AC` |
| LEVEL_24 | `0x8FE0C` | `0x2865F8` | `0x191B5C` | `0x8FE1C` | `0x8FE90` | `0x0C0646D7` |

Mechanism row: family `CALL_FREQUENCY` / V-sync domain (`V`). **C1 verdict: `C1_EXPECTED_PARTIALLY_CORRECT`.** C1 removes exactly one of these 21 gates (documented for L01). Until each module's gate is removed for the module actually loaded, that module's outer cadence is not addressed.

### 3.2 Shared frame delta (`DT_SHARED`), per-module producer

Anchor = `lui 0x3D08 ; ori 0x8889` immediately followed within 0x100 words by `mov.s f12,f20`. `OBSERVED`:

`L01 0x151E0`, `L02 0x155E4`, `L03 0x14FD4`, `L04 0x14E50`, `L05 0x146E0`, `L06 0x13E90`, `L07 0x152E0`, `L08 0x1575C`, `L09 0x146F0`, `L10 0x14958`, `L15 0x11DF4`, `L17 0x135B48`, `L21 0x11DF4`, `L22 0x1239C`, `L23 0x13E70`, `L24 0x138C4`.
**`LEVEL_16` and `LEVEL_18`: not located by this heuristic (UNKNOWN).** A second candidate exists in the `0x0A–0x0C` region of most modules (e.g. L01 `0xC0824`), ownership unestablished.

**C1 verdict: `C1_EXPECTED_PARTIALLY_CORRECT`** — the B1 delta edit is a per-module constant, not a global.

### 3.3 Player outer timing fields (`DT_SHARED` + `N-VEL` + `N-TIMER`)

`0x360A4` writes `+0x56C = dt`, `+0x570 = fmod(+0x570, 1/60) + dt`, `+0x574/+0x584/+0x588/+0x58C += dt`, `+0x578 = dt*30`, and state-selects `+0x57C` vs `+0x580`. `0x328A0` divides per-update displacement by `+0x578`; parts of `0x42C04` subtract `+0x578` as a **countdown magnitude** while other branches subtract literal `1.0`. **C1 verdict: `C1_EXPECTED_PARTIALLY_CORRECT`** — `+0x578 = 0.5` is correct for `N-VEL` and wrong for `N-TIMER`; the two cannot be fixed at the producer. This corroborates the existing `N-VEL` / `N-TIMER` split with byte-level evidence.

### 3.4 Player substep limit (`LOOP_MULTIPLIER`) — **module-dependent, and this is the headline finding**

Controlled comparison, verbatim disassembly:

```
LEVEL_01 @0x2FCA8                      LEVEL_20 @0x2C9AC
 ori  s1, zero, 0                       ori  s1, zero, 0
 lui  s2, 0x2B      ; gate base         lui  s2, 0x20      ; gate base
 sltiu a0, s1, 1                        sltiu a0, s1, 1
 sb   a0, 0x0208(s2)                    sb   a0, 0x59FC(s2)
 … 5-7 body calls, 2 with f12=f20 …     … 6-7 body calls, 2 with f12=f20 …
 addiu s1, s1, 1                        addiu s1, s1, 1
 slti  a0, s1, 2   <-- TWO passes       slti  a0, s1, 1   <-- ONE pass
 bne   a0, zero, back                   bne   a0, zero, back
 ori   a0, zero, 1                      ori   a0, zero, 1
 sb    a0, 0x0208(s2)                   sb   a0, 0x59FC(s2)
```

With `s1` initialised to 0 in both, `slti a0,s1,2` yields **two** substep passes and `slti a0,s1,1` yields **one**. The two loops are otherwise the same construct: same initialisation, same first-substep gate flag store, same post-loop restore, same placement after the timing-field call.

Raw pattern hits (`addiu s1,s1,1 ; slti a0,s1,2`, reported at the `addiu`): L01 `0x2FCF8`+`0x1A2778`; L02 `0x3415C`+`0x1B825C`; L03 `0x2E0A0`+`0x1B7004`; L04 `0x31000`+`0x1B67C4`; L05 `0x2DA04`+`0x191DA8`; L06 `0x2CB68`+`0x193CCC`; L07 `0x2FDF4`+`0x1B305C`; L08 `0x34930`+`0x1DF86C`; L09 `0x2C6B0`+`0x18EB54`; L10 `0x2E75C`+`0x1AA50C`; L15/L21 `0x25D78` only; **L16–L20: none.**
The corresponding `…,1` tails: L16 `0x2F580`,`0x47124`; L17 `0x2F410`,`0x46FB4`; L18 `0x2F66C`,`0x47210`; L19 `0x30D38`,`0x488DC`; L20 `0x2CA14`,`0x43B9C`; plus L15/L21 `0x41F24`.

`LEVEL_02`'s player loop is at RVA `0x34160` (`slti a0,s1,2`), matching the parent static-check reference for LEVEL_02. Note this pattern is register-specific (`s1`/`a0`), so *absence* in L15 is not proof — but L20's site is confirmed by full surrounding disassembly, not by the pattern alone.

**C1 verdict: `C1_EXPECTED_INCORRECT` for LEVEL_16–20 if the same edit is applied**, and `C1_EXPECTED_PARTIALLY_CORRECT` overall. The `2 → 1` edit that *defines* C1 is the vanilla value for LEVEL_16–20; applying it there is at best a no-op and at worst a different loop is hit.

### 3.5 Gate flag `0x2B0208`

L01's first-substep flag lives at `0x2B0208` (`s2 = 0x2B0000`, `sb a0,0x208(s2)`). LEVEL_20's equivalent is `0x2059FC`. The gate byte is therefore **module-local**, and L01's value is instantiated with a hard-coded `lui`. This independently confirms that `0x2B0208` must not be treated as a universal FPS selector — the module base, not the offset, is what varies.

### 3.6 LaserTracer local rate subsystem (`RATE_LOCAL`) — dedicated dossier

`OBSERVED`: local rate `0x2D2C04 = 0x41F00000` (30.0f); one read of it, from `TracerTiming_Init` at `0x14CA70`; the initializer computes `dt = 1.0f/rate`, stores `dt → 0x2D2C08` and `rate → 0x2D2C0C`, and **also builds a literal `1/60` (`0x3D888889`) and a `≈0.785398` (`0x3F490FDB`) constant** which it scales by `dt` and stores toward `0x2D2C4C`/`0x2D2C88`. No code writer of `0x2D2C04` was found; the only pointer to `0x14CA70` is the raw table entry at `0x2DD1F8` (no direct `jal`). Scope is tracer-family-local, not a master clock.

**C1 verdict: `C1_STATICALLY_UNKNOWN`,** with a concrete reason: whether the `rate==60` branch is *reachable* depends on the loader table owner writing `0x2D2C04`, which is unresolved. If the subsystem is configured to 60, its damping coefficients are already correct and C1's shared 1/60 is likely harmless; if it stays at 30 while callbacks double, its per-call counter (`pvar+0x08`) and any `dt`-scaled term double in real time. The literal `1/60` inside the initializer is a second, independent hazard: it does not scale with `rate`.

---

## 4. Candidate corrections — all `UNVERIFIED_STATIC_CANDIDATE`

| ID | Module | RVA / file off | Original word/opcode | Candidate | Conceptual correction | Scope | Risk |
|---|---|---|---|---|---|---|---|
| `CAND-VB-01` | LEVEL_01 | `0x96650` / `0x966C4` | `0x0C06FD09` `jal` | `0x00000000` `nop` | remove conditional 2nd wait | this module only | documented; do **not** generalize |
| `CAND-VB-02…21` | FRONTEND, L02–L10, L15–L24 | gate RVA+`0x10` (table §3.1) | see table | `0x00000000` | same, per module | one module each | each `W` stub must be confirmed to be the wait import, not another 2-word import |
| `CAND-DT-01` | LEVEL_01 | `0x151E0` / `0x15254` | `0x3C043D08` `lui a0` | `0x3C043C88` | shared delta 1/30 → 1/60 | module-wide; 4+ consumers | breaks `N-TIMER` consumers of `+0x578` (see 3.3) |
| `CAND-DT-02…` | L02–L24 | §3.2 RVAs | same pair | `0x3C043C88` | same, per module | module-wide | L16/L18 anchor not yet located |
| `CAND-LOOP-01` | LEVEL_01 | `0x2FCFC` / `0x2FD70` | `0x2A240002` `slti a0,s1,2` | `0x2A240001` | two passes → one | player only | under-integrates `0x32588` family unless local 1/30 is reconstructed |
| `CAND-LOOP-02…` | L02–L15, L21–L24 | §3.4 | `…,2` | `…,1` | same, per module | player only | **must not** be applied to L16–L20 |
| `CAND-LOCAL-01` | LEVEL_01 | `0x2FBBC` / `0x2FC30` | `0x46006506` `mov.s f20,f12` | *(withheld)* | local 1/30 reconstruction for selected substep consumers | narrow | historical `add.s f20,f12,f12` is too early; existing evidence already treats it as non-preferred |
| `CAND-GLOBAL-01` | L01 | `0x360E8` | `0x3C0441F0` `lui 30.0` | *(withheld)* | `+0x578 = dt*30` | — | **REJECTED** as a global fix: `0x328A0` needs the real half-step |

No opcode-level candidate is offered for damage, fire rate, projectiles, camera, or enemy locomotion, because no matched A0/C1 cadence exists for those classes and the atlas is explicit that constant presence is not defect proof.

---

## 5. Cross-level / cross-system relationships

1. **The "C1 socle" is a template, not a global.** All four socle edits are per-module constants with module-specific RVAs. Applying LEVEL_01's RVAs when another module is loaded is a whole class of silent desync that no LEVEL_01-based test can detect.
2. **Two module generations.** L16–L20 differ in (a) segment-1 mapping, (b) absence of the L01-shaped shared-delta producer, (c) vanilla player-loop threshold 1. L15≡L21 are the same bytes. Any per-class "C1 verdict" derived only from Pokitaru/LEVEL_01 does not automatically hold for generation B.
3. **Sync → delta → player loop → substeps → class callbacks** is one chain, but only the first four links are statically resolvable here. Class callbacks are reached indirectly; their cadence is therefore *decided* by which of these links owns them (outer tick vs substep vs display), and that ownership is exactly what is unmeasured.
4. **Dispatch domain is the pivot for every class verdict.** The `Waterfall` runtime pair already shows a class callback halving in real-time period under C1 while its per-call steps stay fixed. That is consistent with a class callback riding the *outer* cadence (which doubles) rather than the *substep* cadence (which C1 keeps at ~60/s by halving passes). It is consistent with, but does not prove, "scene-object callbacks are outer-driven".
5. `0x2B0208` (L01) is read by `LaserTracer`'s local gate. The same offset does not exist as a flag in other modules; only the *role* transfers.

---

## 6. Competing interpretations

| # | Interpretation | Supports | Against |
|---|---|---|---|
| A | Class-local fixed-step logic is *overdriven* under C1 because callbacks are outer-driven at ~60 Hz while per-call steps are vanilla. | Waterfall A0/C1 measured pair; L01 substep loop keeps outer 60 Hz. | A class callback riding the corrected one-pass substep keeps ~60 calls/s with 2× the per-call step only if the step is substep-owned; unmeasured. |
| B | Class-local logic is *already correct* under C1 wherever the callback rides the substep domain, and only outer-domain classes need work. | C1 keeps player substep call rate near vanilla ~60/s. | No class-level cadence has been measured; `Level01Waterfall` lives in `M01` and is not proven substep-owned. |
| C | The apparent L16–L20 loop difference is a pattern-matching artifact (different register allocation). | Pattern scans are register-specific; absence is not proof. | **Contradicted for L20** by full surrounding disassembly: same `ori s1,0` / gate store / body / post-loop restore shape, only the immediate differs. Not yet disproved for L16–L19. |
| D | LaserTracer is already rate-correct and needs no change. | Explicit `rate==60` branch and exponential coefficients exist; the initializer derives `dt` from `rate`. | The literal `1/60` inside the initializer does **not** derive from `rate`; and no writer of `0x2D2C04` is known, so the branch's reachability is UNKNOWN. |
| E | `+0x578 = dt*30` should be globally changed to `dt*60` so the field stays `1.0`. | Keeps `N-TIMER` consumers identical. | **REJECTED** previously and re-confirmed: `0x328A0` divides displacement by `+0x578`. |

---

## 7. Uncertainty and missing evidence

- **Per-class callback cadence and dispatch ownership** — the single largest gap; blocks every class-level C1 verdict.
- **Whether each module's gate `jal` (`W`) is the same logical wait** — all 21 `W` are 2-word `jr ra;nop` stubs, but I did not resolve the per-module import tables, so the *identity* of the import is `INFERRED`, not `OBSERVED`.
- **LEVEL_16 / LEVEL_18 shared-delta producer RVA** — `UNKNOWN` (heuristic found no `mov.s f12,f20` companion).
- **Reachability of the LaserTracer `rate==60` branch** and the owner of the `0x2DD1F8` table entry — `UNKNOWN`.
- **The `0x1A2778` (L01) / `0x1B...` (L02+) two-element 0x18-stride walk** — purpose and timing relevance `UNKNOWN`; explicitly *not* a substep multiplier.
- **The second 1/30 producer near `0x0C0824`** in most modules — ownership `UNKNOWN`.
- **My pattern scans are register- and immediate-specific.** They establish presence, not absence. Every "NONE" in §3.4 is "not found by this detector", not "not present".
- **Tooling constraint:** no Python/Node/`pwsh`, `ConstrainedLanguage`, read-only FS. Full disassembly, relocation-aware decoding, and writing `reports\STATIC-60FPS-COMPLETE-AUDIT-001\staging\mapper\*` were all impossible this session. **No mapper tables, CSVs, `progress.json`, or object dossiers were persisted — the mission's "flush every 25-name shard" contract is UNMET.**

---

## 8. Best deterministic test to distinguish the candidates

**Test T-1 (highest information, ~1 scene, read-only).** In a **non-Pokitaru generation-B module** (LEVEL_20 recommended — its loop is already 1-pass), record with true-stop breakpoints, in A0 then B0 (gate `jal` NOP'd only):

1. outer-cadence counter at the module's own gate site (`0x7975C` neighbourhood in L20) — is complete-cycle cadence ≈2× A0?
2. hits at L20's player-loop tail `0x2CA10/0x2CA14` and one body callee (e.g. `jal 0x19D44`);
3. one passive class callback in that module with a fixed per-call step, plus its field delta per hit and per real second.

Discrimination:
- If (1) doubles, (2) doubles, and (3) doubles *per real second with unchanged per-hit step*, interpretation **A** is supported for that class and generation B behaves like A0→B0→C1 in L01 — so the template premise survives, but the *threshold edit must not be applied* to L16–L20.
- If (1) doubles but (2) stays ~constant, L20's vanilla one-pass loop is not the outer-cadence-bearing loop, and interpretation **C** is rejected outright.
- If (3) stays invariant while (1) doubles, the class rides a self-normalising/display-coupled domain (competing with the Waterfall result), and no per-call correction should be derived for it.

**Test T-2 (cheap, ordering-critical).** Before any of the above, resolve the per-module import stub identity for the 21 `W` targets (static: cross-reference each `W` against the module's import/NID tables). This converts the whole §3.1 table from `INFERRED` to `OBSERVED` and is a prerequisite for validating *any* gate-removal candidate outside LEVEL_01.

**Test T-3 (falsifies §3.4 arithmetic).** At L01 `0x2FCA8` and L20 `0x2C9AC`, record `s1` at loop entry and at the back-edge in A0. Two entries for L01 and one for L20 confirm the pass counts directly, without relying on the immediate.

---

## 9. Coverage accounting (honest, PARTIAL)

| Counter | Value |
|---|---|
| Canonical names expected | 534 (task) |
| Structured-corpus rows in current atlas | 538 (independently re-counted: 538 data rows, 538 unique names, 32 columns) |
| Atlas family counts reproduced exactly | yes — T6 139, T9 115, T10 80, T11 57, T7 55, T5 53, T8 21, T4 8, U1 7, T1/T2/T3 1 each |
| Canonical names individually re-audited by me this session | **not achieved** |
| Module-level anchors newly verified by primary bytes | 21 gate sites, 16 shared-delta producers, ~40 loop-tail sites, LaserTracer anchors |
| **UNEXAMINED** | **≠ 0 — mission is PARTIAL, not COMPLETE** |

I deliberately did **not** fabricate per-class rows. The atlas already carries a terminal family for all 538 structured names, but promoting those to mapper rows without me re-deriving them from primary evidence would be exactly the silent promotion the project forbids.

---

<!-- PARENT_HANDOFF_V1 -->
```json
{
  "established": "OBSERVED(read-only bytes):L01 4 socle sites re-verified;21-module frame-gate table;16 per-module delta producers;LEVEL_15==LEVEL_21 byte-identical.",
  "corroborated": "Frame-gate idiom(lw/addiu/bne/nop/jal)+2-word jr-ra wait stub+module-local frame counter; matches documented LEVEL_01 0x96650 and global 0x2B6E58.",
  "inferred": "Gate jal at gateRVA+0x10 is the removable second VBlank wait in all 21 modules; LEVEL_16-20 vanilla player-loop threshold is already 1, not 2.",
  "contradictions": "LEVEL_20 player loop slti=1 vs LEVEL_01 slti=2 (same loop shape); LEVEL_16-20 differ in seg1 mapping (vaddr==filesz0) and lack the L01 delta-producer shape.",
  "rejected": "NONE newly rejected. Prior rejections preserved and re-checked: 0x151E8->0x884A4, universal dt*30->dt*60, universal RVA+0x74, 0x2B0208 as global selector.",
  "unknown": "Per-class callback cadence/ownership; import identity of each module's wait stub; LEVEL_16/18 delta-producer RVA; LaserTracer rate==60 branch reachability.",
  "top_hypotheses": "H1: the C1 socle is a per-module template; applying LEVEL_01 RVAs to another loaded module is a silent-desync class no LEVEL_01 test detects.",
  "best_discriminating_test": "A0 vs B0(gate NOP only) true-stop cadence at the gate site, the player-loop tail, and one passive class callback in LEVEL_20, same scene/input.",
  "blockers": "Read-only sandbox, approval never; no python/node/pwsh (PS5.1 ConstrainedLanguage); no runtime allowed. 534-name per-class audit not completable this session.",
  "full_report_required": "yes: sections 3,4,6,7 (per-module tables, C1 verdicts, competing interpretations, discriminating tests) before any candidate is promoted."
}
```
<!-- /PARENT_HANDOFF_V1 -->