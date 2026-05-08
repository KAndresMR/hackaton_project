from pydantic import BaseModel, ConfigDict


class BankConnection(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    connected: bool = False