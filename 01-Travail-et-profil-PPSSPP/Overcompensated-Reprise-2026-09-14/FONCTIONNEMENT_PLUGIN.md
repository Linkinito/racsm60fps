# Comment fonctionne le plugin, expliqué simplement

> Document de vulgarisation, écrit le 17 septembre 2026.
> Il décrit ce que fait le plugin sans entrer dans le code. Les détails techniques restent dans `development-v0.6.x/` et dans les sources.

## En une image

Le plugin est un **petit programme qu'on glisse dans la console émulée** avant de lancer le jeu. PPSSPP le charge au démarrage, et il travaille ensuite tout seul, en arrière-plan.

Son métier : **réécrire discrètement certaines instructions du jeu en mémoire**, pour que le jeu affiche 60 images par seconde tout en gardant le même rythme.

Deux points importants : il ne touche **jamais** aux fichiers du jeu sur le disque (ni l'ISO, ni les sauvegardes), et si quelque chose ne correspond pas à ce qu'il attend, **il ne corrige rien du tout** et l'écrit dans son journal.

## Le cycle de vie, étape par étape

1. **Lecture de la configuration.** Au lancement, le plugin lit `RCSMProfiler.ini` : quel mode utiliser, quelles couches activer, quelle fréquence viser. Configuration absente ou incohérente : il reste en observation seule, sans aucun correctif.
2. **Reconnaissance du jeu et du module.** Le jeu n'est pas un seul gros programme : il charge des **modules**, un par niveau ou par mode. Le plugin vérifie qu'il est bien sur `UCES00420`, puis repère le module chargé, par exemple Metalis.
3. **Calcul de la bonne adresse.** L'endroit où se trouve un module change à chaque session. Le plugin ne stocke donc pas d'adresses fixes mais des **écarts** par rapport au début du module ; il mesure le début réel, puis additionne. C'est ce qui rend le correctif réutilisable d'un démarrage à l'autre.
4. **Vérification avant écriture.** Il relit le code à l'endroit prévu et le compare à ce qu'il attend. Une seule différence et il refuse d'écrire : c'est ce qui évite de « corriger » un jeu qui n'est pas la bonne version.
5. **Écriture.** Il remplace les instructions et les valeurs prévues. Tout est fait d'un bloc : si une écriture échoue au milieu, celles déjà faites sont annulées.
6. **Surveillance.** Il relit périodiquement ses points d'écriture pour vérifier qu'ils sont toujours en place, et distingue un correctif intact, un correctif déplacé, une valeur étrangère ou un point illisible.
7. **Journal.** Chaque étape importante est écrite dans `status.log`, et les traces détaillées dans des fichiers `trace_*.json`.

## Les trois outils du plugin

### 1. Le dispatcher : choisir entre une et deux passes

C'est le cœur de l'idée 60 FPS.

Dans le jeu original, un même calcul est **exécuté deux fois** dans la même image. À 30 images par seconde, ça donne le bon résultat. À 60 images par seconde, le même calcul tourne deux fois plus souvent : le jeu va donc deux fois trop vite.

Le dispatcher repère les endroits du jeu où ce calcul a lieu et décide, pour chacun, de laisser **deux passes** (comportement d'origine) ou de n'en garder **qu'une seule** (le rythme redevient normal à 60 images).

Attention : une seule passe ne corrige que ce qui passe par ce calcul-là. Les minuteurs, les dégâts, les animations ou les collisions qui ne passent pas par là restent à traiter séparément. C'est exactement ce qui a occupé les recherches de septembre.

### 2. Le correctif par table : réécrire instruction par instruction

Le plugin embarque une longue liste de « mots » à remplacer, module par module : une instruction par-ci, une constante par-là. Chaque entrée indique la valeur d'origine, la nouvelle valeur, la couche concernée et le type d'opération.

Cette liste est visible en entier dans `inventaire-2026-09-17/inventaire-plugin.csv`. Elle contient 1 425 entrées réparties sur 15 modules.

Les couches permettent d'activer seulement une partie du correctif : `socle`, `armes`, `cassables/boulons`, `particules`. Le profil livré les active toutes les quatre.

### 3. La surveillance : vérifier que rien n'a bougé

Comme le jeu peut réécrire ses propres valeurs au chargement ou après une réinitialisation, le plugin relit régulièrement ses points sensibles. Sept valeurs de Metalis sont dans ce cas : elles ne sont corrigées que lorsqu'elles prennent la valeur d'origine attendue.

Si un emplacement contient autre chose que ce qui est attendu, le plugin **préfère ne rien faire** et le signaler plutôt que d'écraser une donnée inconnue.

## Le menu 30/60, chantier en cours

Le plugin ajoute une entrée dans les menus du jeu : menu principal, pause normale et pause des mini-jeux. L'objectif est de pouvoir choisir 30 ou 60 images par seconde.

Un point essentiel : **le changement n'est pas instantané**.

Quand on change la fréquence en cours de partie, les objets déjà en mouvement gardent leur vitesse actuelle. Le véhicule a déjà une vitesse, le projectile a déjà un âge. Le plugin note donc la demande et l'applique **au prochain chargement de niveau**, quand tout repart de zéro. C'est pour cette raison que l'interface parle d'application au prochain chargement, et non d'un interrupteur immédiat.

Le choix est enregistré dans un petit fichier à part, `Overcompensated.fps`. Ce fichier n'a rien à voir avec les sauvegardes du jeu, qui ne sont jamais modifiées.

## Les fichiers du plugin, et ce qu'ils veulent dire

| Fichier | Rôle |
|---|---|
| `plugin.ini` | Dit à PPSSPP de charger le plugin pour ce jeu |
| `patch.prx` | Le programme lui-même |
| `RCSMProfiler.ini` | Les réglages lus au démarrage |
| `status.log` | Le journal : démarrage, module reconnu, correctif armé, refus, demande de fréquence |
| `trace_*.json` | Les traces d'exécution détaillées, exportées à la demande |
| `Overcompensated.fps` | Le choix 30/60 enregistré par le menu |

## Les garde-fous

- **Rien n'est écrit sans vérification préalable.** Un module inattendu, une version différente du jeu, une instruction modifiée : le plugin refuse.
- **Tout ou rien.** Une écriture qui échoue au milieu annule celles déjà faites.
- **Retrait prudent.** Au démontage, une instruction n'est restaurée que si elle pointe encore vers le plugin. Si un autre programme est passé par là, le plugin n'écrase rien.
- **Pas d'écriture sur disque.** Les fichiers du jeu, l'ISO et les sauvegardes restent intacts.
- **Mode d'installation.** Le mod se distribue et s'installe uniquement sous forme de `patch.prx` chargé par PPSSPP. L'ISO du jeu reste vierge ; aucune image patchée n'est nécessaire.
- **Le redémarrage reste la référence.** Les essais menés en mémoire disparaissent à la fermeture ; seul ce qui a été intégré au plugin revient au démarrage suivant.

## Ce que le plugin ne sait pas faire

- Il ne corrige pas ce qui ne passe pas par les calculs repérés : une partie des dégâts, des animations, des minuteurs d'IA et des mini-jeux reste à traiter.
- Il ne convertit pas un état déjà en cours : d'où l'application au prochain chargement.
- Il n'est prévu que pour la version européenne du jeu (`UCES00420`) sur PPSSPP 1.19.3 sous Windows. Rien ne prouve qu'il fonctionne sur une PSP réelle ou sur une autre version du jeu.
- Aucune validation complète du jeu n'a été faite : beaucoup de corrections sont vérifiées « en mémoire », pas « en jeu ».

