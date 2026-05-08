import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:flutter/material.dart';


class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NxCard(
      gradient: AppColors.balanceGradient,
      glowColor: AppColors.cyan,
      hoverable: true,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'AVAILABLE BALANCE',
            subtitle: 'Updated 2 minutes ago',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.cyan,
            badge: 'LIVE',
          ),

          const SizedBox(height: 34),

          FutureBuilder<Map<String, dynamic>>(
            future: ApiService.getDashboard(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 48,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Text(
                  '\$24,580.00',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.5,
                      ),
                );
              }

              final data = snapshot.data ?? {};
              final balanceValue = data['balance'];
              final balance = balanceValue is num ? balanceValue : 24580;

              return Text(
                '\$${balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.5,
                    ),
              );
            },
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),

                decoration: BoxDecoration(
                  color: AppColors.emeraldMuted,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Text(
                  '+12.4%',
                  style: TextStyle(
                    color: AppColors.emerald,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                'vs last month',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}