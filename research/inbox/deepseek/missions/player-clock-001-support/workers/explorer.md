I have completed the read-only investigation. Below is my Explorer report.

---

# PLAYER-CLOCK-001 — Explorer report (English, research input only)

## 0. Scope, method, limits

Read-only investigation. I did **not** launch or connect to PPSSPP, write RAM, patch code, or modify any project file (V1 or V2). No gameplay claim below is `TESTED`; at best it is `OBSERVED` (static binary / repository content) or `INFERRED`. All addresses are unrelocated module RVAs unless explicitly labelled "live" or "reference-base runtime".

Mission status at review time: `player-clock-001-support` = `RUNNING`, no worker reports present, `evidence/measurements`, `evidence/test-results`, `evidence/traces` all empty. So there are **no new persisted runtime player-clock observations** to compare yet — only static extracts.

## 1. Evidence found

### 1.1 Binary identity and mapping rule (independently re-verified)

- `L/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX`, SHA-256 `d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571` — matches the task and `parent-checks.json`.
- It is an ELF (`7F 45 4C 46`), 2 program headers, 54 sections, one loadable code segment with `p_offset=0x74`, `p_vaddr=0`. Empirically **file offset = RVA + 0x74** for the words checked. `e_shoff=0x2DD6C4`, `e_shnum=54`.

### 1.2 Core socle words — independently decoded from file bytes

| RVA | file off | word | decode |
|---|---|---|---|
| `0x96650` | `0x966C4` | `0x0C06FD09` | `jal 0x1BF424` |
| `0x151E0` | `0x15254` | `0x3C043D08` | `lui $a0,0x3D08` (+`ori 0x8889` → `0x3D088889` ≈ 1/30) |
| `0x2FCFC` | `0x2FD70` | `0x2A240002` | `slti $a0,$s1,2` |
| `0x2FBBC` | `0x2FC30` | `0x46006506` | `add.s $f20,$f12,$f0` (displayed `mov.s $f20,$f12`) |
| archive | `0x3690` | `0x3C043D08` | `lui $a0,0x3D08` (camera delta, RVA `0x361C`) |
| archive | `0x36A8` | `0x3C04BD08` | `lui $a0,0xBD08` (RVA `0x3634`) |
| archive | `0x17B800` | `0x3C044000` | `lui $a0,0x4000` (RVA `0x17B78C`) |

**Challenge to the old worker decode (resolved from encoding, not from agreement):**
`0x46006506` fields: fmt=16, ft=0 (`$f0`), fs=12 (`$f12`), fd=20 (`$f20`), funct=6 (ADD.S). `0x460C6500`: ft=12, fs=12, fd=20, ADD.S. The parent's `mov.s f20,f12` / `add.s f20,f12,f12` is **correct**; the old `mov.s f10,f6` / `add.s f10,f6,f12` decode would require words `0x46003286` / `0x460C3286`, which are not present. Same for `0x3C044000 → 0x3C043F80` (`lui a0,0x4000 → lui a0,0x3F80`, i.e. 2.0→1.0 high halves).

### 1.3 The Pokitaru player update `0x2FB8C` (OBSERVED decode)

Full decode is in the parent's new `research/v2/pokitaru/socle-dataflow.asm`; I re-read key words from the binary (file `0x2FCD4`=`0x0C00D829 jal 0x360A4`, `0x2FD24`=`0x2E240001`, `0x2FD28`=`0xA2440208 sb $a0,0x208($s2)`, `0x2FD58`=`0x0C00E6DD jal 0x39B74` + delay `0x4600A306`, `0x2FD64`=`0x0C007AF1 jal 0x1EBC4` + delay, `0x2FD6C`=`0x26310001`/`0x2A240002`, `0x30034`=`0xC7B40044` epilogue, `0x30168`=`0x0C00BEE3 jal 0x2FB8C`).

Structural facts (all OBSERVED static):
- `a0` = entity pointer → `s0`; `f12` = incoming scalar → `f20` (`0x2FBB8`, `0x2FBBC`).
- It stores the entity pointer to a module global at RVA `0x2B00C0` (`0x2FBC0/0x2FBC4`).
- Writes `{0,0,0,10000.0,0}` triple region at RVA `0x8FB30..0x8FB36` (`0x461C4000`=10000.0). Meaning **UNKNOWN**.
- Copies `+0xA20/+0xA24/+0xA28` → `+0xF6C/+0xF70/+0xF74` (`0x2FC68..0x2FC7C`), i.e. a saved copy of a 3-float vector, **outside** the substep branch.
- Branch: `if ((*(s0+0x95C) & 0x8000) != 0)` execute `0x2FCB0..0x2FD04` loop; else only `0x353A4` runs once (`0x2FD48`).
- Loop body, per iteration: writes the substep index byte to global RVA `0x2B0208` as `(s1<1)`; calls `0x353A4, 0x32004, 0x3BFF8, 0x3C88C, 0x32888` (all `a0=s0`, f12 untouched); then `0x39B74` and `0x1EBC4` **with `mov.s $f12,$f20`**. Counter `s1`, exit `s1<2`.

