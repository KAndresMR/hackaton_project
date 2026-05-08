import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/models/automation_event_model.dart';
import 'package:credynox/frontend/models/dashboard_model.dart';
import 'package:credynox/frontend/models/transaction_model.dart';
import 'package:credynox/frontend/providers/dashboard_providers.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                      const _Header(),
                      const SizedBox(height: 24),
                      _SimulatorPanel(
                        isDesktop: isDesktop,
                        dashboardAsync: dashboardAsync,
                        transactionsAsync: transactionsAsync,
                        automationAsync: automationAsync,
                      ),
                      const SizedBox(height: 24),
                      _BalanceAndAiRow(
                        isDesktop: isDesktop,
                        dashboardAsync: dashboardAsync,
                        automationAsync: automationAsync,
                      ),
                      const SizedBox(height: 24),
                      _HealthSummaryCard(
                        isDesktop: isDesktop,
                        dashboardAsync: dashboardAsync,
                        automationAsync: automationAsync,
                      ),
                      const SizedBox(height: 24),
                      _TransactionFeed(transactionsAsync: transactionsAsync),
                      const SizedBox(height: 24),
                      _AutomationTimeline(automationAsync: automationAsync),
                      const SizedBox(height: 40),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Overview',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Reactive simulation engine connected to live backend data.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _SimulatorPanel extends ConsumerStatefulWidget {
  const _SimulatorPanel({
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
  ConsumerState<_SimulatorPanel> createState() => _SimulatorPanelState();
}

class _SimulatorPanelState extends ConsumerState<_SimulatorPanel> {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Simulation failed: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentTransactionCount = widget.transactionsAsync.valueOrNull?.length ?? 0;

    final content = _ActionCard(
      busy: _busy,
      dashboardAsync: widget.dashboardAsync,
      recentTransactionCount: recentTransactionCount,
      onSalary: () => _execute(() async {
        await ref.read(automationServiceProvider).triggerSalary(amount: 2500, reserveAmount: 400);
      }),
      onExpense: () => _execute(() async {
        await ref.read(automationServiceProvider).triggerExpense(amount: 180);
      }),
      onAutomation: () => _execute(() async {
        await ref.read(automationServiceProvider).runAutomation();
      }),
    );

    final status = _AiStatusCard(
      automationAsync: widget.automationAsync,
    );

    return widget.isDesktop
        ? Row(
            children: [
              Expanded(child: content),
              const SizedBox(width: 20),
              Expanded(child: status),
            ],
          )
        : Column(
            children: [
              content,
              const SizedBox(height: 20),
              status,
            ],
          );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
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
              _ActionButton(
                label: 'Receive Salary',
                icon: Icons.payments_outlined,
                busy: busy,
                onTap: onSalary,
              ),
              _ActionButton(
                label: 'Simulate Expense',
                icon: Icons.remove_circle_outline,
                busy: busy,
                onTap: onExpense,
              ),
              _ActionButton(
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.busy,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: busy ? null : onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.bgElevated,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
    );
  }
}

class _AiStatusCard extends StatelessWidget {
  const _AiStatusCard({required this.automationAsync});

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

class _BalanceAndAiRow extends StatelessWidget {
  const _BalanceAndAiRow({
    required this.isDesktop,
    required this.dashboardAsync,
    required this.automationAsync,
  });

  final bool isDesktop;
  final AsyncValue<DashboardModel> dashboardAsync;
  final AsyncValue<List<AutomationEventModel>> automationAsync;

  @override
  Widget build(BuildContext context) {
    final balanceCard = _BalanceCard(dashboardAsync: dashboardAsync);
    final aiCard = _AiSummaryCard(dashboardAsync: dashboardAsync, automationAsync: automationAsync);

    return isDesktop
        ? Row(
            children: [
              Expanded(flex: 2, child: balanceCard),
              const SizedBox(width: 20),
              Expanded(child: aiCard),
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.dashboardAsync});

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
              _PillMetric(
                label: 'Protected Funds',
                value: dashboard == null ? '—' : '\$${dashboard.protectedFunds.toStringAsFixed(2)}',
                color: AppColors.emerald,
              ),
              _PillMetric(
                label: 'Liquidity',
                value: dashboard == null ? '—' : '\$${dashboard.availableLiquidity.toStringAsFixed(2)}',
                color: AppColors.violet,
              ),
              _PillMetric(
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

class _PillMetric extends StatelessWidget {
  const _PillMetric({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgOverlay,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 11)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _AiSummaryCard extends StatelessWidget {
  const _AiSummaryCard({required this.dashboardAsync, required this.automationAsync});

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

class _HealthSummaryCard extends StatelessWidget {
  const _HealthSummaryCard({
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
          _HealthRow(label: 'Risk Score', value: dashboard == null ? '—' : '${dashboard.riskScore}', color: dashboard != null && dashboard.riskScore < 30 ? AppColors.emerald : AppColors.amber),
          const SizedBox(height: 12),
          _HealthRow(label: 'Liquidity Status', value: liquidityStatus, color: liquidityStatus == 'Healthy' ? AppColors.emerald : AppColors.amber),
          const SizedBox(height: 12),
          _HealthRow(label: 'Automation Level', value: '$completedToday executed today', color: AppColors.cyan),
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

class _HealthRow extends StatelessWidget {
  const _HealthRow({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _TransactionFeed extends StatelessWidget {
  const _TransactionFeed({required this.transactionsAsync});

  final AsyncValue<List<TransactionModel>> transactionsAsync;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'RECENT TRANSACTIONS',
            subtitle: 'Backend-driven activity feed',
            icon: Icons.receipt_long_outlined,
            iconColor: AppColors.cyan,
          ),
          const SizedBox(height: 18),
          transactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return const Text('No transactions yet', style: TextStyle(color: AppColors.textSecondary));
              }

              return Column(
                children: transactions.take(4).map((transaction) {
                  final sign = transaction.amount >= 0 ? '+' : '-';
                  final color = transaction.amount >= 0 ? AppColors.emerald : AppColors.amber;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${transaction.type.toUpperCase()} • ${transaction.date.toLocal().toIso8601String().substring(0, 19)}',
                            style: const TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                        Text(
                          '$sign\$${transaction.amount.abs().toStringAsFixed(2)}',
                          style: TextStyle(color: color, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (error, _) => Text('Failed to load transactions: $error', style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.08);
  }
}

class _AutomationTimeline extends StatelessWidget {
  const _AutomationTimeline({required this.automationAsync});

  final AsyncValue<List<AutomationEventModel>> automationAsync;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'AUTOMATION TIMELINE',
            subtitle: 'Dynamic events generated by the engine',
            icon: Icons.timeline_rounded,
            iconColor: AppColors.violet,
          ),
          const SizedBox(height: 18),
          automationAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return const Text('No automation events yet', style: TextStyle(color: AppColors.textSecondary));
              }

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.bgOverlay,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: events.take(6).toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final event = entry.value;
                    final isLast = index == events.take(6).length - 1;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: event.status.toLowerCase() == 'completed' ? AppColors.emerald : AppColors.amber,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(event.action, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(
                                      event.timestamp.toLocal().toIso8601String().substring(0, 19),
                                      style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                event.status.toUpperCase(),
                                style: TextStyle(
                                  color: event.status.toLowerCase() == 'completed' ? AppColors.emerald : AppColors.amber,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast) const NxDivider(),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (error, _) => Text('Failed to load timeline: $error', style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08);
  }
}
