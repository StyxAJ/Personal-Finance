# Personal Finance Analytics

A personal finance database built from scratch: a PostgreSQL schema that protects its own data, a Python generator for realistic (and deliberately messy) transactions, SQL reports, and an Excel analysis that matches the database to the fils.

It's built as a **foundation**: the same schema and reports work for anyone's own bank data, and later stages add an API, containers and Kubernetes on top of the same project.

Sample data: one year of transactions (Oct 2025 – Sep 2026), amounts in AED.

## Highlights
- **25x faster query with one index:** on 200,000 rows, a composite index on `(category_id, txn_date)` took a category + date-range query from **30.4 ms (Parallel Seq Scan) to 1.2 ms (Bitmap Index Scan)**. Write-up: `sql/project/indexes.md`
- **The database rejects bad data on its own:** `CHECK (amount > 0)`, unique category names, foreign keys, and a `budgets` table with one budget per category per month.
- **Two tools, one answer:** 618 messy rows cleaned in Excel down to 600, and the totals match PostgreSQL exactly (**600 rows, 385,323.67 AED**).
- **Real reporting questions:** net savings per month, loss months, top 2 spending categories per month (window functions), categories over budget.

## Tech
PostgreSQL 18 · Python 3 (`csv`, `random`, `datetime`) · Excel (Power Query, XLOOKUP, SUMIFS, PivotTables) · VS Code · Git/GitHub

## Data model
| Table | Holds | Key rules |
|---|---|---|
| `categories` | id, name, type (`income` / `expense`) | name is unique |
| `accounts` | id, name (e.g. Main Checking, Credit Card) | |
| `transactions` | id, account_id, category_id, amount, txn_date, description | amount > 0; account and category must exist (foreign keys) |
| `budgets` | id, category_id, month, limit_amount | limit > 0; one row per (category, month) |

Amounts are always positive. Whether money comes in or goes out is decided by the category's `type`, so a transaction can never have the "wrong sign".

## Project structure
| Folder / file | What's in it |
|---|---|
| `sql/project/schema.sql` | Tables: `categories`, `accounts`, `transactions` |
| `sql/project/schema_v2.sql` | Constraints + the `budgets` table |
| `sql/project/seed.sql` | The 10 categories and 2 accounts |
| `sql/project/budgets.sql` | Monthly budgets (September 2026) |
| `sql/project/monthly_totals.sql` | Income, expense and net savings per month |
| `sql/project/joins.sql` · `subqueries.sql` | Spend per account and category; transactions above their category's average |
| `sql/project/indexes.md` | The 200k-row index benchmark (plans and timings) |
| `sql/practice/` | Daily query practice (`w2_`, `w3_`, `w4_`, …), incl. the first 20 hand-typed transactions |
| `data/generate_data.py` | Generates `clean.csv` (600 rows) and a deliberately messy `raw.csv` |
| `data/make_big.py` | Generates `big.csv` (200,000 rows, not committed) for the index benchmark |
| `excel/finance_analysis.xlsx` | Cleaning, lookups, SUMIFS analysis and PivotTables |
| `dsa/` | LeetCode solutions by week, plus `patterns.md` |
| `theory/` | Notes on DBMS, OOP and API keys |

## How to run
```
psql -d finance -f sql/project/schema.sql
psql -d finance -f sql/project/schema_v2.sql
psql -d finance -f sql/project/seed.sql
psql -d finance -f sql/project/budgets.sql
python data/generate_data.py
psql -d finance
\copy transactions(account_id, category_id, amount, txn_date, description) FROM 'data/clean.csv' CSV HEADER
```
Check: `SELECT count(*), sum(amount) FROM transactions;` returns **600 | 385323.67**.

For the index benchmark: `python data/make_big.py`, then follow `sql/project/indexes.md`.

