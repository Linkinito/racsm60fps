# Technical overview

> Updated findings from the 2026-09-30 live session (rejected global arms,
> working targeted fixes, particle system) are in [FINDINGS_2026-09-30.md](FINDINGS_2026-09-30.md).

Condensed map of what is known about the 60 FPS problem in `UCES00420`.
Every statement keeps the evidence level of its source; follow the links
before relying on an address. Evidence levels:
[methodology/EVIDENCE_LEVELS.md](methodology/EVIDENCE_LEVELS.md).

## Test configurations

| Name | Definition | Role |
| --- | --- | --- |
| **A0** | Original game, 30 FPS | Reference behaviour |
| **B0** | A0 with the conditional second VBlank wait removed | Uncorrected 60 FPS |
| **B1** | B0 with the shared delta 1/30 → 1/60 | Historical intermediate |
| **C1** | B1 with the player substep limit 2 → 1 | Experimental core, not a parity verdict |
| **D0** | C1 plus selected temporal overrides (currently Help only) | Local-override arm |
| **D1** | Broad inferred global timing profile built from the legacy dispatcher | Current global candidate |

The legacy "D" base, which doubled a local player scalar, is abandoned as a
clean base (it is not C1).

## Core sites (LEVEL_01 / Pokitaru)

Source: [research/v2/pokitaru/player-clock-socle-map.md](../research/v2/pokitaru/player-clock-socle-map.md).
Addresses are module RVAs; runtime addresses depend on relocation.

| Component | RVA | Original → candidate | Status |
| --- | --- | --- | --- |
| Second VBlank wait (outer cadence) | `0x96650` | `jal` → `nop` | Word OBSERVED; cadence effect measured in live tests |
| Shared delta producer | `0x151E0` | `lui a0,0x3D08` → `0x3C88` (≈1/30 → ≈1/60) | OBSERVED; not a universal game clock |
| Player substep limit | `0x2FCFC` | `slti a0,s1,2` → `1` | OBSERVED; consequences INFERRED |

Player chain: `0x1517C` (delta) → `0x2FFF0` → `0x2FB8C` (player update with
the two-iteration substep loop). Function `0x360A4` runs once per outer
update, outside the substep loop, and writes `state+0x578 = dt × 30`.

Known module differences:

- `LEVEL_16`–`LEVEL_20` already use a substep limit of 1 in the original
  game; the C1 "2 → 1" change must not be applied there.
- `LEVEL_15` and `LEVEL_21` are near-identical but not byte-identical; the
  legacy runtime hard-disables both after an archived crash report.
- `FRONTEND` and `LEVEL_16`–`20` have no compiled legacy profile.

## Why one global constant cannot work

Measured consumption shapes under C1
([docs/legacy/CURRENT_STATE.owner.FR-2026-09-21.md](legacy/CURRENT_STATE.owner.FR-2026-09-21.md),
[reports/60FPS-STRATEGY-REVIEW-2026-09-27.md](../reports/60FPS-STRATEGY-REVIEW-2026-09-27.md)):

| Consumer shape | Example | Result under C1 |
| --- | --- | --- |
| Fixed work per outer frame | Pokitaru elevator, Waterfall | 2× too fast (elevator 10.01 s → 5.00 s) |
| Explicit delta integrator | Acidbomb countdown | Correct real-time rate |
| Fixed decrement in the same callback | Acidbomb velocity decay | 2× too fast |
| Player-substep fixed step | AgentsGlove counters, Flamethrower phase | Correct real-time rate |
| Gate-qualified channel | LaserTracer gate/drain | 2× too fast; whole-callback decimation caused judder |

One callback can mix several shapes, so every correction needs to know its
units and dispatch path.

## Legacy dispatcher (v0.4.3 – v0.6.4)

The legacy companion PRX contains a centralized C dispatcher. Its main features:

- **59 wrapper families (WF)** with 267 members and 493 callsites;
- **15 compiled level profiles** (`LEVEL_01`–`10`, `15`, `21`–`24`);
- a policy selection of `default_policy = one_pass | two_pass | vanilla | custom`, overridden per WF family and then per exact return address.

This is the broad-policy / local-exception architecture that D1 reuses. The
`custom` policy currently falls back to `two_pass`. Source:
[reports/LEGACY-COMPANION-PRX-AUDIT-2026-09-23.md](../reports/LEGACY-COMPANION-PRX-AUDIT-2026-09-23.md)
and the legacy sources under
`01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14/development-v0.6.4-no-menu/sources/`.

## Strongest open global hypothesis

**INFERRED:** restore the original mixture of ≈30 Hz outer logic, ≈60 Hz
player substep work and 60 Hz presentation. This differs from throttling the
whole game, because delta consumers gated back to 30 Hz must also receive a
1/30 delta. Scheduling and the time each consumer receives must change
together. Mixed logic/render callbacks may then need interpolation or
presentation exceptions.

## Runtime tooling

- PPSSPP debugger WebSocket API, driven by `tools/runtime/` (Python and Node).
- A0/D0/D1 hot-switch panel: [tools/runtime/D0-SWITCH.md](../tools/runtime/D0-SWITCH.md).
- A hot switch swaps code, not state: spent ammo, finished waves and
  accumulated timers are not undone.
