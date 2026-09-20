# Evidence address book

Open the indicated section only for the active question. These pointers do not
promote historical claims. Paths are relative to research/. `R` below is
[the parent V1 review](inbox/deepseek/missions/v1-parity-inventory/sol-review.md).

| Domain | Canonical entry / exact lookup |
|---|---|
| V1 parity review | R sections1–15; counts in section1; parent-checks.json and reconciled-items.csv beside it |
| Player clock | [active experiment](tasks/pokitaru-player-clock-001.md); [hypotheses](v2/hypotheses/player-clock.md); [four-change map](v2/pokitaru/player-clock-socle-map.md) |
| WF-002 | R section3, paragraph **WF-002**; [timing domains](v2/timing-domains.md), search WF-002 |
| WF-058 | R section3 **WF-058**; [future control](tasks/wf058-control-001.md) |
| Pokitaru | Four-change map above; socle-dataflow.asm and socle-callers.json beside it; [read-only preflight](live-tests/pokitaru/player-clock-001/preflight.mjs) |
| Ryllus provenance | R section7 LEVEL_02 identity row; section3 **Profiler stages 02/03**; primary paths in parent-checks.json |
| Kalidon | R section3 **Kalidon B** and **Kalidon total reconciliation**; section12 controls |
| Metalis | R sections2,5,7 (pickups),9 (vehicle assumptions); reconciled-items.csv for primary paths |
| Weapons / damage | R sections4–6, particularly 170-row supplemental dataset; reconciled-items.csv |
| Giant Clank | R section7 **Giant Clank** and **Giant Clank identity** rows; sections8,13 |
| Wrapper families | R section4 (493 sites /59 families); timing domains above; primary paths in reconciled-items.csv |
| Support mission | [state](inbox/deepseek/missions/player-clock-001-support/mission.json), then PARENT_HANDOFF.md if present; legacy report sections only as needed |
| Player-clock resume review | [bounded parent review](inbox/deepseek/missions/player-clock-001-support/parent-review.md); [live resume](live-tests/pokitaru/player-clock-001/RESUME.md); static relocation evidence: v2/pokitaru/player-address-evidence.json and verify-player-address.py |

Historical `L/` prefix is defined in R's opening. Do not reopen original inventories
merely to follow this index. Consult primary evidence only for specific verification.


## 2026-09-20 Ghidra timing evidence

- `LEVEL_01 0x360A4` — player timing-field delta integrator; `OBSERVED`.
- `LEVEL_01 player+0x578 = dt*30` — normalized frame-step producer; `OBSERVED`.
- `LEVEL_01 0x328A0` — displacement divided by `player+0x578`; velocity-normalization use; `OBSERVED`.
- Global `dt*30 -> dt*60` rewrite for `player+0x578` — `REJECTED` as a general fix due to `0x328A0`.
- `LEVEL_01 0x42C04` — mixed timer use of normalized step and literal `1.0`; `OBSERVED`.
- `LEVEL_01 0x32588` — explicit incoming-delta countdown family; `OBSERVED`.
- `LEVEL_01 0x39B74` — mixed timing-domain function; `OBSERVED`.
- `LEVEL_01 0x1EBC4` — strong `Player_WeaponUpdate` identity and weapon callback contract (`a0=weapon`, `f12=f20`); `CORROBORATED`.
- Flamethrower historical `3 -> 6` as deterministic frame decimation — `SUPERSEDED`; site is pseudo-random modulo selection.
- `LEVEL_01 0x14CA70` — local tracer timing initializer with static `rate=30`, reciprocal-derived constants, and explicit `rate==60` branches; `OBSERVED`.
- Game-wide master-clock interpretation of `DAT_002D2C04` — `SUPERSEDED`; current scope is local tracer/LaserTracer subsystem, `CORROBORATED`.
- `0x2DD1F8 -> 0x14CA70` raw function pointer — indirect initializer-table candidate; `OBSERVED` pointer, owner `UNKNOWN`.

