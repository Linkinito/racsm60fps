# Conception et état du hook Allegrex

## Décision : rediriger les appelants, pas le prologue partagé

Les quinze wrappers commencent par le même prologue, mais détourner leur entrée demanderait de remplacer plusieurs instructions et d’émuler les mots déplacés. Le profiler remplace donc uniquement l’instruction `jal wrapper` de chaque callsite vérifié :

```mips
# Avant
jal   wrapper_two_pass
<delay slot original>

# Pendant le profilage
jal   rcsm_profiler_hook_lXX
<delay slot original>
```

Le delay slot reste byte-identique. À l’entrée du hook, `$ra` vaut `adresse_du_jal + 8` et constitue une clé exacte dans la table du module actif.

## Pourquoi quinze petits stubs

Le wrapper n’a pas la même adresse dans tous les PRX de niveau et le PRX actif peut lui-même changer de base lorsque le profiler occupe de la RAM. Utiliser un pointeur de fonction dans un GPR imposerait de sacrifier ou de modifier un registre visible par le jeu. Chaque stub termine donc par un `j` immédiat exporté comme symbole. Avant un armement instrumenté, le runtime réencode uniquement ce mot appartenant au profiler vers `wrapper_reference + address_delta` ; aucun GPR ne transporte la cible. En `detect_only`, cette adaptation n’est pas exécutée et le nombre total d’écritures reste zéro.

Le stub suit cette séquence binaire auditée :

1. réserver une frame de 288 octets ;
2. sauvegarder le `$ra` original à `132($sp)` ;
3. appeler le corps commun ;
4. restaurer le `$ra` original ;
5. sauter vers le wrapper runtime du niveau ;
6. libérer la frame dans le delay slot du saut.

Le wrapper original voit ainsi les mêmes arguments, registres et adresse de retour que si son `jal` n’avait jamais été redirigé.

## État préservé

Le corps commun sauvegarde les GPR `at`, `v0-v1`, `a0-a3`, `t0-t9`, `s0-s7`, `k0-k1`, `gp`, `fp`, ainsi que HI, LO, FCR31 et les 32 FPR scalaires. `zero` est immuable et `sp` est restauré par construction. Le `$gp` du jeu est conservé ; le `$gp` relogé du PRX n’est chargé que pendant `rcsm_profiler_hook_c()`.

Le shim C effectue uniquement trois opérations : incrément atomique du nombre de hooks actifs, lookup/compteur si l’enregistrement est ouvert, puis décrément atomique. Il ne réalise ni allocation, ni formatage, ni écriture de fichier, ni syscall.

## Installation et retrait

L’installation est transactionnelle. Le cœur relocalise d’abord le profil complet, puis précontrôle les N mots avant d’en modifier un seul. Si une écriture échoue après K changements, ces K mots sont restaurés et les caches sont resynchronisés. Le retrait est conditionnel : seuls les mots qui encodent encore le `jal` vers notre hook sont remis à leur valeur originale. Le tail-jump interne n’a pas à être restauré : il appartient au PRX du profiler et sera adapté de nouveau à la prochaine résidence.

Un contrôle de santé périodique classe chaque mot en `original`, `redirected`, `foreign` ou `unreadable`. Une combinaison original/redirected sans mot étranger est traitée comme un rechargement du même niveau et repasse par la détection stable. Un mot étranger ou illisible bloque tout réarmement dans cette résidence du module.

## Ce qui est prouvé et ce qui ne l’est pas encore

La compilation PSP, la forme des quinze stubs et de leurs quinze symboles tail, les cibles de référence, la source de l’auto-adaptation, les sauvegardes FPU/HI/LO/FCR31, la relogeabilité PRX et l’encodage des 493 redirections sont contrôlés automatiquement dans `PSP_BUILD_VALIDATION.json`. Le palier 00 a déjà prouvé in situ la base dynamique, et le premier essai instrumenté est resté stable. Il reste à obtenir un hit réel pour valider le trampoline ; c’est l’objet du palier `focused_pokitaru` avant `full_module`.
