# OOP 01 — Classes and Objects

## TL;DR
- Class = blueprint, object = one thing built from it.
- `__init__` sets up a new object's attributes.
- `self` = the current object. Python passes it automatically.
- Each object has its own data. Changing one doesn't change the others.
- Classes keep data and the code that uses it in one place.

Sources: [Python docs: Classes (tutorial 9.3)](https://docs.python.org/3/tutorial/classes.html#a-first-look-at-classes)

## What is it?
- A **class** is a blueprint. It says what data a thing has and what it can do. `Transaction` is a class.
- An **object** (or **instance**) is one real thing built from that blueprint. `groceries = Transaction(...)` makes one object. Every object has its own data.
- **`__init__`** runs automatically when you create an object. Its job is to set up the object's starting data (its **attributes**).
- **`self`** is the object the method is working on right now. `self.amount = amount` means "store this amount on *this* object". Python passes `self` for you: `groceries.describe()` is really `Transaction.describe(groceries)`.
- A **method** is a function that lives inside a class and works on `self`, like `describe()`.

## Why does it exist?
- Without classes, a transaction would be loose variables (`amount1`, `date1`, `category1`, `amount2`, ...) or a dict like `{"amount": -245.5, "date": ..., "category": ...}`.
- Problems with that:
  - Nothing makes sure every transaction has the same fields. A typo like `"categry"` just makes a new key and nobody notices.
  - The code that works on a transaction (formatting it, checking it) is a separate function somewhere else, and it has to be passed the data every time.
- A class keeps the **data and the behaviour together**. Every `Transaction` is guaranteed to have `amount`, `date` and `category`, and `describe()` always travels with it.
- Each object is independent, so 600 transactions are 600 objects that don't interfere with each other.

## An example
My `Transaction` class ([oop_transaction.py](oop_transaction.py)):

```python
class Transaction:
    def __init__(self, amount, txn_date, category):
        self.amount = amount
        self.date = txn_date
        self.category = category

    def describe(self):
        return f"{self.date} | {self.category:<12} | {self.amount:>10.2f} AED"


groceries = Transaction(-245.50, date(2026, 11, 1), "Groceries")
salary = Transaction(12000.00, date(2026, 11, 2), "Salary")
groceries.amount = -300.00
```

- `Transaction(...)` calls `__init__`, and `self` is the new object being built.
- `groceries` and `salary` are two separate objects from the same class. Each prints its own line.
- Changing `groceries.amount` only changes `groceries`. `salary.amount` is still 12000, because each object stores its own attributes.

## An interview question
**Q:** What is `self` in Python, and why do methods need it?

**A:** `self` is the specific object a method is being called on. One class can have many objects, and the method's code is shared between all of them, so it needs to know *which* object's data to use. When I write `groceries.describe()`, Python turns it into `Transaction.describe(groceries)`, so inside the method `self` is `groceries` and `self.amount` is groceries' amount. In `__init__`, `self.amount = amount` is what attaches the value to that one object. Without `self`, `amount` would just be a local variable that disappears when the method ends.
