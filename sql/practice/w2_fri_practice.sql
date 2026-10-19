--EXTRACT: pull the month number out of each date

SELECT txn_date, EXTRACT(month FROM txn_date) AS month
FROM transactions
LIMIT 5;

--date_trunc: snap each date back to the first of its month

SELECT txn_date, date_trunc('month', txn_date) AS month_start
FROM transactions
LIMIT 5;

--Same, with ::date to drop the 00:00:00

SELECT txn_date, date_trunc('month', txn_date)::date AS month_start
FROM transactions
LIMIT 5;

--date - interval

SELECT DATE '2026-09-30' - INTERVAL '30 days';
