from fastapi import APIRouter

from app.models.transaction import Transaction
from app.services.transactions_service import list_transactions

router = APIRouter(tags=["transactions"])


@router.get("/transactions", response_model=list[Transaction])
def read_transactions() -> list[Transaction]:
    return list_transactions()
