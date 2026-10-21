--Rules: no notes, no AI, no docs until you finish. Write each answer in sql/w2_selftest.sql, with the question as a comment above it.

--Two definitions so the questions are clear:

--Income = categories 1–3. Expense = categories 4–10.
--“Net savings” = income minus expenses.

--Questions:

--Net savings per month, newest first.

-- ❌ ORDER BY is ASC by default, so this lists oldest first
-- SELECT date_trunc('month', txn_date)::date AS month, SUM(amount) FROM transactions GROUP BY month ORDER BY month;

-- ✅ CASE flips expenses to negative, so 1 SUM gives income minus expenses
SELECT date_trunc('month', txn_date)::date AS month,
       SUM(CASE
             WHEN category_id BETWEEN 1 AND 3  THEN amount
             WHEN category_id BETWEEN 4 AND 10 THEN -amount
             ELSE 0
           END) AS net_savings
FROM transactions
GROUP BY month
ORDER BY month DESC;

--Top 3 expense categories in 2026, by total.

-- ❌ without DESC this gives the bottom 3
-- SELECT category_id, SUM(amount) AS total FROM transactions WHERE category_id BETWEEN 4 AND 10 GROUP BY category_id ORDER BY total LIMIT 3;

-- ✅ both filters are row conditions, so they go in WHERE, then sort biggest first and keep 3
SELECT category_id, SUM(amount) AS total
FROM transactions
WHERE category_id BETWEEN 4 AND 10
  AND EXTRACT(YEAR FROM txn_date) = 2026
GROUP BY category_id
ORDER BY total DESC
LIMIT 3;


--Months where expenses were higher than income.

-- ❌ errors in Postgres: the alias net_savings isn't known yet in HAVING
-- SELECT date_trunc('month', txn_date)::date AS month, SUM(CASE … END) AS net_savings
-- FROM transactions GROUP BY month HAVING net_savings < 0;

-- ✅ repeat the whole SUM(CASE …) in HAVING, ORDER BY can use the alias
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
ORDER BY net_savings ASC;


--Average transaction per category, only for categories with more than 20 transactions.

-- ❌ errors: WHERE runs before grouping, so COUNT(*) doesn't exist yet
-- SELECT category_id, ROUND(AVG(amount), 2) FROM transactions WHERE COUNT(*) > 20 GROUP BY category_id;

-- ✅ the count condition is on groups, so it goes in HAVING
SELECT category_id,
       ROUND(AVG(amount), 2) AS avg_txn,
       COUNT(*)              AS txn_count
FROM transactions
GROUP BY category_id
HAVING COUNT(*) > 20
ORDER BY category_id;

--In one sentence: WHERE vs HAVING.

--Where picks the input rows before grouping up and cannot used aggregates values.
--Having picks the grouped rows after group by and can use aggregates values
