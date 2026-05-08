import 'package:flutter/widgets.dart';

// ── Breakpoints ───────────────────────────────────────────────────────────────
abstract class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1280;
  static const double wide = 1600;
}

// ── Screen Type Enum ──────────────────────────────────────────────────────────
enum ScreenType { mobile, tablet, desktop, wide }

// ── ResponsiveHelper ──────────────────────────────────────────────────────────
class ResponsiveHelper {
  ResponsiveHelper._();

  static ScreenType of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= Breakpoints.wide) return ScreenType.wide;
    if (width >= Breakpoints.desktop) return ScreenType.desktop;
    if (width >= Breakpoints.tablet) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == ScreenType.mobile;

  static bool isTablet(BuildContext context) =>
      of(context) == ScreenType.tablet;

  static bool isDesktop(BuildContext context) =>
      of(context) == ScreenType.desktop || of(context) == ScreenType.wide;

  static bool isLargerThan(BuildContext context, ScreenType type) {
    final current = of(context);
    return current.index > type.index;
  }

  // ── Responsive value helper ──────────────────────────────────────────────
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
    T? wide,
  }) {
    final type = of(context);
    return switch (type) {
      ScreenType.mobile => mobile,
      ScreenType.tablet => tablet ?? desktop,
      ScreenType.desktop => desktop,
      ScreenType.wide => wide ?? desktop,
    };
  }

  // ── Column count for grids ───────────────────────────────────────────────
  static int gridColumns(BuildContext context) => value(
        context,
        mobile: 1,
        tablet: 2,
        desktop: 3,
        wide: 4,
      );

  // ── Horizontal padding ───────────────────────────────────────────────────
  static EdgeInsets pagePadding(BuildContext context) => value(
        context,
        mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        tablet: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        desktop: const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
        wide: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      );

  static double sidebarWidth(BuildContext context) => value(
        context,
        mobile: 0,
        tablet: 0,
        desktop: 240,
        wide: 280,
      );
}

// ── Responsive Builder Widget ─────────────────────────────────────────────────
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context) desktop;

  @override
  Widget build(BuildContext context) {
    final type = ResponsiveHelper.of(context);
    return switch (type) {
      ScreenType.mobile => mobile(context),
      ScreenType.tablet => (tablet ?? desktop)(context),
      ScreenType.desktop || ScreenType.wide => desktop(context),
    };
  }
}

// ── Responsive Layout (show/hide) ────────────────────────────────────────────
class ShowOnDesktop extends StatelessWidget {
  const ShowOnDesktop({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ResponsiveHelper.isDesktop(context) ? child : const SizedBox.shrink();
}

class ShowOnMobile extends StatelessWidget {
  const ShowOnMobile({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ResponsiveHelper.isMobile(context) ? child : const SizedBox.shrink();
}