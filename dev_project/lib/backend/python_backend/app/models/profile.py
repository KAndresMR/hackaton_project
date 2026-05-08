from pydantic import BaseModel, ConfigDict


class UserProfile(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    connected_bank: str
    automation_level: str
    optimized_money: float
    ai_status: bool