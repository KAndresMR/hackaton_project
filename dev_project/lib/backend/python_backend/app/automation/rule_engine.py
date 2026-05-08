from dataclasses import dataclass


@dataclass(frozen=True)
class RuleDecision:
    rule_name: str
    enabled: bool
    reason: str


class RuleEngine:
    def evaluate(self, rule_name: str) -> RuleDecision:
        return RuleDecision(
            rule_name=rule_name,
            enabled=True,
            reason="Mock rule engine ready for future automation logic.",
        )
