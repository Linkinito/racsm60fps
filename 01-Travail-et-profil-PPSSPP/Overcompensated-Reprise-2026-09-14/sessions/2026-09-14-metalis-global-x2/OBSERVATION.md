# Incident Metalis / véhicule de Clank / v0.6.0 globale

Observation utilisateur : 60 FPS affichés, gameplay perçu comme accéléré x2 ; arène où les ennemis attaquent, jeu placé dans le menu pause. Aucune mesure chronométrique de x2 effectuée par la sonde.
Journal : full patch armed LEVEL_04 ; 106 écritures statiques, pending_constants=0, layers=15 ; 36 callsites, 28 TWO_PASS, 8 ONE_PASS, 13 CUSTOM fallback inclus dans TWO_PASS. Base 0x0914BD00, delta +0x12000. Pas de refus ni erreur signalés dans le journal examiné.
Conclusion : le profil global est installé, pas uniquement le socle. Son application réussie ne valide pas la compensation temporelle de ce mini-jeu.
Piste statique : WF-029 (helper partagé entre véhicules Clank et ennemis) reste TWO_PASS. WF-028 (torses Clank) est ONE_PASS. Il faut examiner leurs opérations et la boucle véhicule/timers hors wrapper avant de choisir une correction. Pas de passage global aveugle à ONE_PASS.
Aucun redémarrage, reprise de jeu, changement de profil ni écriture mémoire corrective pendant cette investigation. Rester en pause pour analyse statique ; ne pas demander de longue phase idle en arène hostile.
