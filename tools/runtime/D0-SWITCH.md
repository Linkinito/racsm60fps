# Hot A0 / D0 comparison

The two-button local panel switches the existing running Pokitaru session. No
PPSSPP restart or normal-save reload is needed to change profiles.

| Button | Exact profile |
| --- | --- |
| A0 | Original core at30FPS; D0 rule words restored |
| D0 | C1 core at60FPS + HelpManager fixed timer correction, mask1 |

**C1 remains the core only.** This D0 panel excludes cascade droplets, mist,
surface foam/waves, Butterfly wings and EnemyWave's unmeasured timed branch.
Existing add-ons remain separate; no game asset or plugin deployment changes.
The supported loaded modules are mcp/rcp1/D0Temporal/FamilyRecorder. Additional
plugins, active recorder probes, unknown code words or breakpoints refuse a switch.

## Use

Start with the existing Python runtime:

```text
python tools/runtime/d0-switch-panel.py
```

Open `http://127.0.0.1:8767`. Click A0 or D0 and wait for the verified profile.
The panel reads actual core/plugin state instead of assuming the last button won.
After a normal save load, check again: that load can restore A0. PPSSPP must be
running with its existing debugger on60907 and the accepted D0 v1-r3 loaded.
If the local panel process stops, relaunch it; no PPSSPP restart is needed.

Agent/CLI equivalent:

```text
python tools/runtime/switch-d0-profile.py --target D0 --out-dir <new-local-directory>
python tools/runtime/switch-d0-profile.py --target A0 --out-dir <new-local-directory>
```

Every action produces exclusive local evidence under research/live-tests/
pokitaru/d0-switch. A process lock prevents simultaneous profile compositions.
The panel is loopback-only, serializes requests, and checks origin/session token.
It does not send game data to an external service.

## Transaction and limits

The wrapper validates matching D0 build/ABI/guards, core identity, running CPU,
no breakpoint, recorder passivity/build and original322 callsites/delay words
(accounting for D0's one owned Help delay word when active). It then requests D0
off before any core change; D0 selection applies C1 followed by mask1. The
reviewed underlying controllers each recheck the expected module base before
writing and retain their own allowlists/readback/recovery. A later failure attempts
A0 recovery only in the same supported binding; unresolved ownership stops
further writes and is reported. Brief read-time CPU flags can settle naturally;
the wrapper never resumes a foreign stop.

TESTED: two live A0->D0->A0 cycles (CLI then panel API), six composition fixtures,
eight existing actual-controller mocks, wrong-base refusals with zero writes.
Evidence: research/live-tests/pokitaru/d0-switch/REPORT.md.
This is profile control acceptance, not new gameplay/physics parity evidence.
Concurrency with external writers, kernel/module recycling and boot transitions
remain outside this acceptance.

Switching does not restore dead enemies, timers, random seeds or world state.
Future comparisons should use repeated actions in one scene, owner-started
observation and explicit profile markers. A one-time timed EnemyWave scene
remains deferred until a dedicated save exists; fixed AFK-prone windows do not
justify gameplay conclusions. No new recording session starts automatically.
