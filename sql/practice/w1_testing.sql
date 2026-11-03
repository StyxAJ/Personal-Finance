-- testing delete 
BEGIN;

-- 3, 2, 1, DELETE!

DELETE FROM transactions; 

SELECT count(*) FROM transactions;  -- 0 rows. Every transaction gone. :(

ROLLBACK; -- please work


SELECT count(*) FROM transactions;  -- all 600 back.