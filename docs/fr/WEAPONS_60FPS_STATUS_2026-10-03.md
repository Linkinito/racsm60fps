# Les armes à 60 FPS — état mesuré, fin du 2026-10-03

Version anglaise : [../WEAPONS_60FPS_STATUS_2026-10-03.md](../WEAPONS_60FPS_STATUS_2026-10-03.md).
Mesures en direct avec PPSSPP 1.20.4, UCES00420. A0 = 30 FPS d'origine, C1 =
60 FPS sans correction (trois mots de code). « TESTÉ » veut dire mesuré dans le
cadre indiqué seulement : rien ici n'est encore une version validée.

## Lance-flammes — plugin FlamerGate FG-v3 (expérimental)

FG-v3 retrouve ses emplacements par leur forme dans le code de chaque niveau,
n'agit qu'en C1 et remet le code d'origine sinon. Il ne laisse passer la
vérification de touche, l'allongement du mod 19 et les dégâts secondaires
qu'une image sur deux, comme en A0.

| Vérification (boss Otto, Quodrona) | A0 | C1 + FG-v3 |
| --- | --- | --- |
| Dégâts par image A0 au contact, V1 / V4 / V5 / V8 + mods | 0,63 / 2,67 / 6,0 / 21,33 | identiques |
| Dégât secondaire par image A0 ratée (V8) | +4,67 | +4,67 |
| Taux de touche à distance et orientation égales (V1) | ex. 0,41 à 5 unités | 0,41 |
| Charge de la boule de feu / dégâts | +2 par image / 70 | +2 / 70 |

Aussi TESTÉ : FG-v3 fonctionne sur Pokitaru après un changement de niveau ;
la boule de feu sur les ennemis ne passe pas par le correctif des dégâts
secondaires. Non testé : rangs V2, V3, V6, V7 (seules les valeurs changent),
autres niveaux. Point mineur : selon la phase, le premier dégât secondaire
d'une rafale arrive une image à 60 FPS plus tard (mêmes nombre et valeurs).

## Laser Tracer — défaut trouvé, correctif construit

En C1, dégâts (5,0 → 10,0 par image A0 sur Otto, V1) et munitions doublent.
Deux causes séparées, chacune corrigée en émulation au débogueur : un drapeau
« première mise à jour » toujours allumé à 60 FPS (munitions) et l'appel des
dégâts du rayon exécuté à chaque image (dégâts). Il faut les deux. FG-v4 les
contient (construit, pas encore lancé).

## Agents of Doom — durée de vie corrigée en émulation

La vie d'un agent est un compteur de 900 qui baisse de 1 à chaque mise à jour :
30 s en A0, 15 s en C1. Un pas de 0,5 rend 30 s (TESTÉ sur Quodrona). FG-v4 le
contient. Attaques, dégâts et les deux mods : pas encore mesurés.

## Gant à Bombacide

Pas encore mesuré.

## FG-v4 (expérimental, construit)

Ajoute les correctifs Laser et Agents, activables séparément ; la partie
lance-flammes ne change pas. Une recherche hors jeu dans les modules d'origine
trouve chaque emplacement de façon unique dans les niveaux 01 à 10, 23 et 24.

## FG-v5 (expérimental, construit)

Les corrections optionnelles deviennent une table de modifications contrôlées,
et deux corrections mesurées d'abord sur Pokitaru s'y ajoutent : la mise à jour
des armes reçoit deux fois le pas de temps C1 (en A0 elle tournait deux fois
par image ; à 60 FPS le Blaster tirait deux fois moins vite), et les formules
de vitesse et de durée de vie des tirs du Blaster utilisent 60 mises à jour par
seconde. Une recherche hors jeu les trouve dans tous les niveaux normaux ; le
niveau 02 (déjà une seule passe par image) est exclu de la correction du pas de temps.
