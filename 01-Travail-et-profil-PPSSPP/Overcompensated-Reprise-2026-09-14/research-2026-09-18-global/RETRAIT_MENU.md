# Retrait du menu et du toggle — 18 septembre 2026

La version **0.6.4-no-menu-dev.1** est compilée et installée dans `PSP/PLUGINS/SizeMattersWrapperProfiler`. Elle reste **désactivée** pour l'analyse vanilla : aucun `plugin.ini`, uniquement `plugin.ini.desactive-pour-test`. La copie sur disque ne constitue pas une validation en jeu.

## Changements effectifs

- Retrait du code du menu natif, de ses stubs assembleur et de ses profils de garde du build. Aucun symbole `rcsm_menu`, `menu_monitor`, `menu_stop`, `menu_load_choice` ou `menu_save_choice` dans l'ELF final.
- Retrait de la lecture/écriture du choix `Overcompensated.fps`, archivé avant retrait du dossier plugin. Une ancienne préférence 30 FPS ne peut plus supplanter la configuration INI.
- Retrait de la surveillance de la mailbox de changement à chaud. Les symboles FPS restants servent au statut; seule la lecture initiale de `frame_rate` configure la fréquence. La configuration livrée conserve `global_60fps`, `frame_rate = 60`, `full_layers = 15`.
- Les `31` anciennes redirections de menu sont inventoriées dans `../development-v0.6.4-no-menu/RETIRED_MENU_HOOKS.csv`. Les adresses y sont des offsets module: pour une base runtime B, site=B+call_offset et destination native=B+native_target_offset. Le mot original est le JAL relocalisé vers cette destination. Le PRX sans menu ne réécrit plus ces appels.
- Les tables de patch, le moteur transactionnel, le dispatcher et les wrappers 60 FPS restent identiques octet pour octet à v0.6.3; empreintes dans `UNCHANGED_60FPS_TABLES.json`.

## Correction annexe nécessaire à Metalis

Un défaut préexistant empêchait l'armement de Metalis : `prepare_full_patch` copiait la cave 7 du générateur, dont le mot 34 était déjà `0x3C043F00` (`lui a0,0x3F00`, demi-pas 0.5), puis exigeait `0x3C043F80` avant de l'écraser par `0x3C043F00`. L'égalité impossible provoquait le refus du module avant les écritures de jeu.

La garde accepte maintenant les deux versions connues du template (`3C043F80` historique ou `3C043F00` déjà généralisé), pose `3C043F00` et refuse toujours toute autre valeur. Ce mot est dans une cave injectée du plugin; **ce n'est pas une adresse vanilla du jeu**. Son adresse effective est `adresse_cave_7 + 0x88`, déterminée par le chargement du plugin. Aucun site vanilla ni table de correction supplémentaire n'est modifié par cette réparation.

Le test `test_metalis_cave_prepare.py` extrait les fonctions exactes ancienne et nouvelle, compile avec les vraies tables générées et le vrai `rcsm_full_prepare`, puis exerce leur construction dans un processus hôte séparé. Résultats : ancienne fonction refuse le template actuel; nouvelle construit les 167 entrées; template historique accepté et normalisé; valeur étrangère `3C044000` refusée. Seule la synchronisation de cache PSP est neutralisée pour ce test hors émulateur.

## Vérifications effectuées

- Compilation PSP GCC 15.2.0 avec `-Wall -Wextra -Werror` réussie.
- 912 contrôles statiques/binaires réussis (`sources/PSP_BUILD_VALIDATION.json`). Le validateur a été adapté à la nouvelle chaîne de version et à la recherche des exécutables Windows `.exe`.
- Tests hôte réussis : 600 scénarios module/delta/couches, 1 393 échecs d'écriture injectés, 15 modules/493 callsites, formatage, parser de trace et état FPS.
- Absence des symboles menu et du chemin de sidecar dans le binaire vérifiée avant installation.
- Empreinte de chaque fichier de la sauvegarde comparée au fichier actif avant remplacement.
- Empreinte installée relue et identique au build; plugin toujours désactivé.

## Fichiers et réversibilité

| Élément | Valeur |
|---|---|
| Variante source | `../development-v0.6.4-no-menu/` |
| Nouveau PRX | 81 166 octets |
| SHA-256 nouveau PRX | `2c043c8bb8e3bc02da314d05227b2d67f3f1ee79dea7194126ef77e6c0203ddc` |
| SHA-256 ancien PRX | `2913a613e77b1e7c749a017fed334585dfd50c15db9ee9a659420ecdab25fc44` |
| Sauvegarde complète | `../development-v0.6.4-no-menu/backup-plugin-before-no-menu/` |
| Manifestes | `BACKUP_MANIFEST.json`, `INSTALLATION_NO_MENU.json`, `BUILD_WINDOWS.json` |
| Diff source | `SOURCE_DIFF.patch` |

Un retour arrière consiste à recopier depuis cette sauvegarde `patch.prx`, `RCSMProfiler.ini` et, si souhaité, `Overcompensated.fps`. Le fichier d'activation reste désactivé. Les anciens dossiers v0.6.2/v0.6.3 sont inchangés.

## Limites et suite vanilla

Cette intervention ne valide ni les vitesses ni les durées du jeu. Les trois écarts de valeurs de collecte entre Metalis et la généralisation (vitesse maximum, steering, at-cap) sont conservés délibérément et signalés dans l'audit historique pour le prochain manifeste; aucun rééquilibrage silencieux.

Aucun processus PPSSPP n'a été lancé ou arrêté, aucune RAM, ISO ou sauvegarde de jeu modifiée par cette intervention. Aucun réglage général de PPSSPP modifié. À 09:33, aucun processus PPSSPP n'était présent; une session live peut depuis avoir été ouverte par le travail principal.

Pour établir une référence vanilla, partir d'un démarrage complet de l'ISO original avec plugins et cheats désactivés, sans charger un savestate contenant du code patché; vérifier le module chargé et les mots attendus en mémoire. Le fichier dédié `vanilla-session.ini` du travail principal porte `EnableCheats=False`, `EnablePlugins=False`, `LoadPlugins=False`, `RemoteDebuggerOnStartup=True`. Le retrait du menu ne suffit pas à rendre une session vanilla si le socle 60 FPS est activé: c'est l'absence de chargement du plugin et de cheats qui fournit ce cadre.

## Reproduction

Dans le dossier de la variante : `python create_variant.py`, `python update_validator.py`, `python build-windows.py`, puis les outils de validation et `python test_metalis_cave_prepare.py`. `verify_and_install.py` est une installation unique avec garde sur l'ancienne empreinte et refus d'écraser la sauvegarde; sa relance n'est pas un simple rebuild. `build-windows.py` produit volontairement un rapport de compilation non installé; seul `INSTALLATION_NO_MENU.json` atteste l'installation relue.
