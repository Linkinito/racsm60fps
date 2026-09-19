# PLAYER-CLOCK-001 - DeepSeek Mapper Report

Scope: Pokitaru `LEVEL_01.PRX`, read-only static analysis. PRX SHA256 verified as `d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`. No emulator, RAM, code, profile, patch or save was touched. Tools: bundled Python 3.12 plus Capstone 5.0.7 from `analysis-deps`, with hand bit-field decoding for the two challenged words.

ELF mapping used below: segment 1 has `p_offset=0x74`, `p_vaddr=0`, `p_filesz=0x2DD104`; for every RVA in this report, `file_offset = RVA + 0x74`.

---

## 1. Core-word verification against the binary

| Name | RVA | File offset | Original word | Decode | Patched word | Decode |
|---|---:|---:|---|---|---|---|
| vblank wait | `0x96650` | `0x966C4` | `0x0C06FD09` | `jal 0x1BF424` | `0x00000000` | `nop` |
| delta | `0x151E0` | `0x15254` | `0x3C043D08` | `lui $a0, 0x3D08` | `0x3C043C88` | `lui $a0, 0x3C88` |
| substeps | `0x2FCFC` | `0x2FD70` | `0x2A240002` | `slti $a0, $s1, 2` | `0x2A240001` | `slti $a0, $s1, 1` |
| local player scalar | `0x2FBBC` | `0x2FC30` | `0x46006506` | `mov.s $f20, $f12` | `0x460C6500` | `add.s $f20, $f12, $f12` |

The delta patch keeps `ori $a0,$a0,0x8889` at `0x151E4`, so the full constants are:

- original: `0x3D088889` = `0.03333333507180214` (~1/30)
- patched: `0x3C888889` = `0.01666666753590107` (~1/60)

Hand decoding of the two challenged words:

- `0x46006506`: opcode COP1, fmt S, `ft=f20`, `fs=f12`, `fd=f20`, funct `MOV.S` → `mov.s f20,f12`.
- `0x460C6500`: opcode COP1, fmt S, `ft=f12`, `fs=f12`, `fd=f20`, funct `ADD.S` → `add.s f20,f12,f12`.

The old worker decode `mov.s f10,f6` / `add.s f10,f6,f12` is inconsistent with the actual `ft/fs/fd` fields and is **REJECTED**. The parent's independent decode is confirmed.

---

## 2. Structural map of the outer player-update chain

Direct `jal` scan of segment 1 gives the following single chain:

| RVA | Role | Caller(s) |
|---:|---|---|
| `0x1A40CC` | top-level per-tick callback; no direct `jal` caller in `.text` | indirect only |
| `0x13F0C` | high-level tick function | `jal 0x13F0C` at `0x1A41E0` |
| `0x159DC` | game-mode/state dispatcher | `jal 0x159DC` at `0x13FB0` |
| `0x1517C` | delta orchestrator / player subsystem entry | `jal 0x1517C` at `0x15AA8`, `0x15B18` |
| `0x2FFF0` | player-update wrapper | `jal 0x2FFF0` at `0x15260` |
| `0x2FB8C` | main player update | `jal 0x2FB8C` at `0x300F4` |

`0x1A40CC` has no direct `jal` caller; a 32-bit occurrence of `0x001A40CC` exists at file offset `0x33D1F4`, consistent with a relocated function pointer. Its registration is `UNKNOWN`.

### 2.1 Game-mode dispatcher `0x159DC`

- index source: `lui $s0,9; lw $a0,-0x3A50($s0)` → `a0 = *(0x8C5B0)`, then `addiu $a0,$a0,-1` (`0x15A58`).
- bounds: `sltiu $a1,$a0,0xB` (`0x15A5C`).
- jump table base: `lui $at,0x1C; addu $at,$at,$a0; lw $at,0x2C8($at); jr $at` (`0x15A6C`–`0x15A78`). Table at RVA `0x1C02C8`.
- case 3 → `0x15AA8` → `jal 0x1517C`.
- case 5 → `0x15B08`; `jal 0x1517C` at `0x15B18` only if `0xAA330()` returns nonzero.

