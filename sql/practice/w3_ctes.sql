--#	Question	Check

--A	Everyday expenses above the everyday average. Put the average in a CTE called everyday_avg, then compare against it.	208 rows, the same as yesterday

WITH everyday_avg AS (
    SELECT AVG(amount) AS avg_expense
    FROM transactions
    WHERE category_id BETWEEN 5 AND 10          
)
SELECT category_id, amount
FROM transactions
WHERE category_id BETWEEN 5 AND 10              
  AND amount > (SELECT avg_expense FROM everyday_avg);

--B	Transactions above their own category’s average. Make a CTE cat_avg (one row per category: category_id, average), then JOIN it to transactions on category_id and compare.	286 rows, the same as last night

WITH cat_avg AS (
    SELECT category_id, AVG(amount) AS avg_expense
    FROM transactions
    GROUP BY  category_id      
)
SELECT t.*, c.avg_expense
FROM transactions t
INNER JOIN cat_avg c ON t.category_id = c.category_id
WHERE t.amount > c.avg_expense
ORDER BY t.category_id, t.amount DESC;


--Block 2
--#	Question	Check
--1	CTE monthly: spend per month (categories 4–10). Main query: only months over 15,000.	7 months, the same as Monday’s HAVING

WITH monthly AS (
    SELECT date_trunc('month', txn_date)::date AS month,
           sum(amount) AS total_expense
    FROM transactions
    WHERE category_id BETWEEN 4 AND 10
    GROUP BY month
)
SELECT month, total_expense
FROM monthly
WHERE total_expense > 15000
ORDER BY total_expense;


--2	CTE monthly_net: net savings per month. Main query: months above the average month.	6 months: 2025-10, 2025-12, 2026-01, 2026-03, 2026-07, 2026-08. Average ≈ 1482.11

WITH monthly_net AS (
    SELECT date_trunc('month', txn_date)::date AS month,
           SUM(CASE
                 WHEN category_id BETWEEN 1 AND 3  THEN amount
                 WHEN category_id BETWEEN 4 AND 10 THEN -amount
                 ELSE 0
               END) AS net_savings
    FROM transactions
    GROUP BY month
)
SELECT month, net_savings
FROM monthly_net
WHERE net_savings > (SELECT AVG(net_savings) FROM monthly_net)
ORDER BY month;


--3	Two CTEs in one WITH: income (per month, categories 1–3) and expense (per month, 4–10). Main query: JOIN them on month and show income, expense and net, newest first.	12 rows. First: 2026-09-01, 16379.96, 15546.69, 833.27

WITH income AS (
    SELECT date_trunc('month', txn_date)::date AS month,
           sum(amount) AS total_income
    FROM transactions
    WHERE category_id BETWEEN 1 AND 3
    GROUP BY month
),
expense AS (
    SELECT date_trunc('month', txn_date)::date AS month,
           sum(amount) AS total_expense
    FROM transactions
    WHERE category_id BETWEEN 4 AND 10
    GROUP BY month
)
SELECT i.month,
       i.total_income,
       e.total_expense,
       i.total_income - e.total_expense AS net
FROM income i
INNER JOIN expense e ON i.month = e.month
ORDER BY i.month DESC;

