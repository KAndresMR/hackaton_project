import 'package:credynox/core/helpers/responsive.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.getActivity();
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
                  'Failed to load activity: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              );
            }

            final activity = snapshot.data ?? const [];
            final columns = ResponsiveHelper.gridColumns(context);
            return SingleChildScrollView(
              padding: ResponsiveHelper.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activity',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Everything the engine did, in chronological order.',
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
                      _MetricTile(title: 'Today', value: '${activity.length} events', accent: AppColors.cyan),
                      _MetricTile(title: 'Income', value: '\$3,200', accent: AppColors.emerald),
                      const _MetricTile(title: 'Automations', value: '12 runs', accent: AppColors.violet),
                      const _MetricTile(title: 'Protected', value: '\$1,840', accent: AppColors.amber),
                    ],
                  ),
                  const SizedBox(height: 24),
                  NxCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const NxCardHeader(
                          title: 'Timeline',
                          subtitle: 'Recent simulation and protection events.',
                          icon: Icons.history_rounded,
                        ),
                        const SizedBox(height: 16),
                        ...activity.map((entry) {
                          final item = entry as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _TimelineItem(
                              time: _formatTime(item['timestamp']?.toString() ?? ''),
                              title: item['title']?.toString() ?? 'Event',
                              description: item['description']?.toString() ?? '',
                              amount: _formatAmount(item['amount']),
                              accent: _accentFor(item['category']?.toString() ?? 'automation'),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatTime(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return '--:--';
    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return 'View';
    final value = (amount as num).toDouble();
    final prefix = value < 0 ? '-' : '+';
    return '$prefix\$${value.abs().toStringAsFixed(0)}';
  }

  Color _accentFor(String category) {
    switch (category) {
      case 'income':
        return AppColors.emerald;
      case 'expense':
        return AppColors.rose;
      case 'risk':
        return AppColors.amber;
      case 'bank':
        return AppColors.cyan;
      default:
        return AppColors.violet;
    }
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

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.time,
    required this.title,
    required this.description,
    required this.amount,
    required this.accent,
  });

  final String time;
  final String title;
  final String description;
  final String amount;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent,
                ),
              ),
              Container(width: 2, height: 34, color: AppColors.borderSubtle),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: accent)),
        ],
      ),
    );
  }
}