import 'package:credynox/frontend/screens/dashboard/widgets/layout/dashboard_grid.dart';
import 'package:credynox/frontend/models/automation_event_model.dart';
import 'package:credynox/frontend/models/dashboard_model.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AiSummaryCard extends StatelessWidget {
  const AiSummaryCard({super.key, required this.dashboardAsync, required this.automationAsync});

  final AsyncValue<DashboardModel> dashboardAsync;
  final AsyncValue<List<AutomationEventModel>> automationAsync;

  @override
  Widget build(BuildContext context) {
    final dashboard = dashboardAsync.valueOrNull;
    final completed = automationAsync.valueOrNull?.where((event) => event.status.toLowerCase() == 'completed').length ?? 0;

    return NxCard(
      hoverable: true,
      glowColor: AppColors.emerald,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'AI STATUS',
            subtitle: 'Intelligence mock layer',
            icon: Icons.auto_awesome_outlined,
            iconColor: AppColors.emerald,
            badge: 'ACTIVE',
          ),
          const SizedBox(height: 18),
          const Text(
            'AI Liquidity Engine Active',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            '$completed automations executed today',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Text(
            dashboard == null
                ? 'Loading engine signals...'
                : dashboard.riskScore < 30
                    ? 'System is stable and auto-balancing.'
                    : 'System detected pressure and is reacting.',
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}