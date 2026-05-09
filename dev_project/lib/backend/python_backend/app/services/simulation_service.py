from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime, timedelta
from functools import lru_cache
from threading import RLock

from app.core.supabase import get_supabase_admin_client, get_supabase_client
from app.models.activity import ActivityEntry
from app.models.bank import BankConnection
from app.models.automation_event import AutomationEvent
from app.models.profile import UserProfile
from app.models.transaction import Transaction
from app.models.user import User
from app.models.settings import AutomationSettings
from app.schemas.dashboard import DashboardMetrics
from app.schemas.simulation import SimulationResponse
from app.services.mock_data import MOCK_ACTIVITY, MOCK_AUTOMATION_EVENTS, MOCK_BANKS, MOCK_PROFILE, MOCK_SETTINGS, MOCK_TRANSACTIONS, MOCK_USER


def _utcnow() -> datetime:
    return datetime.now(tz=UTC)


@dataclass
class SimulationState:
    user: User
    protected_funds: float
    available_liquidity: float
    risk_score: int
    profile: UserProfile
    settings: AutomationSettings
    banks: list[BankConnection] = field(default_factory=list)
    activity: list[ActivityEntry] = field(default_factory=list)
    transactions: list[Transaction] = field(default_factory=list)
    automation_events: list[AutomationEvent] = field(default_factory=list)
    next_transaction_id: int = 1
    next_event_id: int = 1
    next_activity_id: int = 1
    last_timestamp: datetime = field(default_factory=_utcnow)


