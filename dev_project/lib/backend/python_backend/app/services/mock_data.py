from datetime import UTC, datetime

from app.models.activity import ActivityEntry
from app.models.bank import BankConnection
from app.models.automation_event import AutomationEvent
from app.models.transaction import Transaction
from app.models.profile import UserProfile
from app.models.settings import AutomationSettings
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
        description="Monthly payroll deposit",
        merchant="CredyNox Corp",
        reasoning="Recurring income detected from known employer. Amount matches historical salary pattern ($1,500). Auto-reserve rule activated — 27% of incoming funds moved to protected bucket to cover rent and fixed costs.",
    ),
    Transaction(
        id=2,
        type="reserve",
        amount=-400.0,
        date=datetime(2026, 5, 2, 10, 30, tzinfo=UTC),
        description="Automated reserve transfer",
        merchant="Protected Funds",
        reasoning="Balance exceeded $1,000 post-salary. Engine applied reserve rule: moved $400 into the protected fund bucket. This covers estimated monthly fixed costs (rent + utilities). Liquidity recalculated to $300.",
    ),
    Transaction(
        id=3,
        type="expense",
        amount=-300.0,
        date=datetime(2026, 5, 4, 14, 0, tzinfo=UTC),
        description="Retail purchase detected",
        merchant="Supermaxi",
        reasoning="Discretionary spend flagged — $300 is 25% above average weekly grocery baseline. Liquidity guard checked: remaining buffer ($0) is below the $300 safety threshold. Risk score adjusted upward. No reserve violation detected; balance is non-zero.",
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

MOCK_PROFILE = UserProfile(
    id=1,
    name="Michael",
    connected_bank="Banco Pichincha",
    automation_level="Advanced",
    optimized_money=120,
    ai_status=True,
)

MOCK_SETTINGS = AutomationSettings(
    auto_reserve=True,
    liquidity_protection=True,
    automatic_payments=True,
    ai_optimization=True,
)

MOCK_BANKS = [
    BankConnection(id=1, name="Banco Pichincha", connected=True),
    BankConnection(id=2, name="Produbanco", connected=False),
    BankConnection(id=3, name="Bolivariano", connected=False),
]

MOCK_ACTIVITY = [
    ActivityEntry(
        id=1,
        title="Salary received",
        description="Incoming payroll from CredyNox Corp.",
        category="income",
        amount=1500,
        timestamp=datetime(2026, 5, 4, 9, 15, tzinfo=UTC),
    ),
    ActivityEntry(
        id=2,
        title="Reserve protected",
        description="Protected funds moved into the reserve bucket.",
        category="automation",
        amount=400,
        timestamp=datetime(2026, 5, 4, 9, 16, tzinfo=UTC),
    ),
    ActivityEntry(
        id=3,
        title="Bank connected",
        description="Banco Pichincha linked successfully.",
        category="bank",
        timestamp=datetime(2026, 5, 4, 8, 50, tzinfo=UTC),
    ),
    ActivityEntry(
        id=4,
        title="Low balance alert",
        description="Liquidity guard reviewed the cash position.",
        category="risk",
        status="completed",
        timestamp=datetime(2026, 5, 5, 10, 30, tzinfo=UTC),
    ),
]
