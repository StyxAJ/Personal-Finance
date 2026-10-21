-- W2 Wed, Block 1 practice: ORDER BY, DISTINCT, LIMIT/OFFSET, CASE

-- ✅ ASC by default, smallest category first
SELECT * FROM transactions ORDER BY category_id;

-- ✅ sorts by category first, then biggest amount first inside each category (DESC only applies to amount)
SELECT * FROM transactions ORDER BY category_id,amount DESC;

-- ✅ each category once
SELECT DISTINCT category_id FROM transactions;

-- ✅ each different (description, category) pair once
SELECT DISTINCT description,category_id FROM transactions ORDER BY category_id;

-- ✅ ORDER BY before LIMIT, so it's the first 10 by category, not 10 random rows
SELECT * FROM transactions ORDER BY category_id LIMIT 10;

-- ❌ errors: description is in SELECT but not in GROUP BY
-- SELECT category_id, description, SUM(amount) FROM transactions GROUP BY category_id;

-- ✅ both non-aggregate columns are in GROUP BY, so 1 row per (category, description)
SELECT category_id, description , SUM(amount) as total_amount FROM transactions
GROUP BY category_id, description ORDER BY category_id LIMIT 10;

-- ❌ COUNT(description) skips NULLs, so the group with a NULL description divides by 0 and errors
-- SELECT category_id, description, SUM(amount)/COUNT(description) AS average_amount FROM transactions
-- GROUP BY category_id, description ORDER BY average_amount OFFSET 5 LIMIT 5;

-- ✅ AVG does the sum / count for us and handles NULLs (Postgres takes OFFSET and LIMIT in either order)
SELECT category_id, description, AVG(amount) as average_amount FROM transactions
 GROUP BY category_id, description ORDER BY average_amount OFFSET 5 LIMIT 5;

-- ❌ WHENs are checked top to bottom, so with > 100 first, everything over 500 is labelled MEDIUM
-- SELECT *, CASE WHEN amount > 100 THEN 'MEDIUM' WHEN amount > 500 THEN 'BIG' ELSE 'SMALL' END AS amount_size FROM transactions;

-- ✅ biggest condition first, the first WHEN that is true wins
 SELECT *,
    CASE WHEN amount > 500 Then 'BIG'
         WHEN amount > 100 Then 'MEDIUM'
         ELSE 'SMALL'
    END
    AS amount_size
 FROM transactions;
