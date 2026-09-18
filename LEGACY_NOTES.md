# Legacy preservation notes

## Duplicate PRX reference set

The following directories were compared before the initial Git snapshot:

- `development-v0.6.1/verified-prx-inputs/`
- `development-v0.6.3-generalisation/prx-reference/`

The following PRX files were SHA-256 identical between both directories:

- LEVEL_01.PRX
- LEVEL_02.PRX
- LEVEL_03.PRX
- LEVEL_04.PRX
- LEVEL_05.PRX
- LEVEL_06.PRX
- LEVEL_07.PRX
- LEVEL_08.PRX
- LEVEL_09.PRX
- LEVEL_10.PRX
- LEVEL_15.PRX
- LEVEL_21.PRX
- LEVEL_22.PRX
- LEVEL_23.PRX
- LEVEL_24.PRX

The v0.6.1 copies are therefore excluded from Git to avoid storing
duplicate binary data. The v0.6.3 `prx-reference` copies are retained
as the canonical legacy reference set.

The original local files have not been deleted.