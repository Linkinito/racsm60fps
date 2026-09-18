# Reproduction du build PSP v0.5.0

## Chaîne utilisée

- PSPDEV release `v20260301`, archive Linux x86-64 ;
- SHA-256 de l'archive : `93324d9aa8b2a86d26b80848cf692e16adfce5144a73406067fe3fe84fc76801` ;
- `psp-gcc (GCC) 15.2.0` ;
- firmware SDK ciblé : 6.60 ;
- options : `-O2 -G0 -std=c11 -Wall -Wextra -Werror -fno-strict-aliasing` ;
- sortie : PRX utilisateur relogeable, module `RCSMProfiler` version `0.5.0-prealpha`.

## Commandes

```sh
export PSPDEV=/chemin/vers/pspdev
export PATH="$PSPDEV/bin:$PATH"

make clean all
python3 tools/validate_prx.py \
  --pspdev "$PSPDEV" \
  --output PSP_BUILD_VALIDATION_v0.5.0.json
```

La validation finale attend `status: PASS` et 910 contrôles. Elle vérifie notamment les 30 stubs, les 30 tail-jumps, les deux destinations de chaque module, les gardes relocalisables, les 493 redirections, la configuration de politiques et le schéma de trace v5.

## Empreinte du build livré

| Élément | Valeur |
|---|---:|
| `patch.prx` | 46 862 octets |
| SHA-256 | `b95b256c101a1a11872ca910aed4f5de8ca22c5e6bba77727b607d1316476a14` |
| `.text` ELF | 34 972 octets |
| `.data` ELF | 660 octets |
| `.bss` ELF | 6 404 octets |
| charge ELF | 42 036 octets |
| piles déclarées | 18 432 octets |

Le plugin utilise `sceIo*`, n'alloue pas de mémoire dynamique et n'initialise pas Newlib. Le validateur désassemble le PRX produit ; une recompilation avec une chaîne différente peut donc avoir une autre empreinte tout en satisfaisant les mêmes propriétés fonctionnelles.
