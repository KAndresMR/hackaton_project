from datetime import datetime
from pydantic import BaseModel, ConfigDict


class Transaction(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    type: str
    amount: float
    date: datetime
