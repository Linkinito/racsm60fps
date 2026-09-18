# Changelog v0.5.0-prealpha

## Dispatcher

- ajout du mode `policy_module` avec module explicitement autorisé ;
- ajout des politiques par défaut, par famille et par `$ra` de référence ;
- priorité des exceptions `$ra` sur les règles de famille ;
- ajout d'une route `ONE_PASS` distincte pour chacun des 15 modules connus ;
- conservation de la route `TWO_PASS` originale et du profileur pendant les essais ;
- ajout d'un fallback visible `CUSTOM → TWO_PASS` ;
- refus des sélecteurs absents, contradictoires ou invalides ;
- installation atomique, rollback et retrait reconnaissant les deux routes ;
- surveillance séparée des routes correctes et des hooks dirigés vers la mauvaise destination.

## Traces et outils

- passage au schéma JSON v5 avec politiques configurées et effectives ;
- parseur compatible avec les schémas v1 à v5 ;
- validation croisée des totaux de routes ;
- nouvel outil `validate_policy_config.py` ;
- tests hôte du routage mixte, du fallback `CUSTOM` et du retrait ;
- validation statique et binaire portée à 910 contrôles.

## Profils Metalis

- 05A : 36/36 `TWO_PASS` ;
- 05B : `WF-030` seule en `ONE_PASS` ;
- 05C : sept familles candidates, neuf callsites en `ONE_PASS` ;
- maintien conservateur des familles transversales et armes/dégâts en `TWO_PASS`.

## Limites connues

- aucun déblocage 60 FPS intégré ;
- aucun correctif d'arme, de dégâts, d'attaque de mêlée ou d'effet cosmétique ;
- aucun code `CUSTOM` spécialisé dans cette préversion ;
- validation PPSSPP réelle encore requise, en commençant par le palier 05A.
