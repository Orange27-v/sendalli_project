import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../dashboard/screens/receiver/receiver_home_screen.dart';
import 'role_gateway_screen.dart';
import 'track_parcel_screen.dart';
import 'onboarding_walkthrough_screen.dart';
import 'terms_and_conditions_screen.dart';

/// Clean, spacious, and uncluttered Welcome Screen.
/// Highlights:
/// 1. Vibrant logistics.svg hero graphic.
/// 2. Outside receiver access (zero account required).
/// 3. Navigation to dedicated Role Gateway Screen for spread-out role selection.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
          children: [
            // ==========================================
            // TOP HERO SECTION (Spacious upper half matching design guide)
            // ==========================================
            Expanded(
              flex: 48,
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Brand Title & Subtitle in dark slate text
                      Text(
                        'SENDALLI',
                        style: AppTextStyles.h1.copyWith(
                          letterSpacing: 2.2,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Local Parcel Delivery • Warri & Effurun',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),

                      // Hero Graphic in clean white container
                      Container(
                        width: 156,
                        height: 124,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border, width: 1.0),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg/logistics.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Punchy Value Prop Badge with subtle deep green accent
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.deepGreenLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.deepGreen.withValues(alpha: 0.25), width: 1.0),
                        ),
                        child: Text(
                          'Send items across town in 10 minutes',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.deepGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==========================================
            // BOTTOM WHITE CURVED SHEET (Reduced height downwards)
            // ==========================================
            Expanded(
              flex: 52,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subtle drag handle bar
                        Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Operator Actions with Receiver Text Buttons under Get Started
                        _buildOperatorSection(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
  }

  /// Clean operator access with Receiver Text Buttons positioned under Get Started
  Widget _buildOperatorSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.border, height: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'FOR: SENDERS • RIDERS • HUBS',
                style: AppTextStyles.caption.copyWith(
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.border, height: 1)),
          ],
        ),
        const SizedBox(height: 14),

        // Primary action to navigate to spread-out Role Gateway Screen (Solid Black)
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RoleGatewayScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textInverse,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get Started',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textInverse),
              ),
              SizedBox(width: 8),
              Icon(FeatherIcons.arrowRight, size: 17, color: AppColors.textInverse),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Direct returning operator sign-in button navigating to RoleGatewayScreen
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RoleGatewayScreen(),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            side: const BorderSide(color: AppColors.borderMedium, width: 1.2),
            foregroundColor: AppColors.textPrimary,
          ),
          child: const Text('Already have an account? Sign In'),
        ),
        const SizedBox(height: 14),

        // Clean Receiver Text Buttons under Get Started
        _buildReceiverSection(context),
        const SizedBox(height: 14),

        // Link to separate 4-context walkthrough
        Center(
          child: TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OnboardingWalkthroughScreen()),
              );
            },
            icon: const Icon(FeatherIcons.compass, size: 14, color: AppColors.textSecondary),
            label: Text(
              'How Sendalli Works',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const TermsAndConditionsScreen(isViewOnly: true),
                ),
              );
            },
            child: Text(
              'Terms of Service & Corridor Agreement',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                color: AppColors.textMuted,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Sleek, minimal outside receiver access as clean text buttons under Get Started
  Widget _buildReceiverSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Receiving a Parcel?',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TrackParcelScreen()),
                    );
                  },
                  icon: const Icon(FeatherIcons.search, size: 13, color: AppColors.textPrimary),
                  label: const Text('Track by ID'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Container(
                  width: 1,
                  height: 12,
                  color: AppColors.borderMedium,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReceiverHomeScreen(
                          user: UserProfile.guestReceiver(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(FeatherIcons.mapPin, size: 13, color: AppColors.textPrimary),
                  label: const Text('My Parcels'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
