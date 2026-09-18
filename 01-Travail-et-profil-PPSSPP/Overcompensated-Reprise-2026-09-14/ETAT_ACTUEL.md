# État actuel du projet

> Point unique de vérité, vérifié sur le disque le 17 septembre 2026.
> En cas de contradiction avec un autre document, c'est celui-ci qui décrit l'état réel.

## Ce qui est installé, en ce moment

| Élément | Valeur vérifiée |
|---|---|
| Plugin actif | `0.6.3-generalisation-dev.2` (généralisation + modules Clank géant exclus) |
| Empreinte du PRX | `2913a613e77b1e7c749a017fed334585dfd50c15db9ee9a659420ecdab25fc44` |
| Taille | 128 386 octets, installé le 17/09 en soirée |
| Version compilée mais non installée | `dev.2` (correction de persistance), empreinte `5b001f0b…` |
| Configuration lue au démarrage | `mode = global_60fps`, `frame_rate = 60`, `full_layers = 15` |
| Choix enregistré par le menu | 60 dans `Overcompensated.fps` |
| PPSSPP | **non lancé** |
| Sauvegarde de sécurité | `sessions/before-native-menu-20260917-193300/` (plugin précédent + sauvegardes du jeu) |

Conséquence directe : au prochain démarrage, le jeu repartira en 60 images par seconde avec les 167 corrections de Metalis et toutes les autres tables, plus le prototype de menu. Tous les essais faits à la main pendant les recherches ont disparu avec la fermeture de PPSSPP.

## Nouvelle version, installée le 17 septembre à 21 h 30

Une version **0.6.3-generalisation-dev.1** a été fabriquée dans `development-v0.6.3-generalisation/`, un dossier séparé : la version de base `development-v0.6.2-menu` n'a pas été touchée.

- elle généralise le correctif des débris (un mot de cave, partagé par les quinze modules) ;
- elle ajoute les cinq constantes de collecte aux modules 01, 02, 03, 05, 06, 07, 08, 09 et 10 ;
- empreinte du PRX : `2913a613e77b1e7c749a017fed334585dfd50c15db9ee9a659420ecdab25fc44` (dev.1 de la généralisation, `554dbdaf…`, conservée comme pièce intermédiaire) ;
- **retirée** après le plantage du 21 h 34 : le plugin en place est redevenu le prototype dev.1 (`d1239a3f…`). Le binaire 0.6.3 est conservé dans `development-v0.6.3-generalisation/runtime-generalisation/` ;
- contrôles hors jeu réussis, aucun essai en jeu pour l'instant.

Installation et retour arrière : voir `development-v0.6.3-generalisation/LISEZ_MOI.md` et `sessions/before-v063-20260917-213010/LISEZ_MOI.txt`.
## Ce qu'on sait maintenant, et qui n'était pas écrit

**Le passage à 30 a déjà été obtenu en vrai, au moins une fois.** Le journal du plugin montre, pendant la dernière session, `frame_rate applied=30 requested=30` sur deux modules chargés à la suite (LEVEL_15 puis LEVEL_04), après une demande faite depuis le menu. Les notes précédentes disaient encore « transition effective 30 : à faire ». Ce qui reste non vérifié, c'est ce que le joueur a vu à l'écran, pas le fait que le plugin a basculé.

**Le mode 30 est difficile à prouver.** En 30 images par seconde, le plugin ne modifie rien : c'est le comportement d'origine. Sa seule preuve est donc sa propre déclaration (`applied=30`) et un compteur d'écritures à zéro. Une vérification indépendante — relire les emplacements de correction et constater qu'ils sont bien restés d'origine — manque encore.

**Toutes les découvertes manuelles de Metalis sont bien dans le plugin.** Les 54 écritures manuelles qui portent une position relative au module se retrouvent à l'identique dans la table compilée. Voir `inventaire-2026-09-17/`.

**L'écart de comptage est expliqué.** Le journal annonce 160 écritures pour une table de 167 entrées : les 7 entrées manquantes sont des valeurs surveillées, corrigées seulement si elles prennent la valeur d'origine attendue.

## Incohérences traitées aujourd'hui

| Incohérence | Traitement |
|---|---|
| Fichier `Overcompensated.fps.tmp` oublié dans le dossier du plugin (reste du renommage refusé de dev.1, contenait 30) | Déplacé dans `sessions/attic-2026-09-17/`, avec une note |
| `MENU_SCOPE.md` décrivait encore l'ancienne forme du menu | Bandeau ajouté en tête du fichier, renvoyant à la spécification actuelle |
| `START_HERE.md` ne mentionnait pas le passage à 30 réellement obtenu | Bandeau ajouté en tête du fichier |
| Aucun état consolidé du projet | Ce document, plus `FONCTIONNEMENT_PLUGIN.md` et l'inventaire |

## Décisions actées le 17 septembre

| Sujet | Décision |
|---|---|
| Copie d'ISO propre | À préserver telle quelle, comme référence d'origine. **Le mod ne patche pas l'ISO** : il reste un `patch.prx` injecté par PPSSPP. Aucun fichier du dossier du jeu ne doit être modifié sans le signaler. |
| Plafond `FrameRate = 30` de PPSSPP | Non-problème confirmé : quand le socle 60 FPS est actif, le jeu bascule à 60. |
| Correctifs débris et collecte | À conserver et à généraliser à tous les niveaux, au même titre que les autres corrections de rythme. Voir `PLAN_GENERALISATION.md`. |
| Documents Word | À remettre à jour plus tard ; ils servent de documentation habituelle. |
| Mise en page du menu | À traiter au fil de l'eau. |
| Collision des débris | Pas encore intégrée : elle porte sur le mot 34 de la cave 7, partagée par tous les modules (voir le plan). |
| Collecte Nano et munitions | Déjà intégrée au plugin pour Metalis ; la généralisation aux autres niveaux est le travail en cours. |

## Priorité

La priorité absolue reste **un jeu à 60 images par seconde dont les durées et les vitesses restent identiques à l'expérience d'origine**, autant que possible. Les ajouts annexes (menu, contrôles) sont secondaires ; le cadrage caméra déjà travaillé reste considéré comme acquis.

## Points techniques restants, sans décision nécessaire

- Le champ `installed` des rapports de compilation vaut `false` même pour le PRX réellement installé : défaut du script de compilation, à corriger lors d'une prochaine passe.
- Le mode 30 n'a pas de témoin mémoire indépendant : à prévoir pour pouvoir prouver qu'il est bien actif.
- Les documents Word et la vue d'ensemble datent d'avant le menu v0.6.2.

## Prochaine étape recommandée

1. Intégrer le mot de cave du correctif débris : un mot, effet sur tous les niveaux.
2. Ajouter les constantes de collecte des modules 01 à 10 (voir `PLAN_GENERALISATION.md`).
3. Installer dev.2 et vérifier que le choix 30/60 survit à un redémarrage.
4. Au fil de l'eau : mise en page du menu à cases.