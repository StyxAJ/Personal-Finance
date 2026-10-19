--#	Question	Check
--1.	Months where spend (categories 4–10) was over 15,000	7 months

SELECT date_trunc('month', txn_date)::date AS month,
       sum(amount) AS total_expense
FROM transactions
WHERE category_id BETWEEN 4 AND 10
GROUP BY month
HAVING sum(amount) > 15000
ORDER BY total_expense;

--2.	Months where net savings were over 3,000	3 months: 2025-10, 2025-12, 2026-01

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

SELECT category_id, max(amount) AS max_amount
FROM transactions
WHERE category_id BETWEEN 5 AND 10
GROUP BY category_id
HAVING max(amount) > 650;


--4.	Accounts with more than 300 transactions	1 row: account 1 (318)

SELECT account_id,
       COUNT(*)              AS txn_count
FROM transactions
GROUP BY account_id
HAVING COUNT(*) > 300
ORDER BY account_id;

--5.	Self-test Q3 again, from a blank line: months where expenses beat income	2 rows: 2025-11, 2026-04

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
