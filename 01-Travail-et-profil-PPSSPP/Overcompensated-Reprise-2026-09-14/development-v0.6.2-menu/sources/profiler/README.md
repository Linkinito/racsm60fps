# Sources du plugin intégré v0.6.0

Le code de ce dossier produit le PRX global décrit dans le guide à la racine de l'archive. La configuration `RCSMProfiler.ini` livrée active le mode `global_60fps` ; en l'absence de configuration ou après un rejet de configuration, le runtime conserve le mode de détection sans correctif.

Les nouvelles fonctions portables sont dans `src/rcsm_full_patch.c`, avec leurs tests de transaction dans `tests/test_full_patch.c`. Les points d'intégration au runtime PSP sont dans `src/psp_plugin_runtime.c` ; `generated/full_patch.generated.c` reprend les mots vérifiés du manifeste historique et les convertit en descriptions relatives au module.

Lire `BUILD_REPRODUCIBILITY.md` pour recompiler et exécuter les contrôles. Les documents conservés dans `../provenance` décrivent les versions antérieures et n'annoncent pas le comportement de cette version globale.
