# DBMS 02 — Keys

Sources:
- [Wikipedia — Relational model](https://en.wikipedia.org/wiki/Relational_model)
- [PostgreSQL Tutorial 3.3 — Foreign Keys](https://www.postgresql.org/docs/current/tutorial-fk.html)

## Relational model terms
| Theory term | SQL / table term |
|---|---|
| Relation | Table |
| Tuple | Row |
| Attribute | Column |
| Domain | Data type |

- A **relation** has a **heading** (its set of attributes) and a **body** (its set of tuples).
- Each **attribute** has a name and a data type.
- A **domain** is the set of allowed values, e.g. all integers or all dates.
- Tuples have **no order**.
- **Degree** = number of attributes (columns).
- **Cardinality** = number of tuples (rows).
- **Relvar** = a relation variable that can be reassigned. A database is a collection of relvars.

## Keys
- **Superkey**: any set of columns whose combined values are unique across all rows.
  - Can include extra, unneeded columns.
- **Candidate key**: a **minimal** superkey. Remove any column and it stops being unique.
  - Every relation has at least one. In the worst case it is all the columns.
  - A relation can have several.
- **Primary key (PK)**: the one candidate key chosen as the main identifier.
- **Alternate keys**: the candidate keys that were not chosen as the PK.
- **Composite key**: a key made of more than one column.
- **Unique right now ≠ key.** A column may happen to be unique in today's data without being a key. A key is a rule that must **always** hold.
  - e.g. if `{ID}` is a key, no two employees can ever share an ID.

```
Superkeys ⊇ Candidate keys ⊇ Primary key
```

## Foreign keys
- **Foreign key (FK)**: column(s) in table R1 that refer to a key in table R2.
- Every FK value in R1 must exist as a key value in R2.
  - e.g. `Order.customer_id` → `Customer.id`.
- An FK is an **integrity constraint**: it limits values to those present in the referenced key.

## Referential integrity
- **Referential integrity** means no row may point at a row that doesn't exist.
- The doing-it-by-hand approach is to check the parent table first, then insert or reject. That is error-prone, so let the DBMS enforce it instead.

```sql
CREATE TABLE cities (
    name     varchar(80) primary key,
    location point
);

CREATE TABLE weather (
    city    varchar(80) references cities(name),  -- FK → cities.name
    temp_lo int,
    temp_hi int,
    prcp    real,
    date    date
);

INSERT INTO weather VALUES ('Berkeley', 45, 53, 0.0, '1994-11-28');
-- ERROR: insert or update on table "weather" violates foreign key constraint "weather_city_fkey"
-- DETAIL: Key (city)=(Berkeley) is not present in table "cities".
```

- FK behavior can be tuned further (for example, what happens on delete or update). See PostgreSQL docs Chapter 5.

## Constraints (general)
- A **constraint** is a rule (a boolean condition) that must always be true.
- If all constraints are true, the database is **consistent**.
- The DBMS **rejects** any change that would break a constraint.
- **Functional dependency** `X → Y`: the value of X determines the value of Y (related idea, used later in normalization).

## Key takeaways
- Relation/tuple/attribute = table/row/column.
- Superkey = unique. Candidate key = minimal unique. PK = the chosen candidate key.
- FK = a pointer to another table's key, enforced by the DB (referential integrity).
- A key is a rule about all possible data, not just the data you have now.
