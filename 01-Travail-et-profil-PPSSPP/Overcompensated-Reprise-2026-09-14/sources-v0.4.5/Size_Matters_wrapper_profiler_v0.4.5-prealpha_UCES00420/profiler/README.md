# Profiler PRX du wrapper — UCES00420

## Fonction du binaire

`patch.prx` est un plugin utilisateur destiné d’abord à PPSSPP. Il ne débloque pas le framerate et n’applique aucune politique `ONE_PASS` ou `TWO_PASS` : il compte les appels connus, mesure leur distribution entre les VBlank, puis transmet chaque appel au wrapper deux-passes original.

Le PRX lit `RCSMProfiler.ini` au démarrage et propose quatre modes :

| Mode | Écritures dans le jeu | Portée |
|---|---:|---|
| `detect_only` | 0 | détection des 15 profils |
| `single_pokitaru` | 1 mot | un `jal` de LEVEL_01 |
| `focused_pokitaru` | 2 mots par défaut | les deux branches WF-019 |
| `full_module` | 6 à 57 mots | module choisi par `allowed_module` |

Les profils fournis sont séparés : `02_full_module` autorise Pokitaru, `03_full_ryllus` autorise Ryllus, `04_full_kalidon` autorise Kalidon et `05_full_all_known_levels` reste réservé à une phase ultérieure. Le prochain essai doit utiliser uniquement `04_full_kalidon`.

## Preuves in situ acquises

Le palier 02 v0.4.3 a parcouru Pokitaru en entier sous PPSSPP 1.19.3 / Windows 11, puis a effectué la transition vers Ryllus sans défaut signalé. Les 55 callsites de LEVEL_01 ont été installés, 34 ont été actifs, 496 697 hits connus ont traversé le trampoline et `unknown_hits` est resté à zéro.

`HutDoor` (WF-016) a produit 303 hits et `TriggeredDoor` (WF-019) 25 hits. Lors de la transition, le plugin a exporté LEVEL_01, reconnu LEVEL_02 avec ses 57 entrées et respecté la liste blanche : aucun callsite de Ryllus n’a été modifié.

Les preuves détaillées se trouvent dans `IN_SITU_ANALYSIS_v0.4.3_STAGE02.json` et `../POKITARU_STAGE02_RESULT.md`.

Le palier 03 v0.4.4 a ensuite terminé Ryllus, y compris la section avec Clank. Les 57 callsites ont été installés, 38 ont été actifs, 122 243 hits connus ont été enregistrés et `unknown_hits` est resté à zéro ; LEVEL_03 a ensuite été reconnu avec 33 entrées sans être modifié. Les preuves se trouvent dans `IN_SITU_ANALYSIS_v0.4.4_STAGE03.json` et `../RYLLUS_STAGE03_RESULT.md`.

La trace temporelle montre que 98,724 % des transitions entre VBlank actifs utilisent un écart de deux VBlank. Cela constitue une référence vanilla 30 Hz très solide, tout en distinguant 53 463 appels supplémentaires effectués dans un VBlank déjà actif.

## Garde-fous

Le runtime récupère `text_addr` du module vivant `rcp1`, calcule son delta avec la base de référence `0x09139D00` et exige une empreinte stable pendant trois sondages. Il vérifie le prologue du wrapper, son appel interne et chaque `jal` candidat après traduction par le même delta. Une divergence bloque l’installation entière.

PPSSPP peut remplacer le premier mot du wrapper par un marqueur JIT `0x68xxxxxx`. Cette classe n’est acceptée qu’à cet emplacement précis ; l’ancre, les trois autres mots du prologue, l’appel interne et les callsites restent comparés exactement.

La résolution primaire utilise `sceKernelGetModuleIdList` et `sceKernelQueryModuleInfo`. Un balayage borné et aligné sur `0x1000` n’est permis qu’en repli et seulement si le candidat est unique. Les écritures sont transactionnelles, les caches sont synchronisés et le retrait ne restaure qu’un mot qui cible encore notre hook.

## Trampoline Allegrex

Chaque niveau possède un stub dont le saut final est réencodé vers le wrapper runtime vérifié. Le corps commun sauvegarde les 30 GPR utiles, HI/LO, FCR31 et les 32 FPR scalaires, appelle un shim C sans I/O ni allocation, puis restaure l’état avant le tail-jump.

Le parcours Pokitaru complet constitue désormais une validation dynamique forte de cette transparence : près d’un demi-million de passages ont été observés, puis le remplacement du module a été géré proprement.

## Trace v4

Les fichiers sont écrits dans `PSP/PLUGINS/SizeMattersWrapperProfiler/` :

- `status.log` : détection, armement, refus, transitions et erreurs ;
- `trace_Lxx_####.json` : table complète au format `rcsm-wrapper-trace/4`.

En plus des totaux et des bornes, chaque entrée v4 contient :

- `active_vblanks` : nombre de VBlank distincts avec au moins un hit ;
- `same_vblank_hits` : hits supplémentaires dans un VBlank déjà actif ;
- `max_hits_per_vblank` : pic observé ;
- `gap_1_vblank`, `gap_2_vblank`, `gap_other_vblank` : histogramme des écarts entre VBlank actifs.

Ces mesures empêchent de confondre une famille intermittente avec une famille appelée lentement. Elles préparent la comparaison contrôlée entre 30 et 60 FPS, sans transformer automatiquement un signal fréquent en verdict gameplay.

Contrôles :

- `L + R + SELECT` : exporter ;
- `L + R + START` : remettre les compteurs à zéro.

Le parseur valide le corpus et les invariants temporels :

```sh
python3 tools/parse_trace.py trace_L02_0001.json --csv trace_L02_0001.csv
```

## Validation et empreinte

Le binaire a été compilé avec PSPDEV v20260301 / `psp-gcc 15.2.0`. `PSP_BUILD_VALIDATION.json` consigne 802 contrôles réussis et le SHA-256 du PRX `bd571b4f3fd230cf4baea92dcbe693e9c71da95bfd733f6df6796de023a77af7`.

Le chargement ELF représente 35 076 octets et les deux piles déclarées 18 432 octets, soit environ 53 508 octets. Newlib et le tas sont désactivés ; le plugin n’utilise pas l’option PPSSPP `memory = 64`.

## Recompiler

Avec `PSPDEV` défini et `$PSPDEV/bin` dans `PATH` :

```sh
make clean all
python3 tools/validate_prx.py --pspdev "$PSPDEV" --output PSP_BUILD_VALIDATION.json
```

Voir `BUILD_REPRODUCIBILITY.md` pour la chaîne exacte et le protocole racine pour l’essai Kalidon. Une PSP réelle sous CFW reste une cible séparée qui nécessitera son propre bootstrap et sa propre validation.
