from app.models.transaction import Transaction
from app.services.mock_data import MOCK_TRANSACTIONS
from app.core.supabase import get_supabase_client


def list_transactions() -> list[Transaction]:
    client = get_supabase_client()
    if client:
        try:
            res = client.table("transactions").select("*").execute()
            data = getattr(res, "data", None)
            if data is None and isinstance(res, dict):
                data = res.get("data")
            if data:
                return [Transaction(**item) for item in data]
        except Exception:
            pass
    return MOCK_TRANSACTIONS
