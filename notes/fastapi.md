# FastAPI Notes

Topics follow the order of freeCodeCamp's *Python API Development – Comprehensive Course for Beginners*. Examples come from this repo: [api/main.py](../api/main.py), [api/practice.py](../api/practice.py), [api/db_check.py](../api/db_check.py).

## Index

### Contents

- [What an API is](#what-an-api-is) · [HTTP methods](#http-methods) · [status codes](#status-codes)
- [First app](#first-app) · [running it](#running-the-server) · [auto docs](#auto-docs-docs)
- [Path operations](#path-operations) · [route order](#route-order-matters)
- [Path parameters](#path-parameters) · [query parameters](#query-parameters) · [type validation (422)](#type-validation-422)
- [Request body + Pydantic](#request-body-with-pydantic)
- [Errors with HTTPException](#errors-with-httpexception)
- [Connecting to Postgres](#connecting-to-postgres) · [SQL injection and %s](#sql-injection-and-s) · [rows to JSON](#turning-a-row-into-json)
- [Environment variables](#environment-variables)
- [Gotchas](#gotchas)
- [Coming up later in the course](#coming-up-later-in-the-course)

### Quick lookup

| I want to… | Go to |
|---|---|
| make a URL call a function | [Path operations](#path-operations) |
| take a value from the URL path (`/fruits/2`) | [Path parameters](#path-parameters) |
| take `?n=4` from the URL | [Query parameters](#query-parameters) |
| accept JSON in a POST | [Request body + Pydantic](#request-body-with-pydantic) |
| return 404 | [HTTPException](#errors-with-httpexception) |
| read from the database in a route | [Connecting to Postgres](#connecting-to-postgres) |
| keep the DB password out of code | [Environment variables](#environment-variables) |
| test endpoints without a browser | [Auto docs](#auto-docs-docs) |
| work out why I got 500 / 404 / 422 | [Gotchas](#gotchas) |

## What an API is

An **API** (here a web API) is a program that waits for **requests** over HTTP and sends back **responses**, usually as JSON. The browser, Postman or another program is the **client**; our FastAPI app is the **server**.

The main idea: **a request is a function call.** Visiting a URL makes FastAPI call one Python function, pass it values from the URL or body, and turn whatever it returns into JSON.

> When I visit `/square?n=4`, FastAPI calls `square` with `n=4` and turns the returned dict into JSON.

### HTTP methods

The method says what the client wants to do. CRUD maps onto it like this:

| CRUD | Method | Decorator | Example |
|---|---|---|---|
| Create | POST | `@app.post` | add a transaction |
| Read | GET | `@app.get` | `/categories/5` |
| Update | PUT / PATCH | `@app.put` / `@app.patch` | rename a category |
| Delete | DELETE | `@app.delete` | remove a transaction |

A browser address bar can only send GET. To try POST/PUT/DELETE, use `/docs` or Postman.

### Status codes

| Code | Meaning | When we see it |
|---|---|---|
| 200 | OK | normal return |
| 201 | Created | after a POST creates something (set with `status_code=201`) |
| 204 | No Content | after a DELETE |
| 404 | Not Found | we raised `HTTPException(404)`, or **no route matched the URL** |
| 422 | Unprocessable Entity | FastAPI rejected the input before our function ran (`/square?n=abc`) |
| 500 | Internal Server Error | our code crashed: look at the uvicorn terminal |

## First app

```python
from fastapi import FastAPI

app = FastAPI()          # the app object uvicorn looks for

@app.get("/health")      # decorator: GET /health → call the function below
def health_check():
    return {"status": "ok"}   # dict → JSON automatically
```

From [api/main.py](../api/main.py). Returning a dict, list, str, int or a Pydantic model all work. FastAPI converts it to JSON.

### Running the server

```powershell
python -m uvicorn api.main:app --reload
```

- `api.main` = the file `api/main.py` (folder.file, no `.py`)
- `:app` = the variable inside it named `app`
- `--reload` = restart automatically when you save a file
- server lives at `http://127.0.0.1:8000`; stop it with `Ctrl+C`

The course runs `uvicorn ...` directly. On this laptop Windows blocks `uvicorn.exe`, so use `python -m uvicorn`. It's the same thing, started through `python.exe`.

### Auto docs (/docs)

FastAPI builds interactive docs from your code for free:

- `http://127.0.0.1:8000/docs`: Swagger UI. Click a route → **Try it out** → **Execute**. Works for POST too.
- `http://127.0.0.1:8000/redoc`: read-only version.

## Path operations

A **path operation** = path (`/fruits/{fruit_id}`) + method (GET) + the function that handles it. The course also calls the function a *path operation function* or *route*.

### Route order matters

FastAPI checks routes **top to bottom** and uses the first match.

```python
@app.get("/posts/{id}")      # "/posts/latest" matches this first → id="latest" → 422
def get_post(id: int): ...

@app.get("/posts/latest")    # never reached
def get_latest(): ...
```

Fix: put fixed paths (`/posts/latest`) **above** the ones with parameters.

## Path parameters

A `{name}` in the path becomes a function argument with the same name.

```python
@app.get("/hello/{name}")
def hello(name: str):
    print("called hello with", name)   # shows in the uvicorn terminal
    return {"greeting": "hi " + name}
```

`/hello/Arsh` → `hello(name="Arsh")` → `{"greeting":"hi Arsh"}` ([api/practice.py](../api/practice.py))

## Query parameters

A function argument that is **not** in the path is read from `?key=value` after the URL.

```python
@app.get("/square")
def square(n: int):
    return {"n": n, "square": n * n}
```

`/square?n=4` → `square(n=4)` → `{"n":4,"square":16}`

Give it a default to make it optional: `def list_txns(limit: int = 10)`. Then `/transactions` and `/transactions?limit=50` both work.

### Type validation (422)

The type hint (`n: int`) does real work: FastAPI converts the text `"4"` to the int `4`, and if it can't (`?n=abc`) it returns **422** without ever calling your function.

## Request body with Pydantic

For POST/PUT the data comes as JSON in the **body**. Describe its shape with a Pydantic `BaseModel` (the course calls this a **schema**).

```python
from datetime import date
from decimal import Decimal
from pydantic import BaseModel

class TransactionIn(BaseModel):
    account_id: int
    category_id: int
    amount: Decimal
    txn_date: date
    description: str | None = None   # optional: may be missing or null

@app.post("/transactions/check")
def check_transaction(transaction: TransactionIn):
    return transaction
```

From [api/main.py](../api/main.py). A parameter whose type is a `BaseModel` → FastAPI reads it from the body.

- missing a required field, or `"amount": "abc"` → **422** with a message saying which field
- `"txn_date": "2025-10-01"` is converted to a real `date` object
- inside the function, use `transaction.amount`; to get a dict back use `transaction.model_dump()`

How FastAPI decides where an argument comes from:

| Argument is… | FastAPI reads it from |
|---|---|
| named in the path `{...}` | the path |
| a simple type (`int`, `str`) not in the path | the query string |
| a Pydantic model | the JSON body |

## Errors with HTTPException

`raise` stops the function right there and sends an error response.

```python
from fastapi import HTTPException

FRUITS = {1: "apple", 2: "mango"}

@app.get("/fruits/{fruit_id}")
def get_fruit(fruit_id: int):
    if fruit_id not in FRUITS:
        raise HTTPException(status_code=404, detail=f"Fruit {fruit_id} not found")
    return {"id": fruit_id, "name": FRUITS[fruit_id]}
```

`/fruits/9` → `404 {"detail":"Fruit 9 not found"}`

A **custom** detail message proves your code ran. Plain `{"detail":"Not Found"}` means FastAPI found **no route** (typo, `//` in the URL, or the server was started from a different file).

To change the success code: `@app.post("/transactions", status_code=201)`. The course uses `from fastapi import status` → `status.HTTP_404_NOT_FOUND`, which is the same number with a readable name.

## Connecting to Postgres

The course uses `psycopg2` with `RealDictCursor`. This repo uses **psycopg 3** (`import psycopg`). The idea is the same, but the syntax is a bit shorter.

Step 1, check that plain Python can connect ([api/db_check.py](../api/db_check.py)):

```python
import os
import psycopg

with psycopg.connect(dbname="finance", user="arsha", password=os.environ["DB_PASSWORD"]) as conn:
    cur = conn.execute("SELECT * FROM transactions ORDER BY id LIMIT 5")
    for row in cur.fetchall():
        print(row)
```

Step 2, the same thing inside a route:

```python
@app.get("/categories/{category_id}")
def get_category(category_id: int):
    with psycopg.connect(dbname="finance", user="arsha", password=os.environ["DB_PASSWORD"]) as conn:
        row = conn.execute("SELECT id, name FROM categories WHERE id = %s", (category_id,)).fetchone()
    if row is None:
        raise HTTPException(status_code=404, detail="Category not found")
    return {"id": row[0], "name": row[1]}
```

`/categories/5` → 200 · `/categories/999` → 404. `/accounts/{account_id}` in [api/practice.py](../api/practice.py) has the same shape.

| psycopg | What it does |
|---|---|
| `with psycopg.connect(...) as conn:` | open a connection; closes (and commits) at the end of the block |
| `conn.execute(sql, params)` | run one query |
| `.fetchone()` | one row as a tuple, or `None` if nothing matched |
| `.fetchall()` | list of tuples |
| `conn.commit()` | save an INSERT/UPDATE/DELETE (the `with` block also commits) |

### SQL injection and %s

**Never** build SQL with f-strings:

```python
conn.execute(f"SELECT * FROM categories WHERE id = {category_id}")   # ❌ injection risk
conn.execute("SELECT * FROM categories WHERE id = %s", (category_id,))  # ✅
```

psycopg sends the value separately from the SQL, so input can't change the query. `(category_id,)` needs the comma: it must be a **tuple**, even with one value.

### Turning a row into JSON

`fetchone()` returns a tuple like `(5, 'Groceries')`. Returning it directly gives the JSON list `[5,"Groceries"]`. Build a dict so the response has named keys:

```python
return {"id": row[0], "name": row[1]}
```

The course's `RealDictCursor` (psycopg2) or psycopg 3's `row_factory=dict_row` do this for you:

```python
from psycopg.rows import dict_row
with psycopg.connect(..., row_factory=dict_row) as conn:
    row = conn.execute(...).fetchone()   # {'id': 5, 'name': 'Groceries'}
```

## Environment variables

The password never goes in code or git. Code reads it with `os.environ["DB_PASSWORD"]`.

| Command (PowerShell) | Lasts |
|---|---|
| `$env:DB_PASSWORD = "..."` | this terminal only, gone when closed |
| `setx DB_PASSWORD "..."` | permanent, but only for terminals/apps opened **after** (restart VS Code fully) |
| `$env:DB_PASSWORD = [Environment]::GetEnvironmentVariable('DB_PASSWORD','User')` | load the saved one into the current terminal without restarting |

Check: `echo $env:DB_PASSWORD` (empty = not set).

Later the course moves this into a `.env` file read by Pydantic `BaseSettings`. `.env` must be in `.gitignore`. See also [theory/api-keys.md](../theory/api-keys.md).

## Gotchas

| Symptom | Cause | Fix |
|---|---|---|
| 500, uvicorn shows `KeyError: 'DB_PASSWORD'` | terminal doesn't have the env var | see [Environment variables](#environment-variables) |
| 500, `password authentication failed` | wrong password saved | `setx` again with the right one |
| `{"detail":"Not Found"}` with no custom message | no route matched | check spelling, remove `//`, check which file uvicorn is running |
| 422 | input type wrong or body field missing | read the `detail`; it names the field |
| server won't start, `SyntaxError` | typo in the file, e.g. `@app.get{"/"}` instead of `@app.get("/")` | one syntax error kills every route in the file |
| `uvicorn.exe ... blocked by Application Control policy` | Windows blocks the launcher | `python -m uvicorn ...` |
| changes don't show | started without `--reload`, or edited a different file | restart with `--reload` |
| route returns a list `[5,"Groceries"]` | returned the raw tuple | return a dict |

**When you get a 500, look at the uvicorn terminal, not the browser.** The last line of the traceback names the cause.

## Coming up later in the course

Not covered in this repo yet. Add notes here as we reach them:

- full CRUD for transactions (POST to insert, PUT, DELETE + `RETURNING *`)
- response models (`response_model=`) to control what's sent back
- SQLAlchemy ORM instead of raw SQL
- routers (`APIRouter`) to split `main.py` into files
- users, password hashing, JWT login
- `.env` + Pydantic settings
- Alembic migrations · CORS · testing with pytest · Docker · deployment
