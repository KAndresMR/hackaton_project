from app.routes.automation import router as automation_router
from app.routes.dashboard import router as dashboard_router
from app.routes.transactions import router as transactions_router

__all__ = ["automation_router", "dashboard_router", "transactions_router"]
