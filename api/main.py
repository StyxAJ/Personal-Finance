from datetime import date
from decimal import Decimal
import os
from fastapi import FastAPI, HTTPException
import psycopg
from pydantic import BaseModel

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello World"}

@app.get("/health")
def health_check():
    return {"status": "ok"}

class TransactionIn(BaseModel):
    account_id: int
    category_id: int
    amount: Decimal
    txn_date: date
    description: str | None = None

@app.post("/transactions/check")
def check_transaction(transaction: TransactionIn):
    return transaction

@app.get("/categories/{category_id}")
def get_category(category_id: int):
    with psycopg.connect(dbname="finance", user="arsha", password=os.environ["DB_PASSWORD"]) as conn:
        row = conn.execute("SELECT id, name FROM categories WHERE id = %s", (category_id,)).fetchone()
    if row is None:
        raise HTTPException(status_code=404, detail="Category not found")
    return {"id": row[0], "name": row[1]}