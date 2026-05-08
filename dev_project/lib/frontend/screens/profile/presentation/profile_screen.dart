import 'package:credynox/core/helpers/responsive.dart';
import 'package:credynox/core/router/routes.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait([
      ApiService.getProfile(),
      ApiService.getDashboard(),
      ApiService.getSettings(),
      ApiService.getBanks(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load profile: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              );
            }

            final profile = snapshot.data![0] as Map<String, dynamic>;
            final dashboard = snapshot.data![1] as Map<String, dynamic>;
            final settings = snapshot.data![2] as Map<String, dynamic>;
            final banks = snapshot.data![3] as List<dynamic>;
            final name = profile['name']?.toString() ?? 'Michael';
            final initials = name.isNotEmpty ? name.substring(0, 1) : 'M';

            return SingleChildScrollView(
              padding: ResponsiveHelper.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.dashboard),
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  NxCard(
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.cyan, AppColors.violet],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'michael@credynox.fin',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.verified_rounded, color: AppColors.emerald, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${profile['connected_bank']?.toString() ?? 'Banco Pichincha'} · ${profile['automation_level']?.toString() ?? 'Advanced'}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: ResponsiveHelper.gridColumns(context),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.5,
                    children: [
                      _StatTile(
                        title: 'Optimized money',
                        value: '\$${(profile['optimized_money'] as num?)?.toStringAsFixed(0) ?? '120'}',
                        accent: AppColors.cyan,
                      ),
                      _StatTile(
                        title: 'Balance',
                        value: '\$${(dashboard['balance'] as num?)?.toStringAsFixed(0) ?? '0'}',
                        accent: AppColors.emerald,
                      ),
                      _StatTile(
                        title: 'Connected banks',
                        value: banks.length.toString(),
                        accent: AppColors.violet,
                      ),
                      _StatTile(
                        title: 'AI status',
                        value: (profile['ai_status'] == true && settings['ai_optimization'] == true) ? 'Active' : 'Disabled',
                        accent: AppColors.amber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  NxCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const NxCardHeader(
                          title: 'Connected institutions',
                          subtitle: 'Banks currently linked to the simulation engine.',
                          icon: Icons.account_balance_rounded,
                        ),
                        const SizedBox(height: 16),
                        ...banks.map((bank) {
                          final item = bank as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _BankRow(
                              name: item['name']?.toString() ?? 'Bank',
                              connected: item['connected'] == true,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.title, required this.value, required this.accent});

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      hoverable: true,
      borderColor: accent.withValues(alpha: 0.3),
      glowColor: accent.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _BankRow extends StatelessWidget {
  const _BankRow({required this.name, required this.connected});

  final String name;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_rounded, color: AppColors.cyan),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: connected ? AppColors.emeraldMuted : AppColors.violetMuted,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              connected ? 'Connected' : 'Available',
              style: TextStyle(
                color: connected ? AppColors.emerald : AppColors.violet,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
