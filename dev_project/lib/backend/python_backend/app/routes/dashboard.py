from fastapi import APIRouter

from app.schemas.dashboard import DashboardMetrics
from app.services.dashboard_service import get_dashboard_metrics

router = APIRouter(tags=["dashboard"])


@router.get("/dashboard", response_model=DashboardMetrics)
def read_dashboard() -> DashboardMetrics:
    return get_dashboard_metrics()
