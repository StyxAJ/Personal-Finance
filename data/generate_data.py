import csv
import datetime as dt
import random

random.seed(42)  # For reproducibility

categories = [
    (1, "Salary", "income"),
    (2, "Freelance", "income"),
    (3, "Interest", "income"),
    (4, "Rent", "expense"),
    (5, "Groceries", "expense"),
    (6, "Utilities", "expense"),
    (7, "Dining Out", "expense"),
    (8, "Transport", "expense"),
    (9, "Entertainment", "expense"),
    (10, "Healthcare", "expense"),
]

accounts = ((1, "Main Checking"), (2, "Credit Card"))


def random_date(start, end):
    """Generate a random date between start and end."""
    delta = end - start
    random_days = random.randint(0, delta.days)
    return start + dt.timedelta(days=random_days)


start = dt.date(2025, 10, 1)
end = dt.date(2026, 9, 30)


rows = []

# Format: (account_id, category_id, amount, txn_date, description)

# Fixed monthly rows: 4 per month x 12 months (Oct 2025 -> Sep 2026) = 48
for i in range(12):
    year = start.year + (start.month - 1 + i) // 12
    month = (start.month - 1 + i) % 12 + 1
    month_start = dt.date(year, month, 1)

    rows.append((1, 1, 15000.00, month_start, "Salary"))
    rows.append((1, 2, round(random.uniform(500, 3000), 2), month_start, "Freelance"))
    rows.append((1, 3, round(random.uniform(20, 80), 2), month_start, "Interest"))
    rows.append((1, 4, 5000.00, month_start, "Rent"))


EXPENSE_RANGES = {
    5: ("Groceries", 50, 400),
    6: ("Utilities", 200, 700),
    7: ("Dining Out", 30, 250),
    8: ("Transport", 10, 150),
    9: ("Entertainment", 30, 300),
    10: ("Healthcare", 50, 600),
}

expense_ids = list(EXPENSE_RANGES.keys())

for _ in range(552):
    cat_id = random.choice(expense_ids)
    cat_name, min_amt, max_amt = EXPENSE_RANGES[cat_id]
    amount = round(random.uniform(min_amt, max_amt), 2)
    txn_date = random_date(start, end)
    account_id = random.choice(accounts)[0]
    rows.append((account_id, cat_id, amount, txn_date, cat_name))

print(len(rows))

with open("data/clean.csv", "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow([
        "account_id",
        "category_id",
        "amount",
        "txn_date",
        "description",
    ])
    writer.writerows(rows)
