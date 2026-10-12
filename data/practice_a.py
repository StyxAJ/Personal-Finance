import random
import time
import datetime as dt
import csv


example = random.random()
print(example)

example2 = random.uniform(2.5, 10)
print(example2)

example3 = random.expovariate(1 / 5)
print(example3)

example4 = random.randrange(10)
print(example4)


year = dt.timedelta(days=365)
another_year = dt.timedelta(weeks=40, days=84.0, hours=23, minutes=50, seconds=60)

year == another_year

print(year.total_seconds())


today = dt.date.today()
print(today)

today == dt.date.fromtimestamp(time.time())

my_birthday = dt.date(today.year, 11, 14)
if my_birthday < today:
    my_birthday = dt.date(today.year + 1, 11, 14)

print(my_birthday)


d = dt.datetime(2026, 3, 9)
print(d.strftime("%d/%m/%Y"))

with open("data/eggs.csv", "w", newline="") as csvfile:
    spamwriter = csv.writer(
        csvfile, delimiter=",", quotechar="|", quoting=csv.QUOTE_MINIMAL
    )
    spamwriter.writerow(["Spam"] * 5 + ["Baked Beans"])
    spamwriter.writerow(["Spam", "Lovely Spam", "Wonderful Spam"])
