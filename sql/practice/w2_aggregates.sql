--How many transactions are there in total?

SELECT count(*) from transactions;

--The largest and smallest everyday expense (categories 5–10), in one query

SELECT MAX(amount) AS largest, MIN(amount) AS smallest
FROM transactions
WHERE category_id BETWEEN 5 AND 10;

--Total, count and average (2 decimals) per category, sorted by category_id

SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
GROUP BY category_id
ORDER BY category_id;

--Same as #3, only categories with a total over 2,000

SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions  
GROUP BY category_id HAVING sum(amount) > 2000
ORDER BY category_id;


--Categories with a total over 20,000

SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
GROUP BY category_id HAVING sum(amount) > 20000
ORDER BY category_id;

--Categories with more than 90 transactions

SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
GROUP BY category_id HAVING count(*) > 90
ORDER BY category_id;

--	Total and count per account

SELECT account_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
GROUP BY account_id
ORDER BY account_id;

--	Everyday expenses only (5–10), per category, only those averaging over 200

SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions WHERE category_id BETWEEN 5 AND 10
GROUP BY category_id HAVING avg(amount) > 200
ORDER BY category_id;