# SQL Notes

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
