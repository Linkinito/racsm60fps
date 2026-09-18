# Audit de l'historique et de la généralisation v0.6.3 — 18 septembre 2026

Audit en lecture seule des sources, PRX de référence, journaux et conversations. Aucun nouvel essai de gameplay dans ce sous-audit. Les documents et versions historiques sont conservés intacts. Les corrections éventuellement produites ensuite par le chantier global doivent être décrites dans leur propre version.

## Conclusion

La discussion **Revoir le travail effectué** a produit un inventaire utile, mais sa généralisation v0.6.3 ne doit pas servir de référence fiable sans corrections : **un conflit de garde empêche l'armement de Metalis et 27 des 45 nouvelles valeurs de collecte ne reproduisent pas les valeurs Metalis validées qualitativement**. Le diagnostic du plantage Clank géant n'a pas été établi. Plusieurs affirmations documentaires sont fausses ou périmées.

Les 45 mots vanilla proposés par la généralisation correspondent bien aux PRX de référence : le défaut porte sur les valeurs de remplacement et sur l'intégration runtime, pas sur ces 45 adresses originales.

Preuves reproductibles : `audit-history.py` génère `audit-historique-preuves.json` (empreintes et vérifications) et `audit-v063-pickup.csv` (45 adresses, mots vanilla, mots v0.6.3 et valeurs Metalis de référence). Commande : Python 3 `research-2026-09-18-global/audit-history.py` depuis le projet.

## 1. Conflit de cave : Metalis refusé par v0.6.3

Dans `development-v0.6.3-generalisation/sources/profiler/src/psp_plugin_runtime.c`, `prepare_full_patch`, lignes 869–891 :

1. Chaque cave est copiée depuis `g_rcsm_cave_templates`.
2. Pour Metalis, cave d'indice 7, la ligne 886 exige que le mot d'indice 34 soit `0x3C043F80`, sinon elle retourne 0.
3. La ligne suivante remplace ce mot par `0x3C043F00`.
4. Or le générateur v0.6.3, via `generated/cave-overrides.json`, a déjà mis ce mot à `0x3C043F00` dans le modèle. La garde échoue donc nécessairement.

Le chemin 60 FPS appelle cette préparation à la ligne 1444 ; l'échec entraîne le refus avant l'installation du correctif. Le chemin de confirmation 30 FPS l'appelle également à la ligne 1399. Ce défaut est établi par les sources et la table réellement générée ; aucun parcours Metalis sous v0.6.3 n'apparaît dans les dernières traces qui permettraient de le confondre avec une validation en jeu.

Correction possible : rendre l'opération idempotente en acceptant uniquement les deux états attendus (`0x3C043F80` et `0x3C043F00`) puis écrire `0x3C043F00`, ou centraliser cette décision dans un modèle de cave contrôlé et supprimer la double transformation. Ajouter une vérification du chemin de préparation complet : les seuls tests de tables et de transactions ne couvraient pas ce conflit.

L'index 7 est le huitième bloc d'un tableau indexé à zéro. Le mot `0x3C043F80` est une instruction `lui a0,0x3F80`, pas le float de données `0x3F800000`. Conserver cette distinction dans les inventaires mémoire.

## 2. Collecte : 27 valeurs différentes de l'expérience Metalis

Les neuf modules concernés sont LEVEL_01, 02, 03, 05, 06, 07, 08, 09 et 10. Les cinq valeurs originales ont été vérifiées dans chacun de leurs PRX par traduction RVA → section ELF. Pour chaque module :

| Champ | Vanilla | Metalis conservé | v0.6.3 généralisé | Verdict |
|---|---|---|---|---|
| Vitesse initiale | `3DCCCCCE` ≈ 0,1 | `3D4CCCCE` ≈ 0,05 | identique | Conforme à Metalis |
| Accélération | `3D75C290` ≈ 0,06 | `3C75C290` ≈ 0,015 | identique | Division par quatre, pas deux |
| Vitesse maximale | `3EAAAAAB` ≈ 0,333333 | `3E2AAAAB` ≈ 0,166667 | `3DAAAAAB` ≈ 0,083333 | Deux fois trop faible par rapport à Metalis |
| Guidage sous plafond | `3DA3D70A` ≈ 0,08 | `3D27413B` ≈ 0,040833693 | `3D23D70A` ≈ 0,04 | Transformation différente |
| Guidage au plafond | `3E4CCCCD` ≈ 0,2 | `3DD8368F` ≈ 0,105572812 | `3D4CCCCD` ≈ 0,05 | Transformation très différente |

