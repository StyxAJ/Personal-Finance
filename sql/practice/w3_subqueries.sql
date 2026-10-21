-- Block 1 practice

-- ❌ errors: WHERE picks the rows that go into the aggregate, so max() isn't worked out yet
-- SELECT category_id, account_id, amount, description FROM transactions WHERE amount = max(amount);

-- ✅ the subquery works out max(amount) on its own first, then the outer WHERE compares each row to that 1 value
-- gives back 12 rows, not 1: all 12 Salary rows are exactly 15000.00, so they tie for the largest.
-- the scalar subquery gives back 1 value, but many rows can match that value.
SELECT category_id, account_id, amount, description
FROM transactions
WHERE amount = (SELECT max(amount) FROM transactions);

-- ❌ errors: = needs 1 value, but the subquery gives back an id for every expense category
-- SELECT category_id, account_id, amount, description FROM transactions
-- WHERE category_id = (SELECT id FROM categories WHERE type = 'expense');

-- ✅ IN checks the value against every row the subquery gives back (the subquery must give back 1 column)
SELECT category_id, account_id, amount, description
FROM transactions
WHERE category_id IN (SELECT id FROM categories WHERE type = 'expense');

-- ❌ errors: EXISTS needs a subquery, not a condition
-- SELECT category_id, account_id, amount, description FROM transactions t
-- INNER JOIN category c ON t.category_id = c.id
-- WHERE EXISTS(t.category_id = c.id AND t.amount > 600);

-- ✅ t.category_id = c.id links the subquery to the category being checked, each category comes back at most once
-- SELECT 1 is a good habit: EXISTS only checks whether a row exists, so what we select doesn't matter
SELECT c.id, c.name
FROM categories c
WHERE EXISTS (
    SELECT 1
    FROM transactions t
    WHERE t.category_id = c.id
      AND t.amount > 600
);


--Block 2 6 queries

--#	Question	Use	Check
--1	Transactions above the overall average amount	scalar	43 rows

SELECT * FROM transactions
WHERE amount > (SELECT AVG(amount) FROM transactions);

--2	Everyday expenses (5–10) above the everyday average	scalar, with WHERE in both queries	208 rows

SELECT * FROM transactions
WHERE category_id BETWEEN 5 and 10 
AND amount > (SELECT AVG(amount) FROM transactions WHERE category_id BETWEEN 5 AND 10);

--3	Count transactions in expense categories, using IN (SELECT id FROM categories WHERE type = 'expense')	IN	564

SELECT COUNT(*) 
FROM transactions
WHERE category_id IN (SELECT id FROM categories WHERE type = 'expense');

--4	Count Credit Card transactions, using IN (SELECT id FROM accounts WHERE name = 'Credit Card')	IN	282

SELECT COUNT(*) 
FROM transactions
WHERE account_id IN (SELECT id FROM accounts WHERE name = 'Credit Card');

--5	Category names that have at least one transaction over 600	EXISTS	4: Salary, Freelance, Rent, Utilities

SELECT c.id, c.name
FROM categories c
WHERE EXISTS (
    SELECT 1
    FROM transactions t
    WHERE t.category_id = c.id
      AND t.amount > 600
);

--6	Category names with no Credit Card transactions	NOT EXISTS	4: Salary, Freelance, Interest, Rent

SELECT c.id, c.name
FROM categories c
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions t
    WHERE t.category_id = c.id
      AND t.account_id = 2
); 
