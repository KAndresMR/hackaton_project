import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:credynox/frontend/services/api_service.dart';
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

          FutureBuilder<List<dynamic>>(
            future: ApiService.getAutomationTimeline(),
            builder: (context, snapshot) {
              final events = snapshot.data ?? const [];
              final pending = events.where((event) {
                final map = event as Map<String, dynamic>;
                return (map['status'] ?? '').toString().toLowerCase() == 'pending';
              }).length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,

                        decoration: BoxDecoration(
                          color: pending == 0 ? AppColors.emerald : AppColors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        pending == 0 ? 'Operational' : 'Attention needed',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    pending == 0
                        ? 'All automations are running normally with no incidents detected.'
                        : '$pending automations are pending review.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
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