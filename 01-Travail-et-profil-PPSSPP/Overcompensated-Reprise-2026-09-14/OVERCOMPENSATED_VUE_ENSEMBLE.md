# Overcompensated — comprendre tout le projet

> Synthèse accessible du **17 septembre 2026**, fondée sur les discussions récupérées, les sources et les rapports locaux.
>
> **Jeu :** Ratchet & Clank : La taille ça compte / Size Matters, version PSP européenne **UCES00420**.
> **Environnement vérifié :** PPSSPP 1.19.3, Windows 64 bits.
> **Dernière version chargée et contrôlée :** `0.6.1-metalis-integration-dev.2`.
> **Statut :** développement expérimental, pas encore validé sur tout le jeu.

Ce document présente tous les volets connus du projet en langage simple. Il sert de point d'entrée pour comprendre le travail et préparer une future documentation GitHub. Les rapports techniques restent nécessaires pour les adresses, les détails et les preuves de chaque essai.

## Sommaire

1. [L'objectif](#1-lobjectif)
2. [Pourquoi le 60 FPS est compliqué](#2-pourquoi-le-60-fps-est-compliqué)
3. [Comment fonctionne le mod](#3-comment-fonctionne-le-mod)
4. [L'historique](#4-lhistorique)
5. [Metalis et les résultats actuels](#5-metalis-et-les-résultats-actuels)
6. [Ce qui est réellement vérifié](#6-ce-qui-est-réellement-vérifié)
7. [Le menu et le choix 30/60](#7-le-menu-et-le-choix-3060)
8. [La généralisation aux autres niveaux](#8-la-généralisation-aux-autres-niveaux)
9. [Les autres chantiers](#9-les-autres-chantiers)
10. [La méthode de travail](#10-la-méthode-de-travail)
11. [Les acquis et les fausses pistes](#11-les-acquis-et-les-fausses-pistes)
12. [La feuille de route](#12-la-feuille-de-route)
13. [Préparer GitHub](#13-préparer-github)
14. [Où retrouver les preuves](#14-où-retrouver-les-preuves)
15. [Petit lexique](#15-petit-lexique)

## 1. L'objectif

Overcompensated veut permettre de jouer à Size Matters à **60 images par seconde en conservant le rythme du jeu original**.

L'affichage doit être plus fluide, tandis que les déplacements, les attaques, les ennemis, les pièges, les animations et les délais conservent leur comportement attendu. Le joueur doit garder les mêmes possibilités, contraintes et récompenses.

Autour de cet objectif principal, le projet explore aussi :

- Un menu Overcompensated pour choisir des options et comparer les modes 30 et 60 FPS.
- Une caméra inspirée du cadrage PS2.
- Des contrôles adaptés à une manette moderne et au second stick.
- De nouveaux points de compétence et un stockage des données propres au mod.
- L'amélioration de certains effets graphiques et distances d'affichage.
- La réutilisation éventuelle de la méthode sur d'autres jeux PSP.

Ces sujets ont des niveaux d'avancement différents. Leur présence dans le projet ne signifie pas qu'ils sont déjà intégrés au plugin actif.

## 2. Pourquoi le 60 FPS est compliqué

Le jeu mélange plusieurs façons de mesurer le temps. Certaines opérations utilisent le temps écoulé. D'autres exécutent simplement une action à chaque image.

Par exemple, un compteur de 90 mises à jour représente trois secondes à 30 mises à jour par seconde, mais une seconde et demie à 60. Une caisse peut alors réapparaître deux fois trop vite.

C'est pourquoi les premiers essais ont produit un jeu affiché à 60 FPS mais fonctionnant largement en vitesse ×2.

| Mécanisme | Exemple de problème | Travail nécessaire |
|---|---|---|
| Déplacement ajouté à chaque image | Véhicule trop rapide | Adapter la quantité de déplacement |
| Accélération | Vitesse maximale atteinte trop tôt | Adapter l'évolution de la vitesse |
| Compteur par image | Réapparition ou cooldown trop court | Conserver la même durée réelle |
| Interpolation | Collecte attirée trop rapidement vers Clank | Adapter la courbe de rapprochement |
| Animation et événement associés | Impact désynchronisé de l'attaque | Vérifier leur synchronisation |
| Collision | Recul ou rebond anormal | Examiner ensemble mouvement et réaction |

**Diviser toutes les valeurs par deux ne suffit pas.** Une vitesse, une accélération et une durée ne se corrigent pas forcément de la même manière. Certaines valeurs sont déjà compensées ailleurs : les modifier encore pourrait ralentir le jeu deux fois.

La cible reste un comportement fidèle, pas seulement un compteur affichant « 60 FPS ».

## 3. Comment fonctionne le mod

### Le plugin et les modules

Le programme principal est un **plugin PRX**, chargé par PPSSPP dans l'environnement PSP émulé. Il reconnaît les modules connus, vérifie les instructions attendues et applique les modifications prévues. Il possède des chemins de restauration et des journaux de diagnostic.

Le développement actuel vise PPSSPP. Les tests disponibles ne démontrent pas un fonctionnement sur PSP physique, toutes les versions de l'émulateur ou d'autres régions du jeu.

Le jeu charge différents morceaux de programme selon le niveau ou le mode. Le projet possède une cartographie de **15 profils de modules**. Un module ne correspond pas forcément à une planète entière. Plusieurs mini-jeux peuvent partager un module tout en ayant des règles différentes.

### Les familles de fonctions

La cartographie regroupe **493 points d'appel dans 59 familles**, nommées `WF-001`, `WF-002`, etc.

Ces familles concernent des appels à des routines intermédiaires étudiées, appelées « wrappers » dans les notes. Un **dispatcher** choisit le chemin utilisé par chaque appel :

- **TWO_PASS** : chemin à deux passes.
- **ONE_PASS** : chemin à une passe lorsque cette compensation est justifiée.
- **CUSTOM** : catégorie indiquant qu'un traitement particulier doit être étudié.

Dans la configuration historique v0.6.0, les routes CUSTOM utilisent encore TWO_PASS comme repli. Une étiquette CUSTOM ne prouve donc pas qu'un traitement spécial est déjà implémenté. Les choix ONE_PASS et TWO_PASS concernent les calculs étudiés, pas simplement la suppression d'une image affichée sur deux.

### Les correctifs complémentaires

Une famille de wrappers ne représente pas toute la logique d'une arme, d'un ennemi ou d'un mini-jeu. Une attaque peut dépendre d'un wrapper, d'un compteur extérieur, d'une animation et d'une collision.

Le plugin contient donc aussi des modifications ciblées d'instructions et de tables de paramètres. Certaines touchent une routine partagée, d'autres plusieurs acteurs utilisant une même table, et d'autres un comportement très précis. Metalis a montré la nécessité de combiner ces approches.

## 4. L'historique

| Étape | Apport principal | Limite |
|---|---|---|
| Socle et premières expériences 60 FPS | Déblocage de la cadence et premières compensations du temps, du joueur et de la caméra | Tous les événements ne sont pas corrigés |
| Profileurs v0.4.x | Observation des appels réellement exécutés | Observer une fonction ne la corrige pas |
| Dispatcher v0.5.0 | Choix plus fin des chemins par appel et famille | Cette version seule ne débloquait pas le 60 FPS |
| Global expérimental v0.6.0 | Réunion du dispatcher et du corpus de correctifs sur les modules cartographiés | Pas de validation complète du jeu |
| Reprise du 14 septembre 2026 | Récupération des discussions et fichiers ; connexion réelle à PPSSPP | Certaines pièces jointes restent manquantes |
| Essais Metalis des 15–16 septembre | Véhicules, arène, caisses, débris et collectes | Les autres mini-jeux restent à étudier |
| Développement v0.6.1 | Intégration aux sources, compilation et tests locaux | Menu natif et transition effective 30/60 inachevés |
| Contrôle du 17 septembre | Nouveau plugin chargé après redémarrage et vérifié en mémoire | Fidélité complète du gameplay encore à mesurer |

Le socle historique réduit notamment l'attente entre images et adapte plusieurs calculs de temps. Retirer indistinctement toutes les attentes n'est pas une solution équivalente.

### Avant Metalis

Pokitaru, Ryllus et Kalidon ont déjà fourni des observations et des traces. Kalidon a servi à un passage de référence à 30 FPS et à un passage avec le socle 60 FPS. L'Airboard a été distingué du gameplay habituel.

La couverture historique rapportée sur les trois premiers niveaux est de **85 points d'appel observés sur 145, dans 32 familles**. C'est une couverture d'observation, pas un pourcentage de jeu corrigé. Toutes les pièces originales de ces campagnes n'ont pas été récupérées.

Repères historiques : 34 points actifs sur 55 à Pokitaru, 38 sur 57 à Ryllus, et 87 570 appels utiles rapportés pour le passage B de Kalidon. Les traces cumulatives ne doivent pas être additionnées comme des sessions indépendantes.

Les anciennes mentions « archive v0.6 manquante », « non compilé » ou « mode détection » décrivent des états dépassés. Les archives v0.5 et v0.6 ont depuis été récupérées.

## 5. Metalis et les résultats actuels

La première arrivée sur Metalis concerne **Clank dans des mini-jeux**. Le niveau suivant met en scène **Clank Géant dans l'espace**. Le prochain gameplay habituel avec Ratchet se situe à **Dreamtime**.

Les essais d'un véhicule de Clank ne constituent donc pas une validation des déplacements de Ratchet.

| Sujet | Problème observé | État au 17 septembre |
|---|---|---|
| Déplacement du véhicule de Clank étudié | Vitesse et accélération excessives | Correction testée, retour visuel favorable |
| Rotation de ce véhicule | Rotation encore trop rapide | Correction complémentaire, retour favorable |
| Ennemis et pièges de l'arène | Clank ralenti mais adversaires et pièges encore à ×2 | Correctifs intégrés ; interactions partiellement validées |
| Réapparition des caisses | Délai trop court | Retour utilisateur favorable |
| Téléportation des caisses | Animation trop rapide | Retour utilisateur favorable |
| Débris des caisses | Rebonds anormaux et disparition trop rapide | Compteur de collision corrigé ; retour « semble normal » |
| Collecte de Nanotech | Récupération accélérée | Correction testée ; retour favorable |
| Collecte de munitions concernée par les essais | Attraction et animation accélérées | Correction testée ; retour favorable |
| Recul des roquettes | Trop fort sur ennemis **et joueur** | À résoudre avec comparaison à 30 FPS |
| Cooldown énergétique | Semble trop court | Soupçon à mesurer |
| Lancer de robots dans une cible | Vitesse doublée signalée | À traiter |
| Guidage de robots, proche de Lemmings | Vitesse doublée signalée | À traiter |
| Clignotement du menu pause | Trop rapide | Candidat localisé, pas encore appliqué ni validé |
| Armes et power-ups en général | Vitesse, durée et fonctionnement à contrôler | Campagne de tests nécessaire |

Les retours favorables sont principalement **des validations visuelles du joueur**. Ils ne remplacent pas encore des comparaisons mesurées complètes. Les collectes des activités de Clank ne démontrent pas que les collectes ordinaires de Ratchet utilisent les mêmes routines.

### Contenu de la v0.6.1

Les essais ont été convertis en **54 ajouts statiques** dans le registre du plugin. Metalis comporte désormais **167 sites gérés par le moteur de correctifs**, ainsi qu'un ajustement du compteur de collision dans une routine exécutée depuis le plugin.

Les 54 ajouts sont ciblés sur Metalis. Les tables des **14 autres profils sont inchangées par cette intégration** : elles conservent les correctifs du corpus précédent.

Le plugin ne stocke pas les anciennes vitesses instantanées des acteurs. Il doit corriger les règles, pas réinjecter la situation d'un véhicule provenant d'une autre session.

## 6. Ce qui est réellement vérifié

Nous distinguons quatre niveaux de preuve :

1. **Analyse du programme** : une instruction, une table ou un appel a été retrouvé.
2. **Test hors jeu** : une partie du code fonctionne dans un scénario contrôlé.
3. **Contrôle en mémoire** : les bons changements sont présents dans PPSSPP.
4. **Validation du gameplay** : le résultat se comporte comme attendu, idéalement avec comparaison 30/60.

Un niveau ne remplace pas les suivants. Pour le binaire v0.6.1-dev.2 :

- Compilation PSP réussie sous Windows, avec les avertissements traités comme des erreurs.
- **912 contrôles** de l'audit statique et binaire réussis.
- **600 scénarios** du moteur de correctifs réussis.
- **1 348 échecs d'écriture simulés** pour vérifier les chemins de restauration.
- Tests du profileur, du formatage, des traces et du contrôleur de choix FPS réussis.
- Après redémarrage réel : **167/167 sites**, **36/36 redirections** et correction de collision conformes sur Metalis.
- Mode 60 déclaré appliqué par le plugin.
- Demande de 30 puis annulation testées, sans changement du mode actif.

Les 600 scénarios sont des simulations de modules, de déplacements d'adresses et de groupes de correctifs, pas 600 séquences de gameplay. Les tests ne prouvent pas la stabilité sur tout le jeu ou toutes les machines. Cette exécution des tests hôte n'a pas utilisé les contrôles supplémentaires ASan/UBSan.

## 7. Le menu et le choix 30/60

L'objectif est une **entrée Overcompensated indépendante** dans le menu de pause et le menu principal. Les entrées originales, dont CHEATS/SPECIAL, doivent rester disponibles. L'idée de remplacer CHEATS ou de détourner une route existante a été abandonnée.

Le périmètre confirmé comprend trois accès obligatoires : le menu principal au lancement, la pause du gameplay Ratchet/Clank et la pause des mini-jeux avec Recommencer et Quitter défi. La couverture ne doit pas se limiter au menu général de Metalis.

Le moteur distingue le mode **demandé**, le mode **confirmé comme appliqué** et un changement **en attente**.

Dans la session vérifiée, demander 30 a laissé le jeu à 60 en indiquant une attente. Annuler a rétabli le choix 60 et supprimé cette attente. Les correctifs actifs sont restés conformes.

Le réglage de démarrage accepte également 30 ou 60 dans la configuration. Le chemin 30 vérifie les emplacements d'origine avant de déclarer ce mode appliqué. **Le passage effectif à 30 puis le retour à 60 restent à tester dans PPSSPP.**

### Ce qui manque

Le menu visible n'est pas encore intégré. Le vrai menu de pause principal a été retrouvé avec ses **sept entrées**. Sa navigation et le traitement de la sélection ont été identifiés. La convention d'appel des arguments entiers examinés a été vérifiée avec le compilateur PSP.

Il reste à construire l'entrée et le sous-menu, conserver les entrées originales, traiter nos commandes avant le routeur du jeu, puis tester le retour et la reconstruction du menu. Le raccordement au menu principal et aux autres modules demandera une vérification propre.

### Pourquoi recharger peut rester nécessaire

Un véhicule possède déjà une vitesse ; un projectile a déjà un âge ; une attaque a déjà un compteur. Modifier uniquement la cadence ne convertit pas ces états.

La première version pourra annoncer **« application au prochain chargement »**. Une relance de manche ne recharge pas forcément le module. Le redémarrage complet reste la référence de comparaison tant que les transitions ne sont pas validées.

La demande en mémoire n'est pas encore enregistrée automatiquement sur disque. La persistance des choix du futur menu reste à raccorder.

## 8. La généralisation aux autres niveaux

Metalis apporte des outils réutilisables : compilation, identification des versions, découverte des adresses, transactions, journaux et comparaisons. Les mécanismes étudiés — accélération, compteur par image, interpolation, collision et durée des particules — donnent aussi des pistes pour d'autres scènes.

En revanche, **une adresse ou une correction Metalis ne se copie pas automatiquement ailleurs**. Une famille WF ne promet pas la couverture complète d'un ennemi ou d'une arme. Il faut identifier les utilisateurs réels du code et mesurer le comportement dans les contextes pertinents.

Une modification spécifique n'est pas un défaut si sa portée est explicite. Chaque correction devrait progressivement posséder une fiche :

| Information | Question |
|---|---|
| Symptôme | Qu'est-ce qui était incorrect ? |
| Cause | Pourquoi le passage à 60 changeait-il ce comportement ? |
| Portée | Quels modules, familles, acteurs ou modes utilisent ce code ? |
| Modification | Qu'est-ce qui a changé ? |
| Preuve | Analyse, contrôle mémoire, retour visuel ou comparaison mesurée ? |
| Limites | Quels cas restent inconnus ? |
| Restauration | Comment revenir à l'état précédent ? |

## 9. Les autres chantiers

### Caméra inspirée de la PS2

Le cadrage retenu historiquement utilise une **distance de 9,0**, une **hauteur de 1,90**, un décalage horizontal nul et le champ de vision original. Le chiffre 1,90 désigne la hauteur, pas la distance.

Ce réglage a reçu une validation visuelle sur Pokitaru. Son intégration à la version actuelle et ses tests dans les autres scènes restent à faire. L'ancienne proposition de caméra d'épaule humoristique a été abandonnée.

### Contrôles modernes et second stick

Un profil `MODERN_PS2` a été envisagé :

| Bouton | Fonction souhaitée |
|---|---|
| L1 | Saut |
| L2 | Sélection rapide |
| R1 | Accroupissement |
| R2 | Tir |
| L3 | Recentrage sans accroupissement, expérimental |
| R3 | Vue subjective |

Une courbe progressive de caméra a été travaillée pour les faibles mouvements du stick. Le comportement de L2 demande encore un diagnostic précis.

Le prototype v0.1 et ses sources ont été retrouvés. Une v0.2 est mentionnée historiquement, mais son archive n'a pas été récupérée et sa validation n'est pas établie.

Le mouvement diagonal a fait l'objet d'un travail distinct. Le réglage PPSSPP `AnalogIsCircular=True` est conservé ; il ne faut pas ajouter une compensation sans vérifier cet acquis.

### Armes, dégâts et progression

Des tableaux et configurations d'armes et de progression sont conservés. Une présentation historique mentionnait 13 fiches d'armes, 215 lignes de dégâts et 100 niveaux de progression. Le fichier HTML annoncé n'a pas été retrouvé ; les documents associés disponibles ne doivent pas être confondus avec une validation de toutes ces données.

Les tests devront distinguer dégâts par impact, cadence, dégâts totaux, consommation de munitions, durée, expérience et réactions des cibles. Un total de dégâts par seconde correct peut masquer un nombre d'impacts incorrect.

Parmi les sujets historiques ouverts : brûleur, mêlée, acide, navigation et sauts des crabes, portes et séquences temporisées. Plusieurs utilisent des calculs extérieurs aux wrappers.

### Sauvegardes et nouveaux points de compétence

L'objectif est de comprendre comment conserver les éventuelles données supplémentaires du mod, notamment de nouveaux points de compétence.

Plusieurs zones de sauvegarde ont été examinées, dont **14 blocs répétés**. Leur initialisation a été retrouvée dans le code. Le rôle de tous les blocs et leur correspondance exacte avec les destinations restent incomplets.

Une découverte a invalidé une ancienne piste : **une zone remplie de zéros n'est pas nécessairement libre**. Le jeu écrit déjà des compteurs dans une partie de la grande zone envisagée. Les premières propositions d'utiliser un intervalle continu de bits comme réserve ne sont pas suffisamment établies non plus.

Aucun espace interne n'est actuellement certifié disponible. La piste provisoire est un fichier annexe versionné, associé correctement à la sauvegarde, avec gestion de la nouvelle partie, de la copie, de l'effacement et du rechargement. Ce système n'est pas livré.

Le déchiffrement et certains repères de format constituent des acquis historiques, mais toute modification devra vérifier leur correspondance avec le fichier effectivement utilisé. Aucun checksum supplémentaire n'a été identifié pendant la dernière analyse ; cela ne démontre pas son absence.

Les sauvegardes de progression n'ont pas été modifiées pendant ces recherches. Une extension doit être testée par une vraie sauvegarde puis un vrai rechargement du jeu : un savestate ne suffit pas. Les futurs chronos devront aussi rester indépendants du nombre d'images.

### Distance d'affichage

Le projet cherche à comprendre pourquoi certains éléments apparaissent tard et s'ils peuvent être visibles de plus loin.

Des fonctions de projection et de visibilité ont été retrouvées. Aucun réglage universel « afficher tous les objets plus loin » n'est confirmé. La limite peut appartenir à la caméra, à un objet, à un niveau ou au chargement des ressources.

Il faut partir d'une disparition reproductible, puis identifier la règle responsable. Aucun correctif de distance d'affichage n'est actuellement validé.

### Bloom géométrique à haute résolution

Le bloom est le halo autour des zones lumineuses. Le défaut signalé devient visible lorsque la résolution interne est fortement augmentée, notamment à partir de ×4.

L'analyse locale de PPSSPP 1.19.3 a retrouvé une exception de compatibilité pour UCES00420 qui désactive son mécanisme générique de réduction de résolution des effets. Un simple changement de cette option peut donc ne pas produire l'effet attendu.

Cette piste est cohérente avec le symptôme, mais la cause exacte de la scène et une correction visuelle restent à valider. C'est un chantier graphique distinct du rythme 60 FPS.

La suite prévue consiste à comparer la même scène en ×1 et ×4, isoler les autres réglages, puis examiner les étapes du rendu. Supprimer les effets ne constituerait pas une correction satisfaisante. Les sources versionnées et les observations sont dans le rapport de rendu lié plus bas.

### Portages éventuels

Trois titres ont été évoqués : **Secret Agent Clank**, **Daxter** et **Jak & Daxter : The Lost Frontier**.

La méthode et les outils pourront aider. La compatibilité du patch et l'identité des mécanismes internes ne sont pas démontrées. Aucun portage fonctionnel n'est disponible.

Chaque jeu devra commencer par son propre inventaire, sa version exacte et une scène reproductible. Ses modes devront être distingués, par exemple déplacements à pied et vol dans Lost Frontier. Aucun taux de réutilisation ou délai fiable ne peut être annoncé avec les éléments actuels.

## 10. La méthode de travail

La procédure visée est la suivante :

1. Identifier le jeu, le module et le plugin chargés.
2. Conserver les fichiers et les états utiles avant modification.
3. Vérifier les valeurs attendues avant toute écriture.
4. Tester un mécanisme identifiable et enregistrer un journal.
5. Comparer le résultat, idéalement avec une référence à 30 FPS.
6. Intégrer le changement aux sources avec sa portée et son statut.
7. Recompiler et vérifier un démarrage propre pour confirmer sa persistance.

Les adresses changent quand un module est rechargé ou lorsque la taille du plugin évolue. Les scripts doivent retrouver les bonnes bases. Une adresse d'une ancienne session n'est pas une recette permanente.

Le JIT de PPSSPP peut également remplacer certaines instructions pour accélérer l'émulation. Les outils en tiennent compte pour ne pas confondre ces marqueurs avec une corruption.

Les savestates conservent toute une image mémoire, potentiellement avec un ancien plugin. La validation d'une nouvelle version utilise donc un démarrage propre et une sauvegarde normale du jeu.

Les fichiers, journaux, versions et empreintes sont conservés pour éviter de refaire les mêmes recherches à chaque reprise. Les modifications de test en mémoire doivent ensuite être intégrées au code pour survivre au redémarrage.

## 11. Les acquis et les fausses pistes

Quelques résultats importants évitent de repartir de zéro :

- Passer WF-029 en ONE_PASS n'a pas supprimé l'accélération générale du véhicule. Sa logique de mouvement devait être examinée séparément ; l'essai a été annulé.
- Corriger uniquement Clank créait un déséquilibre contre les ennemis et les pièges restés trop rapides.
- Pour les débris, corriger le déplacement ne suffisait pas tant qu'un compteur lié à la collision utilisait un autre rythme.
- WF-002 est déjà compensée indirectement dans le contexte étudié : une nouvelle réduction risquerait une double compensation.
- WF-013, WF-014 et WF-021 demandent des vérifications séparées de navigation et de collision.
- WF-044 possède une logique de fluide extérieure au wrapper. Le choix d'une seule passe ne résout pas forcément la montée d'acide.
- Une séquence associée à WF-058 a historiquement été rapportée autour de 6,10 secondes à 30 FPS contre 3,05 à 60. C'est un repère de comparaison à confirmer, pas une validation actuelle de toutes ses utilisations.
- Des essais ont provoqué des blocages, d'où l'importance des gardes et des copies de sécurité.
- Le lancement direct de PPSSPP avec l'ISO a rencontré un problème de pilote graphique. Lancer d'abord l'émulateur seul puis ouvrir le jeu a fonctionné lors des reprises.
- Un objet présent dans une zone mémoire n'est pas forcément actif dans la scène. Il faut observer son exécution.
- Une trace sans appel peut correspondre à un mode détection ou à un chemin non sollicité. Elle ne prouve pas l'absence du mécanisme.
- Un fichier rempli de zéros ne constitue pas une réserve de stockage garantie.

Les noms descriptifs attribués à certaines familles ont évolué pendant les recherches. Une ancienne hypothèse de rôle ne doit pas devenir une certitude sans preuve associée.

## 12. La feuille de route

### Priorité immédiate

- Vérifier le passage effectif à 30 FPS puis le retour à 60 sur une scène reproductible.
- Raccorder le menu Overcompensated et afficher le choix demandé, le mode appliqué et l'attente éventuelle.
- Mesurer le recul des roquettes et le cooldown énergétique.
- Compléter les tests d'armes, power-ups et pièges de l'arène.
- Traiter séparément les mini-jeux de lancer et de guidage.
- Tester puis intégrer le correctif du clignotement du menu pause.

### Après Metalis

- Examiner Clank Géant, puis le gameplay de Ratchet sur Dreamtime.
- Réutiliser les mécanismes confirmés en vérifiant leur présence dans les autres modules.
- Revenir sur les points ouverts de Pokitaru, Ryllus et Kalidon lorsque de nouvelles preuves ou régressions le justifient.
- Élargir les comparaisons aux déplacements, sauts, dégâts, munitions, événements, récompenses, transitions et sauvegardes.

### Ensuite

Intégrer les options de caméra et de contrôles suffisamment établies, poursuivre les sauvegardes et points de compétence, puis les recherches graphiques. Les portages resteront distincts tant que leurs mécanismes ne seront pas cartographiés.

L'ordre pourra évoluer selon les observations. Aucune date de version finale n'est fixée.

## 13. Préparer GitHub

Ce document peut devenir la base de la présentation générale. Un dépôt public devrait séparer l'utilisation du mod des recherches nécessaires à son développement.

Organisation proposée, **pas encore créée ni publiée** :

```text
README.md                  Présentation courte, état et périmètre
CHANGELOG.md               Historique des versions
LICENSE                    Licence à choisir après examen des éléments inclus
CONTRIBUTING.md            Contribution et procédure de test
src/                       Sources du plugin
include/                   Définitions partagées
config/                    Configurations documentées
scripts/                   Compilation et outils de validation
tests/                     Tests automatiques
docs/
  installation.md          Installation et retour à la version précédente
  testing.md               Comparaisons 30/60
  compatibility.md         Versions et environnements réellement testés
  known-issues.md          Problèmes connus
  architecture.md          Fonctionnement technique
  fixes/                   Fiches des correctifs et de leur portée
  research/                Analyses et hypothèses
```

Le lecteur doit pouvoir comprendre rapidement **ce que fait la version, ce qui a été testé, ce qui reste incorrect et comment revenir en arrière**.

Avant une publication :

- Documenter une compilation reproductible et les outils nécessaires. La chaîne locale actuelle utilise PSP GCC 15.2.0 pour le plugin et Zig 0.15.2 comme compilateur C des tests hôte.
- Séparer versions expérimentales et versions destinées aux joueurs.
- Préciser la région du jeu, la version de PPSSPP et les réglages testés.
- Expliquer les risques de combinaison avec les anciens cheats 60 FPS et les autres correcteurs.
- Relier les correctifs à leurs preuves sans présenter les hypothèses comme des résultats.
- Préparer un modèle de bug : version, niveau, mode, scène, attendu, observé et étapes de reproduction.
- Séparer les sources du mod des copies privées du jeu, ISO, dumps, sauvegardes personnelles et conversations de travail.
- Examiner les licences et les droits des éléments retenus avant publication.
- Transformer les rapports nécessaires en documentation autonome, sans dépendance aux chemins de l'ordinateur de développement.

Le dossier actuel est un laboratoire de travail. Il n'est pas encore prêt à être publié tel quel. Aucun dépôt GitHub n'a été créé pour cette synthèse.

## 14. Où retrouver les preuves

Sept anciennes conversations, représentant 88 échanges, ont été récupérées pour les principaux volets. Une conversation supplémentaire de sept échanges et le document de transmission ont été récupérés pour les sauvegardes.

Les archives v0.5.0 et v0.6.0, des versions antérieures, des sources, tableaux, configurations et traces sont conservés. Toutes les anciennes vidéos, présentations HTML et pièces jointes n'ont pas été retrouvées. L'archive Controls v0.2 reste notamment manquante.

Ces liens relatifs fonctionnent dans le dossier de travail actuel. Ils devront être adaptés lors de la préparation du dépôt public.

| Document ou dossier | Utilité |
|---|---|
| [START_HERE.md](START_HERE.md) | Dernier point de reprise ; les mises à jour récentes sont en haut |
| [CONTINUITE.md](CONTINUITE.md) | Historique détaillé ; certains états sont dépassés |
| [Développement v0.6.1](development-v0.6.1/README.md) | Sources, compilation et limites |
| [Validation générale](development-v0.6.1/VALIDATION_SUMMARY.json) | Preuves de build et de tests liées au binaire |
| [Validation en mémoire](development-v0.6.1/LIVE_VALIDATION.json) | Contrôles après le redémarrage réel |
| [Prochaine étape du menu](development-v0.6.1/NEXT_MENU_STEP.md) | Repères techniques pour continuer |
| [Recherche sauvegardes](research-2026-09-16/saves/README.md) | Structure et stockage encore à définir |
| [Recherche menus](research-2026-09-16/menus/RAPPORT.md) | Structures et fonctions natives |
| [Recherche rendu](research-2026-09-16/render/README.md) | Bloom et distance d'affichage |
| [Recherche portages](research-2026-09-16/ports/README.md) | Faisabilité et données nécessaires |
| `history/`, `archives/`, `supplemental-files/` | Discussions, paquets et documents récupérés |
| `connection/`, `sessions/` | Journaux et copies de sécurité |

Les rapports du 16 septembre peuvent encore qualifier certains correctifs de « non appliqués ». Les sections Metalis et validation du présent document prennent en compte les essais et l'intégration réalisés ensuite.

Cette synthèse couvre tous les volets retrouvés et discutés, mais ne remplace pas une archive exhaustive de chaque instruction, expérience ou pièce jointe manquante.

## 15. Petit lexique

| Terme | Explication simple |
|---|---|
| FPS | Nombre d'images affichées par seconde |
| Vanilla | Jeu sans les modifications étudiées |
| Plugin / PRX | Programme additionnel chargé dans l'environnement PSP |
| Module | Partie du programme chargée pour un niveau ou un mode |
| Wrapper | Routine intermédiaire étudiée par le projet |
| Famille WF | Groupe de points d'appel classés dans la cartographie |
| Dispatcher | Partie du plugin choisissant le chemin à utiliser |
| Hook / redirection | Modification faisant passer un appel par le plugin |
| Delta time | Temps utilisé pour calculer une mise à jour |
| Cooldown | Délai avant de réutiliser une action |
| Knockback | Recul provoqué par un impact |
| Nanotech | Élément permettant de récupérer de la vie |
| Bloom | Halo lumineux ajouté à l'image |
| Draw distance | Distance à laquelle un élément est affiché |
| Relocalisation | Adaptation aux adresses réellement utilisées après chargement |
| JIT | Mécanisme de l'émulateur accélérant l'exécution du programme |
| Savestate | Copie de l'état complet de l'émulateur à un instant donné |
| Sauvegarde normale | Progression enregistrée par le système du jeu |
| Empreinte SHA-256 | Identifiant calculé pour vérifier l'identité exacte d'un fichier |
| straddle.junk | Fichier de programme avec des noms de fonctions utiles à l'analyse, malgré son extension |

**Critère de réussite : un jeu plus fluide, dont le rythme et les règles restent fidèles, avec des modifications compréhensibles, vérifiables et documentées.**


## Mise à jour — 17 septembre, prototype du menu

Un premier menu Overcompensated est maintenant accessible au menu principal : l’ouverture est confirmée par l’utilisateur. Les commandes 30/60 sont reçues par le plugin. La présentation reste à faire : l’entrée est mal placée, et de vraies cases dans le style du jeu sont demandées. Les accès pause générale et pause de mini-jeu sont codés, mais restent à vérifier en jeu. Le choix est toujours différé au rechargement. Une correction de son enregistrement est compilée dans la version suivante, pas encore installée ni validée en jeu. Le détail de reprise est conservé dans [REPRISE_MENU.md](development-v0.6.2-menu/REPRISE_MENU.md).