Les coefficients de guidage Metalis correspondent à `1 - sqrt(1 - alpha)` : deux interpolations à 60 Hz conservent alors le même facteur de rétention qu'une interpolation à 30 Hz. Une division naïve par deux n'est pas exactement équivalente, et la valeur au plafond v0.6.3 a même été divisée par quatre.

La documentation v0.6.3 et la réponse du précédent audit disent « cinq constantes divisées par deux ». Cette phrase est incorrecte, même pour les deux valeurs qui reproduisent Metalis. Une accélération exprimée par image, avec vitesse par image divisée par deux, peut demander un facteur 1/4. Chaque unité doit être suivie dans le code consommateur.

Le CSV joint fournit l'adresse exacte de chaque entrée, notamment la variante LEVEL_08 où la vitesse initiale se trouve à table−0x10, contre table−0x14 dans les autres modules généralisés. Ne pas déduire cet écart uniquement d'une signature commune.

La reprise des mots Metalis dans les autres modules reste une **généralisation statique à vérifier en jeu**, même après réparation des 27 écarts. Les deux minuteurs de collecte n'avaient pas été généralisés. Il ne faut donc pas annoncer la collecte entièrement corrigée partout.

## 3. Débris : correction déjà intégrée avant v0.6.3

`development-v0.6.2-menu/sources/profiler/src/psp_plugin_runtime.c`, lignes 885–887, contient déjà la correction locale Metalis du mot 34. Le fichier `metalis-experiments.json` la décrit dans `cave7_word34` avec `scope = module4 only`. Les vérifications historiques v0.6.1 ont également contrôlé ce mot en mémoire.

L'affirmation « collision des débris non reprise / non intégrée » de `inventaire-2026-09-17/INVENTAIRE_MEMOIRE.md`, `ETAT_ACTUEL.md` et `PLAN_GENERALISATION.md` est donc fausse pour Metalis. La confusion vient d'un inventaire centré sur les entrées `RcsmFullWord`, alors que cette correction se fait dans le code d'assemblage des caves. Il faut inventorier aussi les transformations runtime, les redirections et les caves.

Les quinze profils ont bien un retour pour la cave 7. Cela prouve la portée du modèle partagé, pas la fidélité gameplay de sa généralisation. La v0.6.3 dev.2 exclut par ailleurs les modules 15 et 21 : la couverture effective n'est plus « quinze modules corrigés ».

## 4. Plantage Clank géant : cause toujours inconnue

La tâche et `sessions/plantage-clank-geant-20260917-2134/RAPPORT.md` relatent trois essais :

| Essai | État plugin | Résultat rapporté |
|---|---|---|
| 21 h 34 | v0.6.3 dev.1, module 15 armé | Exception hôte PPSSPP `0xC0000005`, décalage `0x2CC9BF` |
| Retour version précédente | v0.6.2 menu dev.1, module 15 armé | Même plantage rapporté |
| 21 h 42 | v0.6.3 dev.2, module 15 exclu | Même plantage rapporté |

Le journal confirme l'exclusion au troisième essai. Ce résultat contredit le diagnostic intermédiaire « l'armement du profil 15 est la cause ». Il n'exclut pas un effet résiduel du module précédent, la surveillance du plugin, un problème propre à PPSSPP ou une interaction avec la configuration. Aucun résultat du test suivant sans plugin n'est présent dans la tâche consultée.

Au premier relevé de cet audit, le dossier actif contenait `plugin.ini.desactive-pour-test`, sans `plugin.ini` : le précédent travail s'est terminé sur une désactivation du plugin pour ce test. Le binaire stocké était de taille 128386 octets, correspondant à v0.6.3 dev.2. Ces observations décrivent le début de l'audit ; tout changement par le chantier courant doit avoir sa propre trace.

Une exclusion de module n'établit pas à elle seule un état vanilla complet. Pour employer « sans aucun patch », démarrage propre depuis les ressources propres, absence de cheats/plugins perturbateurs, puis contrôle mémoire indépendant des points concernés sont nécessaires. Un savestate ancien ne constitue pas une référence vanilla.

