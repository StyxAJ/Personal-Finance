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

2026-10-15 | 10:00 SQL | sql/w2_aggregates.sql (8 queries) + sql/w2_thu_practice.sql (PG: Aggregate Functions) | learned: COUNT/SUM/AVG/MAX/MIN collapse many rows into one, GROUP BY makes one row per group, HAVING filters groups (sum/count/avg) while WHERE filters rows before grouping, both in one query = WHERE category 5–10 + HAVING avg > 200, ROUND(AVG(x), 2) for clean averages, GROUP BY doesn't sort → add ORDER BY | finding: Interest totals only ~464 AED/year so it drops out of HAVING sum > 2000 | confused: ___


2026-10-15 | 16:00 DSA (done 22:30, minimum day) | LC 977 Squares of a Sorted Array | learned: squaring a sorted list with negatives puts the biggest values at both ends, so fill the result from the back instead of sorting (O(n) vs O(n log n)), left <= right because the last middle element still needs a slot | confused: first tried a swap-based sort (never incremented i, read past the end with i+1); needed the "biggest at the ends" hint

2026-10-15 | 20:00 DBMS (done 23:30, minimum day) | theory/dbms-03-normalisation.md: 3NF section + schema check | learned: 3NF = no non-key column depends on another non-key column (no transitive dependency), it's about the design not the data; my schema is 3NF because category/account facts live once and transactions link by id | finding: generated descriptions copy the category name = redundant data (renaming a category wouldn't update them), not a schema flaw | quiz skipped (minimum day)

2026-10-16 | 10:00 SQL | sql/w2_dates.sql (8 queries) + sql/w2_fri_practice.sql (PG: Date/Time Functions) | learned: EXTRACT pulls one part out (month = 10), date_trunc snaps a date to the start of its month/quarter (safe for grouping across years), ::date drops the 00:00:00, DATE - INTERVAL '30 days' for date ranges, isodow 6/7 = weekend, GROUP BY works on a CASE expression | finding: Nov 2025 was the biggest spending month (19382.64), which is why it was the loss month; weekday everyday spend is ~3x weekend | gotcha: forgot the spend filter (category_id >= 4) on #2–#4 so income was counted; non-aggregate column in SELECT without GROUP BY errors

2026-10-16 | 16:00 DSA | missed (out all night) → LC 167 moves into Saturday's redo slot

2026-10-16 | 20:00 Build | missed (out all night) → monthly report covered by Saturday self-test Q1

