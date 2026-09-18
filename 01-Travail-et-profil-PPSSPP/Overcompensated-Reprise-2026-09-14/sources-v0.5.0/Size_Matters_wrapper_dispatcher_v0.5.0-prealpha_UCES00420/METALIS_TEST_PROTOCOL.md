# Protocole de test Metalis — v0.5.0-prealpha

## But immédiat

Le premier passage ne cherche pas encore à corriger Metalis. Il doit confirmer que la nouvelle version reconnaît `LEVEL_04`, installe les 36 routes `TWO_PASS`, conserve le comportement vanilla et révèle le déplacement mémoire produit par le nouveau binaire.

## Palier 05A — à faire maintenant

1. Fermer complètement PPSSPP.
2. Sauvegarder puis supprimer l'ancien dossier `PSP/PLUGINS/SizeMattersWrapperProfiler`.
3. Extraire `RCSMDispatcher_v0.5.0_STAGE05A_METALIS_ALL_TWO_PASS_UCES00420.zip` à la racine du memstick.
4. Désactiver tous les blocs CWCheat 60 FPS et tous les anciens correctifs locaux.
5. Démarrer PPSSPP, charger une sauvegarde et entrer sur Metalis.
6. Jouer une section représentative, idéalement jusqu'à avoir rencontré plusieurs robots et mécanismes.
7. Pendant que le personnage est contrôlable, appuyer sur `L + R + SELECT`, attendre deux secondes puis fermer complètement PPSSPP.
8. Conserver `status.log` et tous les `trace_L04_*.json` de cette session.

Le cadrage vidéo n'est pas nécessaire pour ce premier contrôle structurel. Une courte vidéo devient utile si un comportement visuel, une animation ou un mouvement paraît déjà différent malgré le routage intégral en `TWO_PASS`.

## Lignes attendues dans `status.log`

Le début du journal doit contenir des informations équivalentes à :

```text
start version=0.5.0-prealpha ... trace_schema=5 ... allowed_module=4
module armed key=LEVEL_04 index=4 mode=policy_module callsites=36 two_pass=36 one_pass=0 custom_fallback=0 ...
```

Il faut également relever `base=0x...` et `delta=...`. Si le profil n'est pas reconnu, si le total n'est pas 36/36 ou si `wrong_route`, `foreign`, `unreadable` ou `config rejected` apparaît, ne pas poursuivre vers 05B.

## Construction du socle 60 FPS

Le socle de Metalis sera préparé après réception du journal 05A. Il devra uniquement contenir les six corrections universelles suivantes, relocalisées avec le `delta` réellement observé :

- delta général `1/30 → 1/60` ;
- compensation locale de la physique du joueur ;
- sous-pas du joueur `2 → 1` ;
- suppression d'un seul `VBlankStart` ;
- pas positif de caméra `1/30 → 1/60` ;
- pas négatif de caméra `-1/30 → -1/60`.

Le socle ne devra pas toucher au wrapper, aux callsites, aux armes ou aux dégâts. Les deux corrections des boulons en titane pourront former un bloc séparé activable pour la partie normale, mais elles ne sont pas nécessaires pour juger une famille `WF`.

## Palier 05B — après validation de 05A

Le profil 05B ne change qu'un callsite : `WF-030`, associé statiquement à `TMRobotHeadB_Update`. Les 35 autres callsites restent `TWO_PASS`, ce qui permet d'attribuer tout changement reproductible à cette seule famille.

Le test doit être refait depuis la même sauvegarde, après un redémarrage complet de PPSSPP. La trace attendue doit annoncer `two_pass=35` et `one_pass=1` ; il faut observer l'animation, la rotation, les déplacements, les attaques et l'état final du robot concerné.

## Palier 05C — seulement si 05B est stable

Le profil 05C place neuf callsites d'acteurs ou de mouvements en `ONE_PASS`. Il sert à élargir la couverture après validation du mécanisme sur une cible isolée, et non à remplacer l'essai ciblé.

Les familles d'armes/dégâts `WF-006` à `WF-012`, ainsi que `WF-002`, `WF-013` et `WF-014`, restent `TWO_PASS`. Les armes et les attaques de mêlée feront l'objet de mesures et de routes `CUSTOM` distinctes lorsque les événements d'impact, les ticks et les temporisations auront été isolés.

## Fichiers à renvoyer

- le `status.log` complet ;
- chaque `trace_L04_*.json` créé pendant le passage ;
- le nom exact du ZIP utilisé ;
- la présence ou non d'un crash, d'un ralentissement, d'une animation étrange ou d'un changement gameplay ;
- une vidéo seulement si un phénomène visuel doit être comparé.

Ne pas passer d'un profil à l'autre en remplaçant seulement l'INI pendant que PPSSPP tourne. La configuration est lue au démarrage et les instructions du module peuvent rester en mémoire jusqu'à la fermeture complète de l'émulateur.
