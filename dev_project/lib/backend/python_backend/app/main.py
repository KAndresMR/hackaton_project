from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import get_settings
from app.core.supabase import get_supabase_client
from app.routes.automation_routes import router as automation_router
from app.routes.dashboard import router as dashboard_router
from app.routes.simulation_routes import router as simulation_router
from app.routes.transactions import router as transactions_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    app.state.settings = get_settings()
    app.state.supabase = get_supabase_client()
    yield


settings = get_settings()

app = FastAPI(
    title=settings.app_name,
    version="0.1.0",
    description="CredyNox MVP backend for fintech dashboards, transaction tracking, and automation mocks.",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(dashboard_router)
app.include_router(transactions_router)
app.include_router(automation_router)
app.include_router(simulation_router)


@app.get("/", tags=["system"])
def root() -> dict[str, str]:
    return {
        "service": settings.app_name,
        "environment": settings.environment,
        "docs": "/docs",
        "status": "running",
    }


@app.get("/health", tags=["system"])
def health() -> dict[str, str]:
    return {
        "status": "ok",
        "supabase": "configured" if app.state.supabase else "mock-disabled",
    }
