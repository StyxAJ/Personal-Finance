import datetime as dt
import random

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


def random_date(start, end):
    """Generate a random date between start and end."""
    # start = dt.datetime(2025, 10, 1)
    # end = dt.datetime(2026, 9, 30)
    delta = end - start
    random_days = random.randint(0, delta.days)
    return start + dt.timedelta(days=random_days)


for i in range(5):
    print(random_date(dt.datetime(2025, 10, 1), dt.datetime(2026, 9, 30)))
