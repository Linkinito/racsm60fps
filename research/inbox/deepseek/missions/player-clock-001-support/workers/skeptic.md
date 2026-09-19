I have enough primary evidence. Below is the self-contained report.

---

# PLAYER-CLOCK-001 — DeepSeek Skeptic independent report

**Scope:** bounded player-clock investigation of `LEVEL_01.PRX` (Pokitaru), UCES00420.
**Method:** static, read-only. Primary file, ELF headers, raw instruction words, and Capstone 5.0.1280 disassembly from the repository's bundled `analysis-deps`. No emulator, no RAM, no writes, no patch application.
**Primary file verified:** `01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX`, size `3,444,725`, SHA-256 `d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571` — matches the task's expected hash.

## 0. Address model (established from primary file, not inherited)

ELF program header 0: `p_offset=0x74`, `p_vaddr=0x0`, `p_filesz=0x2DD104`. Therefore, for the whole code/data range used here:

```
file_offset = RVA + 0x74        (RVA = p_vaddr within module)
```

Header 1 (`p_offset=0x2DD178`, `p_vaddr=0x2DD108`, `p_filesz=0x1AC`, `p_memsz=0x18E728`) is BSS and is not file-backed.

The archived V1 README (`archives/Pokitaru_60FPS_V1_two-builds.zip::pokitaru_v1/README_Pokitaru_V1.md`, read in-memory) independently documents runtime base `0x09139D00` and the same formula `file offset = 0x74 + (runtime − 0x09139D00)`, and records the same source hash. So:

```
RVA = historical runtime address − 0x09139D00
```

Historical runtime addresses are **not** RVAs. Example: V1 “Local physics compensation” `0x091698BC` = RVA `0x2FBBC`. The V1 local-JAL list (`0x09162C88`, `0x09165C20`, `0x0927DFFC`, `0x0928A5C8`, `0x092C1424`, `0x09288C28`, `0x09268694`, …) corresponds to RVAs `0x28F88`, `0x2BF20`, `0x1442FC`, `0x1508C8`, `0x187724`, `0x14EF28`, `0x12E994`, … — none of which is the WF-002 Pokitaru site (see §5).

## 1. Core words (read directly from the file)

| System | RVA | file off | vanilla word | decode | V1 patched word |
|---|---|---|---|---|---|
| Second VBlank wait | `0x96650` | `0x966C4` | `0x0C06FD09` | `jal 0x1BF424` | `0x00000000` |
| General delta | `0x151E0` | `0x15254` | `0x3C043D08` | `lui $a0,0x3D08` (with `0x151E4: 0x34848889` `ori → 0x3D088889` = 1/30) | `0x3C043C88` (→ `0x3C888889` = 1/60) |
| Player substeps | `0x2FCFC` | `0x2FD70` | `0x2A240002` | `slti $a0,$s1,2` | `0x2A240001` |
| Local scalar | `0x2FBBC` | `0x2FC30` | `0x46006506` | `mov.s $f20,$f12` | `0x460C6500` |

**Parent decode challenge — resolved in favour of the parent.** Independent field decomposition from the raw words:

```
0x46006506: op=0x11 fmt=0x10 ft=f0  fs=f12 fd=f20 funct=0x06  -> mov.s $f20,$f12
0x460C6500: op=0x11 fmt=0x10 ft=f12 fs=f12 fd=f20 funct=0x00  -> add.s $f20,$f12,$f12
```

Capstone decodes both identically. The older worker decode (`mov.s $f10,$f6` / `add.s $f10,$f6,$f12`) is **REJECTED**. Note that `funct=0x06` (MOV.S) requires `ft=f0`; the word's `fs` field is `f12` and `fd` is `f20`.

Two further early-file delta constants exist and are separate sites: `0x361C: 0x3C043D08` + `0x3634: 0x3C04BD08` (camera ±1/30 → ±1/60). They are not the player path.

## 2. Caller chain and f12 dataflow (single-caller at every level)

