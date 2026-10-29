-- Warm-ups

--Every everyday expense (categories 5–10), with its category's average amount next to it

-- ❌ errors: OVER attaches to ROUND, which isn't an aggregate or window function
-- SELECT *, ROUND(AVG(amount), 2) OVER (PARTITION BY category_id) FROM transactions;

-- ✅ OVER goes straight after AVG, ROUND wraps the whole window result
-- every row stays (unlike GROUP BY), each one gets the average of its own category
SELECT *, ROUND(AVG(amount) OVER (PARTITION BY category_id), 2) AS cat_avg
FROM transactions
WHERE category_id BETWEEN 5 AND 10;

--Add a column counting how many rows share the same category and the same month
--Check: every Transport row in July 2026 shows 11

-- ✅ 2 expressions in PARTITION BY, so each category + month pair is its own partition
-- date_trunc keeps the year (EXTRACT(month) would merge July 2025 and July 2026)
-- no ORDER BY in OVER, so count(*) sees the whole partition, not a running count
SELECT *,
    count(*) OVER (PARTITION BY category_id, date_trunc('month', txn_date)) AS same_cat_month
FROM transactions
WHERE category_id BETWEEN 5 AND 10;


--block 2

WITH monthly_spend AS (
    SELECT date_trunc('month', t.txn_date) :: DATE AS month,
           c.name,
           sum(t.amount) AS total
    FROM transactions t
    JOIN categories c ON t.category_id = c.id
    WHERE t.category_id BETWEEN 5 AND 10 
    GROUP BY date_trunc('month', t.txn_date), c.name
), ranked AS (
    SELECT month, name, total,
       ROW_NUMBER() OVER (PARTITION BY month ORDER BY total DESC) AS rn,
       RANK()       OVER (PARTITION BY month ORDER BY total DESC) AS rnk,
       DENSE_RANK() OVER (PARTITION BY month ORDER BY total DESC) AS drnk
    FROM monthly_spend
)
SELECT month, name, total, rn, rnk, drnk 
FROM ranked 
WHERE rn <= 2
ORDER BY month,rn;

-- Ties: Utilities 3000, Healthcare 3000, Groceries 2000
-- ROW_NUMBER: 1, 1, 1
-- RANK:       1, 1, 1
-- DENSE_RANK: 1, 1, 1
-- So for "top 2 per month" I'd use ___ because ___

WITH t(name, total) AS (
    VALUES ('Utilities', 3000), ('Healthcare', 3000), ('Groceries', 2000)
)
SELECT name, total,
       ROW_NUMBER() OVER (ORDER BY total DESC) AS rn,
       RANK()       OVER (ORDER BY total DESC) AS rnk,
       DENSE_RANK() OVER (ORDER BY total DESC) AS drnk
FROM t;
