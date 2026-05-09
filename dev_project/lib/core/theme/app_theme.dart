import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.cyan,
        onPrimary: AppColors.bgBase,
        secondary: AppColors.violet,
        onSecondary: AppColors.textPrimary,
        tertiary: AppColors.emerald,
        surface: AppColors.bgSurface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.bgElevated,
        outline: AppColors.borderDefault,
        outlineVariant: AppColors.borderSubtle,
        error: AppColors.rose,
        onError: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.bgBase,
      textTheme: _buildTextTheme(),
      cardTheme: _buildCardTheme(),
      appBarTheme: _buildAppBarTheme(),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 20),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(style: _buildFilledButtonStyle()),
      outlinedButtonTheme:
          OutlinedButtonThemeData(style: _buildOutlinedButtonStyle()),
      inputDecorationTheme: _buildInputTheme(),
      // Premium enhancements
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      extensions: const [],
    );
  }

  // ── Text Theme ────────────────────────────────────────────
  static TextTheme _buildTextTheme() {
    // DM Sans for display / headings — geometric, premium
    // JetBrains Mono for numbers — fintech data feel
    final dmSans = GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme);

    return dmSans.copyWith(
      // Display — hero balance numbers
      displayLarge: GoogleFonts.dmSans(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        letterSpacing: -2.0,
        color: AppColors.textPrimary,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.dmSans(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: AppColors.textPrimary,
        height: 1.1,
      ),
      displaySmall: GoogleFonts.dmSans(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.0,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      // Headlines — section titles
      headlineLarge: GoogleFonts.dmSans(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      // Title — card titles
      titleLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textSecondary,
      ),
      // Body
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
      ),
      // Label — badges, tabs, buttons
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        color: AppColors.textTertiary,
      ),
    );
  }

  // ── Card Theme ────────────────────────────────────────────
  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: AppColors.bgSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
    );
  }

  // ── AppBar Theme ──────────────────────────────────────────
  static AppBarTheme _buildAppBarTheme() {
    return AppBarTheme(
      backgroundColor: AppColors.bgBase,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 22),
    );
  }

  // ── Button Styles ─────────────────────────────────────────
  static ButtonStyle _buildFilledButtonStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.cyan,
      foregroundColor: AppColors.bgBase,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }

  static ButtonStyle _buildOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.cyan,
      side: const BorderSide(color: AppColors.borderDefault, width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  // ── Input Theme ───────────────────────────────────────────
  static InputDecorationTheme _buildInputTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgElevated,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cyan, width: 1.5),
      ),
      hintStyle: GoogleFonts.dmSans(
        fontSize: 14,
        color: AppColors.textTertiary,
      ),
    );
  }
}