### 1.4 Callees carrying the scalar (key new finding)

- `0x360A4` (a0=s0, f12=f20) is called **before** the branch at `0x2FC60` (i.e. **outside** the substep loop, once per outer call). It advances several counters by the scalar: `0x570 += f20 + f(0x1a5d68)`, `0x574 += f20`, `0x578 = f20*30.0`, `0x584/0x588/0x58C += f20`, plus a conditional `0x57C/0x580 += f20`. It writes `f20` to `+0x56C`. This is the strongest static candidate for a player-facing **delta-driven timer/animation accumulator** in this function, and it is **not** inside the substep loop.
- `0x39B74` (called **inside** the loop, `a0=s0, f20=f12`) then: calls 11 sub-updates with `a0=s0` only; integrates a 3-vector `+0x30/+0x34/+0x38 += +0xA20/+0xA24/+0xA28`, plus `+0x2D0 += +0xA24` (`0x39C18..0x39C50`); then reloads `+0xA20..+0xA2C` from four consecutive floats at RVA `0x2CA358` and writes `(1.0,0,0)` at `+0xA30..+0xA38`. I read those constants from the binary: `0x2CA358 = {0.0, 0.0, 0.0, 1.0}`, `0x2CA2F8 = {1.0, 0.0, 0.0}`. So `+0xA20..` is a per-call **displacement/accumulator reset after use**, not the persistent position.
- `0x1EBC4` (called **inside** the loop, `a0=s0`) is a large update with a state dispatch (`sltiu` on `+0x9BC`, jump table at RVA `0x1C0450`), flag tests on `+0x95C` (`0x1000`, `0x800`) and pointer work on `+0x59C`. It is also called from `0x1E4E8` (different `a0`) and `0x1E610` with `f12=0`, so its `f12` argument is not universally meaningful.

Therefore, for the "animation inside vs outside the substep loop" question: the **only** evidence so far is that `0x360A4` (delta-driven counters) is outside, while `0x39B74`/`0x1EBC4` are inside. Per-callee ownership remains **INFERRED/UNKNOWN**; no animation system has been positively identified.

### 1.5 Player object identity (static, OBSERVED)

- `static-inventory/objects-by-level.csv`: `1,Pokitaru,Ratchet,...,0x002D6128,0x002D619C,0x001C88B8,...,callbacks 0x162F70;0x162FB0;0x162FB8;0x162FC0`, status "compiled descriptor; no assertion spawned or active".
- `development-v0.6.4-no-menu/sources/tables/object_descriptors.csv` gives the same descriptor with a **reference-base runtime address** `0x0940FE28` = `0x09139D00 + 0x2D6128`.
- `callbacks-by-level.csv` marks Ratchet ordinal 2 (`0x162FB8..0x162FC0`) as the `True` update callback; other ordinals kept for interaction/animation timing.
- Static inventory `candidate-sites.csv` contains 189 rows whose embedded source-path string is `c:/Hig/Projects/Rcp1/Code/CORE/Player/player.cpp` (13 per level). Pokitaru rows:
  - `0x2F400`: `+0x14` field multiplied by `0x3F333333` (0.7) at four sites (`0x2F6D4,0x2F708,0x2F73C,0x2F774`) — a genuine per-call multiplicative damping (frame-count-dependent decay candidate).
  - `0x379CC`: “Ratchet” + `+0x20/+0x24/+0x28` — but the surrounding code is `sqrt`/`div` unit-vector normalisation, i.e. a **false positive** for timing (the multiplier is `1/|v|`).
  - `0x4253C`: `+0x13C/+0x140/+0x144` — also a vector normalisation (false positive for timing).
  - `0x44268`: `PLAYER_UpdateBouncySprout`, integer `+0xA` increment per call (frame-counter candidate).
  - All marked `STATIC_CANDIDATE_NOT_APPLIED_NOT_LIVE_VALIDATED`; the `player.cpp` association is a proximity/string heuristic, not ownership proof.
- Embedded-string path `CORE/Player/grindrail.cpp` is the historical basis for WF-002's tentative naming (`history/6a86dce7…md` ~line 4624).
- No persisted capture of Ratchet's own position/velocity/animation fields exists.

