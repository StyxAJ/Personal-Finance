2026-10-06 | 10:00 SQL | SQLBolt 1-4 (on site) | WHERE filters rows, DISTINCT removes duplicate, ORDER BY sorts them, LIMIT reduced the number of rows, OFFSET moves the counts starting point | confused: LIKE vs = 

2026-10-06 | 16:00 DSA | Big-O in big_o.py | time complexity: constant O(c), linear O(n), Quadratic > nested loop = O(n²) | confused: why O(Yn) if Y is a constant then why do we ignore constant in linear time complex

2026-10-06 | 20:00 DBMS | unable to work on DBMS so it has been pushed to Thursday

2026-10-07 | 10:00 SQL | SQLBolt 5-8 (on site) | JOIN and NULL statements | confused: Outer JOIN 

2026-10-07 | 16:00 DSA | Time complexity during insert and append | confused: how to calculate and write snippets for time complexity

2026-10-07 | 20:00 Postgres | Worked on navigating postgres in vs code and made a database as well.

2026-10-08 | No progress, thus timeline for the week shifter by a day

2026-10-09 | 10:00 SQL | SQLBolt 9-12 (on site) | Query expressions, aggregates. Order of execution

2026-10-09 | 16:00 Leetcode | Leetcode(LC) 1480 Running Sum of 1d Array | used forloop to calculate and update running sun in a 1D array. | since i used for loop, the time complexity as expected was linear | things to look out for: translation of paper solution into code. 

2026-10-09 | 20:00 DBMS | dbms-01-basics.md, dbms-02-keys.md (Postgres docs + Wikipedia) | relation = table, cluster > database > table > row; superkey > candidate key > primary key, foreign key = referential integrity


2026-10-10 | 10:00 SQL | Notes.md for SQLBolt 13-18 | INSERT, UPDATE, DELETE, CREATE/ALTER/DROP TABLE, data types, table constraints | gotcha: always test the WHERE with a SELECT before UPDATE/DELETE

2026-10-10 | 16:00 Leetcode | LC 1929 Concatenation of Array | returned nums + nums, list concatenation builds the new array in one step | time complexity is linear O(n) since every element gets copied

2026-10-10 | 20:00 DBMS | sql/seed.sql | inserted 10 categories, 2 accounts and 20 transactions by hand, then ran it | proof: SELECT * FROM transactions; returns 20 rows

2026-10-12 | 10:00 Python data | data/Notes.md + data/practice_a.py (Python docs) | datetime (date, timedelta, date arithmetic, strftime/strptime), random (seed, randint vs randrange, uniform/expovariate, choices with weights), csv (writer, DictWriter, newline='') | wrote data_eggs.csv with csv.writer using a custom delimiter and quotechar | confused: date() wants 3 ints, not a string

2026-10-12 | 16:00 DSA | LC 344 Reverse String | first used s.reverse(), then solved it with two pointers | learned: in-place = change the list you were given; s = s[::-1] only makes a new list | confused: two pointer logic (needed hint)

2026-10-12 | 20:00 Build | generate_data.py → clean.csv (600 rows) + raw.csv (618) | learned: ... | confused: ...

2026-10-13 | 10:00 SQL | sql/w2_where.sql, 8 WHERE queries on 600 rows (PG docs: Querying a Table, IN, comparison operators, LIKE) | learned: AND runs before OR so brackets matter (160 vs 104), IN = shorter OR, BETWEEN includes both ends, LIKE is case-sensitive but ILIKE isn't, % = any chars and _ = one char, = NULL never matches so use IS NULL | confused: single vs double quotes ('Groceries' is a value, "Groceries" is a column name)

2026-10-13 | 16:00 DSA | LC 125 Valid Palindrome, two versions (if/elif + continue, then inner while loops) | learned: order of checks matters (skip non-alnum BEFORE comparing), inner loops need their own i < j guard or they run off the end (".," → IndexError), isalnum() covers spaces and punctuation, LeetCode ms is noise; judge by Big-O (both O(n) time, O(1) space) | confused: compared before skipping at first, so Panama failed; needed hint on check order

2026-10-13 | 20:00 DBMS | theory/dbms-03-normalisation.md (Wikipedia: Database normalization) + NotebookLM quiz | learned: 3 anomalies (update = same fact repeated in many rows, insert = can't add a category with no transactions, delete = losing the last row loses the category), 1NF = one value per field (no "food, weekend" lists), 2NF = no column depends on only part of a composite key (category_name depends only on category_id, not on (category_id, month)) | quiz: _/10, ✗ on: ___ | confused: ___

2026-10-14 | 10:00 SQL | sql/w2_order_case.sql (8 queries) + sql/w2_wed_practice.sql (PG docs: Querying a Table, LIMIT and OFFSET, CASE) | learned: ORDER BY defaults to ascending (DESC for newest/largest), two-column ORDER BY sorts ties by the 2nd column, LIMIT/OFFSET = take N / skip N, DISTINCT removes duplicate rows across ALL selected columns, CASE = if/elif/else per row that makes a new column (first WHEN that matches wins, no ELSE gives NULL) | gotcha: LIMIT with ties is random → add a tie-breaker like id; 16 account-category pairs, not 20, because all monthly rows went to account 1 | confused: ___

2026-10-14 | 16:00 DSA | LC 26 Remove Duplicates from Sorted Array | learned: same-direction two pointers (slow write + fast read) instead of opposite ends, k is a COUNT not a new list (in-place again), sorted array → duplicates sit next to each other so compare neighbours, write = index of last unique → return write + 1 | confused: mixed two methods (compare with nums[write] vs nums[i+1]) and lost values; started i at 1 so pair (0,1) was never checked → [1,2] failed; fixed by tracing [1,2] and [1,2,3] on paper

2026-10-14 | 20:00 Build | missed (busy); skipped per "don't double up" rule, 15-question file dropped

