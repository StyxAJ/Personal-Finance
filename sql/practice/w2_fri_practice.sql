--EXTRACT: pull the month number out of each date

-- ✅ EXTRACT gives back just the number (3 for March), so all Marches from every year look the same
SELECT txn_date, EXTRACT(month FROM txn_date) AS month
FROM transactions
LIMIT 5;

--date_trunc: snap each date back to the first of its month

-- ✅ date_trunc keeps the year, so March 2025 and March 2026 stay apart
SELECT txn_date, date_trunc('month', txn_date) AS month_start
FROM transactions
LIMIT 5;

--Same, with ::date to drop the 00:00:00

-- ✅ date_trunc gives back a timestamp, ::date turns it back into a plain date
SELECT txn_date, date_trunc('month', txn_date)::date AS month_start
FROM transactions
LIMIT 5;

--date - interval

-- ❌ without DATE, '2026-09-30' is just text and Postgres doesn't know it's a date
-- SELECT '2026-09-30' - 30;

-- ✅ DATE makes it a date, minus an INTERVAL gives a timestamp (2026-08-31 00:00:00)
SELECT DATE '2026-09-30' - INTERVAL '30 days';
