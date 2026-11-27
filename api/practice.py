from fastapi import FastAPI, HTTPException 
import os
import psycopg

app = FastAPI()

students = {
    1 : {"name": "Alice", "age": 20 , "class": "CS101"}
}

@app.get("/")
def index():
    return {"name": "Hello World"}

@app.get("/students/{student_id}")
def get_student(student_id: int):
    if student_id not in students:
        raise HTTPException(status_code=404, detail=f"Student {student_id} not found")
    return students[student_id]


@app.get("/hello/{name}")          # {name} in the path = path parameter
def hello(name: str):
    print("called hello with", name)
    return {"greeting": "hi " + name}

@app.get("/square")                # n is NOT in the path = query parameter
def square(n: int):
    return {"n": n, "square": n * n}

FRUITS = {1: "apple", 2: "mango"}

@app.get("/fruits/{fruit_id}")
def get_fruit(fruit_id: int):
    if fruit_id not in FRUITS:
        raise HTTPException(status_code=404, detail=f"Fruit {fruit_id} not found")
    return {"id": fruit_id, "name": FRUITS[fruit_id]}

@app.get("/accounts/{account_id}")
def get_account(account_id: int):
    with psycopg.connect(dbname="finance", user="arsha",
                         password=os.environ["DB_PASSWORD"]) as conn:
        row = conn.execute("SELECT id, name FROM accounts WHERE id = %s",
                           (account_id,)).fetchone()
    if row is None:
        raise HTTPException(status_code=404, detail=f"Account {account_id} not found")
    return {"id": row[0], "name": row[1]}