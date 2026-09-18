# Notes de portage et risques restant à mesurer

## PPSSPP 1.19.3 — cible immédiate

Le PRX utilisateur, son `plugin.ini`, les API de fichier, contrôle, VBlank, threads et synchronisation de cache sont compilés. Les essais ont validé le chargement, le résolveur, 55 hooks sur Pokitaru, 57 hooks sur Ryllus et les transitions jusqu’à Kalidon. Il reste trois questions que l’analyse statique ne peut pas résoudre :

1. Les 33 callsites de Kalidon restent-ils transparents pendant un parcours complet et une transition ?
2. Les familles actives sur Kalidon conservent-elles le motif vanilla de deux VBlank observé sur Ryllus ?
3. Quelle modification restaure réellement le comportement vanilla quand une scène reproductible est comparée à 30 et 60 FPS ?

La v0.4.4 a mesuré Ryllus sur 42 824 VBlank : 38 callsites actifs, 122 243 hits et zéro `$ra` inconnu. Parmi les transitions entre VBlank actifs, 98,724 % utilisent un écart de deux VBlank ; LEVEL_03 a ensuite été reconnu avec 33 entrées. Le prochain retour attendu est le log et les traces v4 d’un parcours de Kalidon.

## Temps observé

Le compteur mesure les VBlank, pas les frames rendues ni les ticks de simulation. La v4 distingue désormais les VBlank actifs, les hits multiples dans un même VBlank et les écarts de 1, 2 ou davantage de VBlank. L’identification d’une logique liée au framerate exigera malgré tout de comparer ces distributions et un effet gameplay quantifié à 30 puis 60 FPS. Une fréquence doublée est un indice, jamais une preuve suffisante.

## Concurrence

Le nombre de hooks actuellement actifs est atomique afin que l’export attende la fin du chemin chaud. Les statistiques d’un callsite sont volontairement simples pour limiter le coût ; le jeu semble utiliser ces appels depuis sa boucle principale, mais cette hypothèse doit être confirmée. Si `unknown_hits` devient non nul, si les compteurs sont incohérents ou si un test révèle plusieurs threads appelants, la version suivante devra employer des compteurs atomiques ou des buffers par thread.

## VFPU

Le trampoline conserve les 32 FPR scalaires et le registre de contrôle FPU. Le shim C ne contient aucune instruction VFPU et le wrapper étudié utilise la FPU scalaire. Une sauvegarde des 128 registres VFPU n’est donc pas ajoutée d’office : elle augmenterait sensiblement le coût de chaque appel. Si une trace JIT ou un comportement réel indique que du code appelant garde un état VFPU vivant à travers le callsite malgré l’ABI, il faudra alors mesurer et ajouter une variante dédiée.

## PSP réelle sous CFW

Le cœur de lookup, les empreintes et le trampoline peuvent être réutilisés, mais le paquet n’est pas un plugin `seplugins` traditionnel. Un port matériel devra choisir un CFW et un bootstrap, confirmer la disponibilité de `sceKernelGetModuleIdList`/`sceKernelQueryModuleInfo` depuis ce contexte, gérer explicitement le cycle de chargement/déchargement et mesurer la mémoire sur PSP-1000/2000. Le balayage de repli n’est pas une justification pour ignorer ces contraintes. Le port devra commencer en mode détection seulement ; aucune option `memory = 64` de PPSSPP n’existe sur le matériel.

## Futur dispatcher correctif

Le profiler ne doit pas devenir directement le patch final. Après les traces, un dispatcher de production pourra être beaucoup plus léger : profil immuable mais base résolue dynamiquement, lookup `(module, $ra)`, politiques explicites par callsite, aucun export JSON et aucune sauvegarde de registre supérieure à ce que son code utilise. Les familles communes pourront partager une règle seulement si les mesures montrent le même effet ; les exceptions resteront au niveau du callsite. La partie « retrouver le module et appliquer un delta » est réutilisable ; la classification frame/delta/tick ne devient pas pour autant game-agnostic.