### 1.6 Player-vehicle (ClankSaw) runtime observations (recorded, not re-run)

`connection/clanksaw-movement-plan.json` / `-result.json` / `clanksaw-rotation-plan.json` hold live addresses `0x09438B98..0x09438BB0` (RVA `0x2ECE98..0x2ECEB0` over the recorded base `0x0914BD00`) with floats forward cap 0.2→0.1, reverse cap 0.1→0.05, turn step 0.0785398→0.0392699, accel/brake/coast halved or quartered. `inventaire-2026-09-17/INVENTAIRE_MEMOIRE.md` also lists a **state** value `0x09CB3B00` (RVA not in-module: `0x09CB3B00 − 0x0914BD00 = 0xB67E00`), current vehicle velocity 0.02752→0.01376, explicitly "a state value, not a rule; has no meaning outside its session".

### 1.7 New V2 persisted artifacts vs V1 (created during this mission)

`research/v2/pokitaru/{extract-socle.py, socle-callers.json, socle-dataflow.asm}` (mtimes 2026-09-19 10:28, i.e. authored by the parent while this mission runs). They are **static only**.
- Consistency with V1: same PRX SHA-256 (asserted in the script); decoded words I re-checked match `parent-socle-context.asm` and `patch_ledger.csv` exactly.
- New relative to V1 review: the caller list `socle-callers.json` adds the caller chain `0x15260 (jal 0x2FFF0, delay mov.s f12,f20)` → `0x2FFF0` sets `s0` and `f20` → `0x300F4 (jal 0x2FB8C, delay mov.s f12,f20)`. So the delta `1/30` built at `0x151E0` reaches `0x2FB8C` through `0x2FFF0`.
- The script's own caveat is correct: "aligned direct JAL candidates only; no indirect calls; data false positives possible".

### 1.8 Candidate "player base 0x5A838" — resolved further (important)

- The literal `0x5A838` **is** in the code: RVA `0x30014/0x30018` = `0x3C100006` (`lui $s0,6`) / `0x2610A838` (`addiu $s0,$s0,-0x57C8`) → `s0 = 0x0005A838`, immediately used as `a0` for `0x2FB8C` (and dereferenced at `+0xD90` inside `0x2FFF0`). I verified both words from the binary.
- **New: this pair is relocated.** `.rel.text` is a PSP `SHT_PSP_REL` section (type `0x700000A0`, file `0x2DDF34`, size `0x63E90`, entsize 8). At file `0x2E8834` the entries are `(r_offset=0x00030014, r_info=0x00010005)` and `(r_offset=0x00030018, r_info=0x00010006)` — i.e. HI16/LO16 on exactly those two instructions, with a **non-zero reloc payload (0x100)**, unlike the neighbouring module-global pairs (e.g. `r_offset=0x2FBC4`, `r_info=0x00000006`). The ELF's own `.symtab` is stripped (section 51, size `0x10`, one null symbol), so the payload cannot be resolved from this file.
- Consequence: `0x0005A838` is a **link-time operand**, load-time adjusted. It must not be treated as a live address, and the relocated value (base+`0x5A838` would land in `.text`, which is implausible for an object) is not determinable statically here. The parent's caution is confirmed and now explained.
- The same exact 8-byte sequence appears in only `LEVEL_01.PRX` and `LEVEL_06.PRX` among the 15 reference modules (byte search), so it is not a universal per-level wrapper constant.
- Separately, `0x5A838` appears in V1 only as a **LEVEL_24 function node** (`0x5A838..0x5AC48`, callers `0x85AD0`, `0x18015C`) and in unrelated alignment slices — a second, unrelated source of confusion.
- Alternative static pointer locations in Pokitaru: module global RVA `0x2B00C0` (entity pointer store) and substep index byte RVA `0x2B0208` (both relocated pairs).

### 1.9 PPSSPP deterministic input / replay mechanisms (bundled build = PPSSPP v1.19.3)

