--Transactions larger than their own category’s average. Show the category name and amount.

WITH cat_avg AS (
    SELECT category_id, AVG(amount) AS avg_expense
    FROM transactions
    GROUP BY  category_id      
)
SELECT c.name, t.amount
FROM transactions t
JOIN cat_avg a    ON a.category_id = t.category_id
JOIN categories c ON c.id = t.category_id
WHERE t.amount > a.avg_expense
ORDER BY c.name, t.amount DESC;

--Using a CTE of monthly spend (categories 4–10), list the months whose spend was above the average month.

WITH expense AS (
    SELECT date_trunc('month', txn_date)::date AS month,
           SUM(amount) AS total_expense
    FROM transactions
    WHERE category_id BETWEEN 4 AND 10
    GROUP BY month
)
SELECT month, total_expense
FROM expense
WHERE total_expense > (SELECT AVG(total_expense) FROM expense)
ORDER BY month;


--Spend per account per category, with names rather than ids.

WITH acct_cat AS (
    SELECT account_id, category_id, SUM(amount) AS total_spend
    FROM transactions
    GROUP BY account_id, category_id 
)
-- should act a  bridge between both accounts and category tables
SELECT a.name AS Account, c.name AS Category, ac.total_spend
FROM acct_cat ac
JOIN accounts   a ON a.id = ac.account_id
JOIN categories c ON c.id = ac.category_id
WHERE c.type = 'expense'   
ORDER BY a.name, ac.total_spend DESC;

--In one sentence: INNER JOIN vs LEFT JOIN.

The difference between an inner join and an outer (left) join is as follows.

An inner join is used when one table contains a primary key and the other a foreign key. It returns only the rows where the keys match, creating a new table that combines the matching rows from both tables.

A left join returns all rows from the left table and the matching rows from the right table. If a row in the left table has no corresponding row in the right table, the result includes NULL values for the right‑table columns in that row.
