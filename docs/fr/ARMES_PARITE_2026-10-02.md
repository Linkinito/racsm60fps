# Les armes à 60 FPS — état de la parité mesurée (2026-10-02)

Version anglaise détaillée : [../WEAPONS_PARITY_2026-10-02.md](../WEAPONS_PARITY_2026-10-02.md).
Mesures en direct dans PPSSPP 1.20.4, sur Pokitaru, au même endroit. A0 = jeu original à 30 FPS,
C1 = 60 FPS sans correction.

## Résultats

| Arme | Mesure | A0 | C1 | C1 + corrections |
|---|---|---|---|---|
| Lacérators (Blaster) | cadence | 4,134 tirs/s | 1,842 | **4,133** |
| | vitesse des tirs | 125,9 u/s | ~255 | **125,7** |
| Ryno (TELT) | cadence | 0,500 s | 0,467 s | **0,501 s** |
| | roquettes | 24 u/s, 1,13 s | 48 u/s, 0,57 s | **24 u/s, 1,17 s** |
| Canon Tremblator | cadence | 0,767 s | 1,52 s | **0,767 s** |
| | durée de l'onde de choc | 14 images (30 Hz) | ~7 | en cours (~12 sur 14) |

Les 10 autres armes ne sont pas encore mesurées.

## Ce qu'on a compris

1. **La boucle du joueur.** L'arme équipée est mise à jour dans la boucle du joueur, qui tournait deux
   fois par image dans l'original, avec le temps d'une image entière à chaque passage. Le correctif
   `weapondt` lui rend ce temps.
2. **Un piège de PPSSPP.** Une instruction modifiée juste après un saut n'est pas prise en compte tant
   qu'on ne réécrit pas le saut. `weapondt` n'avait jamais été actif. L'outil gère maintenant ce cas.
3. **Les projectiles.** Ils avancent et vieillissent d'un pas à chaque mise à jour, donc 2× trop vite à
   60 FPS. Corrigé par `blastershot` (le « 30 images par seconde » écrit en dur) et `rynorocket`.
4. **La latence des animations.** Le jeu voit la fin d'une animation 2 mises à jour trop tard ; à 60 FPS,
   ce retard est deux fois plus court. Le plugin (`animlat`) le rétablit. Ça touche toutes les
   animations non bouclées, donc il faudra vérifier en dehors des armes.
5. **Les rayons du Tremblator.** Un petit système à part (machine à états, segments, particules) qui
   avance par crans entiers. La conversion exacte consiste à le faire tourner à 30 Hz (« îlot à 30 Hz »).

## Rejeté

- `rynorate` : faux, la recharge du Ryno était déjà correcte.
- 10 sites de `frametimers` étaient déjà corrects à 60 FPS ; ils sont retirés du groupe.
