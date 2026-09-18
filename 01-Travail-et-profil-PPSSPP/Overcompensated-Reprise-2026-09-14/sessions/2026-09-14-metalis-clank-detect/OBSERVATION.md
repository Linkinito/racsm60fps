# Première lecture en jeu — Metalis

Observation utilisateur : Clank dans un véhicule pendant le mini-jeu de Metalis ; jeu en pause.
Sonde : UCES00420 version 1.00 ; mot à 0x08841120 = 4.
Journal v0.6.0 : LEVEL_04 reconnu par module_api, une correspondance, base 0x0914BD00, delta 73728 = 0x12000, writes=0, mode=detect_only. Marqueur JIT accepté, autres gardes valides.
Le journal conserve la transition LEVEL_03 vers LEVEL_04 et une trace L03 exportée. Cette trace ne valide pas le gameplay ou les hooks.
La propriété game.status.paused vaut false : elle ne prouve pas que le gameplay avance, car elle ne représente pas tous les types de pause interne au jeu. Aucune commande de reprise ou entrée manette envoyée.
Conclusion : première lecture mémoire en jeu réussie et chargement du plugin confirmé. Aucun correctif 60 FPS ni instrumentation des callsites activé. Aucune validation de vitesse, véhicule, dégâts ou collisions.
La nouvelle base diffère de celle de v0.4.5 : ne pas réutiliser le déplacement ancien +0x8000.
