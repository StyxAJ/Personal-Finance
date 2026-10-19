# DBMS 03 — Normalisation

Source: [Wikipedia — Database normalization](https://en.wikipedia.org/wiki/Database_normalization)

## What is it?
- **Normalisation** is the process of organising columns and tables so that each fact is stored in **one place only**.
- It is done by following the **normal forms** (1NF, 2NF, 3NF, …), where each one is stricter than the last and meeting a higher one means the lower ones are met too.
- In practice it usually means **splitting one big table into smaller tables** linked by keys.

## Why does it exist?
- When the same fact is repeated across many rows, the copies can drift apart and the data stops being trustworthy.
- Normalisation removes that repetition so the DBMS can keep the data consistent through keys and constraints, instead of us fixing it by hand.
- A badly designed table suffers from 3 kinds of **anomalies**:
  - **Insertion anomaly**: some facts can't be recorded until some other, unrelated fact exists.
    - e.g. a new faculty member can't be added until they are teaching at least one course.
  - **Update anomaly**: the same fact is stored in several rows, so an update that misses one row leaves the data **inconsistent**.
    - e.g. an employee's address changed in one row but not in the others.
  - **Deletion anomaly**: deleting one fact also deletes another fact we wanted to keep.
    - e.g. removing the last course a faculty member teaches also removes the faculty member.

## Normal forms (Wikipedia's Book example)

### 1NF — Satisfying 1NF
- **Rule:** every cell holds **one single (atomic) value**. No lists in a cell, and no repeating groups of columns (Subject1, Subject2, Subject3).
- In the Book table, the **Subject** column held several values in one cell (e.g. "MySQL, Database, Design").
- **Fix:** move Subject out into **its own table**, with one row per (book, subject) pair, linked back to the book.

```
Before:  Book(Title, Format, Author, …, Subject = "MySQL, Database, Design")
After:   Book(Title, Format, Author, …)
         Book_Subject(Title, Subject)     -- one row per subject
```

### 2NF
- **Rule:** be in 1NF, and every non-key column must depend on the **whole** candidate key, not just part of it (only matters when the key is composite).
- In the Book table the key is **{Title, Format}** (the same book can come as Hardcover or E-book).
- **Price** depends on **Title and Format** together (the e-book is cheaper than the hardcover), but columns like Author and Pages depend on **Title only**. That's a **partial dependency**.
- **Fix:** split the table so each column sits with the key it actually depends on.

```
Book(Title, Author, Pages, …)       -- depends on Title only
Price(Title, Format, Price)         -- depends on the full {Title, Format} key
```

### 3NF
- **Rule:** be in 2NF, and no non-key column may depend on **another non-key column**. Every non-key column must depend on the key directly, not through some other column.
- When it goes key → column A → column B, that's a **transitive dependency**, and it's the 3NF violation.
- In the Book table (key = Title), after 2NF:
  - **Author Nationality** depends on **Author**, and Author depends on Title.
  - **Publisher Country** depends on **Publisher**, and Publisher depends on Title.
  - **Genre Name** depends on **Genre ID**, and Genre ID depends on Title.
- So the nationality of an author is repeated on every one of their books (the same update anomaly again).
- **Fix:** move each of those facts into a table keyed by the column it really depends on.

```
Book(Title, Author, Pages, Thickness, Publisher, Genre_ID)
Author(Author, Nationality)
Publisher(Publisher, Country)
Genre(Genre_ID, Genre_Name)
Price(Title, Format, Price)         -- unchanged from 2NF
```

#### Checking my schema
- `categories(id, name, type)`: **3NF ✅.** The only key is `id`. `name` and `type` both describe the category itself, and neither one decides the other (one name doesn't fix a type, and many categories share a type).
- `accounts(id, name)`: **3NF ✅.** There's only one non-key column, so there's no other non-key column for it to depend on.
- `transactions(id, account_id, category_id, amount, txn_date, description)`: **3NF ✅.** Every column describes that one transaction, found by `id`. The category's name and type and the account's name are not copied in; only the FK ids are stored, so there's no `category_id → category_name` chain inside this table.

## An example
Using my finance data. Imagine a bad one-table design where every row repeats the category's name and type:

```
transactions(id, amount, txn_date, category_name, category_type, account_name)
```

### 1. Anomalies
- **Update anomaly:** renaming "Dining Out" to "Restaurants" means updating every Dining Out row. Miss one and the same category now has 2 names.
- **Insert anomaly:** I can't add a new category "Education" until it has a transaction, since a category only exists as part of a transaction row (I'd need a fake transaction or a row full of NULLs).
- **Delete anomaly:** deleting the only Healthcare transaction also deletes the fact that a Healthcare category exists and that it's an expense.

### 2. 1NF break
- A `tags` column holding `"food, weekend"` stores **a list in one cell**, so the value is not atomic.
- Filtering gets messy (`tags LIKE '%food%'` would also match "seafood"), and tags can't be indexed or checked one by one.
- **Fix:** a separate `transaction_tags(transaction_id, tag)` table, one row per tag.

### 3. 2NF break
```
budgets(category_id, month, limit_amount, category_name)   -- key = (category_id, month)
```
- `limit_amount` depends on the **whole** key (each category gets a limit per month). ✅
- `category_name` depends on **category_id only**, not on month. That's the partial dependency, so the 2NF violation. ❌
- **Fix:** drop `category_name` from budgets and get it from the `categories` table through `category_id`.

**Note:** my actual [schema.sql](../sql/project/schema.sql) already avoids all this. Category name and type live once in `categories`, account names once in `accounts`, and `transactions` only holds the ids (FKs).

## An interview question
**Q:** What problems does normalisation solve, and how do 1NF and 2NF differ?

**A:** It removes duplicated data, which causes insertion, update and deletion anomalies. 1NF means every cell holds a single atomic value (no lists or repeating columns). 2NF builds on 1NF and says every non-key column must depend on the whole composite key, not just part of it. Fixing either one usually means splitting the table and linking the parts with keys.

## Key takeaways
- Normalisation = store each fact once, by splitting tables and linking them with keys.
- Repeated data → insertion, update and deletion anomalies.
- 1NF: one value per cell, no lists, no repeating column groups.
- 2NF: 1NF + no column depends on only part of a composite key.
- 3NF: 2NF + no non-key column depends on another non-key column (no transitive dependency).
- Higher normal forms include the lower ones (3NF ⇒ 2NF ⇒ 1NF).
