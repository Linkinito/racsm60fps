# Documentation map

## Start here

| Document | Purpose |
| --- | --- |
| [../README.md](../README.md) | Project overview |
| [../PROJECT_GOALS.md](../PROJECT_GOALS.md) | Priorities: parity first, optional features later |
| [TECHNICAL_OVERVIEW.md](TECHNICAL_OVERVIEW.md) | Timing problem, configurations A0–D1, core sites, legacy dispatcher |
| [FINDINGS_2026-09-30.md](FINDINGS_2026-09-30.md) | Latest live findings: rejected global arms, working fixes, particle system |
| [ROADMAP.md](ROADMAP.md) | Next steps |
| [DECOMP_STATUS_2026-10-01.md](DECOMP_STATUS_2026-10-01.md) | Mass decompilation of LEVEL_01: pipeline, findings, limits |
| [FIX_CATALOGUE_2026-10-01.md](FIX_CATALOGUE_2026-10-01.md) | Corrections ready for live testing and the test order |
| [WHY_60FPS_IS_HARD.md](WHY_60FPS_IS_HARD.md) | The eight time domains of the engine and why no single global patch works (FR: [fr/POURQUOI_LE_60FPS_EST_DIFFICILE.md](fr/POURQUOI_LE_60FPS_EST_DIFFICILE.md)) |
| [DECOMPILATION_FINDINGS.md](DECOMPILATION_FINDINGS.md) | All decompilation findings: engine map, fix families, plugins (FR: [fr/TROUVAILLES_DECOMPILATION.md](fr/TROUVAILLES_DECOMPILATION.md)) |
| [../patches/experimental/enhancements/README.md](../patches/experimental/enhancements/README.md) | OCEnhance: optional camera/controls plugin |
| [RUNTIME_GUIDE.md](RUNTIME_GUIDE.md) | How to switch corrections and use the probes live |
| [DEVELOPMENT_STATUS_2026-09-23.md](DEVELOPMENT_STATUS_2026-09-23.md) | Earlier curated status (superseded in parts) |
| [fr/ETAT_DU_PROJET.md](fr/ETAT_DU_PROJET.md) | Owner summary in French |
| [PUBLICATION_POLICY.md](PUBLICATION_POLICY.md) | What may and may not be committed or published |

## Working state (research branch)

| Document | Purpose |
| --- | --- |
| [../CURRENT_STATE.md](../CURRENT_STATE.md) | Agent checkpoint: current blocker and exact next action |
| [../AGENTS.md](../AGENTS.md) | Rules for AI agents working in this repository |
| [../research/EVIDENCE_INDEX.md](../research/EVIDENCE_INDEX.md) | Entry point to measured evidence |
| [../research/tasks/](../research/tasks/) | Task definitions; the active one is named in `CURRENT_STATE.md` |
| [../reports/60FPS-STRATEGY-REVIEW-2026-09-27.md](../reports/60FPS-STRATEGY-REVIEW-2026-09-27.md) | Current strategy decision |
| [../MIGRATION.md](../MIGRATION.md) | V1 → V2 migration tracking |

## Methodology

| Document | Purpose |
| --- | --- |
| [methodology/EVIDENCE_LEVELS.md](methodology/EVIDENCE_LEVELS.md) | OBSERVED / INFERRED / TESTED / … definitions |
| [methodology/RESEARCH_POLICY.md](methodology/RESEARCH_POLICY.md) | Research requirements |
| [methodology/ORCHESTRATOR_POLICY.md](methodology/ORCHESTRATOR_POLICY.md) | Multi-agent orchestration details |

## Legacy

[legacy/](legacy/) holds the documents that were at the repository root before
the 2026-09-30 cleanup: the 2026-09-18 consolidation notes, the legacy
preservation notes and the French owner summary of 2026-09-21. They are kept
unchanged for provenance and may contradict newer documents.
