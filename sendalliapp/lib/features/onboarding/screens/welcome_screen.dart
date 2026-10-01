import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../widgets/guest_tracking_sheet.dart';
import '../../dashboard/screens/receiver_home_screen.dart';
import 'name_input_screen.dart';
import 'phone_input_screen.dart';

/// The visual Welcome & Splash Gateway Screen (Onboarding.png).
/// Receivers enter directly from here without any login barrier.
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
            children: [
              const SizedBox(height: 16),
              // Brand mark & hero banner
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  FeatherIcons.package,
                  size: 40,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 16),
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
                'Corridor Parcel Logistics',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Send or carry packages across Warri & Effurun along existing keke routes without detours.',
                  style: AppTextStyles.bodySmall.copyWith(height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),

              // Outside Receiver Entrance (No login required)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(FeatherIcons.package, size: 18, color: AppColors.primaryDark),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Receiving a Parcel?',
                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'No login needed • Track or pick up',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
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
                            onPressed: () => GuestTrackingSheet.show(context),
                            icon: const Icon(FeatherIcons.search, size: 15, color: AppColors.textPrimary),
                            label: const Text('Track by ID'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(42),
                              padding: EdgeInsets.zero,
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
                            icon: const Icon(FeatherIcons.mapPin, size: 15, color: AppColors.textPrimary),
                            label: const Text('Receiver Portal'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(42),
                              padding: EdgeInsets.zero,
                              textStyle: AppTextStyles.button.copyWith(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border, height: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'MERCHANTS & RIDERS',
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

              // Business / Operator Actions
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NameInputScreen()),
                  );
                },
                child: const Text('Register as Sender, Rider, or Hub'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  // Direct returning user login with Phone + PIN
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PhoneInputScreen(isReturningLogin: true),
                    ),
                  );
                },
                child: const Text('Operator Sign In • Phone & PIN'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
