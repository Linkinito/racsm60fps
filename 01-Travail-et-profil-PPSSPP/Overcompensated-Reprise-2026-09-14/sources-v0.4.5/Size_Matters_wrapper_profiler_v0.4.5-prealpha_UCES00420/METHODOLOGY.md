# Méthode — catalogue des familles du wrapper

## Coordonnées et regroupement

Les modules PRX sont lus comme des ELF32 MIPS little-endian. Les 493 instructions `jal` dirigées vers l’entrée runtime du helper à deux passes sont des coordonnées exactes ; l’adresse de retour enregistrée par MIPS est calculée par `$ra = PC + 8`, le mot situé à `PC + 4` étant le delay slot.

Une fonction parente est estimée à partir de la plus proche entrée forte antérieure : cible directe de `jal`, entrypoint ou prologue `addiu $sp,$sp,-N`. La borne finale est l’entrée forte suivante. Cette approximation est conservatrice et signalée comme telle dans les tables.

Un appel de `LEVEL_03` dépassait de 0xD4 octets l’ancienne limite arbitraire de recherche fixée à 0x2000. Son parent est désormais confirmé par un prologue réel, une borne suivante cohérente et un descripteur de callback exact `Lvl3Platform` : la fonction mesure 0x2A08 octets et porte le total global de 58 à 59 familles, sans modifier le sous-ensemble Pokitaru/Ryllus.

Les familles utilisent le hash SHA-256 d’une fenêtre de 96 octets dont chaque mot relocalisé est remplacé par son type de relocation. Cela absorbe les changements d’adresse entre PRX. Le hash normalisé du corps estimé complet est fourni séparément pour révéler les familles dont seule l’entrée est identique.

## Références sémantiques

Les couples `R_MIPS_HI16` / `R_MIPS_LO16` sont reconstitués pour récupérer les adresses de chaînes et de constantes chargées depuis `.rodata` ou `.data`. Les chemins source, noms symboliques et schémas de PVars sont classés sans modifier les octets d’origine.

Les descripteurs d’objets sont reconnus dans `.data` lorsqu’un pointeur relocalisé vise un identifiant en `.rodata`, suivi d’au moins deux callbacks visant `.text`. Cette structure permet par exemple de relier directement une fonction à `Level01Boat`, `TriggeredDoor` ou `Level02ExpandableBridge`. Un parcours inverse du graphe de `jal`, limité à trois arêtes, rattache ensuite certaines sous-fonctions à leurs callbacks parents ; ce lien est une inférence et sa distance reste visible.

Les patchs v0.2.1 sont associés à la même fonction estimée lorsqu’ils résident dans `.text`. Une catégorie `WEAPONS`, `BREAKABLES` ou `PARTICLES` située dans les mêmes bornes constitue un indice sémantique fort, mais ne prouve pas que l’appel du helper doit adopter une passe particulière.

## Interprétation

Le niveau **fort** correspond à un descripteur d’objet directement relié ou à un patch connu dans la même fonction. Le niveau **moyen** correspond à un nom symbolique direct ou à un callback parent distant d’au plus deux appels ; le niveau **faible** désigne uniquement un parent à trois appels. Sans ces éléments, la famille demeure indéterminée.

Toutes les familles commencent avec la politique `VANILLA_UNTIL_PROFILED`. La structure statique peut identifier le contexte et réduire l’espace de recherche, mais elle ne peut pas déterminer de façon générale si une logique est par frame, fondée sur un delta, exécutée à tick fixe ou déclenchée par événement.

## Exclusion des données du jeu

Le paquet généré exclut les PRX, BIN, WAD, DUMP, GZF, PAK, textures et archives provenant du jeu. La seule exception d'extension est `profiler/patch.prx` et ses copies d'installation : il s'agit du module original compilé depuis les sources de ce paquet, jamais d'un binaire du jeu.
