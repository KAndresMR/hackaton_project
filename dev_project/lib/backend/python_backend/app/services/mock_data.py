from datetime import UTC, datetime

from app.models.automation_event import AutomationEvent
from app.models.transaction import Transaction
from app.models.user import User

MOCK_USER = User(
    id=1,
    name="CredyNox Demo User",
    balance=1200.0,
)

MOCK_TRANSACTIONS = [
    Transaction(
        id=1,
        type="income",
        amount=1500.0,
        date=datetime(2026, 5, 1, 9, 15, tzinfo=UTC),
    ),
    Transaction(
        id=2,
        type="reserve",
        amount=-400.0,
        date=datetime(2026, 5, 2, 10, 30, tzinfo=UTC),
    ),
    Transaction(
        id=3,
        type="expense",
        amount=-300.0,
        date=datetime(2026, 5, 4, 14, 0, tzinfo=UTC),
    ),
]

MOCK_AUTOMATION_EVENTS = [
    AutomationEvent(
        id=1,
        action="Protected funds recalculated",
        status="completed",
        timestamp=datetime(2026, 5, 4, 8, 0, tzinfo=UTC),
    ),
    AutomationEvent(
        id=2,
        action="Liquidity risk evaluated",
        status="completed",
        timestamp=datetime(2026, 5, 5, 8, 30, tzinfo=UTC),
    ),
    AutomationEvent(
        id=3,
        action="Rule sync queued",
        status="pending",
        timestamp=datetime(2026, 5, 8, 7, 45, tzinfo=UTC),
    ),
]
