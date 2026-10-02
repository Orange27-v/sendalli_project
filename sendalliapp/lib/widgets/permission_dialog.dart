import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

/// Reusable contextual permission dialog matching Modal - Location designs.
class PermissionDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String primaryButtonText;
  final VoidCallback onAllow;
  final VoidCallback? onSkip;

  const PermissionDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.onAllow,
    this.onSkip,
  });

  static Future<bool?> show({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required String primaryButtonText,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PermissionDialog(
        icon: icon,
        title: title,
        description: description,
        primaryButtonText: primaryButtonText,
        onAllow: () => Navigator.of(ctx).pop(true),
        onSkip: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.of(context).pop(false);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: onAllow,
                child: Text(primaryButtonText),
              ),
              if (onSkip != null) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Maybe Later',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
