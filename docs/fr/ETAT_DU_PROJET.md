# État du projet — Overcompensated (60 FPS Size Matters)

_Résumé pour le propriétaire, mis à jour le 30 septembre 2026 (fin de séance).
Checkpoint technique (anglais) : `CURRENT_STATE.md`. Détails : `docs/FINDINGS_2026-09-30.md`._

## Objectif

*Ratchet & Clank: Size Matters* (UCES00420) à 60 FPS avec **exactement le même
gameplay qu'à 30 FPS**. Ensuite seulement : second stick, L2/R2, FOV, nouveaux
points de compétence. Forme : un plugin PRX pour PPSSPP.

## Ce qu'on a compris

- **C1** (3 instructions) débloque le 60 FPS et corrige Ratchet et presque toutes
  les animations, parce qu'elles utilisent le temps écoulé.
- Tout le reste va 2× trop vite parce que le jeu avance d'un **pas fixe à chaque
  frame** : déplacements des ennemis, compteurs d'attaque, particules, etc.
  C'est surtout dans la mise à jour des objets (le « pump 1 ») et dans le système
  de particules.
- Il n'existe **pas de correction globale simple** : 6 approches globales ont été
  testées en jeu et écartées (saccades, bugs, ou aucun effet).

## Ce qui est corrigé (expérimental, testé à l'œil)

- **Crabes** : vitesse (navigation au sol divisée par deux, valable aussi pour les
  robots TM et le TrainingBot) et timing des coups (seuil 27 → 54 frames).

## En cours

- **Particules** (brume, éclaboussures de la cascade) : correction écrite, la
  version 10 corrige le clignotement des versions 8 et 9, **pas encore testée**.
- Vaguelettes, débris de caisses, feu : autres « animateurs » de particules à corriger.
- `animdisp` (déplacement animé de PNJ/cinématiques) : mis de côté, il bloque le jeu.

## Outils disponibles

Recensement des objets actifs, points d'arrêt sur écriture ou appel, coupure
temporaire d'un sous-système, scan de valeurs, bascule des corrections en direct.
Mode d'emploi : `docs/RUNTIME_GUIDE.md`.

## Tester toi-même

1. Plugin `InterpGate` seul activé (les autres à `false`), PPSSPP en Vulkan.
2. Aller à Pokitaru, puis dans un terminal à la racine du dépôt :
   `python tools/runtime/fixes.py --target C1 --fix nav,crab --out research/live-tests/pokitaru/mes-tests/raw/essai-1`
3. Revenir au jeu d'origine : `--target A0` (nouveau dossier `--out` à chaque fois).
4. Ne pas utiliser `animdisp` (blocage du jeu).

## Prochaines étapes

Voir `docs/ROADMAP.md` : tester la version 10 des particules, monter un projet
Ghidra annoté de Pokitaru (lecture beaucoup plus rapide du code), puis continuer
ennemi par ennemi, les armes, et enfin un plugin qui s'applique tout seul.

## Git et GitHub

- `main` (public) : documentation, sources des plugins et outils. Aucun fichier du jeu.
- `v2-research` (local seulement) : tout l'historique de recherche.
- Sauvegarde de l'ancien historique : `..\RAC_60FPS-backup-2026-09-30\` (ne jamais publier).
