I have enough independently verified evidence. Here is my skeptical report.

# DeepSeek Skeptic report — `timing-atlas-global-001`

Method: read-only byte-level ELF/PRX parsing and MIPS decoding (PowerShell 5.1, ConstrainedLanguage; `Get-Content -Encoding Byte -ReadCount 0` + `certutil` for hashes). No PPSSPP, no writes, no patches. Every figure below comes from my own reads, not from summaries. Model agreement is not used as evidence. All `0x…..` addresses are module RVAs.

Modules I hashed and used: LEVEL_01 `d10a81d0…6571`, LEVEL_02 `0037689a…bc8aa`, LEVEL_03 `4b6cf5e4…8b94`, LEVEL_04 `6896122a…dc37`, LEVEL_15 `cebd5b53…e70a`, LEVEL_21 `0e7a7f7d…d706`, LEVEL_16 `7bddff24…6914`, LEVEL_20 `f5a27498…1336`, LEVEL_22 `be7ef863…8986`.

Layout facts established first (needed to trust every RVA): LEVEL_01 phdr0 R+X off `0x74` vaddr `0` filesz `0x2DD104`; phdr1 R+W off `0x2DD178` vaddr `0x2DD108` filesz `0x1AC`; `.text` addr `0` off `0x74` size `0x1BF1AC`; `.data` addr `0x2A9E80` off `0x2A9EF4`; `.bss` addr `0x2DD380`; `.sceStub.text.sceDisplay` addr `0x1BF414` size `0x28` (5 stubs). **`RVA+0x74` is valid only for PT_LOAD#0.**

## 1. Claims that survive scrutiny (my independent decode)

- **Delta producer**: `0x151E0 lui r4,0x3D08` / `0x151E4 ori r4,r4,0x8889` / `0x151E8 jal 0x88768` / `0x151EC mtc1 r4,f20`. Byte-exact as reported.
- **Substep gate**: `0x2FCB0 = 0x2E240001 = sltiu r4,r17,1`; `0x2FCB4 = sb r4,0x208(r18)` with `r18 = 0x002B0000` ⇒ `0x2B0208`; tail `0x2FCF8 addiu r17,r17,1` / `0x2FCFC slti r4,r17,2` / `0x2FD00 bne r4,r0,-80`; post-loop `0x2FD08 ori r4,r0,1` + `0x2FD0C sb`. Gate = 1 (pass 0), 0 (pass 1), 1 (post). The parent-accepted reading is correct.
- **Loop body = 7 calls per pass** (`0x353A4, 0x32004, 0x3BFF8, 0x3C88C, 0x32888, 0x39B74, 0x1EBC4`) — but **only the last two receive the delta**, via delay slots `mov.s f12,f20` at `0x2FCE8`/`0x2FCF4`. The first five get `a0 = player` only.
- **`jal 0x360A4` occurs exactly once** in `.text`, at `0x2FC60`, i.e. inside `0x2FB8C` before the loop. Body verified: `+0x56C = delta`; `+0x570` fed with `0x3C88893B` (≈0.0166670 — note: **not** `0x3C888889`) into `0x1A5D68`; `+0x574…` `+= delta`; `lui 0x41F0` → `mul.s` at `0x360F0` → `+0x578`; `+0x584/588/58C += delta`.
- **N-VEL `0x328A0`**: deltas from `+0x30/34/38` minus `+0x26C/270/274` → `+0x27C/280/284`; then `lwc1 f12,+0x578`, `c.le.s f12,0`, and at `0x32900–0x3290C` `1.0f / (+0x578)` (`div.s`) times each delta → velocity stores `+0x28C/290/294`. Velocity-normalization use confirmed.
- **D `0x32588`**: subtracts the incoming delta from `+0xA00, +0xA08, +0xA14, +0xA18, +0xA0C`, and I verified **five separate clamp-to-zero blocks** (`c.lt.s`/`bc1f`/`swc1 0.0`) at `0x325D4…0x3266C`. Stronger than "clamps several".
- **N-TIMER `0x42C04`**: gate via `0x1E328 == 3`, `+0x9D8 = 10.0f`, and if `+0x9D4 == 0` then `+0x9D4 -= player+0x578` (`0x42C6C–0x42C74`) then clamp. The literal `-1.0` branch was outside my window (UNKNOWN in my session).
- **F60 inside `0x39B74`**: inline `lui 0x3C88 / ori 0x8889` at `0x39EB4/0x39EB8` → `f20` → `mov.s f12,f20` → `jal 0x16388` at `0x39EC8` and `0x39EE0`; `jal 0x16188` at `0x39EFC`.
- **LaserTracer local subsystem**: `DAT_002D2C04 = 0x41F00000 (30.0f)` in-file; `0x14CA70` computes `dt = 1.0/rate` (`div.s` at `0x14CA80`), stores `dt`→`0x2D2C08` and `rate`→`0x2D2C0C`, builds `dt*20.0f` (`lui 0x41A0`) → `0x2D2CA0`, and performs `c.eq.s rate,60.0f` at `0x14CB10` (`lui 0x4270` at `0x14CB08`, `bc1f` at `0x14CB18`) selecting `0x3F376E98` vs `0x3F036F4E`, with `0x3E86F633` also present in the region. Rate-aware subsystem: CORROBORATED by my own decode.
- **`0x2DD1F8`**: contains `0x0014CA70`, but only at file offset `0x2DD268` (second PT_LOAD mapping), and it is **one entry of a dense 8-byte-stride pointer table** (`0x2DD1E8:0x1379B8, 0x2DD1F0:0x144ABC, 0x2DD1F8:0x14CA70, 0x2DD200:0x15FFB0, 0x2DD208:0x162EEC, 0x2DD210:0x16EF48, 0x2DD218:0x17A26C`).
- **`0x148CEC` gated block**: `lbu r4,0x208` at `0x148D7C`, `beq r4,r0,+160` at `0x148D80` (block runs only when the gate is non-zero), and inside: `lwc1 f12,8(s1)` / `f20 = 1.0f` / `sub.s` / `swc1` (`0x148DF8–0x148E08`) ⇒ **`s1+0x8 -= 1.0f` per invocation, not delta-scaled**.
- **Frame/limiter site**: `0x9662C jal 0x1BF424`; `0x96638 jal 0x1BF42C`; `lw a0,0x6E58(0x002B0000)`; `+1`; `bne v0,a0`; `0x96650 jal 0x1BF424` (B0 site); `0x96658 jal 0x1BF42C`; `0x96664 sw v0,0x6E58`. The conditional second wait and its guard exist exactly as described; the `0x1BF42C` return value is compared against a stored incrementing counter.
- **Pokitaru elevator `0x1563E8`**: `div.s` (1/speed) then `× (lui 0x3D08/ori 0x8889 = 1/30)` → store `+0xC`, and `0.0f` → `+0x8`. `(1/speed)*(1/30)` confirmed.
- **Flamethrower global countdown**: `0x13BBFC lwc1 f12,0x1AFC(0x002D0000)`, `lui 0xBF80`, `add.s` at `0x13BC08` ⇒ `DAT_002D1AFC -= 1.0f` per call (per-call, not delta).
- **Kalidon acid `0x15AA84`**: `f12 = +0x34`, `f13 = +0x48`, `add.s`, store `+0x34` — a plain per-call `+=` with no delta.

