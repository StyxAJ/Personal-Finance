# DBMS 01 — Basics

Source: [PostgreSQL Tutorial 2.2 — Concepts](https://www.postgresql.org/docs/current/tutorial-concepts.html)

## RDBMS
- PostgreSQL is an **RDBMS** (Relational Database Management System).
- It manages data stored in **relations**.
- **Relation** = the mathematical term for a **table**.

## Other ways to organize data
- Tables are not the only option.
- **Hierarchical database**: files and folders on Unix-like systems are an example.
- **Object-oriented database**: a newer approach.

## Tables, rows, columns
- A **table** is a named collection of **rows**.
- Every row in a table has the **same set of named columns**.
- Each column has a **specific data type** (e.g. int, text, date).
- **Column order is fixed** within each row.
- **Row order is NOT guaranteed** by SQL. Use `ORDER BY` when you need sorted output.

## Hierarchy
- Tables are grouped into **databases**.
- A group of databases managed by one PostgreSQL server instance is a **database cluster**.

```
Cluster (one server instance)
 └── Database
      └── Table
           └── Row  →  Columns (each with a data type)
```

## Key takeaways
- Relation = table.
- Same columns in every row, each column typed.
- Never rely on row order without `ORDER BY`.
- Cluster ⊃ Database ⊃ Table ⊃ Row.
