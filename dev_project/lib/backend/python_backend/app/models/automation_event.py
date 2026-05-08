from datetime import datetime
from pydantic import BaseModel, ConfigDict


class AutomationEvent(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    action: str
    status: str
    timestamp: datetime