## 5. Mode 30 FPS : preuve à reformuler

Le journal contient réellement `frame_rate applied=30 requested=30` sur LEVEL_15 puis LEVEL_04. Cela prouve le chemin de confirmation du plugin ; ce n'est pas une mesure de cadence ni de fidélité gameplay.

Cependant, l'affirmation « uniquement sa propre déclaration, aucun témoin mémoire » est trop forte : les sources v0.6.1 et v0.6.2-menu montrent déjà, avant cette confirmation, `full_binding_still_present`, `prepare_full_patch`, `rcsm_full_preflight` et la classification des redirections exigeant `state.original == callsite_count`. Une relecture externe reste utile, mais il ne faut pas prétendre que le programme ne contrôle rien. Les constantes marquées CONTINUOUS et les états dynamiques ont un traitement séparé : ces gardes ne prouvent pas l'identité de toute la RAM au vanilla.

## 6. Ce que les acquis antérieurs prouvent réellement

- Pokitaru : rapport `POKITARU_STAGE02_RESULT.md`, 55 callsites installés, 34 actifs, 496697 hits. Stabilité de l'instrumentation et transition Ryllus ; ne décide pas automatiquement ONE_PASS/TWO_PASS.
- Ryllus : `RYLLUS_STAGE03_RESULT.md`, 57 installés, 38 actifs, 122243 hits, 98,724 % des écarts actifs à deux VBlank. Référence temporelle 30 Hz utile, pas validation 60 Hz des objets.
- Kalidon : historique « Système PRX MIPS », parcours avec 33 hooks, 8 actifs, 67905 hits et transition Airboard isolée. HutDoor, Lvl3Platform et MungoDrone observés ; les séquences non rejouables demandent une sauvegarde antérieure pour des comparaisons identiques.
- Metalis : 167 sites et 36 redirections vérifiés après démarrage de v0.6.1, 54 ajouts statiques et correction de cave locale. Les caisses, débris et collectes ont des retours favorables qualitatifs, sans mesure A/B 30/60 étalonnée.
- Les 493 callsites / 59 familles constituent une cartographie des appels à un wrapper, pas un inventaire exhaustif des ennemis, armes et véhicules. Des timers, accélérations, états IA et callbacks secondaires sont en dehors de ce wrapper.

Problèmes encore ouverts dans les sources historiques : recul roquettes sur joueur ET ennemis, cooldown du véhicule énergétique du joueur, lancer de robots et guidage type Lemmings, cadence dégâts Laser/Brûleur/acide, mêlée, trajectoire des crabes, projectiles/power-ups, durée des effets, clignotement pause. Les observations visuelles « x2 » sont des hypothèses à quantifier : une distance peut rester identique avec une durée divisée par deux.

## Références de tâches consultées

- **Revoir le travail effectué** — `01a0b0ad-babe-79e1-a191-76793e7c4a84` ; dix tours lus, pagination complète. Tâche attribuée à Deepseek par l'utilisateur. L'API consultée n'identifie pas le modèle ; aucune attribution automatique supplémentaire n'est faite.
- **Retrouver le projet 60 fps** — `01a0a1b3-da13-7472-b676-9bfc9ef55e5b` ; vingt derniers tours lus pour la continuité Metalis/menu et les validations utilisateur.
- **Valider le patch 60 FPS** — `6a85799c-3910-83ed-9eb6-d06abbec9590`, copie locale `history/`.
- **Système PRX MIPS** — `6a86dce7-2998-83eb-bf81-229c2835c35d`, copie locale `history/`.
- **Analyse du projet 60 FPS** — `6a9e73cd-0054-83eb-a342-db3ec91d25cc`, copie locale `history/`.

## Interprétation des adresses

Une RVA est relative à la base effective du module, obtenue après chargement. L'adresse mémoire est `base runtime + RVA`. Une adresse absolue d'une ancienne session n'est pas réutilisable sans revalider module, empreinte, base et mots originaux. Les mots `jal` relocalisés peuvent différer entre fichier et RAM ; ne pas mélanger `file_vanilla`, `runtime_vanilla`, mot patché et adresse de code détenu par le plugin. Les tables de collecte de ce sous-audit sont des données sans relocation à leurs emplacements contrôlés.
