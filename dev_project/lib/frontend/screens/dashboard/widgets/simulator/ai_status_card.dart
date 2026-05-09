import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/models/automation_event_model.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/layout/dashboard_grid.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiStatusCard extends StatelessWidget {
  const AiStatusCard({super.key, required this.automationAsync});

  final AsyncValue<List<AutomationEventModel>> automationAsync;

  @override
  Widget build(BuildContext context) {
    final completedToday = automationAsync.valueOrNull
            ?.where((event) =>
                event.status.toLowerCase() == 'completed' &&
                event.timestamp.year == DateTime.now().year &&
                event.timestamp.month == DateTime.now().month &&
                event.timestamp.day == DateTime.now().day)
            .length ??
        0;

    return NxCard(
      hoverable: true,
      glowColor: AppColors.emerald,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'AI STATUS',
            subtitle: 'Mock intelligence layer',
            icon: Icons.auto_awesome_outlined,
            iconColor: AppColors.emerald,
            badge: 'ACTIVE',
          ),
          const SizedBox(height: 20),
          Text(
            'AI Liquidity Engine Active',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.1),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: 240.ms,
            child: Text(
              '$completedToday automations executed today',
              key: ValueKey(completedToday),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}