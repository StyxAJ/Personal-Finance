## Week 1 (2026-10-06 – 2026-10-10)

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

## Week 2 (2026-10-12 – 2026-10-17)

2026-10-12 | 10:00 Python data | data/Notes.md + data/practice_a.py (Python docs) | datetime (date, timedelta, date arithmetic, strftime/strptime), random (seed, randint vs randrange, uniform/expovariate, choices with weights), csv (writer, DictWriter, newline='') | wrote data_eggs.csv with csv.writer using a custom delimiter and quotechar | confused: date() wants 3 ints, not a string

2026-10-12 | 16:00 DSA | LC 344 Reverse String | first used s.reverse(), then solved it with two pointers | learned: in-place = change the list you were given; s = s[::-1] only makes a new list | confused: two pointer logic (needed hint)

2026-10-12 | 20:00 Build | generate_data.py → clean.csv (600 rows) + raw.csv (618) 

2026-10-13 | 10:00 SQL | sql/w2_where.sql, 8 WHERE queries on 600 rows (PG docs: Querying a Table, IN, comparison operators, LIKE) | learned: AND runs before OR so brackets matter (160 vs 104), IN = shorter OR, BETWEEN includes both ends, LIKE is case-sensitive but ILIKE isn't, % = any chars and _ = one char, = NULL never matches so use IS NULL | confused: single vs double quotes ('Groceries' is a value, "Groceries" is a column name)

2026-10-13 | 16:00 DSA | LC 125 Valid Palindrome, two versions (if/elif + continue, then inner while loops) | learned: order of checks matters (skip non-alnum BEFORE comparing), inner loops need their own i < j guard or they run off the end (".," → IndexError), isalnum() covers spaces and punctuation, LeetCode ms is noise; judge by Big-O (both O(n) time, O(1) space) | confused: compared before skipping at first, so Panama failed; needed hint on check order

2026-10-13 | 20:00 DBMS | theory/dbms-03-normalisation.md (Wikipedia: Database normalization) + NotebookLM quiz | learned: 3 anomalies (update = same fact repeated in many rows, insert = can't add a category with no transactions, delete = losing the last row loses the category), 1NF = one value per field (no "food, weekend" lists), 2NF = no column depends on only part of a composite key (category_name depends only on category_id, not on (category_id, month)) | quiz: not recorded

2026-10-14 | 10:00 SQL | sql/w2_order_case.sql (8 queries) + sql/w2_wed_practice.sql (PG docs: Querying a Table, LIMIT and OFFSET, CASE) | learned: ORDER BY defaults to ascending (DESC for newest/largest), two-column ORDER BY sorts ties by the 2nd column, LIMIT/OFFSET = take N / skip N, DISTINCT removes duplicate rows across ALL selected columns, CASE = if/elif/else per row that makes a new column (first WHEN that matches wins, no ELSE gives NULL) | gotcha: LIMIT with ties is random → add a tie-breaker like id; 16 account-category pairs, not 20, because all monthly rows went to account 1

2026-10-14 | 16:00 DSA | LC 26 Remove Duplicates from Sorted Array | learned: same-direction two pointers (slow write + fast read) instead of opposite ends, k is a COUNT not a new list (in-place again), sorted array → duplicates sit next to each other so compare neighbours, write = index of last unique → return write + 1 | confused: mixed two methods (compare with nums[write] vs nums[i+1]) and lost values; started i at 1 so pair (0,1) was never checked → [1,2] failed; fixed by tracing [1,2] and [1,2,3] on paper

2026-10-14 | 20:00 Build | missed (busy); skipped per "don't double up" rule, 15-question file dropped

2026-10-15 | 10:00 SQL | sql/w2_aggregates.sql (8 queries) + sql/w2_thu_practice.sql (PG: Aggregate Functions) | learned: COUNT/SUM/AVG/MAX/MIN collapse many rows into one, GROUP BY makes one row per group, HAVING filters groups (sum/count/avg) while WHERE filters rows before grouping, both in one query = WHERE category 5–10 + HAVING avg > 200, ROUND(AVG(x), 2) for clean averages, GROUP BY doesn't sort → add ORDER BY | finding: Interest totals only ~464 AED/year so it drops out of HAVING sum > 2000


2026-10-15 | 16:00 DSA (done 22:30, minimum day) | LC 977 Squares of a Sorted Array | learned: squaring a sorted list with negatives puts the biggest values at both ends, so fill the result from the back instead of sorting (O(n) vs O(n log n)), left <= right because the last middle element still needs a slot | confused: first tried a swap-based sort (never incremented i, read past the end with i+1); needed the "biggest at the ends" hint

2026-10-15 | 20:00 DBMS (done 23:30, minimum day) | theory/dbms-03-normalisation.md: 3NF section + schema check | learned: 3NF = no non-key column depends on another non-key column (no transitive dependency), it's about the design not the data; my schema is 3NF because category/account facts live once and transactions link by id | finding: generated descriptions copy the category name = redundant data (renaming a category wouldn't update them), not a schema flaw | quiz skipped (minimum day)

