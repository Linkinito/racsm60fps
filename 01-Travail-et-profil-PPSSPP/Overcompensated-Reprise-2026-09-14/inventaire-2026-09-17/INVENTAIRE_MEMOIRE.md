# Inventaire des modifications mémoire

> Établi le 17 septembre 2026 à partir des journaux et des fichiers source réellement présents sur le disque.
> Aucun fichier du jeu, aucune sauvegarde et aucune configuration n'ont été modifiés pour produire cet inventaire.

## À quoi sert ce dossier

Il répond à une question simple : **qu'est-ce qui a été écrit dans la mémoire du jeu, où, et qu'est-ce que ça vaut maintenant ?**

C'est la base de travail d'une reprise propre : tout ce qui est listé ici est conservé, même si le code du plugin est un jour reconstruit autrement.

| Fichier | Contenu |
|---|---|
| `INVENTAIRE_MEMOIRE.md` | Ce document : explication, résumés, méthode |
| `inventaire-manuelles.csv` | Les 111 écritures faites à la main pendant les essais de septembre |
| `inventaire-plugin.csv` | Les 1 425 écritures que le plugin fait tout seul à chaque chargement de niveau |

## Les deux familles d'écritures

Il faut distinguer deux choses, souvent mélangées dans les notes :

1. **Les écritures automatiques du plugin.** Le plugin contient des tables de valeurs. Quand un niveau se charge, il vérifie que le code attendu est bien là, puis écrit ces valeurs en mémoire. Ces écritures reviennent à chaque démarrage, tant que le plugin est installé.
2. **Les écritures manuelles des essais.** Pendant les recherches, on a arrêté le processeur et écrit des valeurs à la main pour tester une hypothèse avant de l'intégrer. Ces écritures disparaissent dès que PPSSPP est fermé.

Toutes les découvertes manuelles jugées bonnes ont été converties en écritures automatiques. L'inverse n'est pas vrai : le plugin contient aussi beaucoup de choses plus anciennes, venues du corpus historique, qui n'ont jamais été testées en jeu pendant ce chantier.

---

## 1. Écritures automatiques du plugin

Source : `development-v0.6.2-menu/sources/profiler/generated/full_patch.generated.c` (table compilée dans le plugin).

| Module | Écritures déclarées |
|---|---:|
| LEVEL_01 | 113 |
| LEVEL_02 | 112 |
| LEVEL_03 | 112 |
| **LEVEL_04 (Metalis)** | **167** |
| LEVEL_05 | 110 |
| LEVEL_06 | 110 |
| LEVEL_07 | 112 |
| LEVEL_08 | 112 |
| LEVEL_09 | 112 |
| LEVEL_10 | 112 |
| LEVEL_15 | 15 |
| LEVEL_21 | 15 |
| LEVEL_22 | 17 |
| LEVEL_23 | 98 |
| LEVEL_24 | 108 |
| **Total** | **1 425** |

Trois remarques utiles :

- **Metalis est le module le plus corrigé** : 167 écritures, soit 54 de plus qu'un module ordinaire (~113). Ce sont les découvertes des 15 et 16 septembre.
- **LEVEL_15, LEVEL_21 et LEVEL_22 ne comptent que 15 à 17 écritures.** Ces trois modules ne sont quasiment pas couverts. À ne pas confondre avec « testé et bon ».
- Le frontend (menus, écran-titre) et les modules multijoueur ne font pas partie de ces tables.

### Pourquoi le journal dit parfois 160 alors que la table en compte 167

Cet écart pouvait faire douter. Il est maintenant expliqué : sur les 167 entrées de Metalis, **7 ne sont pas écrites au chargement** mais *surveillées*. Le plugin les relit régulièrement et les corrige seulement s'il reconnaît la valeur d'origine. 167 − 7 = 160, exactement le `static_writes=160` du journal.

Ces 7 entrées portent le marqueur `CONTINUOUS` dans `inventaire-plugin.csv`.

### Les marqueurs de la table

| Marqueur | Signification |
|---|---|
| `CODE` | Réécriture d'une instruction du jeu |
| `CONTINUOUS` | Valeur surveillée, écrite seulement si elle correspond à l'original (7 cas sur Metalis) |
| `CAVE_JUMP` | Redirection d'un saut vers une zone mémoire appartenant au plugin |
| `NEW_JUMP` | Saut réécrit pour la nouvelle disposition mémoire |
| `OLD_JUMP` / `UNLOCK` | Reliquats du corpus historique |

