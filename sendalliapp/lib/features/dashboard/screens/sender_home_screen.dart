import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/storage/session_manager.dart';
import '../../onboarding/screens/welcome_screen.dart';

/// Sender / Merchant Home Dashboard.
class SenderHomeScreen extends StatelessWidget {
  final UserProfile user;

  const SenderHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sendalli Merchant', style: AppTextStyles.h3),
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
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user.firstName.isNotEmpty ? user.firstName[0] : 'S',
                      style: AppTextStyles.h2.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back,', style: AppTextStyles.bodySmall),
                        Text(user.shopName ?? user.fullName, style: AppTextStyles.h3),
                        Text('Merchant • Corridor Active', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Send Parcel flow will open here.')),
                );
              },
              icon: const Icon(Icons.add_box_rounded, color: Colors.white),
              label: const Text('Send a New Parcel'),
            ),
            const SizedBox(height: 28),
            Text('Active Deliveries', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.local_shipping_outlined, size: 48, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    Text('No parcels currently in transit', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 4),
                    Text('Tap above to send along a keke corridor.', style: AppTextStyles.caption),
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
