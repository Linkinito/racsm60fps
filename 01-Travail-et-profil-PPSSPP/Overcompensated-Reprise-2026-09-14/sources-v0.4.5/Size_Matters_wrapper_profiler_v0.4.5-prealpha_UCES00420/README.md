# Size Matters — wrapper profiler v0.4.5-prealpha (UCES00420)

Ce paquet contient un PRX utilisateur compilé pour PPSSPP. Il ne constitue pas encore un patch 60 FPS : il reconnaît le PRX de niveau actif, observe les appels au wrapper deux-passes sans changer son résultat et exporte les mesures nécessaires au futur dispatcher.

## État au 25 août 2026

- 15 modules, 493 callsites et 59 familles cartographiés ;
- résolution dynamique de `rcp1`, testée in situ jusqu’à un déplacement de `+0x8000` ;
- trampoline Allegrex, installation transactionnelle, rollback, retrait conditionnel et synchronisation des caches ;
- palier 02 Pokitaru validé : 55/55 callsites, 34 actifs, 496 697 hits connus et zéro `$ra` inconnu ;
- palier 03 Ryllus validé : 57/57 callsites, 38 actifs, 122 243 hits connus et zéro `$ra` inconnu ;
- section Clank couverte : six familles candidates totalisent 55 765 hits ;
- rythme vanilla mesuré : 98,724 % des transitions entre VBlank actifs utilisent un écart de deux VBlank ;
- transition Ryllus → Kalidon réussie : LEVEL_03 reconnu avec 33 entrées, sans écriture grâce à `allowed_module=2` ;
- traces JSON v4 avec activité par VBlank, multiplicité intra-VBlank et histogramme des écarts ;
- PRX v0.4.5 compilé et validé par 802 contrôles binaires ;
- empreinte estimée : 35 076 octets chargés + 18 432 octets de piles, soit environ 53 508 octets ;
- **prochaine frontière : palier 04, les 33 callsites de Kalidon**.

Les bilans détaillés se trouvent dans [POKITARU_STAGE02_RESULT.md](POKITARU_STAGE02_RESULT.md) et [RYLLUS_STAGE03_RESULT.md](RYLLUS_STAGE03_RESULT.md). Ouvrir [index.html](index.html) pour le rapport vulgarisé et [TEST_PROTOCOL_PPSSPP_1.19.3_WINDOWS11.md](TEST_PROTOCOL_PPSSPP_1.19.3_WINDOWS11.md) pour la prochaine session.

## Prochain essai

1. Fermer complètement PPSSPP et supprimer l’ancien dossier du plugin.
2. Installer uniquement `install/04_FULL_KALIDON` ou son archive prête à extraire.
3. Charger une sauvegarde interne sur Kalidon, parcourir le niveau et interagir avec plateformes, portes, ennemis, armes et éléments mobiles.
4. Exporter avec `L + R + SELECT` pendant que Ratchet est encore contrôlable ; si possible, effectuer ensuite la transition vers le niveau suivant.
5. Fournir `status.log` et toutes les traces `trace_L03_*.json` produites.

Les sources et preuves de compilation se trouvent dans `profiler/`. Aucun EBOOT, PRX de niveau ou autre binaire du jeu n’est inclus ; `patch.prx` est uniquement le module original produit pour cette expérimentation.
