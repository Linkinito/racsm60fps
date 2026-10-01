# Notes techniques — applicabilité à Size Matters

## Conclusion

Le support est applicable à **UCES-00420** sur PPSSPP. Le jeu reçoit déjà les
octets `Rx/Ry` dans `SceCtrlData`, mais son code caméra PSP ne les exploite pas.
La fonction de caméra commune calcule :

- lacet : `R - L`, résultat dans l'état caméra à `+0x274` ;
- tangage : `Haut - Bas`, résultat à `+0x278`, derrière le bit `0x08` de
  l'indicateur caméra situé à `+0x41`.

Le consommateur vertical reste actif dans la caméra standard ; seule la
génération de l'entrée verticale est normalement désactivée. Le prototype
active ce chemin uniquement pendant un mouvement vertical du stick droit.

## Ancrages vérifiés dans les fichiers fournis

Le dump RAM correspond à `LEVEL_02.PRX` chargé avec son texte à `0x09139D00`.
Dans cet état :

- fonction d'entrée caméra : `0x0913CD60` ;
- état caméra : `0x0942FED0` ;
- mise à jour du contrôleur : `0x091B50E0` ;
- structure contrôleur courante : `0x094C1C80` ;
- `Buttons` : `+0x04`, `Lx/Ly` : `+0x08/+0x09`, `Rx/Ry` : `+0x0A/+0x0B`.

Le prototype n'embarque pas ces adresses. Il décode les pointeurs relocalisés
après avoir retrouvé deux signatures masquées. Les signatures apparaissent une
fois chacune dans tous les modules de niveaux et zéro fois dans `FRONTEND.PRX`.

| Module | Caméra (relative) | Contrôleur (relative) |
|---|---:|---:|
| LEVEL_01 | `0x3060` | `0x75454` |
| LEVEL_02 | `0x3060` | `0x7B3E0` |
| LEVEL_03 | `0x30A0` | `0x750FC` |
| LEVEL_04 | `0x2E74` | `0x78170` |
| LEVEL_05 | `0x3060` | `0x73EEC` |
| LEVEL_06 | `0x3060` | `0x6F774` |
| LEVEL_07 | `0x3060` | `0x76E10` |
| LEVEL_08 | `0x30BC` | `0x7CE2C` |
| LEVEL_09 | `0x3060` | `0x720DC` |
| LEVEL_10 | `0x2DF8` | `0x755D4` |
| LEVEL_15 | `0x2B54` | `0x5DA24` |
| LEVEL_16 | `0x2A60` | `0x66DA8` |
| LEVEL_17 | `0x2A60` | `0x66340` |
| LEVEL_18 | `0x2AC4` | `0x668C8` |
| LEVEL_19 | `0x2A60` | `0x68458` |
| LEVEL_20 | `0x2A3C` | `0x5AAF4` |
| LEVEL_21 | `0x2B54` | `0x5DA24` |
| LEVEL_22 | `0x2DFC` | `0x68004` |
| LEVEL_23 | `0x3070` | `0x6C244` |
| LEVEL_24 | `0x2E50` | `0x6E8CC` |

## Différence avec camera_patch_lite

`camera_patch_lite` déclare explicitement UCES-00420, mais sa configuration
Size Matters associe seulement le stick droit horizontal à `LTRIGGER` et
`RTRIGGER`. Son seuil transforme donc le stick en boutons tout-ou-rien et ne
fournit pas d'axe vertical pour ce jeu.

Ici, la synthèse L/R et Haut/Bas est confinée à la fonction caméra, puis les
sorties natives sont pondérées par l'amplitude analogique. Cela évite de
transformer le stick droit en commandes de déplacement ou d'altérer durablement
L+R.

## L2/R2

PPSSPP 1.19.3 expose `Dev-kit L2` (`0x0400`) et `Dev-kit R2` (`0x0800`) dans les
contrôles étendus et les transmet dans `SceCtrlData.Buttons`. Comme Size Matters
ne connaît aucune action L2/R2 native, le prototype peut traduire chacun de ces
bits vers une touche PSP existante avant que le jeu calcule les états
pressé/relâché.

Sur une PSP physique, ces touches n'existent pas. Cette version du prototype
est volontairement limitée à PPSSPP ; un port Vita/Adrenaline demanderait un
chemin de chargement et d'interception distinct.

## Risques restant à tester dynamiquement

- orientation exacte des axes selon le backend de manette ;
- modes caméra spéciaux (visée, tourelle, Clank, véhicules) ;
- ordre de chargement avec le PRX 60 FPS déjà présent ;
- transitions de niveau, sauvegardes d'état et reprises après veille ;
- choix ergonomique final des alias L2/R2.

Le garde-fou principal est l'unicité des deux signatures. En cas d'écart de
version ou de fonction non reconnue, le module concerné n'est pas patché.

## Références publiques utilisées

- [Documentation officielle des plugins PPSSPP](https://www.ppsspp.org/docs/reference/plugins/)
- [camera_patch_lite — Freakler](https://github.com/Freakler/psp-camera_patch_lite)
- [RemasteredControls — TheOfficialFloW](https://github.com/TheOfficialFloW/RemasteredControls)
- [RemasteredControls_MGS_PPSSPP — Kethen](https://github.com/Kethen/RemasteredControls_MGS_PPSSPP)
- [PPSSPP 1.19.3 — définitions du contrôleur](https://github.com/hrydgard/ppsspp/blob/v1.19.3/Core/HLE/sceCtrl.h)
- [PPSSPP 1.19.3 — mappage « Extended PSP controls »](https://github.com/hrydgard/ppsspp/blob/v1.19.3/Core/KeyMap.cpp)
