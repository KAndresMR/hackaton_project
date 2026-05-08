import 'package:credynox/core/helpers/responsive.dart';
import 'package:credynox/core/router/routes.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.getSettings();
  }

  Future<void> _save(Map<String, dynamic> current, String key, bool value) async {
    await ApiService.updateSettings(
      autoReserve: key == 'auto_reserve' ? value : current['auto_reserve'] == true,
      liquidityProtection: key == 'liquidity_protection' ? value : current['liquidity_protection'] == true,
      automaticPayments: key == 'automatic_payments' ? value : current['automatic_payments'] == true,
      aiOptimization: key == 'ai_optimization' ? value : current['ai_optimization'] == true,
    );
    if (mounted) {
      setState(() => _future = ApiService.getSettings());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load settings: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              );
            }

            final settings = snapshot.data ?? const {};
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
                        'Settings',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tune the automation engine without leaving the product flow.',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  NxCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const NxCardHeader(
                          title: 'Automation toggles',
                          subtitle: 'These are backed by the mock API and persist in memory.',
                          icon: Icons.tune_rounded,
                        ),
                        const SizedBox(height: 16),
                        _ToggleRow(
                          title: 'Auto reserve',
                          subtitle: 'Move salary into protected funds automatically.',
                          value: settings['auto_reserve'] == true,
                          accent: AppColors.cyan,
                          onChanged: (value) => _save(settings, 'auto_reserve', value),
                        ),
                        const SizedBox(height: 12),
                        _ToggleRow(
                          title: 'Liquidity protection',
                          subtitle: 'Keep available cash above the reserve threshold.',
                          value: settings['liquidity_protection'] == true,
                          accent: AppColors.emerald,
                          onChanged: (value) => _save(settings, 'liquidity_protection', value),
                        ),
                        const SizedBox(height: 12),
                        _ToggleRow(
                          title: 'Automatic payments',
                          subtitle: 'Simulate safe bill and subscription execution.',
                          value: settings['automatic_payments'] == true,
                          accent: AppColors.violet,
                          onChanged: (value) => _save(settings, 'automatic_payments', value),
                        ),
                        const SizedBox(height: 12),
                        _ToggleRow(
                          title: 'AI optimization',
                          subtitle: 'Keep the assisted cash-flow recommendations active.',
                          value: settings['ai_optimization'] == true,
                          accent: AppColors.amber,
                          onChanged: (value) => _save(settings, 'ai_optimization', value),
                        ),
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

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accent,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final Color accent;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.settings_rounded, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: accent),
        ],
      ),
    );
  }
}