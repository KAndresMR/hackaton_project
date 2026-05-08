from pydantic import BaseModel, Field

from app.models.automation_event import AutomationEvent
from app.models.transaction import Transaction
from app.schemas.dashboard import DashboardMetrics


class SalarySimulationRequest(BaseModel):
    amount: float = Field(default=1500.0, gt=0)
    reserve_amount: float = Field(default=400.0, ge=0)
    source: str = Field(default="Salary detected")


class ExpenseSimulationRequest(BaseModel):
    amount: float = Field(default=250.0, gt=0)
    category: str = Field(default="expense")
    description: str = Field(default="Expense detected")


class AutomationRunRequest(BaseModel):
    trigger: str = Field(default="manual")


class SimulationResponse(BaseModel):
    message: str
    dashboard: DashboardMetrics
    created_transactions: list[Transaction]
    created_events: list[AutomationEvent]
    rules_executed: list[str]