# Installation — Windows 11 / PPSSPP 1.19.3

Cette distribution contient la v0.4.5 à base dynamique, compatible avec les marqueurs JIT de PPSSPP et le format temporel v4. Supprimer d’abord le dossier `PSP\PLUGINS\SizeMattersWrapperProfiler` en entier : conserver un ancien `patch.prx` ou un ancien INI rendrait le résultat ambigu.

## Choisir un seul palier

Chaque dossier contient une arborescence `PSP/PLUGINS/SizeMattersWrapperProfiler` complète. Les mêmes arborescences sont disponibles sous forme d’archives directement extractibles dans `ready_zips/`.

| Dossier | Effet | État |
|---|---|---|
| `00_DETECT_ONLY` | zéro écriture dans le jeu | validé |
| `01_FOCUSED_TRIGGERED_DOOR` | deux `jal` WF-019 dans Pokitaru | validé |
| `02_FULL_POKITARU` | 55 `jal` dans Pokitaru | validé |
| `03_FULL_RYLLUS` | 57 `jal` dans Ryllus | validé |
| `04_FULL_KALIDON` | 33 `jal` dans Kalidon | **prochain essai** |

N’installer qu’un palier à la fois. Le profil tous niveaux n’est pas fourni comme palier prêt à tester.

## Installation du palier 04

1. Fermer complètement PPSSPP.
2. Utiliser `File > Open Memory Stick...` ou `Settings > System > PSP Memory Stick > Show Memory Stick folder`.
3. Supprimer l’ancien dossier `PSP\PLUGINS\SizeMattersWrapperProfiler`.
4. Extraire `RCSMProfiler_v0.4.5_STAGE04_FULL_KALIDON_UCES00420.zip` à la racine du Memory Stick.

Le résultat attendu est :

```text
<Memory Stick>\
└─ PSP\
   └─ PLUGINS\
      └─ SizeMattersWrapperProfiler\
         ├─ patch.prx
         ├─ plugin.ini
         └─ RCSMProfiler.ini
```

Au premier lancement, la ligne `start` doit contenir `version=0.4.5-prealpha`, `trace_schema=4`, `mode=full_module` et `allowed_module=3`. Sur Kalidon, une ligne `module armed` doit annoncer `key=LEVEL_03` et `callsites=33`.

## Désactivation et précautions

Fermer PPSSPP et déplacer `SizeMattersWrapperProfiler` hors de `PSP\PLUGINS`. Le renommer tout en le laissant dans `PLUGINS` n’est pas une désactivation fiable.

Le plugin ne modifie ni l’ISO ni les sauvegardes. Utiliser une sauvegarde interne, désactiver les cheats et l’ancien patch 60 FPS, ne pas activer `memory = 64`, puis archiver le log et les traces avant de changer de palier.

La procédure complète et les critères de réussite se trouvent dans `../../TEST_PROTOCOL_PPSSPP_1.19.3_WINDOWS11.md`.
