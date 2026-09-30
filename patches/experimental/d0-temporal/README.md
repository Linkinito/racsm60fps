# D0 - experimental shared temporal prototype

**D0 is external C1 core plus an explicitly selected temporal rule mask.**
This prototype does not include droplets, mist, cascade surface foam/waves,
Butterfly wings, or separate WaterWaves changes. Those remain separate add-ons.
UCES00420 / LEVEL_01 only. It is not a full-game or physics-parity patch.

Same-session A0/D0-help control is available through the
[local two-button panel](../../../tools/runtime/D0-SWITCH.md). It reuses the
existing loaded plugin and reviewed controllers; no restart/save reload is needed
for profile switching. Successful control is separate from behavioral parity.

## Implemented profiles

| Mask | Profile | Exact modification | Evidence / gate |
| --- | --- | --- | --- |
|0|Passive/off|No game writes|Default linked startup ABI|
|1|D0-help calibration|150F0C LUI3D08 ->3C88; only HelpManager state+1C fixed elapsed step1/30 ->1/60|TESTED live short-window timer rate and apply/remove/reapply; long event parity UNKNOWN|
|3|D0-help-wave trial|Mask1 plus137F5C same LUI edit for EnemyWave's fixed state+0C countdown branch|Static candidate; explicit unmeasured gateD0000002 required|

EnemyWave137FFC uses incoming/dynamic f12, not the locally constructed1/30.
It is preserved. Earlier feasibility wording treating both paths as fixed-step
is SUPERSEDED. Polarizer, event/resource integers, nonlinear motion and every
unknown channel are excluded. No pooled constant or whole callback is changed.
Each rule changes one normal instruction; no jumps, trampoline, cave or delay
slot edits. Original arithmetic/rounding, gates, reset/random range and calls
remain; half-step float32 threshold parity still needs runtime measurement.

Known model limit: sequential float32 rounding predicts the strict1200 help
threshold after1200.2333s in A0,600.1167s in uncorrected C1 and1199.6167s with
D0 half steps, assuming constant eligible cadence/gate clear. D0 is about0.617s
early relative to A0 over20minutes; not bitwise/event-exact parity. Reproduced by
research/scripts/model-d0-help-threshold.py (pinned threshold/source); no message
delivery observed. Original-step cadence gating would be needed if exact
30Hz accumulator recurrence is required. D0 is retained as a reversible first
rate-correction experiment, not a validated final long-timer policy.

The common rule implementation handles both sites. Additional sites require
consumer/cadence/units equivalence; automatic literal-based enrollment is refused.

## Protections and ownership

Startup request0/installed0 is certified in the linked ELF, heap16KiB.63
non-relocated code guards, module name/extent/unique identity and C1 core guards
must match. Monitor checks owned words continuously. Dispatch is suspended for
bounded preflight/write/readback/rollback; binding is rechecked inside that window.
Foreign words/query failures preserve ownership and stop writes. Only confirmed
old-module absence expires ownership and clears the request; next module needs
explicit rearming. Stop joins the monitor before restoring; failed join/removal
refuses unload. There are no retained game caves or code pointers into D0.

Matching plugin load, HelpManager rate response and same-module C1-loss restoration are TESTED in PPSSPP v1.20.4. Module transitions and unload remain NOT TESTED.
Suspended dispatch and repeated identity checks do not prove protection against
external debugger writers or uncharacterized kernel remapping. These are live gates.

## Build and offline acceptance

Use the existing SDK read-only; no installation/cache rebuilding:

```
python patches/experimental/d0-temporal/build.py --name D0-v1-r3
python patches/experimental/d0-temporal/test_offline.py --build patches/experimental/d0-temporal/build/D0-v1-r3 --out patches/experimental/d0-temporal/tests-output/offline-r3.json
```

Existing output names are refused. Latest built package:
`build/D0-v1-r3/D0Temporal/`. Build/source/SDK hashes in manifest.json;
original ELF pin checked. Strict compilation passed. PRX SHA256:
`4d42abb5dfe32de0bf3ac73ffcc73971c45c1d515b08cefb0e79bbee111c1a55`.

TESTED offline:114 linked-MIPS engine cases at3 target bases, using only mocked
IO. Active/off/mask changes, zero-write foreign preflight, delivered/dropped
failed writes, rollback and retained foreign ownership pass; callee-saved
registers/stack preserved. This exercises compiled engine code, not a policy copy.
It does not execute the PSP monitor/loader or establish gameplay behavior.
TESTED offline controller:8 in-memory API cases exercise the actual controller,
including read-only status, help/wave trials, persistent arm, delivered-write
lost acknowledgment with successful cleanup, permanent disconnect reported
UNRESOLVED, foreign original bytes and a wrong loaded build. It does not induce
actual network loss. Raw outputs are retained under tests-output/controller-r1*.
V1-r1 superseded before acceptance; v1-r2 passed engine tests but stop race was
found during bounded source review. V1-r3 uses stop-and-join and in-window binding
recheck. Early model lacked MOVN; test model corrected, no game-code change.

## Deployment / control

`tools/runtime/install-d0.py` requires full PPSSPP closure, exact build/offline
hashes and passive ABI. It refuses an existing D0 directory; deployment evidence
is local. It creates only `PSP/PLUGINS/D0Temporal`; existing plugins/maps stay intact.
V1-r3 was deployed **passive** while PPSSPP was closed. It has now loaded with the
matching build/ABI and passed bounded HelpManager runtime tests. Final live state
is A0, D0 off. See research/live-tests/pokitaru/d0-001-20260927/REPORT.md.

`tools/runtime/control-d0.py` supports status, trial, arm and off. It writes only
the D0 request/gate words, never core/game code. Activation requires running C1,
unique matching plugin/build, original/owned rule words and no breakpoint. Initial
trials refuse corrective companions to retain core-only attribution. Status/off
can inspect or remove the candidate without changing C1. Trial auto-disarms and
checks both original rule words; lost-ack/disconnect cleanup remains explicit.
EnemyWave requires `--profile help-wave --allow-unmeasured-enemywave`.
Raw control records require exclusive output paths and stay local.

Next gate: find an EnemyWave instance in state1, then measure its fixed countdown
in A0/C1 before a candidate trial. Three fixed-path windows had no hit (first two AFK, third owner-confirmed combat); a sampled
11-instance A0 snapshot had states0/4 only. Living enemies alone do not establish
that gate. Preserve Acidbomb delta and Flamethrower invariant controls; module
transitions/unload and long-threshold help delivery remain untested.

The current FamilyRecorder includes an original-word guard at150F0C: do not
arm it over active D0. Use the reviewed observer or a separately reviewed
profile-aware recording gate for the causal comparison. Presence/installation
of D0 alone is not measured timing or gameplay parity.
