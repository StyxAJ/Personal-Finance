import random
import csv
import datetime as dt


random.seed(42)

start = dt.date(2025, 10, 1)

rows = []

for _ in range(200_000):
    account_id = random.randint(1, 2)
    category_id = random.randint(5, 10)
    amount = round(random.uniform(5, 500), 2)
    offset = random.randint(0, 364)
    txn_date = start + dt.timedelta(days=offset)
    description = "expense"
    row = (account_id, category_id, amount, txn_date, description)
    rows.append(row)


print(len(rows))

with open("data/big.csv", "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow([
        "account_id",
        "category_id",
        "amount",
        "txn_date",
        "description",
    ])
    writer.writerows(rows)
