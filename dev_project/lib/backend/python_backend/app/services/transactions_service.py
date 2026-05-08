from app.models.transaction import Transaction
from app.services.simulation_service import get_simulation_engine


def list_transactions() -> list[Transaction]:
    return get_simulation_engine().list_transactions()
