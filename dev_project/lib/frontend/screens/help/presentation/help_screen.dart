import 'package:credynox/core/helpers/responsive.dart';
import 'package:credynox/core/router/routes.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    'Help & Support',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Quick answers for demo flow, banking, and automation controls.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              const NxCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NxCardHeader(
                      title: 'Common questions',
                      subtitle: 'Focused on the hackathon demo behavior.',
                      icon: Icons.help_outline_rounded,
                    ),
                    SizedBox(height: 16),
                    _FaqItem(
                      question: 'How do I connect a bank?',
                      answer: 'Open Connect Bank and tap one of the mock institutions. The selection persists in memory.',
                    ),
                    SizedBox(height: 12),
                    _FaqItem(
                      question: 'How do automations work?',
                      answer: 'Turn toggles on in Settings or Automations. Salary and expense simulations update the state.',
                    ),
                    SizedBox(height: 12),
                    _FaqItem(
                      question: 'Where is the profile?',
                      answer: 'Tap the user row at the bottom of the sidebar or open /profile directly.',
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
                childAspectRatio: 2.2,
                children: const [
                  _SupportTile(title: 'Email', value: 'demo@credynox.fin', accent: AppColors.cyan),
                  _SupportTile(title: 'Response', value: '24h during hackathon', accent: AppColors.emerald),
                  _SupportTile(title: 'Docs', value: '/docs API explorer', accent: AppColors.violet),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(answer, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  const _SupportTile({required this.title, required this.value, required this.accent});

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
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}