So the whole player update runs in game-mode indices 3 and 5. `0x8C5B0` is a tentative game-mode selector.

### 2.2 `0x1517C` → `0x2FFF0` → `0x2FB8C`

- `0x1517C` builds `f20` at `0x151EC` (`mtc1 $a0,$f20`).
- `0x1517C` passes `f12=f20` to `0x87A84` (`0x1521C`), `0x6B7F4` (`0x15234`), `0x2FFF0` (`0x15264`), `0x6B618` (`0x1526C`). These are delay-slot moves; `0x7D510` at `0x15220` does **not** receive `f20` reliably because its delay slot is `nop` and `f12` may have been clobbered. That is a correction to the earlier broad statement that several arbitrary callees receive the delta.
- `0x2FFF0` stores `f20=f12` at `0x30024`, then at `0x300F4`/`0x300F8` calls `0x2FB8C` with `a0=s0=0x5A838` and `f12=f20`.

### 2.3 Player base `0x5A838`

- `0x2FFF0` sets `s0=0x5A838` via `lui $s0,6; addiu $s0,$s0,-0x57C8` (`0x30014`–`0x30018`).
- `0x2FB8C` stores the same pointer to global `0x2B00C0` at `0x2FBC4`.
- The object is used with fields at `+0x30`, `+0x38`, `+0x594`, `+0x5AC`, `+0x5B0`, `+0x95C`, `+0xA20`, `+0xF6C`, `+0xF80`, `+0xF84`, `+0xF88`, `+0xF97`, `+0xF98`, `+0xF9C`, and the loop callees use `+0xF8`, `+0x1F4`, `+0x204`, `+0x248`, `+0x2E8` on the same pointer.
- Status: `OBSERVED` static RVA; `INFERRED` player-object base; live pointer `UNKNOWN` and must be rebased by the current load base.

The whole object is passed unchanged to the dispatchers and loop callees, so `0x5A838` is a strong static lead for the live player object, not a verified live pointer.

---

## 3. Conditional substep loop `0x2FCB0`–`0x2FD04`

Guard:

- `0x2FC80`: `lw $a0,0x95C($s0)`
- `0x2FC84`: `andi $a0,$a0,0x8000`
- `0x2FCA0`: `beqz $a0,0x2FD48` → if bit 15 clear, only `0x353A4` is called.

Loop:

- `0x2FCA8`: `ori $s1,$zero,0`
- `0x2FCAC`: `lui $s2,0x2B`
- `0x2FCB0`: `sltiu $a0,$s1,1` → 1 on first iteration, 0 on second
- `0x2FCB4`: `sb $a0,0x208($s2)` → writes global `0x2B0208` (first-substep flag)
- calls, in order: `0x353A4` (`0x2FCB8`), `0x32004` (`0x2FCC0`), `0x3BFF8` (`0x2FCC8`), `0x3C88C` (`0x2FCD0`), `0x32888` (`0x2FCD8`), `0x39B74` (`0x2FCE4`, delay slot `mov.s f12,f20`), `0x1EBC4` (`0x2FCF0`, delay slot `mov.s f12,f20`)
- `0x2FCF8`: `addiu $s1,$s1,1`
- `0x2FCFC`: `slti $a0,$s1,2`
- `0x2FD00`: `bnez $a0,0x2FCB0`

After the loop:

- `0x2FD08`–`0x2FD0C`: sets `0x2B0208 = 1`
- `0x2FD10`: `jal 0x35964`
- if nonzero: `0x2FD20` `jal 0x35940`, `0x2FD28` `jal 0x4F2D0`

Else branch (`0x2FD48`): only `0x353A4` is called.