| From | site | To | argument |
|---|---|---|---|
| mode dispatch `0x159DC` (`0x15AA8` / `0x15B18`) | `jal 0x1517C` | general update `0x1517C` | — |
| general update | `0x151E0–0x151EC` | — | `f20 = 1/30` (patched 1/60) |
| general update | `0x15260` + delay `mov.s $f12,$f20` | player driver `0x2FFF0` | `f12 = delta` |
| player driver | `0x30024` `mov.s $f20,$f12` | — | saves delta |
| player driver | `0x300F4` + delay `mov.s $f12,$f20` | player update `0x2FB8C` | `f12 = delta` |
| player update | `0x2FBBC` `mov.s $f20,$f12` | — | `f20 = delta` |

`jal`-to-`0x2FB8C` exists **only** at `0x300F4`; `jal`-to-`0x2FFF0` **only** at `0x15260`; `jal`-to-`0x1517C` **only** at `0x15AA8` and `0x15B18` (two mutually exclusive jump-table cases of the mode dispatcher). The delta is a **hardcoded constant, not wall-clock derived** — it encodes an assumed step, so changing it is a tuning change that presumes the outer cadence doubled.

## 3. `0x2FB8C` structure (a0 = player, f12 = delta)

```
2FBBC  mov.s   f20,f12                 ; f20 = delta
2FBC0  sw      s0,0xC0(0x2B0000)       ; global 0x2B00C0 = player pointer
2FC04  if (player[0xD90]) jalr ...     ; callback dispatch, returns
2FC38  if (player[0x5AC]) jal 0x55D80
2FC60  jal 0x360A4  (a0=player, f12=f20)   <-- OUTSIDE loop, 1x per outer call
2FC68  snapshot player[0xA20/24/28] -> player[0xF6C/70/74]
2FC80  gate = player[0x95C] & 0x8000
2FCA0  if gate == 0 -> 2FD48              ; single 0x353A4 call
2FCB0  loop:  0x2B0208 = (s1 < 1)
               0x353A4(a0=player)
               0x32004(a0=player)
               0x3BFF8(a0=player)
               0x3C88C(a0=player)
               0x32888(a0=player)
               0x39B74(a0=player, f12=f20)
               0x1EBC4(a0=player, f12=f20)
               s1++; while (s1 < 2)        ; 2FCFC
2FD08  0x2B0208 = 1
2FD10  0x35964 -> maybe 0x35940, 0x4F2D0
2FD30+ write bit 0x20000 into some child objects' flag
2FE60  player[0x9DC] = 1.0
```

**Callee classification (tentative, all OBSERVED disassembly; semantics INFERRED):**

| Callee | Position | What it actually does |
|---|---|---|
| `0x353A4` | in loop (2×) and else-branch (1×) | Flag-only. Clears bits `0x1,0x2,0x10000,0x20000,0x400000` and **sets `0x8000`** in `player+0x95C`; `player+0x960` `|=8`, clears `0x10,0x40`. No delta. **Writes the same bit that gates the loop.** |
| `0x32004` | in loop | Copies `player+0x30/34/38/3C` → `player+0x26C/270/274/278` (previous-position snapshot), calls `0x31AD4,0x31D84,0x31078`. No f12. |
| `0x3BFF8` | in loop | Jump-table state dispatcher on `player[0xF8]` (`<0x49`, table at `0x1C15E0`); mostly flag writes. |
| `0x3C88C` | in loop | Large jump-table state dispatcher on `player[0xF8]` (`<0x4F`, table at `0x1C1708`); contains the jal at `0x3F7CC` that eventually reaches WF-002. |
| `0x32888` | in loop | Effectively a **no-op stub** (`lh 0xf8; bne -1; jr ra` — both paths return). |
| `0x39B74` | in loop, f12=f20 | Main player subsystem update. Integrates `player[0x30/34/38] += player[0xA20/24/28]` (`0x39C18–0x39C50`), then **reloads `player[0xA20..0xA2C]` from static vector `0x2CA358`**. Calls `0x32588(f12=f20)` at `0x39D20` — which subtracts f20 from `player+0xA00,A08,A14,A18,A0C` with clamp ≥0 (delta countdowns). Uses f20 once more at `0x39D24` only as an argument. |
| `0x1EBC4` | in loop, f12=f20 | State-dependent player update (state `player[0xF8]`), uses f20 exactly once, at `0x1F2D4`, as `f12` to an indirect `jalr` callback. |
| `0x360A4` | **outside** loop, 1×/outer, f12=f20 | Per-frame timer/normalizer (below). |

