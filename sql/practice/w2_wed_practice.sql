-- W2 Wed, Block 1 practice: ORDER BY, DISTINCT, LIMIT/OFFSET, CASE

SELECT * FROM transactions ORDER BY category_id;
SELECT * FROM transactions ORDER BY category_id,amount DESC;
SELECT DISTINCT category_id FROM transactions;
SELECT DISTINCT description,category_id FROM transactions ORDER BY category_id;

SELECT * FROM transactions ORDER BY category_id LIMIT 10;
SELECT category_id, description , SUM(amount) as total_amount FROM transactions
GROUP BY category_id, description ORDER BY category_id LIMIT 10;

SELECT category_id, description , SUM(amount)/COUNT(description) as average_amount FROM transactions
 GROUP BY category_id, description ORDER BY average_amount OFFSET 5 LIMIT 5 ;

 SELECT *,
    CASE WHEN amount > 500 Then 'BIG'
         WHEN amount > 100 Then 'MEDIUM'
         ELSE 'SMALL' 
    END 
    AS amount_size
 FROM transactions;