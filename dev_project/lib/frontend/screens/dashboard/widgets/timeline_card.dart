import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';

class TimelineCard extends StatelessWidget {
  const TimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              color: AppColors.bgOverlay,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.borderSubtle,
              ),
            ),

            child: Column(
              children: [
                _TimelineItem(
                  title: 'Liquidity rebalance executed',
                  time: '2 min ago',
                ),

                const NxDivider(),

                _TimelineItem(
                  title: 'New transaction categorized',
                  time: '12 min ago',
                ),

                const NxDivider(),

                _TimelineItem(
                  title: 'Cashflow prediction updated',
                  time: '1 hour ago',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.title,
    required this.time,
  });

  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),

      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,

            decoration: const BoxDecoration(
              color: AppColors.cyan,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

