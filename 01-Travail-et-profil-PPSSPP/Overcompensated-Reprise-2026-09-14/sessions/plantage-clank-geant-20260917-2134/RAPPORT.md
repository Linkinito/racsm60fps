# Plantage du 17 septembre 2026 à 21 h 34 — section Clank géant

## Ce qui s'est passé

Version installée : **0.6.3-generalisation-dev.1** (premier essai en jeu de cette version).

Parcours utilisateur : partie en cours, passage sur Challax, puis entrée dans la section Clank géant → **arrêt du jeu**.

## Chronologie reconstituée

| Heure | Événement |
|---|---|
| 21:17 | installation de la version 0.6.3 (débris + collecte généralisés) |
| 21:32:02 et 21:32:18 | deux plantages antérieurs, dans `amdxc64.dll` (pilote graphique AMD) — même symptôme que les plantages de lancement déjà connus |
| 21:34:01 | module LEVEL_01 armé (55 sites, 111 écritures), trace enregistrée |
| 21:34:26 | module LEVEL_07 armé (46 sites, 110 écritures), trace enregistrée |
| 21:34:26 | module **LEVEL_15** armé (6 sites, **15 écritures**) — dernière ligne du journal |
| 21:34:28 | PPSSPP s'arrête : exception `0xc0000005` dans **PPSSPPWindows64.exe**, décalage `0x2cc9bf` |

Le plantage est donc **interne à l'émulateur**, différent des plantages du pilote graphique de 21:32. Il survient **2 secondes après l'armement du correctif sur le module LEVEL_15**.

## Hypothèses

1. **Armement du module LEVEL_15** (ou LEVEL_21, module jumeau de même taille). Ces modules correspondent très probablement aux séquences Clank géant. Leur table ne contient que 15 écritures, essentiellement le socle et une redirection de cave. Ce chemin n'avait **jamais été armé auparavant** : dans les sessions précédentes, LEVEL_15 était détecté alors que le mode 30 était appliqué, donc sans aucune écriture.
2. **Mot de cave modifié par la version 0.6.3** (cave 7, mot 34 : 1,0 → 0,5). C'est la seule modification de la 0.6.3 qui touche le module LEVEL_15, puisque les 45 entrées de collecte ne concernent que les modules 01 à 10.
3. Cause extérieure au plugin (hasard, mémoire, pilote). Peu probable vu la corrélation de deux secondes, mais pas exclu.

## Mesures prises

- Retour à la version précédente : `patch.prx` empreinte `d1239a3f…` (avec le prototype de menu) et configuration antérieure, tous deux repris de `sessions/before-v063-20260917-213010/`.
- Preuves conservées dans ce dossier : `status.log` complet, `trace_L01_0001.json`, `trace_L07_0002.json`.
- PPSSPP était fermé au moment du retour arrière.

## Test décisif à faire

Relancer le jeu **avec la version précédente** (déjà remise en place) et refaire exactement le même parcours : partie en cours → Challax → section Clank géant.

| Résultat | Interprétation |
|---|---|
| Le jeu plante de nouveau au même endroit | La 0.6.3 n'est pas en cause. Le défaut vient de l'armement du correctif 60 FPS sur le module LEVEL_15 (ou LEVEL_21), jamais exercé jusqu'ici. À corriger dans le profil de ces modules. |
| Le jeu passe normalement | Le mot de cave modifié par la 0.6.3 est en cause. Il faudra alors fabriquer une variante sans ce mot (collecte seule) et vérifier. |

## Contournement en attendant

Dans la section concernée, le mode 30 FPS évite l'armement du correctif complet sur ces modules : c'est ainsi que le passage s'était déroulé sans incident le 17 septembre à 00:42 et à 20:10. Le choix est piloté par le fichier `Overcompensated.fps` du dossier du plugin ou par le menu du jeu.


## Suite du 17 septembre, le soir

- Le parcours a été refait avec la version précédente : **même plantage**, même module, même décalage dans PPSSPP (`0x2cc9bf`). La généralisation est hors de cause : le défaut vient du profil des modules Clank géant, dont l'armement n'avait jamais été exercé auparavant.
- La version 0.6.3-generalisation-dev.2 exclut désormais les modules 15 et 21 de tout correctif : ces scènes tournent en vanilla, ce qui garantit leur rythme d'origine.
- À comprendre ensuite : pourquoi cet armement fait planter PPSSPP. Pistes : les quinze écritures du profil (dont un `jal` remplacé par un nop pour le déblocage VBlank et une redirection de cave), l'invalidation du cache d'instructions de PPSSPP, ou l'identité ambiguë entre les modules 15 et 21 (le journal indiquait `matches=2`).
- Observation utilisateur : les écrans de chargement restent à 20 images par seconde. Une discussion récupérée (conversation 6a85799c) mentionne déjà que « le chargement natif à 20 FPS ne doit pas recevoir aveuglément les corrections » : c'est un comportement natif du jeu, pas une régression.
## Troisieme essai : 21 h 42, version 0.6.3-generalisation-dev.2 (modules exclus)

Le journal confirme que l'exclusion a fonctionne : `module excluded key=LEVEL_15 index=15 reason=crash_reported_20260917`. Le plugin n'a donc **rien ecrit** dans cette scene, et PPSSPP s'est arrete quand meme, deux secondes plus tard, avec le meme decalage `0x2cc9bf`.

Conclusion : le plantage ne vient pas des ecritures du plugin dans cette scene. Reste a verifier s'il vient du plugin du tout (surveillance, redirections laissees en place depuis le module precedent) ou de PPSSPP lui-meme.

Test suivant : plugin entierement desactive (plugin.ini renomme en plugin.ini.desactive-pour-test), meme parcours.

Si le plantage persiste sans plugin, il faudra regarder du cote de l'emulateur et de ses reglages : resolution interne 10x (valeur extreme), rendu multithread actif, backend Direct3D 11, pilote AMD qui plantait deja deux fois dans l'heure.