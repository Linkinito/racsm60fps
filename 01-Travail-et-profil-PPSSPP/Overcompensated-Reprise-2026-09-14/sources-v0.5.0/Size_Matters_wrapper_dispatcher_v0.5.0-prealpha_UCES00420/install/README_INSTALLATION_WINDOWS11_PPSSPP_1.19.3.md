# Installation — PPSSPP 1.19.3 / Windows 11

## Première installation recommandée

Utiliser `ready_zips/RCSMDispatcher_v0.5.0_STAGE05A_METALIS_ALL_TWO_PASS_UCES00420.zip`. Les deux autres archives sont des paliers expérimentaux ultérieurs et ne doivent pas être installées avant validation de 05A.

1. Fermer complètement PPSSPP.
2. Copier ailleurs l'ancien dossier `PSP/PLUGINS/SizeMattersWrapperProfiler`, puis le supprimer du memstick actif.
3. Extraire le ZIP choisi à la racine du memstick PPSSPP.
4. Vérifier la présence de `PSP/PLUGINS/SizeMattersWrapperProfiler/patch.prx`, `plugin.ini` et `RCSMProfiler.ini`.
5. Désactiver les anciens cheats 60 FPS pour le premier lancement 05A.
6. Démarrer UCES00420 et entrer sur Metalis.

Le plugin crée son `status.log` et ses traces dans le même dossier. `L + R + SELECT` force un export, tandis que `L + R + START` remet les compteurs à zéro.

## Changement de palier

Chaque changement de ZIP exige une fermeture complète de PPSSPP. Il ne suffit pas de revenir au menu du jeu, car le module et ses instructions peuvent rester chargés.

Ne mélangez pas les fichiers de plusieurs paliers. Le binaire `patch.prx` est identique, mais le fichier `RCSMProfiler.ini` détermine les routes installées au démarrage.

## Désinstallation

Fermer PPSSPP puis supprimer le dossier `PSP/PLUGINS/SizeMattersWrapperProfiler`. Cette opération supprime les journaux et traces présents dans ce dossier ; copiez-les avant si vous souhaitez les conserver.
