# Menus natifs et clignotement — audit statique, 16 septembre 2026

Aucun fichier du jeu, PRX installé, sauvegarde ou état mémoire modifié. Les fichiers de ce dossier sont des preuves de lecture et des candidats non appliqués.

## Résultats utilisables

`straddle.junk` est bien un ELF symbolisé. Les symboles PAUSEMENU, PAUSEMODE, LEVELSTARTUP et HUDFXCYCLE existent réellement. Ses valeurs de symbole ne sont PAS des adresses utilisables directement dans le module commercial. Le repérage par signatures normalisées a retrouvé les fonctions suivantes une seule fois dans chaque module :

| Fonction | Metalis LEVEL_04 RVA | FRONTEND RVA |
|---|---:|---:|
| HUDFXCYCLE_Update | 0xA6A34 | 0x15A34 |
| PAUSEMENU_Update | 0xABB18 | 0x15C94 |
| PAUSEMENU_SeekSelection | 0xABBB4 | 0x15D30 |
| PAUSEMENU_SetText | 0xABE04 | 0x15E14 |
| PAUSEMENU_BeginAddingMenuItems | 0xAC018 | 0x15F30 |
| PAUSEMENU_EndAddingMenuItems | 0xAC0F8 | 0x16010 |
| PAUSEMENU_GetCurrentItemNode | 0xAC7F0 | 0x16380 |
| PAUSEMENU_AddItem | 0xAC850 | 0x163B0 |
| PAUSEMENU_Render | 0xAC970 | 0x164D0 |

Les signatures masquent les destinations J/JAL et les immédiats des instructions entières, conservent les registres/opcodes et les opérations FPU. Elles portent sur toute la fonction pour les petites fonctions, au maximum 64 mots pour les grandes. Cela donne des **correspondances statiques fortes**, pas une validation ABI/exécution. `signature-matches.json` précise longueur et candidats. Les fonctions complètes ont été désassemblées avec la taille du symbole de développement; pour une fonction qui a changé de taille, la fin du fichier peut déborder ou être tronquée. La signature complète de PAUSEMODE_Update ne correspond pas sur Metalis, bien que son couple d'appels du curseur soit reconnaissable. Aucun hook d'entrée de cette fonction n'est donc proposé.

## Clignotement pause : cause probable beaucoup plus précise

HUDFXCYCLE_Update modifie `float value` à +8 par addition du pas à +0x14 ou soustraction du pas à +0x18. Il n'y a aucun delta temporel dans ces opérations. Les bornes sont à +0xC/+0x10, le sens à +0x1C, le mode à +0x20 et un compteur entier à +0x24. Les deux premiers mots sont des couleurs, pas des floats.

Dans Metalis, les appels consécutifs RVA0xADD84 et 0xADD90 donnent les états RVA0x2CF7BC et 0x2CF7E4. Ils correspondent structurellement aux deux états nommés `PAUSEMODE_G_CursorCycleFx` et `PAUSEMODE_G_CursorCycleFxUpperLight` dans le fichier symbolisé. Les deux ont min=0, max=1, montée=0.2, descente=0.05, mode=0 et compteur=0. À fréquence d'appel doublée, ils cyclent deux fois plus vite.

Candidat minimal, **non appliqué** :

| RVA float | Original | Candidat 60 fps |
|---|---|---|
| 0x2CF7D0 | 0.2 / 0x3E4CCCCD | 0.1 / 0x3DCCCCCD |
| 0x2CF7D4 | 0.05 / 0x3D4CCCCD | 0.025 / 0x3CCCCCCD |
| 0x2CF7F8 | 0.2 / 0x3E4CCCCD | 0.1 / 0x3DCCCCCD |
| 0x2CF7FC | 0.05 / 0x3D4CCCCD | 0.025 / 0x3CCCCCCD |

Manifest avec empreinte et valeurs attendues : `pause-blink-candidate.json`. Préférer ces quatre données aux changements globaux de HUDFXCYCLE_Update, qui possède 13 callsites dans ce module et anime d'autres écrans. Le premier état est aussi utilisé au callsite0xB427C : il faut compter les appels par image dans pause racine et sous-menus pour exclure un double update spécifique. Ce candidat ne règle pas tous les autres clignotements du HUD.

