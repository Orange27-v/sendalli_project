import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../features/onboarding/screens/welcome_screen.dart';

/// Centralized safe navigation utility.
/// Prevents routes from popping into an unrendered blank screen.
class AppNavigator {
  AppNavigator._();

  /// Safely pops the current screen if a previous route exists.
  /// If the current route is the root route, falls back to navigating to
  /// [fallbackScreen] (defaults to WelcomeScreen) with clean replacement.
  static void safePop(BuildContext context, {Widget fallbackScreen = const WelcomeScreen()}) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => fallbackScreen),
        (route) => false,
      );
    }
  }

  /// Safely resets navigation back to the Welcome Screen.
  static void returnToWelcome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  /// Cleanly minimizes or exits the application from the root screen
  /// without popping the Flutter view into a blank canvas.
  static void exitApp() {
    SystemNavigator.pop();
  }
}
