# Lvl3Elevator progress half-step: experimental PRX copies

Status: **UNVERIFIED_STATIC_CANDIDATE**. This is an in-place, one-word-per-module file patch for UCES00420, not a validated gameplay fix or a complete 60 FPS plugin. It was built offline without starting PPSSPP. The original PRXs remain untouched.

The subsequent [Kalidon live test](../../../research/live-tests/kalidon/lvl3elevator-A0-C1-halfstep-REPORT.md)
**TESTED** the predicted half increment as a direct RAM pvar change on one
LEVEL_03 instance: A0 rides were 2.494–2.501 s, raw C1 rides 1.249–1.377 s,
and C1 half-step rides 2.528–2.544 s. The owner reported smoother motion and
an apparently unchanged duration. This did **not** load the edited PRX or
rerun its initializer; file-patch status remains unchanged. A small sampled
position-versus-progress difference and wider parity remain unresolved.

The owner chose a **companion PRX**, so the next delivery experiment is the
[isolated plugin overlay](COMPANION-PRX-EXPERIMENT.md). It adds the LEVEL_03
initializer word to the companion's guarded 60 FPS transaction. The ISO and
archived source stay untouched. The [live companion PRX test](../../../research/live-tests/kalidon/lvl3elevator-companion-PRX-REPORT.md)
subsequently **TESTED** fresh initialization and two near-A0-duration rides
on one Kalidon instance. This in-place file-copy recipe itself remains
**UNVERIFIED_STATIC_CANDIDATE** and is not the owner's delivery route.

## Causal basis

The accepted A0/C1 probe measured one `Lvl3Elevator` callback per outer frame, `s1+0x0C = 1/300`, and `s1+0x08 += 1/300` once per callback. The resulting ascent was 10.01 s in A0 and 5.00 s in C1. The immediate caller is the first group pump `jalr` at LEVEL_01 RVA `0x6B9B8`, established by the preserved true-stop return addresses.

In the class initializer, `lwc1 f12,4(s1)` loads `moveTime`, `div.s f12,f13,f12` computes `1/moveTime`, and the `lui a2,0x3D08` / `ori a2,a2,0x8889` pair builds float `0x3D088889` (1/30). `mtc1` and `mul.s` form `(1/moveTime)*(1/30)`, stored to `s1+0x0C`. During active motion, the callback loads `s1+0x08` and `s1+0x0C`, adds them, compares with 1.0 and stores progress. Changing the LUI to `lui a2,0x3C88` constructs `0x3C888889` (1/60) with the unchanged ORI. The static prediction for the measured C1 scene is a return to approximately 10 s ascent. The constant register is consumed by the increment multiplication; `a2` is overwritten after the store. No intervening use of `f13` was found before later calls and an explicit reload at LEVEL_01 RVA `0x156664`; this is a bounded static side-effect argument, not runtime parity proof.

| Module | LUI RVA | Before | After | Patched SHA-256 |
|---|---:|---:|---:|---|
| LEVEL_01 | `0x1563E8` | `0x3C063D08` | `0x3C063C88` | `18e31a5f586a272513d244dcb608e0cb325ad524dce651a93b99f8f7f4c9ba17` |
| LEVEL_02 | `0x16B050` | same | same | `9648389b6cee399c1e1e34669910da06b37c337d87f3a9b42b21711cf11a80f8` |
| LEVEL_03 | `0x153BF4` | same | same | `2ab316fdcef369ea8762c4957fc090045d4dae622eb39131f944556a9680949b` |
| LEVEL_07 | `0x166174` | same | same | `4723d1193386d19eab2605617c97adc7ccab1cfd0af14b301b037ecfb94497a5` |
| LEVEL_24 | `0x1367B8` | same | same | `f7aec89eeebbefa423d35c7b3d43e94e1ab2d8991b927100c671824f8be2ff6a` |

The five class copies are listed in the frozen disassembly corpus. No other module is claimed to contain this class. The `recipe.json` pins every vanilla image SHA-256 and four downstream context words for each site. Its LEVEL_02 source is the tracked vanilla reference; the differing external LEVEL_02 image is rejected by the hash guard.

## File construction and checks

`tools/prx/apply-inplace-recipe.py` produces the five copies in `build/` and a deterministic `build-manifest.json`. The tool requires a MIPS PRX (`e_type=0xFFA0`), maps each RVA through an executable file-backed PT_LOAD, verifies source hash and exact words, and rejects an edit at any listed relocation offset. Each copy preserves file length, ELF headers and relocation sections. The observed file difference is exactly two bytes inside one instruction word per PRX; no other byte is changed. The LUI sites have no relocation entry. The builder does not alter the source images and refuses an existing output with different bytes.

Rebuild with:

```powershell
python tools/prx/apply-inplace-recipe.py --recipe patches/experimental/lvl3-elevator-halfstep/recipe.json --output-dir patches/experimental/lvl3-elevator-halfstep/build
```

`build/` is intentionally excluded from Git; regenerate from the pinned sources. The generated manifest records patched hashes, file offsets, edit words and source hashes.

## Limits and required runtime gate

- The edit is **C1-only**. Loading this patched PRX while running A0 would make the elevator slower than vanilla. A final plugin must select it only for the corrected 60 FPS mode or use a mode-aware hook; a permanently installed copy is not an acceptable A0-preserving release.
- The initializer must run after the patched PRX is loaded. The prior savestate may already contain the old `s1+0x0C = 1/300`; resuming it is not a test of this file patch. Reload the level or create a new comparable state after initialization.
- The accepted probe confirms progress and duration, but not complete trajectory, animation, transition timing or other uses of the same class. A0, raw C1 and candidate C need matched measurements and visual checks before promotion.
- This one-word edit needs neither a code cave nor a new relocation. The global frame-unlock word at LEVEL_01 `0x96650` **does** have an `R_MIPS_26` relocation entry (raw `r_info=0x4`) and is not supported by this in-place writer. Blindly replacing that instruction while leaving its relocation is not a validated file patch.
- The existing gate-decimation RAM experiment is not a release correction: its visual regression was rejected. This recipe does not use it.

Next runtime experiment: when the owner supplies a PPSSPP session, after a guarded corrected-60 setup and a fresh level initialization, compare `s1+0x0C`, per-callback `s1+0x08`, ride duration, animation and level transition against the accepted A0 and raw C1 baselines. Restore original PRX/mode afterward. Do not create a separate PPSSPP instance for this candidate.
