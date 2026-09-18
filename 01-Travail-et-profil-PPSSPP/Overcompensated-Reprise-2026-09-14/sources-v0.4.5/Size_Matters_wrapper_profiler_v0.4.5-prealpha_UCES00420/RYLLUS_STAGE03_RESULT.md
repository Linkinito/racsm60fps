# Résultat in situ — Ryllus complet et transition vers Kalidon

Le palier 03 v0.4.4 est validé sous PPSSPP 1.19.3 / Windows 11. Les 57 callsites de LEVEL_02 ont été redirigés transactionnellement, Ryllus a été terminé en incluant la section avec Clank, puis LEVEL_03 a été reconnu après la transition sans crash ni écriture non autorisée.

## Chronologie vérifiée

Le début de `status(9).log` conserve les lignes de sessions antérieures parce que le journal fonctionne en ajout. La session pertinente commence à `start version=0.4.4-prealpha` ; les deux traces LEVEL_02 et la trace LEVEL_03 forment ensuite une chronologie unique et cohérente.

| Étape | Résultat |
|---|---:|
| Armement Ryllus | 57/57 callsites |
| Base runtime | `0x09141D00` |
| Delta | `+0x8000` |
| Marqueur JIT LEVEL_02 | `0x680013F2`, accepté |
| Export manuel Ryllus | VBlank 43 519 |
| Export de transition Ryllus | VBlank 44 195 |
| Reconnaissance Kalidon | réussie, 33 entrées |
| Écritures Kalidon | 0, conformément à `allowed_module=2` |
| Marqueur JIT LEVEL_03 | `0x689DD00A`, accepté |
| `$ra` inconnus | 0 |

## Couverture dynamique de Ryllus

La capture finale couvre 42 824 VBlank, soit environ 11 min 54 s sur l’horloge à 60 VBlank/s. Sur les 57 callsites installés, 38 ont produit au moins un hit ; ils représentent 19 des 29 familles statiquement présentes dans Ryllus et totalisent 122 243 passages connus dans le trampoline.

| Famille | Hits | Call­sites actifs | Contexte statique principal |
|---|---:|---:|---|
| WF-020 | 26 052 | 2/2 | `CBEnterCutscene`, `Sprout`, `ClankBot` indirects |
| WF-013 | 17 520 | 2/2 | helper transversal d’ennemis et acteurs |
| WF-005 | 16 656 | 3/3 | helper transversal, objets mobiles et animations |
| WF-032 | 15 526 | 10/10 | `BotFlinger` indirect |
| WF-022 | 13 140 | 1/1 | `Sprout`, `ClankBot` indirects |
| WF-004 | 11 600 | 1/1 | contexte encore indéterminé |
| WF-057 | 6 146 | 1/1 | `Boulder` indirect |
| WF-014 | 5 760 | 3/3 | helper transversal d’ennemis |
| WF-002 | 5 161 | 1/1 | contexte encore indéterminé |
| WF-017 | 1 074 | 3/3 | `LunaNPC`, `Sprout` indirects |
| WF-055 | 961 | 1/1 | `Level02Column` indirect |
| WF-053 | 558 | 1/1 | `MovedObject` exact |
| WF-043 | 501 | 1/1 | `Dart` indirect |
| WF-025 / WF-026 | 846 | 2/2 | `BotFlingerArm` indirect |
| WF-015 | 298 | 1/1 | véhicules et `RatchetShipAnimation` indirects |
| WF-023 | 201 | 2/2 | `Microbot`, `ClankBot` indirects |
| WF-037 | 174 | 2/3 | `Level02ExpandableBridge` exact |
| WF-021 | 69 | 1/1 | contexte d’ennemis et d’armes indirect |

Les familles liées statiquement à la section Clank — WF-020, WF-022, WF-023, WF-025, WF-026 et WF-032 — totalisent 55 765 hits. Leur première activité est concentrée dans la seconde moitié de la capture, ce qui recoupe le déroulement signalé par le joueur sans prétendre attribuer automatiquement chaque hit à une action précise.

## Ce que la trace temporelle apporte

Parmi les transitions entre VBlank actifs de chaque callsite, 67 865 sur 68 742 ont un écart de deux VBlank, soit 98,724 %. Ce motif correspond très fortement à une logique mise à jour autour de 30 Hz sur une horloge VBlank à 60 Hz ; les trois écarts d’un seul VBlank sont marginaux et les autres écarts correspondent surtout aux périodes où un objet devient inactif.

La trace distingue également 53 463 hits supplémentaires survenus dans un VBlank déjà actif. Ils représentent plusieurs appels au wrapper pendant la même mise à jour, parfois jusqu’à huit pour un callsite, et ne doivent donc pas être interprétés comme huit images ou huit ticks distincts.

Les familles à contexte sémantique fort confirment cette lecture. `Level02ExpandableBridge` produit 174 hits sur 174 VBlank actifs, `MovedObject` 558 sur 558 et `Level02Column` 961 sur 961 ; leurs séquences actives progressent presque exclusivement par pas de deux VBlank. À l’inverse, WF-020 et WF-022 exécutent plusieurs appels dans le même VBlank pendant la section Clank.

## Fin de niveau et transition

Les 676 VBlank séparant l’export manuel de la transition ajoutent 2 055 hits. Seuls les trois callsites WF-005, WF-015 et WF-057 restent actifs ; WF-015 apparaît précisément pendant cette fenêtre avec 298 hits répartis sur 149 VBlank, ce qui est cohérent avec son contexte statique de véhicule ou d’animation de vaisseau.

Kalidon est ensuite reconnu de manière unique à la même base runtime, avec 33 callsites connus et un marqueur JIT accepté. Comme la configuration autorisait uniquement le module 2, LEVEL_03 reste intact : sa trace vide constitue le palier de détection réussi qui autorise maintenant une instrumentation complète limitée à Kalidon.

## Limite et suite

Cette capture fournit une référence temporelle vanilla très solide, mais elle ne suffit pas à décider qu’une famille doit utiliser une ou deux passes. La comparaison 60 FPS devra vérifier si les écarts passent majoritairement de deux à un VBlank et, surtout, mesurer simultanément l’effet gameplay : durée, distance, cadence, dégâts ou état final.

La prochaine étape sûre est la v0.4.5, palier 04, avec `allowed_module = 3`. Elle instrumentera les 33 callsites de Kalidon sans armer les autres niveaux et conservera exactement le format temporel v4.
