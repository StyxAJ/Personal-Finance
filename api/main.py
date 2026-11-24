from datetime import date
from decimal import Decimal
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

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