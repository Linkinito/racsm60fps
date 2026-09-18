# Rendu : bloom et distance d'affichage — 16 septembre 2026

## Résultat exploitable

Le bloom géométrique a une piste précise côté émulation, indépendante du correctif 60 FPS : PPSSPP désactive explicitement sa réduction de résolution des effets pour UCES00420. Un simple passage du réglage à Safe/Balanced/Aggressive peut donc ne rien changer. Aucune modification de réglage, compat.ini, mémoire ou jeu réalisée pendant cette analyse. Aucun résultat visuel validé.

## Bloom : preuves

Réglages disque PSP/SYSTEM/ppsspp.ini lus : Direct3D11, InternalResolution=10, BloomHack=0, SkipBufferEffects=False, SkipGPUReadbackMode=0, ReplaceTextures=True, TexScalingLevel=5, TexDeposterize=True. Aucun fichier UCES00420 spécifique trouvé dans PSP/SYSTEM. Ces lectures ne prouvent pas l'état en mémoire d'une session ouverte. Les valeurs ColorCorrection/Sharpen stockées en fin de fichier ne suffisent pas à prouver qu'un shader est actif.

Le fichier installé C:/Program Files/PPSSPP/assets/compat.ini, section [ForceLowerResolutionForEffectsOff], lignes1519–1529, contient UCES00420=true et le commentaire « Ratchet & Clank looks terrible ». Le même jeu possède séparément une correction DeswizzleDepth (effets de fumée), lignes1400–1409. Ce sont deux mécanismes distincts.

Source PPSSPP v1.19.3 FramebufferManagerCommon.cpp, UpdateRenderSize lignes86–101 : le drapeau ForceLowerResolutionForEffectsOff impose effectiveBloomHack=0, quelle que soit la valeur choisie par l'utilisateur. ResizeFramebufFBO lignes1810–1820 : les niveaux habituels forcent1x selon dimensions : Safe largeur<=128 ou hauteur<=64; Balanced largeur<=256 ou hauteur<=128; Aggressive largeur<480 ou largeur>800 ou hauteur<272. Cette sélection approximative explique pourquoi elle peut aussi détériorer d'autres effets. Les fichiers sources exacts consultés sont archivés dans ce dossier.

