# Conception des trampolines Allegrex v0.5.0

## Redirection au callsite

Le dispatcher remplace uniquement le `jal wrapper` d'un callsite validé. Son delay slot reste byte-identique, et le `$ra` produit par le processeur continue d'identifier exactement la provenance de l'appel.

```mips
# Route TWO_PASS
jal   rcsm_profiler_hook_lXX
<delay slot original>

# Route ONE_PASS
jal   rcsm_profiler_hook_lXX_one
<delay slot original>
```

Chaque module possède deux petits stubs. Après le corps d'observation commun, l'un effectue un tail-jump vers le wrapper original à deux passes et l'autre vers le helper interne à une passe ; les deux destinations sont réencodées avec le déplacement runtime avant l'armement.

## État préservé

Le corps commun sauvegarde les GPR utiles, `HI`, `LO`, `FCR31` et les 32 FPR scalaires. Le shim C ne réalise ni allocation, ni I/O, ni formatage et ne fait qu'identifier le `$ra`, relever le VBlank et mettre à jour les compteurs.

Le jeu retrouve ensuite son adresse de retour et son contexte. Le wrapper ou le helper reçoit les mêmes arguments que dans le callsite d'origine.

## Pourquoi l'appel direct à une passe est valide

Dans les quinze modules, `wrapper_one_pass_runtime` désigne le helper que le wrapper appelle deux fois. L'inspection de `LEVEL_04.PRX` confirme notamment que le wrapper Metalis à `0x09147E54` sauvegarde son contexte, appelle deux fois `0x09147D88` avec les mêmes paramètres restaurés, puis retourne.

Le chemin `ONE_PASS` n'invente donc pas un nouveau algorithme et ne change aucune constante. Il exécute une fois le calcul existant au lieu de l'exécuter deux fois.

## Installation et retrait

Le cœur précontrôle toutes les instructions attendues avant la première écriture. En cas d'échec, il annule les modifications déjà réalisées et synchronise les caches.

Le retrait restaure une instruction uniquement si elle pointe encore vers l'un de nos deux stubs. La surveillance périodique distingue également un hook valide, un hook connu envoyé vers la mauvaise route, une écriture étrangère et une instruction illisible.
