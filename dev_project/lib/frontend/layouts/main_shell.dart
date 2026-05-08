import 'package:credynox/core/helpers/responsive.dart';
import 'package:credynox/core/router/routes.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';


class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (_) => _MobileShell(child: child),
      desktop: (_) => _DesktopShell(child: child),
    );
  }
}

// ── Desktop Shell (Sidebar) ───────────────────────────────────────────────────
class _DesktopShell extends StatelessWidget {
  const _DesktopShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Row(
        children: [
          _Sidebar(),
          const VerticalDivider(
            width: 1,
            color: AppColors.borderSubtle,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ── Mobile Shell (Bottom Nav) ─────────────────────────────────────────────────
class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: child,
      bottomNavigationBar: _buildBottomNav(context, location),
    );
  }

  Widget _buildBottomNav(BuildContext context, String location) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.cyanMuted,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.cyan : AppColors.textTertiary,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 22,
              color: selected ? AppColors.cyan : AppColors.textTertiary,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _getSelectedIndex(location),
          onDestinationSelected: (i) => _onNavTap(context, i),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_rounded),
              label: 'Accounts',
            ),
            NavigationDestination(
              icon: Icon(Icons.bolt_rounded),
              label: 'Automate',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith(AppRoutes.dashboard)) return 0;
    if (location.startsWith(AppRoutes.accounts)) return 1;
    if (location.startsWith(AppRoutes.automations)) return 2;
    if (location.startsWith(AppRoutes.profile)) return 3;
    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        context.go(AppRoutes.accounts);
        break;
      case 2:
        context.go(AppRoutes.automations);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }
}

// ── Desktop Sidebar ───────────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      width: 240,
      color: AppColors.bgSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: _CredyNoxLogo(),
          ),

          // ── Nav items ───────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _SidebarItem(
                    icon: Icons.grid_view_rounded,
                    label: 'Dashboard',
                    isActive: location.startsWith(AppRoutes.dashboard),
                    onTap: () => context.go(AppRoutes.dashboard),
                  ),
                  const SizedBox(height: 2),
                  _SidebarItem(
                    icon: Icons.account_balance_rounded,
                    label: 'Accounts',
                    isActive: location.startsWith(AppRoutes.accounts),
                    onTap: () => context.go(AppRoutes.accounts),
                  ),
                  const SizedBox(height: 2),
                  _SidebarItem(
                    icon: Icons.bolt_rounded,
                    label: 'Automations',
                    isActive: location.startsWith(AppRoutes.automations),
                    onTap: () => context.go(AppRoutes.automations),
                    badge: '3',
                  ),
                  const SizedBox(height: 2),
                  _SidebarItem(
                    icon: Icons.timeline_rounded,
                    label: 'Timeline',
                    isActive: location.startsWith(AppRoutes.automations),
                    onTap: () => context.go(AppRoutes.automations),
                  ),
                  const SizedBox(height: 2),
                  _SidebarItem(
                    icon: Icons.analytics_rounded,
                    label: 'Analytics',
                    isActive: location.startsWith(AppRoutes.automations),
                    onTap: () => context.go(AppRoutes.automations),
                  ),
                  const Spacer(),
                  const Divider(color: AppColors.borderSubtle),
                  const SizedBox(height: 8),
                  _SidebarItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    isActive: location.startsWith(AppRoutes.profile),
                    onTap: () => context.go(AppRoutes.profile),
                  ),
                  _SidebarItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help',
                    isActive: location.startsWith(AppRoutes.profile),
                    onTap: () => context.go(AppRoutes.profile),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── User profile row ─────────────────────────────────────────────
          _SidebarUserRow(),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms, curve: Curves.easeOut)
        .slideX(begin: -0.03, duration: 350.ms, curve: Curves.easeOut);
  }
}

// ── Sidebar Item ──────────────────────────────────────────────────────────────
class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final String? badge;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 180.ms,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.cyanMuted
                : _hovered
                    ? AppColors.bgOverlay
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.isActive
                ? Border.all(color: AppColors.cyan.withValues(alpha: 0.25), width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: widget.isActive
                    ? AppColors.cyan
                    : _hovered
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: widget.isActive
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: widget.isActive
                        ? AppColors.cyan
                        : _hovered
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                  ),
                ),
              ),
              if (widget.badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.violetMuted,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.violet.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Text(
                    widget.badge!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.violet,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Logo ──────────────────────────────────────────────────────────────────────
class _CredyNoxLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.cyan, AppColors.violet],
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Center(
            child: Text(
              'C',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CredyNox',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Finance OS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Sidebar User Row ──────────────────────────────────────────────────────────
class _SidebarUserRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.violetMuted,
            child: const Text(
              'JD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.violet,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Pro Plan',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.unfold_more_rounded,
            size: 16,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}