import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../onboarding/screens/welcome_screen.dart';
import '../../dashboard/screens/sender_home_screen.dart';
import '../../dashboard/screens/rider_home_screen.dart';
import '../../dashboard/screens/hub_home_screen.dart';
import '../../dashboard/screens/receiver_tracking_screen.dart';

/// Cold-start splash screen with automated session verification and routing.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    // 1-second cold-start delay for branding display & cache lookup
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    // 1. Check for logged in authenticated user
    final user = await SessionManager.getUserProfile();
    if (user != null) {
      Widget target;
      switch (user.role) {
        case UserRole.sender:
          target = SenderHomeScreen(user: user);
          break;
        case UserRole.rider:
          target = RiderHomeScreen(user: user);
          break;
        case UserRole.hub:
          target = HubHomeScreen(user: user);
          break;
        case UserRole.receiver:
          target = const WelcomeScreen();
          break;
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => target),
      );
      return;
    }

    // 2. Check for active guest parcel tracking session
    final trackingId = await SessionManager.getTrackingId();
    if (trackingId != null && trackingId.isNotEmpty) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ReceiverTrackingScreen(trackingId: trackingId),
        ),
      );
      return;
    }

    // 3. New user or logged out -> navigate to Welcome Gateway
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => const WelcomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.electric_rickshaw_rounded,
                  size: 56,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'SENDALLI',
                style: AppTextStyles.h1.copyWith(
                  letterSpacing: 3,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Transit-Logistics Network',
                style: AppTextStyles.bodySmall.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
