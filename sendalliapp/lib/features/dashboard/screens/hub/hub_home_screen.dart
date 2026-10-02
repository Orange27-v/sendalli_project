import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/storage/session_manager.dart';
import '../../../onboarding/screens/welcome_screen.dart';

/// Hub Operator Home Dashboard (Custody management & ₦500 custody fee tracking).
class HubHomeScreen extends StatelessWidget {
  final UserProfile user;

  const HubHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text('Drop Hub Custody', style: AppTextStyles.h3),
          actions: [
            IconButton(
              icon: const Icon(FeatherIcons.logOut, size: 20, color: AppColors.textSecondary),
              onPressed: () async {
                await SessionManager.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primary,
                    child: const Icon(FeatherIcons.home, color: AppColors.textInverse, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.shopName ?? 'Drop Hub Store', style: AppTextStyles.h3),
                        Text('Landmark: ${user.landmark ?? "Near PTI Junction"}', style: AppTextStyles.bodySmall),
                        Text('₦500 custody credit per package', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera QR scanner will open to accept package into custody.')),
                );
              },
              icon: const Icon(FeatherIcons.maximize, size: 18, color: AppColors.textInverse),
              label: const Text('Scan Package Into Custody'),
            ),
            const SizedBox(height: 28),
            Text('Packages In Holding (0)', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(FeatherIcons.package, size: 40, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    Text('No parcels currently held in custody', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 4),
                    Text('When riders drop missed handoffs, they will appear here.', style: AppTextStyles.caption),
                  ],
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
}
