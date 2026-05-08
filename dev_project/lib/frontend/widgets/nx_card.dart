import 'package:credynox/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
  });

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

  @override
  State<NxCard> createState() => _NxCardState();
}

class _NxCardState extends State<NxCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? 16.0;
    final hovered = _hovered && widget.hoverable;

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
                  color: widget.glowColor!.withValues(alpha: hovered ? 0.15 : 0.08),
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
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(20),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

// ── NxCardHeader – standardized card top row ──────────────────────────────
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
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.cyan).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (iconColor ?? AppColors.cyan).withValues(alpha: 0.2),
              ),
            ),
            child: Icon(icon, size: 17, color: iconColor ?? AppColors.cyan),
          ),
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
                    _Badge(label: badge!),
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

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.emeraldMuted,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: AppColors.emerald,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── NxDivider ────────────────────────────────────────────────────────────────
class NxDivider extends StatelessWidget {
  const NxDivider({super.key, this.height = 1});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: AppColors.borderSubtle,
    );
  }
}