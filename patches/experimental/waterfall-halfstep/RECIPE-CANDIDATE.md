# Waterfall half-step — RECIPE CANDIDATE (BUILT LOCAL, NOT APPLIED)

Status: candidate with a **local guarded build** (not installed, not applied to
any game image, never tested). Prepared offline 2026-09-23 following
`reports/NEXT-SESSION-PACK-2026-09-23.md` §1 and the project rules for
experimental work.

## Target

- Source: `02-Jeu-et-dumps/Data/BIN/LEVEL_01.PRX`, SHA-256
  `d10a81d076fb44987a45314a020cda2f7e8b39f860b957911ca9365464676571`
  (tracked vanilla; verify again at build time).
- The waterfall-only constant block `0x2D4880..0x2D489C` is read only from
  inside the waterfall function (9 `lwc1` sites, `0x151E78..0x152054`).
- Intended edits (C-mode image only; A0 keeps the vanilla PRX):

| RVA | before | after | meaning |
| --- | --- | --- | --- |
| `0x2D4890` | `0x3C888889` | `0x3C088889` | 1/60 → 1/120 (per-call phase step) |
| `0x2D4894` | `0x3CCCCCCE` | `0x3C4CCCCD` | 0.025 → 0.0125 (second channel) |

- Relocation check: both words and their block neighbours are **not** in the
  PSPREL table (verified against the 54 801-entry relocation set). In-place
  editing is mechanically compatible, subject to the writer's before/context
  checks.
- Unchanged on purpose: the integer `+0x79` step, the `pvar+0x08` parity gate,
  and every other object's constants. One field edit cannot claim
  whole-object parity.

## Build record (2026-09-23)

- Recipe: `recipe.json` in this directory, SHA-256
  `e856d3f9d9b3f5a63c5406b8efe53781869872b7f54c0b99384a8cf1dc6fe32b`.
- Dry run: PASS (1 guarded module). Build:
  `python tools/prx/apply-inplace-recipe.py --recipe .../recipe.json --output-dir .../build`.
- Output (local only, `build/` is git-ignored): `build/LEVEL_01.PRX`,
  patched SHA-256 `93ce8ae6105c582bd4c988c7ac9479818187106c034b0aeece71461797835e9a`,
  **3 changed bytes** (1 in the 1/60 word, 2 in the 0.025 word), size and
  headers unchanged, 54 801 relocation entries scanned. Manifest:
  `build/build-manifest.json`.
- Nothing was installed into PPSSPP and no savestate was written. The runtime
  test (acceptance §) remains pending an owner session; A0 must keep the
  vanilla PRX.

## Acceptance and falsifiers

Acceptance table: `reports/NEXT-SESSION-PACK-2026-09-23.md` §1 (cycle period
ratio ±1 % over 3 repetitions; per-call steps of the four traced fields over
30 calls; state transitions; neighbouring group objects unchanged in the same
session). Falsifiers: the cycle stays ~2× fast; A0 per-call steps drift; any
neighbouring group consumer changes. If falsified, record the result here and
revert to the channel table — do not iterate blindly.
