// lib/frontend/widgets/nx_screen_parts.dart
//
// Partes reutilizables entre pantallas:
//   • NxScreenHeader   – título + subtítulo + botón volver opcional
//   • NxMetricTile     – tarjeta de estadística pressable con glow
//   • NxMetricGrid     – grid de NxMetricTile adaptativo
//   • NxScreenError    – estado de error con botón Retry
//   • NxScreenLoading  – estado de carga centrado
// ─────────────────────────────────────────────────────────────────
import 'package:credynox/core/helpers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'nx_card.dart';
import 'nx_pressable.dart';

// ─── NxScreenHeader ───────────────────────────────────────────────────────────
class NxScreenHeader extends StatelessWidget {
  const NxScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onBack != null)
          GestureDetector(
            onTap: onBack,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_rounded,
                      size: 16, color: AppColors.textTertiary),
                  SizedBox(width: 6),
                  Text(
                    'Back',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                    // Permite que el título baje de línea si no cabe
                    softWrap: true,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      softWrap: true,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 380.ms)
        .slideY(begin: -0.02, duration: 380.ms, curve: Curves.easeOut);
  }
}

// ─── NxMetricTile ────────────────────────────────────────────────────────────
// Tarjeta de estadística con glow animado + escala al presionar.
class NxMetricTile extends StatelessWidget {
  const NxMetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.accent,
    this.onTap,
    this.animationDelay = Duration.zero,
  });

  final String title;
  final String value;
  final Color accent;
  final VoidCallback? onTap;
  final Duration animationDelay;

  @override
  Widget build(BuildContext context) {
    final card = NxCard(
      hoverable: true,
      borderColor: accent.withValues(alpha: 0.35),
      glowColor: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 8),
          // FittedBox para que el valor numérico nunca desborde
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );

    return NxPressable(onTap: onTap, child: card)
        .animate(delay: animationDelay)
        .fadeIn(duration: 320.ms)
        .slideY(begin: 0.04, duration: 320.ms, curve: Curves.easeOut);
  }
}

// ─── NxMetricGrid ────────────────────────────────────────────────────────────
// Envuelve los tiles en un Wrap adaptativo (no GridView) para que en móvil
// cada tile ocupe el 50% del ancho y en desktop se distribuyan en 4 columnas.
class NxMetricGrid extends StatelessWidget {
  const NxMetricGrid({super.key, required this.tiles});
  final List<NxMetricTile> tiles;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final spacing = isMobile ? 10.0 : 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Móvil → 2 columnas; tablet → 2; desktop → 4
        final cols = isMobile ? 2 : (constraints.maxWidth >= 900 ? 4 : 2);
        final tileWidth =
            (constraints.maxWidth - (spacing * (cols - 1))) / cols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < tiles.length; i++)
              SizedBox(
                width: tileWidth,
                // Altura fija para consistencia visual; se adapta a móvil
                height: isMobile ? 88 : 96,
                child: tiles[i],
              ),
          ],
        );
      },
    );
  }
}

// ─── NxScreenLoading ─────────────────────────────────────────────────────────
class NxScreenLoading extends StatelessWidget {
  const NxScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(60),
        child: CircularProgressIndicator(
          color: AppColors.cyan,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

// ─── NxScreenError ───────────────────────────────────────────────────────────
class NxScreenError extends StatelessWidget {
  const NxScreenError({
    super.key,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 40, color: AppColors.rose),
            const SizedBox(height: 16),
            Text(
              message,
              style:
                  const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}