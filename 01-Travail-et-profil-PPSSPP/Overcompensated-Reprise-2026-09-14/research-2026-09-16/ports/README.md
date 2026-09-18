# Portages 60 FPS : faisabilité préliminaire

Aucun binaire Secret Agent Clank, Daxter ou Lost Frontier identifié dans l'inventaire ciblé des noms du dossier Downloads. Ce contrôle n'est pas une recherche exhaustive des disques. Aucun portage ni rapprochement binaire effectué.

Ce qui se réutilise déjà : connexion PPSSPP, capture des arguments et compteurs, désassemblage MIPS, empreintes et préflight, transactions mémoire/rollback, séparation déblocage affichage et compensation simulation, comparaisons de trajectoires/durées/dégâts. Le framework du plugin est une base adaptable; ses59 familles,493 sites, adresses, cave7, tables d'objets et compensations ne constituent pas une API portable.

Priorité de reconnaissance proposée : Secret Agent Clank, puis Lost Frontier, puis Daxter. C'est un ordre de travail provisoire, pas une compatibilité démontrée. Les deux premiers partagent au moins des symptômes graphiques documentés avec Size Matters dans [le rapport PPSSPP19370](https://github.com/hrydgard/ppsspp/issues/19370); cela ne prouve pas l'identité de leur boucle de simulation. Un [témoignage de tests60 FPS sur le forum PPSSPP](https://forums.ppsspp.org/showthread.php?page=40&tid=4799) rapporte un déblocage avec vitesse doublée pour les quatre titres; ancien témoignage, pas un audit actuel. Sa supposition de moteur commun ne doit pas devenir une preuve, notamment pour Daxter.

Pour chaque jeu, l'étape rentable est d'abord une reconnaissance hors ligne sur un dump légal local : ID/région/version/hash, inventaire EBOOT et PRX, présence de symboles/straddle ou autre ELF, chaînes et formats de données. Chercher ensuite correspondances de fonctions normalisées en masquant relocalisations J/JAL et adresses. Une correspondance doit être confirmée par appelants, structure des arguments et rôle observable; un simple motif 1/30 n'est pas suffisant.

Ensuite capturer le rythme original30Hz, déblocage60 séparé, appels par image, dt, timers entiers/flottants, physique et animations. Adapter le dispatcher seulement si ses hypothèses de wrapper/ABI sont retrouvées. Pour Clank : traiter chaque mini-jeu comme un mode distinct; pour Lost Frontier : distinguer à pied et vol; pour Daxter : établir une cartographie indépendante avant réutilisation des compensations.

Fichiers utiles au retour : pour UN titre pilote, version/région exacte, EBOOT/modules extraits avec hashes et éventuels symboles, sauvegarde native proche d'une scène reproductible. Une capture mémoire seule n'offre pas les contrôles d'identité et de relocalisation suffisants. Aucun besoin de fournir les trois jeux avant de stabiliser Metalis.

Conclusion de faisabilité : méthode et infrastructure réutilisables; transposition des correctifs eux-mêmes non établie. Aucun délai ou taux de réutilisation chiffré ne peut être justifié avec les fichiers disponibles.
