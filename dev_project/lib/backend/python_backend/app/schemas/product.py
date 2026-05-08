from pydantic import BaseModel


class ConnectBankRequest(BaseModel):
    bank_name: str


class UpdateSettingsRequest(BaseModel):
    auto_reserve: bool | None = None
    liquidity_protection: bool | None = None
    automatic_payments: bool | None = None
    ai_optimization: bool | None = None