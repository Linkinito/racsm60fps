> MISE A JOUR : redémarrage utilisateur effectué et intégration60fps validée en mémoire; demande/annulation validée. Voir LIVE_VALIDATION.json et NEXT_MENU_STEP.md. Les instructions de redémarrage ci-dessous décrivent le premier essai désormais terminé. Interface menu et transition effective30 restent à faire.

# DÃ©veloppement v0.6.1 â€” compilÃ©, testÃ© hors jeu, installÃ© pour le prochain lancement

Version : `0.6.1-metalis-integration-dev.2`. PRX SHA256 : `67c16bc1caafc6d340de785f4bf0e15de61ce40f41699a3699cb5b71cd8e9341`.

Les 54 ajouts des essais Metalis sont intÃ©grÃ©s aux sources : 167 sites dans le moteur de transaction, capacitÃ© 192, et correction du compteur de collision dans la cave7 uniquement pour Metalis. Les 14 autres tables restent inchangÃ©es. Les vitesses courantes des acteurs ne sont pas enregistrÃ©es dans le plugin.

Compilation Windows portable rÃ©ussie avec PSP GCC15.2.0 (archive dmang-dev v2 vÃ©rifiÃ©e), `-Wall -Wextra -Werror`. Audit binaire : 912 contrÃ´les rÃ©ussis. Tests hÃ´te Zig0.15.2 cc : 600 scÃ©narios et1348 Ã©checs d'Ã©criture injectÃ©s, profiler, format, traces et contrÃ´leur FPS PASS. Pas de validation ASan/UBSan dans cette exÃ©cution. `VALIDATION_SUMMARY.json` relie les preuves au SHA du PRX et aux sources. Les anciens rapports copiÃ©s dans sources restent historiques lorsqu'ils mentionnent v0.6.0.

## Prochaine intervention / essai

L'ancien processus PPSSPP est laissÃ© intact, encore en v0.6.0. Le PRX et l'INI v0.6.1 sont installÃ©s sur disque (60 FPS demandÃ©). Sauvegarde prÃ©alable du plugin, des cinq sauvegardes du jeu et des savestates : `sessions/before-dev061-20260917-003800` dans le dossier parent.

RedÃ©marrer entiÃ¨rement PPSSPP, puis charger Metalis depuis la sauvegarde normale du jeu. Ne pas charger un ancien savestate pour ce contrÃ´le : il contient l'ancien plugin et l'ancienne mÃ©moire. Mettre en pause et prÃ©venir l'agent. Lancement avec ISO ayant dÃ©jÃ  causÃ© un crash AMD, prÃ©fÃ©rer lancement de PPSSPP seul puis ouverture du jeu par l'utilisateur.

Ensuite exÃ©cuter `verify-live-metalis.mjs` : sonde en lecture seule, exige le dÃ©marrage dev.2 dans le log, rÃ©sout les nouvelles bases via logs et symboles ELF, vÃ©rifie binding,167mots,36redirections,cave7 et mode confirmÃ©. La sonde a Ã©tÃ© testÃ©e contre la session ancienne : refus attendu sans aucune Ã©criture. Ses rÃ©sultats en nouvelle session restent ATTENDUS. Ne pas rejouer les scripts mÃ©moire v0.6.0 Ã  leurs anciennes adresses.

## Choix 30/60 : moteur prÃªt, interface native encore Ã  raccorder

`frame_rate = 30` ou `60` dans RCSMProfiler.ini, lu au dÃ©marrage. Le mode global doit rester `global_60fps` (nom historique du moteur). Le choix30 ne pose aucun correctif de jeu et exige la vÃ©rification des sites statiques originaux et des redirections d'origine. Le choix60 suit la transaction complÃ¨te. Tout autre nombre est refusÃ© par le runtime et le validateur de configuration.

BoÃ®te de commande mÃ©moire rÃ©servÃ©e au futur menu : `g_rcsm_requested_fps`; Ã©tat confirmÃ© `g_rcsm_applied_fps` (0 = non confirmÃ©), attente `g_rcsm_fps_pending`. Le moniteur copie la demande validÃ©e vers son contrÃ´leur. Une demande durant une manche ne modifie pas les acteurs ni les correctifs actifs; elle attend une nouvelle activation vÃ©rifiÃ©e. Une simple relance de manche en30 peut ne pas recharger le module : dans ce cas la demande reste en attente. Le redÃ©marrage complet avec l'INI choisi reste le protocole de comparaison fiable Ã  tester. La boÃ®te mÃ©moire n'est pas persistÃ©e sur disque. Aucun menu visible ni raccourci FPS livrÃ© dans cette version.

## Menus : nouvelles preuves

`menu-audit/` et les journaux parent `connection/menu-readonly-*` : la session actuelle utilise l'Ã©cran17, table de routage vers RVA0xAE038, appel rÃ©el de RVA0xB25AC. Objet PAUSEMENU rÃ©solu depuis la paire LUI/addiu Ã  B25CC/B25D4 : adresse courante155309128. Deux nÅ“uds, textes localisÃ©s448/449, routes100/101, tous actifs/visibles. Ce n'est pas une preuve de l'objet du menu pause gÃ©nÃ©ral. La validation parcourt directement les nÅ“uds et leurs routes dans cette routine, sans GetCurrentItemNode : intercepter cette seule fonction ne suffirait pas.

Render RVAACE6C lit le flag texte+0xC : non nul utilise directement le pointeur; zÃ©ro passe par localisation109D48. L'ABI du jeu utilise a0-a3 puis t0-t3 et pile+0 pour AddItem; ne pas inventer un prototype o32 classique. Les globaux BSS ont une relocalisation par segment : la paire originale183A90 ne signifie pas base+183A90. La paire liveADDCC/ADDD0 rÃ©sout157023512, oÃ¹ screen+0xC=17. L'analyse initiale B71E0 est une mauvaise piste corrigÃ©e; utiliser `current-screen17-real.asm`.

Le menu indÃ©pendant doit prÃ©server les entrÃ©es vanilla, garder sa mÃ©moire dans le plugin, consommer ses commandes avant le routeur natif et restaurer le menu parent sur retour. Prochaine Ã©tape aprÃ¨s essai du plugin : hook protÃ©gÃ© de navigation/rendu sur le bon menu et validation en jeu. Aucun hook UI posÃ© dans cette version.

## Limites et travaux restants

Recul roquettes joueur/ennemis, cooldown Ã©nergÃ©tique et mini-jeux lancer/guidage restent Ã  traiter. Clignotement pause : candidat existant non appliquÃ©. Tests gameplay des correctifs intÃ©grÃ©s encore nÃ©cessaires; validations utilisateur antÃ©rieures restent qualitatives. Archives originales prÃ©servÃ©es.

Reproduction : `build-windows.py`, `check-integration.py`, `sources/profiler/tools/run_host_checks.py --cc <zig.exe> --cc-arg cc`, puis `validate_prx.py --pspdev <toolchains/pspdev-win>`. `prepare-live-verifier.py` rÃ©gÃ©nÃ¨re les mÃ©tadonnÃ©es ELF aprÃ¨s compilation. `add-fps-backend.py` et `check-fps-configs.py` sont des scripts de migration ponctuels, ne pas les rejouer : leurs changements sont dÃ©jÃ  intÃ©grÃ©s. `verified-prx-inputs` contient des copies privÃ©es du jeu et ne doit pas Ãªtre distribuÃ©.
