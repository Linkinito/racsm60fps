# État actuel — Overcompensated / Ratchet & Clank: Size Matters 60 FPS (résumé propriétaire)

_Mis à jour le 21 septembre 2026 — résumé en français pour le propriétaire. Le checkpoint agent (anglais) est `CURRENT_STATE.md`._

## Objectif

Faire tourner **Ratchet & Clank: Size Matters (UCES00420)** à 60 FPS avec la
même comportement réel qu'en 30 FPS original : déplacements, sauts, cadences
de tir, cooldowns, dégâts, timers, plateformes, ascenseurs, caméra,
animations, particules, ennemis, scripts. Aucun rééquilibrage ni
fonctionnalité bonus avant la parité.

## Configurations de référence

- **A0** : 30 FPS vanilla (référence).
- **B0** : A0 + suppression de la 2e attente VBlank (site 0x96650).
- **B1** : B0 + delta partagé ~1/30 → ~1/60 (boucle joueur à 2 passes).
- **C1** : B1 + seuil de boucle joueur 2 → 1, scalaire local vanilla conservé.
  C1 est une base expérimentale, pas le patch final.
- **D** : ancien socle avec scalaire ×2 — abandonné comme base propre.

## Ce qui est mesuré (sessions runtime du 20/09, Pokitaru)

- Waterfall A0 ≈ 29,97 Hz ; C1 ≈ 59,94 Hz (ratio 1,9999326).
- Boucle joueur A0/B0 : cadence de cycle complet ×1,999967 en B0.
- C1 : 60 arrêts, seuil 1 confirmé. B1 : 2 passes conservées, +0x578 = 0,5.
- **Constat clé** : le callback Waterfall est appelé une fois par update
  externe ; son résidu en C1 vient du déverrouillage B0, pas du seuil C1.
- **Anomalie ouverte** : déficit d'environ 0,5 % de la pente +0x574 en B1/C1.
- La comparaison A0/B0 était en une passe sans re-vérification des guards en
  A0 ; à confirmer par une séquence A0 → B0 → A0.

## Cartographie statique (points acceptés)

- Delta partagé ~1/30 (0x151E0/E4), cible 0x88768 confirmée (0x884A4 rejeté).
- Chaîne joueur 0x1517C → 0x2FFF0 → 0x2FB8C ; gate 1/0/1 ;
  `+0x578 = dt × 30` (bon pour la normalisation de vitesse, mauvais comme
  timer à 60 Hz).
- LaserTracer : sous-système local « rate-aware » (rate = 30, branche
  rate==60) — ce n'est pas l'horloge du jeu.
- 21 modules avec frame-gate ; 16 producteurs de delta repérés (2 manquants).
- **LEVEL_16–20 ont déjà un seuil de boucle à 1 en vanilla** : le correctif
  « 2 → 1 » de C1 ne doit PAS y être appliqué. C1 est spécifique au module.
- LEVEL_15 et LEVEL_21 : quasi identiques mais pas byte-identiques.
- Règle C1 par forme de consommation : travail par appel = 1,0× (correct) ;
  intégrateur dt = 0,5× (trop lent) ; normalisé N-VEL = 2,0× (trop rapide).

## Corpus figé

Registre canonique : **538 noms** (CSV de l'atlas, hash épinglé dans
`research/v2/corpus-canonical/corpus_manifest.json`). L'ancien « 534 » est
abandonné (il n'a jamais existé comme liste). Les 7 noms sans callback (U1)
sont portés explicitement.

## Missions DeepSeek

- **Run 001** : terminé au niveau orchestration, revu par le parent :
  verdict PARTIAL — le sandbox des workers était en lecture seule, les CSV
  sont restés vides. Reconnaissance réussie, audit exhaustif non terminé.
- **Run 002** : prêt à lancer. Ré-audit sur le registre gelé de 538 noms,
  shards de 25, champ DISPATCH_SITE obligatoire, workers autorisés à écrire
  uniquement dans `research/` et `reports/`.

Pour lancer (dans PowerShell, à la racine du dépôt) :

```powershell
.\tools\agents\scripts\start-deepseek-mission.ps1 `
  -MissionId static-60fps-complete-audit-run-002 `
  -TaskFile "research\tasks\static-60fps-complete-audit-run-002.md" `
  -Roles explorer,mapper,skeptic `
  -Profile deepseek-flash-high
```

Suivi : `.\tools\agents\scripts\get-deepseek-mission-status.ps1 -MissionId static-60fps-complete-audit-run-002`

## État Git

Branche `v2-research`. HEAD `e7c1c97`, 3 commits en avance sur origin,
rien poussé. Commits récents : gel du corpus + revue parent (8220fc9),
infra d'écriture des workers (cf7e3be), tâche du run 002 (e7c1c97).

## Prochaine étape runtime (quand vous rouvrirez PPSSPP)

Test B0-only sur un callback de classe (M01+0x151D78) : ~59,94 Hz =
résidu hérité de B0, ~119,9 Hz = dispatché par sous-étape joueur. Puis
répétition A0, mesures synchronisées sur les ticks (+0x574/+0x578), puis les
neuf sondes Pokitaru A0/C1 de l'atlas.