| Couche | Contenu |
|---|---|
| `socle` | Base du 60 FPS (nombre d'images, sous-pas du joueur) |
| `armes` | Armes et projectiles |
| `cassables/boulons` | Caisses, débris, boulons |
| `particules` | Effets et particules |

Le profil actif active les quatre couches (`full_layers = 15`).

---

## 2. Écritures manuelles des essais (14 → 17 septembre)

Sept essais ont réellement écrit en mémoire. Tous ont été relus après écriture pour vérifier. **Aucune de ces valeurs ne survit à la fermeture de PPSSPP.**

| # | Essai | Date | Écritures | Résultat | Où c'est maintenant |
|---|---|---:|---:|---|---|
| 1 | WF-029 en une passe | 14/09 22 h | 2 | Annulé le jour même | Retour à deux passes, rien conservé |
| 2 | Mouvement du véhicule ClankSaw | 15/09 23 h | 7 | Validé à l'œil par le joueur | Repris dans le plugin |
| 3 | Rotation du véhicule ClankSaw | 16/09 00 h | 1 | Validé à l'œil | Repris dans le plugin |
| 4 | Lot arène Metalis | 16/09 01 h | 40 | Persistance vérifiée, fidélité non validée | Repris dans le plugin |
| 5 | Collision des débris | 16/09 23 h | 1 | Retour « semble normal » | Non repris (essai isolé) |
| 6 | Collecte Nano et munitions | 16/09 23 h | 7 | Retour favorable | Déjà repris dans le plugin |
| 7 | Caisses + reprise de l'arène | 16/09 23 h | 51 | 47 sites persistants relus | Repris dans le plugin |

### Détail des petits essais

**Essai 1 — WF-029 en une passe** (`wf029-apply-result.json`, puis `wf029-rollback-result.json`)

| Cible | Adresse | Avant → Après |
|---|---|---|
| Instruction `jal` du site d'appel | 0x0917764C | 0x0E256DD5 → 0x0E256DDC |
| Octet de politique dans la table | 0x08968D06 | 1 → 2 |

Conclusion : cette piste n'expliquait pas l'accélération du véhicule. Tout a été remis en place le jour même.

**Essais 2 et 3 — véhicule ClankSaw** (`clanksaw-movement-result.json`, `clanksaw-rotation-result.json`)

| Cible | Adresse | Origine | Nouvelle valeur |
|---|---|---|---|
| Plafond avant | 0x09438B98 | 0,2 | 0,1 |
| Plafond arrière | 0x09438B9C | 0,1 | 0,05 |
| Pas de rotation | 0x09438BA0 | 0,0785398 | 0,0392699 |
| Accélération avant | 0x09438BA4 | 0,00833 | 0,004167 |
| Accélération arrière | 0x09438BA8 | 0,00667 | 0,00333 |
| Freinage | 0x09438BAC | 0,01667 | 0,00833 |
| Décélération roue libre | 0x09438BB0 | 0,00833 | 0,004167 |
| Vitesse courante du véhicule | 0x09CB3B00 | 0,02752 | 0,01376 |

La vitesse courante est une valeur d'état, pas une règle : elle n'a de sens que dans la session où elle a été relevée. C'est pour cette raison que le plugin ne la stocke pas.

**Essai 5 — collision des débris** (`debris-collision-1789592905266.json`)

| Cible | Adresse | Avant → Après |
|---|---|---|
| Durée de collision (mot 34 de la zone du plugin) | 0x089679C8 | 1,0 | 0,5 |

**Essai 6 — collecte Nano et munitions** (`pickup-collection-1789593231151.json`)

| Cible | RVA | Origine → Nouvelle valeur |
|---|---|---|
| Attraction Nano, minuteur | 0x1352FC | −1 → −0,5 |
| Disparition Nano, minuteur | 0x1340A4 | −1 → −0,5 |
| Vitesse initiale de l'objet | 0x2E3544 | 0,1 → 0,05 |
| Accélération de l'objet | 0x2E3554 | 0,06 → 0,015 |
| Vitesse maximale | 0x2E3558 | 0,3333 → 0,1666 |
| Guidage sous le plafond | 0x2E355C | 0,08 → 0,0408 |
| Guidage au plafond | 0x2E3560 | 0,2 → 0,1056 |

### Détail des deux gros essais

**Essai 4 — lot arène** (`arena-batch-result.json`) : 40 écritures.

| Bloc | Écritures | Contenu |
|---|---:|---|
| Tables de mouvement | 26 | Plafonds, accélérations, freinages et rotations des véhicules Electro et Ram, variante de charge comprise, plus rotation du sol et impulsions du bélier |
| Minuteurs | 7 | Compteurs de scie, d'électro, de bélier et de pièges, divisés par deux |
| Diviseurs d'animation | 2 | Animations d'extension et de retrait de la scie |
| Durées entières | 2 | Durées actives et de recharge |
| Valeurs d'état | 3 | Vitesses courantes de la session, non reprises par le plugin |

**Essai 7 — caisses et reprise** (`resume-crates-result-1789592738689.json`) : 51 écritures.

| Bloc | Écritures | Contenu |
|---|---:|---|
| `prior-arena` | 37 | Réapplication des 37 sites persistants de l'essai 4 |
| `prior-player` | 7 | Réapplication du mouvement et de la rotation du véhicule du joueur |
| `new-crates` | 3 | Délais de téléportation des caisses de vie et d'énergie, et cadence de l'émetteur |
| Valeurs d'état | 4 | Vitesses courantes des véhicules, non reprises par le plugin |

---

## 3. Recoupement : les essais sont-ils dans le plugin ?

Vérification faite pour les **54 écritures manuelles portant une RVA** (essais 6 et 7) : **les 54 se retrouvent à l'identique dans la table du plugin compilée**. Aucune n'a été oubliée lors de l'intégration.

Restent volontairement hors de la table du plugin :

- les **valeurs d'état** (vitesses courantes des véhicules) : elles n'ont pas de sens hors de leur session ;
- la **collision des débris** (essai 5) : elle porte sur le code que le plugin injecte lui-même (mot 34 de la cave 7) et n'est pas encore intégrée. Voir `PLAN_GENERALISATION.md`.
- la **collecte Nano/munitions** (essai 6) : contrairement à ce qui avait été noté dans un premier temps, elle **est** intégrée. Ses 7 écritures figurent dans le fichier d'essais du générateur, aux côtés des autres découvertes Metalis.

---

## 4. Ce que cet inventaire ne contient pas

- **Les lectures seules.** Beaucoup d'essais n'ont fait qu'observer la mémoire (captures de véhicule, d'ennemis, compteurs, inventaires d'objets). Ils ne modifient rien et restent utiles comme preuves de recherche.
- **Le corpus historique.** Les corrections d'armes et d'effets intégrées au plugin viennent d'un manifeste antérieur, pas des essais de septembre. Elles figurent dans `inventaire-plugin.csv` comme les autres, mais aucune n'a été validée en jeu pendant ce chantier.
- **Les traces d'exécution** (`trace_*.json`) et les rapports de vérification.

## 5. Comment lire les deux CSV

`inventaire-manuelles.csv` — une ligne par écriture manuelle :

| Colonne | Sens |
|---|---|
| `essai`, `date`, `journal` | D'où vient la ligne |
| `groupe`, `libelle` | Ce qui a été modifié |
| `adresse_hex`, `adresse_dec` | Adresse mémoire au moment de l'essai |
| `rva_hex` | Position relative au module : la seule forme réutilisable plus tard |
| `avant_u32`, `apres_u32` | Mot de 32 bits avant et après |
| `avant_float`, `apres_float` | Même chose lue comme un nombre à virgule |
| `verifie`, `statut` | Relecture de contrôle et devenir de l'essai |

`inventaire-plugin.csv` — une ligne par entrée de la table du plugin :

| Colonne | Sens |
|---|---|
| `module_index`, `module_key` | Module concerné |
| `offset_dec`, `offset_hex` | Position dans le module |
| `original_hex`, `patched_hex` | Instruction ou valeur avant et après |
| `flags`, `flags_noms` | Type d'entrée (voir le tableau des marqueurs) |
| `layer`, `layer_nom` | Couche activée par le profil |
| `ecrit_statiquement` | `oui`, ou `non (surveillance)` pour les 7 entrées surveillées |

