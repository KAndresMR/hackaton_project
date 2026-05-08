import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
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

          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 10,
              backgroundColor: AppColors.bgOverlay,
              valueColor: AlwaysStoppedAnimation(AppColors.violet),
            ),
          ),

          const SizedBox(height: 18),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '72% Available',
                style: TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),

              Text(
                'Healthy',
                style: TextStyle(
                  color: AppColors.emerald,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}