# CURRENT_STATE — Overcompensated V2 checkpoint

Updated: 2026-09-23, branch `v2-research`. Actual HEAD on this session's
resume: `0bc71c0`; remote `v2-research` was `fa23a24`. Verify actual HEAD,
remote and worktree again next session. Many unrelated owner/worker changes
are dirty or untracked; stage only owned paths.

Priority 0: UCES00420 original A0 30 FPS -> faithful 60 FPS behavior.
B0 = uncapped; B1 = B0 + 1/60 delta; C1 = B1 + one player substep.
Owner requires a **companion PRX**, not an ISO patch. Never edit the ISO or
original game PRXs. Keep experimental work under `patches/experimental/`.

## Lvl3Elevator: current result

- A0 versus raw C1 established a fixed per-callback progress step: raw 60 FPS
  rides roughly halve A0 duration. A direct C1 RAM half-step restored near-A0
  duration. A freshly initialized LEVEL_03 instance under the earlier v3
  companion acquired the half-step without a RAM pvar write. PRX guards and
  code readback passed; both ride directions completed.
- Matched fresh Kalidon direction-1 A0/v3 PRX rides measured 2.497471 /
  2.541371 s (C1 +1.76%), with identical sampled endpoints. Owner perceived
  same animation, arrival and interaction, smoother at 60 FPS. The gap cause
  remains UNKNOWN, but owner accepts it provisionally for this comparison;
  this is no general tolerance or validated game-wide parity.
- Equal recorded-progress XYZ differs because the callback stores XYZ from
  old progress before incrementing the pvar. Shifting the C1 curve back one
  half-increment collapses A0/C1 central-path RMS to ~0.0016-0.0018. Do not
  add another correction based only on the equal-progress difference.
- A PPSSPP savestate load left the already-created elevator vanilla/plugin
  unarmed. Fresh initialization after a normal in-game save/re-entry was the
  valid PRX test. No savestate was written.
- **v4 generalizes one companion PRX to all five known `Lvl3Elevator` copies:**
  LEVEL_01/02/03/07/24, initializer RVAs `0x1563E8/0x16B050/0x153BF4/
  0x166174/0x1367B8`. Builder hash-checks each original PRX and exact nearby
  words. Compiled global-60fps C gate limits arming to these five modules;
  their descriptor joins the guarded preflight/install/readback/rollback path.
  INI `allowed_module=0` is narrowed by this C gate; the INI-only validator's
  all-15-module aggregate must not be mistaken for runtime scope.
- v4 PRX SHA-256 `0e3982d14926ed66eb8b4107bcfd7756d473fa2b2722468e8a5cf5a8ed778d39`,
  82,294 bytes. Existing toolchain build passed `-Wall -Wextra -Werror`;
  archived PRX validator PASS 912 checks. Per-module policy checks PASS for
  55/57/33/46/23 callsites. The v4 PRX and its four new routes have **not**
  been observed in game; remain experimental.
- v4 PRX/config installed in `PSP/PLUGINS/Lvl3ElevatorExperimental` with
  package hashes verified. Previous v3 files backed up under ignored
  `patches/experimental/lvl3-elevator-halfstep/build/installed-before-v4/`.
  PPSSPP was closed; global `EnablePlugins=False`, experimental UCES00420=false.
  The plugin remains disabled. No ISO, game PRX or savestate write.
- Owner clarified that **generalization means all objects sharing a timing
  mechanism**, not just all elevator copies. The v4 build is one reusable
  component, not the generalization objective. Do not repeat elevator-only
  tests as the main research path.

## Other durable constraints

- Owner publication decision: GitHub receives curated development progress
  and critical source/docs only. Raw measurements and experiment files stay
  local. A bulk push of the research branch was rejected by GitHub because
  `gate-001/raw-cave-watch.json` exceeds 100 MB. A temporary LFS migration
  branch was not published; original `v2-research` was restored to its exact
  pre-migration commit before the next local docs commit. Publish only an
  explicit critical-file allowlist. Exact handoff:
  `research/tasks/curated-github-publication-2026-09-23.md`.

- Parent synthesis: `reports/GLOBAL-TIMING-FAMILY-PLAN-2026-09-23.md`.
  The correction unit is **one measured behavioral channel in a known
  dispatch domain**. Linear fixed steps can be scaled only after measuring
  eligible calls/s; incoming-delta channels may already be correct; integer
  lifetimes, event damage, thresholds and gates need consumer-specific tests.
  No bulk `1/2` rewrite. Flamethrower phase is TESTED preserved; owner's Mungo
  damage observation remains an unverified separate channel, so do not halve
  its damage yet. Waterfall's short, measured outer cycle is the first new
  non-elevator companion-rule target. The plan adds no new runtime evidence.
- Owner added visual Priority 0 scope: box debris, Pokitaru butterflies and
  `SharkgatorFin`, level-up animations and similar non-interactive effects.
  Their callback bindings and A0/B0/C1 behavior are UNKNOWN. The plan now
  requires separate count, trajectory, animation-period, lifetime/fade and
  one-shot duration checks; no blanket half-scaling of cosmetic updates.
- Group `+0x1C` writer/provenance and whether the nested second pump invokes
  that callback remain UNKNOWN. The loader supplies the group array and count
  but does not write/rebase `+0x1C` in the observed pass. Resolve with bounded
  static provenance and true-stop first/second-pump target/cadence comparison.

- C1 is not full parity: Acidbomb fixed `pvar+0x14` decay, LaserTracer
  gate/drain and Waterfall fixed-step cycles have measured residual defects;
  HelpManager's long-timer discrepancy remains a prediction from its fixed
  step. Flamethrower phase is TESTED preserved, while damage is UNKNOWN.
  LaserTracer whole-body decimation and global +0x578 rewrite were REJECTED.
  Preserve evidence; do not infer parity from one object.
- Archived companion supports 15/21 current BIN modules. Selected-module
  whitelist is deliberate; unknown module routes and broader regression are
  not silently armed. Historical five in-place PRX file edits remain static
  candidates only; owner chose the companion route.
- Saved A0/C1 true stops place HelpManager, Elevator, AgentController,
  Waterfall and Acidbomb at the group callback route; three weapons use a
  different route. This is shared dispatch, not one safe scaling rule:
  HelpManager/Elevator ignore shared delta and advance fixed steps, Acidbomb
  mixes preserved delta countdown with doubled fixed velocity, and
  AgentController forwards delta without accumulating it. AgentsGlove has
  fixed per-hit counters but is already rate-correct through substep cadence.
  307 fixed-step static leads are candidates, not 307 proven defects.

## NEXT ACTION and exact reads

1. Read `AGENTS.md`, this checkpoint, active task; verify actual Git HEAD.
2. Complete the curated GitHub publication handoff in
   `research/tasks/curated-github-publication-2026-09-23.md`, then read only
   `reports/GLOBAL-TIMING-FAMILY-PLAN-2026-09-23.md` and relevant
   `research/EVIDENCE_INDEX.md` entries for the next experiment.
3. Resolve group `+0x1C` writer/provenance and possible nested-second-pump
   invocation. Then build the Waterfall channel A0/B0/C1 table and predeclare
   a short-cycle companion experiment with exact guard, field and full-cycle
   acceptance checks. Keep the existing elevator component separate. Do not
   patch all group callbacks or halve Flamethrower damage by assumption.
4. Then run the visual representatives specified in the family plan. Read
   primary evidence only for a concrete binding or measurement question.
