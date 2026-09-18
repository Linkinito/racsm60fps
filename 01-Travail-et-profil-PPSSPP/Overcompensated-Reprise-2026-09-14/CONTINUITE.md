> Mise à jour : lire [START_HERE.md](START_HERE.md) pour la situation actuelle. Sept chats / 88 échanges archivés ; v0.5.0 et v0.6.0 récupérées et vérifiées ; v0.6.0 installée en detect_only, cheats désactivés. Les mentions ci-dessous de versions manquantes et du plugin v0.4.5 décrivent le snapshot initial. Caméra validée : distance 9,0 et hauteur 1,90.

# Overcompensated — dossier de continuité

État établi le 14 septembre 2026. Objectif immédiat : conserver les acquis et relier PPSSPP à des essais ciblés du 60 FPS fidèle. Les propositions historiques ne constituent pas toutes des validations.

## Récupération et limites

Les trois conversations fournies ont été paginées jusqu'au bout et conservées en JSON et en Markdown dans `history/` :

- **Système PRX MIPS** : 60 échanges, de la proposition du framework à la livraison annoncée v0.5.0.
- **Fix mouvement Ratchet** : 2 échanges, dont la confirmation utilisateur du correctif.
- **Analyse du projet 60 FPS** : 5 échanges, dont la livraison annoncée v0.6.0 et le projet de connexion PPSSPP.

Il s'agit de tous les messages exposés par l'outil pour ces trois chats, pas d'un export de toutes les pièces jointes ou des fichiers du projet ChatGPT. Les références `chatgpt-content-reference` ne fournissent généralement pas de lien téléchargeable. L'outil navigateur échoue à son initialisation. Les conversations antérieures non fournies ne sont pas incluses.

16 archives/documents retrouvés dans Téléchargements sont copiés dans `archives/`, avec chemins d'origine, tailles et SHA-256 dans `archives-manifest.csv`. Les sources complètes v0.4.5 sont extraites dans `sources-v0.4.5/`. Les versions globales SOCLE v0.1.0, EXPERIENCE v0.2.0/v0.2.1, les profileurs v0.4.3/v0.4.4/v0.4.5, les audits de timing, les essais Pokitaru/Kalidon et le prototype de contrôles sont conservés selon cet inventaire.

`snapshot-original/` contient une copie des plugins, cheats, cinq sauvegardes normales et savestates, contrôles et réglages, antérieure à cette reprise. `snapshot-manifest.csv` en fixe les empreintes. Les originaux n'ont pas été remplacés. Le gros journal PPSSPP de 6,38 Go n'a pas été recopié.

Les ISO, cinq dumps RAM et ressources extraites restent à leur emplacement initial, répertoriés dans `game-files.csv`. Le dossier Data contient notamment BIN, ALLLEVELS, GLOBALWAD, HUD et leurs archives, ainsi que RCPM et des copies BACKUP des modules. L'EBOOT déchiffré est également présent sous `PSP/SYSTEM/DUMP/UCES00420_EBOOT.BIN`.

**Manquants prioritaires :** les archives complètes du dispatcher v0.5.0 et du patch global v0.6.0, leurs sources et manifests ; le point d'étape final avec matrice des 59 familles et audit des 13 armes ; les vidéos A/B et anciennes traces remplacées dans le dossier actif. Leurs résultats textuels sont conservés, leurs pièces originales ne sont pas toutes récupérées.

## État local vérifié

| Élément | Résultat |
|---|---|
| Émulateur | PPSSPP Windows 64 bits v1.19.3 |
| Cible des fichiers | UCES00420, Europe |
| Plugin installé | SizeMattersWrapperProfiler v0.4.5-prealpha, binaire identique par SHA-256 au paquet récupéré |
| Configuration du profileur | full_module, allowed_module=3, export_on_transition=true |
| Cheat activé | Test B Kalidon : socle minimal + Titanium, huit écritures, déplacement supposé +0x8000 |
| Réglages | Cheats et plugins activés ; JIT ; frameskip 0 ; AnalogIsCircular=True |
| Contrôles supplémentaires | RACSM_Controls et sources présents à la racine PPSSPP, hors du dossier actif PSP/PLUGINS |
| Changement effectué pour la liaison | RemoteDebuggerOnStartup passé de False à True, après sauvegarde du fichier |

