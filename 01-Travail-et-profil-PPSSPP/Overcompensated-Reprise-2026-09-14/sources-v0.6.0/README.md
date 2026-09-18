# Overcompensated — patch global 60 FPS v0.6.0

Cette version expérimentale intègre le déblocage 60 FPS et les correctifs disponibles dans un seul plugin PRX, pour **Size Matters Europe UCES00420**, avec PPSSPP 1.19.3 sous Windows comme cible de test. Elle reprend le dispatcher v0.5.0 et les correctifs du corpus global v0.2.1, avec une nouvelle intégration relocalisable. Elle est compilée et vérifiée hors émulateur ; elle n'a pas encore été exécutée dans PPSSPP dans cette session et ne constitue pas une version 60 FPS 1:1 validée sur l'intégralité du jeu.

## Installation et premier essai

1. Fermer complètement PPSSPP. Conserver une copie de la sauvegarde normale du jeu et de l'ancien dossier `PSP/PLUGINS/SizeMattersWrapperProfiler` hors du répertoire des plugins.
2. Désactiver les anciens cheats 60 FPS et les autres plugins correcteurs pour ce premier essai. Le nouveau PRX intègre le socle : aucun INI CWCheat supplémentaire n'est nécessaire.
3. Remplacer entièrement le dossier `PSP/PLUGINS/SizeMattersWrapperProfiler` par celui de l'archive. Ce dossier contient exactement `plugin.ini`, `patch.prx` et `RCSMProfiler.ini`.
4. Démarrer le jeu depuis un lancement neuf et charger une sauvegarde normale. Éviter de charger un savestate d'une ancienne version, car il peut réintroduire son code ou une disposition mémoire différente.
5. Entrer sur Metalis et attendre une seconde avant les mesures. Vérifier que le journal contient `full patch armed key=LEVEL_04` et le routage attendu de 28 appels à deux passes et 8 à une passe.
6. Tester déplacement, saut, caméra, destruction de caisses, ramassage de boulons et quelques armes. Terminer par un changement de planète et un retour sur Metalis pour examiner la détection et la réinstallation.
7. Utiliser `L + R + SELECT` une fois en jeu pour exporter une trace. Après fermeture de PPSSPP, conserver `status.log` et les fichiers `trace_*.json` du dossier du plugin.

Le test initial vise à vérifier que l'intégration tient en mémoire et au changement de niveau, puis à relever les comportements encore accélérés. Un compteur de 60 FPS ne suffit pas à valider les dégâts, les collisions ou les transitions d'IA : ces observations doivent rester distinctes du simple succès du chargement.

## Contenu intégré

| Partie | Traitement de cette version |
|---|---|
| Socle temporel | VBlank, delta général, compensation et sous-pas du joueur |
| Caméra et boulons en titane | Reprise des corrections de vitesse existantes |
| Armes | Reprise des correctifs disponibles pour les 13 armes dans les modules qui les contiennent |
| Débris et boulons ordinaires | Reprise de l'intégrateur et des constantes identifiées |
| Particules et effets | Reprise des correctifs identifiés dans le corpus précédent |
| Wrapper | 119 sites candidats à une passe ; 374 restent à deux passes |
| Interfaces et fonctionnalités supplémentaires | Aucun nouveau menu, shader, mapping de manette ou cadrage PS2 ajouté |

Le corpus couvre `LEVEL_01` à `LEVEL_10`, puis `LEVEL_15`, `LEVEL_21`, `LEVEL_22`, `LEVEL_23` et `LEVEL_24`. Le frontend et les modules multijoueur `LEVEL_16` à `LEVEL_20` sont hors de cette version ; les séquences Airboard et Giant Clank sont incluses à titre expérimental, sans validation spécifique de leur gameplay.

Les 32 familles candidates à une passe proviennent du point d'étape et de l'analyse précédente. Les familles transversales WF-013, WF-014 et WF-021 restent à deux passes en attendant de trancher par contexte, et WF-029 reste également à deux passes : Metalis utilise donc 8 routes à une passe, contre 9 dans le profil isolé 05C de la v0.5.0.

## Limites connues à examiner