class SimulationEngine:
    def __init__(self) -> None:
        self._lock = RLock()
        self._read_client = get_supabase_client()
        self._admin_client = get_supabase_admin_client()
        self._state = self._load_initial_state()

    def _load_initial_state(self) -> SimulationState:
        user = User(id=MOCK_USER.id, name=MOCK_USER.name, balance=MOCK_USER.balance)
        protected_funds = 400.0
        available_liquidity = 300.0
        risk_score = 12
        transactions = list(MOCK_TRANSACTIONS)
        automation_events = list(MOCK_AUTOMATION_EVENTS)
        profile = MOCK_PROFILE.model_copy()
        settings = MOCK_SETTINGS.model_copy()
        banks = [bank.model_copy() for bank in MOCK_BANKS]
        activity = [entry.model_copy() for entry in MOCK_ACTIVITY]

        client = self._admin_client or self._read_client
        if client:
            try:
                user_res = client.table("users").select("*").eq("id", 1).single().execute()
                user_data = getattr(user_res, "data", None) or {}
                user = User(
                    id=int(user_data.get("id", 1)),
                    name=str(user_data.get("name", MOCK_USER.name)),
                    balance=float(user_data.get("balance", MOCK_USER.balance)),
                )
                protected_funds = float(user_data.get("protected_funds", protected_funds))
                available_liquidity = float(user_data.get("available_liquidity", available_liquidity))
                risk_score = int(user_data.get("risk_score", risk_score))
            except Exception:
                pass

            try:
                tx_res = client.table("transactions").select("*").order("date", {"ascending": True}).execute()
                tx_data = getattr(tx_res, "data", None) or []
                if tx_data:
                    transactions = [Transaction(**item) for item in tx_data]
            except Exception:
                pass

            try:
                event_res = client.table("automation_events").select("*").order("timestamp", {"ascending": True}).execute()
                event_data = getattr(event_res, "data", None) or []
                if event_data:
                    automation_events = [AutomationEvent(**item) for item in event_data]
            except Exception:
                pass

        if not transactions:
            transactions = list(MOCK_TRANSACTIONS)

        if not automation_events:
            automation_events = list(MOCK_AUTOMATION_EVENTS)

        next_transaction_id = max((tx.id for tx in transactions), default=0) + 1
        next_event_id = max((event.id for event in automation_events), default=0) + 1
        next_activity_id = max((entry.id for entry in activity), default=0) + 1

        return SimulationState(
            user=user,
            protected_funds=protected_funds,
            available_liquidity=available_liquidity,
            risk_score=risk_score,
            profile=profile,
            settings=settings,
            banks=banks,
            activity=activity,
            transactions=transactions,
            automation_events=automation_events,
            next_transaction_id=next_transaction_id,
            next_event_id=next_event_id,
            next_activity_id=next_activity_id,
        )

    def _snapshot(self) -> DashboardMetrics:
        return DashboardMetrics(
            balance=int(round(self._state.user.balance)),
            protected_funds=int(round(self._state.protected_funds)),
            available_liquidity=int(round(self._state.available_liquidity)),
            risk_score=int(self._state.risk_score),
        )

    def _advance(self, seconds: int = 1) -> datetime:
        self._state.last_timestamp = self._state.last_timestamp + timedelta(seconds=seconds)
        return self._state.last_timestamp

    _REASONING: dict[str, str] = {
        "income": "Incoming funds detected from a known source. Salary rule evaluated balance thresholds and triggered reserve allocation if balance exceeded $1,000.",
        "reserve": "Engine moved funds to the protected reserve bucket after a balance threshold was crossed. This safeguards fixed-cost obligations like rent and utilities.",
        "expense": "Discretionary outflow detected. Liquidity guard recalculated available buffer. Risk score was updated to reflect the new balance position.",
    }

    def _create_transaction(
        self,
        tx_type: str,
        amount: float,
        timestamp: datetime,
        description: str | None = None,
        merchant: str | None = None,
        reasoning: str | None = None,
    ) -> Transaction:
        transaction = Transaction(
            id=self._state.next_transaction_id,
            type=tx_type,
            amount=round(amount, 2),
            date=timestamp,
            description=description,
            merchant=merchant,
            reasoning=reasoning or self._REASONING.get(tx_type),
        )
        self._state.next_transaction_id += 1
        self._state.transactions.append(transaction)
        return transaction

    def _create_event(self, action: str, status: str, timestamp: datetime) -> AutomationEvent:
        event = AutomationEvent(
            id=self._state.next_event_id,
            action=action,
            status=status,
            timestamp=timestamp,
        )
        self._state.next_event_id += 1
        self._state.automation_events.append(event)
        return event

    def _create_activity(
        self,
        title: str,
        description: str,
        category: str,
        amount: float | None = None,
        status: str = "completed",
        timestamp: datetime | None = None,
    ) -> ActivityEntry:
        activity = ActivityEntry(
            id=self._state.next_activity_id,
            title=title,
            description=description,
            category=category,
            amount=amount,
            status=status,
            timestamp=timestamp or self._advance(),
        )
        self._state.next_activity_id += 1
        self._state.activity.append(activity)
        return activity

    def _recalculate_profile(self) -> None:
        enabled = sum(
            [
                self._state.settings.auto_reserve,
                self._state.settings.liquidity_protection,
                self._state.settings.automatic_payments,
                self._state.settings.ai_optimization,
            ]
        )
        if enabled >= 4:
            automation_level = "Advanced"
        elif enabled >= 3:
            automation_level = "Standard"
        elif enabled >= 1:
            automation_level = "Basic"
        else:
            automation_level = "Manual"

        self._state.profile.automation_level = automation_level
        self._state.profile.ai_status = self._state.settings.ai_optimization
        self._state.profile.connected_bank = next((bank.name for bank in self._state.banks if bank.connected), self._state.profile.connected_bank)
        self._state.profile.optimized_money = round(max(self._state.profile.optimized_money, self._state.protected_funds * 0.1), 2)

    def _recalculate_liquidity(self) -> None:
        self._state.available_liquidity = max(0.0, self._state.user.balance - self._state.protected_funds)

    def _recalculate_risk(self, trigger: str | None = None) -> None:
        balance = max(self._state.user.balance, 1.0)
        coverage = (self._state.protected_funds + self._state.available_liquidity) / balance

        if coverage >= 1.4:
            risk = 8
        elif coverage >= 1.0:
            risk = 12
        elif coverage >= 0.8:
            risk = 20
        elif coverage >= 0.6:
            risk = 32
        elif coverage >= 0.4:
            risk = 48
        else:
            risk = 65

        if trigger == "expense":
            risk = min(95, risk + 7)

        self._state.risk_score = int(max(5, min(95, risk)))

    def _sync_supabase(self, created_transactions: list[Transaction], created_events: list[AutomationEvent]) -> None:
        client = self._admin_client
        if not client:
            return

        try:
            client.table("users").upsert(
                {
                    "id": self._state.user.id,
                    "name": self._state.user.name,
                    "balance": self._state.user.balance,
                    "protected_funds": self._state.protected_funds,
                    "available_liquidity": self._state.available_liquidity,
                    "risk_score": self._state.risk_score,
                }
            ).execute()
        except Exception:
            pass

        for transaction in created_transactions:
            try:
                client.table("transactions").upsert(transaction.model_dump(mode="json")).execute()
            except Exception:
                pass

        for event in created_events:
            try:
                payload = event.model_dump(mode="json")
                payload["meta"] = {"source": "simulation_engine"}
                client.table("automation_events").upsert(payload).execute()
            except Exception:
                pass

    def get_dashboard_metrics(self) -> DashboardMetrics:
        with self._lock:
            return self._snapshot()

    def get_profile(self) -> UserProfile:
        with self._lock:
            return self._state.profile.model_copy()

    def get_settings(self) -> AutomationSettings:
        with self._lock:
            return self._state.settings.model_copy()

    def update_settings(self, payload: dict[str, bool | None]) -> AutomationSettings:
        with self._lock:
            for field_name, value in payload.items():
                if value is not None:
                    setattr(self._state.settings, field_name, value)

            self._recalculate_profile()
            self._create_activity(
                "Settings updated",
                "Automation toggles were saved from the UI.",
                "settings",
            )
            return self._state.settings.model_copy()

    def list_banks(self) -> list[BankConnection]:
        with self._lock:
            return [bank.model_copy() for bank in self._state.banks]

    def connect_bank(self, bank_name: str) -> dict[str, object]:
        with self._lock:
            selected = next((bank for bank in self._state.banks if bank.name.lower() == bank_name.lower()), None)
            if selected is None:
                selected = BankConnection(id=len(self._state.banks) + 1, name=bank_name, connected=False)
                self._state.banks.append(selected)

            for bank in self._state.banks:
                bank.connected = bank.name == selected.name

            self._state.profile.connected_bank = selected.name
            self._create_activity(
                "Bank connected",
                f"{selected.name} linked to the CredyNox experience.",
                "bank",
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

    def list_transactions(self) -> list[Transaction]:
        with self._lock:
            return sorted(self._state.transactions, key=lambda transaction: transaction.date, reverse=True)

    def list_automation_timeline(self) -> list[AutomationEvent]:
        with self._lock:
            return sorted(self._state.automation_events, key=lambda event: event.timestamp, reverse=True)

    def simulate_salary(self, amount: float, reserve_amount: float = 400.0, source: str = "Salary detected") -> SimulationResponse:
        with self._lock:
            created_transactions: list[Transaction] = []
            created_events: list[AutomationEvent] = []
            rules_executed: list[str] = []

            timestamp = self._advance()
            salary_amount = abs(amount)

            self._state.user.balance += salary_amount
            created_transactions.append(self._create_transaction(
                "income", salary_amount, timestamp,
                description="Monthly payroll deposit",
                merchant="Employer",
                reasoning=f"Salary of ${salary_amount:,.0f} detected. Balance updated to ${self._state.user.balance:,.0f}. Reserve rule evaluated.",
            ))
            created_events.append(self._create_event(source, "completed", timestamp))
            rules_executed.append("salary_detected")

            if self._state.user.balance > 1000:
                reserve = min(abs(reserve_amount), max(0.0, self._state.user.balance - 1000.0))
                if reserve > 0:
                    reserve_timestamp = self._advance()
                    self._state.user.balance -= reserve
                    self._state.protected_funds += reserve
                    self._recalculate_liquidity()
                    created_transactions.append(self._create_transaction(
                        "reserve", -reserve, reserve_timestamp,
                        description="Automated reserve transfer",
                        merchant="Protected Funds",
                        reasoning=f"Balance exceeded $1,000 post-salary. Engine reserved ${reserve:,.0f} to cover fixed monthly obligations.",
                    ))
                    created_events.append(self._create_event("Funds reserved for rent", "completed", reserve_timestamp))
                    rules_executed.append("reserve_for_rent")
                    self._create_activity(
                        "Reserve transfer",
                        f"{reserve:.0f} reserved from incoming salary.",
                        "automation",
                        amount=reserve,
                        timestamp=reserve_timestamp,
                    )

            self._recalculate_liquidity()
            self._recalculate_risk()
            self._recalculate_profile()

            optimize_timestamp = self._advance()
            created_events.append(self._create_event("Liquidity optimized", "completed", optimize_timestamp))
            rules_executed.append("liquidity_optimized")
            self._create_activity(
                "Liquidity optimized",
                "Cash position was rebalanced after salary arrival.",
                "insight",
            )

            self._sync_supabase(created_transactions, created_events)

            return SimulationResponse(
                message="Salary simulation executed",
                dashboard=self._snapshot(),
                created_transactions=created_transactions,
                created_events=created_events,
                rules_executed=rules_executed,
            )

    def simulate_expense(self, amount: float, category: str = "expense", description: str = "Expense detected") -> SimulationResponse:
        with self._lock:
            created_transactions: list[Transaction] = []
            created_events: list[AutomationEvent] = []
            rules_executed: list[str] = []

            timestamp = self._advance()
            expense_amount = abs(amount)

            self._state.user.balance = max(0.0, self._state.user.balance - expense_amount)
            created_transactions.append(self._create_transaction(
                category, -expense_amount, timestamp,
                description=f"{category.title()} purchase detected",
                reasoning=f"${expense_amount:,.0f} outflow detected. Liquidity guard recalculated buffer. Risk score updated to reflect new balance of ${self._state.user.balance:,.0f}.",
            ))
            created_events.append(self._create_event(description, "completed", timestamp))
            rules_executed.append("expense_detected")
            self._create_activity(
                "Expense recorded",
                f"{category.title()} expense reduced liquidity by {expense_amount:.0f}.",
                "expense",
                amount=-expense_amount,
                timestamp=timestamp,
            )

            self._recalculate_liquidity()
            self._recalculate_risk(trigger="expense")
            self._recalculate_profile()

            recalc_timestamp = self._advance()
            created_events.append(self._create_event("Liquidity recalculated", "completed", recalc_timestamp))
            created_events.append(self._create_event("Risk score updated", "completed", self._advance()))
            rules_executed.extend(["liquidity_recalculated", "risk_recalculated"])
            self._create_activity(
                "Risk updated",
                "The risk engine refreshed the score after the expense.",
                "risk",
                timestamp=recalc_timestamp,
            )

            self._sync_supabase(created_transactions, created_events)

            return SimulationResponse(
                message="Expense simulation executed",
                dashboard=self._snapshot(),
                created_transactions=created_transactions,
                created_events=created_events,
                rules_executed=rules_executed,
            )

    def run_automation(self, trigger: str = "manual") -> SimulationResponse:
        with self._lock:
            created_transactions: list[Transaction] = []
            created_events: list[AutomationEvent] = []
            rules_executed: list[str] = []

            base_timestamp = self._advance()
            created_events.append(self._create_event(f"Automation run started ({trigger})", "running", base_timestamp))
            self._create_activity(
                "Automation run started",
                f"Automation engine triggered via {trigger} input.",
                "automation",
                timestamp=base_timestamp,
            )

            if self._state.user.balance > 1000:
                reserve = min(400.0, max(0.0, self._state.user.balance - 1000.0))
                if reserve > 0:
                    reserve_timestamp = self._advance()
                    self._state.user.balance -= reserve
                    self._state.protected_funds += reserve
                    self._recalculate_liquidity()
                    created_transactions.append(self._create_transaction(
                        "reserve", -reserve, reserve_timestamp,
                        description="Automation reserve rule executed",
                        merchant="Protected Funds",
                        reasoning=f"Automation run: balance ${self._state.user.balance + reserve:,.0f} exceeded $1,000. Engine reserved ${reserve:,.0f} automatically.",
                    ))
                    created_events.append(self._create_event("Funds reserved for rent", "completed", reserve_timestamp))
                    rules_executed.append("balance_over_1000_reserve_400")
                    self._create_activity(
                        "Reserve rule executed",
                        "Cash was moved into reserve automatically.",
                        "automation",
                        amount=reserve,
                        timestamp=reserve_timestamp,
                    )

            if self._state.available_liquidity > 300:
                move_amount = min(120.0, self._state.available_liquidity - 300.0)
                if move_amount > 0:
                    liquidity_timestamp = self._advance()
                    self._state.user.balance -= move_amount
                    self._state.protected_funds += move_amount
                    self._recalculate_liquidity()
                    created_transactions.append(self._create_transaction(
                        "reserve", -move_amount, liquidity_timestamp,
                        description="Liquidity protection transfer",
                        merchant="Protected Funds",
                        reasoning=f"Liquidity ${self._state.available_liquidity + move_amount:,.0f} exceeded $300 threshold. Engine shifted ${move_amount:,.0f} to reserve to prevent over-exposure.",
                    ))
                    created_events.append(self._create_event("Liquidity moved to reserve fund", "completed", liquidity_timestamp))
                    rules_executed.append("liquidity_over_300_move_120")
                    self._create_activity(
                        "Liquidity protection moved funds",
                        "Liquidity protection shifted extra cash into reserve.",
                        "automation",
                        amount=move_amount,
                        timestamp=liquidity_timestamp,
                    )

            recent_expense = any(transaction.type == "expense" for transaction in self._state.transactions[-5:])
            if recent_expense:
                self._recalculate_risk(trigger="expense")
                rules_executed.append("expense_triggered_risk_recalculation")
                created_events.append(self._create_event("Risk score recalculated", "completed", self._advance()))
                self._create_activity(
                    "Risk score recalculated",
                    "Recent spending caused the risk model to refresh.",
                    "risk",
                )
            else:
                self._recalculate_risk()

            if not rules_executed:
                rules_executed.append("no_rule_changed_state")
                created_events.append(self._create_event("No rule changes required", "completed", self._advance()))

            completion_timestamp = self._advance()
            created_events.append(self._create_event("Automation run completed", "completed", completion_timestamp))
            self._create_activity(
                "Automation run completed",
                "All enabled rules finished their pass.",
                "automation",
                timestamp=completion_timestamp,
            )
            self._recalculate_profile()

            self._sync_supabase(created_transactions, created_events)

            return SimulationResponse(
                message="Automation rules executed",
                dashboard=self._snapshot(),
                created_transactions=created_transactions,
                created_events=created_events,
                rules_executed=rules_executed,
            )


@lru_cache
def get_simulation_engine() -> SimulationEngine:
    return SimulationEngine()