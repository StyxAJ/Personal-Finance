CREATE TABLE categories (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense'))
);

CREATE TABLE accounts (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE transactions (
    id          SERIAL PRIMARY KEY,
    account_id  INTEGER NOT NULL REFERENCES accounts(id),
    category_id INTEGER NOT NULL REFERENCES categories(id),
    amount      NUMERIC(12,2) NOT NULL,
    txn_date    DATE NOT NULL,
    description TEXT
);
