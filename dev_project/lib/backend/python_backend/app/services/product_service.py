from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime, timedelta
from threading import RLock

from app.models.activity import ActivityEntry
from app.models.bank import BankConnection
from app.models.profile import UserProfile
from app.models.settings import AutomationSettings
from app.schemas.product import ConnectBankRequest, UpdateSettingsRequest
from app.services.mock_data import MOCK_ACTIVITY, MOCK_BANKS, MOCK_PROFILE, MOCK_SETTINGS


def _utcnow() -> datetime:
    return datetime.now(tz=UTC)


def _automation_level(settings: AutomationSettings) -> str:
    enabled = sum([
        settings.auto_reserve,
        settings.liquidity_protection,
        settings.automatic_payments,
        settings.ai_optimization,
    ])
    if enabled >= 4:
        return "Advanced"
    if enabled >= 3:
        return "Standard"
    if enabled >= 1:
        return "Basic"
    return "Manual"


@dataclass
class ProductState:
    profile: UserProfile
    settings: AutomationSettings
    banks: list[BankConnection] = field(default_factory=list)
    activity: list[ActivityEntry] = field(default_factory=list)
    next_activity_id: int = 1
    clock: datetime = field(default_factory=_utcnow)


class ProductService:
    def __init__(self) -> None:
        self._lock = RLock()
        self._state = ProductState(
            profile=MOCK_PROFILE.model_copy(),
            settings=MOCK_SETTINGS.model_copy(),
            banks=[bank.model_copy() for bank in MOCK_BANKS],
            activity=[entry.model_copy() for entry in MOCK_ACTIVITY],
            next_activity_id=max((entry.id for entry in MOCK_ACTIVITY), default=0) + 1,
        )

    def _advance(self, seconds: int = 1) -> datetime:
        self._state.clock = self._state.clock + timedelta(seconds=seconds)
        return self._state.clock

    def _append_activity(
        self,
        title: str,
        description: str,
        category: str,
        amount: float | None = None,
        status: str = "completed",
    ) -> ActivityEntry:
        entry = ActivityEntry(
            id=self._state.next_activity_id,
            title=title,
            description=description,
            category=category,
            amount=amount,
            status=status,
            timestamp=self._advance(),
        )
        self._state.next_activity_id += 1
        self._state.activity.append(entry)
        return entry

    def _recalculate_profile(self) -> None:
        self._state.profile.automation_level = _automation_level(self._state.settings)
        self._state.profile.ai_status = self._state.settings.ai_optimization

    def _connected_bank(self) -> BankConnection | None:
        return next((bank for bank in self._state.banks if bank.connected), None)

    def get_profile(self) -> UserProfile:
        with self._lock:
            return self._state.profile.model_copy()

    def get_settings(self) -> AutomationSettings:
        with self._lock:
            return self._state.settings.model_copy()

    def update_settings(self, payload: UpdateSettingsRequest) -> AutomationSettings:
        with self._lock:
            for field_name, value in payload.model_dump(exclude_none=True).items():
                setattr(self._state.settings, field_name, value)

            self._recalculate_profile()
            self._append_activity(
                title="Settings updated",
                description="Automation toggles were saved from the premium UI.",
                category="settings",
            )
            return self._state.settings.model_copy()

    def list_banks(self) -> list[BankConnection]:
        with self._lock:
            return [bank.model_copy() for bank in self._state.banks]

    def connect_bank(self, payload: ConnectBankRequest) -> dict[str, object]:
        with self._lock:
            selected = next((bank for bank in self._state.banks if bank.name.lower() == payload.bank_name.lower()), None)
            if selected is None:
                selected = BankConnection(id=len(self._state.banks) + 1, name=payload.bank_name, connected=False)
                self._state.banks.append(selected)

            for bank in self._state.banks:
                bank.connected = bank.name == selected.name

            self._state.profile.connected_bank = selected.name
            self._append_activity(
                title="Bank connected",
                description=f"{selected.name} is now linked to CredyNox.",
                category="bank",
            )
            self._recalculate_profile()

            return {
                "message": f"{selected.name} connected successfully",
                "profile": self._state.profile.model_copy(),
                "banks": [bank.model_copy() for bank in self._state.banks],
            }

    def list_activity(self) -> list[ActivityEntry]:
        with self._lock:
            return sorted(self._state.activity, key=lambda entry: entry.timestamp, reverse=True)


_product_service = ProductService()


def get_product_service() -> ProductService:
    return _product_service