import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../widgets/guest_tracking_sheet.dart';
import '../../dashboard/screens/receiver_home_screen.dart';
import 'role_gateway_screen.dart';
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
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Hero Brand Illustration (logistics.svg in brand green)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SvgPicture.asset(
                    'assets/svg/logistics.svg',
                    height: 160,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Brand Title & Tagline
              Center(
                child: Column(
                  children: [
                    Text(
                      'SENDALLI',
                      style: AppTextStyles.h1.copyWith(
                        letterSpacing: 2,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Corridor Parcel Logistics • Warri & Effurun',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Move items rapidly across refinery, market, and estate routes using trusted local transit.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ==========================================
              // SECTION 1: OUTSIDE RECEIVER ENTRANCE (NO LOGIN)
              // ==========================================
              _buildReceiverCard(context),
              const SizedBox(height: 20),

              // ==========================================
              // SECTION 2: OPERATOR NETWORK (SPREAD OUT TO GATEWAY)
              // ==========================================
              _buildOperatorSection(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Clean, spacious receiver entry card
  Widget _buildReceiverCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderMedium, width: 1.2),
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
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SvgPicture.asset(
                  'assets/svg/delivery-location.svg',
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
                          style: AppTextStyles.h2.copyWith(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NO LOGIN',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => GuestTrackingSheet.show(context),
                  icon: const Icon(FeatherIcons.search, size: 15),
                  label: const Text('Track by ID'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: AppTextStyles.button.copyWith(fontSize: 13),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: const BorderSide(color: AppColors.borderMedium, width: 1.2),
                    textStyle: AppTextStyles.button.copyWith(fontSize: 13),
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
        const SizedBox(height: 18),

        // Primary action to navigate to spread-out Role Gateway Screen
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RoleGatewayScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: const BorderSide(color: AppColors.borderMedium, width: 1.2),
          ),
          child: const Text('Operator Sign In • Phone & PIN'),
        ),
      ],
    );
  }
}
