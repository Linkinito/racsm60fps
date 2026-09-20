# STATIC-60FPS-COMPLETE-AUDIT-001 — Start Here

Projet cible :

`C:\Users\linki\Documents\PPSSPP\RAC_60FPS`

Mission :

Construire un audit statique exhaustif de Ratchet & Clank: Size Matters (UCES00420) afin d'identifier tout ce qui peut se comporter différemment entre le jeu original à 30 FPS et le patch 60 FPS C1.

Le but final est :

> 60 FPS visuels, comportement temps réel identique au 30 FPS original.

Le kit est conçu pour fonctionner sans accès runtime de DeepSeek.

## Ordre recommandé

1. Copier ce kit dans le dépôt, idéalement sous :
   `docs/STATIC-60FPS-COMPLETE-AUDIT-001/`
2. Lire `CONTEXT.md`.
3. Lire `MISSION.md`.
4. Lire `AGENTS.md`.
5. Lancer `scripts/Initialize-StaticAudit.ps1` depuis la racine du dépôt.
6. Donner `prompts/MASTER_COORDINATOR_PROMPT.md` à l'agent principal DeepSeek.
7. Laisser le Coordinator créer et distribuer les shards.
8. Contrôler régulièrement :
   - `reports/STATIC-60FPS-COMPLETE-AUDIT-001/STATUS.md`
   - `coverage.md`
   - `master_inventory.csv`
   - `timing_mechanisms.csv`
   - `patch_candidates.csv`
9. Ne jamais considérer la mission terminée tant que :
   `UNEXAMINED = 0`

## Règle essentielle

Aucun candidat de patch produit par cette mission n'est validé.

Tous les correctifs proposés doivent être marqués :

`UNVERIFIED_STATIC_CANDIDATE`

Ils doivent ensuite être testés manuellement sous PPSSPP.

## Ce que DeepSeek ne doit pas faire

- aucune écriture mémoire runtime ;
- aucune automatisation PPSSPP ;
- aucune modification des PRX ;
- aucune modification de l'ISO ;
- aucune activation automatique de cheats ;
- aucune modification silencieuse de C1 ;
- aucune conclusion runtime inventée.

## Retour vers ChatGPT

Une fois une première vague terminée, fournir de préférence :

- `coverage.md`
- `STATUS.md`
- `high_priority_findings.md`
- `shared_timing_architecture.md`
- `timing_mechanisms.csv`
- `patch_candidates.csv`
- quelques dossiers `objects/*.md` représentatifs

Le fichier `HANDOFF_TO_CHATGPT.md` donne le format recommandé.
