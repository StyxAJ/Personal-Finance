# SQL Notes

### SELECT statements
- We use **SELECT** to choose a column where the column is represents the common property of the category

```sql
SELECT * 
FROM mytable;
```
- where "*" is used to pull all the columns in the database

```sql
SELECT column, another_column, …
FROM mytable;
```
- in the above Query we specify which column or category we want to look in

## Queries with constraints

When we have data or tables with thousands or millions or billions of data. Thus, In order to filter certain results from being returned, we need to use a WHERE clause in the query. The clause is applied to each row of data by checking specific column values to determine whether it should be included in the results or not.

### WHERE statements
- When we need to add a way to add constrain or filter data, we use **WHERE** in order to add conditions. 
    - Writing clauses to constrain the set of rows returned also allows the query to run faster due to the reduction in unnecessary data being returned.
    - More complex clauses can be constructed by joining numerous AND or OR logical keywords
    - SQL supports a number of useful operators to do things like case-insensitive string comparison and wildcard pattern matching.

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition
    AND/OR another_condition
    AND/OR …;
```

#### WHERE conditions

| Operator | Condition | Example (PostgreSQL) |
|---|---|---|
| `=`, `!=`, `<`, `<=`, `>`, `>=` | Standard comparisons | `amount != 4` |
| `BETWEEN … AND …` | Within a range (inclusive) | `amount BETWEEN 1.5 AND 10.5` |
| `NOT BETWEEN … AND …` | Outside a range | `amount NOT BETWEEN 1 AND 10` |
| `IN (…)` | Value is in a list | `id IN (2, 4, 6)` |
| `NOT IN (…)` | Value is not in a list | `id NOT IN (1, 3, 5)` |
| `=` | Exact string match (case-sensitive) | `name = 'abc'` |
| `!=` or `<>` | Exact string mismatch | `name != 'abcd'` |
| `LIKE` | Pattern match, **case-sensitive** in Postgres | `name LIKE 'ABC%'` |
| `ILIKE` | Pattern match, case-insensitive (Postgres only) | `name ILIKE 'abc%'` |
| `NOT LIKE` | Pattern doesn't match | `name NOT LIKE 'ABCD'` |
| `%` | Any run of 0+ characters (with LIKE) | `'%AT%'` → AT, ATTIC, CAT, BATS |
| `_` | Exactly one character (with LIKE) | `'AN_'` → AND, but not AN |
| `IN (…)` | String is in a list | `name IN ('A', 'B', 'C')` |
| `NOT IN (…)` | String is not in a list | `name NOT IN ('D', 'E', 'F')` |

**Gotcha:** SQLBolt uses SQLite. In PostgreSQL, strings need single quotes ('abc'),
and LIKE is case-sensitive, so use ILIKE for case-insensitive matching.


## Filtering and sorting Query results 
Data in the databases is may be unique, but results in the some queries may not be. There are times when database hold same data in the 
different rows. So in order to discard rows that have duplicate column value, SQL provides a keyword for such a function, called **DISTINCT**.

### DISTINCT
- DISTINCT keyword will blindly remove duplicate rows

```sql
SELECT DISTINCT column, another_column, …
FROM mytable
WHERE condition(s);
```

### ORDER BY
Most data in real databases are added in no particular column order. As a result, it can be difficult to read through and understand the results of a query as the size of a table increases to thousands or even millions rows.
- SQL provides a way to sort your results by a given column in ascending or descending order using the ORDER BY clause.
    - ASC is for ascending
    - DESC is for descending
    - Each row is sorted alpha-numerically based on the specified column's value.

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC;
```

### LIMIT and OFFSET
When we work with large date base, there often are larger enough that it get inefficient to read them. So we use **LIMIT** to reduce the number of rows that is returned. While we can use **OFFSET** to specify where to begin the count for number of rows from.

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC
LIMIT num_limit OFFSET num_offset;
```