Le mécanisme documenté par PPSSPP est cohérent avec le symptôme : un bloom PSP résulte de réductions successives de l'image; à haute résolution, le nombre fixe de passes laisse trop de détails dans l'image lumineuse additionnée à la scène. C'est une hypothèse forte pour l'aspect géométrique signalé, pas une identification visuelle de cette scène. [Documentation officielle](https://www.ppsspp.org/docs/troubleshooting/the-bloom-problem/).

Un rapport directement pertinent existe : [issue19370](https://github.com/hrydgard/ppsspp/issues/19370), ouvert le26juillet2024, signale Size Matters UCUS98633, Secret Agent Clank et Lost Frontier avec éclairage pixelisé aux résolutions élevées sous1.17.1/Vulkan. C'est un témoignage de bug, pas une preuve que tous les backends/version1.19.3 sont identiques, ni un correctif validé.

Sources versionnées : [FramebufferManagerCommon.cpp](https://github.com/hrydgard/ppsspp/blob/v1.19.3/GPU/Common/FramebufferManagerCommon.cpp#L86), [options interface](https://github.com/hrydgard/ppsspp/blob/v1.19.3/UI/GameSettingsScreen.cpp#L600), [compat.ini](https://github.com/hrydgard/ppsspp/blob/v1.19.3/assets/compat.ini).

## Prochain test bloom, au retour utilisateur

1. Conserver une vue fixe avec bloom manifeste; comparer1x puis4x, même scène, même backend, même patch60 et même éclairage. Captures PNG non recompressées.
2. Comparer avec textures remplacées/scaling désactivés dans une configuration de test sauvegardée séparément; ne changer qu'un facteur à la fois. Cela isole bloom de netteté des textures.
3. Ne pas promettre de résultat au simple réglage BloomHack : exception de compatibilité ci-dessus. Ne pas activer Skip buffer effects comme correction finale, car cela supprime des passes nécessaires.
4. Si1x supprime bien le défaut, prendre une capture GE de cette image avec le débogueur GPU. Examiner successivement framebuffer scène, cibles réduites du bloom, reconstruction additive : dimensions PSP, dimensions hôte, filtrage, scissor, offsets texels. Chercher la première passe où apparaît la forme géométrique.
5. Un essai de levée de l'exception ne serait pertinent que dans une installation/configuration isolée et avec captures comparatives de fumée, transparence, pause, HUD et cinématiques. Pas de modification faite ici : le commentaire de compat prévient d'une régression connue.
6. La solution robuste potentielle est une détection spécifique des cibles bloom, ou une adaptation du nombre/des dimensions des passes du jeu. Le shader final plein écran ne peut pas retrouver proprement une séparation bloom/scène déjà fusionnée.

## Draw distance : ce qui est réellement identifié

straddle.junk est un ELF32 MIPS avec symboles, pas un document texte. Extraction locale enregistrée dans render-symbols.json / render-symbols-expanded.json. Les valeurs des symboles sont relatives à leur section : NE PAS les utiliser comme adresses PPSSPP ou RVA LEVEL_04 sans relocalisation/cartographie.

| Symbole | Valeur section1 .text | Taille |
|---|---:|---:|
| CAMERA_CommitToDisplay | 0x0000 |104|
| DISPLAY_SetupProjection |0x33D0|32|
| MakePerspectiveProjectionFromProj |0x3560|124|
| MakePerspectiveProjection |0x35DC|152|
| DISPLAY_SetVisibilityPlanes |0x33F0|36|
| DISPLAY_BuildFrustumPlanes |0x3674|2240|

Désassemblage sauvegardé projection-disassembly.txt et projection-builder.txt. CommitToDisplay appelle successivement vue, projection, commit, construction des plans et choix des plans de visibilité. La projection reçoit quatre flottants f12–f15; le constructeur transforme les deux premiers via une fonction trigonométrique et transmet les deux derniers au constructeur matriciel. Cela fournit une entrée concrète pour identifier les plans proche/lointain, mais leur valeur et leur effet sur les objets disparus ne sont pas encore capturés.

Globales nommées g_clipMat, g_WorldClipPlanes et g_pCurrentClipPlanes repérées. Aucun symbole explicitement nommé draw distance/LOD n'a été trouvé par le filtre utilisé; cela ne prouve pas l'absence de mécanisme dans les modules de niveaux.

Un plan lointain plus éloigné ne suffit pas si le jeu omet déjà un objet, choisit un LOD ou charge une zone seulement à proximité. De même, le réglage émulateur DisableRangeCulling n'est pas une preuve de contrôle sur la sélection CPU des objets du jeu. Aucun multiplicateur global applicable identifié à ce stade.

## Protocole draw distance ciblé

- Choisir un objet précis qui apparaît trop tard et noter lieu, orientation et position caméra. Faire aller/retour lent au seuil d'apparition, sans changer FOV ni hauteur.
- Distinguer coupure d'une partie géométrique par plan, disparition d'objet entier, changement de modèle, apparition d'une zone, ou effet lumineux uniquement.
- Cartographier la fonction de projection straddle vers son instance chargée puis lire ses quatre paramètres. Modifier temporairement uniquement le paramètre lointain confirmé, sous garde et avec valeur originale sauvegardée; comparer au même emplacement.
- Si l'objet n'est toujours pas soumis au GPU, capturer le chemin de visibilité de sa classe dans le module concerné, ses bornes et un éventuel seuil de distance au carré. Tester un seul objet/type avant généralisation.
- Mesurer temps CPU/GPU, compte d'objets/primitives, stabilité et précision profondeur. Une augmentation du plan lointain peut dégrader la précision de profondeur; elle ne charge pas automatiquement les données absentes.

## Limites et fichiers utiles

Aucune image de bloom actuelle ni capture GE n'a été obtenue; aucun objet de draw distance nommé par l'utilisateur. Les symboles permettent de préparer des points d'observation, pas de certifier un patch. Les fichiers utiles pour la prochaine étape sont une capture GE1x/4x de la même scène et le nom/emplacement d'un élément dont l'apparition est trop proche. Il n'est pas nécessaire de reprendre l'audit60 FPS à zéro.
