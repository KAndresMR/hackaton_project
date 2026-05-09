import 'package:credynox/frontend/screens/dashboard/widgets/layout/dashboard_grid.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/balance/pill_metric.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';
import 'package:credynox/frontend/models/dashboard_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.dashboardAsync});

  final AsyncValue<DashboardModel> dashboardAsync;

  @override
  Widget build(BuildContext context) {
    final dashboard = dashboardAsync.valueOrNull;

    return NxCard(
      hoverable: true,
      glowColor: AppColors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'BALANCE CARD',
            subtitle: 'Live financial position',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.cyan,
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: 260.ms,
            child: Text(
              dashboard == null ? 'Loading...' : '\$${dashboard.balance.toStringAsFixed(2)}',
              key: ValueKey(dashboard?.balance.toStringAsFixed(2) ?? 'loading'),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.2,
                  ),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              PillMetric(
                label: 'Protected Funds',
                value: dashboard == null ? '—' : '\$${dashboard.protectedFunds.toStringAsFixed(2)}',
                color: AppColors.emerald,
              ),
              PillMetric(
                label: 'Liquidity',
                value: dashboard == null ? '—' : '\$${dashboard.availableLiquidity.toStringAsFixed(2)}',
                color: AppColors.violet,
              ),
              PillMetric(
                label: 'Risk Score',
                value: dashboard == null ? '—' : '${dashboard.riskScore}',
                color: dashboard != null && dashboard.riskScore < 30 ? AppColors.emerald : AppColors.amber,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.08);
  }
}