**`0x360A4` in detail** (this is the key non-substep delta consumer):

```
player[0x56C] = f20
player[0x570] += f20
player[0x574] += f20
player[0x578] = 30.0 * f20            ; 0x41F0 = 30.0
player[0x584] += f20 ; player[0x588] += f20 ; player[0x58C] += f20
(player[0x57C] or player[0x580]) += f20   ; depends on player[0xF8]
jal 0x1A5D68 (f12 = player[0x570], f13 = 0x3C88893B ≈ 1/60)
```

`player+0x578` (= `30·delta`) is read **inside the substep loop**:
- `0x328A0` at `0x328E8` divides a displacement difference by `0x578` (velocity estimate), called from `0x39B74` at `0x39BE4`;
- `0x42C04` (called from `0x39B74` at `0x39BAC`, a0 = player) subtracts `0x578` from countdowns `player+0x9D4` and `player+0x9D8`.

## 4. Challenge to the equation “outer-rate × substeps × delta”

Define `R` = vanilla outer cadence of `0x1517C`/`0x2FB8C` (calls/s). The correct per-consumer invariant is **(calls per second) × (delta per call)**, and the loop and non-loop consumers have *different* call rates:

| Consumer | Vanilla (A0) per second | Delta-only (B1: outer 2R, substeps 2, delta 1/60) | Full socle (2R, substeps 1, local ×2) |
|---|---|---|---|
| per-substep (`0x39B74`/`0x32588`, `0x1EBC4`) | `R · 2 · (1/30) = 2R/30` | `2R · 2 · (1/60) = 2R/30` ✅ | `2R · 1 · (1/30) = 2R/30` ✅ |
| per-outer-frame (`0x360A4`) | `R · (1/30) = R/30` | `2R · (1/60) = R/30` ✅ | `2R · (1/30) = 2R/30` ❌ 2× |

Consequences:

1. The local doubling at `0x2FBBC` has a real, mechanically-grounded purpose: it restores `f20 = 1/30` per substep so the in-loop consumers and the `player+0x578` normalization are preserved **after** the 2→1 substep change. This partially answers Sol-review §4's “semantic purpose unknown.”
2. But because `0x360A4` is outside the loop and receives the *same* doubled `f20`, the socle **over-corrects every once-per-frame consumer in that function by 2×** relative to A0, assuming outer cadence really doubles. The values that advance 2× are `player+0x570,0x574,0x584,0x588,0x58C,0x57C/0x580` and the `f12` passed to `0x1A5D68`. `player+0x578` stays `1.0` (which is probably *why* doubling was chosen — it is used as a “one frame” divisor inside the loop — but that same choice breaks the additive accumulators).
3. **Delta-only (B1) is the unique arm of the three that preserves both consumers.** The substep change is not required to preserve delta budgets under a doubled outer rate; it is only required if some per-substep effect is *not* delta-scaled.
4. Therefore the slogan “outer-rate × substeps × delta” is not a law and can mislead: it hides that the product only holds for consumers reached once per substep. Two consumers with different multiplicities cannot be simultaneously satisfied by one doubled scalar once substeps ≠ 1.

This is an `INFERRED` result from `OBSERVED` disassembly. Its weak point is the unproven premise `B0 outer rate = 2R` (see §6).

## 5. WF-002 — is there a supported path?

**What WF-002 is (from primary/archived evidence):** family for the shared smoothing wrapper; `CONTINUITE.md` labels WF-002 “player orientation / proposed grindrail context.” The shared wrapper is RVA `0xE35C`; it calls the smoothing helper `0xE290` **twice** per invocation (`0xE394`, `0xE3B0`). `0xE290` is a velocity-based smoother: `vel = (target−current)·k − vel·d`, clamp, then `current += vel`.

