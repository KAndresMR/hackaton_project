from fastapi import APIRouter

from app.models.activity import ActivityEntry
from app.models.bank import BankConnection
from app.models.profile import UserProfile
from app.models.settings import AutomationSettings
from app.schemas.product import ConnectBankRequest, UpdateSettingsRequest
from app.services.product_service import get_product_service

router = APIRouter(tags=["product"])


@router.get("/profile", response_model=UserProfile)
def read_profile() -> UserProfile:
    return get_product_service().get_profile()


@router.get("/settings", response_model=AutomationSettings)
def read_settings() -> AutomationSettings:
    return get_product_service().get_settings()


@router.post("/settings/update", response_model=AutomationSettings)
def update_settings(payload: UpdateSettingsRequest) -> AutomationSettings:
    return get_product_service().update_settings(payload)


@router.get("/activity", response_model=list[ActivityEntry])
def read_activity() -> list[ActivityEntry]:
    return get_product_service().list_activity()


@router.get("/banks", response_model=list[BankConnection])
def read_banks() -> list[BankConnection]:
    return get_product_service().list_banks()


@router.post("/connect-bank")
def connect_bank(payload: ConnectBankRequest) -> dict[str, object]:
    return get_product_service().connect_bank(payload)