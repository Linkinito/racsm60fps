# Metalis — état de recherche du 16 septembre 2026

PPSSPP absent lors de la reprise : aucun nouvel essai mémoire, aucun PRX/INI/ISO/sauvegarde modifié. Les anciens essais mémoire ne survivent pas à la fermeture. Ne pas présenter ces résultats comme une validation visuelle.

## Caisses : trois candidats concrets

`crate-candidates.json` contient trois instructions vérifiées sur LEVEL_04.PRX SHA256 6896122ac19973e928303dc94c40fa309b5f06e5fef6ab14f624987035a4dc37. RVA signifie offset depuis la base du module, à redétecter.

- 0x13579C et 0x135CF0 : les callbacks secondaires des téléporteurs santé/power-up soustraient 1 au timer objet+0x70 chaque appel. Candidat -0.5 pour conserver les unités 30 Hz à 60 appels/s.
- 0x67060 : le helper appelé par les deux téléporteurs ajoute 1/30 à un temps écoulé pvars+0x28. Candidat 1/60 (LUI 0x3D08 -> 0x3C88, partie basse 0x8889 inchangée). Ce helper est partagé : effet potentiellement plus large que les caisses; les particules émises ont encore leurs propres routines.
- Ne PAS doubler aussi le multiplicateur 30 aux RVA0x1359C4/0x135F18 : son résultat initialise précisément ce même timer objet+0x70. Doubler la durée ET diviser le décrément produirait une durée quatre fois plus longue en nombre d'images.

L'effet de téléportation complet exige encore vérification des particules, pas seulement du compteur d'émission. Les fonctions descriptor update sont vides : la logique pertinente est dans les callbacks secondaires 0x13578C/0x135CE0.

## Débris : incohérence identifiée dans la compensation existante

Le plugin v0.6 détourne 0x27EA0 vers la cave7. Elle intègre position avec dt=0.5, gravité dt et terme 0.5*g*dt², puis remet f12=1 (mot index34, 0x3C043F80). Retour original 0x27F0C. À 0x27F5C, cette valeur est copiée vers f13, puis retranchée du champ état+0x34 à 0x27F68. Le helper 0x279A0 traite l'expiration de ce champ et applique la réponse au contact; 0x27BD0 calcule le temps prévu de collision dans les unités originales et l'écrit à +0x34.

La trajectoire progresse donc de 0.5 tandis que le compte à rebours de collision progresse de 1. Un modèle illustratif de chute donne un déclenchement à hauteur0.75 au lieu du sol0 après la moitié du temps prévu. `debris-countdown-model.json` et `prepare-evidence.py` reproduisent ce calcul. Ceci confirme une incohérence arithmétique; l'attribution au défaut visuel observé reste à tester dans le jeu.

Candidat : pour Metalis seulement, garder f12=0.5 en sortie de cave7 (mot index34 : 0x3C043F80 -> 0x3C043F00). Ne pas modifier le template global sans audit des autres modules. Avant essai : résoudre la cave réellement ciblée par le saut, vérifier sa signature entière et son retour, CPU suspendu. Aucun patch de cave n'a été appliqué ou intégré au PRX. Les compteurs généraux de débris 0x2FF5C/0x2FF7C/0x30114 sont déjà compensés par v0.6; les diviser encore serait incorrect. La disparition trop rapide n'est pas entièrement expliquée : arrêt sur faible vitesse/après rebonds et autre système de particules restent possibles.

## Recul ennemi

Routine commune 0x2AB54 : vitesse de recul état+0xC, direction +0x10/+0x14; ajout direct XZ aux RVA0x2AD84..0x2ADA8, décroissance par table+0x1C à0x2ADB4. Les tables mouvement corrigées précédemment ne touchaient pas +0x1C.

Attention : une impulsion initiale inchangée ET une décroissance inchangée donnent la même somme de déplacements par impact, mais sur la moitié du temps à60fps. L'impression de force x2 ne prouve donc pas une distance x2. Des impacts répétés peuvent aussi changer le total. Ne pas diviser globalement les impulsions : joueur signalé correct, chemins ennemis et joueur à distinguer. Prochaine capture : watchpoint d'écriture sur +0xC d'un ennemi vivant identifié, mesurer distance/durée/impacts contre référence30fps.

## Armes et power-ups : inventaire utile, pas validation

- DerbyPowerup 0x1332FC multiplie vitesse XYZ par1/30 (LUI0x13330C), puis ajoute gravité table0x2E3538 à vy sans dt. Un éventuel1/60 doit être accompagné de gravité par demi-pas, en conservant les limites et les unités de vitesse. Ne pas traiter ce LUI seul.
- VehicleMissile 0x196EA0 : vitesse état+0x20 utilisée pour collision balayée (0x196FD0), déplacement et émission de traînée. Table de guidage0x2EC31C, plusieurs constantes d'effets aux0x2EC33C/40. Le1.0 à0x197144 appartient aussi aux calculs fractionnaires d'émission : pas un timer à remplacer aveuglément.
- VehicleMine update0x196658 ne contient pas de TTL direct; suit l'objet propriétaire et un état. Chercher ses callbacks secondaires avant d'affirmer durée infinie ou correcte.
- ElectroBall callback0x138A9C, PowerupHealth0x133F70 : désassemblages/table objets disponibles, cadence dégâts et durée encore à tracer.

## Reprise du test

1. Relancer PPSSPP, charger sauvegarde normale Metalis, retrouver module4/base/plugin actif. Éviter les scripts à anciennes adresses absolues.
2. Reconstituer les essais historiques depuis leurs snapshots, avec préflight. `prior-arena-static-rvas.json` conserve les37 sites statiques; corrections joueur dans connection/clanksaw-movement-plan.json et clanksaw-rotation-plan.json. Ne pas restaurer d'anciennes valeurs dynamiques de vitesse.
3. Tester d'abord les caisses (trois candidats), puis séparément le compteur de rebond, puis pauseblink (rapport menus). Comparaison30/60 même scène : délai casse->retour, durée téléportation, premiercontactsol, dernierdébris, période du curseur pause.
4. Pour armes : projectile vitesse/portée, durée avant disparition, cadence/dégâts/contact, cooldown, cumul des effets et pickups. Capturer plusieurs cycles; 60fps affichés ne constituent pas une validation.

Les changements sont préparés et documentés, pas installés. Le jeu étant fermé et l'utilisateur absent, la validation visuelle et la capture d'impacts sont les prochaines étapes dépendant d'une session jouable.
