# DUPLICATE / FINGERPRINT AGENT PROMPT

Find equivalent implementations across PRX/module files.

Use normalized binary/disassembly evidence.

Create:

`implementation_groups.csv`

For each group record:

- group ID;
- canonical semantic name;
- module instances;
- addresses;
- binary/signature evidence;
- confidence;
- known differences.

Do not remove any per-module inventory entries.

If two functions are almost identical but differ in timing constants or calls, they must not be merged as fully equivalent.

Report near-duplicates separately.
