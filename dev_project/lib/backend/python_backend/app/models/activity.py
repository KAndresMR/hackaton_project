from datetime import datetime

from pydantic import BaseModel, ConfigDict


class ActivityEntry(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    title: str
    description: str
    category: str
    amount: float | None = None
    status: str = "completed"
    timestamp: datetime