import 'package:credynox/core/helpers/responsive.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait([ApiService.getDashboard(), ApiService.getProfile()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load analytics: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              );
            }

            final dashboard = snapshot.data![0] as Map<String, dynamic>;
            final profile = snapshot.data![1] as Map<String, dynamic>;
            final columns = ResponsiveHelper.gridColumns(context);

            return SingleChildScrollView(
              padding: ResponsiveHelper.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analytics',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A compact view of growth, retention, and cash efficiency.',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.8,
                    children: [
                      _MetricTile(title: 'Savings rate', value: '${profile['optimized_money']?.toString() ?? '120'}', accent: AppColors.emerald),
                      _MetricTile(title: 'Runway', value: '${dashboard['available_liquidity']?.toString() ?? '0'}', accent: AppColors.cyan),
                      _MetricTile(title: 'Risk score', value: '${dashboard['risk_score']?.toString() ?? '0'}', accent: AppColors.amber),
                      _MetricTile(title: 'Automation ROI', value: '${profile['automation_level']?.toString() ?? 'Advanced'}', accent: AppColors.violet),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: columns >= 2 ? 2 : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: columns >= 2 ? 0.98 : 0.88,
                    children: [
                      const _ChartCard(),
                      _InsightCard(
                        balance: dashboard['balance']?.toString() ?? '0',
                        connectedBank: profile['connected_bank']?.toString() ?? 'Banco Pichincha',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.title, required this.value, required this.accent});

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      hoverable: true,
      borderColor: accent.withValues(alpha: 0.3),
      glowColor: accent.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard();

  @override
  Widget build(BuildContext context) {
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'Cash flow trend',
            subtitle: 'Last 30 days of inflow vs reserve movement.',
            icon: Icons.show_chart_rounded,
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _Bar(height: 0.45, accent: AppColors.cyan),
                SizedBox(width: 10),
                _Bar(height: 0.62, accent: AppColors.emerald),
                SizedBox(width: 10),
                _Bar(height: 0.38, accent: AppColors.violet),
                SizedBox(width: 10),
                _Bar(height: 0.74, accent: AppColors.cyan),
                SizedBox(width: 10),
                _Bar(height: 0.56, accent: AppColors.amber),
                SizedBox(width: 10),
                _Bar(height: 0.8, accent: AppColors.emerald),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.accent});

  final double height;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: height,
          widthFactor: 0.72,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [accent.withValues(alpha: 0.9), accent.withValues(alpha: 0.28)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.balance, required this.connectedBank});

  final String balance;
  final String connectedBank;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'Top insights',
            subtitle: 'What the engine would recommend next.',
            icon: Icons.auto_graph_rounded,
          ),
          SizedBox(height: 16),
          _InsightRow(
            title: 'Increase reserve rate',
            description: 'The current balance is $balance and the main bank is $connectedBank.',
            accent: AppColors.emerald,
          ),
          SizedBox(height: 12),
          const _InsightRow(
            title: 'Reduce low-value subscriptions',
            description: 'Cancel 2 recurring items to free about \$180 per month.',
            accent: AppColors.amber,
          ),
          SizedBox(height: 12),
          const _InsightRow(
            title: 'Trigger automation earlier',
            description: 'Set the reserve rule to fire 8 hours sooner after payroll.',
            accent: AppColors.violet,
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.title, required this.description, required this.accent});

  final String title;
  final String description;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}