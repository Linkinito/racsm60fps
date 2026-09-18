# Reproduction v0.6.0-global-experimental.1

Utiliser PSPDEV v20260301, archive `pspdev-ubuntu-latest-x86_64.tar.gz`, SHA-256 `93324d9aa8b2a86d26b80848cf692e16adfce5144a73406067fe3fe84fc76801`. Les options de compilation sont dans le Makefile et comprennent `-Wall -Wextra -Werror` ; la chaîne utilisée rapporte `psp-gcc (GCC) 15.2.0`.

Depuis ce dossier, avec PSPDEV et PATH configurés vers la chaîne PSP :

```sh
make clean all
python3 tools/validate_prx.py --pspdev "$PSPDEV" --output ../PSP_BUILD_VALIDATION.json
python3 tools/run_host_checks.py --sanitize
python3 tools/validate_policy_config.py RCSMProfiler.ini > ../POLICY_RESOLUTION.json
```

Les tables compilables sont déjà incluses pour permettre une compilation sans disposer des fichiers du jeu. Leur régénération nécessite les PRX originaux, avec les empreintes exactes indiquées dans `../BINARY_AUDIT.json` :

```sh
python3 tools/generate_full_patch.py --prx-dir /chemin/vers/PRX
```

Les tests hôte couvrent le catalogue du wrapper, les transactions de correction, le formatage et le contrat de trace. Le test historique `test_runtime_dump.c` est conservé dans les sources, mais il n'a pas été exécuté dans cette session : les dumps récents qu'il attend ne sont pas présents et `RAM.dump` n'est pas une référence active pour le Pokitaru actuel.

L'inspection PSP contrôle 912 propriétés du code source et du binaire, et le moteur de correction passe 600 scénarios de module/delta/couches ainsi que 1 294 injections d'échec d'écriture. Ces chiffres décrivent des contrôles hors jeu, sans mesure du framerate, des dégâts ni des collisions dans PPSSPP.
