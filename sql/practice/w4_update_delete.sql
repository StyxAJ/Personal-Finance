-- W4: UPDATE and DELETE
-- Routine: run each change inside BEGIN; … ROLLBACK;. Check the rows first with a SELECT,
-- then change them, check again, and ROLLBACK so the real data stays the same.
-- Gotcha: inside one BEGIN, the first error aborts the whole transaction,
-- and every later command is ignored.

--#	Change

--1	Rename category 'Dining Out' to 'Restaurants'

BEGIN;
UPDATE categories
SET name = 'Restaurants'
WHERE name = 'Dining Out';
-- the transactions only store category_id, so they pick up the new name through the JOIN
SELECT c.name, count(*)
FROM transactions t
INNER JOIN categories c
  ON c.id = t.category_id
WHERE c.name = 'Restaurants'
GROUP BY c.name;
ROLLBACK;
-- Predicted: UPDATE 1, the JOIN shows 109 transactions under 'Restaurants'
--            (1 row changed, all 109 transactions follow it: that's 3NF paying off)
-- Actual:

--2	Raise all September 2026 budgets by 10%

BEGIN;
UPDATE budgets
SET limit_amount = limit_amount * 1.10   -- uses the current value, like temp_hi - 2 in the docs
WHERE month = '2026-09-01'
RETURNING *;                             -- shows the changed rows straight away, no extra SELECT
ROLLBACK;
-- Predicted: UPDATE 6, Groceries goes from 1500.00 to 1650.00
-- Actual:

--3	Set any one transaction's amount to 0

BEGIN;
UPDATE transactions
SET amount = 0
WHERE id = 1;
ROLLBACK;
-- Predicted: fails (CHECK), positive_amount needs amount > 0
-- Actual:

--4	Delete every Transport (category 8) transaction in July 2026

BEGIN;
-- count first, so we know how many rows the DELETE should hit
SELECT count(*)
FROM transactions
WHERE category_id = 8
  AND txn_date >= '2026-07-01'
  AND txn_date <  '2026-08-01';
-- same WHERE, copied from the SELECT
DELETE FROM transactions
WHERE category_id = 8
  AND txn_date >= '2026-07-01'
  AND txn_date <  '2026-08-01';
ROLLBACK;
-- Predicted: count is 11, then DELETE 11
-- Actual:

--5	The scary one: DELETE with no WHERE

BEGIN;
DELETE FROM transactions;              -- no WHERE, every row goes, and Postgres doesn't ask first
SELECT count(*) FROM transactions;     -- 0
ROLLBACK;
SELECT count(*) FROM transactions;     -- back to 600
-- Predicted: DELETE 600, count is 0, then after ROLLBACK the count is 600 again
-- Actual:
-- Without BEGIN, those 600 rows would be gone for good. That's why the routine exists.

-- Final check: nothing above should have changed the real data

SELECT count(*), sum(amount) FROM transactions;
-- Actual: shows no change
