# Spécification du profiler MIPS — v0.4.5

## Objectif et non-objectifs

Le profiler établit **qui appelle**, **combien de fois** et **sur quelle fenêtre VBlank**. Il ne modifie pas encore le nombre de passes du helper, le delta time, la physique ou le framerate. Sa sortie sert à préparer un dispatcher correctif spécifique à UCES00420 tout en conservant une architecture réutilisable pour d’autres jeux.

## Deux espaces d’adresses : référence et runtime

Le corpus utilise la base de référence `0x09139D00`, issue des dumps propres. La présence d’un plugin change toutefois l’allocation mémoire : le retour v0.4.1 montre que `rcp1` a été chargé `0x6000` plus haut. Cette valeur est une observation, pas une constante.

Le runtime énumère donc les modules PSP, recherche le module courant nommé `rcp1`, lit son `text_addr`, puis calcule :

```text
address_delta = rcp1.text_addr - 0x09139D00
runtime_address = reference_address + address_delta
```

Le plugin applique ce même delta à l’ancre de détection, aux cinq gardes, aux entrées des wrappers, aux 493 `$ra`, au callsite single configuré et au saut final de chaque trampoline. Si l’API de modules échoue, un balayage borné de `-0x200000` à `+0x400000`, par pages de `0x1000`, n’est accepté que s’il trouve exactement un candidat. Si l’API fonctionne mais ne trouve aucun `rcp1`, le balayage n’est pas lancé afin de ne pas confondre un ancien bloc RAM avec un module vivant.

Un profil n’est accepté qu’après trois observations identiques espacées de 100 ms. LEVEL_15 et LEVEL_21 restent équivalents : leurs tables de callsites et leur wrapper sont identiques, donc cette ambiguïté ne change pas la redirection.

Historique : la v0.4.0 confondait mots PRX bruts et mots relocalisés ; la v0.4.1 supposait encore les adresses absolues du dump ; la v0.4.2 a validé la base dynamique à `+0x7000`, mais a pris le marqueur JIT `0x682BACB6` pour un changement de niveau. La v0.4.3 accepte la classe officielle PPSSPP `0x68xxxxxx` uniquement au premier mot du wrapper, puis valide les 55 hooks de Pokitaru et 496 697 hits connus. La v0.4.4 ajoute les métriques temporelles et valide les 57 hooks de Ryllus, 122 243 hits connus et la transition vers Kalidon.

## Clé de trace

Chaque `jal wrapper` connu est associé à :

```text
(module_index, ra_reference, family_id)  -> corpus stable
(module_index, ra_runtime, family_id)    -> capture courante
```

Sur Allegrex, `$ra = adresse_du_jal + 8`. Les 493 clés sont triées par `$ra` dans chaque module afin que le shim effectue un lookup binaire sans allocation.

## Modes

- `detect_only` : lie le profil et peut exporter une table vide ; aucune écriture dans le jeu ni dans le trampoline.
- `single_pokitaru` : traduit la référence `$ra = 0x091840C0`, puis redirige uniquement le callsite runtime correspondant, famille WF-002, LEVEL_01.
- `focused_pokitaru` : sélectionne par défaut WF-019 et redirige ses deux branches `TriggeredDoor` dans LEVEL_01 ; la famille est configurable par `focus_family`.
- `full_module` : redirige tous les callsites du module détecté si son index correspond à `allowed_module`; `0` signifie tous les profils connus.

L’installation est « tout ou rien » : tous les mots originaux et la portée du `jal` sont vérifiés avant la première écriture. Un échec d’écriture déclenche un rollback des mots déjà changés.

## Chemin chaud

Le stub Allegrex sauvegarde l’état CPU, transmet le `$ra` runtime au shim C, le restaure et effectue un tail-jump vers le wrapper original. L’instruction `j` finale appartient au profiler : juste avant un armement instrumenté, elle est réencodée vers le wrapper runtime du module détecté, puis les caches sont synchronisés. Aucun GPR du jeu n’est sacrifié pour transporter cette cible. Cette auto-adaptation n’est jamais exécutée en `detect_only`.

Le shim incrémente un compteur d’activité atomique, enregistre le hit si la capture est ouverte, puis décrémente le compteur. Il n’appelle aucune API PSP.

Les compteurs saturent à `UINT32_MAX`. `first_sample` est fixé au premier hit et `last_sample` au plus récent. Depuis la v0.4.4, le profiler compte aussi les VBlank distincts actifs, les hits supplémentaires dans un même VBlank, le maximum par VBlank et les écarts de 1, 2 ou davantage de VBlank. Un `$ra` absent du profil incrémente `unknown_hits`; une trace correcte doit normalement laisser ce compteur à zéro.

## Export v4

Une trace contient l’environnement, le mode, la raison de l’export, le module, la fenêtre VBlank, le nombre de profils équivalents, le nombre de sites réellement installés et les statistiques complètes du module. Elle conserve `reference_base`, `runtime_base`, `address_delta`, `resolution_source` et, pour chaque entrée, le couple `ra` stable / `runtime_ra`. La v4 ajoute `active_vblanks`, `same_vblank_hits`, `max_hits_per_vblank`, `gap_1_vblank`, `gap_2_vblank` et `gap_other_vblank`. Le schéma est dans `profiler/trace_schema.json`.

L’export est déclenché par `L + R + SELECT`, un changement de module ou l’arrêt du plugin. Si aucun module n’est reconnu, la même combinaison écrit dans `status.log` la méthode de résolution, le statut de l’API, la base, le delta et les valeurs observées aux adresses déjà traduites. Avant de copier les compteurs, le runtime ferme l’enregistrement et attend que le nombre de hooks actifs revienne à zéro. Aucune I/O n’a lieu dans le trampoline.

## Politique de sécurité

Tout profil reste `VANILLA` jusqu’à mesure. La résolution dynamique ne rend pas l’analyse temporelle automatique : le PRX sait retrouver une structure connue après déplacement, mais il ne sait pas décider seul si une logique est « par frame », « delta time » ou « tick fixe ». Le futur verdict repose sur deux axes :

1. évolution de la fréquence d’appel entre 30 et 60 FPS ;
2. évolution mesurée de l’effet gameplay (distance, durée, dégâts, ticks, collision ou état final).

Une famille peut recevoir une règle commune uniquement si ses callsites se comportent de la même manière. Sinon, la décision descend au niveau `(module, $ra)`.

## Critère de sortie du prototype

La transparence des 55 hooks de LEVEL_01 et des 57 hooks de LEVEL_02, les exports cohérents et les transitions vers Ryllus puis Kalidon sont désormais validés. La prochaine frontière est l’instrumentation des 33 callsites de LEVEL_03, puis les comparaisons 30/60 FPS assorties de mesures gameplay. Le patch correctif restera un livrable séparé.
