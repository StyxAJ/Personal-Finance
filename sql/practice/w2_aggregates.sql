--How many transactions are there in total?

-- ✅ count(*) counts every row (count(description) would skip the NULL descriptions)
SELECT count(*) from transactions;

--The largest and smallest everyday expense (categories 5–10), in one query

-- ✅ WHERE drops the other categories before MAX and MIN are worked out
SELECT MAX(amount) AS largest, MIN(amount) AS smallest
FROM transactions
WHERE category_id BETWEEN 5 AND 10;

--Total, count and average (2 decimals) per category, sorted by category_id

-- ❌ errors: description isn't in GROUP BY, each category has many descriptions and Postgres can't pick one
-- SELECT category_id, description, sum(amount) FROM transactions GROUP BY category_id;

-- ✅ only the grouped column and aggregates in SELECT, ROUND for display
SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
GROUP BY category_id
ORDER BY category_id;

--Same as #3, only categories with a total over 2,000

-- ❌ errors: WHERE runs before grouping, so sum() doesn't exist yet
-- SELECT category_id, sum(amount) AS total FROM transactions WHERE sum(amount) > 2000 GROUP BY category_id;

-- ✅ HAVING filters the groups after sum() is worked out
SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
GROUP BY category_id HAVING sum(amount) > 2000
ORDER BY category_id;


--Categories with a total over 20,000

-- ❌ errors in Postgres: the alias total isn't known yet in HAVING
-- SELECT category_id, sum(amount) AS total FROM transactions GROUP BY category_id HAVING total > 20000;

-- ✅ repeat the aggregate in HAVING
SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
GROUP BY category_id HAVING sum(amount) > 20000
ORDER BY category_id;

--Categories with more than 90 transactions

-- ✅ HAVING can use a different aggregate from the ones shown in SELECT
SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
GROUP BY category_id HAVING count(*) > 90
ORDER BY category_id;

--	Total and count per account

-- ✅ same query, grouped by a different column
SELECT account_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
GROUP BY account_id
ORDER BY account_id;

--	Everyday expenses only (5–10), per category, only those averaging over 200

-- ❌ works, but wasted work: every category gets grouped first and the others thrown away after
-- SELECT category_id, ROUND(avg(amount), 2) FROM transactions GROUP BY category_id
-- HAVING category_id BETWEEN 5 AND 10 AND avg(amount) > 200;

-- ✅ row condition in WHERE (before grouping), aggregate condition in HAVING (after)
SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions WHERE category_id BETWEEN 5 AND 10
GROUP BY category_id HAVING avg(amount) > 200
ORDER BY category_id;
