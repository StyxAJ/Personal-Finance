# Notes index

Every note in the repo, one line each.

| Note | What's in it |
|---|---|
| [notes/sql.md](sql.md) | SQL syntax from SQLBolt and the PostgreSQL docs: SELECT, WHERE, JOINs, aggregates, subqueries, CTEs, window functions, dates, constraints |
| [notes/excel.md](excel.md) | Excel from W5–W6: Power Query import, Tables, cleaning, XLOOKUP, SUMIFS, PivotTables, gotchas, Excel ↔ SQL |
| [notes/python-vocab.md](python-vocab.md) | English → Python lookup tables for DSA: classes, lists, loops, two pointers, sets/dicts, stacks, linked lists, errors |
| [notes/python-data.md](python-data.md) | The `datetime`, `random` and `csv` modules used by the data generator |
| [notes/linux.md](linux.md) | The Linux command line (TLCL): navigation, files, redirection and pipes, permissions, processes, find, grep and regex, text processing on CSVs, bash scripting, gotchas, Linux ↔ SQL ↔ Excel |
| [theory/dbms-01-basics.md](../theory/dbms-01-basics.md) | What an RDBMS is; tables, rows, columns; cluster → database → table |
| [theory/dbms-02-keys.md](../theory/dbms-02-keys.md) | Superkey, candidate key, primary key, foreign key, referential integrity |
| [theory/dbms-03-normalisation.md](../theory/dbms-03-normalisation.md) | Anomalies, 1NF/2NF/3NF, and a check of this project's schema |
| [theory/dbms-04-acid.md](../theory/dbms-04-acid.md) | Transactions and the four ACID guarantees |
| theory/dbms-05-indexes.md | missing, rewrite during the W11 DBMS review |
| [theory/oop-01-classes.md](../theory/oop-01-classes.md) | Classes, objects, `__init__` and `self`, with the `Transaction` class |
| [theory/oop-02-encapsulation.md](../theory/oop-02-encapsulation.md) | Encapsulation: `_amount`, name mangling, `@property` + setter so `Transaction` rejects a bad amount |
| [theory/oop-03-inheritance-polymorphism.md](../theory/oop-03-inheritance-polymorphism.md) | The 4 pillars with `Account` → `SavingsAccount` / `CurrentAccount`: inheritance, polymorphic `withdraw()`, abstraction |
| [theory/os-03-memory.md](../theory/os-03-memory.md) | Address spaces, virtual vs physical addresses, pages and page tables |
| [theory/os-04-concurrency.md](../theory/os-04-concurrency.md) | Race conditions, critical sections and locks, deadlock and lock ordering, with `race.py` / `deadlock.py`, and why Postgres doesn't race |
| [theory/api-keys.md](../theory/api-keys.md) | What an API key is, where it goes, and how to keep it out of git |
| [dsa/patterns.md](../dsa/patterns.md) | Every LeetCode problem, grouped by pattern: "when I see ___ → I do ___" |
| [notes/fastapi.md](fastapi.md) | FastAPI from the freeCodeCamp beginner course: routes, path/query params, Pydantic bodies, HTTPException, psycopg in a route, env vars, gotchas |
| [notes/big-o.md](big-o.md) | Big-O notation with examples of constant, linear and quadratic code |
| [sql/project/indexes.md](../sql/project/indexes.md) | The 200k-row index benchmark (query plans and timings) |
| [log.md](../log.md) | Daily study log, grouped by week |

## Where do I look for…?

- **SQL syntax** → [notes/sql.md](sql.md) (start with its Quick lookup table)
- **How to do something in Excel** → [notes/excel.md](excel.md) (start with its Quick lookup table)
- **Python syntax** → [notes/python-vocab.md](python-vocab.md)
- **A terminal / bash command** → [notes/linux.md](linux.md) (start with its Quick lookup table)
- **FastAPI / building the API** → [notes/fastapi.md](fastapi.md) (start with its Quick lookup table)
- **A DSA pattern** → [dsa/patterns.md](../dsa/patterns.md)
- **Theory** (DBMS, OOP, API keys) → [theory/](../theory/)
- **What I did on a day** → [log.md](../log.md)
