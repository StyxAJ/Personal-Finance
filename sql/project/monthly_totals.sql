--Months where expenses were higher than income.

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