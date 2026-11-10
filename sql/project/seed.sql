INSERT INTO categories (id, name, type) VALUES
    (1,  'Salary',        'income'),
    (2,  'Freelance',     'income'),
    (3,  'Interest',      'income'),
    (4,  'Rent',          'expense'),
    (5,  'Groceries',     'expense'),
    (6,  'Utilities',     'expense'),
    (7,  'Dining Out',    'expense'),
    (8,  'Transport',     'expense'),
    (9,  'Entertainment', 'expense'),
    (10, 'Healthcare',    'expense');

INSERT INTO accounts (id, name) VALUES
    (1, 'Main Checking'),
    (2, 'Credit Card');

-- Explicit ids bypass the SERIAL sequences, so move them past the seeded rows
SELECT setval(pg_get_serial_sequence('categories', 'id'), (SELECT MAX(id) FROM categories));
SELECT setval(pg_get_serial_sequence('accounts', 'id'),   (SELECT MAX(id) FROM accounts));

