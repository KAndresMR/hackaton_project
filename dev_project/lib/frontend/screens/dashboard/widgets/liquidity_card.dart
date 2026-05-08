import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:flutter/material.dart';


class LiquidityCard extends StatelessWidget {
  const LiquidityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NxCard(
      hoverable: true,
      glowColor: AppColors.violet,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'LIQUIDITY',
            subtitle: 'System allocation',
            icon: Icons.water_drop_outlined,
            iconColor: AppColors.violet,
          ),

          const SizedBox(height: 28),
          FutureBuilder<Map<String, dynamic>>(
            future: ApiService.getDashboard(),
            builder: (context, snapshot) {
              final dashboard = snapshot.data ?? {};
              final availableLiquidity = (dashboard['available_liquidity'] as num?)?.toDouble() ?? 0;
              final balance = (dashboard['balance'] as num?)?.toDouble() ?? 1;
              final ratio = (availableLiquidity / balance).clamp(0.0, 1.0);

              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 10,
                      backgroundColor: AppColors.bgOverlay,
                      valueColor: const AlwaysStoppedAnimation(AppColors.violet),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(ratio * 100).toStringAsFixed(0)}% Available',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const Text(
                        'Healthy',
                        style: TextStyle(
                          color: AppColors.emerald,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}