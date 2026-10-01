import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../widgets/guest_tracking_sheet.dart';
import 'name_input_screen.dart';
import 'phone_input_screen.dart';

/// The visual Welcome & Splash Gateway Screen (Onboarding.png).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Brand mark & hero banner
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.electric_rickshaw_rounded,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'SENDALLI',
                style: AppTextStyles.h1.copyWith(
                  letterSpacing: 2,
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Corridor Parcel Logistics',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Send or carry packages across Warri & Effurun along existing keke routes without detours.',
                  style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 2),

              // Primary Actions
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NameInputScreen()),
                  );
                },
                child: const Text('Get Started'),
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
                child: const Text('I already have an account • Log In'),
              ),
              const SizedBox(height: 20),

              // Guest Fast-Track Action
              InkWell(
                onTap: () => GuestTrackingSheet.show(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.qr_code_scanner, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Have a Tracking ID? Track here',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
