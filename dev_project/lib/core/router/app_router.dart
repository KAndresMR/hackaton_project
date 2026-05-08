import 'package:credynox/core/router/routes.dart';
import 'package:credynox/frontend/layouts/main_shell.dart';
import 'package:credynox/frontend/screens/activity/presentation/activity_screen.dart';
import 'package:credynox/frontend/screens/analytics/presentation/analytics_screen.dart';
import 'package:credynox/frontend/screens/connect_bank/pressentation/connect_bank_screen.dart';
import 'package:credynox/frontend/screens/accounts/presentation/accounts_screen.dart';
import 'package:credynox/frontend/screens/automations/presentation/automations_screen.dart';
import 'package:credynox/frontend/screens/dashboard/presentation/dashboard_screen.dart';
import 'package:credynox/frontend/screens/profile/presentation/profile_screen.dart';
import 'package:credynox/frontend/screens/help/presentation/help_screen.dart';
import 'package:credynox/frontend/screens/settings/presentation/settings_screen.dart';
import 'package:credynox/frontend/screens/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// ── Router Provider ───────────────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      // ── Splash ──────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => _buildFadePage(
          state: state,
          child: const SplashScreen(),
        ),
      ),

      // ── Connect Bank ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.connectBank,
        name: 'connect-bank',
        pageBuilder: (context, state) => _buildSlidePage(
          state: state,
          child: const ConnectBankScreen(),
        ),
      ),

      // ── Main Shell (with nav) ─────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) => _buildFadePage(
              state: state,
              child: const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.accounts,
            name: 'accounts',
            pageBuilder: (context, state) => _buildFadePage(
              state: state,
              child: const AccountsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.automations,
            name: 'automations',
            pageBuilder: (context, state) => _buildFadePage(
              state: state,
              child: const AutomationsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.activity,
            name: 'activity',
            pageBuilder: (context, state) => _buildFadePage(
              state: state,
              child: const ActivityScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            name: 'analytics',
            pageBuilder: (context, state) => _buildFadePage(
              state: state,
              child: const AnalyticsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => _buildFadePage(
              state: state,
              child: const ProfileScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => _buildFadePage(
              state: state,
              child: const SettingsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.help,
            name: 'help',
            pageBuilder: (context, state) => _buildFadePage(
              state: state,
              child: const HelpScreen(),
            ),
          ),
        ],
      ),
    ],

    // ── Error page ─────────────────────────────────────────────────────────
    errorPageBuilder: (context, state) => _buildFadePage(
      state: state,
      child: _ErrorPage(error: state.error),
    ),
  );
});

// ── Page transition builders ──────────────────────────────────────────────────
CustomTransitionPage<void> _buildFadePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _buildSlidePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween(
        begin: const Offset(0.05, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

// ── Error Page ────────────────────────────────────────────────────────────────
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({this.error});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Route not found\n${error?.toString() ?? ""}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}