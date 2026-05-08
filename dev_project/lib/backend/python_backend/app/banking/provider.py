class BankingProvider:
    def healthcheck(self) -> dict[str, str]:
        return {
            "status": "mock-ready",
            "message": "Banking integrations are intentionally disabled for the MVP.",
        }
