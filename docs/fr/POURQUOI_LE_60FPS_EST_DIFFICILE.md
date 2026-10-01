# Pourquoi le 60 FPS est si difficile dans Size Matters

Version anglaise : [../WHY_60FPS_IS_HARD.md](../WHY_60FPS_IS_HARD.md).
Analyse du code de Pokitaru (LEVEL_01) et mesures en jeu (30 septembre – 2 octobre 2026).

## En bref

Le jeu n'a pas **une** façon de compter le temps, il en a au moins **huit**, mélangées dans les mêmes
objets. Une seule d'entre elles (le « delta » transmis aux entités) suit la vitesse d'affichage. Le jeu
d'origine tourne toujours à 30 images par seconde : les développeurs pouvaient donc écrire « par image »
ou « par seconde » indifféremment. Passer à 60 casse tous les endroits qui comptaient sur cette
équivalence. Pire : une partie du jeu (la boucle du joueur) tournait déjà à 60 Hz dans l'original, avec
un temps doublé ; le même réglage qui en corrige une moitié en ralentit l'autre.

## Les huit façons de compter le temps

| # | Domaine | Comment le temps avance | À 60 FPS | Exemples | Correction |
|---|---|---|---|---|---|
| 1 | Temps écoulé (delta) | `x += vitesse × dt` | juste | animations de Ratchet, vaisseau ennemi, requin | aucune |
| 2 | Pas fixe par mise à jour | `x += k` à chaque image | 2× trop vite | déplacement des crabes, papillons, animaux, ascenseur, bateau | diviser le pas par 2 |
| 3 | Minuteries en images | `t -= 1` par image, durées pensées pour 30 images/s | 2× trop vite | états du crabe, TrainingBot, Luna, HUD (`frames30`) | doubler les durées |
| 4 | Pas de 1/30 écrit en dur | `t -= 0,0333` par appel | 2× trop vite | vagues d'ennemis, aide, téléporteur, caméra | passer à 1/60 |
| 5 | Lissages, ressorts et filtres | `v = (cible-x)k - v·d` par appel ; pour la caméra, un filtre amorti exact avec 1/30 s figé dedans | 2× trop rapide | rotation de tous les PNJ, portes, manivelles, 20 filtres de caméra | recalculer k et d ; pour la caméra, conversion exacte (k = ω/60, racine carrée de l'exponentielle) |
| 6 | Compteur global d'images | +1 par image, utilisé comme horloge | 2× trop vite | déclencheurs « toutes les 4 images », chrono du point de compétence | copie à 30 Hz |
| 7 | Systèmes à part (particules, boulons, débris) | leur propre physique par image | 2× trop vite | 49 types de particules, boulons et débris de caisses (`0x2832C`) | mise à jour une image sur deux, dessin à chaque image ; demi-pas |
| 8 | Boucle du joueur | en original : 2 passages par image, chacun avec un temps de 1/30 s | pas fixes justes, mais tout ce qui utilise le temps va 2× trop lentement | minuteries d'attente de Ratchet, cadence du Blaster (mesurée : 4,2 tirs/s contre 2,0) | doubler le temps transmis (à valider) |

À cela s'ajoutent des éléments du moteur principal (EBOOT), hors du module du niveau : écrans de
chargement (corrigés par l'autre session), et probablement le défilement de l'eau.

## Pourquoi une correction globale ne peut pas marcher

- Mettre tout à jour une image sur deux remet les vitesses mais saccade et casse les interactions (rejeté).
- Diviser par deux tout ce qui change abîme les données qui ne sont pas des nombres (couleurs, drapeaux).
- Doubler toutes les durées casse des valeurs qui ressemblent à des durées mais n'en sont pas
  (10 instructions sur 29 dans l'ancien lot du crabe).
- Le domaine 8 va dans l'autre sens : il faut lui donner **plus** de temps, pas moins.

## Conséquence pour le patch

On classe chaque mécanisme dans un domaine, on applique la transformation correspondante, on mesure avec
le suivi chiffré par rapport au jeu original, et tu valides visuellement. Les domaines 2 à 6 se règlent
par des retouches de données ou d'instructions ; le 7 par le plugin InterpGate ; le 8 doit être confirmé
en jeu. Détail des corrections : [../FIX_CATALOGUE_2026-10-01.md](../FIX_CATALOGUE_2026-10-01.md).
