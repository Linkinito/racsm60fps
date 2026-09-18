# Reprise du menu natif — 17 septembre 2026, 19 h 40

## État réel

Le premier prototype **0.6.2-native-menu-dev.1** est installé et exécuté au menu principal. L’utilisateur confirme entrer dans Overcompensated et demande des **cases dans le style du menu du jeu**, car le texte est mal placé/caché. Capture visuelle : le texte Overcompensated se superpose entre Charger partie et Nouvelle partie. Ce rendu n’est pas terminé.

Les trois points d’entrée sont implémentés : FRONTEND, pause générale et pause de défi. Les deux pauses sont identifiées statiquement dans les 15 modules solo/spéciaux. Seul FRONTEND a été contrôlé en jeu dans cette session. Ne pas présenter les deux pauses comme validées.

Le contrôleur ajoute une liste de pointeurs privée sans modifier les nœuds d’origine. Il intercepte ses propres commandes avant le routeur vanilla et restaure le parent. Les trois passerelles conservent les registres et utilisent le GP du jeu pour lire les entrées, celui du plugin pour le contrôleur C. Le choix FPS est différé ; aucune transition effective 30→60/60→30 n’est encore prouvée en jeu.

`analysis/live-frontend-dev1.json` prouve : 5 entrées (4 originales conservées + Overcompensated), routes originales 99/98/79/94, hook installé, demande60/appliqué0 (FRONTEND), jeu non figé. Base plugin 0x08957100 (144011520), FRONTEND 150181888, objet menu151345904. Ces adresses ne doivent pas être reprises sans vérification.

## Versions et fichiers

- Installé/en mémoire : dev.1, SHA256 d1239a3f4c7302fbfb57cc592f220973dfe5c0467ccb5ffcbd8074ad87b86354.
- `runtime-dev1/` contient le PRX, ELF, symboles et rapport EXACTS du prototype actif. Le binaire a été reconstruit et son SHA correspond.
- Sources courantes et compilation courante : **dev.2**, correction de persistance uniquement. NON INSTALLÉE. Voir BUILD_WINDOWS.json et runtime-symbols.json.
- Sauvegarde avant installation : `../sessions/before-native-menu-20260917-193300/`, ancien plugin dev061 et SAVEDATA.
- `verify-live-frontend-dev1.mjs` : lecture seule, recherche la base par signatures et exige la redirection FRONTEND vers le hook de dev.1 ; conserve un rapport.
- `verify-live-metalis.mjs` : adapté au binaire courant dev.2, à utiliser seulement après installation/rechargement correspondant.

L’installation a conservé le socle de gameplay dev061. Le plugin actuel conserve donc les correctifs Metalis précédents ; leur conformité en mémoire après cette nouvelle version reste à recontrôler lorsque Metalis sera chargé.

## Persistance

Le prototype a enregistré initialement 60, puis les demandes30/60 ont été reçues, mais le remplacement de Overcompensated.fps par renommage n’a pas produit de nouvelles confirmations dans le journal. Hypothèse très probable : destination déjà existante refusée. Dev.2 écrit directement les trois octets du fichier de préférence, vérifie écriture/fermeture et n’utilise plus ce renommage. Ce changement est compilé mais **pas encore validé en jeu**. Ce n’est pas une écriture atomique : fichier partiel rejeté au prochain démarrage, retour à la valeur de l’INI. Aucune sauvegarde native n’est modifiée. Ne pas confondre le choix demandé et le choix persisté dans dev.1.

## Prochaine étape prioritaire : mise en page avec cases

L’utilisateur a explicitement demandé des cases et une sélection lisible dans le style du jeu. Ne pas se limiter à décaler le texte ou à remplacer une option vanilla.

Cause du placement actuel : nœuds privés avec rectangleID=-1, donc le renderer impose x≈240, y=32+16*indice (bas du texte +15). FRONTEND utilise des rectangles/widgets261/262/263/264 pour les quatre entrées originales ; celles-ci ne suivent pas cette grille. Ajouter le cinquième nœud ne crée aucune case.

