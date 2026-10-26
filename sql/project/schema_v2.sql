ALTER TABLE transactions ADD CONSTRAINT positive_amount CHECK (amount> 0);
SELECT * FROM transactions WHERE amount <= 0;        

ALTER TABLE categories ADD CONSTRAINT unique_category_name UNIQUE (name);
SELECT name FROM categories GROUP BY name HAVING COUNT(*) > 1;

CREATE TABLE budgets(
    id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL REFERENCES categories(id),
    month DATE NOT NULL,
    limit_amount NUMERIC(12,2) NOT NULL CONSTRAINT positive_limit CHECK (limit_amount > 0),
    UNIQUE (category_id, month)
);