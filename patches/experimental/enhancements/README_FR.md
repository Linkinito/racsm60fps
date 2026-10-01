# OCEnhance — plugin facultatif caméra et commandes

Priorité 2 : séparé du patch 60 FPS, chaque option est désactivée sauf si elle est activée dans
`ocenhance.ini`. État : COMPILÉ, PAS ENCORE TESTÉ EN JEU.

| Option | Effet |
|---|---|
| `right_stick = 1` | le stick droit tourne la caméra (horizontal et vertical), proportionnellement |
| `deadzone`, `invert_x/y`, `sensitivity_x/y` | réglages du stick (sensibilité 10 à 300 %) |
| `l2`, `r2` | touches « Dev-kit L2/R2 » de PPSSPP associées à une action PSP (désactivé par défaut) |
| `fov_deg` | champ de vision vertical en degrés (original 31,5) |
| `cam_distance`, `cam_height` | distance (original 5,0) et hauteur (original 1,14) de la caméra |

Installation : copier `build/<nom>/OCEnhance/` dans `PSP/PLUGINS/OCEnhance/`, puis dans PPSSPP
associer le stick droit (« Stick analogique droit ») et, si souhaité, Dev-kit L2/R2.

Fonctionnement : réécriture sans bibliothèque C du prototype RACSM Controls (licence MIT). Le plugin
retrouve le niveau chargé et ne le modifie que si les deux fonctions visées sont trouvées une seule
fois par signature (tous les niveaux de jeu ; le menu est ignoré). Les constantes de vue sont
retrouvées par leurs valeurs, uniques dans les 15 niveaux vérifiés.

À 60 FPS, la caméra tourne 2× trop vite tant que la correction de parité `camera` n'est pas
appliquée ; le stick hérite de cette vitesse.
