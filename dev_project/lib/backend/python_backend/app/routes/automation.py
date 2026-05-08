from fastapi import APIRouter

from app.models.automation_event import AutomationEvent
from app.services.automation_service import list_automation_timeline

router = APIRouter(tags=["automation"])


@router.get("/automation/timeline", response_model=list[AutomationEvent])
def read_automation_timeline() -> list[AutomationEvent]:
    return list_automation_timeline()
