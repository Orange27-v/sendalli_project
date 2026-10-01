import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../dashboard/screens/receiver_home_screen.dart';
import 'role_gateway_screen.dart';
import 'track_parcel_screen.dart';
import 'onboarding_walkthrough_screen.dart';
import 'phone_input_screen.dart';

/// Clean, spacious, and uncluttered Welcome Screen.
/// Highlights:
/// 1. Vibrant logistics.svg hero graphic.
/// 2. Outside receiver access (zero account required).
/// 3. Navigation to dedicated Role Gateway Screen for spread-out role selection.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ==========================================
            // TOP GREEN HERO SECTION (matching Screen 3 of design guide)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                children: [
                  // App Brand Title & Subtitle in White
                  Text(
                    'SENDALLI',
                    style: AppTextStyles.h1.copyWith(
                      letterSpacing: 2.2,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Corridor Parcel Logistics • Warri & Effurun',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Hero Graphic in soft circle
                  Container(
                    width: 140,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/logistics.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Punchy Value Prop Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Move items rapidly across transit routes in 10 minutes',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ==========================================
            // BOTTOM WHITE CURVED SHEET (matching Screen 3 of design guide)
            // ==========================================
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 18.0),
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
                        const SizedBox(height: 16),

                        // Section 1: Outside Receiver Entrance (No Login)
                        _buildReceiverCard(context),
                        const SizedBox(height: 18),

                        // Section 2: Operator Network & Actions
                        _buildOperatorSection(context),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Clean, spacious receiver entry card
  Widget _buildReceiverCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandGreenLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.brandGreen.withValues(alpha: 0.35), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.brandGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  FeatherIcons.package,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Receiving a Parcel?',
                          style: AppTextStyles.h2.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.brandGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NO LOGIN',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Track live ETA and get your pickup release code.',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TrackParcelScreen()),
                    );
                  },
                  icon: const Icon(FeatherIcons.search, size: 15),
                  label: const Text('Track by ID'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: AppTextStyles.button.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReceiverHomeScreen(
                          user: UserProfile.guestReceiver(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(FeatherIcons.mapPin, size: 15),
                  label: const Text('Receiver Portal'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(color: AppColors.brandGreen, width: 1.2),
                    textStyle: AppTextStyles.button.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brandGreenDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Clean operator access navigating to dedicated RoleGatewayScreen
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
                'OPERATORS: SENDERS • RIDERS • HUBS',
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
        const SizedBox(height: 16),

        // Primary action to navigate to spread-out Role Gateway Screen (Vibrant Green)
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RoleGatewayScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: AppColors.brandGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose Role to Enter',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              SizedBox(width: 8),
              Icon(FeatherIcons.arrowRight, size: 17),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Direct returning operator sign-in button
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PhoneInputScreen(isReturningLogin: true),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: AppColors.borderMedium, width: 1.2),
          ),
          child: const Text('Operator Sign In • Phone & PIN'),
        ),
        const SizedBox(height: 16),

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
              'How Sendalli Works • Explore 4 Corridors',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
