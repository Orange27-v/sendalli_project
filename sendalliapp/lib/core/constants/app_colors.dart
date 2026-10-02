import 'package:flutter/material.dart';

/// Centralized color palette for the Sendalli application.
/// Designed for high legibility under bright Nigerian road conditions.
class AppColors {
  AppColors._();

  // Primary brand colors (Default Sendalli Vibrant Lime #A6EB2E)
  static const Color primary = Color(0xFFA6EB2E);
  static const Color primaryDark = Color(0xFF6E9E1E);
  static const Color primaryLight = Color(0xFFF1FCD6);
  static const Color primaryAccent = Color(0xFFB8F547);

  // Default brand colors standardized to default Sendalli palette (avoiding deep green)
  static const Color brandGreen = Color(0xFFA6EB2E);
  static const Color brandGreenDark = Color(0xFF6E9E1E);
  static const Color brandGreenLight = Color(0xFFF1FCD6);

  // Neutral background & surface colors (Nelo clean spec: kGrey100 & kGrey200)
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color surfaceSubtle = Color(0xFFEEEEEE);

  // Typography & text hierarchy
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textInverse = Colors.white;

  // Borders & Dividers
  static const Color border = Color(0xFFEEEEEE);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color borderFocus = Color(0xFFA6EB2E);

  // Status & Gamification Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Trust Score Badges
  static const Color eliteGold = Color(0xFFD97706);
  static const Color eliteGoldLight = Color(0xFFFEF3C7);
  static const Color standardBlue = Color(0xFF2563EB);
  static const Color standardBlueLight = Color(0xFFDBEAFE);
}