### 3.1 Critical distinction: per-substep vs first-substep-only

The loop body runs `2×` per outer tick in vanilla and `1×` per outer tick after the patch. For calls that run on **every** iteration:

- vanilla: `2 × 30 = 60/s`
- patched: `1 × 60 = 60/s` → preserved.

But code gated by `0x2B0208 == 1` runs once per `0x2FB8C` invocation in both versions:

- vanilla: `30/s`
- patched: `60/s` → **doubled**.

The only reader of `0x2B0208` found in the binary is inside `0x148CEC`:

- `0x148D78`: `lui $a0,0x2B`
- `0x148D7C`: `lbu $a0,0x208($a0)`
- `0x148D80`: `beqz $a0,0x148E20`

`0x148CEC` has no direct `jal` caller; it is likely an indirect callback. Its first-substep path clears `s1+0xD` and calls `0x148C50` (`0x148D88`–`0x148D94`); the flag-zero path jumps to `0x148FDC`. This is a concrete structural counterexample to the idea that the `2→1` patch normalizes all loop behavior: a first-substep-only path still runs once per outer tick and therefore doubles at 60 FPS.

### 3.2 Bit 0x8000 of `+0x95C`

Writers to bit 15 of `+0x95C` found in `0x353A4`:

- `0x353D0`: `ori $a1,$a1,0x8000`
- `0x3693C`: `ori $a0,$a0,0x8000`

The reset function around `0x2F840` sets `lui $a1,0x8000` = `0x80000000`, i.e. bit 31, not bit 15. Do not conflate these two flags. The exact condition under which `0x353A4` sets bit 15 is `UNKNOWN`.

---

## 4. In-loop callees relevant to player motion/animation

### `0x353A4` — state/flags entry
- Clears/sets several `+0x95C` bits, including bit 15.
- Writes `player+0xF8` at `0x36854` (`sh $zero`) and `0x37AD0` (`sh $a0`).
- Tentative: player state/flag transition entry.

### `0x3BFF8` — first behavior dispatcher
- `0x3C008`: `lh $a0,0xF8($s0)`
- `0x3C00C`: `sltiu $a1,$a0,0x49`
- table base `0x1C15E0` (`lw $at,0x15E0($at)`), 73 cases.
- Indexed by `player+0xF8`; sets several `+0x95C` and `+0x960` flags.

### `0x3C88C` — second behavior dispatcher and WF-002 owner chain
- `0x3C8B4`: `lh $a0,0xF8($s0)`
- `0x3C8B8`: `sltiu $a1,$a0,0x4F`
- table base `0x1C1708` (`lw $at,0x1708($at)`), 79 cases.
- It is called from the loop exactly once: `jal 0x3C88C` at `0x2FCD0` with `a0=player`.
- The function is huge: `0x3C88C`–`0x4129C`; there is no intervening `jr $ra` before the epilogue at `0x41280`–`0x4129C`.
- It writes `player+0xF8` at `0x3FC2C`, `0x40044`, `0x4079C`, so it can change the dispatch state for a subsequent substep.

### `0x39B74` — player movement/physics orchestrator
- `0x39B9C`: `mov.s $f20,$f12`.
- `0x39C18`–`0x39C44`: adds velocity components `+0xA20/+0xA24/+0xA28` into position `+0x30/+0x34/+0x38` **without** an explicit delta multiplication.
- `0x39D20`: `jal 0x32588` with delay slot `0x39D24 mov.s $f12,$f20` → `0x32588` receives the incoming delta.
- `0x39EB4`–`0x39EBC`: loads `0x3C888889` (1/60) into `f20`; passes it to `0x16388` twice and `0x16188` once. This is a hardcoded 1/60 inside vanilla `0x39B74`.
- Tentative: main player movement/state orchestrator.

