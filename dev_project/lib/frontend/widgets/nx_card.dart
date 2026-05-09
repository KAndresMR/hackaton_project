import 'package:credynox/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NxCard
//
// Uso habitual (contenido fijo, tamaño conocido):
//   NxCard(child: Text('hello'))
//
// Cuando el contenido puede ser más alto que la pantalla (ej: ConnectBankScreen)
// usa NxCard.scroll() — agrega internamente un SingleChildScrollView:
//   NxCard.scroll(child: Column(...grande...))
//
// hoverable: mueve el borde y el glow al hacer hover (desktop/web).
// ─────────────────────────────────────────────────────────────────────────────
class NxCard extends StatefulWidget {
  const NxCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.borderColor,
    this.glowColor,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.hoverable = false,
    bool scrollable = false,
  }) : _scrollable = scrollable;

  /// Constructor named para contenido que puede desbordarse verticalmente.
  /// Ideal para pantallas móviles con mucho contenido.
  const NxCard.scroll({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Gradient? gradient,
    Color? borderColor,
    Color? glowColor,
    VoidCallback? onTap,
    double? width,
    double? height,
    double? borderRadius,
    bool hoverable = false,
  }) : this(
          key: key,
          child: child,
          padding: padding,
          gradient: gradient,
          borderColor: borderColor,
          glowColor: glowColor,
          onTap: onTap,
          width: width,
          height: height,
          borderRadius: borderRadius,
          hoverable: hoverable,
          scrollable: true,
        );

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? glowColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool hoverable;
  final bool _scrollable;

  @override
  State<NxCard> createState() => _NxCardState();
}

class _NxCardState extends State<NxCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? 16.0;
    final hovered = _hovered && widget.hoverable;

    // ── Contenido interno ──────────────────────────────────
    Widget content = Padding(
      padding: widget.padding ?? const EdgeInsets.all(20),
      child: widget.child,
    );

    // Si el card es scrollable, envolvemos en SingleChildScrollView.
    // Esto evita el RenderFlex overflow en móvil cuando el contenido
    // supera la altura disponible.
    if (widget._scrollable) {
      content = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    return MouseRegion(
      onEnter: widget.hoverable ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.hoverable ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.gradient ?? AppColors.cardGradient,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: hovered
                  ? (widget.borderColor ?? AppColors.borderActive)
                  : (widget.borderColor ?? AppColors.borderSubtle),
              width: 1,
            ),
            boxShadow: [
              if (widget.glowColor != null)
                BoxShadow(
                  color: widget.glowColor!
                      .withValues(alpha: hovered ? 0.15 : 0.08),
                  blurRadius: hovered ? 24 : 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: content,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NxCardHeader
// ─────────────────────────────────────────────────────────────────────────────
class NxCardHeader extends StatelessWidget {
  const NxCardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
    this.badge,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          NxIconBox(icon: icon!, color: iconColor ?? AppColors.cyan),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    NxBadge(label: badge!),
                  ],
                ],
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

// ── Icono cuadrado con fondo semitransparente ─────────────────────────────────
class NxIconBox extends StatelessWidget {
  const NxIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 34,
    this.iconSize = 17,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.29),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NxBadge – reutilizable fuera de NxCardHeader
// ─────────────────────────────────────────────────────────────────────────────
class NxBadge extends StatelessWidget {
  const NxBadge({
    super.key,
    required this.label,
    this.color = AppColors.emerald,
    this.bgColor = AppColors.emeraldMuted,
  });

  final String label;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NxDivider
// ─────────────────────────────────────────────────────────────────────────────
class NxDivider extends StatelessWidget {
  const NxDivider({super.key, this.height = 1});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(height: height, color: AppColors.borderSubtle);
  }
}
