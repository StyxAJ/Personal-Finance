-- September 2026 budgets for the everyday expense categories (5–10)
INSERT INTO budgets (category_id, month, limit_amount) VALUES
    (5,  '2026-09-01', 1500.00),   -- Groceries
    (6,  '2026-09-01', 2000.00),   -- Utilities
    (7,  '2026-09-01', 1500.00),   -- Dining Out
    (8,  '2026-09-01',  400.00),   -- Transport
    (9,  '2026-09-01',  800.00),   -- Entertainment
    (10, '2026-09-01', 3000.00);   -- Healthcare

SELECT b.id, c.name, b.month, b.limit_amount
FROM budgets b
INNER JOIN categories c
  ON c.id = b.category_id
ORDER BY b.category_id;

SELECT count(*) FROM budgets;   -- 6
