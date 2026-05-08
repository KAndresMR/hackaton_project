class DashboardModel {
  const DashboardModel({
    required this.balance,
    required this.protectedFunds,
    required this.availableLiquidity,
    required this.riskScore,
  });

  final double balance;
  final double protectedFunds;
  final double availableLiquidity;
  final int riskScore;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      protectedFunds: (json['protected_funds'] as num?)?.toDouble() ?? 0,
      availableLiquidity: (json['available_liquidity'] as num?)?.toDouble() ?? 0,
      riskScore: (json['risk_score'] as num?)?.toInt() ?? 0,
    );
  }
}
