# SQL Notes

## Index

### Contents

- [SELECT queries](#select-queries)
- [Queries with constraints (WHERE)](#queries-with-constraints) · [operators tables](#where-conditions) · [WHERE in depth](#where-in-depth)
- [Filtering and sorting](#filtering-and-sorting-query-results) · [DISTINCT](#distinct) · [ORDER BY](#order-by) · [LIMIT and OFFSET](#limit-and-offset) · [Sorting and CASE](#sorting-and-case)
- [JOINs](#multi-table-queries-with-joins) · [normalization](#database-normalization) · [INNER JOIN](#inner-join) · [OUTER JOIN](#outer-join) · [NULL](#null)
- [Queries](#queries)
  - [Expressions and aliases](#queries-with-expressions)
  - [Aggregates](#queries-with-aggregates) · [GROUP BY](#grouped-aggregate-functions) · [HAVING](#having) · [Aggregates and GROUP BY](#aggregates-and-group-by) · [Aggregates in depth](#aggregates-in-depth) · [FILTER](#filter)
  - [Subqueries](#subqueries) · [EXISTS](#exists) · [IN / NOT IN](#in-and-not-in) · [ANY / ALL](#any--some-and-all)
  - [WITH queries (CTEs)](#with-queries-ctes) · [WITH RECURSIVE](#with-recursive)
  - [Window functions](#window-functions) · [PARTITION BY](#partition-by) · [running totals](#window-frames-running-totals) · [top N per group](#filtering-on-a-window-result)
  - [Order of execution](#order-of-execution-of-a-query)
- [INSERT](#inserting-rows) · [UPDATE](#updating-rows) · [DELETE](#deleting-rows)
- [CREATE TABLE](#creating-tables) · [data types](#data-types) · [ALTER TABLE](#altering-tables) · [DROP TABLE](#dropping-tables)
- [Dates and times](#dates-and-times-postgresql) · [EXTRACT](#extract) · [date_trunc](#date_trunc) · [intervals](#date-arithmetic-with-intervals)
- [Constraints](#constraints-postgresql) · [CHECK](#check) · [NOT NULL](#not-null) · [UNIQUE](#unique) · [PRIMARY KEY](#primary-key) · [FOREIGN KEY](#foreign-key-references) · [ON DELETE](#on-delete--on-update) · [EXCLUDE](#exclude)

### Quick lookup

| I want to… | Go to |
|---|---|
| filter rows | [WHERE](#where-in-depth) |
| match text / patterns (LIKE, ILIKE) | [text operators](#text-data) |
| check for missing values | [NULL](#null) |
| sort, take top n, page through results | [ORDER BY](#order-by), [LIMIT and OFFSET](#limit-and-offset) |
| make an if/else column | [CASE](#sorting-and-case) |
| count / sum / average per group | [Aggregates and GROUP BY](#aggregates-and-group-by) |
| filter groups | [HAVING](#having), [WHERE vs HAVING](#where-vs-having) |
| count only some rows inside an aggregate | [FILTER](#filter) |
| keep every row but add a group total next to it | [PARTITION BY](#partition-by) |
| running total / rank / top n per group | [Window functions](#window-functions) |
| combine 2 tables | [JOINs](#join-statements), [LEFT JOIN gotchas](#outer-join) |
| use one query's result inside another | [Subqueries](#subqueries), [CTEs](#with-queries-ctes) |
| group by month / weekday | [EXTRACT vs date_trunc](#extract-vs-date_trunc-for-grouping) |
| "last 30 days" | [intervals](#date-arithmetic-with-intervals) |
| change or remove rows safely | [UPDATE](#updating-rows), [DELETE](#deleting-rows) |
| stop bad data getting in | [Constraints](#constraints-postgresql) |
| know why an alias doesn't work in WHERE | [Order of execution](#order-of-execution-of-a-query) |

## SELECT queries

A **SELECT** statement (also called a query) is used to pull data out of the database. In the query we say what data we want, where to find it, and optionally how to transform it before it is returned.

A table is like a category of things (e.g. Dogs):
- each **row** is one instance of that thing (one dog)
- each **column** is a property that every instance has in common (name, breed, age)

### SELECT statements
- **SELECT** picks which columns to show; **FROM** picks the table
- the result is a new 2D table (rows and columns) that is a copy of the original table, holding only the columns we asked for

```sql
SELECT column, another_column, …
FROM mytable;
```
- in the above Query we specify which column or property we want to look at

```sql
SELECT * 
FROM mytable;
```
- where "*" is used to pull all the columns in the table. Useful for a quick look at a table.

**Note:** SQL keywords don't have to be in capitals, but by convention we write them in capitals so that it is easy to tell keywords apart from the column and table names.

## Queries with constraints

When we have tables with thousands or millions or billions of rows, reading through all of it is slow and impractical. Thus, in order to filter certain results from being returned, we need to use a **WHERE** clause in the query. The clause is applied to each row of data by checking specific column values to determine whether it should be included in the results or not.

### WHERE statements
- When we need to constrain or filter data, we use **WHERE** to add conditions.
    - Writing clauses to constrain the set of rows returned also allows the query to run faster due to the reduction in unnecessary data being returned.
    - More complex clauses can be constructed by joining numerous AND or OR logical keywords.
    - SQL supports a number of useful operators to do things like case-insensitive string comparison and wildcard pattern matching.

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition
    AND/OR another_condition
    AND/OR …;
```

**Gotcha:** AND runs before OR (like * before + in maths). So `a AND b OR c` is read as `(a AND b) OR c`, and the condition `a` only applies to the first half. Always use brackets when mixing AND and OR, or use IN when it's the same column.

```sql
-- ❌ returns category 9 rows from ANY account, not just account 2
SELECT * FROM transactions
WHERE account_id = 2 AND category_id = 7 OR category_id = 9;

-- ✅ brackets make account_id = 2 apply to both categories
SELECT * FROM transactions
WHERE account_id = 2 AND (category_id = 7 OR category_id = 9);

-- ✅ same thing, shorter
SELECT * FROM transactions
WHERE account_id = 2 AND category_id IN (7, 9);
```

### WHERE conditions

#### Numerical data

| Operator | Condition | Example (PostgreSQL) |
|---|---|---|
| `=`, `!=`, `<`, `<=`, `>`, `>=` | Standard comparisons | `amount != 4` |
| `BETWEEN … AND …` | Within a range (inclusive) | `amount BETWEEN 1.5 AND 10.5` |
| `NOT BETWEEN … AND …` | Outside a range (the 2 end values are not included) | `amount NOT BETWEEN 1 AND 10` |
| `IN (…)` | Value is in a list | `id IN (2, 4, 6)` |
| `NOT IN (…)` | Value is not in a list | `id NOT IN (1, 3, 5)` |

#### Text data

| Operator | Condition | Example (PostgreSQL) |
|---|---|---|
| `=` | Exact string match (case-sensitive) | `name = 'abc'` |
| `!=` or `<>` | Exact string mismatch (case-sensitive) | `name != 'abcd'` |
| `LIKE` | Pattern match, **case-sensitive** in Postgres | `name LIKE 'ABC%'` |
| `ILIKE` | Pattern match, case-insensitive (Postgres only) | `name ILIKE 'abc%'` |
| `NOT LIKE` | Pattern doesn't match | `name NOT LIKE 'ABCD'` |
| `%` | Any run of 0+ characters (with LIKE) | `'%AT%'` → AT, ATTIC, CAT, BATS |
| `_` | Exactly one character (with LIKE) | `'AN_'` → AND, but not AN |
| `IN (…)` | String is in a list | `name IN ('A', 'B', 'C')` |
| `NOT IN (…)` | String is not in a list | `name NOT IN ('D', 'E', 'F')` |

**Gotcha:** all strings must be in quotes so that the database can tell the words in the string apart from SQL keywords.

**Gotcha:** SQLBolt uses SQLite, where LIKE is case-insensitive. In PostgreSQL, strings need single quotes ('abc'), and LIKE is case-sensitive, so use ILIKE for case-insensitive matching.

**Gotcha:** while "=" compares the whole exact values, "LIKE" compares patterns, where wildcards such as "%" and "_" are used to broaden the search for the data. Without a wildcard, "LIKE" acts exactly as "="

**Note:** these operators are fine for normal filtering, but for full-text search (searching through large amounts of text) dedicated tools like Apache Lucene or Sphinx are used instead.

### WHERE in depth

**Does:** filters rows, using AND, OR, IN, BETWEEN, LIKE/ILIKE and IS NULL.

**Pattern:**

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition AND (a OR b);
```

**My example:** query #2 from w2_where.sql, Dining Out (7) or Entertainment (9), only on the Credit Card (account 2).

```sql
SELECT * FROM transactions
WHERE (category_id = 7 OR category_id = 9) AND account_id = 2;
```

**Gotcha:** without brackets, AND runs before OR, so `category_id = 7 OR category_id = 9 AND account_id = 2` gives 160 rows instead of 104 (account_id = 2 only applies to category 9).

**Gotcha:** 'text' uses single quotes, while "name" with double quotes means a column. SQLBolt (SQLite) let us get away with double quotes for strings, Postgres won't.

**Gotcha:** in LIKE, `_` matches exactly one character and `%` matches any number of characters. Without `%`, `ILIKE 'out'` only matches the exact word "out".

**Gotcha:** `= NULL` never matches anything, use `IS NULL`.

**Gotcha:** BETWEEN includes both ends, so `amount BETWEEN 100 AND 200` keeps 100 and 200 too.

## Filtering and sorting Query results

**Gotcha:** In SQL when we filter and sort queries, we don't need to SELECT the column being filtered/sorted on. i.e, we just want to see 2 columns and the 3rd column is not needed to view but is necessary for filter/sorting.

### DISTINCT
Data in the database may be unique, but the results of some queries may not be. There are times when the database holds the same data in different rows (e.g. many movies released in the same year). So in order to discard rows that have duplicate column values, SQL provides a keyword for such a function, called **DISTINCT**.
- DISTINCT keyword will blindly remove duplicate rows
- it removes rows where all the selected columns match, not just one column.
- to remove duplicates based on specific columns, we use grouping with **GROUP BY** (see Grouped aggregate functions below)

```sql
SELECT DISTINCT column, another_column, …
FROM mytable
WHERE condition(s);
```

### ORDER BY
Most data in real databases is added in no particular order. As a result, it can be difficult to read through and understand the results of a query as the size of a table increases to thousands or even millions rows.
- SQL provides a way to sort your results by a given column in ascending or descending order using the ORDER BY clause.
    - ASC is for ascending
    - DESC is for descending
    - Each row is sorted alpha-numerically based on the specified column's value.
    - we can sort by more than one column, e.g. `ORDER BY year DESC, title ASC`
- some databases also let us set a **collation**, which sorts text better when it has international characters.

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC;
```

### LIMIT and OFFSET
When we work with large databases, the results are often large enough that it gets inefficient to read them. So we use **LIMIT** to reduce the number of rows that is returned. While we can use **OFFSET** to specify where to begin the count for number of rows from.
- LIMIT and OFFSET are often used together with ORDER BY, e.g. websites like Reddit or news sites show results page by page, only pulling the rows needed for that page.
- LIMIT and OFFSET are applied after the rest of the query is done (see Order of execution of a Query below).

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

Example, page 2 of movie titles in alphabetical order (5 per page):

```sql
SELECT title
FROM movies
ORDER BY title ASC
LIMIT 5 OFFSET 5;
```

Examples: Refer lesson 4 of sqlbolt file

### Sorting and CASE

**Does:** ORDER BY sorts the result, LIMIT keeps only the first n rows, DISTINCT drops duplicate rows, and CASE builds a new column whose value depends on a condition (an if/else for each row).

**Pattern:**

```sql
SELECT column,
    CASE WHEN condition THEN 'label_a'
         ELSE 'label_b'
    END AS label_column
FROM mytable
ORDER BY column DESC, another_column
LIMIT n;
```

**My example:** query #7 from w2_order_case.sql, labels each transaction 'BIG' if it's over 500, else 'SMALL'.

```sql
SELECT category_id, amount, description,
    CASE WHEN amount > 500 THEN 'BIG'
         ELSE 'SMALL'
    END AS amount_size
FROM transactions;
```

**Gotcha:** ORDER BY without DESC is ascending, smallest first. So `ORDER BY amount LIMIT 1` gives the smallest transaction, and we need `ORDER BY amount DESC` for the largest. With 2 columns, each one needs its own DESC: `ORDER BY txn_date, amount DESC` is oldest date first, then largest amount first within each date.

**Gotcha:** CASE belongs in SELECT, not WHERE. It makes a label column; to filter rows, just write the condition in WHERE (`WHERE amount > 500`). We also can't filter on the CASE alias (`WHERE amount_size = 'BIG'` errors), because WHERE runs before SELECT.

**Gotcha:** DISTINCT applies to the whole row, not just the first column. `SELECT DISTINCT account_id, category_id` keeps every different pair, so the same account_id can still show up many times.

**Gotcha:** without ORDER BY, LIMIT returns whichever rows Postgres finds first, which can change between runs. Always sort before using LIMIT.

**Gotcha:** CASE without an ELSE gives NULL for the rows that match no WHEN.

Docs: [LIMIT and OFFSET](https://www.postgresql.org/docs/current/queries-limit.html), [CASE](https://www.postgresql.org/docs/current/functions-conditional.html#FUNCTIONS-CASE), [SELECT tutorial](https://www.postgresql.org/docs/current/tutorial-select.html)

## Multi-table queries with JOINs

Data and data-sets in the real world are often broken down into pieces and stored across multiple separate tables using a process known as normalization.
- this keeps duplicate data in each table to a minimum, and lets each table grow independently of the others
- the trade-off is that queries get more complex, as they have to pull data from different parts of the database, and having many large tables can slow things down

### Database normalization

Normalization is the process of organizing the columns (attributes) and tables (relations) of a database to ensure that their dependencies are properly enforced by database integrity constraints. It is accomplished by applying some formal rules either by a process of synthesis (creating a new database design) or decomposition (improving an existing database design).

Normalization is based on functional dependencies. When we use functional dependencies, we break a table into multiple tables that help us prevent duplicate data and hence improve data quality, with fewer errors and better database design.

#### Dependency
Dependency is when a column (attribute or set of attributes) holds unique values and is used to determine the value of another column (an attribute of the same table, or of a different table that also holds attributes from the first table)

X → Y

Here, X is the determinant, and Y is the dependent attribute. This means that for each unique value of X, there is precisely one corresponding value of Y.

- Basically 2 tables have same attributes and we use them as a link to pull necessary values from either tables.

#### Normal Forms

Normal forms are a set of progressive rules (or design checkpoints) for relational schemas that reduce redundancy and prevent data anomalies. Each normal form ( 1NF, 2NF, 3NF, BCNF, 4NF, 5NF ) is stricter than the previous one: meeting a higher normal form implies the lower ones are satisfied.

refer for more detail: https://www.geeksforgeeks.org/dbms/normal-forms-in-dbms/
**Note:** come back when more clarity is needed as normal forms are quite long need more in depth study later.

### JOIN statements
Tables that share information on a single entity need to have a __primary key__ that identifies that entity uniquely across the database.
**Note:** One common primary key type is an auto-incrementing integer (because they are space efficient), but it can also be a string, hashed value, so long as it is unique.

we use **JOIN** clause to join 2 separate table rows using the unique key that acts as a merge point. 

Thus after JOIN we get 1 big table, after which we can use the usual filter/sorting and other clauses.

#### INNER JOIN

The INNER JOIN is the process where rows are matched from the first table and the second table which have the same key (as defined by the ON constraint) to create a result row with the combined columns from both tables. After the tables are joined, the other clauses we learned previously are then applied.

```sql
SELECT column, another_table_column, …
FROM mytable
INNER JOIN another_table 
    ON mytable.id = another_table.id
WHERE condition(s)
ORDER BY column, … ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

**Gotcha:** INNER JOIN might not be sufficient in some cases because the resulting table only contains data that belongs in both of the tables.

**Note:** some queries write INNER JOIN as just JOIN. Both are the same, but writing INNER JOIN makes it clearer once we start using the other (outer) joins.

#### OUTER JOIN

If the two tables have asymmetric data, which will easily happen when data is entered in different stages, then we would have to use a LEFT JOIN, RIGHT JOIN or FULL JOIN instead to ensure that the data you need is not left out of the results.

```sql
SELECT column, another_column, …
FROM mytable
INNER/LEFT/RIGHT/FULL JOIN another_table 
    ON mytable.id = another_table.matching_id
WHERE condition(s)
ORDER BY column, … ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

- INNER/LEFT/RIGHT/FULL JOIN
    When joining table A to table B:
    - a LEFT JOIN simply includes rows from A regardless of whether a matching row is found in B.
    - a RIGHT JOIN includes rows in B regardless of whether a match is found in A.
    - a FULL JOIN simply means that rows from both tables are kept, regardless of whether a matching row exists in the other table.
- just like INNER JOIN, these joins also need the ON constraint to say which columns to join on.

**Gotcha:** outer joins will often give NULL values in the result, for the rows that had no match in the other table. These need extra care when filtering or reading the results (see NULL below).

**Gotcha:** after a join, GROUP BY the columns of the table we're reporting on, not the foreign key from the other table. `SELECT c.name … GROUP BY t.category_id` errors ("c.name must appear in the GROUP BY clause"), even though they match one-to-one, because Postgres can't tell. `GROUP BY c.id, c.name` works (grouping by a primary key lets us select any other column from that table). With a LEFT JOIN it also matters for correctness: an unmatched row has `t.category_id = NULL`, so grouping on the `t.` column loses the link back to its category.

**Gotcha:** with a LEFT JOIN, use `COUNT(t.id)`, not `COUNT(*)`. An unmatched category still has 1 joined row (all NULLs on the `t.` side), so `COUNT(*)` shows Education as 1. `COUNT(t.id)` skips NULLs and gives 0.

**Gotcha:** a filter on the right table in WHERE turns a LEFT JOIN back into an INNER JOIN. WHERE runs after the join, and the unmatched rows have `t.txn_date = NULL`, so `WHERE EXTRACT(month FROM t.txn_date) = 9` drops them. Conditions on the right table go in ON (they only decide which rows get matched), conditions on the left table go in WHERE (`WHERE c.type = 'expense'`).

```sql
SELECT c.name, COALESCE(SUM(t.amount), 0) AS spend
FROM categories c
LEFT JOIN transactions t
  ON t.category_id = c.id
 AND t.txn_date >= '2026-09-01'
 AND t.txn_date <  '2026-10-01'
WHERE c.type = 'expense'
GROUP BY c.id, c.name
ORDER BY c.id;
```

**Gotcha:** SUM (and AVG, MAX, …) over only NULLs gives NULL, not 0. Wrap it in `COALESCE(SUM(t.amount), 0)` to show 0.00 for categories with no transactions.

**Gotcha:** a LEFT JOIN only gives extra rows if some left row has no match. My first run gave 10 rows for both INNER and LEFT, because the seed has no Education category, so every category had transactions. If the row counts match, check the data before the query.

**Note:** we may also see LEFT OUTER JOIN, RIGHT OUTER JOIN or FULL OUTER JOIN. The OUTER keyword is only kept for SQL-92 compatibility, they are the same as LEFT JOIN, RIGHT JOIN and FULL JOIN.

### NULL

A NULL value represents an unknown, missing, or inapplicable data in a database field. It is not a value itself, but a placeholder to indicate the absence of data.
- it's good to keep NULL values in the database to a minimum, as they need special handling in queries, constraints (some functions behave differently with NULL) and when processing the results.
- instead of NULL we can use a default value that fits the data type, e.g. 0 for numbers or an empty string '' for text.
- but NULL is the better choice when a default value would mess up later analysis, e.g. when taking the AVG of numbers, putting 0 in place of missing data would drag the average down.
- sometimes NULLs can't be avoided, like with outer joins on asymmetric data.
- to test for NULL we will have to use the IS NULL and IS NOT NULL operators.

**Gotcha:** `= NULL` and `!= NULL` don't work, since NULL is not a value, nothing is ever "equal" to it. Always use IS NULL / IS NOT NULL.

```sql
SELECT column, another_column, …
FROM mytable
WHERE column IS/IS NOT NULL
AND/OR another_condition
AND/OR …;
```

## Queries

### Queries with expressions 

Apart from querying and referencing raw column data with SQL, expressions can be used to write more complex logic on column values in a query. These expressions can use mathematical and string functions along with basic arithmetic to transform values when the query is executed. 

```sql
SELECT particle_speed / 2.0 AS half_particle_speed
FROM physics_data
WHERE ABS(particle_position) * 10.0 > 500;
```

- expressions can be used both in the SELECT part and in the WHERE part of the query (like in the above example).

Use of expressions can save time and extra post-processing of the result data, but can make the query harder to read. When expressions are used in the SELECT part of the query, they should also be given a descriptive alias using the AS keyword.

**Note:** each database has its own set of mathematical, string and date functions, so check the docs of the database being used.

Format:

```sql
SELECT col_expression AS expr_description, …
FROM mytable;
```

**Gotcha:** regular columns and even tables can also have aliases to make them easier to reference in the output and as a part of simplifying more complex queries.

```sql
SELECT column AS better_column_name, …
FROM a_long_widgets_table_name AS mywidgets
INNER JOIN widget_sales
  ON mywidgets.id = widget_sales.widget_id;
```

### Queries with aggregates

Aggregate expressions (or functions) allow us to summarize information about a group of rows of data. e.g. how many movies has Pixar made, or which movie made the most money each year.
- without a GROUP BY, the aggregate runs over all the rows in the result and gives back just 1 value.
- giving the aggregate an alias (AS) makes the output easier to read.

```sql
SELECT AGG_FUNC(column_or_expression) AS aggregate_description, …
FROM mytable
WHERE constraint_expression;
```

| Function | Description |
| --- | --- |
| `COUNT(*)`, `COUNT(column)` | A common function used to count the number of rows in the group if no column name is specified. Otherwise, counts the number of rows in the group with non-NULL values in the specified column. |
| `MIN(column)` | Finds the smallest numerical value in the specified column for all rows in the group. |
| `MAX(column)` | Finds the largest numerical value in the specified column for all rows in the group. |
| `AVG(column)` | Finds the average numerical value in the specified column for all rows in the group. |
| `SUM(column)` | Finds the sum of all numerical values in the specified column for the rows in the group. |

Docs: [MySQL](https://dev.mysql.com/doc/refman/5.6/en/group-by-functions.html), [Postgres](http://www.postgresql.org/docs/9.4/static/functions-aggregate.html), [SQLite](http://www.sqlite.org/lang_aggfunc.html), [Microsoft SQL Server](https://msdn.microsoft.com/en-us/library/ms173454.aspx)


#### Grouped aggregate functions

In addition to aggregating across all the rows, we can instead apply the aggregate functions to individual groups of data (e.g. total box office per genre, Comedy vs Action). This would then create as many results as there are unique groups defined by the GROUP BY clause.
- GROUP BY works by putting rows that have the same value in the given column into one group, then the aggregate is worked out for each group.

```sql
SELECT AGG_FUNC(column_or_expression) AS aggregate_description, …
FROM mytable
WHERE constraint_expression
GROUP BY column;
```
#### HAVING
Since WHERE runs before the rows are grouped, we can't use it to filter the groups. So we use the **HAVING** clause, which is used specifically with the GROUP BY clause to allow us to filter grouped rows from the result set.

```sql
SELECT group_by_column, AGG_FUNC(column_expression) AS aggregate_result_alias, …
FROM mytable
WHERE condition
GROUP BY column
HAVING group_condition;
```

The HAVING clause constraints are written the same way as the WHERE clause constraints, and are applied to the grouped rows.

**Gotcha:** if we are not using GROUP BY, a normal WHERE clause is enough, no need for HAVING.

### Aggregates and GROUP BY

**Does:** aggregates (COUNT, SUM, AVG, MAX, MIN) squash many rows into 1 value. GROUP BY splits the rows into groups first, so we get 1 value per group, and HAVING then filters those groups.

**Pattern:**

```sql
SELECT group_column, SUM(column) AS total, COUNT(*), ROUND(AVG(column), 2) AS average
FROM mytable
WHERE row_condition
GROUP BY group_column
HAVING AGG_FUNC(column) > value
ORDER BY group_column;
```

**My example:** query #8 from w2_aggregates.sql, everyday expenses only (categories 5–10), total, count and average per category, only the categories averaging over 200.

```sql
SELECT category_id, sum(amount) AS total, count(*), ROUND(avg(amount), 2) AS average
FROM transactions
WHERE category_id BETWEEN 5 AND 10
GROUP BY category_id HAVING avg(amount) > 200
ORDER BY category_id;
```

**Gotcha:** WHERE filters rows before grouping, HAVING filters groups after. So `category_id BETWEEN 5 AND 10` goes in WHERE, and `avg(amount) > 200` goes in HAVING. An aggregate in WHERE errors, because the groups don't exist yet.

**Gotcha:** every non-aggregate column in SELECT must be in GROUP BY. `SELECT category_id, description … GROUP BY category_id` errors, because each group has many descriptions and Postgres can't pick one.

**Gotcha:** GROUP BY doesn't sort. The groups come back in whatever order Postgres finds them, so add ORDER BY.

**Gotcha:** AVG gives a long decimal (e.g. 228.0609…), so wrap it in `ROUND(avg(amount), 2)`. Round in SELECT for display, not in WHERE, and if amount is a float use `ROUND(avg(amount)::numeric, 2)`.

### Aggregates in depth

**Does:** an aggregate takes many input rows and gives back 1 result (count, sum, avg, max, min). With GROUP BY we get 1 result per group, HAVING filters those groups, and FILTER limits which rows go into just one aggregate.

**Pattern:**

```sql
SELECT group_column,
    COUNT(*) AS row_count,
    COUNT(*) FILTER (WHERE condition) AS matching_count,
    MAX(column) AS max_value
FROM mytable
WHERE row_condition
GROUP BY group_column
HAVING AGG_FUNC(column) > value;
```

**Docs example:** the weather table from the Postgres tutorial, how many readings each city has and its highest low temperature, only for cities whose highest low is under 40.

```sql
SELECT city, count(*), max(temp_lo)
FROM weather
GROUP BY city
HAVING max(temp_lo) < 40;
```

#### Aggregate in WHERE vs subquery

We can't use an aggregate inside WHERE, because WHERE picks the rows that go **into** the aggregate, so it has to run before the aggregate is worked out. To find the row that holds the max, we use a subquery, which works out its own aggregate separately from the outer query.

```sql
-- ❌ errors, WHERE runs before max() is worked out
SELECT city FROM weather
WHERE temp_lo = max(temp_lo);

-- ✅ the subquery works out the max first, then the outer WHERE compares to it
SELECT city FROM weather
WHERE temp_lo = (SELECT max(temp_lo) FROM weather);
```

#### WHERE vs HAVING

- **WHERE** picks the input rows **before** groups and aggregates are worked out. It can't contain aggregates.
- **HAVING** picks the group rows **after** groups and aggregates are worked out. It almost always contains aggregates.
- a condition that doesn't use an aggregate (e.g. `city LIKE 'S%'`) should go in WHERE, not HAVING. Both give the same result, but WHERE is faster, because it throws the rows away before they get grouped and aggregated.

```sql
-- ✅ non-aggregate condition in WHERE, rows are dropped before grouping
SELECT city, count(*), max(temp_lo)
FROM weather
WHERE city LIKE 'S%'
GROUP BY city;
```

#### FILTER

FILTER lets us choose which rows go into **one** aggregate, without changing the rows that the other aggregates see. It's like a WHERE that only applies to that one aggregate.

```sql
SELECT city,
    count(*) FILTER (WHERE temp_lo < 45),
    max(temp_lo)
FROM weather
GROUP BY city;
```
- here count only counts the readings under 45, but max still sees every row, so San Francisco gets count 1 and max 46.

**Gotcha:** an aggregate in WHERE errors, use a subquery `(SELECT max(...) FROM ...)` or move the condition to HAVING.

**Gotcha:** putting a normal (non-aggregate) condition in HAVING works, but it's wasted work, as the rows get grouped first and thrown away after. Put it in WHERE.

**Gotcha:** FILTER is Postgres (and standard SQL), SQLite only got it in 3.30 and MySQL doesn't have it. The older way is `SUM(CASE WHEN condition THEN 1 ELSE 0 END)`.

Docs: [Aggregate tutorial](https://www.postgresql.org/docs/current/tutorial-agg.html), [Aggregate functions](https://www.postgresql.org/docs/current/functions-aggregate.html), [Aggregate expressions (FILTER)](https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-AGGREGATES)

### Subqueries

**Does:** a subquery is a SELECT inside another query, written in brackets. The subquery expressions below all give back true/false, so they go in WHERE (or HAVING). EXISTS checks if the subquery found any rows, IN / NOT IN check if a value is in the subquery's list, and ANY / ALL compare a value against every row the subquery gives back.

**Pattern:**

```sql
SELECT column
FROM mytable
WHERE EXISTS (SELECT 1 FROM another_table WHERE another_table.id = mytable.id);

SELECT column
FROM mytable
WHERE column IN (SELECT column FROM another_table WHERE condition);

SELECT column
FROM mytable
WHERE column > ALL (SELECT column FROM another_table WHERE condition);
```

| Expression | True when | Subquery gives back 0 rows |
| --- | --- | --- |
| `EXISTS (subquery)` | the subquery gives back at least 1 row | false |
| `expr IN (subquery)` | expr equals any of the rows | false |
| `expr NOT IN (subquery)` | expr equals none of the rows | true |
| `expr operator ANY (subquery)` | the comparison is true for at least 1 row | false |
| `expr operator ALL (subquery)` | the comparison is true for every row | true |
| `expr operator (subquery)` | the comparison is true for the 1 row it gives back | NULL |

#### EXISTS

**Docs example:** the rows of tab1 that have at least 1 matching row in tab2.

```sql
SELECT col1
FROM tab1
WHERE EXISTS (SELECT 1 FROM tab2 WHERE col2 = tab1.col2);
```

- the subquery can use columns from the outer query (`tab1.col2`), so it gets worked out again for each outer row, with that row's values acting like constants.
- EXISTS only cares if any rows come back, not what is in them, so we just write `SELECT 1`.
- it stops as soon as it finds 1 row, it doesn't run the whole subquery.
- it works like an INNER JOIN on col2, but gives back at most 1 row per tab1 row, even if tab2 has many matches (a join would repeat the tab1 row for each match).

#### IN and NOT IN

The subquery must give back exactly 1 column. IN is true if any row equals the value, NOT IN is true if none of them do.

```sql
SELECT column
FROM mytable
WHERE column NOT IN (SELECT column FROM another_table WHERE column IS NOT NULL);
```

#### ANY / SOME and ALL

These take a comparison operator (=, <>, <, >, …) and check it against every row the subquery gives back. ANY is true if it holds for at least 1 row, ALL is true only if it holds for every row. SOME is just another name for ANY.
- `IN` is the same as `= ANY`.
- `NOT IN` is the same as `<> ALL`.
- `> ALL (subquery)` means bigger than every row, i.e. bigger than the max. `> ANY (subquery)` means bigger than at least 1 row, i.e. bigger than the min.

#### Single-row comparison

When we compare with a normal operator (`=`, `>`, …) straight to a subquery, like `WHERE temp_lo = (SELECT max(temp_lo) FROM weather)`, the subquery has to give back at most 1 row.
- more than 1 row errors.
- 0 rows gives NULL, so the outer row is dropped.
- it also works with multiple columns: `WHERE (col1, col2) = (SELECT a, b FROM … )`, the subquery must give back the same number of columns.

**Gotcha:** NOT IN with a NULL in the subquery gives back nothing. If no row matches and one of the rows is NULL, the result is NULL instead of true (since "is x <> NULL?" is unknown), so every outer row gets dropped. Add `WHERE column IS NOT NULL` in the subquery, or use NOT EXISTS instead, which doesn't have this problem.

**Gotcha:** if the left side value is NULL, IN and NOT IN both give NULL, so that row is never returned either way.

**Gotcha:** `= (subquery)` errors with "more than one row returned by a subquery used as an expression" if the subquery gives back many rows. Use IN (or `= ANY`) instead.

**Gotcha:** a scalar subquery gives back 1 value, but many rows can match that value. `WHERE amount = (SELECT max(amount) FROM transactions)` gave back 12 rows, not 1, because all 12 Salary rows are exactly 15000.00 and tie for the largest.

**Gotcha:** ALL with an empty subquery is true, so every outer row passes. NOT IN with an empty subquery is true too.

Docs: [Subquery expressions](https://www.postgresql.org/docs/current/functions-subquery.html)

### WITH queries (CTEs)

**Does:** WITH lets us write a helper query first, give it a name, and then use that name like a table in the main query. Each helper is called a **CTE** (Common Table Expression), and it only exists while that one query runs. It's a way to break a big query with nested subqueries into simple named steps that read top to bottom.

**Pattern:**

```sql
WITH step_one AS (
    SELECT column, AGG_FUNC(column) AS total
    FROM mytable
    GROUP BY column
), step_two AS (
    SELECT column
    FROM step_one
    WHERE total > value
)
SELECT *
FROM mytable
WHERE column IN (SELECT column FROM step_two);
```

- more than 1 CTE is separated by commas, with only one WITH at the start.
- a later CTE can use an earlier one (step_two reads from step_one).

**Docs example:** sales per product, but only in the top regions (regions with more than 10% of all sales).

```sql
WITH regional_sales AS (
    SELECT region, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region
), top_regions AS (
    SELECT region
    FROM regional_sales
    WHERE total_sales > (SELECT SUM(total_sales)/10 FROM regional_sales)
)
SELECT region,
       product,
       SUM(quantity) AS product_units,
       SUM(amount) AS product_sales
FROM orders
WHERE region IN (SELECT region FROM top_regions)
GROUP BY region, product;
```

- the same thing could be written with nested subqueries, but WITH is much easier to follow, since each step has a name.

#### WITH RECURSIVE

With RECURSIVE, a CTE can read its own output, which lets it loop. It has 2 parts joined by UNION ALL (or UNION):
- the **non-recursive part** runs once and gives the starting rows.
- the **recursive part** runs again and again, each time only on the rows made by the last round, until it gives back no new rows.

```sql
WITH RECURSIVE t(n) AS (
    VALUES (1)                          -- start: n = 1
  UNION ALL
    SELECT n + 1 FROM t WHERE n < 100   -- each round adds n + 1, stops at 100
)
SELECT sum(n) FROM t;                   -- 5050
```

- it's mostly used for tree or hierarchy data, e.g. every sub-part of a product (and their sub-parts), or every employee under a manager.
- UNION ALL keeps every row, UNION drops duplicate rows (which can help stop loops).
- Postgres also has `SEARCH DEPTH FIRST / BREADTH FIRST BY …` to order the results of a tree walk, and `CYCLE … SET is_cycle USING path` to stop looping on data that links back to itself.

#### Materialized or not

- a CTE used **once** gets folded into the main query, so Postgres can still use indexes and the main query's WHERE.
- a CTE used **more than once** is worked out once and stored (materialized), then reused.
- `WITH w AS MATERIALIZED (…)` / `WITH w AS NOT MATERIALIZED (…)` overrides this. MATERIALIZED is useful when the CTE calls something slow, so it only runs once.

#### Changing data inside WITH

INSERT, UPDATE and DELETE can also go inside a WITH. The rows from their **RETURNING** clause become the CTE's table.

```sql
-- move October rows from products into products_log in one statement
WITH moved_rows AS (
    DELETE FROM products
    WHERE "date" >= '2010-10-01' AND "date" < '2010-11-01'
    RETURNING *
)
INSERT INTO products_log
SELECT * FROM moved_rows;
```

**Gotcha:** a CTE only exists for the one query it's attached to. The next query can't use it, so it has to be written again.

**Gotcha:** a recursive CTE with no stopping condition (like `WHERE n < 100`) loops forever. When testing, a `LIMIT` on the main query can stop it, but don't rely on that in real queries.

**Gotcha:** all parts of a WITH see the same snapshot of the data. After an UPDATE in a CTE, `SELECT * FROM products` in the main query still shows the **old** values. To see the new values, select from the CTE (`SELECT * FROM t`), which holds the RETURNING rows.

**Gotcha:** a data-changing CTE always runs fully, even if the main query never uses its output.

Docs: [WITH queries (CTEs)](https://www.postgresql.org/docs/current/queries-with.html)

### Window functions

**Does:** a window function works out a value across a set of rows that are related to the current row (its "window"), like an aggregate does. But unlike GROUP BY, the rows are **not** squashed into 1 row per group, every row stays in the result and just gets the extra value next to it. The `OVER (…)` part is what makes it a window function.

**Pattern:**

```sql
SELECT column, another_column,
    AGG_OR_WINDOW_FUNC(column) OVER (PARTITION BY group_column ORDER BY sort_column) AS alias
FROM mytable;
```

- `PARTITION BY` splits the rows into groups (partitions), like GROUP BY, but without collapsing them. Leave it out and the whole table is 1 partition.
- `ORDER BY` inside OVER sets the order the rows are processed in, within each partition.
- `OVER ()` with nothing inside means the window is every row in the result.
- any normal aggregate (sum, avg, count, max, min) can be used as a window function, plus window-only ones like `row_number()`, `rank()`, `lag()`, `lead()`.

#### PARTITION BY

**Docs example:** each employee's salary next to the average salary of their department.

```sql
SELECT depname, empno, salary, avg(salary) OVER (PARTITION BY depname)
FROM empsalary;
```

```
  depname  | empno | salary |          avg
-----------+-------+--------+-----------------------
 develop   |    11 |   5200 | 5020.0000000000000000
 develop   |     7 |   4200 | 5020.0000000000000000
 develop   |     9 |   4500 | 5020.0000000000000000
 develop   |     8 |   6000 | 5020.0000000000000000
 develop   |    10 |   5200 | 5020.0000000000000000
 personnel |     5 |   3500 | 3700.0000000000000000
 personnel |     2 |   3900 | 3700.0000000000000000
 sales     |     3 |   4800 | 4866.6666666666666667
 sales     |     1 |   5000 | 4866.6666666666666667
 sales     |     4 |   4800 | 4866.6666666666666667
```

- all 10 rows are still there. With GROUP BY depname we'd only get 3 rows and lose empno and salary.

#### ORDER BY inside OVER

**Docs example:** number the employees in each department from highest to lowest salary.

```sql
SELECT depname, empno, salary,
    row_number() OVER (PARTITION BY depname ORDER BY salary DESC)
FROM empsalary;
```

```
  depname  | empno | salary | row_number
-----------+-------+--------+------------
 develop   |     8 |   6000 |          1
 develop   |    10 |   5200 |          2
 develop   |    11 |   5200 |          3
 develop   |     9 |   4500 |          4
 develop   |     7 |   4200 |          5
 personnel |     2 |   3900 |          1
 personnel |     5 |   3500 |          2
 sales     |     1 |   5000 |          1
 sales     |     4 |   4800 |          2
 sales     |     3 |   4800 |          3
```

- the numbering starts again at 1 for each department.
- the ORDER BY inside OVER only decides the order for the window function, it doesn't sort the final output. Add a normal ORDER BY at the end for that.

#### Window frames (running totals)

Some functions (like sum) don't look at the whole partition, only at the row's **window frame**:
- **with ORDER BY** in OVER, the frame is from the start of the partition up to the current row, plus any later rows that tie with it on the ORDER BY value (its "peers").
- **without ORDER BY**, the frame is the whole partition.

```sql
-- no ORDER BY: every row gets the total of the whole table
SELECT salary, sum(salary) OVER () FROM empsalary;        -- 47100 on every row

-- with ORDER BY: a running total
SELECT salary, sum(salary) OVER (ORDER BY salary) FROM empsalary;
```

```
 salary |  sum
--------+-------
   3500 |  3500
   3900 |  7400
   4200 | 11600
   4500 | 16100
   4800 | 25700
   4800 | 25700
   5000 | 30700
   5200 | 41100
   5200 | 41100
   6000 | 47100
```

- the 2 rows with 4800 both show 25700, because they are peers, so both are in each other's frame.

#### Filtering on a window result

Window functions only run after WHERE, GROUP BY and HAVING, so we can't filter on them there. Wrap the query in a subquery (or a CTE) and filter outside.

**Docs example:** the top 2 earners in each department.

```sql
SELECT depname, empno, salary, enroll_date
FROM (
    SELECT depname, empno, salary, enroll_date,
        row_number() OVER (PARTITION BY depname ORDER BY salary DESC, empno) AS pos
    FROM empsalary
) AS ss
WHERE pos < 3;
```

#### Named windows (WINDOW)

When more than 1 function uses the same window, name it once with WINDOW instead of writing the OVER (…) out each time.

```sql
SELECT sum(salary) OVER w, avg(salary) OVER w
FROM empsalary
WINDOW w AS (PARTITION BY depname ORDER BY salary DESC);
```

**Gotcha:** window functions are only allowed in SELECT and ORDER BY. `WHERE row_number() OVER (…) < 3` errors, use the subquery above.

**Gotcha:** window functions run **after** aggregates (after GROUP BY / HAVING, before DISTINCT, ORDER BY and LIMIT). So an aggregate can go inside a window function, e.g. `sum(sum(amount)) OVER (ORDER BY month)` for a running total of monthly totals, but not the other way round.

**Gotcha:** a running total with ORDER BY gives tied rows the **same** total (both 4800 rows show 25700), it doesn't go up row by row. Add a tie-breaker column to the ORDER BY (`ORDER BY txn_date, id`), or use `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` so the frame stops exactly at the current row.

**Gotcha:** with ties, `row_number()` hands out the numbers in no fixed order (empno 10 and 11 could swap between runs). Add a tie-breaker (like `, empno` in the top-2 example) so the result doesn't change between runs.

**Gotcha:** adding ORDER BY to OVER changes what sum/avg/count give back. `sum(x) OVER (PARTITION BY d)` is the partition total, `sum(x) OVER (PARTITION BY d ORDER BY y)` is a running total.

Docs: [Window functions tutorial](https://www.postgresql.org/docs/current/tutorial-window.html), [Window function calls (frame options)](https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS), [Window functions list](https://www.postgresql.org/docs/current/functions-window.html)

### Order of execution of a Query

Complete SELECT query with all the clauses put together:

```sql
SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
FROM mytable
JOIN another_table
    ON mytable.column = another_table.column
WHERE constraint_expression
GROUP BY column
HAVING constraint_expression
ORDER BY column ASC/DESC
LIMIT count OFFSET count;
```

Written order ≠ run order. The database runs it like this:

| # | Clause | What it does | Can use SELECT aliases? |
|---|--------|--------------|-------------------------|
| 1 | `FROM` / `JOIN` | Builds the full working set of rows (tables, joins, subqueries) | ❌ |
| 2 | `WHERE` | Filters **individual rows** | ❌ |
| 3 | `GROUP BY` | Collapses rows into groups (one row per unique value) | ❌ |
| 4 | `HAVING` | Filters **groups** (usually on aggregates) | ❌ |
| 5 | `SELECT` | Computes the output columns/expressions and aliases | — |
| 6 | `DISTINCT` | Drops duplicate output rows | — |
| 7 | `ORDER BY` | Sorts the result | ✅ |
| 8 | `LIMIT` / `OFFSET` | Keeps only the requested slice of rows | — |

**Mnemonic:** *From Where Groups Have Selected Distinct Ordered Limits.*

**Key takeaways**
- `WHERE` = filter rows **before** grouping; `HAVING` = filter groups **after** grouping.
- Aliases defined in `SELECT` don't exist yet in `WHERE` / `GROUP BY` / `HAVING` (most DBs) — repeat the expression instead. *(SQLite, which SQLBolt uses, and MySQL are lenient here, but Postgres / SQL Server will error.)*
- `ORDER BY` runs after `SELECT`, so it **can** use aliases.
- `GROUP BY` is only needed when you're using aggregate functions.
- `LIMIT` is applied last — it slices the already sorted result.
- not every query needs every clause, only use the ones needed.

```sql
-- ❌ fails in most DBs: alias not known yet in WHERE
SELECT price * qty AS total FROM orders WHERE total > 100;

-- ✅ repeat the expression in WHERE, alias is fine in ORDER BY
SELECT price * qty AS total FROM orders WHERE price * qty > 100 ORDER BY total DESC;
```

## Inserting Rows

The database schema is what describes the structure of each table, and the datatypes that each column of the table can contain. 

Example:  Movies table, the values in the Year column must be an Integer, and the values in the Title column must be a String. 

- having this fixed structure is what lets the database stay efficient and consistent, even when it holds millions or billions of rows.

### Insertion of Data

We use the "INSERT" command when inserting (adding) data into the database. It declares which table to write into, the columns of data that we are filling, and one or more rows of data to insert.

Rule of thumb - each row of data you insert should contain values for every corresponding column in the table. You can insert multiple rows at a time by just listing them sequentially.

```sql
INSERT INTO mytable
VALUES (value_or_expr, another_value_or_expr, …),
       (value_or_expr_2, another_value_or_expr_2, …),
       …;
```

In some cases, if there is incomplete data and the table contains columns that support default values, you can insert rows with only the columns of data you have by specifying them explicitly.

```sql
INSERT INTO mytable
(column, another_column, …)
VALUES (value_or_expr, another_value_or_expr, …),
      (value_or_expr_2, another_value_or_expr_2, …),
      …;
```

As such the number of values needs to match the number of columns specified.

**Gotcha:** writing out the column names is longer, but it is safer. If a new column (with a default value) is added to the table later, the INSERT statements that name their columns will still work without any changes.

We can also use mathematical and string expressions with the values that we are inserting.
This can be useful to ensure that all data inserted is formatted a certain way.

```sql
INSERT INTO boxoffice
(movie_id, rating, sales_in_millions)
VALUES (1, 9.9, 283742034 / 1000000);
```

## Updating Rows

We use the **UPDATE** statement to change data that is already in the table. Just like INSERT, we have to say exactly which table, columns and rows to update.
- the data that is to be updated has to match the data type of the columns in the table schema.
- we can update more than 1 column at a time by listing the column/value pairs separated by commas.

```sql
UPDATE mytable
SET column = value_or_expr, 
    other_column = another_value_or_expr, 
    …
WHERE condition;
```
The statement works by taking multiple column/value pairs, and applying those changes to each and every row that satisfies the constraint in the WHERE clause.

**Docs example:** the weather table from the Postgres tutorial. The readings after Nov 28 were all 2 degrees too high, so take 2 off both temperatures for those rows.

```sql
UPDATE weather
    SET temp_hi = temp_hi - 2, temp_lo = temp_lo - 2
    WHERE date > '1994-11-28';
```

```
     city      | temp_lo | temp_hi | prcp |    date
---------------+---------+---------+------+------------
 San Francisco |      46 |      50 | 0.25 | 1994-11-27
 San Francisco |      41 |      55 |    0 | 1994-11-29
 Hayward       |      35 |      52 |      | 1994-11-29
```

- the value after `=` can use the column's own current value (`temp_hi - 2`), so we can change data relative to what's already there.
- only the rows matching WHERE change. The 1994-11-27 row is left as it was (46 / 50).

**Gotcha:** every expression in SET sees the **old** row. So `SET a = b, b = a` swaps the 2 values in Postgres, it doesn't copy b into both.

Docs: [UPDATE tutorial](https://www.postgresql.org/docs/current/tutorial-update.html)

### Taking care

Mistakes while updating data happen to most people working with SQL at some point. Like updating the wrong set of rows in a production database, or leaving out the WHERE clause, which makes the update apply to **all** the rows in the table.

**Gotcha:** always write the WHERE constraint first and test it with a SELECT query to make sure we are hitting the right rows. Only then write the column/value pairs for the UPDATE.

## Deleting Rows

We use the **DELETE** statement to remove data from a table. It says which table to delete from and uses a WHERE clause to pick which rows get removed.

```sql
DELETE FROM mytable
WHERE condition;
```

- If we leave out the WHERE constraint, **all** the rows in the table get removed. This is a quick way to empty a table, but only if that is what we actually want.

**Docs example:** we no longer care about Hayward's weather, so remove all of its rows.

```sql
DELETE FROM weather WHERE city = 'Hayward';
```

```
     city      | temp_lo | temp_hi | prcp |    date
---------------+---------+---------+------+------------
 San Francisco |      46 |      50 | 0.25 | 1994-11-27
 San Francisco |      41 |      55 |    0 | 1994-11-29
```

**Gotcha:** `DELETE FROM tablename;` with no WHERE empties the whole table, and Postgres **doesn't ask for confirmation** first. It just does it.

Docs: [DELETE tutorial](https://www.postgresql.org/docs/current/tutorial-delete.html)

### Taking care

Just like UPDATE, it's a good idea to first run the constraint in a SELECT query to make sure we are removing the right rows.

**Gotcha:** without a proper backup or a test database, deleted data can be lost for good. "read your DELETE statements twice and execute once."

## Creating Tables

When we have new entities and relationships to store in the database, we create a new table using the **CREATE TABLE** statement. The structure of the new table is defined by its table schema, which is a series of columns.

```sql
CREATE TABLE IF NOT EXISTS mytable (
    column DataType TableConstraint DEFAULT default_value,
    another_column DataType TableConstraint DEFAULT default_value,
    …
);
```
- each column has a **name**, a **data type** (what kind of data it holds), an optional **table constraint** (rules on the values that can be inserted) and an optional **default value**.

**Gotcha:** if a table with the same name already exists, the database will usually throw an error. Adding **IF NOT EXISTS** skips the error and just doesn't create the table.

### Data types

Each database supports its own data types, but the common ones are numeric, string and some others like dates, booleans or binary data.

| Data type | Description |
|---|---|
| `INTEGER`, `BOOLEAN` | Whole numbers like counts or ages. Some databases store a boolean as an integer, 0 or 1. |
| `FLOAT`, `DOUBLE`, `REAL` | More precise numbers like measurements or fractions. Which one to use depends on how precise it needs to be. |
| `CHARACTER(num_chars)`, `VARCHAR(num_chars)`, `TEXT` | Text and strings. CHARACTER and VARCHAR (variable character) need a max number of characters, and longer text may get cut off (truncated). They mostly differ in how efficient they are, which matters for large tables. |
| `DATE`, `DATETIME` | Dates and timestamps, useful for time series and event data. Can be tricky, especially with time zones. |
| `BLOB` | Binary data stored directly in the database. The database can't read what's inside, so it needs to be stored with the right metadata to be useful when queried back. |

Docs: [MySQL](https://dev.mysql.com/doc/refman/5.6/en/data-types.html), [Postgres](http://www.postgresql.org/docs/9.4/static/datatype.html), [SQLite](https://www.sqlite.org/datatype3.html), [Microsoft SQL Server](https://msdn.microsoft.com/en-us/library/ms187752.aspx)

### Table constraints

Constraints are rules that limit what values can be put into a column (not a full list):

| Constraint | Description |
|---|---|
| `PRIMARY KEY` | Values in this column are unique, and each value is used to identify a single row in the table. |
| `AUTOINCREMENT` | For integers, the value is filled in and goes up by 1 automatically with each new row. Not supported by every database. |
| `UNIQUE` | No two rows can have the same value in this column. Unlike PRIMARY KEY, it doesn't have to be the key for a row. |
| `NOT NULL` | The value can't be NULL. |
| `CHECK (expression)` | Runs an expression to check if a value is valid, e.g. values must be positive, have a minimum length, or start with a certain prefix. |
| `FOREIGN KEY` | A consistency check that each value in this column matches a value in a column of another table. |

- e.g. FOREIGN KEY: one table lists all employees by their ID, and another table holds their payroll info. The FOREIGN KEY makes sure every row in the payroll table matches a valid employee in the employee list.

Example, the movies table schema used in SQLBolt:

```sql
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT,
    director TEXT,
    year INTEGER,
    length_minutes INTEGER
);
```

## Altering Tables

As the data changes over time, we use the **ALTER TABLE** statement to add, remove or change columns and table constraints of a table that already exists.

### Adding columns

The syntax is similar to how columns are written in CREATE TABLE, we give the data type, any constraints and a default value.

```sql
ALTER TABLE mytable
ADD column DataType OptionalTableConstraint
    DEFAULT default_value;
```
- the default value is put into the existing rows as well as any new rows inserted later.

**Note:** MySQL lets us use FIRST or AFTER to choose where the new column goes, but this is not standard SQL.

### Removing columns

```sql
ALTER TABLE mytable
DROP column_to_be_deleted;
```

**Gotcha:** some databases, like SQLite, don't support dropping columns. In that case we have to create a new table and copy the data over.

### Renaming the table

```sql
ALTER TABLE mytable
RENAME TO new_table_name;
```

**Note:** each database supports different ALTER TABLE features and syntax, so check the docs before altering a table.

Docs: [MySQL](http://dev.mysql.com/doc/refman/5.6/en/alter-table.html), [Postgres](http://www.postgresql.org/docs/9.4/static/sql-altertable.html), [SQLite](https://www.sqlite.org/lang_altertable.html), [Microsoft SQL Server](https://msdn.microsoft.com/en-us/library/ms190273.aspx)

## Dropping Tables

In the rare case that we want to remove a whole table, including all its data and metadata, we use the **DROP TABLE** statement.

```sql
DROP TABLE IF EXISTS mytable;
```

- DROP TABLE is different from DELETE: DELETE (with no WHERE) removes all the rows but the table stays, while DROP TABLE removes the table schema from the database entirely.
- just like CREATE TABLE, dropping a table that doesn't exist throws an error, so we add **IF EXISTS** to skip it.

**Gotcha:** if another table depends on the table being dropped (e.g. through a FOREIGN KEY), we can't drop it straight away. We first have to update the dependent tables to remove the rows that depend on it, or remove those tables completely.

## Dates and times (PostgreSQL)

Docs: [EXTRACT](https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT), [date_trunc](https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-TRUNC), [operators](https://www.postgresql.org/docs/current/functions-datetime.html#OPERATORS-DATETIME-TABLE)

### EXTRACT

Pulls **one piece** out of a date and gives it back as a number.

```sql
EXTRACT(field FROM source)
```

| Field | Returns | Example for `2025-10-16` (a Thursday) |
|-------|---------|----------------------------------------|
| `year` | the year | 2025 |
| `month` | 1–12 | 10 |
| `quarter` | 1–4 (Jan–Mar = 1, …) | 4 |
| `isodow` | day of week, Monday = 1 … Sunday = 7 | 4 |

**Gotcha:** `dow` (without "iso") counts Sunday = 0 … Saturday = 6. `isodow` is the one that puts the weekend at 6 and 7, which makes `WHERE EXTRACT(isodow FROM txn_date) >= 6` work.

### date_trunc

Snaps the **whole date back** to the start of the chosen unit (`'year'`, `'quarter'`, `'month'`, `'week'`, `'day'`, …). Everything smaller than that unit is reset to its lowest value.

```sql
date_trunc('month', txn_date)          -- 2025-10-01 00:00:00
date_trunc('month', txn_date)::date    -- 2025-10-01
date_trunc('year',  TIMESTAMP '2001-02-16 20:38:40')   -- 2001-01-01 00:00:00
date_trunc('hour',  TIMESTAMP '2001-02-16 20:38:40')   -- 2001-02-16 20:00:00
```

- the input is turned into a timestamp first, so a time comes back attached. Add `::date` to get a clean date.
- `'week'` snaps back to the Monday of that week.

### EXTRACT vs date_trunc for grouping

`EXTRACT(month …)` throws the year away: October 2025 and October 2026 are both `10`, so grouping on it merges them into one group. `date_trunc('month', …)` keeps the year (`2025-10-01` vs `2026-10-01`), so each month stays separate.

```sql
-- ❌ Oct 2025 and Oct 2026 end up in the same group
SELECT EXTRACT(month FROM txn_date) AS month, SUM(amount)
FROM transactions GROUP BY 1;

-- ✅ one row per real calendar month
SELECT date_trunc('month', txn_date)::date AS month, SUM(amount)
FROM transactions GROUP BY 1 ORDER BY 1;
```

Use `EXTRACT` when we actually want to compare "all Octobers" or "all Saturdays" together.

### Date arithmetic with intervals

| Operator | Example | Result |
|----------|---------|--------|
| `date + interval` | `DATE '2001-09-28' + INTERVAL '1 hour'` | `2001-09-28 01:00:00` (timestamp) |
| `date - interval` | `DATE '2001-09-28' - INTERVAL '1 hour'` | `2001-09-27 23:00:00` (timestamp) |

```sql
SELECT DATE '2026-09-30' - INTERVAL '30 days';   -- 2026-08-31 00:00:00
```

- like `date_trunc`, the result is a timestamp, so add `::date` if we want a plain date.
- common use: "last 30 days" → `WHERE txn_date >= CURRENT_DATE - INTERVAL '30 days'`.

**Gotcha:** `'1 month'` is not a fixed number of days. `DATE '2026-01-31' + INTERVAL '1 month'` gives `2026-02-28`, because Postgres moves to the last valid day when the month is shorter.

## Constraints (PostgreSQL)

**Does:** constraints are rules on a table that the database checks on every INSERT and UPDATE. If a row breaks a rule, Postgres throws an error and the row isn't saved (even if the bad value came from a DEFAULT). Data types only limit the kind of value (e.g. a number), constraints limit which values are allowed (e.g. a number above 0).

**Pattern:**

```sql
CREATE TABLE mytable (
    id          SERIAL PRIMARY KEY,                           -- unique + not null
    name        TEXT NOT NULL UNIQUE,                          -- column constraints
    price       NUMERIC CONSTRAINT positive_price CHECK (price > 0),
    sale_price  NUMERIC,
    other_id    INTEGER REFERENCES other_table(id) ON DELETE RESTRICT,
    CONSTRAINT valid_sale CHECK (price > sale_price)          -- table constraint
);
```

- a **column constraint** is written right after one column and only talks about that column.
- a **table constraint** is written on its own line in the column list, and can use more than 1 column.
- `CONSTRAINT some_name …` gives the constraint a name. It shows up in the error message, and lets us drop it later with ALTER TABLE. Without a name, Postgres makes one up (e.g. `products_price_check`).

**My example:** the Personal Finance schema (sql/project/schema.sql).

```sql
CREATE TABLE categories (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense'))
);

CREATE TABLE transactions (
    id          SERIAL PRIMARY KEY,
    account_id  INTEGER NOT NULL REFERENCES accounts(id),
    category_id INTEGER NOT NULL REFERENCES categories(id),
    amount      NUMERIC(12,2) NOT NULL,
    txn_date    DATE NOT NULL,
    description TEXT
);
```

- tested against each constraint in w4_constraints.sql.

### CHECK

Runs a true/false expression on each new or changed row.

```sql
price numeric CHECK (price > 0)
```

- the row passes if the expression is **true or NULL**. So `CHECK (price > 0)` lets `price = NULL` through. Add NOT NULL if NULLs aren't allowed.
- a CHECK should only look at the row being inserted. Postgres doesn't support CHECKs that look at other rows or other tables (use UNIQUE, FOREIGN KEY or EXCLUDE for those).
- a CHECK only runs on INSERT and UPDATE. Rows already in the table aren't checked again later.

### NOT NULL

The column can't hold NULL.

```sql
product_no integer NOT NULL
```

- works the same as `CHECK (product_no IS NOT NULL)`, but is faster.
- a column can have many constraints, written in any order: `price numeric NOT NULL CHECK (price > 0)`.
- **Tip from the docs:** most columns in a good database design should be NOT NULL.

### UNIQUE

No 2 rows can have the same value in the column (or the same combination of values, for a group of columns).

```sql
CREATE TABLE example (
    a integer UNIQUE,        -- a on its own must be unique
    b integer,
    c integer,
    UNIQUE (b, c)            -- the pair (b, c) must be unique, b or c alone can repeat
);
```

- Postgres builds an index for each UNIQUE constraint automatically.
- by default 2 NULLs are **not** equal to each other, so many rows can have NULL in a UNIQUE column. `UNIQUE NULLS NOT DISTINCT` treats NULLs as equal, so only 1 NULL is allowed.
- "unique, but only for some rows" can't be a UNIQUE constraint, use a partial unique index instead.

### PRIMARY KEY

Identifies each row. It's the same as `UNIQUE NOT NULL`, plus:
- a table can have only **1** primary key (but many UNIQUE constraints).
- it's the default column a FOREIGN KEY points to, so `REFERENCES categories` means `REFERENCES categories(id)`.
- it can be more than 1 column: `PRIMARY KEY (a, c)`.
- Postgres doesn't force every table to have one, but every table should.

### FOREIGN KEY (REFERENCES)

The value must match a row that exists in another table. This keeps the links between tables valid (**referential integrity**).

```sql
CREATE TABLE orders (
    order_id   integer PRIMARY KEY,
    product_no integer REFERENCES products (product_no),
    quantity   integer
);
```

- the table with REFERENCES (orders) is the **referencing** table, the one it points to (products) is the **referenced** table.
- for more than 1 column, use the table form: `FOREIGN KEY (b, c) REFERENCES other_table (c1, c2)`.
- a table can reference itself, e.g. `parent_id integer REFERENCES tree` for a tree, where the top rows have `parent_id = NULL`.
- the referenced column must be a PRIMARY KEY or UNIQUE.

#### ON DELETE / ON UPDATE

What happens to the referencing rows when the row they point to is deleted (or its key is changed):

| Action | What it does | Use when |
|---|---|---|
| `NO ACTION` (default) | error, if any rows still point to it at the end of the statement (can be put off to the end of the transaction) | the 2 tables are separate things |
| `RESTRICT` | error straight away, can't be put off | same as above, stricter |
| `CASCADE` | delete the referencing rows too (ON UPDATE: copy the new key into them) | the child can't exist without the parent, e.g. order items of an order |
| `SET NULL` | set the referencing column to NULL | the link is optional |
| `SET DEFAULT` | set the referencing column to its DEFAULT (which must still be valid) | the link is optional, with a fallback |

```sql
CREATE TABLE order_items (
    product_no integer REFERENCES products ON DELETE RESTRICT,   -- can't delete a product that's been ordered
    order_id   integer REFERENCES orders   ON DELETE CASCADE,    -- deleting an order deletes its items
    quantity   integer,
    PRIMARY KEY (product_no, order_id)
);
```

### EXCLUDE

A more general UNIQUE: for any 2 rows, the given comparison must not be true for all the listed columns. E.g. no 2 circles (or 2 bookings) can overlap:

```sql
CREATE TABLE circles (
    c circle,
    EXCLUDE USING gist (c WITH &&)
);
```

**Gotcha:** CHECK passes on NULL. `CHECK (amount > 0)` with `amount = NULL` gives NULL, not false, so the row gets in. It needs NOT NULL as well.

**Gotcha:** a FOREIGN KEY column can still be NULL, and a NULL skips the check. That's why `category_id` is `NOT NULL REFERENCES categories(id)` in my schema.

**Gotcha:** the default ON DELETE is NO ACTION, so deleting a category that still has transactions errors. Pick CASCADE only when losing the child rows is actually what we want (deleting a category should **not** wipe its transactions).

**Gotcha:** a FOREIGN KEY doesn't make an index on the referencing column (`transactions.category_id`), only PRIMARY KEY and UNIQUE do. Deleting a category has to scan transactions to check for links, so add an index by hand on big tables.

**Gotcha:** UNIQUE lets many NULLs in, because NULL is never equal to NULL (same idea as `= NULL` never matching). Use `NULLS NOT DISTINCT` or NOT NULL.

**Gotcha:** inside one BEGIN, the first error aborts the whole transaction, and every later command is ignored ("current transaction is aborted"), until ROLLBACK. Test each constraint in its own BEGIN; … ROLLBACK;.

Docs: [Constraints](https://www.postgresql.org/docs/current/ddl-constraints.html)
