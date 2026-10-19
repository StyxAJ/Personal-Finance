--#	Question	Check

--1.	Every transaction with its category name next to it	600 rows

SELECT txn_date, description, name, type 
FROM transactions INNER JOIN categories
    ON transactions.category_id = categories.id

--2.	Same, plus the account name (join three tables)	600 rows, names like “Main Checking”

SELECT t.txn_date,
       t.description,
       c.name AS category,
       c.type,
       a.name AS account
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts   a ON t.account_id  = a.id;

--3.	The 5 largest everyday expenses, showing category name and account name	Top row: 699.99, Utilities

SELECT t.txn_date,
       t.description,
       t.amount,
       c.name AS category,
       a.name AS account
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts   a ON t.account_id  = a.id
WHERE t.category_id BETWEEN 5 AND 10
ORDER BY t.amount DESC
LIMIT 5;

--4.	Number of transactions per category name	10 rows. Dining Out: 109

SELECT c.name AS category,
       COUNT(*) AS txn_count
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
GROUP BY c.name
ORDER BY c.name;
