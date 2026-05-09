from fastapi import APIRouter
from pydantic import BaseModel

from app.services.simulation_service import get_simulation_engine

router = APIRouter(prefix="/ai", tags=["ai"])


class AiQueryRequest(BaseModel):
    question: str
    context: str | None = None


class AiQueryResponse(BaseModel):
    answer: str
    confidence: float
    source: str


_KNOWLEDGE: list[tuple[list[str], str]] = [
    (
        ["balance", "saldo", "dinero", "how much"],
        "Your current balance reflects real-time simulation data. Every income and expense event updates the dashboard instantly. The engine tracks net position across all accounts.",
    ),
    (
        ["reserve", "reserva", "protected", "protegido"],
        "Protected funds are amounts the automation engine moved into a separate reserve bucket. They cover fixed costs like rent and utilities — the engine never touches them for discretionary spending.",
    ),
    (
        ["risk", "riesgo", "score", "puntaje"],
        "The risk score (0–95) is calculated from the ratio of protected + liquid funds to your total balance. A score below 30 means the engine considers your cash position stable. Above 50 triggers protective rules.",
    ),
    (
        ["automation", "automatización", "rule", "regla", "toggle"],
        "Automations are rule-based triggers that run when financial conditions are met — salary arrival reserves funds, expense bursts raise the risk score, and liquidity protection shifts cash before exposure grows.",
    ),
    (
        ["bank", "banco", "institution", "connect"],
        "Connected banks are simulated institutions whose balance feeds are monitored by the CredyNox engine. The engine reads transaction signals and triggers rules accordingly.",
    ),
    (
        ["ai", "intelligence", "inteligencia", "engine", "motor"],
        "The AI layer analyzes transaction patterns, liquidity signals, and risk indicators to suggest optimal money movements before you need to act manually. All reasoning is logged per transaction.",
    ),
    (
        ["salary", "salario", "income", "ingreso", "payroll"],
        "When a salary is detected, the engine automatically reserves a portion into protected funds, recalculates available liquidity, and updates the risk score — all within milliseconds.",
    ),
    (
        ["expense", "gasto", "spending", "purchase", "compra"],
        "Each expense reduces available liquidity. If spending exceeds configured thresholds, the risk score rises and the engine can automatically suggest or execute a protective reserve transfer.",
    ),
    (
        ["liquidity", "liquidez", "available", "disponible"],
        "Liquidity is the cash available after subtracting your protected reserve. The engine maintains this positive by controlling automatic transfers and flagging threshold breaches.",
    ),
    (
        ["transaction", "transacción", "movement", "movimiento"],
        "Every transaction is logged with type (income / reserve / expense), amount, timestamp, merchant, and an AI reasoning note explaining why the engine acted and what changed in your financial position.",
    ),
    (
        ["help", "how", "what", "cómo", "qué", "ayuda"],
        "I can answer questions about your balance, protected reserves, risk score, automations, connected banks, transactions, and how the AI engine makes decisions. Just ask!",
    ),
]


def _build_answer(question: str, metrics: dict[str, int]) -> tuple[str, float]:
    q = question.lower()
    for keywords, template in _KNOWLEDGE:
        if any(kw in q for kw in keywords):
            answer = template
            balance = metrics.get("balance", 0)
            risk = metrics.get("risk_score", 0)
            liquidity = metrics.get("available_liquidity", 0)
            protected = metrics.get("protected_funds", 0)
            answer = (
                answer
                + f" (Current snapshot: balance ${balance:,}, liquidity ${liquidity:,}, protected ${protected:,}, risk {risk}.)"
            )
            return answer, 0.92

    balance = metrics.get("balance", 0)
    risk = metrics.get("risk_score", 0)
    liquidity = metrics.get("available_liquidity", 0)
    return (
        f"Based on your current financial state — balance ${balance:,}, liquidity ${liquidity:,}, risk score {risk} — "
        "the CredyNox engine is actively monitoring your cash flows. "
        "Try asking about your balance, protected reserves, risk score, automations, or individual transactions.",
        0.72,
    )


@router.post("/query", response_model=AiQueryResponse)
def ai_query(payload: AiQueryRequest) -> AiQueryResponse:
    engine = get_simulation_engine()
    m = engine.get_dashboard_metrics()
    metrics = {
        "balance": m.balance,
        "protected_funds": m.protected_funds,
        "available_liquidity": m.available_liquidity,
        "risk_score": m.risk_score,
    }
    answer, confidence = _build_answer(payload.question, metrics)
    return AiQueryResponse(answer=answer, confidence=confidence, source="CredyNox AI Engine v1.0")
