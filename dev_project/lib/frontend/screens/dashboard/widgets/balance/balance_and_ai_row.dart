import 'package:credynox/frontend/models/automation_event_model.dart';
import 'package:credynox/frontend/models/dashboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'balance_card.dart';
import 'ai_summary.dart';

class BalanceAndAiRow extends StatelessWidget {
  const BalanceAndAiRow({
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
    final balanceCard = BalanceCard(
      dashboardAsync: dashboardAsync,
    );

    final aiCard = AiSummaryCard(
      dashboardAsync: dashboardAsync,
      automationAsync: automationAsync,
    );

    return isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: balanceCard,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: aiCard,
              ),
            ],
          )
        : Column(
            children: [
              balanceCard,
              const SizedBox(height: 20),
              aiCard,
            ],
          );
  }
}