# RACSM Controls — prototype PPSSPP v0.1.0

Prototype expérimental pour **Ratchet & Clank: Size Matters**, version
européenne **UCES-00420**, testé statiquement contre les 20 modules de niveaux
fournis. Il ajoute une caméra analogique sur deux axes avec le stick droit et
expose L2/R2 sous forme d'alias configurables.

## Installation

1. Fermer complètement le jeu dans PPSSPP.
2. Copier le dossier `RACSM_Controls` entier dans le dossier de la Memory Stick
   de PPSSPP, sous `PSP/PLUGINS/`.
3. Le chemin final doit être :
   `PSP/PLUGINS/RACSM_Controls/plugin.ini`.
4. Relancer PPSSPP puis démarrer Size Matters UCES-00420.
5. Dans **Paramètres > Contrôles > Mappage des contrôles**, vérifier que les
   axes du stick droit sont assignés.

Pendant les essais, privilégier une sauvegarde interne au jeu. Les sauvegardes
d'état peuvent conserver une ancienne version d'un plugin chargé.

## Stick droit

Le plugin ne se contente pas d'un remappage numérique. Il lit `Rx/Ry`, réutilise
le calcul de caméra natif du jeu, puis module la vitesse selon l'amplitude du
stick. Les réglages sont dans `racsm_controls.ini` :

- `deadzone` : 0 à 126, valeur conseillée 24 ;
- `invert_x` et `invert_y` : 0 ou 1 ;
- `sensitivity_x` et `sensitivity_y` : 10 à 300, en pourcentage ;
- `camera_enabled` : 1 pour activer, 0 pour désactiver sans retirer le plugin.

Les véritables touches L/R et la croix directionnelle ne sont modifiées que
pendant l'appel caméra, puis restaurées. Le recentrage, l'accroupissement et les
sauts qui utilisent L+R doivent donc rester disponibles.

## L2/R2 sur PPSSPP 1.19.3+

Dans le mappage PPSSPP, ouvrir **Extended PSP controls** et associer les
gâchettes physiques aux entrées **Dev-kit L2** et **Dev-kit R2**. Choisir ensuite
leur alias dans `racsm_controls.ini` :

```ini
l2 = SELECT
r2 = CIRCLE
```

Actions reconnues : `OFF`, `SELECT`, `START`, `UP`, `RIGHT`, `DOWN`, `LEFT`,
`L`, `R`, `L+R`, `TRIANGLE`, `CIRCLE`, `CROSS`, `SQUARE`, `CAMERA_CENTER`.

Les deux alias restent sur `OFF` dans la configuration livrée, car le jeu n'a
pas d'actions L2/R2 d'origine et le choix ergonomique doit être validé en jeu.
Après toute modification du fichier, redémarrer complètement le jeu. Dans ce
prototype, les alias ne sont actifs que lorsqu'un module de niveau est chargé,
pas dans l'écran titre.

## Compatibilité et retrait

Le plugin recherche deux signatures uniques avant d'écrire quoi que ce soit. Il
ne patche ni `EBOOT.BIN` ni `FRONTEND.PRX`, et il suit les changements de module
lors des transitions de niveau. Il est conçu pour cohabiter avec le correctif
60 FPS existant : le hook appelle toujours la fonction caméra originale, donc
les coefficients de timing déjà corrigés restent dans le chemin d'exécution.
Cette cohabitation doit néanmoins être validée dynamiquement dans PPSSPP.

Ne pas charger simultanément un autre plugin qui remappe le stick droit vers
L/R, par exemple `camera_patch_lite`, pendant le test. Pour revenir au
comportement d'origine, fermer le jeu et retirer le dossier
`PSP/PLUGINS/RACSM_Controls`.

## Vérification conseillée

Tester au minimum :

1. caméra horizontale et verticale, lente puis en butée ;
2. marche/course simultanée avec rotation de caméra ;
3. recentrage et accroupissement avec L+R ;
4. saut en longueur et saut en hauteur ;
5. visée, armes, tourelles et séquences Clank ;
6. passage Pokitaru → Ryllus puis chargement d'une sauvegarde ;
7. L2/R2 après avoir choisi des alias temporaires.

Le fichier `racsm_controls.log`, créé à côté du PRX, indique le module patché et
confirme la première détection de Dev-kit L2/R2. Il n'enregistre pas les entrées
image par image.

## Compilation

Avec PSPSDK/PSPDEV dans le `PATH` :

```sh
cd source
make clean
make
```

Copier ensuite `source/RACSM_Controls.prx` à côté de `plugin.ini`.
