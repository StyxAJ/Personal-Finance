-- W4: rejection tests after schema_v2.sql
-- All 5 should fail. Run each on its own, inside BEGIN; … ROLLBACK;.
-- Gotcha: after an error, run ROLLBACK; on its own before the next test.

--#	Test

--1	Re-run old test #3: a transaction with amount = -50

BEGIN;
INSERT INTO transactions (account_id, category_id, amount, txn_date, description)
VALUES (1, 5, -50, '2026-10-26', 'Test: negative amount');
ROLLBACK;
-- Predicted: fails (CHECK positive_amount)
-- Actual:

--2	Re-run old test #4: a second 'Groceries' category

BEGIN;
INSERT INTO categories (name, type) VALUES ('Groceries', 'expense');
ROLLBACK;
-- Predicted: fails (UNIQUE unique_category_name)
-- Actual:

--3	A second September budget for Groceries

BEGIN;
INSERT INTO budgets (category_id, month, limit_amount) VALUES (5, '2026-09-01', 1000.00);
ROLLBACK;
-- Predicted: fails (UNIQUE (category_id, month)), Groceries already has a 2026-09-01 budget
-- Actual:

--4	A budget for category_id = 99

BEGIN;
INSERT INTO budgets (category_id, month, limit_amount) VALUES (99, '2026-09-01', 500.00);
ROLLBACK;
-- Predicted: fails (FK), category 99 doesn't exist
-- Actual:

--5	A budget with limit_amount = -100

BEGIN;
INSERT INTO budgets (category_id, month, limit_amount) VALUES (4, '2026-09-01', -100.00);
ROLLBACK;
-- Predicted: fails (CHECK positive_limit)
-- Actual:
