from fastapi import APIRouter

from app.models.automation_event import AutomationEvent
from app.schemas.simulation import AutomationRunRequest, SimulationResponse
from app.services.automation_service import list_automation_timeline
from app.services.simulation_service import get_simulation_engine

router = APIRouter(tags=["automation"])


@router.get("/automation/timeline", response_model=list[AutomationEvent])
def read_automation_timeline() -> list[AutomationEvent]:
    return list_automation_timeline()


@router.post("/automation/run", response_model=SimulationResponse)
def run_automation(payload: AutomationRunRequest) -> SimulationResponse:
    return get_simulation_engine().run_automation(trigger=payload.trigger)