## 2. Claims weak, unsupported, or contradicted

- **REJECTED (my own predecessor's claim)**: `timing-domains-crosslevel-001/workers/skeptic.md` §2/§8/§11 asserts `0x2FCB0 = sltiu at,s1,1`, "index-derived value dead", "byte = 0 inside the loop". The bytes are `0x2E240001 = sltiu r4,r17,1` (destination `a0`), and `0x2FCB4` stores exactly that register. The parent arbitration in favour of Explorer is right; the Skeptic claim was wrong and must not be reused.
- **"Seven functions per pass with the delta"**: only 2 of 7 are delta-parameterized.
- **"Single shared frame delta"**: the `1/30` literal is stamped per callsite — strict `lui 0x3D08 + ori 0x8889` occurs 59× (LEVEL_01), 60× (LEVEL_02), 65× (LEVEL_03), 55× (LEVEL_04); raw `0x3D088889` words 21/22/27…; FRONTEND has **zero** literal `30.0f` and `60.0f` words.
- **LEVEL_02 contamination premise is not reproducible today**: `Data/BIN/LEVEL_02.PRX` hash is `0037689a…bc8aa`, identical to `Data/BACKUP/BIN/LEVEL_02_clean.PRX` and `prx-reference/LEVEL_02.PRX`, and its substep immediate is `2` at `0x3415C` (two-pass). The one-byte variant is not what that path contains now; keep the provenance rule, but re-hash before letting "contaminated baseline" drive decisions.
- **"The wrapper corpus covers timing-relevant calls"**: LEVEL_16 and LEVEL_20 (absent from the 15-module corpus) contain the same literal families (30.0f × 76 / × 58, 60.0f × 20 / × 11) and the loop-tail pattern. Corpus completeness is contradicted.
- **"Every `60.0f` is refresh-rate support"**: LEVEL_01 holds 31 literal `60.0f` words and 81 literal `30.0f` words, but **exactly one** COP1 compare in the module is adjacent to a fresh `60.0f` build — the LaserTracer rate check. Per module, `cmp60` = 1 (LEVEL_01–10, 23, 24) or 0 (LEVEL_15, 21, 22, 16, 20, FRONTEND) against 2.9k–5.4k compares overall.
- **Implicit mapping rule `RVA+0x74`**: wrong for `0x2DD108…0x2DD2B4` (second PT_LOAD, e.g. the LaserTracer pointer table). Prior scripts of mine would have mis-read any target there.
- **The `addiu/slti/bne` tail is not a player-loop discriminator**: 41 matching windows in LEVEL_01 (immediates 2 and 6, e.g. `0xBA4`, `0x2D65C`, `0x2D830`, besides `0x2FCF8`), 35–60 per other module. Only the enclosing context (flag store + the 7-call sequence) identifies the player loop.
- **LEVEL_15 vs LEVEL_21**: near-duplicates, not distinct designs — identical size, **14 differing bytes**, all in `file 0x2359A4–0x2359DC` (RVA `0x235930…`), where the differences are the level index (`0x0F` vs `0x15`) and the path string `ART/LEVELS/level04_Giantclank/…gclank_art.mb.wad` vs `level07_Giantclank/…gclank_7_art.mb.wad`. For that pair RVAs are mutually transferable; elsewhere it must be verified per pair.

## 3. Alternative explanations

1. The `0x96650` site may be a **vblank resynchronization** (skip a vblank after an overrun), not a 30 FPS cap; B0's effect could then be small or state-dependent. The stub's identity is not decidable from the file (only library names are stored; no per-function import-name strings), so `WaitVblankStart` vs `GetVcount` is INFERRED from its returned-value use.
2. Many "x2" sites are **disguised delta consumers** rather than fixed-step movers: the camera computes `rate × 1/30` (`0x361C/0x3634`), so halving the constant is semantically right there, whereas the elevator's `(1/speed) × 1/30` is a per-call step that must become `× dt`, not `× 0.5`. Same literal, different correct treatment.
3. **Post-loop-gated systems break the pass-count intuition**: because the gate is 1 on pass 0 *and* 1 after the loop, `0x148CEC`'s block runs twice per outer call in vanilla (≈60/s at 30 outer/s) and would still run twice per outer call under a one-pass design (≈120/s at 60 outer/s). "One pass halves things" is false for this family.
4. The `1/30` literal family plausibly bundles ≥3 semantic families: disguised delta (`rate×1/30`), embedded-step (`(1/speed)×1/30`), and 30 Hz-reference normalization (`dt*30`).

## 4. Missing evidence

Runtime cadence (everything here is static); identity of each of the 5 `sceDisplay` imports; dispatcher/owner and per-object cadence of the `0x148CEC` table entry; the literal `-1.0` branch of `0x42C04` and the meaning of `+0x9D4/+0x9D8`; the `%3` site in `0x13BBEC`; semantics of `+0xA00…+0xA18`; LEVEL_16–20 identity; decoded semantics for all modules except LEVEL_01/02/03 spot checks (elsewhere I have counts, not meanings).

## 5. Strongest falsification attempts and results

1. "The gate byte is a stale mask register" → **falsified** by the `0x2E240001` decode.
2. "RVAs transfer across modules" → **falsified** for LEVEL_01 vs LEVEL_02 at `0x151E0`, but LEVEL_15≈LEVEL_21 is a counter-counterexample; the rule must be per-pair, verified.
3. "The 1/30 literal family is one delta domain" → **falsified** by the three distinct semantics above and 59 sites vs 1 patched site.
4. "Existing `1/60` sites are dormant under 30 FPS" → **falsified**: `1/60` is a live per-substep delta in the vanilla two-pass loop, implying ≈60 substeps/s.
5. "B0 doubles every gameplay callback" → **not falsified and not confirmed**. Static structure is limiter-compatible, but the removed call's identity and the resulting cadence remain UNKNOWN. This is the single most load-bearing untested premise of the whole atlas.

## 6. Best discriminating experiments (minimal, ranked)

1. Control (parent's, unchanged): A0→B0 outer cadence at `base+0x2FB8C` + loop counter (`base+0x2FCFC`) + `base+0x2B0208` byte + `state+0x574` slope.
2. Substep budget on A0: loop-body executions/s and `0x39B74` call rate — prediction ≈60/s (2 passes × 30 outer/s). If it is ≈30/s, the "1/60 per substep" reading collapses.
3. Post-loop-gated block: count `0x148CEC` gated executions or slope of `s1+0x8` in A0 vs the candidate C build — prediction: unchanged 2×outer ⇒ residual 2× symptom, falsifying "one pass fixes player-adjacent systems".
4. `+0x578` semantics: sample after `0x360A4` and check `+0x28C` velocity — A0 = 1.0, B1 = 0.5 with preserved velocity separates N-VEL from N-TIMER.
5. One non-player family each (elevator travel time; one enemy attack timer; one projectile lifetime; camera path) in A0/B0 — no static evidence yet shows they share the player clock.

## 7. Scanner corrections (deterministic)

Segment-aware RVA→file mapping per module (both PT_LOADs), never a global `+0x74`; strict same-register `lui`+`ori` pairs for `1/30` and `1/60` (raw `0x3C888889` occurs **0** times in LEVEL_01 `.text`; its 17 PH0 hits are data); loop-tail signature requires enclosing-context constraints (expect 35–60 raw hits/module); resolve the gate address from the store site's own `lui` base (never hardcode `0x2B0208`); `60.0f` comparisons only with an adjacent fresh `60.0f` build (≤1/module); restrict decode to `.text` and validate with section headers — my whole-PH0 counts (e.g. ~1.5k `div.s`-shaped words per module) are dominated by data.

## 8. Archetypes observed

O outer-delta integrator (`0x360A4`); S two-pass 7-call body with 2 delta-parameterized callees; D delta countdown with clamp (`0x32588`); N-VEL (`0x328A0`); N-TIMER (`0x42C04`); C per-call fixed decrement (`0x148CEC` gated `s1+0x8 -= 1.0`, Flamethrower `DAT_2D1AFC -= 1.0`); F30-as-disguised-delta (camera); F30-embedded-step (elevator); F60-per-substep (`0x39B74`); R rate-aware local subsystem (LaserTracer); E/H gate-driven post-loop family; V two unconditional + one conditional `sceDisplay` calls per limiter pass.

## 9. Must remain UNKNOWN

B0 cadence effect; `sceDisplay` stub function identities; whether NPC/projectile/camera/particle families share the outer cadence; `0x148CEC` dispatch ownership and per-frame invocation count; `+0xA00…+0xA18` and `+0x9D4/+0x9D8` semantics; `%3` damage path; LEVEL_16–20 identity. No file was modified; nothing here is TESTED.

<!-- PARENT_HANDOFF_V1 -->
```json
{
  "established": "L01: 0x2FCB0=0x2E240001 sltiu r4,r17,1, stored 0x2FCB4 into 0x2B0208; jal 0x360A4 once at 0x2FC60; 0x328A0 computes 1.0/(+0x578) then stores velocity +0x28C/290/294.",
  "corroborated": "LaserTracer 0x14CA70: dt=1/rate at 0x14CA80, c.eq.s rate,60.0f at 0x14CB10 (lui 0x4270 at 0x14CB08) picking 0x3F376E98/0x3F036F4E; DAT_2D2C04=30.0f; 0x2DD1F8=0x14CA70.",
  "inferred": "0x1BF42C-return is compared with a stored counter (counter-query-like); 0x1BF424 is wait-like; camera 0x361C/3634 is rate*1/30 disguised delta; 0x39B74 1/60-per-substep implies ~60 substeps/s.",
  "contradictions": "REJECTED own prior skeptic claim: 0x2FCB0 dest is a0 not at, gate=1/0/1. Data/BIN/LEVEL_02.PRX now hashes 0037689a (clean) with slti imm=2: contamination not reproducible. LEVEL_15 vs 21 differ by only 14 bytes.",
  "rejected": "Single shared 1/30 producer (59-77 per-call stamped literals/module); RVA+0x74 as universal file mapping (fails above 0x2DD108); bare addiu/slti/bne tail as a player-loop discriminator (41 hits in LEVEL_01); corpus covering all timing calls.",
  "unknown": "B0 cadence effect (UNTESTED); identity of each of the 5 sceDisplay import stubs; whether NPC/projectile/camera/particle families share the outer cadence; 0x148CEC dispatch cadence; semantics of +0xA00..+0xA18, +0x9D4/+0x9D8, %3 damage path.",
  "top_hypotheses": "H1: limiter removal doubles outer cadence only if 0x96650 is a real wait, unproven. H2: post-loop gate makes 0x148CEC's block run 2x per outer call, so one-pass designs leave it 2x. H3: F30 sites split into disguised-delta vs embedded-step.",
  "best_discriminating_test": "A0: count loop passes (base+0x2FCFC) and 0x39B74 calls/s; ~60/s with 2 passes confirms the 1/60-per-substep premise. Then compare 0x148CEC gated-block rate in A0 vs candidate C.",
  "blockers": "Static only, no runtime; sceDisplay import names absent from file so stub function identity stays INFERRED; no dispatcher resolved for the 0x2D4158 table; LEVEL_16-20 identity unverified.",
  "full_report_required": "yes: section 2 (byte-level rejection of the prior skeptic gate claim and the LEVEL_02 re-hash), section 7 (scanner mapping/pitfall spec), section 5-6 (falsification results and ranked runtime queue)."
}
```
<!-- /PARENT_HANDOFF_V1 -->