**Pokitaru WF-002 call site:** trace `trace_L01_0001.json` records WF-002 with `ra = 0x091840C0` → RVA `0x4A3C0`. In the binary, RVA `0x4A3B8` is `jal 0xE35C` (delay `lwc1 $f15,0x25C($s0)`), inside function `0x4A158`. So the WF-002 member is the wrapper call at `0x4A3B8` inside function `0x4A158`. RVA `0x4A158` is confirmed as a real function entry (`addiu $sp,$sp,-0x80`) that normalizes vectors (sqrt/div of `0x1F4..0x20C`).

**Static jal path from the player substep loop to WF-002 exists:**

```
0x2FB8C --(0x2FCD0 jal)--> 0x3C88C --(0x3F7CC jal)--> 0x48E30
       --(0x48E7C jal)--> 0x4A4F0 --(0x4A6F0 jal)--> 0x4A158
       --(0x4A3B8 jal)--> 0xE35C (wrapper) --> 0xE290 twice
```

**Counterevidence / limits:**
- `0x3F7CC` sits inside the jump-table-dispatched region of `0x3C88C`. It is one of many adjacent case bodies (`0x3F7AC→0x4884C`, `0x3F7CC→0x48E30`, `0x3F7DC→0x57B54`, `0x3F7EC→0x55EE0`, `0x3F7FC→0x5870C`). Nothing shows it executes on every substep. So the path is `OBSERVED` static; “WF-002 is invoked once per substep, therefore its rate self-normalizes” is `INFERRED / LOW confidence`, not corroborated.
- The Kalidon A number (`2,595 / 48.767 s ≈ 53.2 hits/s`) has no preserved raw capture; only B (`2,585 hits / 2,585 active VBlanks ≈ 55.5/s`, 1 hit/VBlank) is raw. A ≈ 2 hits/frame at 30 FPS is *consistent with* one call per substep, but a derivation from B by `×2/60` is circular.
- My function-level call-graph reachability is unreliable in both directions because (a) leaf functions without prologues get merged into the preceding function (this produced a spurious “socle → frame limiter” edge), and (b) many dispatches are `jr $at` jump tables invisible to a `jal` graph. I therefore report only the explicit jal chain above, not “depth-N reachability”.
- V1’s local-JAL build did **not** touch Pokitaru WF-002 (its 15 sites are Navigate/Luna/doors/boat/dropship). Only V1’s broad “global-wrapper” build (`0xE394` → `nop`) would have affected it. So no historical Pokitaru measurement of a WF-002-specific change exists.

**Alternative normalization:** even if WF-002’s call rate is preserved, replacing the two-pass wrapper by one direct `jal 0xE290` is **not algebraically equivalent** to two passes at half rate. Two steps of `vel=(target−current)·k − vel·d; current+=vel` compose into a different map than one step with the same constants (and the clamp makes exact composition generally impossible). “ONE_PASS restores parity” is an approximation, not a proven root fix; a rigorous fix would preserve the number *and* size of smoothing steps per unit real time (e.g., one call at half rate, or root-composed coefficients).

## 6. A0 / B0 / B1 comparability, and the highest-information first ablation

- **A0** = vanilla 30 FPS; **B0** = NOP at `0x96650` only; **B1** = NOP + delta word `0x151E0 → 0x3C043C88` (substeps and `0x2FBBC` untouched).
- **Caveat that must be resolved before B0/B1 mean anything:** I could **not** establish statically that the gameplay update runs once per invocation of the frame-limit function. The NOP is inside `0x96490` (prologue `0x96490`), which is called only from `0x94B38` inside `0x94970`; the gameplay update `0x1517C` is reached from the main loop `0x1A41E0 → 0x13F0C → 0x159DC`. Whether these are the same cadence or different threads/loops is `UNKNOWN`. If they are decoupled, B0 may change render cadence only, and the whole “outer rate doubles” premise — hence the need for delta halving and substep reduction — is unproven.
- Initialization-time words (dropship/elevator, per the V1 README) mean both arms must be entered from the same cold boot/checkpoint; a savestate created under other patches is not comparable.
- **Highest-information first ablation:** after B0, run **B1 (delta-only)** before any substep or local-scalar arm. Rationale: the consumer table in §4 predicts B1 preserves both delta-scaled consumer classes exactly; therefore B1 vs B0 partitions the doubled effects into “delta-scaled” (fixed by B1) vs “per-call / not delta-scaled” (only then justifying the 2→1 substep change). Just as important, measure **call counts**, not only outcomes, in each arm — otherwise B0/B1 cannot be interpreted at all.

