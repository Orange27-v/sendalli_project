import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_text_styles.dart';

// ============================================================================
// THEME COLOR PALETTE
// Defined directly in this file for easy, centralized color customization.
// Edit any color value below to instantly update the entire application.
// ============================================================================
class AppColors {
  AppColors._();

  // --- Dominant Theme: Black & White ---
  static const Color primary = Color(0xFF0F172A); // Dominant rich dark slate / black
  static const Color primaryDark = Color(0xFF020617); // Deep pure black
  static const Color primaryLight = Color(0xFFF1F5F9); // Crisp neutral light slate
  static const Color primaryAccent = Color(0xFF1E293B);

  // --- Non-Dominant Accent: Deep Green ---
  // Used strictly for subtle badges, active dots, verified status, focus rings
  static const Color deepGreen = Color(0xFF14532D); // Classic Nigerian deep forest / emerald green
  static const Color deepGreenLight = Color(0xFFDCFCE7); // Soft mint/sage tint for chips and badges
  static const Color deepGreenMuted = Color(0xFF166534); // Supporting deep green

  // Standardized green aliases for backwards compatibility
  static const Color brandGreen = deepGreen;
  static const Color brandGreenDark = deepGreenMuted;
  static const Color brandGreenLight = deepGreenLight;

  // --- Neutral Canvas & Surfaces ---
  static const Color background = Color(0xFFF8FAFC); // Clean off-white canvas
  static const Color surface = Colors.white; // Crisp pure white
  static const Color surfaceSubtle = Color(0xFFF1F5F9); // Light neutral container fill

  // --- Typography & Text Hierarchy ---
  static const Color textPrimary = Color(0xFF0F172A); // High-contrast dark slate / black
  static const Color textSecondary = Color(0xFF475569); // Slate body
  static const Color textMuted = Color(0xFF94A3B8); // Muted captions & hints
  static const Color textInverse = Colors.white; // Pure white text

  // --- Borders & Dividers ---
  static const Color border = Color(0xFFE2E8F0); // Subtle divider / card border
  static const Color borderMedium = Color(0xFFCBD5E1); // Input field border
  static const Color borderFocus = Color(0xFF14532D); // Deep green subtle focus ring

  // --- Status & Feedback Colors ---
  static const Color success = Color(0xFF15803D); // Deep green success
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // --- Trust Score & Rating Badges ---
  static const Color eliteGold = Color(0xFFD97706);
  static const Color eliteGoldLight = Color(0xFFFEF3C7);
  static const Color standardBlue = Color(0xFF2563EB);
  static const Color standardBlueLight = Color(0xFFDBEAFE);
}

/// App theme configurations applying clean, quiet, and minimal design specs.
class AppTheme {
  AppTheme._();

  // Direct convenience aliases to theme colors
  static const Color primaryColor = AppColors.primary;
  static const Color deepGreen = AppColors.deepGreen;
  static const Color deepGreenLight = AppColors.deepGreenLight;
  static const Color backgroundColor = AppColors.background;
  static const Color surfaceColor = AppColors.surface;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;

  static TextTheme _buildTextTheme(TextTheme base, Color color) {
    final fontTheme = GoogleFonts.urbanistTextTheme(base);
    return fontTheme.copyWith(
      displayLarge: fontTheme.displayLarge?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: -0.5,
      ),
      headlineLarge: fontTheme.headlineLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      headlineSmall: fontTheme.headlineSmall?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      titleLarge: fontTheme.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      bodyLarge: fontTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: color,
        height: 1.45,
      ),
      bodyMedium: fontTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.45,
      ),
      labelLarge: fontTheme.labelLarge?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      labelSmall: fontTheme.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: AppColors.textInverse,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        secondary: AppColors.deepGreen,
        onSecondary: AppColors.textInverse,
        outlineVariant: AppColors.border,
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme, AppColors.textPrimary),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        shape: CircleBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.12),
          disabledForegroundColor: AppColors.textMuted,
          minimumSize: const Size.fromHeight(48),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button.copyWith(
            color: AppColors.textInverse,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(48),
          elevation: 0,
          side: const BorderSide(color: AppColors.borderMedium, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.deepGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        space: 1,
        thickness: 1,
      ),
    );
  }
}