Test à la reprise : identifier module/base, lire structures et instructions sans emuhacks, compter appels/image ou échantillonner valeur+8 dans une pause stable, conserver avant/après, appliquer les quatre floats sous suspension CPU uniquement si préflight original ou état déjà connu, mesurer période à30 puis60 sur même écran. Vérifier retour et sous-menus. Restaurer valeurs seulement si elles sont encore celles du candidat. Sur un autre module, refaire repérage; aucun offset global constant supposé.

## Ajouter un menu sans remplacer CHEATS

Les structures confirment le principe retenu historiquement : liste de pointeurs et nombre d'entrées variables. Champs observés dans PAUSEMENU :

- +0 : tableau de pointeurs vers les nœuds; +4 : nombre; +8 : sélection.
- +0x24/+0x28 : début/fin du buffer de construction; +0x2C curseur d'allocation.
- +0x30 état de construction; +0x34 nombre de nœuds construits.
- Un nœud fait 0xE4 octets. AddItem écrit les données utilisateur à +0xD0, puis +0xD4/+0xD8/+0xDC.
- EndAddingMenuItems fabrique le tableau de pointeurs après les nœuds, ajoute un pointeur nul final, puis publie tableau et compteur à +0/+4.
- Chaque nœud dispose de quatre blocs texte de 0x30 octets; SetText calcule `nœud + indexTexte*0x30`, écrit la valeur au début et le booléen à +0xC. Le sens précis du booléen (texte direct/localisé) reste à confirmer dans Render avant utilisation.

Le premier prototype concret peut ainsi allouer dans le plugin un buffer de `N*0xE4+(N+1)*4` octets minimum plus marges d'alignement, construire son propre objet avec Begin/Add/End, et étendre le menu parent par un tableau de N+1 pointeurs plus terminaison nulle. Les nœuds vanilla restent à leurs adresses; conserver l'ancien tableau/compteur pour restauration. Créer le nœud additionnel dans le plugin et conserver ses chaînes pendant toute sa durée d'affichage. Ne jamais appeler AddItem sur un menu terminé : l'état +0x30 l'interdit.

Le prototype doit intercepter son identifiant utilisateur réservé **avant** le routeur vanilla, garder origine frontend/pause, appeler Update/Render natifs sur son objet et rendre la main au menu d'origine sur retour. Pas de réutilisation de la route38 : elle possède un usage multijoueur frontend. Pas de suppression de SPECIAL/CHEATS; l'accès Overcompensated doit rester indépendant du Mode défi.

Limite concrète restante : les objets racine frontend/pause et les hooks de validation doivent encore être retrouvés et relus dans les binaires/runtime actuels. Les nombres historiques4/7 et l'insertion5/8 viennent du chat archivé; cet audit reconfirme le mécanisme dynamique, pas ces instances. Le frontend n'était pas chargé pour mesure. Ajouter directement une entrée sans vérifier le traitement des commandes serait prématuré. Aucun prototype C exécutable n'est livré en inventant la convention d'appel, notamment les arguments PSP passant au-delà de a3.

Ensuite seulement : FRAME RATE, CAMERA, autres options. Enregistrer un choix demandé dans la configuration du plugin et afficher application au prochain chargement tant que les recettes de transition à chaud restent non validées. Conserver l'état appliqué séparé du choix demandé; aucune écriture du format de sauvegarde du jeu nécessaire.

## Reproduction et provenance

`elf_menu.py` extrait les symboles et les désassemblages; `match.py` produit les correspondances sur LEVEL_04 et FRONTEND; `xref.py` les 13 appelants; `finalize.py` les données strictement JSON et le candidat. Python système + dépendance capstone locale `analysis-deps` pour analyse binaire uniquement. `cycle-data.py` est une première extraction historique; son ancien format floats interprétait les couleurs comme NaN, donc préférer les sorties de finalize.py.

SHA256 :
- straddle.junk : 775bbec949cb1d27a80f889a1721423ec2c29585a52ddf7e1f1963325a0cb7ff
- LEVEL_04.PRX : 6896122ac19973e928303dc94c40fa309b5f06e5fef6ab14f624987035a4dc37
- FRONTEND.PRX : f203e56c49ae36651fd80db97b901159d076ea379da4bb55cecb490356fc2104

Source historique : `history/6a91f690-3128-83eb-8433-64acad3727a9.md`. Les propositions initiales de remplacer CHEATS et route38 sont explicitement abandonnées par la suite du même échange.
