# État du projet — Overcompensated (60 FPS Size Matters)

_Résumé pour le propriétaire, mis à jour le 30 septembre 2026. Le checkpoint
technique (anglais) est `CURRENT_STATE.md`._

## Objectif

Faire tourner *Ratchet & Clank: Size Matters* (UCES00420) à 60 FPS **avec
exactement le même gameplay qu'à 30 FPS**. Ensuite seulement viendront les
améliorations : second stick, L2/R2, meilleur FOV et nouveaux points de
compétence.

Le patch prend la forme d'un **plugin PRX** chargé par PPSSPP. Le jeu vide et
recharge son code à chaque niveau, donc un simple `.ini` de cheats ne suffit
pas.

## Ce qu'on sait

- La logique tourne à 30 Hz. Le joueur fait 2 sous-étapes par frame.
- Débloquer à 60 FPS se fait en 3 changements (VBlank, delta 1/30 → 1/60,
  boucle joueur 2 → 1). C'est la configuration **C1**. Le joueur bouge alors
  à la bonne vitesse.
- Mais des centaines d'objets comptent en frames et vont 2× trop vite :
  ascenseurs, cascades, armes, ennemis, particules…
- Un seul réglage global ne peut pas tout corriger. Certains éléments sont
  déjà justes en C1 (Acidbomb, Flamethrower), d'autres non.
- L'ancien plugin (v0.6.x) contient déjà un « dispatcher » centralisé :
  59 familles de fonctions, 493 points d'appel et 15 niveaux compilés.

## Corrections mesurées (une par une)

| Élément | Résultat |
| --- | --- |
| Timer Help (Pokitaru) | Corrigé et réversible (mesuré) |
| Ascenseur Pokitaru | 2× trop rapide en C1 (10 s → 5 s), défaut confirmé |
| Ascenseur Kalidon | Corrigé, à 1,76 % près |
| Cascade et papillon (Pokitaru) | Corrections locales mesurées |

## Où on en est

- **D1**, le candidat global, est compilé et passe 324 tests hors-ligne.
- Au premier lancement : crash et plus de son. D1 a été désactivé.
- **Blocage actuel :** PPSSPP ne démarre plus du tout, même sans D1. Windows
  indique un crash dans le pilote graphique AMD (`amdxc64.dll`) avec le rendu
  OpenGL. La cause n'est pas prouvée.

## Prochaine étape

1. Remettre PPSSPP en marche : essayer un autre moteur de rendu (Vulkan ou
   Direct3D 11) de façon réversible.
2. Relancer D1 et le tester en jouant, avec la bascule A0 ↔ D1.
3. Corriger au fur et à mesure les écarts constatés (exceptions locales).

## Rangement du 30 septembre 2026

- Les branches GitHub qui contenaient des fichiers du jeu (PRX, sauvegardes,
  dumps, désassemblage) ont été supprimées. Seule `main` reste publique.
- L'historique Git local a été nettoyé : il passe d'environ 250 Mo à environ
  4 Mo. Les fichiers retirés sont toujours sur le disque, simplement ignorés
  par Git.
- Une sauvegarde complète de l'ancien historique se trouve dans
  `..\RAC_60FPS-backup-2026-09-30\`. **Ne jamais la publier.**
- Les documents sont indexés dans `docs/README.md`. Règles de publication :
  `docs/PUBLICATION_POLICY.md`.
