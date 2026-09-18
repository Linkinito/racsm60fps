# Sources du Wrapper Dispatcher v0.5.0

Ce dossier contient le runtime PSP, les trampolines Allegrex, le catalogue généré des 15 modules et les outils de validation. Le binaire `patch.prx` reconnaît 493 callsites répartis entre 59 familles et autorise un routage `TWO_PASS` ou `ONE_PASS` par callsite.

## Configuration

Le fichier racine `RCSMProfiler.ini` est volontairement en `detect_only`. Les trois profils Metalis prêts à tester se trouvent dans `config_profiles/10_*`, `11_*` et `12_*` ; les profils numérotés 00 à 05 sont conservés uniquement comme références historiques de la série v0.4.x.

Le mode actuel de recherche est `policy_module`. Il exige un module explicite, refuse les familles ou `$ra` absents de ce module et force `detect_only` en cas de contradiction.

## Recompiler et valider

```sh
export PSPDEV=/chemin/vers/pspdev
export PATH="$PSPDEV/bin:$PATH"

make clean all
python3 tools/validate_prx.py --pspdev "$PSPDEV" --output PSP_BUILD_VALIDATION_v0.5.0.json
python3 tests/test_trace_parser.py
python3 tools/validate_policy_config.py config_profiles/10_metalis_all_two_pass/RCSMProfiler.ini
```

Le rapport binaire livré annonce 910 contrôles réussis. Les tests hôte couvrent aussi le routage mixte, le rollback, le retrait conditionnel et le format de trace v5.

## Fichiers centraux

| Fichier | Rôle |
|---|---|
| `src/psp_plugin_runtime.c` | résolution du module, configuration, armement, logs et traces |
| `src/profiler_hook.S` | trampolines `TWO_PASS` et `ONE_PASS` pour les 15 modules |
| `src/rcsm_profiler_core.c` | relocalisation et installation transactionnelle des callsites |
| `generated/wrapper_profiles.generated.c` | signatures et 493 callsites de référence |
| `tools/parse_trace.py` | validation/export CSV des traces v1 à v5 |
| `tools/validate_policy_config.py` | résolution statique d'un INI sur le corpus |
| `tools/validate_prx.py` | audit du binaire PSP produit |

La v0.5.0 n'implémente pas encore de correctif `CUSTOM`. Une entrée configurée ainsi est enregistrée comme telle dans la trace, mais exécute explicitement `TWO_PASS`.
