# Index lab: transactions_big (200,000 rows)

Query: category_id = 5 AND March 2026

```sql
EXPLAIN ANALYZE
SELECT *
FROM transactions_big
WHERE category_id = 5
  AND txn_date >= '2026-03-01'
  AND txn_date <  '2026-04-01';
```

| | Plan | Execution time |
|---|---|---|
| Before | Gather + Parallel Seq Scan | 30.421 ms |
| After (idx on category_id, txn_date) | Bitmap Heap Scan + Bitmap Index Scan on idx_tb_cat_date | 1.208 ms |

Speed-up: ~25x

Rows returned: 2,762 (estimate: 200,000 x 1/6 x 31/365 ≈ 2,830)

## Observations

- Before: every row was read and ~197,000 were thrown away (Rows Removed by Filter: 98,619 x 2 workers).
- After: the index found the 2,762 matching rows by reading only 4 index pages, then fetched them from 1,265 table blocks.
- Column order matters: `category_id` (equality) goes first and `txn_date` (range) second, so March for category 5 is one contiguous slice of the index.
- Timings are from the 3rd run of each query, so the data was already cached.
