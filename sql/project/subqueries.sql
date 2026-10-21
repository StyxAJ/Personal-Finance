--the important one: every transaction that’s larger than the average of its own category.

--This is a correlated subquery: the inner query runs once per outer row, each time using that row’s category.

--Give the outer table an alias, t, and the inner one a different alias, t2. Both read from transactions.
--The inner query works out the average for one category: the one where t2.category_id equals the outer row’s t.category_id.
--The outer WHERE compares t.amount to that average.


SELECT t.*
FROM transactions t
WHERE t.amount > (
    SELECT AVG(t2.amount)
    FROM transactions t2
    WHERE t2.category_id = t.category_id
)
ORDER BY t.category_id, t.amount DESC;
