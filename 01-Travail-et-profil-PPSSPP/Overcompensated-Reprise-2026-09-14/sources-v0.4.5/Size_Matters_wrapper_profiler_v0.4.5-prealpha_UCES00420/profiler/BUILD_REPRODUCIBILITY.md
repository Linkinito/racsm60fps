# Reproduction du build PSP

## Chaîne utilisée

- PSPDEV release `v20260301`, archive Linux x86-64 ;
- SHA-256 de l’archive utilisée : `93324d9aa8b2a86d26b80848cf692e16adfce5144a73406067fe3fe84fc76801` ;
- `psp-gcc (GCC) 15.2.0` ;
- firmware SDK ciblé : 6.60 ;
- options principales : `-O2 -G0 -std=c11 -Wall -Wextra -Werror -fno-strict-aliasing` ;
- sortie : PRX utilisateur relogeable, module `RCSMProfiler` version 0.4.5.

La release officielle est publiée sur <https://github.com/pspdev/pspdev/releases/tag/v20260301>. Sous Windows 11, WSL2 est la voie de reproduction la plus simple ; le PRX déjà compilé ne nécessite toutefois ni WSL ni PSPDEV pour être testé dans PPSSPP.

## Commandes

```sh
export PSPDEV=/chemin/vers/pspdev
export PATH="$PSPDEV/bin:$PATH"

make clean all
python3 tools/validate_prx.py \
  --pspdev "$PSPDEV" \
  --output PSP_BUILD_VALIDATION.json
```

La validation attend `status: PASS` et contrôle 802 invariants. Le rapport inclut l’empreinte SHA-256 exacte de `patch.prx`, ses sections, ses quinze symboles de hook et quinze symboles tail, les gardes relocalisables, le marqueur JIT borné, l’annonce du schéma temporel v4, les imports PSP du gestionnaire de modules et l’absence de `+0x6000` codé en dur.

## Pourquoi Newlib est désactivé

Le plugin écrit avec `sceIo*`, n’utilise ni `malloc` ni les flux `stdio`, et possède un formateur borné testé séparément. Initialiser Newlib ajouterait des pools de descripteurs et une large bibliothèque de formatage sans bénéfice fonctionnel. La désactivation maintient le chargement ELF à 35 076 octets dans ce build ; avec 18 432 octets de piles déclarées, l’estimation atteint 53 508 octets. Le thread principal reste créé par le CRT PSPSDK ; seules les routines d’initialisation/désinitialisation de Newlib sont neutralisées.

## Reproductibilité binaire

La source, le compilateur et les drapeaux sont figés, mais un SHA-256 identique n’est garanti que dans un environnement de linkage équivalent. La preuve principale n’est pas une promesse de build bit-à-bit : `validate_prx.py` désassemble chaque stub et vérifie les propriétés fonctionnelles du binaire produit.
