-- ✅ no GROUP BY, so the aggregates run over every row and give back 1 row
SELECT count(*), sum(amount), max(amount), min(amount) FROM transactions;

-- ✅ GROUP BY gives 1 row per category, ORDER BY because GROUP BY doesn't sort
SELECT category_id, count(*), sum(amount), max(amount), min(amount) FROM transactions
 GROUP BY category_id ORDER BY category_id;

-- ❌ errors: WHERE runs before grouping, so sum() doesn't exist yet
-- SELECT category_id, sum(amount) FROM transactions WHERE sum(amount) > 2000 GROUP BY category_id;

-- ✅ HAVING filters the groups after sum() is worked out (no ORDER BY, so the order is random)
SELECT category_id, count(*), sum(amount) , max(amount), min(amount) FROM transactions
 GROUP BY category_id HAVING sum(amount) > 2000;

-- ✅ ROUND(…, 2) cuts the long AVG decimal down for display
SELECT category_id, count(*), ROUND(avg(amount), 2) AS average_amount, max(amount), min(amount)
FROM transactions
GROUP BY category_id;


--WHERE filters rows before grouping. HAVING filters groups after grouping.
