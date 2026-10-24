
BEGIN;
INSERT INTO categories (id, name, type) VALUES (11, 'Education', 'expense');

--#	Question	Check
--1	Transactions per category name, INNER JOIN	10 rows, no Education

SELECT c.name, COUNT(*)
FROM categories c
INNER JOIN transactions t
  ON t.category_id = c.id
GROUP BY c.id, c.name
ORDER BY c.id;

--2	Same with categories c LEFT JOIN transactions t, using COUNT(t.id)	11 rows, Education 0

SELECT c.name, COUNT(t.id)
FROM categories c 
LEFT JOIN transactions t
  ON t.category_id = c.id
GROUP BY c.id, c.name
ORDER BY c.id;

--3	Categories with no transactions: LEFT JOIN + WHERE t.id IS NULL	1 row: Education

SELECT c.name, COUNT(t.id)
FROM categories c 
LEFT JOIN transactions t
  ON t.category_id = c.id 
WHERE t.id IS NULL 
GROUP BY c.id, c.name
ORDER BY c.id;

--4	Spend per expense category in Sept 2026, zeros included: COALESCE(SUM(t.amount), 0), with the month filter in ON	8 rows. Education 0.00, Healthcare 4283.27

SELECT c.name, COALESCE(SUM(t.amount), 0) AS spend
FROM categories c
LEFT JOIN transactions t
  ON t.category_id = c.id
 AND t.txn_date >= '2026-09-01'
 AND t.txn_date <  '2026-10-01'
WHERE c.type = 'expense'
GROUP BY c.id, c.name
ORDER BY c.id;

-- ROLLBACK;