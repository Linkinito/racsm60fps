from pathlib import Path
import json,hashlib,datetime
r=Path(r'C:\Users\linki\Documents\PPSSPP\Overcompensated-Reprise-2026-09-14');d=r/'development-v0.6.1';p=d/'sources/profiler'
f=d/'check-integration.py';s=f.read_text().replace(",'PSP_compiled':False,'host_C_tests_run':False,'runtime_tested':False,'new_PRX_installed':False",",'scope':'generation only; build, host tests and installation recorded in VALIDATION_SUMMARY.json'");f.write_text(s)
j=json.loads((d/'INTEGRATION_CHECKS.json').read_text());j={k:v for k,v in j.items() if k not in ['PSP_compiled','host_C_tests_run','runtime_tested','new_PRX_installed']};j['scope']='generation only; see VALIDATION_SUMMARY.json';(d/'INTEGRATION_CHECKS.json').write_text(json.dumps(j,indent=2))
prx=json.loads((d/'PRX_VALIDATION_WINDOWS.json').read_text());host=json.loads((d/'sources/HOST_VALIDATION.json').read_text());installed=json.loads((d/'INSTALLATION.json').read_text(encoding='utf-8-sig'))
sha=hashlib.sha256((p/'patch.prx').read_bytes()).hexdigest();assert sha==prx['binary']['prx_sha256']==installed['installed_prx_sha256']
summary={'timestamp':datetime.datetime.now(datetime.timezone.utc).isoformat(),'version':'0.6.1-metalis-integration-dev.2','prx_sha256':sha,'PSP_compiled':True,'binary_audit_checks':prx['checks_passed'],'host_tests':host,'static':j,'installed_on_disk':True,'running_process_version':'0.6.0-global-experimental.1','runtime_tested_new_build':False,'native_menu_hook_implemented':False,'fps_backend':'request/applied state; activation at verified module load; no in-round actor conversion','source_sha256':{str(f.relative_to(p)):hashlib.sha256(f.read_bytes()).hexdigest() for folder in ['src','include','generated'] for f in (p/folder).iterdir() if f.suffix in ['.c','.h','.S']}}
(d/'VALIDATION_SUMMARY.json').write_text(json.dumps(summary,indent=2))
(d/'README.md').write_text('''# Développement v0.6.1 — compilé, testé hors jeu, installé pour le prochain lancement

Version : `0.6.1-metalis-integration-dev.2`. PRX SHA256 : `'''+sha+'''`.

Les 54 ajouts des essais Metalis sont intégrés aux sources : 167 sites dans le moteur de transaction, capacité 192, et correction du compteur de collision dans la cave7 uniquement pour Metalis. Les 14 autres tables restent inchangées. Les vitesses courantes des acteurs ne sont pas enregistrées dans le plugin.

Compilation Windows portable réussie avec PSP GCC15.2.0 (archive dmang-dev v2 vérifiée), `-Wall -Wextra -Werror`. Audit binaire : 912 contrôles réussis. Tests hôte Zig0.15.2 cc : 600 scénarios et1348 échecs d'écriture injectés, profiler, format, traces et contrôleur FPS PASS. Pas de validation ASan/UBSan dans cette exécution. `VALIDATION_SUMMARY.json` relie les preuves au SHA du PRX et aux sources. Les anciens rapports copiés dans sources restent historiques lorsqu'ils mentionnent v0.6.0.

## Prochaine intervention / essai

L'ancien processus PPSSPP est laissé intact, encore en v0.6.0. Le PRX et l'INI v0.6.1 sont installés sur disque (60 FPS demandé). Sauvegarde préalable du plugin, des cinq sauvegardes du jeu et des savestates : `sessions/before-dev061-20260917-003800` dans le dossier parent.

Redémarrer entièrement PPSSPP, puis charger Metalis depuis la sauvegarde normale du jeu. Ne pas charger un ancien savestate pour ce contrôle : il contient l'ancien plugin et l'ancienne mémoire. Mettre en pause et prévenir l'agent. Lancement avec ISO ayant déjà causé un crash AMD, préférer lancement de PPSSPP seul puis ouverture du jeu par l'utilisateur.

Ensuite exécuter `verify-live-metalis.mjs` : sonde en lecture seule, exige le démarrage dev.2 dans le log, résout les nouvelles bases via logs et symboles ELF, vérifie binding,167mots,36redirections,cave7 et mode confirmé. La sonde a été testée contre la session ancienne : refus attendu sans aucune écriture. Ses résultats en nouvelle session restent ATTENDUS. Ne pas rejouer les scripts mémoire v0.6.0 à leurs anciennes adresses.

## Choix 30/60 : moteur prêt, interface native encore à raccorder

`frame_rate = 30` ou `60` dans RCSMProfiler.ini, lu au démarrage. Le mode global doit rester `global_60fps` (nom historique du moteur). Le choix30 ne pose aucun correctif de jeu et exige la vérification des sites statiques originaux et des redirections d'origine. Le choix60 suit la transaction complète. Tout autre nombre est refusé par le runtime et le validateur de configuration.

Boîte de commande mémoire réservée au futur menu : `g_rcsm_requested_fps`; état confirmé `g_rcsm_applied_fps` (0 = non confirmé), attente `g_rcsm_fps_pending`. Le moniteur copie la demande validée vers son contrôleur. Une demande durant une manche ne modifie pas les acteurs ni les correctifs actifs; elle attend une nouvelle activation vérifiée. Une simple relance de manche en30 peut ne pas recharger le module : dans ce cas la demande reste en attente. Le redémarrage complet avec l'INI choisi reste le protocole de comparaison fiable à tester. La boîte mémoire n'est pas persistée sur disque. Aucun menu visible ni raccourci FPS livré dans cette version.

## Menus : nouvelles preuves

`menu-audit/` et les journaux parent `connection/menu-readonly-*` : la session actuelle utilise l'écran17, table de routage vers RVA0xAE038, appel réel de RVA0xB25AC. Objet PAUSEMENU résolu depuis la paire LUI/addiu à B25CC/B25D4 : adresse courante155309128. Deux nœuds, textes localisés448/449, routes100/101, tous actifs/visibles. Ce n'est pas une preuve de l'objet du menu pause général. La validation parcourt directement les nœuds et leurs routes dans cette routine, sans GetCurrentItemNode : intercepter cette seule fonction ne suffirait pas.

Render RVAACE6C lit le flag texte+0xC : non nul utilise directement le pointeur; zéro passe par localisation109D48. L'ABI du jeu utilise a0-a3 puis t0-t3 et pile+0 pour AddItem; ne pas inventer un prototype o32 classique. Les globaux BSS ont une relocalisation par segment : la paire originale183A90 ne signifie pas base+183A90. La paire liveADDCC/ADDD0 résout157023512, où screen+0xC=17. L'analyse initiale B71E0 est une mauvaise piste corrigée; utiliser `current-screen17-real.asm`.

Le menu indépendant doit préserver les entrées vanilla, garder sa mémoire dans le plugin, consommer ses commandes avant le routeur natif et restaurer le menu parent sur retour. Prochaine étape après essai du plugin : hook protégé de navigation/rendu sur le bon menu et validation en jeu. Aucun hook UI posé dans cette version.

## Limites et travaux restants

Recul roquettes joueur/ennemis, cooldown énergétique et mini-jeux lancer/guidage restent à traiter. Clignotement pause : candidat existant non appliqué. Tests gameplay des correctifs intégrés encore nécessaires; validations utilisateur antérieures restent qualitatives. Archives originales préservées.

Reproduction : `build-windows.py`, `check-integration.py`, `sources/profiler/tools/run_host_checks.py --cc <zig.exe> --cc-arg cc`, puis `validate_prx.py --pspdev <toolchains/pspdev-win>`. `prepare-live-verifier.py` régénère les métadonnées ELF après compilation. `add-fps-backend.py` et `check-fps-configs.py` sont des scripts de migration ponctuels, ne pas les rejouer : leurs changements sont déjà intégrés. `verified-prx-inputs` contient des copies privées du jeu et ne doit pas être distribué.
''',encoding='utf-8')
f=r/'START_HERE.md';s=f.read_text();f.write_text('''> REPRISE 17sept00:38 : dev.2 COMPILE / TESTE HOTE / INSTALLE SUR DISQUE, processus en cours encore v0.6.0 inchangé. Lire development-v0.6.1/README.md + VALIDATION_SUMMARY.json. 54ajouts/167sites/cave7 intégrés;912contrôlesbinaires,600scénarios+1348échecsinjectés PASS. Backend FPS30/60 différé implémenté, MENU NATIF PAS ENCORE RACCORDE. Prochaine action utilisateur : redémarrage COMPLET PPSSPP, charger Metalis par sauvegarde normale (pas savestate), pause. Puis sonde development-v0.6.1/verify-live-metalis.mjs en lecture seule. Nouvelles bases attendues, jamais appliquer vieuxscripts. Backup sessions/before-dev061-20260917-003800. NouveauPRXSHA67c16bc1caafc6d340de785f4bf0e15de61ce40f41699a3699cb5b71cd8e9341. Anciennes mentions NON COMPILE ci-dessous historiques.

'''+s,encoding='utf-8')
print('Validation summary and handoff updated')
