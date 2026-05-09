import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/models/automation_event_model.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/health/health_row.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/layout/dashboard_grid.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';
import 'package:credynox/frontend/models/dashboard_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({
    super.key,
    required this.isDesktop,
    required this.dashboardAsync,
    required this.automationAsync,
  });

  final bool isDesktop;
  final AsyncValue<DashboardModel> dashboardAsync;
  final AsyncValue<List<AutomationEventModel>> automationAsync;

  @override
  Widget build(BuildContext context) {
    final dashboard = dashboardAsync.valueOrNull;
    final completedToday = automationAsync.valueOrNull
            ?.where((event) =>
                event.status.toLowerCase() == 'completed' &&
                event.timestamp.year == DateTime.now().year &&
                event.timestamp.month == DateTime.now().month &&
                event.timestamp.day == DateTime.now().day)
            .length ??
        0;

    final liquidityStatus = dashboard == null
        ? 'Loading'
        : dashboard.availableLiquidity > 300
            ? 'Healthy'
            : 'Watch';

    final healthCard = NxCard(
      hoverable: true,
      glowColor: AppColors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'FINANCIAL HEALTH',
            subtitle: 'Risk and liquidity signals',
            icon: Icons.shield_outlined,
            iconColor: AppColors.amber,
          ),
          const SizedBox(height: 18),
          HealthRow(label: 'Risk Score', value: dashboard == null ? '—' : '${dashboard.riskScore}', color: dashboard != null && dashboard.riskScore < 30 ? AppColors.emerald : AppColors.amber),
          const SizedBox(height: 12),
          HealthRow(label: 'Liquidity Status', value: liquidityStatus, color: liquidityStatus == 'Healthy' ? AppColors.emerald : AppColors.amber),
          const SizedBox(height: 12),
          HealthRow(label: 'Automation Level', value: '$completedToday executed today', color: AppColors.cyan),
        ],
      ),
    ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.08);

    final automationCard = NxCard(
      hoverable: true,
      glowColor: AppColors.violet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'AUTOMATION STATUS',
            subtitle: 'Engine reactions',
            icon: Icons.auto_fix_high_rounded,
            iconColor: AppColors.violet,
          ),
          const SizedBox(height: 18),
          Text(
            dashboard == null
                ? 'Loading automation engine...'
                : dashboard.balance > 1000
                    ? 'Reserve strategy activated'
                    : 'Monitoring balance and expense flow',
            style: const TextStyle(color: AppColors.textPrimary, height: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Trigger salary or expense simulations to see the engine react.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.08);

    return isDesktop
        ? Row(
            children: [
              Expanded(child: healthCard),
              const SizedBox(width: 20),
              Expanded(child: automationCard),
            ],
          )
        : Column(
            children: [
              healthCard,
              const SizedBox(height: 20),
              automationCard,
            ],
          );
  }
}