SELECT count(*), sum(amount), max(amount), min(amount) FROM transactions;
SELECT category_id, count(*), sum(amount), max(amount), min(amount) FROM transactions
 GROUP BY category_id ORDER BY category_id;

SELECT category_id, count(*), sum(amount) , max(amount), min(amount) FROM transactions
 GROUP BY category_id HAVING sum(amount) > 2000;

SELECT category_id, count(*), ROUND(avg(amount), 2) AS average_amount, max(amount), min(amount)
FROM transactions
GROUP BY category_id;


--WHERE filters rows before grouping. HAVING filters groups after grouping.

