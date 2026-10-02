import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

/// Modal dialog displayed upon successful profile creation (Modal - Location-2.png).
class ProfileCompletedDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onContinue;

  const ProfileCompletedDialog({
    super.key,
    this.title = 'Profile Completed!',
    required this.subtitle,
    this.buttonText = 'Let\'s Go',
    required this.onContinue,
  });

  static Future<void> show({
    required BuildContext context,
    required String subtitle,
    required VoidCallback onContinue,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ProfileCompletedDialog(
        subtitle: subtitle,
        onContinue: () {
          Navigator.of(ctx).pop();
          onContinue();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.deepGreenLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FeatherIcons.checkCircle,
                  size: 40,
                  color: AppColors.deepGreen,
                ),
              ),
              const SizedBox(height: 20),
              Text(title, style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: onContinue,
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