### `0x1EBC4` — player state machine
- `0x1EBD4`: `mov.s $f20,$f12`.
- `0x1EBF4`: if `player+0xF8 == 0x21` (33), branch to `0x1EC18` → `0x1F36C` = function epilogue, i.e. state 33 skips the whole body.
- `0x1EC78`: `lw $a0,0x9BC($s0)`; jump table at `0x1C0450`, 13 cases.
- `0x1F2D0`: `jalr $a1` with delay slot `0x1F2D4 mov.s $f12,$f20` → the delta reaches an indirect callback.
- Tentative: player action/animation state machine.

### Pre-loop `0x360A4` — timer/accumulator update
- Called once per `0x2FB8C` invocation at `0x2FC60`, with delay slot `0x2FC64 mov.s $f12,$f20`.
- `0x360B4`: `mov.s $f20,$f12`.
- Adds `f20` to `player+0x570`, `+0x574`, `+0x584`, `+0x588`, `+0x58C`, `+0x57C`, `+0x580`, and multiplies `+0x578`.
- Because it is pre-loop and receives the locally doubled `f20`, the structural prediction is that its per-second accumulation doubles at 60 FPS under the full socle. This is an accidental-compensation candidate, not a proven defect.

### Post-loop animation/event dispatch
- `0x2FEF0`: `jal 0x6D1DC` with `a2 = player+0xF98`.
- `0x2FF8C`: `jal 0x8A9F4` with a table indexed from the flag word built at `0x2FE6C`–`0x2FF94`.
- These run once per `0x2FB8C` invocation, outside the substep loop, with no `f20` passed. They are candidates for 2× at 60 FPS.

---

## 5. WF-002: is there a supported structural path?

**Yes.** The path is:

```
0x2FB8C (player update)
  -> 0x3C88C (called at 0x2FCD0, inside the substep loop)
       -> dispatch index = signed halfword at player+0xF8, table 0x1C1708
            index 31 (0x1F) -> 0x3F7BC -> jal 0x48E30 at 0x3F7CC
            index 33 (0x21) -> 0x3F7EC -> jal 0x55EE0 at 0x3F7EC
       -> 0x48E30 -> jal 0x4A4F0 at 0x48E7C
       -> 0x4A4F0 -> jal 0x4A158 at 0x4A6F0 (also 0x4A818, 0x4AA3C, 0x4AB90, 0x4ABE8, 0x4AE9C)
       -> 0x570F0 -> jal 0x4A158 at 0x57204 (also 0x5738C, 0x574BC)
       -> 0x4A158 -> jal 0xE35C at 0x4A3B8   <-- WF-002 wrapped helper
```

Verified call-site chain:

- `jal 0x3C88C`: only `0x2FCD0`.
- `jal 0x3BFF8`: only `0x2FCC8`.
- `jal 0x48E30`: only `0x3F7CC`.
- `jal 0x55EE0`: only `0x3F7EC`.
- `jal 0x4A4F0`: only `0x48E7C`.
- `jal 0x570F0`: only `0x56008`.
- `jal 0x4A158`: 10 sites, all inside `0x49018`, `0x4A4F0` or `0x570F0`.
- `jal 0xE35C`: 55 sites; the WF-002 profiler callsite in Pokitaru is `0x4A3B8`, which matches the `wrapper_callsites.csv` owner `0x4A158` and callsite `0x4A3B8`.

Arguments at the WF-002 boundary:

- `0x4A4F0` sets `a1 = player+0x2E8` at `0x4A6EC`, then `a0 = player` and calls `0x4A158`.
- `0x570F0` does the same at `0x57200`/`0x57204`.
- `0x4A158` reads orientation fields `player+0x1F4`, `+0x1F8`, `+0x1FC`, `+0x204`–`+0x20C`, `+0x214`, `+0x224`–`+0x22C`, `+0x248`, `+0x250`, `+0x254`, `+0x258`, `+0x25C`, `+0x260`, `+0x268`.
- `0x4A158` calls `0xE35C` with `a0 = player+0x248`, `a1 = player+0x250`, `f13 = player+0x254`, `f14 = player+0x258`, `f15 = player+0x25C`.

