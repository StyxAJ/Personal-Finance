--#	Question	Check

--1.	Total spend per category name, biggest first	7 rows: Rent 60000.00, Utilities 37126.93, Healthcare 29700.91…

SELECT c.name AS category,
       sum(t.amount) AS total_amount
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
WHERE t.category_id >= 4
GROUP BY c.name
ORDER BY total_amount DESC;

--2.	Total spend per account name per category name, sorted by account, then category	13 rows. Credit Card has no Rent, because rent is always paid from Main Checking.

SELECT c.name AS category,
       a.name AS account,
       SUM(t.amount) AS total_spend
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts   a ON t.account_id  = a.id
WHERE t.category_id >= 4
GROUP BY account, category
ORDER BY account, category;

--3.	Same as #2, only the Credit Card rows. Filter by name, not by id.	6 rows. Utilities 18654.98

SELECT a.name AS account,
       c.name AS category,
       SUM(t.amount) AS total_spend
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts   a ON t.account_id  = a.id
WHERE c.type = 'expense'
  AND a.name = 'Credit Card'
GROUP BY account, category
ORDER BY account, category;


--4.	Total spend per account name	Main Checking 121702.64, Credit Card 62066.54

SELECT a.name AS account,
       SUM(t.amount) AS total_spend
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts   a ON t.account_id  = a.id
WHERE c.type = 'expense'
GROUP BY account
ORDER BY total_spend DESC;


--5.	Proof: one query that totals all expense spend	183769.18, which equals #4’s two totals added together

SELECT SUM(t.amount) AS total_spend
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
WHERE c.type = 'expense';