Le cheat Kalidon actuel n'est pas une configuration vanilla ni un patch global v0.6.0. Ne pas le réutiliser avec un nouveau PRX sans vérifier la base runtime : la taille du plugin peut déplacer les modules.

## Acquis techniques à conserver

- Le jeu mélange delta time, mises à jour par image, compteurs privés et événements. Un multiplicateur unique ne suffit pas.
- Le socle retire une seule des deux attentes VBlank, adapte le delta 1/30 vers 1/60, la physique/sous-passes joueur et les deltas caméra. Retirer les deux attentes désynchronise la boucle.
- 493 sites d'appel, 59 familles, 15 profils de modules cartographiés. Les « 55 » désignent les callsites de Pokitaru. Le nombre 58 figurant dans les premiers échanges a été corrigé après découverte d'un appel supplémentaire.
- Le profileur identifie les profils connus et les appelants par `$ra` ; il ne découvre pas automatiquement toute logique dépendant des images.
- Résolution du module par API, translation depuis la base de référence 0x09139D00, gardes d'instructions, redirections transactionnelles, retrait conditionnel, préservation MIPS/FPU et gestion du JIT.
- Les déplacements +0x6000, +0x7000 et +0x8000 ont varié avec les versions. Aucun ne doit devenir une constante universelle.
- Le mot de classe JIT 0x68xxxxxx a déjà causé un faux changement de module ; ce problème et sa correction sont documentés. Ne pas le rediagnostiquer comme corruption sans vérifier les autres gardes.
- Une trace à zéro hit peut être un mode détection ou un chemin non sollicité. Un PASS du parseur valide la structure et les invariants, pas la fidélité du gameplay.
- Les exports cumulatifs ne sont pas des sessions indépendantes. Ne pas additionner leurs compteurs.

## Progression déjà obtenue

| Étape | Résultat historique conservé | Statut de preuve actuel |
|---|---|---|
| Pokitaru, palier 02 | 55 hooks, 34 actifs, 496 697 hits, zéro inconnu ; transition Ryllus | Compte rendu détaillé dans le paquet v0.4.5 et chat |
| Ryllus, palier 03 | 57 hooks, 38 actifs, 122 243 hits ; section Clank ; transition Kalidon | Compte rendu détaillé et chat |
| Kalidon, palier 04 | 33 hooks ; Airboard LEVEL_22 isolé ; retour Kalidon et arrivée Metalis | Chat ; des traces locales subsistent |
| Kalidon A, référence 30 FPS | Passage validé ; 13 callsites actifs dans la capture principale ; 69 173 hits | Analyse du chat, vidéos/ancienne capture originale non récupérées |
| Kalidon B, socle 60 FPS | 33 hooks, 8 actifs, 87 570 hits utiles, zéro inconnu ; Titanium récupéré | Chat + traces locales 0004/0005 revalidées |
| Dispatcher v0.5.0 | Livraison annoncée, 910 contrôles ; traces v5 ; trois paliers Metalis | Texte récupéré, archive manquante, test Metalis non établi |
| Global v0.6.0 | Livraison annoncée ; 15 modules, 600 simulations, 1 294 échecs d'écriture simulés | Texte récupéré ; archive manquante ; explicitement pas testé dans PPSSPP |

La couverture historique agrégée des trois premiers niveaux est de 85/145 callsites dans 32 familles. Ce chiffre n'a pas été recalculé à partir de toutes les traces originales pendant cette reprise.

Sept traces du snapshot ont été revalidées avec le parseur v0.4.5 existant : toutes PASS et zéro `$ra` inconnu. L01, L04 et L22 sont en détection, sans hooks actifs. L03_0001 : 19 287 hits ; L03_0003 : 2 006 ; L03_0004 et L03_0005 : 87 570 chacune, cumulatives et sans nouvelle activité entre les deux. Rapports et CSV dans `trace-validation/`.

## Hypothèses et anomalies déjà localisées

