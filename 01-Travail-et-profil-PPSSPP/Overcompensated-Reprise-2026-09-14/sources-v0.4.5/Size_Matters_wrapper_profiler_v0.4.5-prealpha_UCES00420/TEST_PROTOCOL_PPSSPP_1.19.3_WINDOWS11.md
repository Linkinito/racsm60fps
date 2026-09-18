# Protocole — palier 04 Kalidon sous PPSSPP 1.19.3 / Windows 11

## État de départ

Pokitaru et Ryllus sont désormais validés avec tous leurs hooks. Le parcours Ryllus a enregistré 122 243 hits connus sur 38 des 57 callsites, puis LEVEL_03 a été reconnu avec 33 entrées sans recevoir d’écriture parce que le palier précédent imposait `allowed_module = 2`.

La v0.4.5 conserve le format temporel `rcsm-wrapper-trace/4` et annonce désormais explicitement `trace_schema=4` dans la ligne de démarrage. Le prochain objectif est de vérifier la transparence des 33 hooks de Kalidon, notamment autour de `HutDoor`, `Lvl3Platform` et `MungoDrone`.

## Préparation

1. Fermer complètement PPSSPP.
2. Ouvrir le Memory Stick depuis PPSSPP.
3. Déplacer les anciens `status.log` et `trace_*.json` dans un dossier d’archive.
4. Supprimer entièrement `PSP\PLUGINS\SizeMattersWrapperProfiler`.
5. Désactiver provisoirement cheats, patch 60 FPS et autre plugin Size Matters.
6. Extraire uniquement `RCSMProfiler_v0.4.5_STAGE04_FULL_KALIDON_UCES00420.zip` à la racine du Memory Stick.
7. Utiliser une sauvegarde **interne au jeu** sur Kalidon. Ne pas charger un savestate créé avec une autre version du plugin.

Conserver le cœur JIT habituel, le frameskip à zéro et la vitesse d’émulation à 100 %. Cette session doit rester une référence vanilla ; le profiler mesure les appels mais laisse toujours le wrapper deux-passes original produire le résultat.

## Vérification au démarrage

Après le chargement de Kalidon, le journal doit contenir :

```text
start version=0.4.5-prealpha ... trace_schema=4 mode=full_module ... allowed_module=3
module armed key=LEVEL_03 index=3 ... callsites=33 resolver=module_api base=0x........ delta=.....
PPSSPP JIT marker accepted key=LEVEL_03 ...
```

Arrêter immédiatement si la dernière ligne `start` indique une autre version, si `callsites` n’est pas 33, si `allowed_module` n’est pas 3, si l’installation est refusée ou si un mot est déclaré `foreign/unreadable`.

## Parcours recommandé

Le meilleur retour est un parcours aussi complet que possible de Kalidon. Il faut jouer normalement tout en essayant de couvrir plusieurs types de logique :

- utiliser les portes de type `HutDoor` et attendre leur cycle complet ;
- emprunter les plateformes ou mécanismes associés à `Lvl3Platform` ;
- combattre les `MungoDrone` et plusieurs autres ennemis avec la clé et au moins deux armes ;
- déclencher les scripts, cinématiques et déplacements normaux du niveau ;
- tester les éléments mobiles, les changements d’altitude et une zone déjà visitée si le parcours le permet.

À la fin du niveau ou après une longue portion, appuyer une fois sur `L + R + SELECT` pendant que Ratchet est visible et contrôlable. Attendre deux secondes. Si la progression mène ensuite à Metalis, effectuer la transition : le plugin doit exporter automatiquement LEVEL_03, reconnaître LEVEL_04, puis rester sans écriture puisque seul le module 3 est autorisé.

Quitter PPSSPP normalement après l’export ou la transition. Ne pas charger de savestate et ne pas modifier les cheats au milieu de la capture.

## Résultat attendu

La trace manuelle doit contenir :

- `schema: "rcsm-wrapper-trace/4"` ;
- `module_index: 3` et `module_key: "LEVEL_03"` ;
- 33 entrées ;
- `capture.installed_callsites: 33` ;
- `unknown_hits: 0` ;
- au moins un callsite actif ;
- des métriques temporelles cohérentes pour chaque entrée active.

Le parseur les vérifie automatiquement :

```powershell
python profiler\tools\parse_trace.py "C:\chemin\vers\trace_L03_0001.json" --csv "C:\chemin\vers\trace_L03_0001.csv"
```

Une sortie `status: PASS` valide le format, le corpus, les adresses runtime et les invariants temporels. Elle ne détermine encore aucune politique `ONE_PASS` ou `TWO_PASS`.

## Critères d’arrêt

| Symptôme | Action |
|---|---|
| aucune ligne `module armed` pour LEVEL_03 | exporter manuellement, quitter et fournir le log |
| ancienne version ou mauvais `allowed_module` | supprimer tout le dossier du plugin et réinstaller le palier 04 |
| `resolver=fallback_scan` | ne pas poursuivre une longue session ; fournir le log |
| `install refused`, `foreign` ou `unreadable` | quitter sans forcer et fournir le log |
| crash, blocage, animation ou commandes anormales | fermer PPSSPP et décrire l’action exacte |
| `unknown_hits > 0` | ne pas tester le niveau suivant instrumenté |
| marqueur `PPSSPP JIT marker accepted` | comportement normal si les autres gardes restent valides |

## Fichiers à renvoyer

Fournir le `status.log` complet et toutes les traces créées pendant la session, notamment la trace manuelle LEVEL_03 et l’éventuelle trace automatique de transition. Une courte indication des zones parcourues et des interactions suffit ; le log PPSSPP n’est nécessaire qu’en cas de problème visible ou de refus d’installation.

La capture Ryllus fournit déjà une excellente référence 30 Hz. Les comparaisons 60 FPS commenceront après consolidation de ces paliers vanilla, avec une scène reproductible et une mesure gameplay associée à la cadence observée.
