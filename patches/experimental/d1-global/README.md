# D1 broad timing candidate

Experimental UCES00420 profile, first built 2026-09-29 and deployed passively
2026-09-30. No runtime acceptance or gameplay parity yet. Current build D1-v1-r2.

This implements the owner's broad-prototype-first direction: reuse existing
WF policies across enrolled modules, then find local exceptions during play.
It is not the complete historical `full_layers` patch.

| Profile | LEVEL_01 / Pokitaru | LEVEL_03 / Kalidon |
|---|---:|---:|
| A0 | All original instructions | All original instructions |
| C1 | Wait removed, delta1/60, player loop1 | Same three-word core |
| D1 | C1 +54 one-pass sites +Help +elevator initializer | C1 +32 one-pass sites +elevator initializer |
| D1 changed words / context guards | 59 /152 | 36 /125 |

One WF-002 callsite per enrolled module retains two passes, based on historical
non-doubling evidence. All other selected wrapper sites use the INFERRED default
one-pass policy. A family number does not prove a universal timing unit.
The archived runtime has15 compiled profiles;15/21 are historically excluded;
11 other potentially eligible profiles are not yet enrolled. FRONTEND/16-20 are
outside that compiled coverage. Add modules by extending the pinned recipe,
not by removing identity guards. Broaden after first reversible live acceptance,
without requiring perfect Pokitaru behavior first.

## Source rationale and limits

The legacy two-pass wrapper preserves its incoming scalar arguments for a second
call to the same leaf helper. Its first call receives the original arguments.
Calling the leaf directly therefore implements that first computation pass:
no game code cave, plugin callback or altered delay slot is needed. The second
pass previously observed the memory updated by the first pass. This is static
mechanical evidence, not a claim that halving passes preserves every trajectory.

The old base `full_layers=1` also changes additional core constants and doubles a
local scalar. Those extras were not imported: D1 uses the current three-word C1.
Weapon/breakable/particle layers and optional features were not imported.
Existing local Help/elevator recipes are explicit group2 rules. Elevator changes
affect initialization; hot switching does not rewrite an already spawned object.

The package starts with request0 and no game writes. The monitor binds a unique
`rcp1` with exact segment extent and content guards. It rechecks that binding
inside suspended dispatch before a transaction, verifies original/owned words,
and restores on failure without overwriting a foreign word. Lost ownership
remains unresolved. A confirmed module unload clears the request; each new
residency requires an explicit arm. Only supported module requests1 and3 exist.
Some loader-relocated HI/LO context words guard opcode/registers only; this is
recorded as guard kind2, not full address-immediate validation.

## Reproduce locally

Use the existing bundled Python and PSP SDK; no toolchain installation required.
Build names and result paths must be new (outputs are preserved and ignored).

```text
python patches/experimental/d1-global/build.py --name D1-v1-r2
python patches/experimental/d1-global/test_offline.py --build patches/experimental/d1-global/build/D1-v1-r2 --out patches/experimental/d1-global/tests-output/offline-r2.json
python patches/experimental/d1-global/test_controller.py --out patches/experimental/d1-global/tests-output/controller-r3.json
```

Local build manifest records inputs/tool hashes, profile rules, guards, policy,
linked symbols, heap size and PRX hash. Compiled MIPS transaction tests cover324
cases at three bases. Controller fixtures cover38 cases including passive D0/
recorder coexistence, mode changes, foreign words, breakpoint/plugin/build/size
refusals, delivered writes with lost acknowledgments, and module changes.
Neither test suite executes the PSP monitor, real loader or JIT.

## Run and switch

Deployment is exclusive to `PSP/PLUGINS/D1Global`, using `tools/runtime/install-d1.py`
with PPSSPP fully closed. Existing plugins and original assets are preserved.
Start PPSSPP normally and load a normal Pokitaru save, without a savestate.
First verify passive ABI, module identity and original words; then one short
A0->D1->A0 acceptance before owner-controlled exploration.

```text
python tools/runtime/switch-d1-profile.py --target status --out-dir <new-local-directory>
python tools/runtime/switch-d1-profile.py --target D1 --out-dir <new-local-directory>
python tools/runtime/switch-d1-profile.py --target A0 --out-dir <new-local-directory>
python tools/runtime/d0-switch-panel.py --candidate D1 --port 8768
```

The shared panel server keeps its original D0 default. D1 uses its own page and
controller on http://127.0.0.1:8768/. The old D0 panel refuses the added D1 module;
use the D1 panel for this experiment. Both controllers share the same lock.
C1 is a CLI comparison profile owned by D1; D0Temporal remains passive.
Switch to A0 before changing levels; inspect and rearm after each normal load.
Switches do not undo ammo, HP, events, random state or initialized coefficients.
Do not resume/overwrite a foreign stop or unknown profile. A failed restoration,
crash or identity loss ends the trial; ordinary semantic differences become
measured exception candidates. Visit Kalidon early after technical acceptance.

See `research/live-tests/pokitaru/d1-switch/REPORT.md` for hashes, deployment and
the exact next acceptance. Raw build/test/deployment outputs remain local.
