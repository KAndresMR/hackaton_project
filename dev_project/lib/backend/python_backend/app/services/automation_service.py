from app.models.automation_event import AutomationEvent
from app.services.simulation_service import get_simulation_engine


def list_automation_timeline() -> list[AutomationEvent]:
    return get_simulation_engine().list_automation_timeline()
