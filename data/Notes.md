# Python Notes: datetime, random, csv

These are the 3 standard library modules used to generate fake finance data (`generate_data.py`): **datetime** for transaction dates, **random** for amounts/categories, and **csv** for writing the result to a file that can be loaded into the database.

**How to read these notes:**
- ⭐ **Focus:** the parts needed most for the data generator, learn these first.
- **Gotcha:** common mistakes / behaviour that is easy to get wrong.
- **Note:** extra info, good to know but not urgent.

Docs: [datetime](https://docs.python.org/3/library/datetime.html), [random](https://docs.python.org/3/library/random.html), [csv](https://docs.python.org/3/library/csv.html)

## datetime

The **datetime** module gives us classes to work with dates and times. It supports date and time arithmetic (e.g. "30 days after this date"), but the focus of the implementation is on pulling out attributes efficiently for formatting and changing the output.

### Import style

```python
import datetime as dt      # module, then use dt.date, dt.datetime, dt.timedelta
from datetime import date, datetime, timedelta   # or import the classes directly
```

**Gotcha:** the module and the main class are both called `datetime`. With `import datetime` we have to write `datetime.datetime.now()`. Pick one import style per file and stick with it, mixing them is the most common source of `AttributeError`.

### Main classes

| Class | What it holds | Example |
|---|---|---|
| `date` | year, month, day only | `date(2026, 10, 12)` |
| `time` | hour, minute, second, microsecond (no date) | `time(9, 30)` |
| `datetime` | a date **and** a time together | `datetime(2026, 10, 12, 9, 30)` |
| `timedelta` | a **duration**, i.e. the difference between 2 dates/times | `timedelta(days=7)` |
| `timezone` | a fixed offset from UTC | `timezone.utc` |

#### Aware vs naive
- a **naive** object has no time zone info, it's just "9:30 on 12 Oct" with no idea where in the world.
- an **aware** object knows its time zone (has `tzinfo` set), so it is an exact moment in time.
- for our project (dates of transactions) naive `date` objects are enough.

**Gotcha:** naive and aware datetimes can't be compared or subtracted with each other, it raises a `TypeError`.

### ⭐ date

```python
from datetime import date

d = date(2026, 10, 12)          # year, month, day
today = date.today()

d.year, d.month, d.day          # 2026, 10, 12
d.weekday()                     # Monday = 0 ... Sunday = 6
d.isoweekday()                  # Monday = 1 ... Sunday = 7
d.isoformat()                   # '2026-10-12'
date.fromisoformat('2026-10-12')   # string -> date
d.replace(day=1)                # '2026-10-01', returns a NEW date (dates can't be changed)
```

- ⭐ **Focus:** `isoformat()` gives `YYYY-MM-DD`, which is the format SQL/PostgreSQL expects for a `DATE` column. `str(d)` gives the same thing.
- `weekday()` is useful for things like "more spending on weekends" (`d.weekday() >= 5`).

**Gotcha:** `date`, `datetime` and `timedelta` objects are **immutable**. `replace()` and arithmetic return a new object, so we have to save the result: `d = d.replace(day=1)`.

### datetime

```python
from datetime import datetime

now = datetime.now()                         # current local date and time
dt_obj = datetime(2026, 10, 12, 14, 30, 0)   # year, month, day, hour, minute, second
dt_obj.date()                                # -> date(2026, 10, 12)
dt_obj.time()                                # -> time(14, 30)
datetime.combine(date(2026, 10, 12), time(9, 0))   # date + time -> datetime
```

**Note:** `datetime.utcnow()` is deprecated (Python 3.12+). Use `datetime.now(timezone.utc)` instead, which gives an aware datetime.

### ⭐ timedelta

A **timedelta** is a duration (how long), not a point in time (when).

```python
from datetime import timedelta

delta = timedelta(weeks=2, days=50, hours=8, minutes=5,
                  seconds=27, milliseconds=29000, microseconds=10)
print(delta)                 # 64 days, 8:05:56.000010
delta.days                   # 64
delta.total_seconds()        # the whole duration as seconds (float)
```

- all arguments are optional and default to 0. They can be ints or floats, positive or negative.
- internally it only stores **days, seconds and microseconds**. Everything else is converted:
    - weeks → 7 days, hours/minutes → seconds, milliseconds → 1000 microseconds
    - that is why `weeks=2, days=50` prints as `64 days`, and `seconds=27` + `milliseconds=29000` (29 s) shows up as `:56`.

**Gotcha:** `delta.seconds` is **not** the total seconds, it is only the leftover seconds part (0 to 86399) after the days are taken out. Use `delta.total_seconds()` for the full duration.

#### ⭐ Date arithmetic

| Operation | Result | Example |
|---|---|---|
| `date + timedelta` | date | `date(2026, 1, 1) + timedelta(days=30)` → 2026-01-31 |
| `date - timedelta` | date | `today - timedelta(days=90)` → 90 days ago |
| `date - date` | timedelta | `(end - start).days` → number of days between them |
| `date < date`, `==`, etc. | bool | `if d <= end:` |

- ⭐ **Focus:** a random date in a range = start date + a random number of days:

```python
start = date(2026, 1, 1)
end = date(2026, 12, 31)
span = (end - start).days                          # 364
random_day = start + timedelta(days=random.randint(0, span))
```

**Gotcha:** timedelta has no `months` or `years`, because months have different lengths. For "same day next month" use `d.replace(month=d.month + 1)` (careful with December and day 31), or a library like `dateutil.relativedelta`.

**Gotcha:** `date + timedelta` only uses the **days** part, any hours/seconds are ignored.

### ⭐ Formatting and parsing: strftime / strptime

- **strftime** = string **f**rom time → turns a date into a string (format it).
- **strptime** = string **p**arse time → turns a string into a datetime (read it).

```python
d = date(2026, 10, 12)
d.strftime('%d/%m/%Y')        # '12/10/2026'
d.strftime('%b %d, %Y')       # 'Oct 12, 2026'
d.strftime('%A')              # 'Monday'

datetime.strptime('12/10/2026', '%d/%m/%Y')          # -> datetime(2026, 10, 12, 0, 0)
datetime.strptime('12/10/2026', '%d/%m/%Y').date()   # -> date(2026, 10, 12)
```

| Code | Meaning | Example |
|---|---|---|
| `%Y` | 4-digit year | 2026 |
| `%y` | 2-digit year | 26 |
| `%m` | month, zero-padded | 01 – 12 |
| `%d` | day of month, zero-padded | 01 – 31 |
| `%B` / `%b` | month name full / short | October / Oct |
| `%A` / `%a` | weekday name full / short | Monday / Mon |
| `%H` | hour (24-hour clock) | 00 – 23 |
| `%I` / `%p` | hour (12-hour clock) / AM-PM | 02 / PM |
| `%M` | minute | 00 – 59 |
| `%S` | second | 00 – 59 |
| `%j` | day of the year | 001 – 366 |

**Gotcha:** `%m` is month and `%M` is minute. Mixing them up gives wrong dates without any error.

**Gotcha:** `strptime` only exists on `datetime`, not on `date`. To get a date, parse with `datetime.strptime(...)` then call `.date()`. (For ISO strings `date.fromisoformat()` is simpler.)

**Note:** the format string must match the input exactly, otherwise `strptime` raises a `ValueError`.

## random

The **random** module creates **pseudo-random** numbers. They look random, but are produced by an algorithm (Mersenne Twister) from a starting value called the **seed**. The same seed always gives the same sequence of numbers.

**Gotcha:** never use `random` for passwords, tokens or anything security related, the output can be predicted. Use the **secrets** module for that.

### ⭐ seed

```python
import random

random.seed(42)
random.randint(1, 100)   # same number every time the script runs with seed 42
```

- ⭐ **Focus:** set the seed **once** at the top of the generator script. That way the fake data is the same every run, so query results (and bugs) can be reproduced. Change or remove the seed to get new data.
- with no seed, Python seeds from the system time/OS randomness, so each run is different.

**Note:** `rng = random.Random(42)` makes a separate generator with its own seed, so it doesn't affect (or get affected by) other code using the module-level functions.

### ⭐ Integers

| Function | Returns | End value included? |
|---|---|---|
| `randint(a, b)` | int from a to b | ✅ **both** a and b |
| `randrange(stop)` | int from 0 to stop - 1 | ❌ stop excluded |
| `randrange(start, stop, step)` | int from start to stop - 1, going up in step | ❌ stop excluded |

```python
random.randint(1, 6)          # dice roll: 1, 2, 3, 4, 5 or 6
random.randrange(10)          # 0 – 9
random.randrange(0, 101, 5)   # 0, 5, 10, ... 100
```

**Gotcha:** `randint` includes the end value, `randrange` doesn't (it works like `range()`). This is the most common off-by-one mistake with this module.

### ⭐ Floats

| Function | Returns |
|---|---|
| `random()` | float in `[0.0, 1.0)`, 1.0 is never returned |
| `uniform(a, b)` | float between a and b, every value equally likely |
| `gauss(mu, sigma)` | normal distribution (bell curve) around mean `mu` |
| `expovariate(lambd)` | exponential distribution, mean is `1 / lambd`. Lots of small values, a few big ones |
| `triangular(low, high, mode)` | between low and high, most values near `mode` |

```python
amount = round(random.uniform(5, 200), 2)   # e.g. 87.43
random.gauss(50, 10)                        # mostly 40 – 60
random.expovariate(1 / 5)                   # average around 5
```

- ⭐ **Focus:** money needs 2 decimal places, so always `round(x, 2)` the float.
- `uniform` is fine to start with, but real spending is not uniform. `expovariate`, `triangular` or `lognormvariate` give more realistic amounts (many small purchases, a few large ones).

**Gotcha:** `gauss` can return negative numbers. Clamp it, e.g. `max(0.5, random.gauss(20, 8))`.

### ⭐ Sequences

| Function | What it does | Changes the list? |
|---|---|---|
| `choice(seq)` | picks 1 random item | no |
| `choices(seq, weights=None, k=1)` | picks **k** items **with** replacement (repeats allowed), returns a list | no |
| `sample(seq, k)` | picks **k unique** items **without** replacement | no |
| `shuffle(lst)` | shuffles the list **in place** | ✅ yes |

```python
categories = ['Groceries', 'Rent', 'Transport', 'Dining']

random.choice(categories)                                   # 'Transport'
random.choices(categories, weights=[40, 5, 30, 25], k=3)    # ['Groceries', 'Dining', 'Groceries']
random.sample(categories, 2)                                # ['Rent', 'Dining']
```

- ⭐ **Focus:** `choices` with `weights` lets some items be picked more often than others. Above, Groceries is picked ~40% of the time and Rent ~5%. Weights don't need to add up to 100, they are relative.
- `choice` → 1 item (not a list); `choices` → always a list, even when `k=1`.

**Gotcha:** `shuffle` returns `None`. `lst = random.shuffle(lst)` loses the list, just call `random.shuffle(lst)` on its own line.

**Gotcha:** `weights` must be the same length as the sequence, otherwise `ValueError`. `sample` raises `ValueError` if `k` is bigger than the list.

## csv

**CSV** (Comma Separated Values) is the most common format for moving tabular data between programs, like spreadsheets and databases. The **csv** module handles the tricky parts for us, like values that contain commas or quotes.

### ⭐ Opening the file

```python
with open('transactions.csv', 'w', newline='', encoding='utf-8') as f:
    ...
```

- ⭐ **Focus:** always pass `newline=''` when opening a file for csv (reading or writing).
- `with` closes the file automatically, even if there is an error.
- mode `'w'` overwrites the file, `'a'` adds to the end, `'r'` reads.

**Gotcha:** without `newline=''`, on Windows the csv file gets an extra blank line between every row. The csv module writes its own line endings (`\r\n`), and Python would translate them again.

### Writing: csv.writer

Each row is a **list**.

```python
import csv

with open('transactions.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['id', 'date', 'amount', 'category'])     # header row
    writer.writerow([1, date(2026, 10, 12), 42.50, 'Groceries'])
    writer.writerows(rows)                                   # many rows at once (list of lists)
```

- values are converted with `str()`, so a `date` is written as `2026-10-12` and `None` is written as an empty field.

### ⭐ Writing: csv.DictWriter

Each row is a **dict**. Safer, because the column order comes from `fieldnames`, not from the order we build the row in.

```python
fieldnames = ['id', 'date', 'amount', 'category']

with open('transactions.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()                       # writes the fieldnames as the first row
    writer.writerow({'id': 1, 'date': '2026-10-12', 'amount': 42.5, 'category': 'Groceries'})
```

- ⭐ **Focus:** `DictWriter` + `writeheader()` is the cleanest way to write the generated data, and the header row lets PostgreSQL map columns when loading.
- keys missing from the dict are written as empty (`restval=''`).

**Gotcha:** a key in the dict that is **not** in `fieldnames` raises a `ValueError` (default `extrasaction='raise'`). Use `extrasaction='ignore'` to skip extra keys.

**Gotcha:** forgetting `writeheader()` gives a file with no column names.

### Reading: csv.reader and csv.DictReader

```python
with open('transactions.csv', newline='', encoding='utf-8') as f:
    reader = csv.reader(f)
    header = next(reader)          # first row, skip/save the header
    for row in reader:
        print(row)                 # ['1', '2026-10-12', '42.5', 'Groceries']

with open('transactions.csv', newline='', encoding='utf-8') as f:
    for row in csv.DictReader(f):  # uses the first row as keys
        print(row['amount'])       # '42.5'
```

**Gotcha:** everything read from a csv is a **string**, even numbers and dates. Convert them ourselves: `float(row['amount'])`, `date.fromisoformat(row['date'])`.

**Note:** the reader is an iterator, it can only be looped over once. Open the file again (or save rows to a list) to read it again.

### Formatting options (dialects)

The default format is `'excel'`: comma separated, `"` as the quote character, and only quotes fields that need it.

| Parameter | Default | Example use |
|---|---|---|
| `delimiter` | `','` | `delimiter='\t'` for tab separated (TSV), `';'` for some European exports |
| `quotechar` | `'"'` | character used to wrap fields containing the delimiter |
| `quoting` | `csv.QUOTE_MINIMAL` | `csv.QUOTE_ALL` quotes every field, `csv.QUOTE_NONNUMERIC` quotes all non-numbers |

```python
writer = csv.writer(f, delimiter=';', quoting=csv.QUOTE_ALL)
```

**Note:** a field like `Coffee, large` is written as `"Coffee, large"` automatically, so the comma doesn't break the columns. This is the main reason to use the csv module instead of `','.join(row)`.

## ⭐ Putting it together

A small version of the generator, using all 3 modules:

```python
import csv
import random
from datetime import date, timedelta

random.seed(42)

categories = ['Groceries', 'Rent', 'Transport', 'Dining', 'Utilities']
weights = [35, 2, 30, 25, 8]
start, end = date(2026, 1, 1), date(2026, 12, 31)
span = (end - start).days

with open('transactions.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['id', 'txn_date', 'amount', 'category'])
    writer.writeheader()
    for i in range(1, 501):
        writer.writerow({
            'id': i,
            'txn_date': (start + timedelta(days=random.randint(0, span))).isoformat(),
            'amount': round(random.uniform(2, 150), 2),
            'category': random.choices(categories, weights=weights)[0],
        })
```

**Note:** the file can then be loaded into PostgreSQL with `COPY transactions FROM '/path/transactions.csv' WITH (FORMAT csv, HEADER true);` (or `\copy` in psql for a file on our own machine).

**Gotcha:** `random.choices(...)` returns a list, so `[0]` is needed to get the single value out.
