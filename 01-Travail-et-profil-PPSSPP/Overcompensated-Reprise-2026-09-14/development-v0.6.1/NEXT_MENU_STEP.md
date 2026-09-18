# Reprise après validation en jeu du 17 septembre, 00:42

Le PRX dev.2 a bien été chargé par le redémarrage utilisateur. Sonde PASS :167/167 sites,36/36 redirections,cave7mot34=3C043F00,modeconfirmé60. Aucun ancien patch mémoire réappliqué. Bases actuelles plugin 0x8957100 et module 0x914cd00. Toujours revalider après redémarrage.

Test réel de boîte de commande :60/60/0 -> demande30 donnant30/60/1 -> annulation60 donnant60/60/0. Aucun changement de fréquence active. Après test, sonde complète à nouveau PASS. Pas de touches envoyées, pas de suspension CPU, jeu laissé dans sa pause interne. La transition effective30 et le retour60 après rechargement restent non testés; ne pas les confondre avec le test de demande.

## Menu racine retrouvé

Après redémarrage, écran3 (auparavant17). Table dispatcher : cibleRVA ADE28, jal B6494. Objet racine résolu sur instructions live B64B0 LUI s1 et B64BC addiu s0,s1; adresse 155320796. Sept entrées locales IDs365,221,222,223,225,226,227; routes2,4,5,12,26,6,29. Entrées2-5 désactivées dans cette scène; conserver leurs statuts. Sélection0. Le précédent objet écran17 à2entrées existe toujours en RAM mais est INACTIF : première sonde de ce tour le lisait encore, corrigée ensuite par branche screen3/17.

Routine racine B6494 : lit masque actions via callB64A4 ->78448; retour v0 copié a0 àB64AC. Bits0x1008 = retour/start;0x4000=validation. La validation relit directement le nœud sélectionné puis routeD0; nonzero passe au routeurAE8C8 par callB655C. Navigation via PAUSEMENU_Update àB6570. Ne pas passer un ID réservé au routeur vanilla. Un hook sur GetCurrentItemNode ne couvre pas cette voie.

Pistes de raccordement, NON IMPLEMENTEES : wrapper de lecture d'actions au callB64A4 qui appelle l'original puis consomme uniquement les actions du sous-menu Overcompensated; extension du tableau de pointeurs avec huitième nœud possédé par plugin; sous-menu temporaire dans le même objet de rendu, sauvegarder/restaurer tableau,nombre,sélection et champs de scroll. Il faut vérifier la durée de vie/reconstruction et le rendu des identifiants de widgets avant insertion. Le callEndAdding àB6C00 est un candidat, son lien avec la construction racine reste à confirmer (ne pas supposer sur proximité).

## ABI : obstacle réduit par une preuve de compilation

menu-audit/abi-probe.c et.s confirment GCC PSP EABI32 : huit argumentsentiers dans$4-$11, neuvième à0(sp), exactement comme AddItem analysé. La crainte qu'un prototype C utilise forcément o32 était infondée pour cette chaîne. Un prototype correctement typé peut convenir; GP plugin/jeu et arguments float doivent encore être préservés/validés. Aucun appel natif expérimental effectué.

## Prochaine étape

Développer et tester hors jeu le modèle de menu (conservation des7entrées, domaine descommandes,annulation et demandeFPS), puis hook UI protégé et nouvelle compilation/installation. Interface native toujours absente. Nouvelle intervention probable pour redémarrer avec ce futur build. Ne pas relancer les scripts de migration ponctuels add-fps-backend.py/check-fps-configs.py. verify-live-metalis est enlectureseule et dérive baseslogs; menu-readonly/test-live-fps-mailbox ont des gardes liées à cette session, à régénérer si changement.

Quota à dernière lecture :82% cinqheures,90%hebdomadaire, créditsnonutilisés. Clôture avec marge conformément à la demande utilisateur.
