# DBMS 04 — ACID

Sources: [PG: Transactions (tutorial 3.4)](https://www.postgresql.org/docs/current/tutorial-transactions.html) · [Wikipedia — ACID](https://en.wikipedia.org/wiki/ACID)

## What is it?
- A **transaction** groups several steps into **one all-or-nothing operation**. Either every step happens or none of them do.
- **ACID** is the set of 4 guarantees a database gives for each transaction:
  - **Atomicity**: the transaction is one unit. If any step fails, the whole thing is undone and the database is left unchanged.
  - **Consistency**: a transaction can only move the database from one valid state to another. Every rule (constraints, foreign keys, checks) still holds afterwards.
  - **Isolation**: transactions running at the same time don't see each other's half-finished work. The result is the same as if they had run one after another.
  - **Durability**: once a transaction is committed, it stays committed, even after a crash or power cut (it's written to permanent storage).
- In PostgreSQL you wrap the steps in `BEGIN` … `COMMIT`. `ROLLBACK` cancels everything since `BEGIN`.

```sql
BEGIN;
UPDATE accounts SET balance = balance - 100.00 WHERE name = 'Alice';
UPDATE accounts SET balance = balance + 100.00 WHERE name = 'Bob';
COMMIT;   -- or ROLLBACK; to undo both
```

- PG treats **every single statement as its own transaction** if you don't write `BEGIN` (an implicit `BEGIN` + `COMMIT` around it).
- **Savepoints** (`SAVEPOINT name;` … `ROLLBACK TO name;`) undo only part of a transaction and keep the earlier steps.

## Why does it exist?
- Real operations are often **several writes that only make sense together** (a transfer is a withdraw and a deposit).
- Without transactions, a crash, an error, or another user in the middle could leave the data **half-updated** and wrong.
- ACID means the database handles this for us, so we don't have to write recovery code for every failure.
- From the PG page: a transaction's updates are **not visible to other transactions until it commits**, and then they all become visible at once.

## An example
Moving **500 AED from Main Checking to Credit Card** in my finance app is two writes:

```sql
BEGIN;
UPDATE accounts SET balance = balance - 500 WHERE name = 'Main Checking';
UPDATE accounts SET balance = balance + 500 WHERE name = 'Credit Card';
COMMIT;
```

(My real `accounts` table has no `balance` column. Balances come from summing `transactions`, so the real version would be two `INSERT`s. The idea is the same.)

What goes wrong **without** each letter:
- **Atomicity:** the power cuts after the first update, so Main Checking is down 500 but Credit Card never got it. 500 AED vanishes.
- **Consistency:** a bad update breaks a rule (e.g. `amount` set to NULL, or the transfer points at an account id that doesn't exist), and that invalid data gets saved.
- **Isolation:** a monthly-total report runs between the two updates and sees the 500 gone from Main Checking but not yet on the Credit Card, so my net worth shows 500 AED less than it really is.
- **Durability:** the app says "Transfer complete", then the server crashes and restarts, and the transfer is gone as if it never happened.

## An interview question
**Q:** What does ACID stand for, and why does a bank transfer need it?

**A:** Atomicity, Consistency, Isolation, Durability. A transfer is two writes, a debit and a credit. Atomicity makes sure both happen or neither does, so money can't vanish or be created. Consistency makes sure all the database rules still hold afterwards. Isolation stops other queries from seeing the halfway state where the money has left one account but hasn't reached the other. Durability means that once the transfer is confirmed, a crash can't undo it. In SQL you get this by wrapping both updates in `BEGIN` … `COMMIT`.

## Key takeaways
- Transaction = several steps treated as one all-or-nothing unit (`BEGIN` / `COMMIT` / `ROLLBACK`).
- **A**tomicity: all or nothing.
- **C**onsistency: valid state → valid state, rules always hold.
- **I**solation: no one sees half-finished work.
- **D**urability: committed = permanent, even after a crash.
- In PG every statement on its own is already a transaction. `BEGIN` is needed to group several.
