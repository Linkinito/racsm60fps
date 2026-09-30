# Current checkpoint - 2026-09-30

Priority0 UCES00420 original30 -> faithful60 parity; experimental only.
Branch v2-research (local-only); history REWRITTEN 2026-09-30, so older SHAs
quoted below or in reports (5dc4f38, 589d1f1...) no longer resolve; use
commit subjects. Active task research/tasks/global-candidate-rollout-001.md.

## 2026-09-30 repository cleanup (Claude session)

Remote v2-research/codex branches deleted (contained game PRX, SAVEDATA,
dumps, disasm); only public main remains. Local history filtered (game-
derived paths + blobs >5 MB), ~250 MB -> ~4 MB; files kept on disk, ignored.
Pre-cleanup bundle: ../RAC_60FPS-backup-2026-09-30/ (private). Root docs
reorganized: README, docs/README (map), docs/TECHNICAL_OVERVIEW,
docs/PUBLICATION_POLICY, docs/fr/ETAT_DU_PROJET, old root docs in docs/legacy.
Root clutter moved to _local/ (ignored). No gameplay/runtime work this session.

## Owner direction and delivered candidate

GLOBAL inferred prototype first, A0/patch during play, measured local exceptions
later. No per-class proof gate for experiments. Do not resume cosmetic polish,
blind EnemyWave hunting or a new architecture audit as the main work.
Strategy reports/60FPS-STRATEGY-REVIEW-2026-09-27.md remains the decision source.
Latest owner asks when to open PPSSPP. Now ready for normal Pokitaru boot.

D1-v1-r2 BUILT, now DISABLED after owner-reported startup crash and loss of sound.
PPSSPP now cannot launch even with D1 disabled. Windows Event1000/1001 identifies amdxc64.dll31.0.21910.11004, exceptionc0000005 offseta331f (latest01:36:51 Paris). Fault location OBSERVED; root cause/audio relation UNKNOWN. No D1 acceptance.
Only D1Global plugin.ini mapping set false, closed-process check/readback OK;
original descriptor backed up under d1-global/deployment/disabled-<timestamp>.
Do not re-enable D1 or retry A0/D1 switches until startup fault is resolved.
patches/experimental/d1-global/README.md and
research/live-tests/pokitaru/d1-switch/REPORT.md carry scope/method/hashes.
LEVEL_01: C1 core3 +54 one-pass calls +Help +elevator initializer =59 words.
LEVEL_03: C1 core3 +32 one-pass calls +elevator initializer =36 words.
WF-002 keeps two passes (one site/module). No EnemyWave/cascade/wings extras.
15 legacy compiled profiles,15/21 excluded;11 more eligible not yet enrolled.
FRONTEND/16-20 outside compiled coverage. Broaden after technical acceptance;
first-level perfection is not required. Hot switch cannot reset spawned state.

Static arbitration: wrapper saves original scalars, first leaf call already gets
original args, second repeats on updated memory. Direct relocated JAL to leaf
implements one_pass without game code caves or plugin callbacks. Luna's initial
remapping/stub concern was rejected after exact disassembly and corrected.
Legacy full_layers base1 is NOT C1: extra constants/local scalar doubling omitted.
Broad one-pass gameplay correction remains INFERRED, not validated.

## Build, control and current operational state

Final PRX SHA256075eb500395fabc971b311105cbe2b39ad4ae0e3967eae006b2c8f9df1572e72.
Build manifest SHA2565d4925b248922e76fb8b7911c8de607ea86d63c417468a85b14e81693563db97.
324 compiled-MIPS transaction/rollback cases pass (offline-r2.json);38 controller
fixtures pass with passive D0/recorder,47 overlapping WF callsites accounted for
(controller-r3.json). Loader/JIT/monitor/gameplay not covered. Luna reviewed;
stale binding at successful module_stop fixed inr2, unload still not live-tested.

Installed only PSP/PLUGINS/D1Global, passive request0, PPSSPP closed, readback OK.
No existing plugins/assets/config changed. Existing plugin/debugger config true.
D1 controller owns A0/C1/D1; D0Temporal must stay passive. It writes only D1 ABI
request/module words; runtime checks module identity/extent/context/ownership and
restores transactionally. Ambiguity retains ownership; confirmed unload disarms.
Each normal load/residency requires inspect/rearm. Unknown profile stops trial.

Panel: http://127.0.0.1:8768/, process40400 relaunched after connection refused; HTTP200 rechecked.
Start via bundled Python tools/runtime/d0-switch-panel.py --candidate D1 --port 8768. Shared D0 server default preserved; old D0 controller
refuses D1Global and should not be used for this trial. Shared lock prevents both.
Page200/token substitution and unauthenticated POST403 checked; no game request.
Historical D0 hot acceptance remains in d0-switch/REPORT.md, not D1 evidence.

## Exact NEXT ACTION / next-session files

AGENTS -> CURRENT_STATE -> research/tasks/global-candidate-rollout-001.md.
Then research/live-tests/pokitaru/d1-switch/REPORT.md and D1 README above.
First restore emulator startup: latest Windows reports fault in AMD driver with D1 disabled. Preserve config/logs, inspect known prior AMD workaround and backend enum, then try a reversible backend override; no driver reinstall/PPSSPP version change without authorization. Current config GraphicsBackend=0 (OPENGL).
Luna wf_reuse_audit has a bounded read-only D1/D0 runtime/build startup comparison.
Read that handoff first; distinguish plugin loading/resources from armed policy.
Actual D1 request before failure UNKNOWN; user was following initial boot steps.
Fix passive startup only after cause narrowed; then restore original acceptance
plan (status, A0->D1->A0, ordinary play, early Kalidon). No gameplay parity claim.

Quota last checked100% five-hour used/0% remaining, weekly68%; checkpoint before
live work as requested. Raw build/tests/deployment outputs stay local ignored.
