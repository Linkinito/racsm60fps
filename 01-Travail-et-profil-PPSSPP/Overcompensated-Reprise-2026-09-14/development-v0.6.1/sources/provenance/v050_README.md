# Size Matters Wrapper Dispatcher v0.5.0-prealpha

Jeu ciblé : **Ratchet & Clank: Size Matters — UCES00420**. Cette version est un prototype de recherche pour **PPSSPP 1.19.3 sous Windows 11** ; elle n'est pas un patch 60 FPS complet prêt pour une partie normale.

## Résultat principal

La v0.5.0 transforme le profileur v0.4.5 en dispatcher expérimental. Chaque callsite connu peut maintenant être envoyé, indépendamment des autres, vers le wrapper original à deux passes ou directement vers son helper à une passe, tout en conservant les compteurs et l'identification par `$ra`.

Le paquet reconnaît toujours 15 modules, 493 callsites et 59 familles. Le premier module autorisé pour les essais de politique est **Metalis (`LEVEL_04`, index 4)**, qui contient 36 callsites répartis entre 21 familles.

## Archives prêtes à installer

| Palier | Routage Metalis | Usage |
|---|---:|---|
| `STAGE05A_METALIS_ALL_TWO_PASS` | 36 `TWO_PASS`, 0 `ONE_PASS` | **Premier test recommandé** : validation structurelle et référence |
| `STAGE05B_METALIS_WF030_ONE_PASS` | 35 `TWO_PASS`, 1 `ONE_PASS` | Test isolé de `WF-030`, après validation de 05A |
| `STAGE05C_METALIS_ACTOR_CANDIDATES` | 27 `TWO_PASS`, 9 `ONE_PASS` | Lot expérimental, seulement après 05A et 05B |

Les ZIP se trouvent dans `install/ready_zips/`. Chaque archive contient exactement le dossier `PSP/PLUGINS/SizeMattersWrapperProfiler` à extraire dans le memstick de PPSSPP.

## Ce que fait le dispatcher

- il résout dynamiquement la véritable base de `rcp1` et applique le même déplacement à ses signatures, callsites et destinations ;
- il attend trois identifications identiques espacées de 100 ms avant toute écriture ;
- il vérifie les 36 instructions d'origine avant d'installer le moindre hook ;
- il applique la politique par famille, puis les éventuelles exceptions par `$ra` de référence ;
- il conserve le delay slot de chaque `jal` et sauvegarde les registres du jeu dans le trampoline ;
- il surveille les redirections et distingue les routes `TWO_PASS`, `ONE_PASS` et les routes inattendues ;
- il retire uniquement ses propres hooks lors d'un changement de module ou de l'arrêt du plugin ;
- il exporte une trace JSON v5 contenant la politique configurée et la politique réellement exécutée.

## Ce que cette version ne corrige pas

La v0.5.0 ne débloque pas elle-même le framerate. Elle n'inclut pas non plus les compensations du delta général, du joueur, de la caméra, des boulons en titane, des armes, des dégâts, des attaques de mêlée, des breakables ou des effets cosmétiques.

Le mode `CUSTOM` est réservé dans le format de configuration, mais il revient volontairement à `TWO_PASS` dans ce prototype. Aucune fonction corrective spécialisée n'est encore exécutée silencieusement.

## Premier test sur Metalis

Installe uniquement `RCSMDispatcher_v0.5.0_STAGE05A_METALIS_ALL_TWO_PASS_UCES00420.zip`, désactive tous les cheats 60 FPS, redémarre complètement PPSSPP et entre sur Metalis. Le journal doit annoncer `version=0.5.0-prealpha`, puis `key=LEVEL_04`, `callsites=36`, `two_pass=36`, `one_pass=0` et `custom_fallback=0`.

Ce premier lancement est nécessaire avant de préparer le socle CWCheat de Metalis, car la taille différente du PRX peut déplacer le module du niveau. Le `runtime_base` et le `delta` du nouveau `status.log` permettront de relocaliser les six écritures du socle sans reprendre à l'aveugle les adresses d'une ancienne version.

Le protocole complet est décrit dans `METALIS_TEST_PROTOCOL.md`. La conception et les garanties de sécurité sont détaillées dans `DISPATCHER_SPEC.md`.

## Commandes en jeu

| Combinaison | Action |
|---|---|
| `L + R + SELECT` | export manuel de la trace courante |
| `L + R + START` | remise à zéro des compteurs de la capture courante |

Les fichiers sont écrits dans `PSP/PLUGINS/SizeMattersWrapperProfiler/`. Une transition vers un autre module exporte également la capture si `export_on_transition=true`.

## État de validation

- compilation PSP avec `psp-gcc 15.2.0`, options strictes et `-Werror` ;
- tests hôte du catalogue, de la relocalisation, du rollback et des deux routes ;
- validation du format des traces v1 à v5 ;
- validation des trois configurations Metalis ;
- inspection statique du PRX final : **910 contrôles réussis** ;
- taille de `patch.prx` : **46 862 octets** ;
- SHA-256 de `patch.prx` : `b95b256c101a1a11872ca910aed4f5de8ca22c5e6bba77727b607d1316476a14`.

Ces contrôles ne remplacent pas l'essai réel dans PPSSPP. C'est précisément l'objet du palier 05A.
