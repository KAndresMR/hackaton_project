import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
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

          Text(
            '\$24,580.00',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                ),
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