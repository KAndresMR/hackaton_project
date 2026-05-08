import 'package:credynox/frontend/screens/dashboard/widgets/analytics_card.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/automation_card.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/balance_card.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/dasboard_header.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/liquidity_card.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/risk_card.dart';
import 'package:credynox/frontend/screens/dashboard/widgets/timeline_card.dart';
import 'package:flutter/material.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🟢 DashboardGrid build started');

    final width = MediaQuery.of(context).size.width;

    debugPrint('📏 Screen width: $width');

    final isDesktop = width >= 1200;

    debugPrint('🖥️ isDesktop: $isDesktop');

    try {
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40 : 20,
              vertical: 24,
            ),

            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Builder(
                    builder: (_) {
                      debugPrint('✅ DashboardHeader rendered');
                      return const DashboardHeader();
                    },
                  ),

                  const SizedBox(height: 32),

                  Builder(
                    builder: (_) {
                      debugPrint('✅ BalanceCard rendered');
                      return const BalanceCard();
                    },
                  ),

                  const SizedBox(height: 24),

                  if (isDesktop)
                    Row(
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (_) {
                              debugPrint('✅ LiquidityCard rendered');
                              return const LiquidityCard();
                            },
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: Builder(
                            builder: (_) {
                              debugPrint('✅ AutomationCard rendered');
                              return const AutomationCard();
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Builder(
                          builder: (_) {
                            debugPrint('✅ LiquidityCard rendered');
                            return const LiquidityCard();
                          },
                        ),

                        const SizedBox(height: 20),

                        Builder(
                          builder: (_) {
                            debugPrint('✅ AutomationCard rendered');
                            return const AutomationCard();
                          },
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  Builder(
                    builder: (_) {
                      debugPrint('✅ TimelineCard rendered');
                      return const TimelineCard();
                    },
                  ),

                  const SizedBox(height: 24),

                  Builder(
                    builder: (_) {
                      debugPrint('✅ AnalyticsCard rendered');
                      return const AnalyticsCard();
                    },
                  ),

                  Builder(
                    builder: (_) {
                      debugPrint('✅ RiskCard rendered');
                      return const RiskCard();
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      );
    } catch (e, stack) {
      debugPrint('❌ DashboardGrid ERROR');
      debugPrint(e.toString());
      debugPrint(stack.toString());

      return Center(
        child: Text(
          'Dashboard Error: $e',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }
}