## 7. Claims that survive scrutiny

- The parent’s decode of `0x46006506` and `0x460C6500` (`mov.s f20,f12` / `add.s f20,f12,f12`) — OBSERVED, independently reproduced from raw words + field decode + Capstone.
- The four core words at RVAs `0x96650`, `0x151E0`, `0x2FCFC`, `0x2FBBC`, the ELF offset mapping, and the runtime↔RVA conversion for this file — OBSERVED.
- Single-caller chain `0x1517C → 0x2FFF0 → 0x2FB8C`, and `f12 = 1/30` (patched `1/60`) reaching `0x2FBBC` — OBSERVED.
- `0x360A4` is invoked once per outer call **outside** the substep loop; `0x32588` (delta countdowns), `0x328A0`, `0x42C04` are inside — OBSERVED.
- `player+0x578 = 30·f20` and is consumed as a decrement/divisor inside the loop — OBSERVED.
- The loop is gated by `player+0x95C & 0x8000`, and `0x2FCB4` writes a first-substep flag at global `0x2B0208` (1 on first iteration, 0 on second, forced to 1 after) — OBSERVED.
- Delta is a hardcoded constant, not wall-clock — OBSERVED.
- Pokitaru WF-002 = `jal 0xE35C` at RVA `0x4A3B8`; wrapper `0xE35C` calls helper `0xE290` twice — OBSERVED.

## 8. Weak, unsupported, or contradicted claims

- **“The outer rate doubles after the VBlank NOP.”** `INFERRED`, not established for `0x1517C`/`0x2FB8C` (see §6).
- **“Substeps 2→1 plus local doubling is the correct/root fix.”** The arithmetic shows it is correct for per-substep consumers *and* 2× too strong for the per-frame consumer `0x360A4`; no measurement supports it. It cannot be called root-cause.
- **“Local doubling preserves physics.”** It preserves per-substep delta budgets and `player+0x578`; it doubles the additive accumulators in `0x360A4` (whose gameplay consequence is UNKNOWN — no reader of `player+0x570/574/584/588/58C` was found outside `0x360A4` itself).
- **“WF-002 self-normalizes because it is inside the substep loop.”** A static path exists but is state-gated; no per-frame counts in Pokitaru; the 30 FPS Kalidon number is not raw. Weak.
- **“`0x353A4`, `0x32004`, `0x3BFF8`, `0x3C88C`, `0x32888` are player motion.”** Contradicted in part: `0x353A4` is flag-only, `0x32888` is a stub, `0x3BFF8`/`0x3C88C` are state dispatchers. Only `0x39B74` (and its `0x32588`/`0x328A0`/`0x42C04` descendants) shows position/timer integration.
- **“The four socle words were independently validated.”** Historical runtime addresses are version-specific; the file’s vanilla status rests on a hash match with a historical reference, not on an independent ISO extraction of `LEVEL_01.PRX` (contrast F2/`LEVEL_02`). The V1 README itself warns that its bundle’s `RAM.dump`/`LEVEL_02_clean.PRX` belonged to Ryllus.

## 9. Alternative explanations

1. **The two-iteration loop is a solver/refresh iteration, not a time step.** Then 2→1 changes solver quality, not real-time rate, and the local doubling is a misfix. The fact that `0x39B74` *resets* `player+0xA20..0xA2C` to a static vector each iteration is compatible with either reading.
2. **The gameplay update is not frame-rate-locked to `0x96490`.** Then B0 changes rendering only, and the player-clock symptoms are not caused by the removed wait.
3. **`player+0x570/584/588/58C` are per-frame bookkeeping consumed only through `0x1A5D68`**, so their 2× advance may be harmless — or harmful. UNKNOWN.
4. **WF-002’s flat hits/s is a provenance artifact** (derived A, different sessions, same-VBlank counting) rather than self-normalization.
5. **A single f20 is being overloaded** (per-substep physics + per-frame normalization + `30·delta` factors); the observed “accidental compensation” may be an inherent engine design, not a patch error.