### 5.1 Rate relationship

- `0x3C88C` is called once per substep, so the substep patch preserves its per-second rate: `2 × 30 = 1 × 60 = 60/s`.
- `0x3C88C` does not receive `f20`; its delay slot is `move $a0,$s0`. The delta patch therefore does not directly reach the WF-002 chain. The substep patch is the supported normalization mechanism for WF-002.
- In state 31 or 33, each `0x3C88C` invocation reaches `0x48E30` or `0x55EE0`, hence `0x4A158`, hence `0xE35C` at `0x4A3B8` (subject to the branch below).

### 5.2 Important counterevidence: WF-002 is an event count, not a raw clock

`0x4A158` has an early exit at `0x4A308` that skips the `0xE35C` call:

- `0x4A2A4`: `c.lt.s $f28,$f12` with `0x3C8B4396` ≈ `0.017`
- `0x4A2AC`: `bc1t 0x4A308` → early exit
- `0x4A2C4`: `c.le.s $f14,$f12` with `0x38D1B717` ≈ `1e-4`
- `0x4A2CC`: `bc1t 0x4A308` → early exit

Additional thresholds in the same function include `0x4047F1E6` ≈ `3.1241393`, `0x3A83126F` ≈ `0.001`, `0x3FC90FDB` ≈ `1.5707964`, `0x3E99999A` ≈ `0.3`, `0x3DCCCCCD` ≈ `0.1`.

Therefore the WF-002 hit count is an orientation-event count conditioned on the player's angular state, not a pure call counter. The reported A/B similarity (about 53–55 hits/s) cannot by itself prove self-compensation; it can also arise from the orientation trajectory crossing the threshold at different rates.

---

## 6. Candidate timing mechanisms

1. **Outer cadence (TD-01):** the `0x96650` patch removes one VBlank wait in the frame-pacing function around `0x96490`, so the outer tick runs 1×/VBlank instead of 1×/2 VBlanks.
2. **Explicit delta (TD-02):** `0x151E0` builds 1/30; the patch makes it 1/60. The delta reaches `0x87A84`, `0x6B7F4`, `0x2FFF0`, `0x6B618` (and through them the player chain).
3. **Conditional player substeps (TD-03):** the `0x2FCB0`–`0x2FD04` loop runs 2× or 1× depending on the patch and on `player+0x95C` bit 15.
4. **Local player scalar (TD-04):** `0x2FBBC` doubles the incoming delta for `0x360A4`, `0x39B74` and `0x1EBC4`.
5. **First-substep flag (new):** global `0x2B0208`; read by `0x148CEC`. First-substep-only code runs once per outer tick and doubles at 60 FPS.
6. **Behavior dispatch on `player+0xF8` (new):** the two in-loop jump tables `0x3BFF8` (base `0x1C15E0`, 73 cases) and `0x3C88C` (base `0x1C1708`, 79 cases). WF-002 is in the second table at indices 31 and 33.
7. **Pre-loop timer/accumulator (new):** `0x360A4` updates `player+0x570`–`+0x58C` with the locally doubled delta once per outer tick.
8. **Post-loop animation/event dispatch (new):** `0x6D1DC` and `0x8A9F4` run once per outer tick, outside the substep loop.
9. **WF-002 event threshold (new):** the `0x4A158` early-out at `0x4A308` makes WF-002 state-dependent.

---

## 7. Cross-level and cross-system relationships

