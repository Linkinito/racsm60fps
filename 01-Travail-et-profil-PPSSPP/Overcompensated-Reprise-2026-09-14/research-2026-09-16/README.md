# Reprise du 16 septembre 2026 — résultats et prochaine session

Travail arrêté pour préserver le quota5h (dernière lecture avant clôture :85% utilisé). PPSSPP absent au contrôle processus; aucune nouvelle modification mémoire ni fichier de jeu/PRX/INI/save. Les anciens essais mémoire sont à reconstituer après lancement et détection fraîche.

| Sujet | Résultat | Rapport |
|---|---|---|
| Metalis caisses | Deux timers encore à -1/image et helper téléportation1/30; trois candidats vérifiés, non appliqués | [Metalis](metalis/README.md) |
| Débris | Cave7 intègre dt0.5 mais compteur de collision encoredt1; modèle numérique illustre rebond anticipé; candidat non testé | [Metalis](metalis/README.md) |
| Recul/armes | Chemin du recul identifié; distance par impact à distinguer de vitesse/cadence. Power-up balistique et missiles cartographiés partiellement | [Metalis](metalis/README.md) |
| Pause/menu | Quatre floats du blink identifiés; fonctions natives et structure de liste des menus retrouvées | [Menus](menus/RAPPORT.md) |
| Sauvegardes | PJ et7 échanges récupérés; RE00 initialisation confirmée; zone supposée libre contient table de compteurs | [Sauvegardes](saves/README.md) |
| Bloom | Exception PPSSPP pourUCES00420 désactive réduction résolutioneffets; réglage générique seul potentiellement sans effet | [Rendu](render/README.md) |
| Draw distance | Pipeline projection/plans identifié; aucun seuil objet global certifié | [Rendu](render/README.md) |
| Portages | Méthode transférable, patch binaire non démontré; fichiers pilotes manquants | [Portages](ports/README.md) |

## Ordre de reprise

1. Lire ce fichier puis rapportMetalis; ne pas refaire la récupération des chats ni des archives.
2. Détecter processus/port, jeuUCES00420, module4 et sa base, pluginv0.6global. Reconstituer les corrections expérimentales historiques sous garde depuis snapshots; jamais réinjecter anciennes vitesses dynamiques ni adresses sans relocalisation.
3. Tester séparément caisses, puis collision débris, puis quatre valeurs pause. Les candidats sont des manifestes de recherche, pas un patch livré/validé.
4. Comparer30/60 sur mêmes événements; demander retour visuel seulement quand utilisateur disponible. Recueillir un impact ennemi isolé pour séparer force/distance/cadence.
5. Menu : identifier instances de listes et validation avant insertion; sauvegarde : aucune réserve interne certifiée, ne pas écrire dans la plage nulle. Bloom : capture GE et comparaison1x/4x avant changement compat.

Tous les rapports distinguent preuves statiques, hypothèses et essais restant à faire. Aucun nouveau PRX compilé ou installé pendant cette passe.
