--#	Question	Check

--1.	Every transaction with its category name next to it	600 rows

-- ❌ no ; at the end, so it runs into the next query and errors when the whole file is run
-- SELECT txn_date, description, name, type FROM transactions INNER JOIN categories ON transactions.category_id = categories.id

-- ✅ name and type only exist in categories, so they don't need a prefix here (but it's clearer with one)
SELECT txn_date, description, name, type
FROM transactions INNER JOIN categories
    ON transactions.category_id = categories.id;

--2.	Same, plus the account name (join three tables)	600 rows, names like “Main Checking”

-- ❌ errors: categories and accounts both have a name column, so "name" is ambiguous
-- SELECT t.txn_date, name FROM transactions t
-- INNER JOIN categories c ON t.category_id = c.id INNER JOIN accounts a ON t.account_id = a.id;

-- ✅ table aliases (t, c, a) plus column aliases (AS category, AS account) keep the 2 names apart
SELECT t.txn_date,
       t.description,
       c.name AS category,
       c.type,
       a.name AS account
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts   a ON t.account_id  = a.id;

--3.	The 5 largest everyday expenses, showing category name and account name	Top row: 699.99, Utilities

-- ✅ join first, then WHERE, ORDER BY and LIMIT work on the joined rows like on 1 table
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

-- ❌ errors: c.name isn't in GROUP BY (Postgres only allows it if the group is on c.id, the primary key)
-- SELECT c.name, COUNT(*) FROM transactions t INNER JOIN categories c ON t.category_id = c.id GROUP BY t.category_id;

-- ✅ group by the column shown (GROUP BY c.id, c.name is safer if 2 categories could share a name)
SELECT c.name AS category,
       COUNT(*) AS txn_count
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
GROUP BY c.name
ORDER BY c.name;
