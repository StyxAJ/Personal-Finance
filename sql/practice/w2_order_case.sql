--The 3 largest everyday expenses (categories 5–10)

-- ❌ ORDER BY is ASC by default, so this gives the 3 smallest
-- SELECT category_id, amount, description, txn_date FROM transactions WHERE category_id >= 5 ORDER BY amount LIMIT 3;

-- ✅ DESC puts the biggest first, then LIMIT keeps 3
-- (>= 5 is the same as BETWEEN 5 AND 10 only because 10 is the highest category)
SELECT category_id,amount,description,txn_date FROM transactions
WHERE category_id >= 5 ORDER BY amount DESC LIMIT 3;

--The 5 most recent transactions

-- ✅ id DESC breaks ties when several transactions share the same date, so the result is always the same 5
SELECT category_id,amount,description,txn_date FROM transactions
ORDER BY txn_date DESC, id DESC LIMIT 5;

--	The single smallest transaction

-- ✅ ASC is the default, so smallest first (if 2 tie for smallest, LIMIT 1 picks either one)
SELECT category_id,amount,description,txn_date FROM transactions
ORDER BY amount LIMIT 1;

-- All transactions: oldest date first, and largest amount first within the same date

-- ❌ DESC only applies to the column right before it, so this sorts txn_date DESC and amount ASC
-- SELECT category_id, amount, description, txn_date FROM transactions ORDER BY txn_date DESC, amount;

-- ✅ txn_date ASC first, then amount DESC inside each date
SELECT category_id,amount,description,txn_date FROM transactions
ORDER BY txn_date,amount DESC;

-- Every different description

-- ✅ DISTINCT gives each description once (all the NULLs count as 1)
SELECT DISTINCT description FROM transactions ORDER BY description;

-- 	Every different (account_id, category_id) pair

-- ✅ DISTINCT on 2 columns drops rows where both match, not just one
SELECT DISTINCT account_id,category_id FROM transactions ORDER BY account_id,category_id;
-- 16 not 20: Salary, Freelance, Interest and Rent (1-4) only ever went to Main Checking (account 1),
-- so they give 4 pairs. Only categories 5-10 used both accounts, so 4 + 6*2 = 16.

--id, amount, and a label column: 'big' if over 500, else 'small'

-- ❌ errors: every CASE needs an END
-- SELECT amount, CASE WHEN amount > 500 THEN 'BIG' ELSE 'SMALL' AS amount_size FROM transactions;

-- ✅ CASE … END AS gives the new column a name
SELECT category_id,amount,description,
CASE WHEN amount > 500 Then 'BIG'
     ELSE 'SMALL'
    END AS amount_size
 FROM transactions;

--	Count the big ones

-- ✅ the same condition as the CASE, just in WHERE
-- (COUNT(*) FILTER (WHERE amount > 500) does it too, next to other counts)
SELECT COUNT(*) FROM transactions
WHERE amount > 500;
