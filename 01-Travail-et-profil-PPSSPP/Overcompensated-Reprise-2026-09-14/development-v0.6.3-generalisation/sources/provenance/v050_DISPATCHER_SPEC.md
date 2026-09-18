# Spécification technique — Wrapper Dispatcher v0.5.0-prealpha

## 1. Objectif

La v0.5.0 ajoute une couche de décision entre les callsites du jeu et le calcul d'amortissement commun. Elle permet de comparer proprement le comportement original à deux passes et le candidat à une passe sans modifier globalement le wrapper de tout le module.

Le dispatcher reste un outil expérimental. Il ne décide pas automatiquement qu'une famille est liée au framerate et n'implémente encore aucun correctif `CUSTOM` pour les armes, dégâts ou machines d'état.

## 2. Chemins d'exécution

| Politique configurée | Destination effective | Effet |
|---|---|---|
| `TWO_PASS` | wrapper original du module | deux appels successifs au helper, comportement vanilla |
| `VANILLA` | wrapper original du module | alias de sécurité de `TWO_PASS` |
| `ONE_PASS` | helper interne du module | un seul calcul, sans approximation intermédiaire |
| `CUSTOM` | wrapper original du module | fallback explicite en attendant une fonction spécialisée |

Sur Metalis, le wrapper de référence se trouve à `0x09147E54` et le helper à `0x09147D88`. Le désassemblage du binaire `LEVEL_04.PRX` confirme que le wrapper sauvegarde son contexte, appelle deux fois ce même helper avec les mêmes paramètres, puis retourne ; l'appel direct du chemin `ONE_PASS` équivaut donc au retrait exact d'une des deux passes.

Toutes ces adresses sont des adresses de référence. À l'exécution, le dispatcher applique le déplacement mesuré à la base réelle du module `rcp1`.

## 3. Résolution des politiques

Pour chaque callsite du module autorisé, la résolution suit cet ordre :

1. `default_policy` fournit la valeur initiale ;
2. une règle de famille remplace cette valeur ;
3. une règle par `$ra` de référence remplace la règle familiale ;
4. `CUSTOM` est conservé dans la trace, mais sa destination effective reste `TWO_PASS` dans cette version.

Une même famille ou un même `$ra` ne peut pas être placé dans plusieurs listes. Une famille ou une adresse absente du module autorisé entraîne également un refus, afin d'éviter un test silencieusement différent de celui annoncé.

## 4. Format de configuration

```ini
[dispatcher]
mode = policy_module
allowed_module = 4
default_policy = two_pass

one_pass_families = 30
two_pass_families =
custom_families =

one_pass_ras =
two_pass_ras =
custom_ras =

instrumentation_enabled = true
poll_us = 100000
stable_polls = 3
export_on_transition = true
controls_enabled = true
```

Les familles sont écrites sous forme d'identifiants numériques compris entre 1 et 59. Les exceptions `$ra` utilisent toujours les adresses du corpus de référence, car le plugin les relocalise lui-même.

`policy_module` exige un `allowed_module` explicite non nul. Toute erreur de syntaxe ou contradiction force le plugin en `detect_only`, sans redirection.

## 5. Installation atomique et retrait

Avant l'armement, le plugin vérifie les signatures du profil et toutes les instructions `jal` attendues. Si une seule instruction est différente, aucune redirection n'est conservée ; si une écriture échoue en cours d'installation, les écritures déjà effectuées sont annulées.

Chaque callsite reçoit ensuite un `jal` vers le trampoline `TWO_PASS` ou `ONE_PASS` du module. Les delay slots originaux ne sont jamais modifiés, et les caches d'instructions et de données sont synchronisés après les écritures.

Lors du retrait, une instruction n'est restaurée que si elle pointe encore vers l'un des trampolines du plugin. Une écriture étrangère n'est pas écrasée, et l'anomalie apparaît dans le journal.

## 6. Trampoline

Les deux entrées de trampoline partagent la même routine d'observation. Elles sauvegardent les registres généraux, `HI/LO`, les registres flottants nécessaires et `FCR31`, puis transmettent le `$ra` extérieur au compteur.

Après restauration du contexte, la variante `TWO_PASS` saute vers le wrapper original relocalisé. La variante `ONE_PASS` saute vers le helper interne relocalisé, ce qui conserve le contrat d'appel du callsite tout en supprimant exactement une exécution du calcul.

## 7. Surveillance de santé

Le plugin relit périodiquement les 36 callsites armés. Le bilan distingue :

- `original` : instruction vanilla, hook absent ;
- `two_pass` : hook installé sur la route attendue à deux passes ;
- `one_pass` : hook installé sur la route attendue à une passe ;
- `wrong_route` : hook connu, mais différent de la politique résolue ;
- `foreign` ou `unreadable` : instruction inconnue ou illisible.

Une route inversée n'est donc pas confondue avec une installation valide. Cette distinction est nécessaire pour que les résultats A/B soient interprétables.

## 8. Trace JSON v5

La trace conserve les métriques temporelles de la v4 et ajoute :

- un objet global `policy` avec la politique par défaut et le nombre de routes effectives ;
- `configured_policy` pour chaque callsite ;
- `effective_policy` pour chaque callsite ;
- `custom_fallback` pour rendre visible tout `CUSTOM` encore exécuté en `TWO_PASS`.

Le parseur fourni reste compatible avec les traces v1 à v4. Il vérifie en plus la cohérence des totaux de politique dans les traces v5.

## 9. Portée du palier Metalis

Metalis contient 36 callsites dans 21 familles. Les profils livrés appliquent les routes suivantes :

| Profil | Familles `ONE_PASS` | Callsites `ONE_PASS` |
|---|---|---:|
| 05A | aucune | 0 |
| 05B | `WF-030` | 1 |
| 05C | `WF-015`, `WF-023`, `WF-025`, `WF-026`, `WF-028`, `WF-029`, `WF-030` | 9 |

Dans 05C, `WF-002`, `WF-006` à `WF-012`, `WF-013` et `WF-014` restent volontairement à deux passes. Elles touchent des helpers transversaux ou des zones liées aux armes et dégâts, pour lesquelles un simple changement du nombre de passes ne suffit pas encore à garantir les timings, le nombre de ticks ou la synchronisation animation-impact.

## 10. Limites et prochaine extension

Une politique `ONE_PASS` ne corrige que le calcul traversant ce wrapper. Elle ne corrige pas les timers décrémentés par image, la cadence d'émission d'une arme, les volumes de dégâts, les attaques de mêlée, les particules, les débris ou les états qui ne passent jamais par ce helper.

La prochaine extension `CUSTOM` devra pouvoir appeler une fonction propre au callsite ou modifier une donnée avant/après le chemin vanilla. Elle devra conserver les mêmes garanties de relocalisation, d'installation atomique, de traçabilité et de repli sûr que les deux routes actuelles.
