--#	Question	Check
--1.	Months where spend (categories 4–10) was over 15,000	7 months

-- ❌ errors: category_id isn't grouped, so HAVING can't see it (and it's a row condition anyway)
-- SELECT date_trunc('month', txn_date)::date AS month, sum(amount) FROM transactions
-- GROUP BY month HAVING category_id BETWEEN 4 AND 10 AND sum(amount) > 15000;

-- ✅ WHERE drops the income rows first, HAVING then filters the monthly totals
SELECT date_trunc('month', txn_date)::date AS month,
       sum(amount) AS total_expense
FROM transactions
WHERE category_id BETWEEN 4 AND 10
GROUP BY month
HAVING sum(amount) > 15000
ORDER BY total_expense;

--2.	Months where net savings were over 3,000	3 months: 2025-10, 2025-12, 2026-01

-- ❌ errors in Postgres: the alias net_savings isn't known yet in HAVING
-- SELECT date_trunc('month', txn_date)::date AS month, SUM(CASE … END) AS net_savings
-- FROM transactions GROUP BY month HAVING net_savings > 3000;

-- ✅ no WHERE, since income and expenses are both needed, and the SUM(CASE …) is repeated in HAVING
SELECT date_trunc('month', txn_date)::date AS month,
       SUM(CASE
             WHEN category_id BETWEEN 1 AND 3  THEN amount
             WHEN category_id BETWEEN 4 AND 10 THEN -amount
             ELSE 0
           END) AS net_savings
FROM transactions
GROUP BY month
HAVING SUM(CASE
             WHEN category_id BETWEEN 1 AND 3  THEN amount
             WHEN category_id BETWEEN 4 AND 10 THEN -amount
             ELSE 0
           END) > 3000
ORDER BY month;

--3. Everyday categories (5–10) whose largest single transaction was over 650	1 row: category 6

-- ❌ errors: amount isn't grouped, HAVING can only see group columns and aggregates
-- SELECT category_id, max(amount) FROM transactions WHERE category_id BETWEEN 5 AND 10
-- GROUP BY category_id HAVING amount > 650;

-- ✅ max() per category, then HAVING keeps the ones over 650
SELECT category_id, max(amount) AS max_amount
FROM transactions
WHERE category_id BETWEEN 5 AND 10
GROUP BY category_id
HAVING max(amount) > 650;


--4.	Accounts with more than 300 transactions	1 row: account 1 (318)

-- ❌ errors: WHERE runs before grouping, so COUNT(*) doesn't exist yet
-- SELECT account_id, COUNT(*) FROM transactions WHERE COUNT(*) > 300 GROUP BY account_id;

-- ✅ count per account, HAVING keeps the ones over 300
SELECT account_id,
       COUNT(*)              AS txn_count
FROM transactions
GROUP BY account_id
HAVING COUNT(*) > 300
ORDER BY account_id;

--5.	Self-test Q3 again, from a blank line: months where expenses beat income	2 rows: 2025-11, 2026-04

-- ❌ WHERE can't hold an aggregate, and the month's total isn't known until after grouping
-- SELECT date_trunc('month', txn_date)::date AS month FROM transactions
-- WHERE SUM(CASE … END) < 0 GROUP BY month;

-- ✅ net savings below 0 = expenses beat income
SELECT date_trunc('month', txn_date)::date AS month,
       SUM(CASE
             WHEN category_id BETWEEN 1 AND 3  THEN amount
             WHEN category_id BETWEEN 4 AND 10 THEN -amount
             ELSE 0
           END) AS net_savings
FROM transactions
GROUP BY month
HAVING SUM(CASE
             WHEN category_id BETWEEN 1 AND 3  THEN amount
             WHEN category_id BETWEEN 4 AND 10 THEN -amount
             ELSE 0
           END) < 0
ORDER BY month;
