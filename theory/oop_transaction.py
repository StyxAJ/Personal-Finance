from datetime import date


class Transaction:
    def __init__(self, amount, txn_date, category):
        # store each value on self so every object keeps its own copy
        self.amount = amount
        self.date = txn_date
        self.category = category

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
