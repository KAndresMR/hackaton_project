import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:credynox/frontend/services/api_service.dart';
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

          FutureBuilder<List<dynamic>>(
            future: ApiService.getTransactions(),
            builder: (context, snapshot) {
              final transactions = snapshot.data ?? const [];
              final values = transactions.isEmpty
                  ? [60.0, 120.0, 90.0, 170.0, 130.0, 200.0]
                  : transactions
                      .map((item) => ((item as Map<String, dynamic>)['amount'] as num).abs().toDouble())
                      .toList();

              return Container(
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

                  children: values.take(6).map((value) => _Bar(value)).toList(),
                ),
              );
            },
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