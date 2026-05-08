from app.schemas.dashboard import DashboardMetrics
from app.services.simulation_service import get_simulation_engine


def get_dashboard_metrics() -> DashboardMetrics:
    return get_simulation_engine().get_dashboard_metrics()