Piste à étudier (PAS IMPLÉMENTÉE) : fournir des rectangles privés au rendu des seuls nœuds Overcompensated, via interception gardée de la résolution des rectangles, et dessiner/reprendre les cadres natifs. Ne pas modifier globalement la grille de tous les menus. La fonction native Metalis GetRect est 0xA0FD4, appelée dans PAUSEMENU_Render à0xACE4C pour le texte principal ; a0=ID, a1=rectangle de quatre entiers, f12 conservé. Renderer début0xAC970 ; branche fallback-1 à0xACE18. Le renderer contient d’autres chemins selon flags : les inspecter avant de généraliser. FRONTEND renderer0x164D0. Les sources originales et désassemblages restent dans research-2026-09-16/menus.

Une autre approche par widgets existants doit conserver les quatre entrées originales et leur navigation. Ne pas fabriquer de cases par empilement de nœuds invisibles simplement pour obtenir une coordonnée.

## Tests et limites

Tests hôte du contrôleur : 24 tailles de liste, conservation des entrées, commandes30/60, retour, remise en état et reconstruction. Tests précédents FPS, transactions (600 scénarios et1348 écritures défaillantes simulées), profiler, format et traces passent. Compilation PSP avec avertissements traités comme erreurs. Ces tests ne prouvent pas le rendu, les transitions de modules ni une fidélité30/60 du gameplay.

Restent : rendu avec cases dans les3contextes ; persistance30 puis60 après redémarrage ; navigation/reconstruction/retour et dialoguesRestart/Quit ; conformité167sites/36redirects surMetalis ; vrais essais30puis60. Vérifier aussi l’arrêt du plugin si un hook est actif et la gestion des menus en cas de changement inattendu du code.

## PPSSPP et quota

Les lancements automatiques (avec ISO, depuis son dossier et via lanceurWindows) ont planté dans amdxc64.dll, exception0xc0000005, avant chargement du plugin. Le lancement manuel utilisateur a réussi. Ne pas réessayer en boucle ou modifier le pilote.

Un crédit a été explicitement autorisé et consommé durant cette reprise (idempotencyKey c673b830-87a9-4e0b-a98a-45477f917da3). Il en reste un ; aucune autorisation pour un deuxième. Dernière lecture avant finalisation : quota5h79%, semaine12%. Arrêt avec marge demandé par l’utilisateur.

## Spécification visuelle confirmée par l’utilisateur — après le premier essai

Cette spécification remplace la présentation du prototype à six lignes (deux boutons FPS séparés, statuts, Retour). Reprendre la forme du menu natif Paramètres audio/vidéo montré par l’utilisateur : bandeau de titre, cases à contour jaune, libellé à gauche et valeur dans une case à droite ; sélection native lisible ; pied de page X Alterner et Triangle Ret.

Titre exact : **PARAMÈTRES OVERCOMPENSATED**.

Exactement trois options :

| Libellé | Valeurs alternées par X |
| --- | --- |
| Framerate | 30 FPS / 60 FPS |
| Caméra | Proche / Éloignée |
| Commandes | PSP / Manette |

Navigation haut/bas entre les trois lignes ; X alterne la valeur de la ligne sélectionnée ; Triangle revient au menu parent. Ne pas ajouter une quatrième ligne Retour. Accès obligatoire depuis le menu principal, la pause Ratchet/Clank et la pause des mini-jeux. Conserver les options vanilla.

Référence fournie : C:/Users/linki/AppData/Local/Temp/codex-clipboard-d1adcdb4-ecc1-486b-a43e-f671bd0c7b1e.png (image temporaire ; disposition décrite ici pour pérennité).

La présentation des trois options est confirmée, mais leurs implémentations ne doivent pas être confondues avec cette spécification. FPS reste différé tant qu’une transition fiable n’est pas validée ; l’expliquer discrètement sans rajouter d’option. Pour Caméra et Commandes, reprendre les trouvailles/prototypes existants avant de définir les valeurs et actions précises. Ne pas livrer des bascules factices ni déclarer ces deux réglages fonctionnels sur la seule base de l’interface. Cette mise à jour consigne la demande ; aucun changement de plugin effectué après l’arrêt à91% du quota.