- Historical `patch_ledger.csv` shows the same four core word pairs in all solo modules (`LEVEL_01`–`10`, `15`, `21`–`24`), but the surrounding player-function RVAs differ (e.g. LEVEL_02 `0x34020`, LEVEL_03 `0x2DF64`, LEVEL_04 `0x30EC4`, LEVEL_07 `0x2FCB8`). The mechanism appears shared; exact function identity per module is not established here.
- WF-002 has one callsite per module in 15 modules, with per-module owner RVAs (Pokitaru `0x4A158`, Ryllus `0x4EA0C`, Kalidon `0x48718`, Metalis `0x4B750`, Dreamtime `0x47CD8`, etc.). The helper signature is shared, but the owner chain must be re-mapped per module.
- Reusable module-relative globals found in Pokitaru:
  - `0x8C5B0`: tentative game-mode selector for `0x159DC`.
  - `0x2B00C0`: tentative current-player pointer, written by `0x2FB8C`.
  - `0x2B0208`: first-substep flag, written by `0x2FB8C`, read by `0x148CEC`.
  - `0x2B6E58`, `0x2B6E50`, `0x2B6DF4`: frame-pacing state used around the VBlank patch.
- The profiler wrapper families are instrumentation, not vanilla code. WF-002's TWO_PASS policy is a V2/profiler decision; the vanilla code path is the direct `jal 0xE35C` at `0x4A3B8`.

---

## 8. Competing interpretations

**A. Substeps normalize WF-002 (best supported structurally).**
`0x3C88C` is per-substep; `2×30 = 1×60`; WF-002 is downstream of `0x3C88C` at +0xF8 indices 31/33. Prediction: B2 (unlock + substep only) restores WF-002 to A0; B1 (unlock + delta only) leaves it doubled.

**B. Delta normalizes WF-002.**
The owner `0x4A158` uses vector/angle math and may be influenced by the delta through the player state. However, `0x3C88C` gets leftover `f12`, not `f20`, so there is no direct delta path to WF-002. Prediction: B1 restores WF-002; B2 leaves it doubled.

**C. WF-002 is state-trajectory dependent.**
The early-out at `0x4A308` and the `+0xF8` dispatch make the hit count an event count, not a clock. The reported similar A/B rates could be coincidence or a state-trajectory effect. Prediction: repeated A0/B0 measurements with different input sequences will not show a clean ×2 relation.

**D. Accidental over-compensation of per-outer-tick code.**
`0x360A4` receives the locally doubled `f20` once per outer tick, so its accumulators are predicted to be 2× at 60 FPS under the full socle. `0x148CEC`'s first-substep path is predicted to be 2× for the same reason. Prediction: B3 shows these at 2× while the in-loop callees are normalized.

**E. Animation ownership is split.**
In-loop `0x1EBC4` and `0x3C88C` are substep-preserved; post-loop `0x6D1DC`/`0x8A9F4` and pre-loop `0x360A4` are outer-tick-driven. Prediction: animation/event behavior in the first group tracks A0, while the second group doubles in B0/B1/B2/B3.

---

## 9. Uncertainty and missing evidence

- `player+0x95C` bit 15 semantics: `UNKNOWN`; "substep enable" is tentative.
- `player+0xF8` semantics: `UNKNOWN`; indices 31 (0x1F) and 33 (0x21) select WF-002. That 0x21 is a grindrail/treadmill state is `INFERRED` from the profiler context, not proven.
- `0x5A838` live pointer: `UNKNOWN`; static RVA only.
- `0x148CEC` owner/caller: `UNKNOWN`; no direct `jal`.
- `0x360A4` field semantics (`+0x570`–`+0x58C`): `UNKNOWN`.
- `0x4A158` / `0xE35C` exact formula and threshold meaning: `INFERRED`.
- No live load base, relocation delta, or RAM check was performed; all runtime addresses must be computed as `load_base + RVA`.
- No controlled A0/B0/B1/B2/B3 rate measurement exists in this static pass. All rate predictions above are `INFERRED`.
- The historical A-side raw trace for WF-002 is still missing, so the reported A/B hit counts cannot be independently rederived.

---

## 10. Best deterministic test to distinguish the candidates

