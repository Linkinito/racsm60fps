# Portée des générateurs

`build_reference_corpus.py` et `build_wrapper_family_catalog.py` reconstruisent la couche d’analyse statique à partir des sources locales fournies : empreintes, adresses, familles, descripteurs, tables C initiales et rapport. Ils servent à régénérer le corpus dans un dossier de sortie vide, mais leurs gabarits historiques ne reproduisent pas le runtime v0.4.2 maintenu dans ce paquet.

La couche v0.4.2 — résolution dynamique de `rcp1`, trampoline, runtime PSP, configurations graduées, schéma de trace v3 et protocole — se trouve dans `profiler/` et se compile avec son propre `Makefile`. Son audit est reproduit avec `profiler/tools/validate_prx.py`. Le générateur exclut les mots relocalisés de l’empreinte et exporte la base de référence ; le runtime maintenu applique ensuite le delta de chargement observé.

Cette séparation est intentionnelle : le corpus est généré depuis des binaires du jeu disponibles localement, tandis que le paquet distribué reste libre de ces binaires et contient seulement les résultats analytiques ainsi que le PRX original du profiler.
