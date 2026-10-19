-- 1. Groceries over 300 AED
SELECT * FROM transactions WHERE category_id = 5 AND amount > 300;
-- 2. Dining Out or Entertainment, only on the credit card (OR, with brackets)
SELECT * FROM transactions WHERE (category_id = 7 OR category_id = 9) AND account_id = 2;
-- 3. Same as #2, using IN
SELECT * FROM transactions WHERE category_id IN (7, 9) AND account_id = 2;
-- 4. Every transaction in March 2026 (BETWEEN with dates)
SELECT * FROM transactions WHERE txn_date BETWEEN '2026-03-01' AND '2026-03-31';
-- 5. Amounts from 100 to 200 AED
SELECT * FROM transactions WHERE amount BETWEEN 100 AND 200;
-- 6. Descriptions starting with D
SELECT * FROM transactions WHERE description LIKE 'D%';
-- 7. Descriptions containing lowercase out: first with LIKE
SELECT * FROM transactions WHERE description LIKE '%out%';
-- 7. Descriptions containing lowercase out: with ILIKE
SELECT * FROM transactions WHERE description ILIKE '%out%';
-- 8. Transactions with no description: first with = NULL
SELECT * FROM transactions WHERE description = NULL;
-- 8. Transactions with no description:  with IS NULL
SELECT * FROM transactions WHERE description IS NULL;
