# Metalis : extension de la compensation 60 FPS

## Resultats acquis
Le joueur juge le deplacement puis la rotation de ClankSawTorso corrects. Validation qualitative uniquement. Les attaques, cooldowns, ennemis et pieges restent non valides. Les essais resident en memoire; aucun correctif global nouveau installe.

## Constat technique
La routine RVA 0x2AB54 integre vitesse et acceleration par appel. La table capturee est RVA 0x2ECE98 (runtime 0x09438B98 avec base 0x0914BD00). Certains chemins EnemySawTorso utilisent cette meme table: ne pas appliquer deux fois les facteurs. WF029 ne suffit pas: c est un lissage utilise pour une rotation avant composition de matrice.
Les countdowns fixes -1 sont separes du mouvement. timer-candidates.json recense des emplacements a auditer; ce n est pas un patch executable ni une validation globale.
ObstacleSpinningFloor et ObstacleBouncer ont un callback update vide: leur logique utile se trouve dans des callbacks supplementaires/interactions. Scanner seulement les updates manquerait ces pieges. ObstacleSpinningFloor RVA0x166018 incremente son angle pvars+8 avec une constante RVA0x2E848C. Le 1.0 a RVA0x16606C est une composante de matrice, pas une cadence: ne pas le diviser aveuglement. ObstacleVent update est vide aussi. Scies: compteur objet+70 dans RVA0x165A24, cycles et animations a examiner ensemble.

## Perimetre
coverage.csv liste vehicules joueur/ennemis, controleurs, pieges, projectiles, bonus et environnement a couvrir. Presence dans le pool du niveau ne prouve pas activite dans le combat actuel. metalis-active-objects.json recense des descripteurs/pools charges, pas une preuve de tous les objets actifs. derby-controller-live.json lit la liste de combat: dernier releve trois VehicleHusk et un EnemyRamTorso; etat utilisateur a confirmer avant modifications d instances.

## Conditions du prochain essai coherent
1. Ennemis: verifier voies IA, tables partagees et valeurs de vitesse des instances, puis normaliser leur simulation avec celle de Clank.
2. Attaques: temps de recharge, duree active, projectiles, collisions, degats par coup et frequence de contact. Conserver la valeur d un coup; eviter de diviser indiscriminement les degats.
3. Pieges: vitesse/rotation, phases de cycle, collision et periode de degats; suivre aussi callbacks d interaction et animation.
4. Controleurs: duree de manche, spawns et bonus. Eviter double compensation des fonctions qui utilisent deja un dt corrige.
5. Tout essai doit sauvegarder et verifier les mots, garder un retour arriere et documenter les elements non couverts. Aucun resultat ne doit etre annonce comme tous pieges corriges sans verification.
