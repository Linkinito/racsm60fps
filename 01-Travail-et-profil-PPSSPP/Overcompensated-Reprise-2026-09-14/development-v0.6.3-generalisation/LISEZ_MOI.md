# Version de travail 0.6.3 — généralisation des débris et de la collecte

> Créée le 17 septembre 2026. **Cette version n'est pas installée.** Le plugin en place reste le prototype de menu dev.1.
> La version de base (`development-v0.6.2-menu`) n'a pas été modifiée : tout le travail a été fait dans ce dossier-ci.

## Ce que cette version apporte

Deux corrections validées à la main sur Metalis sont désormais **généralisées à tous les niveaux concernés** :

1. **Collision des débris.** Un mot du bloc de code que le plugin injecte (cave 7, mot 34) passe de 1,0 à 0,5. Ce bloc est utilisé par les quinze modules : une seule valeur corrige donc les débris partout.
2. **Collecte Nano et munitions.** Les cinq constantes de la table de collecte sont divisées par deux dans les neuf modules qui possèdent cette table et qui n'étaient pas encore corrigés : LEVEL_01, 02, 03, 05, 06, 07, 08, 09 et 10.

Metalis (LEVEL_04) n'est pas retouché : ses 167 entrées étaient déjà bonnes.

## Preuve que rien d'autre n'a bougé

Comparaison automatique entre la table de la version de base et celle de cette version (`verifier-difference.py`, résultat dans `DIFFERENCE_TABLES.json`) :

| Élément | Différence constatée |
|---|---|
| Modèles de cave | 1 seul mot : cave 7, mot 34, `0x3C043F80` → `0x3C043F00` |
| LEVEL_01, 02, 03, 05 à 10 | +5 entrées chacun, aucune suppression, aucune modification |
| LEVEL_04, 15, 21, 22, 23, 24 | **aucune différence** |

Les 45 entrées ajoutées ont été vérifiées une par une contre les PRX d'origine avant d'être acceptées : le générateur refuse d'écrire si la valeur d'origine ne correspond pas exactement.

## Ce qui a été vérifié, et ce qui ne l'est pas

| Contrôle | Résultat |
|---|---|
| Empreintes des PRX d'origine | conformes à l'audit binaire (LEVEL_02 pris depuis la copie propre) |
| Génération de la table | réussie, 99 entrées expérimentales (54 Metalis + 45 nouvelles) |
| Différence avec la version de base | exactement celle prévue |
| Compilation PSP | réussie, avertissements traités comme des erreurs |
| Tests hôte (menu, FPS, transactions, profileur, format, traces) | **PASS**, dont 600 scénarios et 1 393 échecs d'écriture simulés |
| Validation du PRX | **PASS**, 912 contrôles |
| Test en jeu | **non fait** |

Autrement dit : le binaire est propre et conforme à ce qui était prévu, mais personne n'a encore joué avec. Les débris et la collecte dans les niveaux autres que Metalis restent des extrapolations, pas des faits observés.

## Contenu du dossier `runtime-generalisation`

C'est ce qu'il faudra copier dans le dossier du plugin sur la carte mémoire, le moment venu :

| Fichier | Taille | Empreinte SHA-256 |
|---|---|---|
| `patch.prx` | 128 242 o | `554dbdaf19f2b2de3d9e5ef1af530694e5d79f25447c541ae53dac39662838b5` |
| `RCSMProfiler.ini` | 1 035 o | configuration inchangée (60 images, quatre couches) |
| `plugin.ini` | 80 o | inchange |

## Installation, quand tu le décideras

1. Fermer complètement PPSSPP.
2. Sauvegarder le dossier `PSP/PLUGINS/SizeMattersWrapperProfiler` actuel (il contient le plugin dev.1 et son journal).
3. Copier les trois fichiers de `runtime-generalisation` dans ce dossier, en remplaçant `patch.prx`.
4. Relancer le jeu **depuis l'ISO propre**, par une sauvegarde normale, jamais depuis un savestate.
5. Vérifier dans `status.log` la ligne de démarrage : elle doit annoncer `0.6.3-generalisation-dev.1`.

## Retour arrière, si besoin

Tout est conservé. Il suffit de recopier le `patch.prx` correspondant :

| Pour revenir à… | Fichier à recopier | Empreinte SHA-256 |
|---|---|---|
| prototype de menu actuellement en place (dev.1) | `development-v0.6.2-menu/runtime-dev1/patch.prx` | `d1239a3f4c7302fbfb57cc592f220973dfe5c0467ccb5ffcbd8074ad87b86354` |
| version de compilation dev.2 (non testée en jeu) | `development-v0.6.2-menu/sources/profiler/patch.prx` | `5b001f0bd5cf0b0bc541dceca44373db18ec5ad4b813ff5edc9f839192b76e24` |
| socle dev.061 antérieur | `sessions/before-native-menu-20260917-193300/SizeMattersWrapperProfiler/patch.prx` | `67c16bc1caafc6d340de785f4bf0e15de61ce40f41699a3699cb5b71cd8e9341` |

Le plugin ne modifie aucun fichier du jeu : revenir en arrière se limite donc à remplacer le PRX et à relancer PPSSPP.

## Comment relancer la fabrication

```text
python development-v0.6.3-generalisation/sources/profiler/tools/generate_full_patch.py \
       --prx-dir development-v0.6.3-generalisation/prx-reference
python development-v0.6.3-generalisation/build-windows.py
python development-v0.6.3-generalisation/sources/profiler/tools/run_host_checks.py \
       --cc development-v0.6.3-generalisation/../toolchains/zig/zig-x86_64-windows-0.15.2/zig.exe --cc-arg cc
python development-v0.6.3-generalisation/verifier-difference.py
```

Les fichiers de données à modifier sont :

- `sources/profiler/generated/cave-overrides.json` — les dérogations de cave (débris) ;
- `sources/profiler/generated/generalisation-experiments.json` — les ajouts par module (collecte) ;
- `sources/profiler/generated/metalis-experiments.json` — les 54 découvertes Metalis, inchangées.

## Reste à faire après un premier essai concluant

- Étudier les deux minuteurs de collecte (instructions « charger 1,0 → 0,5 »), qui n'ont pas de signature simple : ils demandent une analyse de code module par module.
- Regarder les modules 15, 21, 22, 23 et 24, qui n'ont pas la table de collecte telle quelle.
- Examiner la seconde table présente dans LEVEL_04 et LEVEL_08, dont les valeurs d'entrée diffèrent.


## Mise à jour dev.2 — exclusion des modules Clank géant

Premier essai de la dev.1 le 17 septembre à 21 h 34 : plantage de PPSSPP en entrant dans la section Clank géant, deux secondes après l'armement du module LEVEL_15. Le même parcours refait avec la version de base a produit **exactement le même plantage**, au même décalage dans PPSSPP (`0x2cc9bf`) : le défaut est donc préexistant et n'a rien à voir avec la généralisation.

La dev.2 ajoute une exclusion : les modules **15 et 21** (séquences Clank géant, tables identiques) ne reçoivent plus aucun correctif. Le journal écrit une ligne `module excluded key=LEVEL_15 ... reason=crash_reported_20260917`. Ces scènes restent en vanilla, donc à leur rythme d'origine, mais pas à 60 images, le temps de comprendre le profil fautif.

| Élément | Valeur |
|---|---|
| Empreinte du PRX dev.2 | `2913a613e77b1e7c749a017fed334585dfd50c15db9ee9a659420ecdab25fc44` |
| Taille | 128 386 octets |
| Tests hôte et validation PRX | PASS |