import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_text_styles.dart';

// ============================================================================
// DESIGN TOKENS — Centralized dimensions for easy global tuning.
// Change any value here to instantly update the entire app.
// ============================================================================
class AppDimens {
  AppDimens._();

  // --- Corner Radius ---
  static const double radiusSmall = 4.0;   // Badges, tags, tiny chips
  static const double radius = 12.0;        // Default: cards, inputs, dialogs
  static const double radiusLarge = 12.0;   // Sheets, modals (same as default for flat look)
  static const double radiusButton = 28.0;  // Pill rounded buttons matching brand spec (button.png)
  static const double radiusPill = 28.0;    // Full pill / stadium radius

  // --- Border Width ---
  static const double borderWidth = 0.5;       // Hairline card/container borders
  static const double borderWidthMedium = 1.0; // Input fields, focused outlines
  static const double borderWidthThick = 1.5;  // Active/focus accent outlines

  // --- Screen Padding (distance from phone edge to content) ---
  static const double screenPaddingH = 14.0;  // Horizontal margin from device edge
  static const double screenPaddingV = 12.0;  // Vertical margin from top/bottom

  // --- Card / Container Inner Padding ---
  static const double cardPadding = 14.0;     // Default inner padding for cards
  static const double cardPaddingLarge = 18.0; // Larger cards, feature panels

  // --- Reusable EdgeInsets shortcuts ---
  static const EdgeInsets screenInsets = EdgeInsets.symmetric(
    horizontal: screenPaddingH,
    vertical: screenPaddingV,
  );

  static const EdgeInsets screenInsetsH = EdgeInsets.symmetric(
    horizontal: screenPaddingH,
  );
}

// ============================================================================
// THEME COLOR PALETTE
// Defined directly in this file for easy, centralized color customization.
// Edit any color value below to instantly update the entire application.
// ============================================================================
class AppColors {
  AppColors._();

  // --- Dominant Theme Brand Color: Vibrant Green (#009944) ---
  // Canonical brand primary color as specified in the reference design
  static const Color primary = Color(0xFF009944); // Dominant brand green (#009944)
  static const Color primaryDark = Color(0xFF007A37); // Deep shade for pressed states & borders
  static const Color primaryLight = Color(0xFFE6F5EC); // Crisp soft emerald tint
  static const Color primaryAccent = Color(0xFF00B350); // Vibrant highlight green

  // Standardized green aliases for backwards compatibility
  static const Color deepGreen = primary;
  static const Color deepGreenLight = primaryLight;
  static const Color deepGreenMuted = primaryDark;
  static const Color sageAccent = primary;
  static const Color sageLight = primaryLight;
  static const Color sageMuted = primaryDark;
  static const Color brandGreen = primary;
  static const Color brandGreenDark = primaryDark;
  static const Color brandGreenLight = primaryLight;

  // --- Signature Green Gradient Fades (#009944) ---
  // Soft, airy top & bottom vignette fade as seen in the onboarding design
  static const LinearGradient screenGradientFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x38009944), // ~22% opacity soft green at top edge
      Color(0x0F009944), // ~6% opacity transition
      Colors.white,      // Pure crisp white in center focus area
      Colors.white,      // Pure crisp white
      Color(0x0F009944), // ~6% opacity transition
      Color(0x3D009944), // ~24% opacity soft green at bottom edge
    ],
    stops: [0.0, 0.20, 0.40, 0.65, 0.85, 1.0],
  );

  // Soft top fade only (e.g. for hero backgrounds)
  static const LinearGradient topFadeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x2E009944), // ~18% soft green fade
      Color(0x08009944),
      Colors.white,
    ],
    stops: [0.0, 0.50, 1.0],
  );

  // Soft bottom fade only
  static const LinearGradient bottomFadeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Color(0x08009944),
      Color(0x33009944), // ~20% soft green fade
    ],
    stops: [0.0, 0.50, 1.0],
  );

  // --- Neutral Canvas & Surfaces ---
  static const Color background = Color(0xFFF8FAFC); // Clean off-white canvas
  static const Color surface = Colors.white; // Crisp pure white
  static const Color surfaceSubtle = Color(0xFFF1F5F9); // Light neutral container fill

  // --- Typography & Text Hierarchy ---
  static const Color textPrimary = Color(0xFF0F172A); // High-contrast dark slate / black
  static const Color textSecondary = Color(0xFF475569); // Slate body
  static const Color textMuted = Color(0xFF94A3B8); // Muted captions & hints
  static const Color textInverse = Colors.white; // Pure white text
  static const Color textSage = Color(0xFF009944); // Headline accent text in #009944

  // --- Borders & Dividers ---
  static const Color border = Color(0xFFE2E8F0); // Subtle divider / card border
  static const Color borderMedium = Color(0xFFCBD5E1); // Input field border
  static const Color borderFocus = Color(0xFF009944); // #009944 subtle focus ring

  /// Convenience: default hairline border used on most containers.
  static BorderSide get hairlineBorder =>
      BorderSide(color: border, width: AppDimens.borderWidth);

  /// Convenience: medium-weight border for inputs.
  static BorderSide get mediumBorder =>
      BorderSide(color: borderMedium, width: AppDimens.borderWidthMedium);

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
  static const Color sageAccent = AppColors.sageAccent;
  static const Color sageLight = AppColors.sageLight;
  static const Color backgroundColor = AppColors.background;
  static const Color surfaceColor = AppColors.surface;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;

  // Signature gradient fade aliases
  static const LinearGradient screenGradientFade = AppColors.screenGradientFade;
  static const LinearGradient topFadeGradient = AppColors.topFadeGradient;
  static const LinearGradient bottomFadeGradient = AppColors.bottomFadeGradient;

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
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textInverse),
        actionsIconTheme: const IconThemeData(color: AppColors.textInverse),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textInverse,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // Android: white status bar icons on green
          statusBarBrightness: Brightness.dark,      // iOS: white status bar icons on green
        ),
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
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
          disabledForegroundColor: AppColors.textInverse.withValues(alpha: 0.65),
          minimumSize: const Size.fromHeight(50),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusButton),
          ),
          textStyle: AppTextStyles.button.copyWith(
            color: AppColors.textInverse,
            fontWeight: FontWeight.w700,
            fontSize: 16,
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
            borderRadius: BorderRadius.circular(AppDimens.radiusButton),
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
          borderRadius: BorderRadius.circular(AppDimens.radius),
          borderSide: BorderSide(color: AppColors.border, width: AppDimens.borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          borderSide: BorderSide(color: AppColors.border, width: AppDimens.borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          borderSide: BorderSide(color: AppColors.deepGreen, width: AppDimens.borderWidthThick),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          borderSide: BorderSide(color: AppColors.danger, width: AppDimens.borderWidthMedium),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          side: BorderSide(color: AppColors.border, width: AppDimens.borderWidth),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.border,
        space: 1,
        thickness: AppDimens.borderWidth,
      ),
    );
  }
}
