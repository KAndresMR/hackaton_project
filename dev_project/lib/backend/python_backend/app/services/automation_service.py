from app.models.automation_event import AutomationEvent
from app.services.mock_data import MOCK_AUTOMATION_EVENTS
from app.core.supabase import get_supabase_client


def list_automation_timeline() -> list[AutomationEvent]:
    client = get_supabase_client()
    if client:
        try:
            res = client.table("automation_events").select("*").order("timestamp", {"ascending": False}).execute()
            data = getattr(res, "data", None)
            if data is None and isinstance(res, dict):
                data = res.get("data")
            if data:
                return [AutomationEvent(**item) for item in data]
        except Exception:
            pass
    return MOCK_AUTOMATION_EVENTS
