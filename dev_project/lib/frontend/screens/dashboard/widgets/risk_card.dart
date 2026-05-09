import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:flutter/material.dart';


class RiskCard extends StatelessWidget {
  const RiskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NxCard(
      hoverable: true,
      glowColor: AppColors.amber,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Replace mock risk metrics with realtime controller/provider data.

          const NxCardHeader(
            title: 'RISK MONITORING',
            subtitle: 'Predictive financial analysis',
            icon: Icons.shield_outlined,
            iconColor: AppColors.amber,
          ),

          const SizedBox(height: 28),
          FutureBuilder<Map<String, dynamic>>(
            future: ApiService.getDashboard(),
            builder: (context, snapshot) {
              final dashboard = snapshot.data ?? {};
              final riskScore = (dashboard['risk_score'] as num?)?.toInt() ?? 24;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _RiskMetric(
                          label: 'Risk Score',
                          value: '$riskScore%',
                          color: riskScore < 30 ? AppColors.emerald : AppColors.amber,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: _RiskMetric(
                          label: 'Volatility',
                          value: riskScore < 30 ? 'Low' : 'Medium',
                          color: AppColors.cyan,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: _RiskMetric(
                          label: 'Exposure',
                          value: riskScore < 30 ? 'Moderate' : 'Elevated',
                          color: AppColors.amber,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: AppColors.bgOverlay,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.borderSubtle,
                      ),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,

                          decoration: BoxDecoration(
                            color: riskScore < 30 ? AppColors.emerald : AppColors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            riskScore < 30
                                ? 'System risk is currently stable with no abnormal liquidity behavior detected.'
                                : 'Risk is elevated. Review automation and transaction patterns.',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Column(
                    children: [
                      _RiskEventRow(
                        title: 'Liquidity fluctuation detected',
                        time: '12 min ago',
                        severity: 'Low',
                        severityColor: AppColors.emerald,
                      ),

                      const SizedBox(height: 14),

                      _RiskEventRow(
                        title: 'Automation rebalance executed',
                        time: '28 min ago',
                        severity: 'Medium',
                        severityColor: AppColors.amber,
                      ),

                      const SizedBox(height: 14),

                      _RiskEventRow(
                        title: 'Cashflow prediction updated',
                        time: '1 hour ago',
                        severity: 'Info',
                        severityColor: AppColors.cyan,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RiskMetric extends StatelessWidget {
  const _RiskMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final cardWidth = width < 500
        ? double.infinity
        : 160.0;

    return Container(
      width: cardWidth,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.bgOverlay,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderSubtle,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 10),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,

            child: Text(
              value,
              maxLines: 1,

              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskEventRow extends StatelessWidget {
  const _RiskEventRow({
    required this.title,
    required this.time,
    required this.severity,
    required this.severityColor,
  });

  final String title;
  final String time;
  final String severity;
  final Color severityColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.bgOverlay.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,

            decoration: BoxDecoration(
              color: severityColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30),
            ),

            child: Text(
              severity,
              style: TextStyle(
                color: severityColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}