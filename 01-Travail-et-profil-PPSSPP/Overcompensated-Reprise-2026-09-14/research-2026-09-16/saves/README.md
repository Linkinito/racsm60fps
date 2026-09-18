# Sauvegardes Overcompensated — reprise vérifiée du 16 septembre 2026

La structure décrite dans la pièce jointe est reproductible avec les fichiers locaux. Une découverte change toutefois la décision de stockage : **la grande plage nulle 0x3E4EC–0x536DF ne doit pas être attribuée en bloc au mod**. Le jeu possède déjà un chemin d'écriture vers 0x534E0, qui se trouve dans cette plage. Aucun fichier de progression ni aucune mémoire du jeu n'a été modifié.

## Contexte retrouvé

Les sept échanges complets du chat « Coder nouveaux points de compétence » sont archivés dans chat-turn-0.json à chat-turn-6.json (ordre du plus récent au plus ancien ; pagination terminée, hasMore=false). La pièce jointe est extraite dans handoff-extracted.txt. Les premières réponses du chat qui proposent les bits 25–47 comme intervalle libre sont obsolètes : les échanges suivants décrivent des groupes par demi-octets, avec trous entre les groupes. Il ne faut donc pas utiliser un intervalle 25–47 comme réserve de flags.

Fichiers primaires retrouvés : Downloads/SECURE_CURRENT_DECRYPTED.bin et Downloads/Ratchet & Clank - Size Matters (Europe) (PSN)/RAM.dump. Le script inspect_saves.py reconstruit une copie de l'ancien buffer dans ram-save-c13c0.bin ; il n'écrit jamais dans les fichiers sources.

## Vérifications reproduites

Le payload clair actuel fait 356128 octets (0x56F20), SHA256 7e1ec222c550d93c48f7b97d1258c559c1cdc48d957c1fb176304288c2c72a58. Boulons à 0x1C28 : 20973 ; six octets de flags à 0x8F7 : 02 00 00 00 00 00. L'ancien buffer commence à l'offset fichier 0xC13C0 du RAM.dump (ne pas confondre cet offset avec une adresse live). Il contient 20522 boulons, SHA256 e4328a00df1ea7f453f612dc1b36e3a569c8d919f625380ec79929cdca992bfc.

Les 14 blocs RE00 commencent à 0x1C40+n*0x4000. Les blocs 4 à 13 sont identiques entre les deux états. Les blocs 0 à 3 diffèrent. Cela soutient l'hypothèse d'états par niveau, mais ne démontre pas le mapping de toutes les destinations. Le bloc 0 contient encore des données jusqu'à +0x19BE alors que son champ +8 vaut 0x20C : ce champ n'est pas une borne universelle permettant de récupérer l'espace après lui.

Les cinq fichiers SECURE.BIN locaux DATA0 à DATA4 ont chacun 356144 octets et des SHA256 distincts, consignés dans verified-format.json. Le payload clair fourni n'a pas été redéchiffré depuis le DATA0 live : son lien exact avec la toute dernière sauvegarde sur disque reste à vérifier avant toute édition.

## Nouvelles preuves dans LEVEL_01.PRX original

Les adresses ci-dessous sont des RVA du LEVEL_01 original, pas des adresses absolues utilisables sur Metalis. Les désassemblages ciblés sont joints.

- **RVA 0x21B14 / 0x21B38 :** lecture/écriture des flags confirmées à GameState+0x880+indice. Le pointeur GameState est chargé depuis le symbole relocalisé au RVA 0x2AF280. Cela confirme que les indices logiques 0x77–0x7C correspondent aux offsets 0x8F7–0x8FC.
- **RVA 0x218C0–0x218D0 :** construction de la longueur 0x56F20, avec a1=0 et pointeur GameState, puis appel 0x1ADA9C. Le contexte ressemble à une réinitialisation globale ; il faut confirmer le corps du callee avant de le nommer memset. Une extension persistante doit en tout cas prévoir le cycle nouvelle partie/réinitialisation, pas seulement sauvegarde/rechargement.
- **RVA 0x9804C–0x98124 :** initialisation explicite des 14 slots. Écrit les octets RE00, le champ 0x8000 et le champ 0x20C, puis 256 paires FF 00. Le stride de 0x4000 et la borne 14 sont dans le code. Le format vierge n'est donc plus uniquement déduit des saves.
- **RVA 0x97FB4–0x97FEC et 0x9817C–0x981BC :** la fonction 0x98B74 fournit un index ; décalage de 14 bits puis ajout GameState+0x1C40. Deux chemins passent ce slot à 0x1056A4 / 0x1056F4 avec un buffer et un argument 0x8000 sur le second. Cibles utiles pour décoder sérialisation/désérialisation ; les sens exacts et compression restent à confirmer.
- **RVA 0x6DD88–0x6DDD8 :** écriture d'un demi-octet à GameState+0x534E0+(index<<9)+(a0>>1). La parité de a0 choisit nibble bas/haut. La valeur est incrémentée si inférieure à 15 dans le contexte visible. Le symbole index est lu à RVA 0x2CC588. C'est une table de compteurs bornés à 4 bits, sémantique encore inconnue. **Sa base 0x534E0 tombe dans la prétendue réserve nulle.** Sans borner index/a0 et comprendre les appels, nous ne certifions pas quels octets exacts sont utilisés en jeu ; le simple fait d'être nul dans deux saves n'est plus un argument suffisant pour réserver cette zone.

Le hit immédiat 0x3030 à RVA0x96C78 est une vérification de version MIG 1.00, sans rapport avec RE00 ; désassemblage conservé pour éviter cette fausse piste.

## Architecture et prochaine expérience

Privilégier provisoirement un fichier annexe versionné du plugin pour les nouveaux points, ou attendre l'audit des champs avant toute insertion dans SECURE.BIN. Prévoir identité de slot, gestion nouvelle partie/copier/effacer/recharger, taille/version, contrôle d'intégrité et écriture atomique ; ne pas lier uniquement au nombre de boulons ou au hash intégral de la save, qui changent à chaque sauvegarde. Aucun emplacement interne n'est certifié libre aujourd'hui.

Pour poursuivre sans utilisateur : analyser 0x98B74 et les encodeurs 0x1056A4/0x1056F4 ; retrouver les appelants de 0x6DDxx et borner sa table ; auditer systématiquement les consommateurs des six octets Skill Points. Lors d'un test utilisateur ultérieur, une save après Dreamtime permettra de comparer le slot RE00 #4, mais le passage spécial Clank Géant impose de ne pas supposer que les slots suivent exactement les seules planètes du menu.

Pour un essai d'extension, il faudra une copie isolée et une sauvegarde native/recharge native. Un savestate seul ne valide pas la sérialisation PSP. Les vitesses 60 FPS expérimentales ne doivent pas changer les unités persistantes des nouveaux chronos : enregistrer une durée définie, indépendante du nombre d'updates, et gérer pause/défaite/rechargement.

Le déchiffrement mode 5 et la clé de la PJ restent des acquis historiques ; ils n'ont pas été réimplémentés ici. Aucun checksum de jeu supplémentaire n'a été identifié dans cette passe. Ne pas conclure qu'il n'en existe pas, ni modifier SECURE.BIN chiffré à des offsets de plaintext.