Strings present in `03-Emulateur/PPSSPPWindows64.exe` (OBSERVED, `rg -a`): `input.buttons.send`, `input.buttons.press`, `input.analog.send`; `savestate.save/load/rewind`; `cpu.breakpoint.*`, `cpu.stepping`, `cpu.getAllRegs`, `cpu.getReg/setReg`, `memory.read/write`, `memory.breakpoint.*`; `game.pause/resume/reset/start/status`.
- Legacy use that actually ran: `derby-combat-capture.mjs` (and `derby-controller.mjs`) send `input.buttons.send {buttons:{start:true|false}}` while using `cpu.breakpoint.add/remove`; `ppsspp-probe.mjs` allows only `version`, `game.status`, `memory.read_u32` (read-only). WebSocket `ws://127.0.0.1:<port>/debugger`, subprotocol `debugger.ppsspp.org` (documented in `CONTINUITE.md`, with the PPSSPP 1.19.3 source links).
- No input-recording/TAS feature was found: the only `*Replay*` strings are graphics-related (`GPUReplay`, `ReplayClut`, `ReplayMemcpy`, `ReplayTex`) plus debugger GE-dump helpers; `BeginRecording`/`GPURecord`/`WebSocketGPURecordState` are AVI/GPU recording. Absence of strings is not proof, but there is no code/doc path in the repository for frame-indexed input replay.
- Relevant config (`01-Travail-et-profil-PPSSPP/PSP/SYSTEM/ppsspp.ini`): `RemoteDebuggerOnStartup=True`, `FrameSkip=0`, `AutoFrameSkip=False`, `CPUCore=1`, `FastMemoryAccess=False`, `GraphicsBackend=2 (D3D11)`, `EnableCheats=False`, `AnalogIsCircular=True`, `AnalogDeadzone=0.151114`, `AnalogSensitivity=1.1`. `CONTINUITE.md` warns that PPSSPP 1.19.3 memory reads can briefly suspend the CPU, so probes are for identification, not timing.

## 2. Provenance (main paths)

- `01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.3-generalisation/prx-reference/LEVEL_01.PRX` (hash above)
- `…/research/inbox/deepseek/missions/v1-parity-inventory/{sol-review.md,parent-checks.json,parent-socle-context.asm}`
- `…/research/v2/pokitaru/{extract-socle.py,socle-callers.json,socle-dataflow.asm}` (parent-authored, new)
- `…/research-2026-09-18-global/static-inventory/{objects-by-level.csv,callbacks-by-level.csv,candidate-sites.csv,functions-by-level.csv}`
- `…/research-2026-09-18-global/{patch_ledger.csv,prx_hashes.csv}`
- `…/development-v0.6.4-no-menu/sources/tables/object_descriptors.csv`; `…/inventaire-2026-09-17/INVENTAIRE_MEMOIRE.md`
- `…/research-2026-09-16/metalis/{README.md,prior-arena-static-rvas.json,prepare-evidence.py}`
- `…/connection/{clanksaw-movement-plan.json,clanksaw-rotation-plan.json,clanksaw-movement-result.json,disasm-*.txt}`
- `…/history/6a86dce7-2998-83eb-bf81-229c2835c35d.md`; `…/CONTINUITE.md`; `…/FONCTIONNEMENT_PLUGIN.md`
- `03-Emulateur/PPSSPPWindows64.exe`; `01-Travail-et-profil-PPSSPP/PSP/SYSTEM/ppsspp.ini`

## 3. Historical observations (with status)

- `OBSERVED (recorded history, not re-measured)`: WF-002 "2595 vs 2585 hits over ~48.8 s / 46.6 s"; Kalidon A 6.10 s vs B 3.05 s; acid rise ×2; Burner damage ×2; melee animation/damage desync; diagonal jump slowdown; crab failed jumps.
- `OBSERVED (static)`: the four socle words and their patch values; the conditional substep loop; the delta chain `0x151E0 → 0x2FFF0 → 0x2FB8C`.
- `INFERRED`: WF-002 is compensated by the substep change; `0x39B74` owns player position integration; `0x360A4` owns delta-driven timers; `0x1EBC4` owns a player state machine; `0x1BF424/0x1BF42C` are `sceDisplay` WaitVblank/GetVcount import stubs (they sit in section `.sceStub.text.sceDisplay` and their file bytes are `jr $ra; nop` stubs).
- `UNKNOWN`: ownership of `+0xA20..` and `+0x30/+0x34/+0x38`; meaning of the `0x8FB30` triple; which module/entity `0x2B00C0` points to at runtime; live value of the `0x5A838` operand.

## 4. Contradictions / counterevidence