## 10. Missing evidence

- Measured cadence of `0x1517C`, `0x2FFF0`, `0x2FB8C`, `0x360A4`, `0x39B74`, `0x1EBC4`, `0x4A158`, `0xE35C` in A0 and B0 (counts per second).
- Live `player+0x570/0x574/0x578/0x584/0x588/0x58C`, `0xA00/0xA08/0x9D4/0x9D8` in A0/B0/B1.
- Proof that `0x5A838` is the live player object. Status: the driver `0x2FFF0` hardcodes `lui $s0,6; addiu $s0,$s0,-0x57C8` → `s0 = 0x5A838` and passes it as `a0` to `0x2FB8C`; that is a strong static lead, but it is an in-module absolute, not a verified live pointer, and the same constant is reused in ~200 places.
- Whether `0x3F7CC` executes per substep or only in a specific player state.
- A raw 30 FPS WF-002 capture; per-frame counts for `0x4A158`.
- Independent ISO provenance for this `LEVEL_01.PRX`.

## 11. Strongest falsification attempt (analytic, performed)

Derive the per-consumer budgets and test whether any single choice of `(outer rate, substeps, delta, local factor)` keeps all consumers at their A0 real-time rate. Result: no. The full socle necessarily drives `0x360A4` (once per outer call) 2× faster in real time while keeping the in-loop consumers equal — unless outer cadence does not double. So the socle is **falsified as a universally rate-preserving transform**. I could not run the runtime version of this test (no emulator), so it remains an analytic falsification plus a prediction.

## 12. Best discriminating experiment (parent-only)

Read-only instrumentation, not a patch: in A0 and B0, log per-second entry counts of `0x1517C`, `0x2FFF0`, `0x2FB8C`, `0x360A4`, `0x39B74`, `0x1EBC4`, `0x4A158`, `0xE35C`, and sample the player fields above during a fixed idle + straight-line run. Three decisive reads:

1. Does the `0x1517C`/`0x2FB8C` cadence actually double in B0? (If not, the whole socle premise is void.)
2. Under B1, do `player+0x570/0x574/0x584/0x588/0x58C` and `0xA00/0xA08/0x9D4/0x9D8` advance per real second the same as A0?
3. Under the full socle, do the `0x360A4` accumulators advance 2× relative to A0 while the in-loop countdowns stay equal?

Then add the substep and local-scalar words only if B1 leaves a measured, delta-uncorrected discrepancy.

## 13. Unresolved points / falsifiable tests (summary)

- `UNKNOWN`: true outer cadence linkage between frame limiter `0x96490` and gameplay update `0x1517C`.
- `UNKNOWN`: identity/ownership of `0x148CEC` (only reader of first-substep flag `0x2B0208`; no direct `jal` caller found → indirect callback).
- `UNKNOWN`: gameplay meaning of `player+0x570/0x574/0x584/0x588/0x58C` and of the `0x1A5D68` call.
- `INFERRED/LOW`: WF-002 substep self-normalization (static path exists; frequency unproven).
- Falsifier list: outer cadence unchanged in B0; B1 accumulators already equal A0 while gameplay looks wrong; full socle accumulators 2× and gameplay wrong; `0x3F7CC` never executed during rail/grindrail segments; WF-002 hits/s doubles in a clean B0 raw capture.

**Bottom line for the parent:** the parent’s two decodes and the four words are confirmed from the binary. The strongest new finding is that `0x2FB8C` contains **two different delta-consumer classes** (per-substep and once-per-frame) fed by one scalar; the 2→1 substep change requires the local doubling for the per-substep class but necessarily over-drives the once-per-frame class (notably `0x360A4`). Delta-only (B1) is therefore the highest-information next arm, and the WF-002 substep explanation is only a plausible static path, not supported causality. No gameplay claim here is `TESTED`.