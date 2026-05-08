import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';


class AutomationCard extends StatelessWidget {
  const AutomationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NxCard(
      hoverable: true,
      glowColor: AppColors.emerald,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'AUTOMATION STATUS',
            subtitle: 'Realtime monitoring',
            icon: Icons.auto_awesome_outlined,
            iconColor: AppColors.emerald,
            badge: 'ACTIVE',
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Container(
                width: 12,
                height: 12,

                decoration: const BoxDecoration(
                  color: AppColors.emerald,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                'Operational',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'All automations are running normally with no incidents detected.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}