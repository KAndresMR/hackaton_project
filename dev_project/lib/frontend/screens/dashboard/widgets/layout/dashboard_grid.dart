import 'package:credynox/frontend/screens/dashboard/widgets/transactions/transaction_feed.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/timeline/automation_timeline.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/health/health_summary_card.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/balance/balance_and_ai_row.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/simulator/simulator_panel.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/header/dashboard_header.dart';
import 'package:credynox/frontend/providers/dashboard_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';



extension AsyncValueReadable<T> on AsyncValue<T> {
  T? get valueOrNull => maybeWhen(data: (value) => value, orElse: () => null);
}

class DashboardGrid extends ConsumerWidget {
  const DashboardGrid({super.key});

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final dashboardAsync = ref.watch(dashboardProvider);
    final transactionsAsync = ref.watch(transactionProvider);
    final automationAsync = ref.watch(automationProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1100;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardProvider);
            ref.invalidate(transactionProvider);
            ref.invalidate(automationProvider);
            await Future.wait([
              ref.read(dashboardProvider.future),
              ref.read(transactionProvider.future),
              ref.read(automationProvider.future),
            ]);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : 20,
                  vertical: 24,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Header(),
                      const SizedBox(height: 24),
                      SimulatorPanel(
                        isDesktop: isDesktop,
                        dashboardAsync: dashboardAsync,
                        transactionsAsync: transactionsAsync,
                        automationAsync: automationAsync,
                      ),
                      const SizedBox(height: 24),
                      BalanceAndAiRow(
                        isDesktop: isDesktop,
                        dashboardAsync: dashboardAsync,
                        automationAsync: automationAsync,
                      ),
                      const SizedBox(height: 24),
                      HealthSummaryCard(
                        isDesktop: isDesktop,
                        dashboardAsync: dashboardAsync,
                        automationAsync: automationAsync,
                      ),
                      const SizedBox(height: 24),
                      TransactionFeed(
                        transactionsAsync: transactionsAsync,
                      ),
                      const SizedBox(height: 24),
                      AutomationTimeline(
                        automationAsync: automationAsync,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

