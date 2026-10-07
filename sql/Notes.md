# SQL Notes

### SELECT statements
- We use **SELECT** to choose a column where the column is represents the common property of the category
- **SELECT** picks which columns to show; **FROM** picks the table

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

**Gotcha:** while "=" compares the whole exact values, "LIKE" compare it patterns where wildcards such as "%" and "_" are used to broaden the search for the data. With out Wildcard, "LIKE" acts exactly as "="


## Filtering and sorting Query results 
Data in the databases is may be unique, but results in the some queries may not be. There are times when database hold same data in the 
different rows. So in order to discard rows that have duplicate column value, SQL provides a keyword for such a function, called **DISTINCT**.

**Gotcha:** In SQL when we filter and sort queries, we need not request to see the column being filtered in question. i.e, we just want to see 2 columns and 3rd column is not needed to view but necessary for filter/sorting.

### DISTINCT
- DISTINCT keyword will blindly remove duplicate rows
- it removes rows where all the selected columns match, not just one column.

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

Examples: Refer lesson 4 of sqlbolt file

## Multi-table queries with JOINs

Data and data-sets in the real world is often broken down into pieces and stored across multiple separate tables using a process known as normalization. 

### Database normalization

Normalization is the process of organizing the columns (attributes) and tables (relations) of a database to ensure that their dependencies are properly enforced by database integrity constraints. It is accomplished by applying some formal rules either by a process of synthesis (creating a new database design) or decomposition (improving an existing database design).

Normalization is based on functional dependencies. When we use functional dependencies, we break a table into multiple tables that should helps us in preventing duplicate data and hence Improves Data Quality, less errors and better database design.

#### Dependency
Dependency is the process where the column(attribute or set of attributes) hold unique values and is used the determined the value of another column(attribute of the same table or different table that holds attributes from the first table as well )

X → Y

Here, X is the determinant, and Y is the dependent attribute. This means that for each unique value of X, there is precisely one corresponding value of Y.

- Basically 2 tables have same attributes and we use them as a link to pull necessary values from either tables.

#### Normal Forms

Normal forms are a set of progressive rules (or design checkpoints) for relational schemas that reduce redundancy and prevent data anomalies. Each normal form ( 1NF, 2NF, 3NF, BCNF, 4NF, 5NF ) is stricter than the previous one: meeting a higher normal form implies the lower ones are satisfied.

refer for more detail: https://www.geeksforgeeks.org/dbms/normal-forms-in-dbms/
**Note:** come back when more clarity is needed as normal forms are quite long need more in depth study later.

### JOIN statements
Tables that share information on a single entity need to have a __primary key__ that is used to identify uniquely across the database.
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

### NULL

A NULL value represents an unknown, missing, or inapplicable data in a database field. It is not a value itself, but a placeholder to indicate the absence of data.
- to test we will have to use the IS NULL and IS NOT NULL operators instead.

```sql
SELECT column, another_column, …
FROM mytable
WHERE column IS/IS NOT NULL
AND/OR another_condition
AND/OR …;
```
