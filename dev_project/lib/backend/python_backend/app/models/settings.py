from pydantic import BaseModel, ConfigDict


class AutomationSettings(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    auto_reserve: bool
    liquidity_protection: bool
    automatic_payments: bool
    ai_optimization: bool