- `history/…md` line 3397 `player.position += player.velocity * clock.renderDelta;` is a **hypothetical decompiled design sketch**, not an observation of the game. It must not be cited as game behavior.
- The `player.cpp`-labelled candidate rows at `0x379CC`/`0x4253C` are vector normalisations; the timing heuristic over-fires there. The `0x2F400` 0.7 multiply is a better frame-dependence lead but is still a proximity-labelled static candidate.
- `0x1EBC4` is called with `f12=0` and with a non-player `a0`; it cannot be assumed to be exclusively player-owned.
- The substep loop is conditional; the else path runs only `0x353A4`. Any "always 2→1" claim is invalid.
- The `0x5A838` pair is relocated; using the literal as a live pointer (or as a player base) is unsupported. The V1-level-24 function of the same number is unrelated.
- Historical addresses in `connection/*.json` and `inventaire-2026-09-17` are **live session addresses** (`0x09438B98`, `0x09CB3B00`, `0x0917764C`); `disasm-*.txt` in `connection/` are **LEVEL_04 (Metalis)** disassemblies (produced by `disasm-metalis.py` from LEVEL_04), so an RVA like `0x2FC34` means a Metalis function there and a `nop` inside the Pokitaru player loop in LEVEL_01. RVA numbers are module-scoped.
- WF-002's hit counts are recorded history with missing raw captures (V1 review §3); they do not by themselves establish the substep link.

## 5. Missing evidence

- No raw 30/60 player capture (position/velocity/animation phase) anywhere; `evidence/` empty.
- No live confirmation that `a0` at `0x2FB8C` is Ratchet, and no live value of the `0x5A838`-derived pointer, of `0x2B00C0`, or of `0x2B0208`.
- No ownership map for `0x39B74`, `0x1EBC4`, `0x360A4`, `0x353A4`, `0x32004`, `0x3BFF8`, `0x3C88C`, `0x32888` (no symbol/source evidence found locally).
- No evidence that the game exposes animation phase in a readable field.
- No PPSSPP input-replay artifact (only scripted button injection in one historical capture).

## 6. Open questions

1. Is `f20` at `0x2FBBC` the "1/30 fixed step" or the frame delta, and is it the same value that `0x360A4` treats as a timer delta?
2. Do `+0x30/+0x34/+0x38` (updated by `+0xA20/+0xA24/+0xA28`) hold world position, and does the substep loop double their slope per outer call?
3. Is the `0x360A4` counter set (outside the loop) halved correctly when the delta is halved, or does it double in rate when the outer cadence doubles?
4. Does anything in the loop depend on `s0+0x2B0208` (the substep index) or on the `0x353A4`-only branch, and does the flag `+0x95C & 0x8000` hold during ordinary Pokitaru movement?
5. What is the loader's live value for the relocated `0x5A838` operand?

## 7. Recommended next evidence to collect (cheap, falsifiable)

1. **Read-only pointer probe (parent-only):** breakpoint/one-shot at `0x2FB8C` entry (or `0x300F4`) and log `a0`, `*(0x2B00C0)`, and the value of `s0` after `0x30018`. This single capture resolves whether `0x5A838` relocated to a valid object and whether `a0` is Ratchet. No writes.
2. **Static callee resolution:** resolve the relocation payload for a HI16 at `0x30014` in PPSSPP's ELF loader (or Ghidra), i.e. confirm the relocation semantics; then re-derive the live operand. If needed, observe at runtime instead.
3. **Field-watch list for A0/B0/B1:** `+0x30/34/38` (candidate position), `+0xA20/24/28` (per-call displacement, resets to 0/0/0), `+0xF6C/70/74` (saved copy), `+0x2D0`, `+0x570/574/578/584/588/58C` (delta-driven counters), `+0x9BC`/`+0xF8`/`+0x95C` (state/flags). Record values once per render frame at a fixed scene; assert that `+0xA20..` is 0 at the end of each player update.
4. **Discriminating test for TD-03/TD-04:** at fixed scene and identical input, compare per-real-second growth of `+0x30/34/38` and of `+0x570..0x58C` across A0 / unlock-only B0 / delta-only B1 / substeps. If position slope is invariant while `0x360A4`'s counters double, animation/timer ownership is separate from the substep integrator.
5. **WF-002 path check:** confirm whether the `grindrail` callsites are reached from `0x353A4`/`0x39B74` or from an entirely separate callback; only then can "already compensated by substeps" be tested rather than assumed.
6. **Deterministic input harness:** reuse the proven pattern (`input.buttons.send` + `cpu.breakpoint`) and add `input.analog.send` for the diagonal-jump/straight-line protocol; drive it from CPU breakpoints (not wall-clock) so runs are comparable. Keep `FrameSkip=0`, `AutoFrameSkip=False`, fixed save, fixed module hash.

## 8. Explicit non-actions

Nothing was executed in the emulator; no RAM write; no patch; no profile/save modification; no V1 artifact changed; no file created. All binary decodes above were obtained by reading `LEVEL_01.PRX` bytes and the ELF relocation/section tables, plus reading existing repository text. The new `research/v2/pokitaru/*` artifacts are parent-authored and were only read and cross-checked.