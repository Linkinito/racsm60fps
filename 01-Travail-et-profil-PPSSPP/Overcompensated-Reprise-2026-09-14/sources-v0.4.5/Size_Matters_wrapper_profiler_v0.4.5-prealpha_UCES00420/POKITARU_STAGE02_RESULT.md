# Résultat in situ — Pokitaru complet et transition vers Ryllus

Le palier 02 v0.4.3 est validé dans PPSSPP 1.19.3 sous Windows 11. Les 55 callsites de LEVEL_01 ont été redirigés transactionnellement vers le trampoline, Pokitaru a été parcouru intégralement, puis LEVEL_02 a été reconnu après la transition sans crash ni écriture non autorisée.

## Chronologie vérifiée

Le fichier `status(7).log` est un préfixe du journal complet `status(8).log`, arrêté juste après le premier export manuel. Il ne représente donc pas une seconde session contradictoire : les traces `L01_0001`, `L01_0002` et `L02_0003` forment une seule chronologie cohérente.

| Étape | Résultat |
|---|---:|
| Armement Pokitaru | 55/55 callsites |
| Base runtime | `0x09140D00` |
| Delta | `+0x7000` |
| Marqueur JIT LEVEL_01 | `0x680013F2`, accepté |
| Export manuel Pokitaru | VBlank 21 868 |
| Export de transition Pokitaru | VBlank 23 348 |
| Reconnaissance Ryllus | réussie |
| Écritures Ryllus | 0, conformément à `allowed_module=1` |
| Marqueur JIT LEVEL_02 | `0x6899D98A`, accepté |
| Export manuel Ryllus | VBlank 25 828 |
| `$ra` inconnus | 0 |

## Couverture dynamique de Pokitaru

La capture finale couvre 22 320 VBlank, soit environ 372 secondes avec une horloge à 60 VBlank/s. Sur les 55 callsites installés, 34 ont produit au moins un hit ; ils appartiennent à 16 des 27 familles statiquement présentes dans Pokitaru et totalisent 496 697 passages dans le trampoline.

| Famille | Hits | Call­sites actifs | Contexte statique principal |
|---|---:|---:|---|
| WF-005 | 330 600 | 3/3 | famille transversale, plusieurs objets mobiles ou animés |
| WF-027 | 90 685 | 5/5 | `SharkagatorFin` |
| WF-051 | 36 219 | 1/1 | `Butterfly` |
| WF-013 | 14 700 | 2/2 | nombreuses familles d’ennemis à distance 1 |
| WF-011 | 8 700 | 2/2 | `AgentOfDoom` à distance 3 |
| WF-014 | 4 788 | 3/3 | nombreuses familles d’ennemis à distance 2–3 |
| WF-012 | 4 350 | 1/1 | `MutantCow`, `MutantMadCow`, `AgentOfDoom` indirects |
| WF-036 | 4 022 | 3/3 | `Level01Boat` |
| WF-033 | 1 488 | 6/6 | `DropshipB` à distance 1 |
| WF-016 | 303 | 2/2 | `HutDoor` |
| WF-002 | 246 | 1/1 | contexte encore indéterminé |
| WF-047 | 224 | 1/1 | `DropshipB` à distance 2 |
| WF-021 | 216 | 1/1 | contexte d’ennemis, dont `Crab` à distance 2 |
| WF-015 | 106 | 1/1 | véhicules et animations de vaisseau indirects |
| WF-019 | 25 | 1/2 | `TriggeredDoor` |
| WF-046 | 25 | 1/1 | `Level01DoorTarget` |

Les 21 callsites restés muets appartiennent notamment aux familles associées statiquement au Polarizer, aux Agents of Doom, à `Sprout`, `TMRobotHeadB` et `CrankedObject`, ainsi qu’à trois familles indéterminées. Leur silence ne signifie pas que leur cartographie est fausse : certains exigent une arme, un état de sauvegarde, une rencontre ou une interaction que le parcours courant n’a pas nécessairement déclenché.

## Ce que cette capture prouve

Le trampoline a supporté près d’un demi-million de passages tout en conservant un gameplay permettant de terminer le niveau. La transition valide aussi le choix de ne pas restaurer les mots de l’ancien PRX après que le chargeur a commencé à remplacer LEVEL_01 : Ryllus a été reconnu avec 57 entrées, zéro callsite installé et zéro hit, exactement comme l’imposait la liste blanche limitée à Pokitaru.

Cette trace ne permet cependant pas encore d’attribuer une politique `ONE_PASS` ou `TWO_PASS`. Le format v3 connaît le total et les bornes temporelles, mais pas le nombre de VBlank distincts ni les hits multiples dans un même VBlank ; une famille intermittente peut donc sembler lente si l’on divise naïvement son total par toute la fenêtre.

## Suite expérimentale

La v0.4.4 introduit une trace v4 avec `active_vblanks`, `same_vblank_hits`, `max_hits_per_vblank` et un histogramme des écarts de 1, 2 ou davantage de VBlank. Le prochain essai utile est un parcours de Ryllus avec ses 57 callsites autorisés ; il fournira à la fois la validation complète de LEVEL_02 et une première base temporelle suffisamment précise pour préparer ensuite les comparaisons 30/60 FPS.
