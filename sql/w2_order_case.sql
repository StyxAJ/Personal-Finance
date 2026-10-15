--The 3 largest everyday expenses (categories 5–10)

SELECT category_id,amount,description,txn_date FROM transactions 
WHERE category_id >= 5 ORDER BY amount DESC LIMIT 3;

--The 5 most recent transactions

SELECT category_id,amount,description,txn_date FROM transactions 
ORDER BY txn_date DESC, id DESC LIMIT 5;

--	The single smallest transaction
SELECT category_id,amount,description,txn_date FROM transactions 
ORDER BY amount LIMIT 1;

-- All transactions: oldest date first, and largest amount first within the same date
SELECT category_id,amount,description,txn_date FROM transactions 
ORDER BY txn_date,amount DESC;

-- Every different description

SELECT DISTINCT description FROM transactions ORDER BY description;

-- 	Every different (account_id, category_id) pair
SELECT DISTINCT account_id,category_id FROM transactions ORDER BY account_id,category_id;
-- 16 not 20: Salary, Freelance, Interest and Rent (1-4) only ever went to Main Checking (account 1),
-- so they give 4 pairs. Only categories 5-10 used both accounts, so 4 + 6*2 = 16.

--id, amount, and a label column: 'big' if over 500, else 'small'

SELECT category_id,amount,description,
CASE WHEN amount > 500 Then 'BIG'
     ELSE 'SMALL' 
    END AS amount_size
 FROM transactions;

--	Count the big ones

SELECT COUNT(*) FROM transactions 
WHERE amount > 500;
