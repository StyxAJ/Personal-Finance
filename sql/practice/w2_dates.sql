--1. Transactions in March 2026, using EXTRACT (year and month)
--   Check: 45, the same as Tuesday's BETWEEN query

-- ❌ errors: the aliases years and months aren't known yet in WHERE
-- SELECT txn_date, EXTRACT(month FROM txn_date) AS months, EXTRACT(year FROM txn_date) AS years
-- FROM transactions WHERE years = 2026 AND months = 3;

-- ✅ repeat the EXTRACT in WHERE, and check both year and month (month alone would also give March 2025)
SELECT txn_date, EXTRACT(month FROM txn_date) AS months, EXTRACT(year FROM txn_date) AS years
FROM transactions
WHERE EXTRACT(year FROM txn_date) = 2026 AND  EXTRACT(month FROM txn_date) = 3;

--2. Spend per month, using date_trunc, oldest first
--   Check: 12 rows. First: 2025-10-01, 13908.34

-- ❌ groups by the exact day, so it gives 1 row per day instead of 1 per month
-- SELECT txn_date, sum(amount) FROM transactions WHERE category_id >= 4 GROUP BY txn_date;

-- ✅ date_trunc snaps every date to the 1st of its month, so a month's dates fall into 1 group
-- (Postgres lets GROUP BY and ORDER BY use the SELECT alias, WHERE and HAVING can't)
SELECT date_trunc('month',txn_date) AS month_start ,sum(amount)
FROM transactions
WHERE category_id >= 4
GROUP BY month_start ORDER BY month_start;

--3. Same as #2, but newest first, with the month shown as a plain date
--   Check: First: 2026-09-01, 15546.69

-- ✅ ::date drops the 00:00:00 that date_trunc adds
SELECT date_trunc('month',txn_date)::date AS month_start ,sum(amount)
FROM transactions
WHERE category_id >= 4
GROUP BY month_start ORDER BY month_start DESC;

--4. The single biggest spending month
--   Check: 2025-11-01, 19382.64

-- ❌ errors: aggregates can't be nested inside each other
-- SELECT max(sum(amount)) FROM transactions WHERE category_id >= 4 GROUP BY date_trunc('month', txn_date);

-- ✅ sort the monthly totals biggest first and keep just the top 1
SELECT date_trunc('month',txn_date)::date AS month_start ,sum(amount)
FROM transactions
WHERE category_id >= 4
GROUP BY month_start ORDER BY sum(amount) DESC
LIMIT 1;

--5. Number of transactions per month
--   Check: 12 rows. November has 61

-- ✅ no WHERE, so income and expenses are both counted
SELECT date_trunc('month', txn_date)::date AS month_start, count(*)
FROM transactions
GROUP BY month_start ORDER BY month_start;


--6. Transactions in the last 30 days of data (on or after 2026-09-30 minus 30 days), using an INTERVAL
--   Check: 55

-- ✅ DATE '…' makes it a real date, minus an INTERVAL gives 2026-08-31 00:00
-- (DATE '2026-09-30' - 30 does the same, date minus a number of days)
SELECT count(*)
FROM transactions
WHERE txn_date >= DATE '2026-09-30' - INTERVAL '30 days';


--7. Everyday spend (categories 5–10) on weekends vs weekdays: CASE on isodow (6 and 7 are Sat and Sun), then GROUP BY
--   Check: Weekend 29926.81, weekday 93842.37

-- ❌ dow counts Sunday as 0 and Saturday as 6, so IN (6, 7) misses every Sunday
-- SELECT CASE WHEN EXTRACT(dow FROM txn_date) IN (6, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type, sum(amount)
-- FROM transactions WHERE category_id BETWEEN 5 AND 10 GROUP BY day_type;

-- ✅ isodow goes Monday 1 to Sunday 7, so 6 and 7 are Sat and Sun
SELECT CASE
           WHEN EXTRACT(isodow FROM txn_date) IN (6, 7) THEN 'Weekend'
           ELSE 'Weekday'
       END AS day_type,
       sum(amount) AS total
FROM transactions
WHERE category_id BETWEEN 5 AND 10
GROUP BY day_type;


--8. Spend per quarter
--   Check: 4 rows. First: Q4 2025, 46626.15

-- ✅ same as per month, date_trunc('quarter') snaps to the 1st of Jan / Apr / Jul / Oct
SELECT date_trunc('quarter', txn_date)::date AS quarter_start, sum(amount) AS total
FROM transactions
WHERE category_id >= 4
GROUP BY quarter_start ORDER BY quarter_start;