| Sujet | Acquis / hypothèse | Prochain test utile |
|---|---|---|
| WF-002 | Orientation joueur, contexte grindrail proposé ; le socle réduit déjà la cadence extérieure ; TWO_PASS à conserver provisoirement | États joueur/rail/support, éviter une double compensation |
| WF-013 | Direction/orientation d'acteurs, deux composantes ; contexte Crab | Une seule famille modifiée, trajectoire et états mesurés |
| WF-014 | Navigation, trois branches alternatives ; une seule observée sur Kalidon | Isoler les branches et le drapeau 0x40 ; pas de verdict familial définitif |
| WF-021 | Autre chemin de navigation des crabes, sensible aux collisions | Séparer de WF-013/014 ; saut eau-vers-île |
| WF-044 | Lvl3Platform : le fluide reçoit une addition directe avant le wrapper | CUSTOM pour montée d'acide, décision séparée pour le lissage |
| WF-058 | Séquence MungoDrone : 6,10 s en A contre 3,05 s en B rapportées | ONE_PASS ciblé, puis vérifier compteur extérieur si nécessaire |
| WF-016 | HutDoor, cadence doublée avec le socle | Cycle complet, trajectoire et fin d'ouverture |
| Brûleur | Dégâts accélérés confirmés par l'utilisateur ; hors correction du socle | Dégâts, munitions, scans et réactions séparés ; pas seulement vitesse visuelle |
| Mêlée | Décalage animation/dégâts signalé | Fenêtre de contact et unicité de l'événement de dégâts |
| Crabes | Sauts ratés avec ancien wrapper global | A/B puis WF-013/014/021 une à une ; contrôler ancienne constante locale divisée par deux |
| Crabe géant | Instance Crab scale=3.0 à PVar+0x44 dans le dump historique | Identification par structure, jamais adresse d'instance fixe |
| Débris / boulons | Intégrateur à demi-pas candidat partagé ; âge, durée, rebond | Trajectoire, collision, récompense unique et nombre/valeur inchangés |

L'identité précise de certaines familles a évolué et parfois été reformulée entre réponses. Les noms sémantiques restent des hypothèses sauf preuve liée à une fonction/classe et observation. Conserver les anciennes adresses comme coordonnées du corpus, pas comme adresses utilisables aveuglément en direct.

Répartition candidate du point d'étape : 35 ONE_PASS ou ONE_PASS+CUSTOM ; 1 TWO_PASS ; 5 décisions par appelant ; 13 principalement CUSTOM ; 5 insuffisamment identifiées. Ce n'est pas une liste blanche validée pour publication.

