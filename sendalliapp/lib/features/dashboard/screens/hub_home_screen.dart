import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/storage/session_manager.dart';
import '../../onboarding/screens/welcome_screen.dart';

/// Hub Operator Home Dashboard (Custody management & ₦500 custody fee tracking).
class HubHomeScreen extends StatelessWidget {
  final UserProfile user;

  const HubHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drop Hub Custody', style: AppTextStyles.h3),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
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
      body: SingleChildScrollView(
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
                    child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 28),
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
              icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
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
                    const Icon(Icons.inventory_2_outlined, size: 44, color: AppColors.textMuted),
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
    );
  }
}
