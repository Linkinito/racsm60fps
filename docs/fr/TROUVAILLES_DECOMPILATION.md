# Trouvailles de décompilation — LEVEL_01 (Pokitaru), projet 60 FPS

Version anglaise : [../DECOMPILATION_FINDINGS.md](../DECOMPILATION_FINDINGS.md).
Niveaux de preuve : OBSERVÉ (lu dans le code ou la mémoire), DÉDUIT (raisonné), TESTÉ /
validé par le propriétaire (vu en jeu), REJETÉ. Les noms sont provisoires. Les adresses sont des
décalages dans le module LEVEL_01 ; en jeu, il faut ajouter l'adresse de chargement. Aucun code du
jeu n'est publié : le C décompilé, la base Ghidra et les listings restent en local.

## 1. Méthode

- Ghidra 12.0.4 + Allegrex en mode automatique, sur une copie locale protégée du projet :
  5045 fonctions décompilées sur 5045, 496 noms automatiques tirés de la table des classes (150
  classes), plus 133 annotations écrites à la main (`level01-annotations.json`, appliquées par
  `ghidra/ApplyAnnotations.java`).
- Des scripts déterministes (`research/scripts/`) transforment des formes de code en listes : pas
  fixes, minuteries en frames, constantes 1/30, conversions x30, compteurs d'âge, phases,
  utilisateurs de l'horloge, ressorts. Chaque liste porte l'empreinte de sa méthode et se régénère.
- Vérifications en jeu via le débogueur WebSocket de PPSSPP ; depuis le 01/10, un suivi chiffré dans
  le plugin mesure les vitesses par seconde de jeu (`tools/runtime/fix-monitor.py`).

## 2. Pourquoi le jeu va 2x trop vite à 60 FPS

Le jeu fait une mise à jour par image affichée. Le « delta » commun (1/30 s) est lu en `0x151E0`
et transmis aux entités, mais la plupart du code de jeu l'ignore et avance d'un pas fixe à chaque
appel. C1 (trois mots : retirer la 2e attente VBlank en `0x96650`, delta 1/30 -> 1/60 en `0x151E0`,
sous-étapes du joueur 2 -> 1 en `0x2FCFC`) donne 60 mises à jour par seconde et corrige tout ce qui
utilise le delta (Ratchet, les animations, le Blaster). Tout ce qui ajoute une constante par mise à
jour tourne deux fois plus souvent. Les solutions globales (demi-cadence, interpolation, diviser
tout changement par deux) ont été testées et rejetées (saccades, interactions cassées) : on corrige
donc famille par famille.

## 3. Structure du moteur (OBSERVÉ)

| Élément | Adresse | Notes |
|---|---|---|
| Boucle du niveau | `0x13F0C` | tant que l'état vaut -1 : compteur `0x2AF28C` +1, puis la frame `0x159DC` |
| Mise à jour principale | `0x1517C` | delta en `0x151E0` ; appel pompe 1 en `0x15230` ; pompe 2 ; particules |
| Pompe 1 | `0x6B7F4` | groupes d'entités (pas 0x50), fiches de 0x80 octets, appel `(delta, entité)` |
| Fiche d'entité (moby) | +0x30 position, +0x54/+0x58 données de la classe, +0x64 drapeaux, +0x70 âge/minuterie, +0x76/+0x77 rayons d'activation/affichage | le pointeur de données dépend de la classe (crabe +0x58, papillon +0x54) |
| Joueur | segment 1 + 0x5A838, vie en +0x964 | |
| Particules | parcours `0x8CC18`, appel des animateurs en `0x8CE54` ; 49 réserves ; allocation `0x8C86C`/`0x8C8A8` | une particule morte est remplacée par la dernière |
| Ressort | `0xE290` : `v = (cible-x)k - v d ; x += v` à chaque appel | sert aux rotations, portes, manivelles |
| Compteur de frames | `0x2AF28C` | +1 par frame ; sert d'horloge à plus de 30 fonctions |
| Caméra | entrée `0x3060`, lacet `0x35B0`, tangage `0x37AC`, suivi `0x7740`, FOV `0xAD0` | pas en 1/30 par appel |
| Constantes de vue | `0x2AA3C0` | FOV 0,5498 rad, plans 1 et 10000 ; distance 5,0 (+0x30) ; hauteur 1,14 (+0x3C) ; même motif dans les 15 niveaux vérifiés |
| Manette | `0x75454` | lecture de la manette |