2026-10-17 | 10:00 Self-test (done 16:11) | sql/w2_selftest.sql | score: 3/5 (Q2 didn't show category_id + grouped by year instead of filtering 2026; Q3 listed all months instead of HAVING net < 0) | fixed both after marking | Mon: first 25 min = HAVING on expressions

2026-10-17 | 16:00 DSA | LC 167 Two Sum II (first attempt, replaced its own redo) | learned: sorted array means moving R left always shrinks the sum and moving L right always grows it, so one pass finds the pair in O(n) with O(1) space; answer is 1-based | solved alone (paper step first) | note: while True works only because one answer is guaranteed; use while L < R

2026-10-17 | 20:00 Wrap-up (done 16:48) | README written (Week 1 + 2), LC 125 redo from blank file, Week 3 read, merged via PR | week 2: 15 of 18 sessions (missed Wed C, Fri B + C; Thu B/D minimum) | self-test 3/5 → Mon first 25 min = HAVING redo

2026-10-19 | 10:00 SQL | sql/w3_having_redo.sql (5) + sql/w3_joins_practice.sql (4) (PG: Aggregate Functions, Joins Between Tables) | redo: self-test Q3 now correct from blank, HAVING on SUM(CASE) expressions done | learned: INNER JOIN matches rows on a key (t.category_id = c.id) to show names instead of ids, chain joins for 3 tables, aliases (t, c, a) + table prefixes avoid "ambiguous column" errors, AS renames clashing columns (c.name AS category, a.name AS account), GROUP BY works on joined columns | gotcha: "over" means > not >=; missing ; merges two statements

2026-10-19 | 16:00 DSA (done 20:20) | LC 217 Contains Duplicate, two versions (loop + set, and len(set) vs len(list)) (fCC: Hash Table & Set) | learned: a set stores unique values with O(1) lookup, so check-then-add in one loop is O(n); the same check on a list would be O(n²); the loop can stop early, the len() version can't | solved alone 

2026-10-19 | 20:00 Build | sql/project/joins.sql (5 queries) | learned: two INNER JOINs to get account + category names, GROUP BY two columns, filter by joined columns (c.type = 'expense', a.name = 'Credit Card'), proof query: per-account totals add up to the grand total (183769.18), so the joins didn't lose or duplicate rows | finding: Credit Card has no Rent (rent always from Main Checking) | reorganised repo: sql/project, sql/practice, dsa/week1-3

2026-10-21 | 10:00 SQL | sql/practice/w3_subqueries.sql (3 practice + 6 queries) (PG: Aggregate Functions, Subquery Expressions) | learned: scalar subquery = one value calculated first (needed because WHERE runs before aggregates exist), IN (SELECT …) = match against a list, EXISTS / NOT EXISTS = "is there at least one row?", correlated = inner query uses the outer row (t.category_id = c.id) | gotchas: = with a multi-row subquery errors → use IN; a scalar max can match many tied rows (12 salaries); overall average (642) is skewed by salary/rent, so only 43 rows are above it

2026-10-21 | 16:00 DSA | LC 1 Two Sum (fCC: Hash Table & Set) | learned: dict upgrades the set pattern, seen[number] = index so you can look up "the number I need" in O(1) and get its index back; the dict only holds the past, so a pair is found at its 2nd number; enumerate() gives index + value; trade memory (O(n) dict) for time (O(n) vs O(n²)) | needed hint: had key/value reversed and traced by looking ahead; bug: seen[nums] used the whole list as a key

2026-10-21 | 20:00 Build (started 23:45, minimum) | sql/project/subqueries.sql | learned: correlated subquery = inner query runs per outer row, linked by t2.category_id = t.category_id, so each transaction is compared to its OWN category's average (286 rows) | skipped: Aug-2026 NOT EXISTS (returns 0 rows, practised in the morning) | note: 3rd evening slip, fix the 20:00 slot on Saturday

2026-10-22 | 10:00 SQL (started 12:03) | sql/practice/w3_ctes.sql (2 rewrites + 3 queries) (PG: WITH Queries 7.8.1) | learned: WITH name AS (…) names a step so the main query reads like a table, several CTEs separated by commas, JOIN a CTE instead of a correlated subquery (each category's average calculated once), a CTE can be reused (months above the AVERAGE month needs totals first, then their average) | gotchas: never ROUND before comparing (228 vs 228.06), only for display; ORDER BY inside a CTE is pointless

2026-10-22 | 16:00 DSA (done 20:14) | LC 383 Ransom Note | learned: dict as a counter, .get(ch, 0) avoids KeyError for unseen keys, count what you HAVE first then spend it on what you NEED, return False the moment a count hits 0 | needed help

2026-10-22 | 20:00 DBMS | theory/dbms-04-acid.md (Wikipedia: ACID, PG: Transactions) + NotebookLM quiz | learned: Atomicity = all-or-nothing (a 500 AED transfer can't half-happen), Consistency = only valid states (constraints still hold), Isolation = unfinished changes are invisible to others, Durability = once committed, it survives a crash; BEGIN/COMMIT/ROLLBACK group steps into one transaction | quiz: 7/10, ✗ on: ___ | note: moved here from Tue; isolation levels → W4 Thu

2026-10-24 | 10:00 SQL (done 20:00–20:57) | sql/practice/w3_left_join.sql (4) + sql/practice/w3_selftest.sql | learned: LEFT JOIN keeps every left row (NULLs where no match), COUNT(t.id) not COUNT(*) for zero counts, filter the right table in ON not WHERE (WHERE drops the NULL rows), COALESCE(x, 0) turns NULL into 0, test data inside BEGIN … ROLLBACK | self-test: 3/4 (Q3 not counted: used AI; redid it from memory after) | note: INNER JOIN matches any ON condition, not only PK/FK

2026-10-24 | 16:00 DSA (done 21:07–21:32) | LC 242 Valid Anagram (first attempt, replaced its own redo) | learned: it's LC 383 + a length check: equal lengths and no count going below 0 = perfect match | needed help: googled; lesson: check patterns.md for a similar problem before searching

2026-10-24 | 16:00 DSA (redo) | LC 1 Two Sum from memory | result: wrote a correct O(n²) brute force but couldn't recall the hash map version → ⭕ in patterns.md, redo again next Saturday | knew why two pointers fails (unsorted)

2026-10-24 | 20:00 Wrap-up | README Week 3, patterns.md review, Week 4 read | week 3: 13 of 18 sessions (missed Tue all, Fri all; Wed C minimum; Sat done 20:00–23:00) | self-test 3/4 | ⭕ LC 1 → redo next Saturday