Familles silencieuses à solliciter : WF-003 rail ; WF-006 Polarizer ; WF-007 à 010 Agents of Doom (invocation jusqu'à expiration) ; WF-024 Skyboarder01 avant le chargement LEVEL_22 ; WF-030 TMRobotHeadB ; WF-031 CrankedObject. Branches manquantes : WF-001/004, WF-005/015, WF-014, WF-017, WF-019, WF-037, contextes séparés WF-011/012.

## Autres fonctionnalités et choix conservés

- Saut diagonal : utilisateur confirme la correction par AnalogIsCircular=True ; réglage retrouvé actif. Ne pas patcher à nouveau le seuil aérien sans nouvelle anomalie.
- Second stick : prototype et sources récupérés ; caméra deux axes et alias L2/R2. Ancien bilan rapporte R2 fonctionnel, retard L2 et sensibilité à affiner ; ne pas confondre cela avec une nouvelle validation.
- Caméra PS2 : valeur 1.90 retenue selon le bilan récent ; généralisation non validée ici.
- The Big Package / Overcompensated : ambition de mod modulaire, objectif anniversaire évoqué au 13 février 2027. Les textes d'annonce sont des projets, pas une preuve de livraison.
- Long terme : caméra libre pour vidéos sans système réalisateur ; audit du debug avant reconstruction ; statistiques en jeu ; difficulté simple ; deuxième Quick Select si faisable ; replay de segments devenus inaccessibles ; LiveSplit envisagé.
- Non prioritaires : stand de tir, mode photo, HUD repositionnable, fantômes/cartes de chaleur coûteux. Polices/HUD HD préférés. Ne pas élargir la reprise 60 FPS à ces fonctions sans demande.

## Connexion PPSSPP réellement testée

Le 14 septembre, le processus PPSSPP a été lancé sans jeu. Connexion réussie à `ws://127.0.0.1:60907/debugger`, sous-protocole `debugger.ppsspp.org`. Réponses : version v1.19.3, game=null. Preuve JSON dans `connection/probe-1789419834423.json`.

`ppsspp-probe.mjs` demande uniquement version, état du jeu et, si UCES00420 est chargé, le mot d'index du module à 0x08841120. Il n'envoie aucun patch, reset, entrée manette ou chargement de savestate. Le script PowerShell `Connect-PPSSPP.ps1` recherche le port du processus existant pour éviter de supposer que 60907 restera fixe.

La lecture mémoire et l'identification du niveau n'ont PAS encore été exécutées en jeu. Le code PPSSPP 1.19.3 montre que les lectures mémoire peuvent suspendre brièvement le CPU : utiliser cette sonde pour l'identification, pas comme chronomètre à haute fréquence. Les mesures temporelles du profileur restent nécessaires.

Références techniques :

- https://www.ppsspp.org/docs/reference/websocket-api/
- https://github.com/hrydgard/ppsspp/blob/v1.19.3/Core/Debugger/WebSocket/GameSubscriber.cpp
- https://github.com/hrydgard/ppsspp/blob/v1.19.3/Core/Debugger/WebSocket/MemorySubscriber.cpp

## Prochaine session de test

1. Récupérer et auditer les sources v0.5.0/v0.6.0 avant de remplacer le plugin actif. Ne pas reconstruire ces versions de mémoire et leur attribuer le même numéro.
2. Charger normalement UCES00420, puis lancer Connect-PPSSPP.ps1 pour confirmer identité et index de module. Faire correspondre l'index au log et vérifier les gardes/base runtime.
3. Pour une référence vanilla, désactiver les cheats avant un démarrage propre ; conserver la configuration exacte et le hash du PRX. Le profil actuel est le passage B Kalidon.
4. Réutiliser les résultats A/B Kalidon existants. Ne refaire un passage que si une mesure nouvelle manque ou si les fichiers de référence sont irrécupérables pour la comparaison visée.
5. Pour Metalis v0.5 : 05A = 36 TWO_PASS et zéro ONE_PASS/CUSTOM fallback, cheats 60 FPS désactivés. Après validation du chargement et de la base, préparer le socle relocalisé ; 05B = WF-030 seule ; 05C = neuf candidats, seulement après les tests ciblés.
6. Une sauvegarde normale de départ immuable, copie de travail par essai ; même difficulté, armement et scène. Aucun ancien savestate entre versions du plugin. Redémarrage propre entre A/B/C : décocher un cheat ne restaure pas le code déjà écrit.
7. Pour chaque essai : créer un dossier unique, archiver réglages/cheat/PRX et hash, état initial, module/base, logs et traces avant écrasement, vidéo si nécessaire et observation utilisateur. Distinguer exports cumulatifs et essais indépendants.
8. Comparer durée en temps émulé, déplacement, état final, dégâts et événements sur une même durée ; ne pas comparer simplement le même nombre d'images. VBlank, FPS rendu et mises à jour du gameplay sont distincts.
9. Critères d'arrêt : mauvais jeu/module, garde invalide, résolution ambiguë, retours inconnus, crash ou comportement anormal. Un succès visuel isolé ne valide pas tous les systèmes.

## Travail restant pour une récupération exhaustive

- Télécharger les pièces jointes manquantes depuis les trois chats ou les récupérer depuis une copie locale indiquée par l'utilisateur.
- Retrouver, si souhaité, les autres conversations sur caméra, shaders, armes et premiers prototypes, non contenues dans les trois liens fournis.
- Relier le rapport final des 59 familles aux sources effectives v0.5/v0.6 et aux vidéos/traces originales ; ne pas convertir les chiffres annoncés en validations locales.
- Effectuer la première sonde en jeu, puis le prochain test ciblé convenu.
