import 'package:credynox/core/helpers/responsive.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';

class AutomationsScreen extends StatefulWidget {
  const AutomationsScreen({super.key});

  @override
  State<AutomationsScreen> createState() => _AutomationsScreenState();
}

class _AutomationsScreenState extends State<AutomationsScreen> {
  late Future<Map<String, dynamic>> _settingsFuture;

  @override
  void initState() {
    super.initState();
    _settingsFuture = ApiService.getSettings();
  }

  Future<void> _toggle(String key, bool value, Map<String, dynamic> current) async {
    await ApiService.updateSettings(
      autoReserve: key == 'auto_reserve' ? value : current['auto_reserve'] == true,
      liquidityProtection: key == 'liquidity_protection' ? value : current['liquidity_protection'] == true,
      automaticPayments: key == 'automatic_payments' ? value : current['automatic_payments'] == true,
      aiOptimization: key == 'ai_optimization' ? value : current['ai_optimization'] == true,
    );
    if (mounted) {
      setState(() {
        _settingsFuture = ApiService.getSettings();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _settingsFuture,
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
                  const Text(
                    'Automations',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rules that protect cash flow and move money automatically.',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  _AutomationOverview(settings: settings),
                  const SizedBox(height: 24),
                  _AutomationToggles(settings: settings, onToggle: _toggle),
                  const SizedBox(height: 24),
                  const _AutomationRules(),
                ],
              ),
            );
          },
          ),
      ),
    );
  }
}

class _AutomationOverview extends StatelessWidget {
  const _AutomationOverview({required this.settings});

  final Map<String, dynamic> settings;

  @override
  Widget build(BuildContext context) {
    final enabledCount = [
      settings['auto_reserve'] == true,
      settings['liquidity_protection'] == true,
      settings['automatic_payments'] == true,
      settings['ai_optimization'] == true,
    ].where((enabled) => enabled).length;

    return NxCard(
      hoverable: true,
      borderColor: AppColors.emerald.withValues(alpha: 0.3),
      glowColor: AppColors.emerald.withValues(alpha: 0.12),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.emeraldMuted,
              border: Border.all(color: AppColors.emerald.withValues(alpha: 0.25)),
            ),
            child: const Icon(Icons.bolt_rounded, color: AppColors.emerald, size: 32),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$enabledCount of 4 automations enabled',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'The engine reserves cash, pays bills, and watches thresholds in real time.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AutomationToggles extends StatefulWidget {
  const _AutomationToggles({required this.settings, required this.onToggle});

  final Map<String, dynamic> settings;
  final Future<void> Function(String key, bool value, Map<String, dynamic> current) onToggle;

  @override
  State<_AutomationToggles> createState() => _AutomationTogglesState();
}

class _AutomationTogglesState extends State<_AutomationToggles> {
  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.gridColumns(context);
    return GridView.count(
      crossAxisCount: columns >= 3 ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.55,
      children: [
        _ToggleCard(
          title: 'Auto reserve',
          subtitle: 'Move salary into protected funds automatically.',
          icon: Icons.savings_rounded,
          accent: AppColors.cyan,
          value: widget.settings['auto_reserve'] == true,
          onChanged: (value) => widget.onToggle('auto_reserve', value, widget.settings),
        ),
        _ToggleCard(
          title: 'Smart liquidity',
          subtitle: 'Keep enough available cash before payouts.',
          icon: Icons.water_drop_rounded,
          accent: AppColors.emerald,
          value: widget.settings['liquidity_protection'] == true,
          onChanged: (value) => widget.onToggle('liquidity_protection', value, widget.settings),
        ),
        _ToggleCard(
          title: 'Auto bills',
          subtitle: 'Schedule utilities and subscriptions safely.',
          icon: Icons.receipt_long_rounded,
          accent: AppColors.violet,
          value: widget.settings['automatic_payments'] == true,
          onChanged: (value) => widget.onToggle('automatic_payments', value, widget.settings),
        ),
        _ToggleCard(
          title: 'AI optimization',
          subtitle: 'Suggest better savings and transfer moments.',
          icon: Icons.auto_awesome_rounded,
          accent: AppColors.amber,
          value: widget.settings['ai_optimization'] == true,
          onChanged: (value) => widget.onToggle('ai_optimization', value, widget.settings),
        ),
      ],
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      hoverable: true,
      borderColor: accent.withValues(alpha: 0.28),
      glowColor: accent.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent.withValues(alpha: 0.2)),
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: accent,
          ),
        ],
      ),
    );
  }
}

class _AutomationRules extends StatelessWidget {
  const _AutomationRules();

  @override
  Widget build(BuildContext context) {
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          NxCardHeader(
            title: 'Automation rules',
            subtitle: 'Review what the engine does when signals change.',
            icon: Icons.rule_rounded,
          ),
          SizedBox(height: 16),
          _RuleItem(
            title: 'Salary detection',
            description: 'Detect incoming salary, reserve funds, and update balances.',
            status: 'Active',
            accent: AppColors.cyan,
          ),
          SizedBox(height: 12),
          _RuleItem(
            title: 'Low balance alert',
            description: 'Warn if liquidity drops below the configured threshold.',
            status: 'Active',
            accent: AppColors.amber,
          ),
          SizedBox(height: 12),
          _RuleItem(
            title: 'Budget exceed block',
            description: 'Mark spending bursts and recommend a reserve transfer.',
            status: 'Queued',
            accent: AppColors.violet,
          ),
        ],
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    required this.title,
    required this.description,
    required this.status,
    required this.accent,
  });

  final String title;
  final String description;
  final String status;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.rule_rounded, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: accent.withValues(alpha: 0.22)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: accent,
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
