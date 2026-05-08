import 'package:credynox/core/helpers/responsive.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.gridColumns(context);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Accounts',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'All linked institutions and cash positions in one place.',
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
                children: const [
                  _SummaryTile(
                    title: 'Net worth',
                    value: '\$48,240',
                    accent: AppColors.cyan,
                  ),
                  _SummaryTile(
                    title: 'Liquid cash',
                    value: '\$12,840',
                    accent: AppColors.emerald,
                  ),
                  _SummaryTile(
                    title: 'Linked accounts',
                    value: '6',
                    accent: AppColors.violet,
                  ),
                  _SummaryTile(
                    title: 'Monthly burn',
                    value: '\$3,240',
                    accent: AppColors.amber,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: columns >= 2 ? 2 : 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.85,
                children: const [
                  _AccountCard(
                    name: 'Banco Pichincha',
                    type: 'Primary checking',
                    balance: '\$8,420',
                    updated: 'Updated 2 min ago',
                    accent: AppColors.cyan,
                    icon: Icons.account_balance_rounded,
                  ),
                  _AccountCard(
                    name: 'Produbanco',
                    type: 'Savings vault',
                    balance: '\$11,200',
                    updated: 'Updated 8 min ago',
                    accent: AppColors.emerald,
                    icon: Icons.savings_rounded,
                  ),
                  _AccountCard(
                    name: 'Pacífico',
                    type: 'Credit line',
                    balance: '-\$1,180',
                    updated: 'Updated 15 min ago',
                    accent: AppColors.rose,
                    icon: Icons.credit_card_rounded,
                  ),
                  _AccountCard(
                    name: 'Bolivariano',
                    type: 'Investment wallet',
                    balance: '\$29,800',
                    updated: 'Updated 1 hour ago',
                    accent: AppColors.violet,
                    icon: Icons.trending_up_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.title,
    required this.value,
    required this.accent,
  });

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      hoverable: true,
      borderColor: accent.withValues(alpha: 0.35),
      glowColor: accent.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.name,
    required this.type,
    required this.balance,
    required this.updated,
    required this.accent,
    required this.icon,
  });

  final String name;
  final String type;
  final String balance;
  final String updated;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      hoverable: true,
      borderColor: accent.withValues(alpha: 0.3),
      glowColor: accent.withValues(alpha: 0.14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accent.withValues(alpha: 0.25)),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                balance,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                updated,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