Use the parent's PPSSPP orchestration (parent-only) on a controlled Pokitaru treadmill/grindrail scene with deterministic input. Instrument these module-relative RVAs (add the live load base):

- `0x2FCD0` — `jal 0x3C88C` (per-substep dispatcher call count)
- `0x2FC80` — load of `player+0x95C` (log bit 15)
- `0x3C8B4` — `lh $a0,0xF8($s0)` (log dispatch state)
- `0x3F7CC` / `0x3F7EC` — WF-002 path entries
- `0x4A3B8` — `jal 0xE35C` (WF-002 helper hits)
- `0x2FC64` — `mov.s $f12,$f20` before `0x360A4` (log `f12`, then read `player+0x570`–`+0x58C`)
- `0x2FCE8` / `0x2FCF4` — `f12` passed to `0x39B74` / `0x1EBC4`
- `0x148D7C` — first-substep flag read; log whether the branch at `0x148D80` is taken

Arms: A0 = vanilla 30; B0 = unlock only; B1 = unlock + delta only; B2 = unlock + substep only; B3 = full socle (unlock + delta + substep + local doubling). Keep the wrapper policy fixed, all other patches off, same save and input sequence, repeat at least 3 times.

Structural prediction table:

| Observable | A0 | B0 | B1 | B2 | B3 |
|---|---:|---:|---:|---:|---:|
| `0x3C88C` calls/s (per substep) | 60 | 120 | 120 | 60 | 60 |
| WF-002 path entries/s (state 31/33) | 60 | 120 | 120 | 60 | 60 |
| `0x39B74`/`0x1EBC4` calls/s | 60 | 120 | 120 | 60 | 60 |
| delta sum/s for those two | 2 | 4 | 2 | 2 | 2 |
| `0x360A4` calls/s | 30 | 60 | 60 | 60 | 60 |
| `0x360A4` accumulator slope | 1× | 2× | 1× | 2× | 2× |
| `0x148CEC` first-substep path/s | 30 | 60 | 60 | 60 | 60 |

Discriminators:

- If B2 restores WF-002 and B1 does not → interpretation **A** (substeps normalize).
- If B1 restores WF-002 and B2 does not → interpretation **B** (delta normalizes).
- If neither restores it → interpretation **C** (event-rate/state dependence).
- If B3 shows `0x360A4` or `0x148CEC` at 2× while the in-loop callees are normalized → interpretation **D/E** (split ownership and accidental over-compensation).

The WF-002 hit rate alone is not a sufficient test because of the `0x4A308` early-out; always log `player+0xF8` and the orientation thresholds alongside the hit count.

---

## 11. Evidence status summary

- `OBSERVED`: PRX hash and ELF mapping; all core words and decodes; all `jal` call sites listed above; the `0x2FCB0` loop structure; the `0x2B0208` writer/reader; the two `+0xF8` jump tables and their WF-002 entries; the WF-002 chain `0x3C88C → 0x48E30/0x55EE0 → 0x4A4F0/0x570F0 → 0x4A158 → 0xE35C`; the `0x4A308` early-out; the `0x360A4` accumulator field offsets.
- `INFERRED`: `0x5A838` as the player object base; the per-substep vs first-substep rate distinction; WF-002 normalization by the substep patch; `0x148CEC` as an indirect per-substep callback; the `0x360A4` and post-loop animation 2× predictions; the game-mode and state-ID semantics.
- `UNKNOWN`: live load base and pointer; bit 15 and `+0xF8` semantics; `0x148CEC` owner; `0x360A4` field meanings; `0x4A158`/`0xE35C` exact semantics; all measured rates.
- `REJECTED`: the inherited decode `mov.s f10,f6` / `add.s f10,f6,f12`; the claim that `0x7D510` reliably receives `f20` (delay-slot analysis).
- No claim in this report is `TESTED`; all rate relationships are structural predictions requiring the controlled ablation above.