## 4. Familles de corrections (outil `tools/runtime/fixes.py`, catalogue : [../FIX_CATALOGUE_2026-10-01.md](../FIX_CATALOGUE_2026-10-01.md))

| Famille | Ce qui a été trouvé | Correction | État |
|---|---|---|---|
| nav, nav2 | déplacements au sol par vecteur fixe par appel | vecteur divisé par 2 | validé (crabes) |
| crab, crabtimers | minuterie d'état (19 rechargements) et seuil d'attaque 27 ; délai de récupération 15,0 x (1 à 1,3) | x2 / 30,0 | `crab` validé ; l'ancien lot de 29 instructions est REJETÉ par l'audit de GPT-6 (10 n'étaient pas des minuteries, dont des drapeaux partagés par toutes les entités) ; `crabtimers` révisé à tester |
| butterfly | vitesse et battement d'ailes tirés à l'apparition, ressort | /2, réajusté | validé (mesure x1,00) |
| cows | trois fonctions de déplacement (vaches mutantes, Agent of Doom) | /2 | à tester |
| frametimers | 29 minuteries qui retirent 1/30 par appel | 1/60 | à tester |
| frames30 | 17 conversions secondes x 30 | x 60 | à tester |
| age70 | âge +1 par appel (projectiles, voitures volantes, mine-abeille) | +0,5 | à tester |
| phases | 24 fondus/comptes à rebours/phases à pas fixe | /2 | à tester |
| clock | 16 fonctions utilisant le compteur de frames comme horloge (dont le chrono du point de compétence) | copie à 30 Hz | à tester |
| springs | 28 réglages du ressort | réglages 60 Hz calculés | à tester |
| particles(-all) | 47 animateurs à pas fixe | demi-pas générique | à tester |
| spawn | émetteurs à nombre fixe par frame | moitié pour les émetteurs continus | à tester |
| waterfall | apparition une frame sur deux, défilement de texture | une sur quatre, /2 | à tester |
| firerate | le feu émet 0,667 particule par frame | 0,333 | à tester |
| pathanimals | marche, chute et rotation des animaux | /2, gravité /4, ressort | à tester |
| luna | saut et pause de Luna | /2, x2 | à tester |
| laser, laseracc, laserbeam | consommation, fondus et défilement du rayon | /2, x2 | à tester |
| elevator, boatfade, crank | ascenseur, fondu du bateau, écrous de manivelle | 1/60, /2 | à tester |

Rejetés après lecture du code : `0x6C318` (calcule un point d'attache absolu ; les gels venaient
des registres, pas du temps), `0x7248` (caméra des bonus), EnemyWave +0x15C (nombre d'ennemis).
Solutions globales D1, G1, G, GI, F1, H, I : rejetées en jeu le 30/09.

## 5. Plugins

- **InterpGate IG-v16f** (7,8 Ko) : aide passive utilisée par `fixes.py`. Construit sans
  bibliothèque C ni thread : la version de 237 Ko coïncidait avec un crash au chargement de Dayni
  Moon ; avec IG-v16f le niveau se charge. `fixes.py` refuse d'écrire si la version chargée n'est
  pas la bonne ou si le niveau n'est pas Pokitaru.
- **OCEnhance** (environ 9 Ko) : options facultatives, désactivées sauf dans `ocenhance.ini` :
  caméra au stick droit, L2/R2, FOV, distance et hauteur de caméra. Fonctionne dans tous les
  niveaux grâce aux signatures. Pas encore testé en jeu.

## 6. Reste à faire

- Porter les familles validées vers les autres niveaux (seul LEVEL_01 est cartographié).
- Suivi chiffré : mesurer la durée des minuteries qui comptent vers le haut (crabe +0x60).
- 16 papillons d'une autre configuration n'ont pas été ajustés en direct.
- Horodatages du compteur aux lecteurs inconnus laissés sur l'horloge du jeu : `0x54EFC`, `0x77098`, `0x783B0`, `0x106698`.
