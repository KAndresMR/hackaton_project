import 'package:credynox/frontend/screens/dashboard/widgets/simulator/action_button.dart';
import 'package:flutter/material.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/layout/dashboard_grid.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:credynox/frontend/models/dashboard_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.busy,
    required this.dashboardAsync,
    required this.recentTransactionCount,
    required this.onSalary,
    required this.onExpense,
    required this.onAutomation,
  });

  final bool busy;
  final AsyncValue<DashboardModel> dashboardAsync;
  final int recentTransactionCount;
  final VoidCallback onSalary;
  final VoidCallback onExpense;
  final VoidCallback onAutomation;

  @override
  Widget build(BuildContext context) {
    final balance = dashboardAsync.valueOrNull?.balance;

    return NxCard(
      hoverable: true,
      glowColor: AppColors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'TRANSACTION SIMULATOR',
            subtitle: 'Drive the simulation engine',
            icon: Icons.play_circle_outline_rounded,
            iconColor: AppColors.cyan,
            badge: 'LIVE',
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ActionButton(
                label: 'Receive Salary',
                icon: Icons.payments_outlined,
                busy: busy,
                onTap: onSalary,
              ),
              ActionButton(
                label: 'Simulate Expense',
                icon: Icons.remove_circle_outline,
                busy: busy,
                onTap: onExpense,
              ),
              ActionButton(
                label: 'Trigger Automation',
                icon: Icons.auto_awesome_outlined,
                busy: busy,
                onTap: onAutomation,
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: 280.ms,
            child: Text(
              balance == null ? 'Loading reactive balance...' : 'Current balance: \$${balance.toStringAsFixed(2)}',
              key: ValueKey(balance?.toStringAsFixed(2) ?? 'loading'),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recent transactions: $recentTransactionCount',
            style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.08);
  }
}