from fastapi import APIRouter

from app.schemas.simulation import ExpenseSimulationRequest, SalarySimulationRequest, SimulationResponse
from app.services.simulation_service import get_simulation_engine

router = APIRouter(tags=["simulation"])


@router.post("/simulate/salary", response_model=SimulationResponse)
def simulate_salary(payload: SalarySimulationRequest) -> SimulationResponse:
    return get_simulation_engine().simulate_salary(
        amount=payload.amount,
        reserve_amount=payload.reserve_amount,
        source=payload.source,
    )


@router.post("/simulate/expense", response_model=SimulationResponse)
def simulate_expense(payload: ExpenseSimulationRequest) -> SimulationResponse:
    return get_simulation_engine().simulate_expense(
        amount=payload.amount,
        category=payload.category,
        description=payload.description,
    )