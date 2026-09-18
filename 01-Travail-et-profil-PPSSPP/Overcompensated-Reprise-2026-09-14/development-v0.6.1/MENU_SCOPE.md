# PÉRIMÈTRE DÉPASSÉ - 17 septembre 2026

> Ce document décrit la **première** forme envisagée pour le menu : une entrée avec deux boutons de fréquence, une ligne d'état et une action Retour.
> La spécification confirmée par l'utilisateur ensuite la remplace : titre **PARAMÈTRES OVERCOMPENSATED**, exactement trois lignes avec cases natives (Framerate 30/60, Caméra, Commandes), navigation haut/bas, X pour alterner, Triangle pour revenir, aucune ligne Retour.
> Voir ../development-v0.6.2-menu/REPRISE_MENU.md, section « Spécification visuelle confirmée par l'utilisateur ».
> Ce qui reste valable ici : le repérage des trois contextes, les routines de menu, l'ABI et les contraintes de sécurité.
# Menu Overcompensated — périmètre accepté le 17 septembre 2026

## Trois points d'accès obligatoires

1. Menu principal au lancement du jeu (FRONTEND).
2. Menu pause du gameplay Ratchet et Clank.
3. Menu pause des mini-jeux, notamment celui avec Recommencer et Quitter défi.

Le menu est une entrée indépendante ajoutée à chaque liste. Il conserve toutes les entrées d'origine, leur ordre relatif, leur activation et leurs destinations. Il ne remplace ni CHEATS/SPECIAL, ni Recommencer, ni Quitter défi. Une réalisation limitée à Metalis ne sera pas présentée comme la couverture complète demandée.

## Interface commune prévue

Titre : Overcompensated.
Choix : Fréquence demandée : 30 FPS / 60 FPS.
Information distincte : Mode actif : 30 / 60 / non confirmé.
Si nécessaire : Application au prochain chargement.
Action : Retour, rétablissant la liste parent et sa sélection.

Le même choix doit être accessible depuis les trois contextes. Le menu principal doit afficher une absence de mode gameplay confirmé si aucun module de niveau n'est actif, sans présenter cela comme une erreur. Une demande en attente reste visible et peut être annulée en choisissant le mode actif. Ne pas promettre une bascule instantanée.

## Repérage disponible

Metalis, pause générale : écran3, routine B6494, lecture actions callB64A4, navigation callB6570. Objet résolu par LUI B64B0 / addiu B64BC. Sept nœuds observés après redémarrage. Validation routeD0 puis appelAE8C8 : consommer les commandes Overcompensated avant ce routeur.

Metalis, menu mini-jeu à deux choix : écran17, routine B25AC, lecture actions callB25BC, navigation callB270C. Objet résolu par LUI B25CC / addiu B25D4. Routes100/101 et textes localisés448/449 observés. Traiter ce contexte séparément : le routeur n'est pas celui du menu général.

FRONTEND : fonctions PAUSEMENU identifiées dans le rapport de recherche. Instance racine, construction et validation restent à cartographier. Les adresses Metalis ne s'y appliquent pas.

Autres modules : établir des profils de fonctions vérifiés sur chacun, sans copier les RVA de Metalis. La détection actuelle du moteur60 couvre15profils de niveaux; la présence du menu principal nécessitera sa propre détection même quand aucun de ces niveaux n'est actif.

## Architecture de réalisation

- Modèle de menu commun, séparé des adaptateurs frontend/pause/mini-jeu.
- Mémoire de nœuds, chaînes et tableaux possédée par le plugin.
- Identifiants des commandes réservés, vérification des collisions avec les entrées existantes.
- Publication/restauration de la liste à un point sûr, pas pendant son parcours par le moteur de rendu.
- Préserver sélection et état de défilement; restaurer le parent sur Retour, fermeture de pause et changement de module.
- Appels natifs : GCC PSP EABI32 entier confirmé par abi-probe; vérifier GP, flottants, signatures et registres pour chaque hook.
- Intégrer le choix au moteur demandé/appliqué déjà testé, sans modifier arbitrairement les états des acteurs au milieu d'une manche.
- Persistance dans un fichier propre au plugin à concevoir; ne pas écrire dans la sauvegarde du jeu.

## Validation nécessaire

Pour chacun des trois contextes : accès, navigation, affichage30/60, demande, annulation, Retour et seconde ouverture. Les actions d'origine doivent continuer à fonctionner. Vérifier les états d'entrées désactivées et le changement de contexte.

Tester réellement un démarrage30, puis60, avant de déclarer le comparateur utilisable. Les contrôles actuels prouvent seulement l'intégration60 et la demande/annulation en mémoire.

Couverture : frontend puis pause normale et mini-jeu surMetalis pour le prototype, ensuite profils de tous les modules disponibles. Conserver une matrice indiquant distinctement profil statique, hook installé et essai utilisateur réussi.

## État à cette étape

Ce document fixe le périmètre demandé. Aucun nouveau hook de menu n'a encore été installé. PRX dev.2 et jeu non modifiés pendant cette clarification. Dernière lecture quota :3%cinqheures,97%hebdomadaire. Autorisation d'utiliser un crédit de reset demandée, pas encore obtenue; aucun crédit consommé.
