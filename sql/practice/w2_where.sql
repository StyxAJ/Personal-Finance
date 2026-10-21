-- 1. Groceries over 300 AED
-- ✅ AND = both conditions must be true
SELECT * FROM transactions WHERE category_id = 5 AND amount > 300;

-- 2. Dining Out or Entertainment, only on the credit card (OR, with brackets)
-- ❌ AND runs before OR, so this gives category 9 on the card plus category 7 from ANY account
-- SELECT * FROM transactions WHERE category_id = 7 OR category_id = 9 AND account_id = 2;

-- ✅ the brackets make the OR run first, then the AND applies to both
SELECT * FROM transactions WHERE (category_id = 7 OR category_id = 9) AND account_id = 2;

-- 3. Same as #2, using IN
-- ✅ IN (7, 9) is the same as the bracketed OR, and no brackets needed
SELECT * FROM transactions WHERE category_id IN (7, 9) AND account_id = 2;

-- 4. Every transaction in March 2026 (BETWEEN with dates)
-- ✅ BETWEEN includes both ends, and works here because txn_date is a DATE
-- (if it were a timestamp, '2026-03-31' would mean midnight and miss the rest of that day)
SELECT * FROM transactions WHERE txn_date BETWEEN '2026-03-01' AND '2026-03-31';

-- 5. Amounts from 100 to 200 AED
-- ✅ 100 and 200 are both included
SELECT * FROM transactions WHERE amount BETWEEN 100 AND 200;

-- 6. Descriptions starting with D
-- ❌ no % = exact match, only finds a description that is just "D"
-- SELECT * FROM transactions WHERE description LIKE 'D';

-- ✅ % after D = D followed by anything (case matters in Postgres, 'd%' wouldn't match)
SELECT * FROM transactions WHERE description LIKE 'D%';

-- 7. Descriptions containing lowercase out: first with LIKE
-- ✅ LIKE is case-sensitive in Postgres, so only lowercase "out" matches
SELECT * FROM transactions WHERE description LIKE '%out%';

-- 7. Descriptions containing lowercase out: with ILIKE
-- ✅ ILIKE ignores case, so "Out" and "OUT" match too (Postgres only)
SELECT * FROM transactions WHERE description ILIKE '%out%';

-- 8. Transactions with no description: first with = NULL
-- ❌ gives back 0 rows: NULL isn't a value, so nothing is ever = NULL
-- SELECT * FROM transactions WHERE description = NULL;

-- 8. Transactions with no description:  with IS NULL
-- ✅ IS NULL is the only way to test for NULL
SELECT * FROM transactions WHERE description IS NULL;