Les dégâts continus du Brûleur et du Laser, les attaques de mêlée, les hitboxes et l'alignement animation-impact restent à mesurer. Les correctifs repris pour les armes ne constituent pas une preuve que ces problèmes sont résolus ; aucun nouvel ajustement de dégâts n'a été inventé pour les masquer.

L'acide de Kalidon, les sauts de certains ennemis, les phases des boss, les boosts Airboard et les mécanismes ne traversant pas le wrapper restent des cibles prioritaires. Le routage `CUSTOM` conserve ici le chemin à deux passes, de manière explicitement visible dans les traces ; les correctifs spécialisés importés du corpus d'armes fonctionnent séparément et ne sont pas présentés comme des handlers CUSTOM nouvellement validés.

Les 77 constantes initialisées à l'exécution sont corrigées uniquement lorsque leur valeur vanilla attendue est reconnue. Une constante encore nulle ou différente reste inchangée ; la surveillance s'effectue toutes les 100 ms et peut donc laisser un bref délai après une initialisation ou une réinitialisation du jeu.

## Protections ajoutées

Les adresses sont calculées depuis la base réelle du module chargé, et les sauts sont réencodés pour cette base. Les huit routines ajoutées occupent la mémoire appartenant au plugin, sans utiliser les anciennes caves de l'EBOOT à adresses fixes ; le wrapper commun reste intact et les sites d'appel sont routés individuellement.

Avant l'installation, le plugin revérifie le module et les mots attendus, puis applique les écritures pendant une suspension de l'ordonnanceur PSP. Le déblocage VBlank arrive en dernier et les écritures précédentes sont annulées si l'installation échoue ; lors d'un retrait, seules les valeurs encore identifiées comme celles du plugin sont restaurées.

Une transition vers une empreinte différente interdit toute restauration à partir des anciennes adresses. Ces protections ont été vérifiées par simulation et inspection du binaire ; la chronologie réelle du chargeur, les interruptions et les effets sur les performances restent à éprouver dans PPSSPP.

## Journal attendu sur Metalis

Le journal doit annoncer la version `0.6.0-global-experimental.1`, puis le module `LEVEL_04`. Dans ce module, le profil complet installe 106 écritures statiques, surveille 7 constantes initialisées au runtime et route 36 sites d'appel.

```text
full patch armed key=LEVEL_04 static_writes=106 pending_constants=... layers=15 caves=plugin_owned
module armed key=LEVEL_04 index=4 mode=global_60fps callsites=36 two_pass=28 one_pass=8 custom_fallback=13 ...
```

Une ligne `full patch refused` indique une instruction ou donnée non conforme avant installation ; elle donne l'adresse et la valeur observée. Une ligne `full health foreign` indique un changement inattendu après installation ; dans ces cas, transmettre le journal complet permet de distinguer conflit de patch, état de chargement et hypothèse incorrecte sur une donnée runtime.

## Configurations de diagnostic

Le profil global complet est activé dans le dossier `PSP` de l'archive. Les variantes présentes dans `diagnostics` sont des outils d'isolation : elles remplacent uniquement `RCSMProfiler.ini`, avec un redémarrage complet obligatoire entre deux configurations.

| Variante | Fonction |
|---|---|
| `detect_only.ini` | Reconnaissance et journalisation sans correctif de gameplay |
| `socle_reference.ini` | Socle, caméra et titane ; wrapper intégralement à deux passes ; autres couches désactivées |
| `global_default.ini` | Copie du profil global livré |

## Sources et reproduction

Le répertoire `sources` contient le code, les tables, le manifeste antérieur ayant servi à la génération et les rapports de validation. Les fichiers du jeu et les sauvegardes ne sont pas inclus ; le générateur nécessite les PRX originaux correspondant aux empreintes enregistrées.

La compilation utilise PSPDEV v20260301 et `psp-gcc 15.2.0`, comme la version précédente. La chaîne officielle est disponible sur la [page des versions PSPDEV](https://github.com/pspdev/pspdev/releases/tag/v20260301) ; les commandes de reproduction sont dans `sources/profiler/BUILD_REPRODUCIBILITY.md`.
