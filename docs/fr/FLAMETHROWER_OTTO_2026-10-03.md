# Flamethrower et Otto à 60 FPS — état mesuré (03/10/2026)

État plus récent (FG-v3 testé, Laser/Agents) : [WEAPONS_60FPS_STATUS_2026-10-03.md](WEAPONS_60FPS_STATUS_2026-10-03.md).

Version anglaise : [../FLAMETHROWER_OTTO_2026-10-03.md](../FLAMETHROWER_OTTO_2026-10-03.md).
Toutes les valeurs viennent de mesures en jeu (PPSSPP 1.20.4, UCES00420).
A0 = jeu original à 30 FPS ; C1 = 60 FPS sans correction. Aucune correction
n'est encore validée.

## Flamethrower

| Ce qu'on mesure | A0 | C1 | Bilan |
| --- | --- | --- | --- |
| Mises à jour de l'arme | 60/s (2 par image) | 60/s (1 par image) | déjà identique |
| Munitions consommées | 4/s | 4/s | déjà identique |
| Requêtes de dégâts (tir maintenu) | 30/s | 60/s | **2× trop en C1** |
| Coups acceptés sur Otto | 30/s | 60/s | **2× trop en C1** |
| Dégâts par coup sur Otto | 2,6667 | 2,6667 | identique |

**Pourquoi :** en A0, l'arme est mise à jour deux fois par image, mais le
« verrou » qui déclenche les dégâts n'est consommé qu'une fois par image. En
C1, il est consommé à chaque image, donc deux fois plus souvent.

**Décision :** on garde les dégâts d'origine par coup et on remet les requêtes
à 30 Hz. Diviser les dégâts par deux aurait gardé deux fois trop de coups,
alors que chaque coup accepté a des effets propres (réactions, dégâts
secondaires différés).

**Livraison :** le plugin FlamerGate retrouve le code du Flamethrower sur
chaque niveau (validé sur Pokitaru et Quodrona). La version avec le filtre
(FG-v2, deux crochets selon la conception de GPT) est construite mais pas encore testée. La boule de feu du relâchement
est un autre chemin de dégâts, pas encore mesuré.

## Otto (boss de Quodrona)

- Bouclier de 500, puis vie de 5000. On mesure 2,6667 par coup, mais son code
  n'a pas de multiplicateur : la différence viendrait de dégâts secondaires
  différés, déclenchés par les coups acceptés (à confirmer en jeu).
- Le bouclier revient d'un coup après une fenêtre de vulnérabilité :
  6,9 à 8,0 s en A0, seulement 4,3 à 5,1 s en C1.
- Certaines de ses animations (2, 3, 6 et 13 ; son vrai état logique est
  ailleurs dans sa mémoire) sont comptées en images :
  elles vont 2× trop vite en C1. Les autres sont comptées en temps et sont
  déjà correctes.
- La phase 2 (sans bouclier) commence sous environ 60 à 66 % de vie (constante du jeu ~0,66), vérifiée à un
  changement d'état. À 0 de vie, il passe d'abord par l'animation de colère
  (2,4 s, intuable), puis meurt.

## Suite

GPT confirme dans le code les phases d'Otto et la conception du filtre ; on
teste ensuite A0, C1 et C1 + filtre sur Otto depuis la même sauvegarde d'état ;
puis on avance dans le registre de couverture : chaque niveau d'arme, chaque
mod et chaque pouvoir d'armure.
