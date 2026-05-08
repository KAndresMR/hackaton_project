import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Backgrounds ─────────────────────────────────────────
  static const Color bgBase = Color(0xFF07090F); // deepest dark
  static const Color bgSurface = Color(0xFF0D1017); // card bg
  static const Color bgElevated = Color(0xFF131925); // elevated card
  static const Color bgOverlay = Color(0xFF1A2235); // hover / overlay

  // ── Borders ──────────────────────────────────────────────
  static const Color borderSubtle = Color(0xFF1E2A3A);
  static const Color borderDefault = Color(0xFF253347);
  static const Color borderActive = Color(0xFF2E4060);

  // ── Accent: Cyan ─────────────────────────────────────────
  static const Color cyan = Color(0xFF00D9FF);
  static const Color cyanDim = Color(0xFF0099BB);
  static const Color cyanGlow = Color(0x2200D9FF);
  static const Color cyanMuted = Color(0xFF003D4D);

  // ── Accent: Violet ───────────────────────────────────────
  static const Color violet = Color(0xFF7B61FF);
  static const Color violetDim = Color(0xFF5542CC);
  static const Color violetGlow = Color(0x337B61FF);
  static const Color violetMuted = Color(0xFF1E1A40);

  // ── Accent: Emerald (success) ────────────────────────────
  static const Color emerald = Color(0xFF00E5A0);
  static const Color emeraldGlow = Color(0x2200E5A0);
  static const Color emeraldMuted = Color(0xFF003D2A);

  // ── Accent: Amber (warning) ──────────────────────────────
  static const Color amber = Color(0xFFFFAA00);
  static const Color amberGlow = Color(0x22FFAA00);

  // ── Accent: Rose (danger) ────────────────────────────────
  static const Color rose = Color(0xFFFF4D6A);
  static const Color roseGlow = Color(0x22FF4D6A);

  // ── Text ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8899BB);
  static const Color textTertiary = Color(0xFF4A5A78);
  static const Color textDisabled = Color(0xFF2A3548);

  // ── Gradients ────────────────────────────────────────────
  static const LinearGradient cyanVioletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cyan, violet],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF131925), Color(0xFF0D1017)],
  );

  static const LinearGradient balanceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.6, 1.0],
    colors: [Color(0xFF1A2235), Color(0xFF0F1820), Color(0xFF07090F)],
  );
}