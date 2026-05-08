from app.schemas.dashboard import DashboardMetrics
from app.services.mock_data import MOCK_TRANSACTIONS, MOCK_USER
from app.core.supabase import get_supabase_client


def get_dashboard_metrics() -> DashboardMetrics:
    client = get_supabase_client()
    if client:
        try:
            res = client.table("users").select("*").eq("id", 1).single().execute()
            data = getattr(res, "data", None)
            if data is None and isinstance(res, dict):
                data = res.get("data")
            if data:
                balance = int(data.get("balance", MOCK_USER.balance))
                return DashboardMetrics(
                    balance=balance,
                    protected_funds=data.get("protected_funds", 400),
                    available_liquidity=data.get("available_liquidity", 300),
                    risk_score=data.get("risk_score", 12),
                )
        except Exception:
            pass

    return DashboardMetrics(
        balance=int(MOCK_USER.balance),
        protected_funds=400,
        available_liquidity=300,
        risk_score=12,
    )
