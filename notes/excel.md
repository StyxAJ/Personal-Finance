# Excel Notes

Built from W5–W6 work on `excel/finance_analysis.xlsx` (618 messy rows → 600 clean, totals = SQL: **600 rows, 385,323.67 AED**).

## Index

### Contents

- [Importing a CSV (Power Query)](#importing-a-csv-power-query) · [cleaning recipe](#cleaning-recipe-power-query-in-order)
- [Tables](#tables) · [selecting inside a table](#selecting-inside-a-table)
- [Cleaning](#cleaning) · [text](#text-trim-and-proper) · [paste values](#paste-values) · [duplicates](#remove-duplicates) · [text → numbers](#text--numbers) · [text → dates](#text--dates) · [blanks](#blanks)
- [XLOOKUP](#xlookup) · [vs VLOOKUP](#xlookup-vs-vlookup)
- [SUMIFS / COUNTIFS / COUNTIF](#sumifs--countifs--countif) · [date ranges](#date-ranges)
- [PivotTables](#pivottables) · [grouping dates](#grouping-dates) · [% of Grand Total](#-of-grand-total) · [number bands](#number-bands) · [slicers](#slicers) · [PivotChart](#pivotchart)
- [Gotchas](#gotchas)
- [Excel ↔ SQL](#excel--sql)

### Quick lookup

| I want to… | Go to |
|---|---|
| bring a CSV in without Excel "fixing" it | [Power Query](#importing-a-csv-power-query) |
| clean everything in one repeatable go | [Cleaning recipe](#cleaning-recipe-power-query-in-order) |
| fix messy spellings / spaces | [TRIM and PROPER](#text-trim-and-proper) |
| turn a formula column into fixed values | [Paste values](#paste-values) |
| "AED 120" → 120 | [text → numbers](#text--numbers) |
| DD/MM text → real date | [text → dates](#text--dates) |
| bring a column in from another table (JOIN) | [XLOOKUP](#xlookup) |
| total / count with conditions (WHERE) | [SUMIFS](#sumifs--countifs--countif) |
| total for one month | [date ranges](#date-ranges) |
| summary grid by category / month (GROUP BY) | [PivotTables](#pivottables) |
| share of total per category | [% of Grand Total](#-of-grand-total) |
| histogram-style counts | [number bands](#number-bands) |
| clickable filter | [slicers](#slicers) |
| chart of a pivot | [PivotChart](#pivotchart) |

## Importing a CSV (Power Query)

**Data → Get Data → From File → From Text/CSV** → pick the file → **Transform Data** (opens Power Query).

- **Use First Row as Headers** (Home tab): if the headers came in as row 1 of the data.
- **Delete the "Changed Type" step** (Applied Steps panel, right side): auto type detection silently converts or errors out the mess (e.g. "AED" amounts, DD/MM dates). Keep everything as text first, look at the mess, *then* clean it.
- **Close & Load** → lands as a Table on a new sheet.

What the raw data had: 17 blank categories, 44 "AED" amounts, 22 DD/MM dates, 18 duplicates.

### Cleaning recipe (Power Query, in order)
1. Use First Row as Headers
2. category: Transform → Format → Trim, then Capitalize Each Word
3. category: Replace Values → (blank) → Uncategorised
4. amount: Replace Values "AED " → (nothing), then Change Type → Decimal Number
5. txn_date: Change Type → Using Locale → Date, English (United Kingdom)
6. Home → Remove Rows → Remove Duplicates (select all columns first)
7. Close & Load → CHECK: 600 rows, sum 385,323.67. If not, stop and find out why.

Why this order:
- **Trim before Replace blanks:** a cell holding only spaces becomes truly blank after Trim, so step 3 catches it.
- **Remove Duplicates last:** rows that differ only in spelling, spacing, "AED" or date format become identical after cleaning, so they're caught too.

Tips:
- Step 3: if the blanks don't change, open **Advanced options** and tick **Match entire cell contents**. If they still don't change, the cells are `null`, not empty text: type `null` in Value To Find.
- Each step is saved in **Applied Steps**. New data → **Data → Refresh All** reruns the whole recipe, unlike formulas + paste values.
- Checked against `raw.csv` (W6 Sat): 618 → 600 rows, 385,323.67 = SQL.

## Tables

Select the range → **Ctrl+T** (or Insert → Table). Rename it in **Table Design → Table Name** (`tbl_raw`, `tbl_clean`, `tbl_categories`, `tbl_accounts`).

Why tables:
- formulas use names, not cell ranges: `tbl_clean[amount]`, `[@category]` (= this row's category)
- they grow automatically when you add rows
- **Total Row** (Table Design → tick Total Row) gives a quick SUM/COUNT at the bottom

### Selecting inside a table

- Click a cell in the column → **Ctrl+Space** selects just that table column (not the whole sheet column).
- Or type the range in the **Name Box** (left of the formula bar), e.g. `B2:B601`.

Selecting the whole sheet column (clicking the letter) also grabs headers and empty rows below.

## Cleaning

### Text: TRIM and PROPER

```
=PROPER(TRIM([@category]))
```
- `TRIM` removes extra spaces (leading, trailing, double)
- `PROPER` makes "groceries" / "GROCERIES" → "Groceries"
- Result here: 103 spellings → 10 categories + 17 blanks

### Paste values

A helper formula column must be turned into plain values before you overwrite the original or delete the source:

copy → right-click → **Paste Special → Values** (or **Ctrl+Shift+V** / Paste → 123 icon).

Pasting the *formula* back over the column it reads from = **circular reference** (the cell refers to itself). Fix: paste values over it.

### Remove Duplicates

Click in the table → **Data → Remove Duplicates** → tick all columns → 618 → 600.

### Text → numbers

Amounts like `AED 120.50` are text, so SUM ignores them.

```
=VALUE(TRIM(SUBSTITUTE([@amount], "AED", "")))
```
- `SUBSTITUTE(text, old, new)` replaces "AED" with nothing
- `TRIM` removes the space left behind
- `VALUE` turns the text "120.50" into the number 120.50

Check: a real number is right-aligned; text is left-aligned. `=ISNUMBER(A2)` → TRUE.

> I fixed these in place on W5 Tue but didn't type this formula myself → practise it.

### Text → dates

`raw.csv` has two formats, both loaded as text: `2026-03-20` (yyyy-mm-dd, 596 rows) and `01/06/2026` (dd/mm/yyyy, 22 rows).

`DATEVALUE` reads text using the PC's date format. On a US-format PC, "03/04/2026" (3 April) becomes 4 March. Build the date from its parts instead with `DATE(year, month, day)`, which works regardless of PC settings:

| Text | year | month | day |
|---|---|---|---|
| `2026-03-20` | `LEFT(d, 4)` | `MID(d, 6, 2)` | `RIGHT(d, 2)` |
| `01/06/2026` | `RIGHT(d, 4)` | `MID(d, 4, 2)` | `LEFT(d, 2)` |

One formula for both (has a `/` → dd/mm/yyyy, otherwise yyyy-mm-dd):

```
=IF(ISNUMBER(SEARCH("/", [@txn_date])),
    DATE(RIGHT([@txn_date], 4), MID([@txn_date], 4, 2), LEFT([@txn_date], 2)),
    DATE(LEFT([@txn_date], 4),  MID([@txn_date], 6, 2), RIGHT([@txn_date], 2)))
```
- `SEARCH("/", text)` returns the position of `/`, or `#VALUE!` if there isn't one; `ISNUMBER` turns that into TRUE/FALSE.

Steps:
1. New helper column `date_clean` in `tbl_clean` → type the formula (the table fills it down).
2. If it shows numbers like `46101`, that's a real date: **Home → Number Format → Short Date**.
3. Check: `=COUNT(tbl_clean[date_clean])` = 600 (COUNT only counts numbers, so text dates would be missed); spot-check `01/06/2026` → 1 June 2026; `MIN`/`MAX` give sensible first/last dates.
4. Copy `date_clean` → **Paste Values** over `txn_date` → delete the helper column (pasting the formula itself over `txn_date` = circular reference).

**Shorter formula:** `yyyy-mm-dd` text converts to a date on its own in any locale, so only the slash dates need taking apart. `--` (minus minus) turns text into a number; `VALUE()` does the same.

```
=IF(ISNUMBER(SEARCH("/", [@txn_date])),
    DATE(RIGHT([@txn_date], 4), MID([@txn_date], 4, 2), LEFT([@txn_date], 2)),
    --[@txn_date])
```

**Shortest, no formula (Power Query):** Data → Queries & Connections → open the query → right-click `txn_date` → **Change Type → Using Locale…** → Date, **English (United Kingdom)** → Close & Load. The UK locale reads `01/06/2026` as 1 June; `yyyy-mm-dd` works in any locale. Unlike a formula, it reruns on Refresh when new data comes in. (This is "Changed Type" done on purpose, with the format stated, not guessed.)

> Done in place on W5 Tue, formula not yet typed from memory → practise.

### Blanks

17 blank categories → filled with `Uncategorised` (type: Extra expense) because their real type is unknown. Don't guess a category; label it and keep it visible.

## XLOOKUP

Excel's JOIN: for each row, find a value in another table and bring back a column from it.

```
=XLOOKUP(lookup_value, lookup_column, return_column, if_not_found)

=XLOOKUP([@category], tbl_categories[name], tbl_categories[type], "Not found")
```
Result: 548 expense / 35 income / 17 Not found.

- Leave out the 4th argument → `#N/A` on anything without a match.
- Text in a formula needs **"double quotes"**: `"Not found"`, not `Not found`.
- Text `"1"` ≠ number `1`: if one table stores ids as text, the lookup fails. Convert both to numbers.

### XLOOKUP vs VLOOKUP

| | XLOOKUP | VLOOKUP |
|---|---|---|
| match | exact by default | approximate by default (need `FALSE`) |
| direction | can look left | only returns columns to the right |
| return column | by name/range | by column number (breaks if columns move) |
| not found | built-in 4th argument | needs `IFERROR` around it |

## SUMIFS / COUNTIFS / COUNTIF

SUMIFS = `SUM ... WHERE ... AND ...`. **Sum range first**, then range/condition pairs.

```
=SUMIFS(sum_range, criteria_range1, criteria1, criteria_range2, criteria2, ...)

=SUMIFS(tbl_clean[amount], tbl_clean[account_name], "Credit Card")      → 62066.54
=SUMIFS(tbl_clean[amount], tbl_clean[type], "expense")                   → 179905.19
```

COUNTIFS has no sum range, only pairs. COUNTIF = one condition.

```
=COUNTIF(tbl_clean[amount], ">500")                                      → 91
```

Comparison operators go **inside quotes**; join them to a cell or value with `&`:

```
=COUNTIF(tbl_clean[amount], ">" & H2)
```

### Date ranges

One month = **two conditions on the same column**: `>=` first day AND `<` first day of the next month.

```
=SUMIFS(tbl_clean[amount],
        tbl_clean[category], "Groceries",
        tbl_clean[txn_date], ">=" & DATE(2026,3,1),
        tbl_clean[txn_date], "<"  & DATE(2026,4,1))                      → 2087.99
```
Use `<` next month, not `<=` the last day/next month's 1st (my W5 Thu bug: `<=` April 1 included April 1).

## PivotTables

Excel's GROUP BY. Click in the table → **Insert → PivotTable** → New Worksheet. Drag fields into:
- **Rows**: what to group by (category)
- **Columns**: second grouping (type, month)
- **Values**: what to total (Sum of amount)
- **Filters**: restrict the whole pivot (type = expense)

Always check a pivot total against SUMIFS/SQL (expense by category = 179905.19 = SUMIFS).

### Grouping dates

Right-click a date in the pivot → **Group** → select **Months AND Years**.

Months only → Jan 2025 and Jan 2026 merge into one "Jan", and the order starts at Jan instead of your first month.

### % of Grand Total

Right-click a value → **Show Values As → % of Grand Total** (Rent 33.35%, Utilities 20.16%).

### Number bands

Put `amount` in Rows → right-click → **Group** → Starting at 0, Ending at 1000, By 100 → counts per 0–100, 100–200, … Use Count of amount in Values.

### Slicers

Click the pivot → **PivotTable Analyze → Insert Slicer** → pick a field (account type). Clickable filter buttons; check the filtered total against SUMIFS.

### PivotChart

Click the pivot → **PivotTable Analyze → PivotChart** → Line for trends over months (monthly expense peaked Nov 2025).

## Gotchas

- **Auto type detection** hides mess → delete "Changed Type" in Power Query first.
- **Circular reference** → you pasted a formula over the cells it reads. Ctrl+Z, paste **Values** only.
- **Paste values errors**:
  - *"You can't change part of an array" / spill range* → the formula was written once for the whole column (`=PROPER(TRIM(tbl_raw[category]))`) and spilled. Copy the **whole** spill, or write it per row instead: `=PROPER(TRIM([@category]))`.
  - *"Copy area and paste area aren't the same size"* → one side is the whole sheet column (clicked the letter), the other a table column. Use **Ctrl+Space** inside the table on both sides.
  - *"This won't work because it would move cells in a table"* → selection crosses the table edge (header, Total Row, rows below). Select with Ctrl+Space or the Name Box (`B2:B619`).
  - *0 / #REF! after deleting the helper* → you pasted the formula, not values, so it still points at the deleted column. Ctrl+Z, paste Values.
  - Order that always works: helper column → Ctrl+Space → Ctrl+C → first data cell of the original column → Ctrl+Space → **Ctrl+Shift+V** → check → delete helper.
- **Pivot filter "(Multiple Items)"** → a filter can silently include 2 items. Open it and check what's ticked.
- **Text vs number** → left-aligned numbers are text; lookups and SUMs miss them.
- **DATEVALUE on DD/MM** → misreads on a US-format PC. Use `DATE(...)`.
- **Totals don't match SQL** → find the rows that differ (my 3863.99 gap = expense rows that lost their category and became Uncategorised).

## Excel ↔ SQL

| Excel | SQL |
|---|---|
| Table | table |
| filter / SUMIFS conditions | `WHERE` |
| XLOOKUP | `JOIN` |
| SUMIFS / COUNTIFS | `SUM(...) / COUNT(*) ... WHERE` |
| PivotTable | `GROUP BY` |
| pivot grouped by Months + Years | `date_trunc('month', txn_date)` |
| `>=` start, `<` next start | `txn_date >= '2026-03-01' AND txn_date < '2026-04-01'` |
| Remove Duplicates | `DISTINCT` |
| "Not found" fallback | `COALESCE` after a `LEFT JOIN` |
