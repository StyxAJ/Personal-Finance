-- W4: constraint tests
-- Run each test on its own, inside BEGIN; … ROLLBACK;. Real data stays safe.
-- Gotcha: inside one BEGIN, the first error aborts the whole transaction,
-- and every later command is ignored.

--#	Test

--1	Insert a transaction with category_id = 99 (no such category)

BEGIN;
INSERT INTO transactions (account_id, category_id, amount, txn_date, description)
VALUES (1, 99, 25.00, '2026-10-26', 'Test: no such category');
ROLLBACK;
-- Predicted: fails (FK), category 99 doesn't exist in categories
-- Actual: ERROR: insert or update on table "transactions" violates foreign key constraint "transactions_category_id_fkey"
--         DETAIL: Key (category_id)=(99) is not present in table "categories".

--2	Insert a transaction with amount = NULL

BEGIN;
INSERT INTO transactions (account_id, category_id, amount, txn_date, description)
VALUES (1, 5, NULL, '2026-10-26', 'Test: NULL amount');
ROLLBACK;
-- Predicted: fails (NOT NULL), amount is NOT NULL
-- Actual: ERROR: null value in column "amount" of relation "transactions" violates not-null constraint
--         DETAIL: Failing row contains (604, 1, 5, null, 2026-10-26, Test: NULL amount).

--3	Insert a transaction with amount = -50

BEGIN;
INSERT INTO transactions (account_id, category_id, amount, txn_date, description)
VALUES (1, 5, -50, '2026-10-26', 'Test: negative amount');
SELECT * FROM transactions WHERE amount < 0;
ROLLBACK;
-- Predicted: succeeds, there's no CHECK (amount > 0)
-- Actual: INSERT 0 1, the SELECT shows the new row (id 605, amount -50.00), so a negative amount gets in

--4	Insert a category named 'Groceries' again

BEGIN;
INSERT INTO categories (name, type) VALUES ('Groceries', 'expense');
SELECT * FROM categories WHERE name = 'Groceries';
ROLLBACK;
-- Predicted: succeeds, there's no UNIQUE on categories.name
-- Actual: INSERT 0 1, the SELECT shows 2 rows named 'Groceries' (id 5 and id 11, both expense), so duplicate names get in

--5	Insert a category with type = 'savings'

BEGIN;
INSERT INTO categories (name, type) VALUES ('Emergency Fund', 'savings');
ROLLBACK;
-- Predicted: fails (CHECK), type must be 'income' or 'expense'
-- Actual: ERROR: new row for relation "categories" violates check constraint "categories_type_check"
--         DETAIL: Failing row contains (12, Emergency Fund, savings).

--6	DELETE FROM categories WHERE id = 5;

BEGIN;
DELETE FROM categories WHERE id = 5;
ROLLBACK;
-- Predicted: fails (FK), Groceries still has transactions (default ON DELETE NO ACTION)
-- Actual: ERROR: update or delete on table "categories" violates foreign key constraint "transactions_category_id_fkey" on table "transactions"
--         DETAIL: Key (id)=(5) is still referenced from table "transactions".
