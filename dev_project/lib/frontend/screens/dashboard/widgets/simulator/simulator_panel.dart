import 'package:credynox/frontend/models/automation_event_model.dart';
import 'package:credynox/frontend/models/dashboard_model.dart';
import 'package:credynox/frontend/models/transaction_model.dart';
import 'package:credynox/frontend/providers/dashboard_providers.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/layout/dashboard_grid.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/simulator/action_card.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/simulator/ai_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimulatorPanel extends ConsumerStatefulWidget {
  const SimulatorPanel({
    super.key,
    required this.isDesktop,
    required this.dashboardAsync,
    required this.transactionsAsync,
    required this.automationAsync,
  });

  final bool isDesktop;
  final AsyncValue<DashboardModel> dashboardAsync;
  final AsyncValue<List<TransactionModel>> transactionsAsync;
  final AsyncValue<List<AutomationEventModel>> automationAsync;

  @override
  ConsumerState<SimulatorPanel> createState() => SimulatorPanelState();
}


class SimulatorPanelState extends ConsumerState<SimulatorPanel> {
  bool _busy = false;

  Future<void> _execute(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(dashboardProvider);
      ref.invalidate(transactionProvider);
      ref.invalidate(automationProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Simulation executed successfully')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Simulation failed: $error')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentTransactionCount =
        widget.transactionsAsync.valueOrNull?.length ?? 0;

    final content = ActionCard(
      busy: _busy,
      dashboardAsync: widget.dashboardAsync,
      recentTransactionCount: recentTransactionCount,
      onSalary: () => _execute(() async {
        await ref
            .read(automationServiceProvider)
            .triggerSalary(amount: 2500, reserveAmount: 400);
      }),
      onExpense: () => _execute(() async {
        await ref.read(automationServiceProvider).triggerExpense(amount: 180);
      }),
      onAutomation: () => _execute(() async {
        await ref.read(automationServiceProvider).runAutomation();
      }),
    );

    final status = AiStatusCard(automationAsync: widget.automationAsync);

    return widget.isDesktop
        ? Row(
            children: [
              Expanded(child: content),
              const SizedBox(width: 20),
              Expanded(child: status),
            ],
          )
        : Column(children: [content, const SizedBox(height: 20), status]);
  }
}

