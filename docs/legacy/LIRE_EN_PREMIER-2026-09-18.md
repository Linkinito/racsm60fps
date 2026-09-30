# Reprise du projet Overcompensated — 18 septembre 2026

## Commencer ici
Ce dossier rassemble une copie du travail, des recherches, des versions, des outils, de la documentation, du profil PPSSPP (plugins, réglages et sauvegardes), du jeu et des dumps, ainsi que de l'émulateur. Les originaux restent à leur emplacement habituel. La copie n'est pas une installation portable : certains scripts contiennent des chemins absolus vers les originaux. Les examiner avant exécution.

## Organisation
- 01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14 : sources, historiques déjà exportés, versions, captures, recherches, sessions et outils.
- 01-Travail-et-profil-PPSSPP/Documentation-Overcompensated-2026-09-15 : documents et scripts de mise en page.
- 01-Travail-et-profil-PPSSPP/PSP : copie du profil, des plugins et des sauvegardes.
- 01-Travail-et-profil-PPSSPP/RACSM_Controls : travail sur les contrôles.
- 02-Jeu-et-dumps : ISO, fichiers extraits et dumps mémoire.
- 03-Emulateur : copie des fichiers de l'installation PPSSPP.
- MANIFESTE_SHA256.csv et VERIFICATION.json : inventaire et résultat du contrôle des copies.

## État confirmé lors de cette consolidation
Le patch.prx du profil correspond à la version 0.6.4-no-menu-dev.1 décrite dans research-2026-09-18-global/RETRAIT_MENU.md. SHA-256 relu : 2c043c8bb8e3bc02da314d05227b2d67f3f1ee79dea7194126ef77e6c0203ddc.
Le dossier du plugin contient plugin.ini.desactive-pour-test et aucun plugin.ini : le fichier d'activation est désactivé. Cela ne prouve pas l'état d'une éventuelle session déjà en mémoire.
Les anciennes notes ETAT_ACTUEL.md et START_HERE.md contiennent des informations historiques contradictoires et ne doivent pas servir seules à déterminer la version actuelle. Elles sont conservées sans réécriture.

## Décisions et objectif pour reprendre
Le toggle/menu est retiré du périmètre actuel. La priorité est l'inventaire des comportements affectés par le 60 FPS, des ennemis, mobys, véhicules, gadgets et armes, de Pokitaru à Quodrona et au High Impact Treehouse. Documenter les adresses vanilla, les mots originaux, les modifications candidates et leur niveau de preuve. Préparer ensuite un premier patch global à tester. Le mod reste un plugin PRX : ne pas modifier l'ISO de référence.

## Derniers résultats à consulter
Dans 01-Travail-et-profil-PPSSPP/Overcompensated-Reprise-2026-09-14 :
1. research-2026-09-18-global/RETRAIT_MENU.md : variante sans menu, correction de la garde de cave Metalis, validations hors jeu et limites.
2. development-v0.6.4-no-menu/ : sources et construction de cette variante, sauvegarde du plugin précédent.
3. research-2026-09-18-global/AUDIT_HISTORIQUE.md : réévaluation des travaux antérieurs, notamment des résultats à confirmer.
4. research-2026-09-18-global/patch_audit_summary.json, patch_ledger.csv, wrapper_ledger.csv et prx_hashes.csv : audit statique.
5. research-2026-09-18-global/metalis_transfers.csv et metalis_transfer_gaps.csv : transferts candidats et manques.
6. research-2026-09-18-global/static-inventory et weapons-gadgets : inventaires complémentaires.
7. research-2026-09-18-global/iso_verification.json : comparaison des modules des ISO.

L'historique de la tâche « Recenser impacts du patch 60 fps » rapporte 15 PRX vérifiés, 1 470 entrées de patch, 493 appels de wrappers et 20 nouveaux transferts statiques candidats, sans validation en jeu de ces transferts. Ces nombres ne constituent pas une nouvelle exécution des audits aujourd'hui.
Cet historique rapporte aussi 15/15 modules conformes à la référence pour l'ISO portant le nom complet du jeu, contre 14/15 pour copy.iso. Ne pas assimiler copy.iso à la référence vanilla.

## Suite recommandée
Relire les rapports du 18 septembre et distinguer validation statique, observation en jeu et hypothèse. Vérifier une session vanilla démarrée proprement (sans plugin ni cheat, sans savestate patché), puis poursuivre l'inventaire et les comparaisons de durées/vitesses. Ne pas qualifier le patch global de validé avant ces essais.

## Historique et limites de cette archive
Les historiques déjà présents dans les fichiers du projet sont copiés. Ce dossier ne prétend pas contenir un export intégral de toutes les conversations Codex/ChatGPT. Tâche récente consultée : Recenser impacts du patch 60 fps, identifiant 01a0b174-1aae-7be2-a254-21b3874bd4c6.
La consolidation ne lance aucun jeu, ne réactive aucun plugin et ne restaure aucune sauvegarde. Elle conserve aussi les versions anciennes pour leur traçabilité.
