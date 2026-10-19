# Personal Finance Analytics

A personal finance database built from scratch to learn SQL, Python and data skills.
PostgreSQL schema, a Python data generator, and SQL reports on one year of transactions
(Oct 2025 – Sep 2026, amounts in AED).

Part of my Winter Arc study plan (Oct – Dec 2026).

## Tech
PostgreSQL 18 · Python 3 (csv, random, datetime) · VS Code

## Project structure
| Folder / file | What's in it |
|---|---|
| `sql/project/schema.sql` | Tables: `categories`, `accounts`, `transactions` |
| `sql/project/seed.sql` | 10 categories and 2 accounts |
| `data/generate_data.py` | Generates `clean.csv` (600 rows) and a deliberately messy `raw.csv` |
| `sql/practice/` | Daily query practice (`w2_`, `w3_`, …) |
| `sql/project/monthly_totals.sql` | Net savings per month |
| `dsa/` | LeetCode solutions by week |
| `theory/` | DBMS notes |

## How to run

psql -d finance -f sql/project/schema.sql
psql -d finance -f sql/project/seed.sql
python data/generate_data.py
psql -d finance
\copy transactions(account_id, category_id, amount, txn_date, description) FROM ‘data/clean.csv’ CSV HEADER


## Progress

### Week 1: SQL basics
- Completed SQLBolt lessons 1–18 (SELECT, JOINs, aggregates, INSERT/UPDATE/DELETE, CREATE TABLE).
- Designed the schema and seeded it by hand (10 categories, 2 accounts, 20 transactions).
- DSA: Big-O basics, Python list costs, LC 1480, LC 1929.
- Theory: what a DBMS is; primary, candidate and foreign keys.
- Self-test: ___/5

### Week 2: SQL on my own data
- Built a Python data generator: 600 realistic transactions plus a messy `raw.csv` for cleaning practice in Week 5.
- Loaded the data with `\copy` and verified the totals match the file exactly.
- Queries: WHERE (AND/OR, IN, BETWEEN, LIKE), ORDER BY, LIMIT, DISTINCT, CASE, aggregates, GROUP BY/HAVING, date functions.
- Monthly net-savings report: 10 of 12 months were profitable; November 2025 had the highest spending.
- DSA: two pointers (LC 344, 125, 26, 977, 167).
- Theory: normalisation (anomalies, 1NF, 2NF, 3NF); checked that this schema is in 3NF.
- Self-test: 3/5
Sat 17 Oct: Week 2 complete (self-test 3/5). Starting Week 3 Day 1.
Data: 600 transactions loaded from data/clean.csv; raw.csv waiting for Week 5.
Pending fixes: Mon 10:00, first 25 min = HAVING on expressions (self-test under 4/5).
