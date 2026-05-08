import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(height: 24),

          Container(
            height: 240,

            decoration: BoxDecoration(
              color: AppColors.bgOverlay,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.borderSubtle,
              ),
            ),

            padding: const EdgeInsets.all(20),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                _Bar(60),
                _Bar(120),
                _Bar(90),
                _Bar(170),
                _Bar(130),
                _Bar(200),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar(this.height);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: height,

      decoration: BoxDecoration(
        gradient: AppColors.cyanVioletGradient,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}