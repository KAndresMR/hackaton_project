// lib/frontend/widgets/nx_pressable.dart
//
// Wrapper que añade animación de escala al presionar.
// Úsalo envolviendo cualquier widget que quieras hacer "tappable":
//
//   NxPressable(
//     onTap: () => ...,
//     child: NxCard(child: ...),
//   )
//
// Parámetros de escala:
//   pressScale  → qué tanto se encoge al presionar  (default 0.96)
//   duration    → duración de la animación           (default 130ms)
// ─────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

class NxPressable extends StatefulWidget {
  const NxPressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressScale = 0.96,
    this.duration = const Duration(milliseconds: 130),
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressScale;
  final Duration duration;
  final Curve curve;

  @override
  State<NxPressable> createState() => _NxPressableState();
}

class _NxPressableState extends State<NxPressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: 1.0, end: widget.pressScale).animate(
      CurvedAnimation(parent: _ctrl, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _ctrl.forward();

  void _onTapUp(TapUpDetails _) {
    _ctrl.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}