2026-10-16 | 10:00 SQL | sql/w2_dates.sql (8 queries) + sql/w2_fri_practice.sql (PG: Date/Time Functions) | learned: EXTRACT pulls one part out (month = 10), date_trunc snaps a date to the start of its month/quarter (safe for grouping across years), ::date drops the 00:00:00, DATE - INTERVAL '30 days' for date ranges, isodow 6/7 = weekend, GROUP BY works on a CASE expression | finding: Nov 2025 was the biggest spending month (19382.64), which is why it was the loss month; weekday everyday spend is ~3x weekend | gotcha: forgot the spend filter (category_id >= 4) on #2–#4 so income was counted; non-aggregate column in SELECT without GROUP BY errors

2026-10-16 | 16:00 DSA | missed (out all night) → LC 167 moves into Saturday's redo slot

2026-10-16 | 20:00 Build | missed (out all night) → monthly report covered by Saturday self-test Q1

2026-10-17 | 10:00 Self-test (done 16:11) | sql/w2_selftest.sql | score: 3/5 (Q2 didn't show category_id + grouped by year instead of filtering 2026; Q3 listed all months instead of HAVING net < 0) | fixed both after marking | Mon: first 25 min = HAVING on expressions

2026-10-17 | 16:00 DSA | LC 167 Two Sum II (first attempt, replaced its own redo) | learned: sorted array means moving R left always shrinks the sum and moving L right always grows it, so one pass finds the pair in O(n) with O(1) space; answer is 1-based | solved alone (paper step first) | note: while True works only because one answer is guaranteed; use while L < R

2026-10-17 | 20:00 Wrap-up (done 16:48) | README written (Week 1 + 2), LC 125 redo from blank file, Week 3 read, merged via PR | week 2: 15 of 18 sessions (missed Wed C, Fri B + C; Thu B/D minimum) | self-test 3/5 → Mon first 25 min = HAVING redo

## Week 3 (2026-10-19 – 2026-10-24)

2026-10-19 | 10:00 SQL | sql/w3_having_redo.sql (5) + sql/w3_joins_practice.sql (4) (PG: Aggregate Functions, Joins Between Tables) | redo: self-test Q3 now correct from blank, HAVING on SUM(CASE) expressions done | learned: INNER JOIN matches rows on a key (t.category_id = c.id) to show names instead of ids, chain joins for 3 tables, aliases (t, c, a) + table prefixes avoid "ambiguous column" errors, AS renames clashing columns (c.name AS category, a.name AS account), GROUP BY works on joined columns | gotcha: "over" means > not >=; missing ; merges two statements

2026-10-19 | 16:00 DSA (done 20:20) | LC 217 Contains Duplicate, two versions (loop + set, and len(set) vs len(list)) (fCC: Hash Table & Set) | learned: a set stores unique values with O(1) lookup, so check-then-add in one loop is O(n); the same check on a list would be O(n²); the loop can stop early, the len() version can't | solved alone 

2026-10-19 | 20:00 Build | sql/project/joins.sql (5 queries) | learned: two INNER JOINs to get account + category names, GROUP BY two columns, filter by joined columns (c.type = 'expense', a.name = 'Credit Card'), proof query: per-account totals add up to the grand total (183769.18), so the joins didn't lose or duplicate rows | finding: Credit Card has no Rent (rent always from Main Checking) | reorganised repo: sql/project, sql/practice, dsa/week1-3

2026-10-21 | 10:00 SQL | sql/practice/w3_subqueries.sql (3 practice + 6 queries) (PG: Aggregate Functions, Subquery Expressions) | learned: scalar subquery = one value calculated first (needed because WHERE runs before aggregates exist), IN (SELECT …) = match against a list, EXISTS / NOT EXISTS = "is there at least one row?", correlated = inner query uses the outer row (t.category_id = c.id) | gotchas: = with a multi-row subquery errors → use IN; a scalar max can match many tied rows (12 salaries); overall average (642) is skewed by salary/rent, so only 43 rows are above it

2026-10-21 | 16:00 DSA | LC 1 Two Sum (fCC: Hash Table & Set) | learned: dict upgrades the set pattern, seen[number] = index so you can look up "the number I need" in O(1) and get its index back; the dict only holds the past, so a pair is found at its 2nd number; enumerate() gives index + value; trade memory (O(n) dict) for time (O(n) vs O(n²)) | needed hint: had key/value reversed and traced by looking ahead; bug: seen[nums] used the whole list as a key

2026-10-21 | 20:00 Build (started 23:45, minimum) | sql/project/subqueries.sql | learned: correlated subquery = inner query runs per outer row, linked by t2.category_id = t.category_id, so each transaction is compared to its OWN category's average (286 rows) | skipped: Aug-2026 NOT EXISTS (returns 0 rows, practised in the morning) | note: 3rd evening slip, fix the 20:00 slot on Saturday

2026-10-22 | 10:00 SQL (started 12:03) | sql/practice/w3_ctes.sql (2 rewrites + 3 queries) (PG: WITH Queries 7.8.1) | learned: WITH name AS (…) names a step so the main query reads like a table, several CTEs separated by commas, JOIN a CTE instead of a correlated subquery (each category's average calculated once), a CTE can be reused (months above the AVERAGE month needs totals first, then their average) | gotchas: never ROUND before comparing (228 vs 228.06), only for display; ORDER BY inside a CTE is pointless

2026-10-22 | 16:00 DSA (done 20:14) | LC 383 Ransom Note | learned: dict as a counter, .get(ch, 0) avoids KeyError for unseen keys, count what you HAVE first then spend it on what you NEED, return False the moment a count hits 0 | needed help

2026-10-22 | 20:00 DBMS | theory/dbms-04-acid.md (Wikipedia: ACID, PG: Transactions) + NotebookLM quiz | learned: Atomicity = all-or-nothing (a 500 AED transfer can't half-happen), Consistency = only valid states (constraints still hold), Isolation = unfinished changes are invisible to others, Durability = once committed, it survives a crash; BEGIN/COMMIT/ROLLBACK group steps into one transaction | quiz: 7/10 | note: moved here from Tue; isolation levels → W4 Thu

2026-10-24 | 10:00 SQL (done 20:00–20:57) | sql/practice/w3_left_join.sql (4) + sql/practice/w3_selftest.sql | learned: LEFT JOIN keeps every left row (NULLs where no match), COUNT(t.id) not COUNT(*) for zero counts, filter the right table in ON not WHERE (WHERE drops the NULL rows), COALESCE(x, 0) turns NULL into 0, test data inside BEGIN … ROLLBACK | self-test: 3/4 (Q3 not counted: used AI; redid it from memory after) | note: INNER JOIN matches any ON condition, not only PK/FK

2026-10-24 | 16:00 DSA (done 21:07–21:32) | LC 242 Valid Anagram (first attempt, replaced its own redo) | learned: it's LC 383 + a length check: equal lengths and no count going below 0 = perfect match | needed help: googled; lesson: check patterns.md for a similar problem before searching

2026-10-24 | 16:00 DSA (redo) | LC 1 Two Sum from memory | result: wrote a correct O(n²) brute force but couldn't recall the hash map version → ⭕ in patterns.md, redo again next Saturday | knew why two pointers fails (unsorted)

2026-10-24 | 20:00 Wrap-up | README Week 3, patterns.md review, Week 4 read | week 3: 13 of 18 sessions (missed Tue all, Fri all; Wed C minimum; Sat done 20:00–23:00) | self-test 3/4 | ⭕ LC 1 → redo next Saturday

## Week 4 (2026-10-26 – 2026-10-31)

2026-10-26 | 10:00 SQL (done 17:45–20:43, late shift) | sql/practice/w4_constraints.sql (6 predict-then-test) (PG: Constraints) | learned: FK blocks unknown ids and blocks deleting a referenced parent (default NO ACTION), NOT NULL, CHECK (type IN …), each test in its own BEGIN/ROLLBACK because one error aborts the whole transaction | predictions 6/6 | gaps found: no CHECK (amount > 0), no UNIQUE on categories.name | gotcha: sequences don't roll back → id gaps (604, 605, 11, 12 burned)

2026-10-26 | 16:00 DSA (done 20:45–21:20) | LC 121 Best Time to Buy and Sell Stock | learned: sliding window = L (buy) only jumps forward to a cheaper price, R (sell) scans every day, one pass O(n) | needed hint: i =+ 1 (not +=) looped forever, Tails didn't move in the else branch, i and Tails did the same job; skipped the paper trace again

2026-10-26 | 20:00 Build (done 21:45–22:30) | sql/project/schema_v2.sql | added CHECK positive_amount on transactions, UNIQUE unique_category_name on categories, new budgets table (PK, FK, CHECK positive_limit, UNIQUE (category_id, month)), 6 September 2026 budgets | proof: all 5 rejection tests fail with my named constraints | learned: ALTER TABLE ADD CONSTRAINT checks existing rows (fails if any break the rule); named constraints make errors readable; checked data before altering (600 rows, 385323.67)

2026-10-27 | 10:00 SQL (done 20:05–21:22, late shift) | sql/practice/w4_update_delete.sql (5 changes, all rolled back) (PG: Updates, Deletions) | learned: safe routine = SELECT the WHERE first → BEGIN → change → check → COMMIT/ROLLBACK; RETURNING * shows changed rows; renaming 1 category renamed it for all 109 transactions (3NF); positive_amount blocks UPDATE to 0 too; DELETE with no WHERE wiped 600 rows → ROLLBACK saved them | final check: 600 | 385323.67

2026-10-27 | 16:00 DSA (done 21:25–22:10) | LC 643 Maximum Average Subarray I | learned: fixed-size sliding window, new sum = old sum + entering number − leaving number, so each step is O(1); re-summing each window would be O(n·k); divide once at the end

2026-10-27 | 20:00 DBMS (minimum, done 23:50) | theory/dbms-05-indexes.md (PG: Indexes intro, B-tree) | learned: an index is a sorted lookup structure (B-tree) that jumps to matching rows instead of scanning every row; cost = slower INSERT/UPDATE/DELETE + extra disk; don't index every column | quiz skipped

2026-10-28 | all sessions | missed (interview day, overslept the planned night session) → index lab moved to Thu 20:00 (replaces DBMS review), LC 303 → W13, isolation levels → W11 Thu

2026-10-29 | A | window functions: AVG/COUNT OVER, PARTITION BY 2 columns, ROW_NUMBER/RANK/DENSE_RANK, top 2 per month via 2 CTEs → w4_windows.sql | learned: WHERE runs before window functions, so filter rank in an outer query | confused: semicolon inside CTE, forgot the 5–10 filter twice

2026-10-29 | B (late shift) | LC 724 Find Pivot Index ✅ | learned: the paper routine (table → compare rows → English steps → code); right = total − left − x; nums[-1] is the last element, not nothing | confused: started with pseudocode instead of a table; slice bounds [0:i-1] and [i+1:-1] were off by one

2026-10-29 | lab (late shift, minimum) | index lab: 200k rows, EXPLAIN ANALYZE before/after composite index → indexes.md | make_big.py (seed 42, 200,000 rows) → big.csv (gitignored) | before 30.421 ms (Parallel Seq Scan, ~197k rows removed by filter), after 1.208 ms (Bitmap Index Scan on idx_tb_cat_date) → ~25x | learned: equality column first, range column second in a composite index; use the 3rd run (cached) | confused: import generate_data runs the whole file (re-seeds, rewrites clean/raw.csv); append() takes one tuple, not 5 args; needed the CREATE TABLE/\copy code given

2026-10-31 | all sessions | missed (course deadline ran over) → SQL self-test → W13 SQL final, README SQL/ERD + CV line → W5 Sat S, LC 1 + 724 → W5 Sat B, LC 121 → W13 | lesson: declare a minimum day in advance when a deadline eats two days

## Week 5 (2026-11-02 – 2026-11-07)

2026-11-02 | A (14:25–15:20) | Excel: Get Data → From Text/CSV, Power Query (Use First Row as Headers, removed Changed Type so mess stays as text), Tables (tbl_raw 618 rows, Total Row, tbl_categories) → excel/finance_analysis.xlsx | mess found: 17 blank categories, 44 "AED" amounts, 22 DD/MM dates, 18 duplicates | confused: headers came in as data; auto type detection would have hidden the mess

2026-11-02 | B (late shift 21:45–22:40) | Stack class (push, pop, peek, is_empty) on a list → dsa/week5/stack.py | learned: top = END of the list so every operation is O(1); the speed comes from where the top is, not from LIFO itself; is_empty() only looks and doesn't change the list; raise IndexError on empty pop/peek | confused: thought the stack ops were O(n) at first; paper table step 7 showed [] instead of [1]

2026-11-02 | C (late shift 22:45–23:40) | Clean sheet: tbl_raw pasted as values → tbl_clean, PROPER(TRIM()) 103 spellings → 10 categories + 17 blanks, Remove Duplicates 618 → 600 | confused: pasted the formula instead of values over category → circular reference, fixed Tue morning

2026-11-03 | A (15:15–16:12, late) | Excel: fixed Monday's circular reference (paste values on B2:B601); amount → numbers in place, sum 385323.67 = SQL; txn_date → real dates in place, all 22 DD/MM correct, Groceries Mar 2026 = 2087.99 = SQL | learned: select inside a table with Ctrl+Space or the Name Box, not the sheet column; DATEVALUE would misread DD/MM on a US-format PC | confused: didn't write SUBSTITUTE/VALUE or DATE formulas yet → practise in Saturday self-test


2026-11-03 | B (late shift 21:20–22:15) | LC 20 Valid Parentheses ✅ → dsa/week5/20_valid_parentheses.py | learned: counting checks HOW MANY brackets, a stack checks the ORDER (most recent open bracket must close first = LIFO); dict maps closer → opener; check empty before pop; leftover openers = invalid | confused: started with counters, then popped without checking the match

2026-11-03 | D (late shift, full, 22:22–23:17) | OOP 1: Transaction class → theory/oop_transaction.py, notes → theory/oop-01.md | learned: class = blueprint, object = one instance with its own data, __init__ sets that data, self = the object the method was called on | confused: Python tutorial alone is too terse → added Real Python OOP to the notebook, Python Tutor to visualise objects | quiz → Thu D

2026-11-04 | A (14:20–15:00, late) | XLOOKUP: tbl_categories (id, name, type) → type column in tbl_clean with "Not found" fallback → 548 expense / 35 income / 17 Not found; tbl_accounts → account_name | learned: XLOOKUP = Excel's JOIN (lookup value, lookup column, return column, if not found); text in formulas needs "double quotes"; text "1" ≠ number 1 in a lookup; XLOOKUP vs VLOOKUP (exact match by default, looks left, no column numbers) | confused: left out the 4th argument (#N/A on 17 blanks), then wrote Not found without quotes

2026-11-04 | B (16:20–17:20) | LC 20 blank redo, Design B (opener → closer, push the expected closer) | learned: logic ≠ syntax, so translate English steps into Python with a vocabulary table; a dict only looks up key → value fast, so key it by what you're holding; "in stack" ≠ "on top" | blank redo needed level 3 (vocabulary table) | LC 232 → W13

2026-11-04 | C (minimum, 23:37–00:05) | finished cleaning tbl_clean: 17 blanks → Uncategorised (type: Extra expense, because the real type of a blank category is unknown), account_id → numbers | proof: 600 rows, 385323.67 = SQL | budget column → W6

2026-11-05 | A (12:20–13:20) | SUMIFS/COUNTIFS/COUNTIF on tbl_clean → Analysis sheet, all 5 checks match (Groceries Mar 2087.99, 8 rows, 91 over 500, Credit Card 62066.54 = SQL, expense 179905.19) | learned: SUMIFS = SUM ... WHERE ... AND (sum range first, then range/condition pairs); dates need two conditions on one column (">=" start, "<" next start); join operator and value with & | gap: 3863.99 vs SQL = expense rows that lost their category in raw.csv (Uncategorised) | bug: used "<=" April 1 in #1, fixed to "<"

2026-11-05 | B (19:45–20:40) | Stack class blank redo (structure right; missing return ×2, duplicate push, print instead of raise) + LC 155 Min Stack ✅ → dsa/week5/155_min_stack.py | learned: a single min variable forgets the old min when overwritten → keep a stack of mins; 0 is a real value, use float('inf') or None as "no value yet" | habits to fix: forgot return (None comes back), forgot () (gives the method, not its value), duplicate method name overwrites

2026-11-05 | D (minimum, 22:32–22:57) | OOP 2: encapsulation, Transaction.amount as a property that rejects 0 (ValueError) → theory/oop_transaction.py | quiz skipped (minimum) → W11 review

2026-11-06 | all sessions | missed (out all day) → LC 682 → W13, month × category grid covered by the W6 pivots

2026-11-07 | A (revision quiz, 16:11–17:10) | 15 closed-book questions from review-bank: 3 ✓ (S13, A11, P1), 9 partly, 3 ✗ (D1 ACID, S11 safe DELETE, X5 DATEVALUE) | learned: partly = core idea right, missing the example/formula/term; topics touched once and never again fade first | function moved to Sunday, so Saturday ran as revision

2026-11-07 | B (19:15–20:05) | blank redos: LC 1 Two Sum (dict, check before store) ✅ ~15 min, off ⭕ since W3; LC 155 Min Stack ✅ ~15 min, cleaner than Thursday (generic _peek/_is_empty, every return and () right) | learned: LeetCode runtime % is noise, judge by Big-O

2026-11-07 | S (Excel self-test, 20:10–20:35) | excel/w5_selftest.xlsx: 4/5 own work (XLOOKUP 548/35/17, Utilities Feb 2026 4990.51, over 500 = 91, 600 rows / 385323.67 = SQL) | Task 1 cleaning done by the Claude Excel add-in → scored 0; cleaning → review Box 1, retry in the W6 Sat self-test | learned: what I never typed myself I can't recall

## Week 6 (2026-11-09 – 2026-11-14)

2026-11-09 | A (14:45–15:20, after micro1 interview) | review: D1 ✓, X8 ✓, A3 partly | PivotTables → Pivot sheet: spend by category (type = expense only) = 179905.19 = SUMIFS; months × type grouped by Years + Months, income 201529.27 | learned: a pivot filter can silently include 2 items ("Multiple Items"); group by Months AND Years or months from different years merge and sort Jan-first | interview: lost on API key questions → primer today, properly in W8

2026-11-09 | B (19:45–21:15, ran over) | Stack blank redo + linked list → dsa/week6/linked_list.py (Node, append, prepend, to_list, length) | learned: head is a pointer, not a node; last node → None; prepend order matters (save the old head first or lose the list); stop ON the last node vs walk PAST it | used a syntax site; paper drawing missed None and head-as-pointer

2026-11-09 | C (minimum, 21:20–21:45) | Analysis sheet: pivot of month × category (expense), grand total 179905.19 matches SUMIFS and Pivot 1

2026-11-10 | A (10:55–11:40) | review: linked list ✓, S10 ✓, S15 ✓ (range beats EXTRACT: index-friendly) | pivots: % of Grand Total (Rent 33.35%, Utilities 20.16%), amount bands 0–1000 by 100 (count 600; most = ___ because ___; >1000 = ___), slicer on account type (Credit Card 62066.54 = SUMIFS, no income column because salary goes to Main Checking)

2026-11-10 | B (19:55–21:00, extended) | linked list redo (from memory; IndentationError on class methods) + LC 206 Reverse Linked List ✅ 28/28 | idea mine: reverse = keep prepending onto a new list; needed the box-and-arrow trace for the flip column (current.next = prev every step, not None) | learned: save → flip → move prev → move current; order matters (flip before save loses the list); don't name a param `list`; LeetCode uses .val and returns the head

2026-11-12 | minimum day (22:55–00:15) | A: PivotChart line of monthly expense (peak Nov 2025) | B: LC 141 Linked List Cycle ✅ (set of nodes, not values; idea mine) | D: Account tests (isinstance, polymorphic withdraw: savings refuses, current → −200) + TL;DR of the 4 pillars

2026-11-13 | all sessions | planned day off (graduation) → Dashboard → Sat S, Power Query cut (plan's first W6 cut), LC 876 → W13, ERD + CV line → W7 Sat S

2026-11-14 | late shift (birthday, started 21:00) | ...

2026-11-14 | A (self-test, 21:00–22:10) | w6_selftest.xlsx, own work: categories ✓, AED amounts ✓, all 22 DD/MM dates ✓ (converted via ___), XLOOKUP ✓, chart ✓ | missed: Remove Duplicates (618 rows, sum 391329.58 vs 385323.67 = 6005.91 of duplicates) and blanks → Uncategorised | lesson: always finish cleaning with the row count + sum check vs SQL