## Use it for your own finances
1. Create the database and run the two schema files.
2. Edit `seed.sql` with your own categories (each marked `income` or `expense`) and accounts.
3. Export your bank statement as CSV and shape it into five columns: `account_id, category_id, amount, txn_date, description`. Amounts positive, dates as `YYYY-MM-DD`. If the export is messy, the Excel cleaning steps in `finance_analysis.xlsx` show how to fix it.
4. Load it with the `\copy` line above.
5. Replace the rows in `budgets.sql` with your own monthly limits, then run the reports in `sql/project/`.

## Roadmap
- [x] SQL: schema, constraints, reports, window functions, index benchmark
- [x] Excel: cleaning, lookups, SUMIFS, PivotTables
- [ ] Excel dashboard that refreshes from new data
- [ ] REST API over the database (FastAPI) with tests
- [ ] Docker and Docker Compose (API + database)
- [ ] Kubernetes deployment

## Progress log

### Week 1: SQL basics
- SQLBolt lessons 1–18 (SELECT, JOINs, aggregates, INSERT/UPDATE/DELETE, CREATE TABLE).
- Designed the schema and seeded it by hand.
- DSA: Big-O basics, Python list costs, LC 1480, LC 1929.
- Theory: what a DBMS is; primary, candidate and foreign keys.

### Week 2: SQL on my own data
- Python data generator: 600 realistic transactions plus a messy `raw.csv` for cleaning practice.
- Loaded with `\copy` and verified the totals match the file exactly.
- WHERE (AND/OR, IN, BETWEEN, LIKE), ORDER BY, LIMIT, DISTINCT, CASE, aggregates, GROUP BY/HAVING, date functions.
- Monthly net-savings report: 10 of 12 months saved money; November 2025 had the highest spending.
- DSA: two pointers (LC 344, 125, 26, 977, 167).
- Theory: normalisation (anomalies, 1NF–3NF); this schema is in 3NF.

### Week 3: JOINs, subqueries, CTEs
- INNER and LEFT JOINs with aliases; COUNT(t.id), filtering in ON, COALESCE for zeros.
- Subqueries: scalar, IN, EXISTS / NOT EXISTS, correlated (transactions above their own category's average).
- CTEs for multi-step questions, e.g. income vs expense per month.
- `joins.sql` includes a proof query: per-account totals add up to 183,769.18 AED.
- Tested every change inside BEGIN … ROLLBACK.
- DSA: hash sets and hash maps (LC 217, 1, 383, 242).
- Theory: ACID and transactions.

### Week 4: Constraints, indexes, window functions
- `schema_v2.sql`: named constraints (positive amounts, unique category names) and a `budgets` table. Six bad inserts tested, each rejected by the expected rule.
- Safe change routine: SELECT the WHERE first → BEGIN → change with RETURNING * → check → COMMIT or ROLLBACK.
- Index benchmark on 200,000 generated rows: 30.4 ms → 1.2 ms (~25x) with a composite index; equality column first, range column second.
- Window functions: top 2 spending categories per month with ROW_NUMBER, RANK and DENSE_RANK, filtered in an outer query.
- DSA: sliding window (LC 121, 643) and prefix sums (LC 724).
- Theory: indexes and B-trees.

### Week 5: Excel cleaning and lookups
- Imported the messy `raw.csv` with Power Query (type detection off, so the mess stays visible).
- Cleaning: 103 category spellings → 10 (TRIM, PROPER), 18 duplicate rows removed, 44 "AED 45.50"-style text amounts and 22 DD/MM dates converted, 17 blank categories → "Uncategorised". Found that DATEVALUE would have silently put 13 of the 22 dates in the wrong month on a US-format PC.
- XLOOKUP (Excel's JOIN) for category type and account name, with a "Not found" fallback.
- SUMIFS and COUNTIFS: totals match SQL (600 rows, 385,323.67 AED).
- DSA: stacks (own Stack class, LC 20, LC 155).
- Theory: OOP classes, objects and properties (`Transaction` rejects an amount of 0).
