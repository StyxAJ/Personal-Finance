from datetime import date


class Transaction:
    def __init__(self, amount, txn_date, category):
        # store each value on self so every object keeps its own copy
        self.amount = amount
        self.date = txn_date
        self.category = category

    @property
    def amount(self):
        return self._amount

    @amount.setter
    def amount(self, value):
        # runs for both __init__ (self.amount = amount) and later t.amount = ...
        if value == 0:
            raise ValueError("amount cannot be 0")
        self._amount = value

    def describe(self):
        return f"{self.date} | {self.category:<12} | {self.amount:>10.2f} AED"


groceries = Transaction(-245.50, date(2026, 11, 1), "Groceries")
salary = Transaction(12000.00, date(2026, 11, 2), "Salary")

# 1. two objects print their own lines
print(groceries.describe())
print(salary.describe())

# 2. change one amount -> only that object changes
groceries.amount = -300.00
print("after change:")
print(groceries.describe())
print(salary.describe())

# 3. a valid transaction prints its describe() line
t = Transaction(-50.00, date(2026, 11, 3), "Transport")
print("valid:")
print(t.describe())

# 4. creating with amount 0 is refused
try:
    Transaction(0, date(2026, 11, 4), "Misc")
except ValueError as e:
    print("create with 0:", e)

# 5. setting amount to 0 is refused, and the old value is kept
try:
    t.amount = 0
except ValueError as e:
    print("set to 0:", e)
print("amount still:", t.amount)
