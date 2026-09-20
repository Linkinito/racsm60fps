# COVERAGE AGENT PROMPT

Perform final consistency audit.

Compare:

- original corpus;
- master inventory;
- object dossiers;
- timing mechanisms;
- implementation groups;
- patch candidates;
- manual test queue.

Find:

- missing original entries;
- UNEXAMINED entries;
- timing-relevant objects with no mechanisms;
- mechanisms with no A0/B0/B1/C1 model;
- mechanisms with no C1 verdict;
- incorrect/partial C1 mechanisms with no candidate and no unresolved explanation;
- orphan candidates;
- orphan mechanisms;
- duplicate IDs;
- dossiers not referenced by inventory;
- inventory paths with missing dossiers;
- implementation groups with inconsistent instances.

Do not declare completion unless:

`UNEXAMINED = 0`

and no silent structural omissions remain.

Update `coverage.md` with exact counts.
