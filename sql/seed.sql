
INSERT INTO categories (name, type) VALUES
    ('Salary',        'income'),   -- 1
    ('Freelance',     'income'),   -- 2
    ('Interest',      'income'),   -- 3
    ('Rent',          'expense'),  -- 4
    ('Groceries',     'expense'),  -- 5
    ('Utilities',     'expense'),  -- 6
    ('Dining Out',    'expense'),  -- 7
    ('Transport',     'expense'),  -- 8
    ('Entertainment', 'expense'),  -- 9
    ('Healthcare',    'expense');  -- 10

INSERT INTO accounts (name) VALUES
    ('Main Checking'),  -- 1
    ('Credit Card');    -- 2

INSERT INTO transactions (account_id, category_id, amount, txn_date, description) VALUES
    (1, 1,  4200.00, '2026-09-01', 'Monthly salary - September'),
    (1, 4,  1350.00, '2026-09-02', 'Apartment rent'),
    (2, 5,    86.45, '2026-09-04', 'Weekly groceries at supermarket'),
    (2, 7,    32.80, '2026-09-06', 'Dinner at Thai restaurant'),
    (2, 8,    45.00, '2026-09-07', 'Monthly metro pass'),
    (1, 6,   112.37, '2026-09-10', 'Electricity bill'),
    (2, 5,    64.10, '2026-09-11', 'Groceries and household items'),
    (2, 9,    15.99, '2026-09-12', 'Streaming subscription'),
    (1, 2,   650.00, '2026-09-15', 'Freelance website project payment'),
    (1, 6,    49.99, '2026-09-16', 'Internet bill'),
    (2, 10,   25.00, '2026-09-18', 'Pharmacy - prescription copay'),
    (2, 7,    18.50, '2026-09-20', 'Lunch with coworkers'),
    (2, 5,    92.73, '2026-09-25', 'Weekly groceries at supermarket'),
    (2, 9,    48.00, '2026-09-27', 'Concert tickets'),
    (1, 3,     6.84, '2026-09-30', 'Savings interest'),
    (1, 1,  4200.00, '2026-10-01', 'Monthly salary - October'),
    (1, 4,  1350.00, '2026-10-02', 'Apartment rent'),
    (2, 8,    38.60, '2026-10-04', 'Fuel'),
    (2, 7,    54.25, '2026-10-05', 'Birthday dinner'),
    (2, 5,    71.90, '2026-10-08', 'Groceries at farmers market');
