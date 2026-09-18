# Généralisation des correctifs débris et collecte

> Décision prise le 17 septembre 2026 : **on garde** le correctif des débris et celui de la collecte Nano/munitions, et **on les généralise à tous les niveaux**.
> Ce document décrit ce qui a été trouvé en analysant les PRX originaux, et ce qu'il reste à faire.

## Méthode

Les fichiers `LEVEL_*.PRX` extraits du disque du jeu ont été comparés à l'audit binaire du projet. Résultat : ce sont bien les originaux attendus, **sauf LEVEL_02**, dont la copie extraite a été modifiée en mai. Pour l'analyse, il faut utiliser `Data\BACKUP\BIN\LEVEL_02_clean.PRX` pour ce module.

Les constantes ont ensuite été recherchées dans ces fichiers par leur signature binaire, ce qui permet de les retrouver sans se tromper de cible.

## Résultat 1 : le correctif des débris tient en un seul mot, et il vaut pour tous les niveaux

Le plugin injecte dans le jeu huit petits blocs de code qui lui appartiennent (les « caves »). Le septième contient, au mot 34, l'instruction qui charge la durée de collision des débris :

| Cave | Mot | Valeur enregistrée | Valeur après correction |
|---|---:|---|---|
| cave 7 | 5 | `0x3C043F00` (déjà corrigé) | — |
| cave 7 | 34 | `0x3C043F80` (1,0) | `0x3C043F00` (0,5) |

Ce même bloc est installé dans **les quinze modules** couverts par le plugin : la table des modules référence la cave 7 pour chacun d'eux.

Conséquence : changer ce mot dans le modèle de cave corrige les débris sur **tous les niveaux d'un coup**. C'est le cas le plus simple possible, et il n'a pas encore été intégré — le mot 34 est toujours à 1,0 dans la table compilée.

## Résultat 2 : la table de collecte existe dans dix modules, et on connaît sa position

La table de collecte a une signature très reconnaissable : cinq nombres à virgule qui se suivent dans l'ordre 0,06 / 0,3333 / 0,08 / 0,2, avec la vitesse initiale (0,1) juste avant.

| Module | Position de la table (relative au module) |
|---|---|
| LEVEL_01 | `0x2D5E0C` |
| LEVEL_02 | `0x2EF31C` |
| LEVEL_03 | `0x2EC794` |
| LEVEL_04 | `0x2E3554` (déjà corrigé) |
| LEVEL_05 | `0x2C2304` |
| LEVEL_06 | `0x2C50C4` |
| LEVEL_07 | `0x2E720C` |
| LEVEL_08 | `0x310614` |
| LEVEL_09 | `0x2BFA3C` |
| LEVEL_10 | `0x2DD82C` |

Les modules LEVEL_15, LEVEL_21, LEVEL_22, LEVEL_23 et LEVEL_24 ne contiennent pas cette table : la collecte y passe par un autre chemin, à identifier si on veut les couvrir aussi. Les modules multijoueur (LEVEL_16 à 20) ne sont pas concernés.

Deux modules présentent une **seconde** table, à `0x2E8914` (LEVEL_04) et `0x318104` (LEVEL_08), dont les valeurs d'entrée diffèrent. Elle ne doit pas être corrigée sans examen : ce n'est peut-être pas la même famille d'objet.

## Résultat 3 : les deux minuteurs de collecte restent à localiser

Les deux corrections « minuteur −1 → −0,5 » sont des **instructions** (charger 1,0 au lieu de 0,5), pas des données de table. Elles ne se retrouvent donc pas par signature simple.

Pour les généraliser, il faut, dans chaque module, retrouver la routine qui utilise la table de collecte ci-dessus, puis repérer les deux instructions concernées. C'est un travail d'analyse plus fin, à faire après les deux premiers points.

## Étape suivante proposée, dans l'ordre

1. **Intégrer le mot 34 de la cave 7** dans le modèle de cave du générateur. Un mot, effet sur tous les niveaux, vérification facile avant écriture.
2. **Ajouter les cinq constantes de collecte** pour LEVEL_01, 02, 03, 05, 06, 07, 08, 09, 10 (LEVEL_04 est déjà fait). Chaque entrée doit être vérifiée contre la valeur d'origine du PRX avant d'être écrite.
3. **Analyser les deux minuteurs** module par module, en s'appuyant sur la position de la table trouvée ici.
4. **Tester en jeu**, niveau par niveau, avec la même méthode que pour Metalis : une observation visuelle, puis une comparaison 30/60.

## Précautions

- Ne jamais écrire sans vérifier la valeur d'origine : le générateur le fait déjà pour les essais Metalis, il faut conserver ce contrôle.
- Ne pas patcher la table de collecte deux fois dans un module (LEVEL_04 l'a déjà).
- Ne pas toucher à la seconde table des modules 04 et 08 sans preuve qu'elle concerne la même chose.
- La correction des débris passe par la cave : elle sera donc active partout, y compris dans des niveaux non testés. C'est voulu, mais cela doit être annoncé comme tel dans les notes de version.
- Le module LEVEL_02 ne doit pas être analysé depuis `Data\BIN` (fichier modifié) mais depuis la copie propre.
- Les PRX du jeu servent uniquement de **référence d'analyse**. Le livrable reste le plugin `patch.prx` chargé par PPSSPP : aucun fichier du jeu n'est modifié, reconstruit ni repacké.

