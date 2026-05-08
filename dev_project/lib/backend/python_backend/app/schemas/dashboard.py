from pydantic import BaseModel


class DashboardMetrics(BaseModel):
    balance: int
    protected_funds: int
    available_liquidity: int
    risk_score: int
