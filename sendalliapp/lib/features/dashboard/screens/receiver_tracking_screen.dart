import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/storage/session_manager.dart';

/// Friction-free guest tracking screen for parcel recipients.
class ReceiverTrackingScreen extends StatelessWidget {
  final String trackingId;

  const ReceiverTrackingScreen({super.key, required this.trackingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Parcel Tracker', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(FeatherIcons.x, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await SessionManager.clearTrackingId();
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            child: Text(
              'Exit',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tracking Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tracking ID', style: AppTextStyles.caption),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'IN TRANSIT',
                          style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(trackingId, style: AppTextStyles.h2.copyWith(color: AppColors.primaryDark)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(FeatherIcons.clock, size: 16, color: AppColors.primaryDark),
                      const SizedBox(width: 8),
                      Text(
                        'Estimated Arrival: In ~12 mins',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Drop Point: Jakpa Junction (Roadside Stop)',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6-Digit Release Code Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'YOUR 6-DIGIT RELEASE CODE',
                    style: AppTextStyles.caption.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '849 201',
                      style: AppTextStyles.h1.copyWith(
                        letterSpacing: 6,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Read this code to the keke rider upon roadside handover to receive your parcel.',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Rider Contact Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surfaceSubtle,
                    child: Icon(FeatherIcons.user, color: AppColors.textPrimary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Diran Olakunle', style: AppTextStyles.h3),
                        Text('Tricycle Plate: WRA-492-XA', style: AppTextStyles.bodySmall),
                        Row(
                          children: [
                            const Icon(FeatherIcons.shield, size: 14, color: AppColors.eliteGold),
                            const SizedBox(width: 4),
                            Text('Trust Score: 94%', style: AppTextStyles.caption.copyWith(color: AppColors.eliteGold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling rider: +234 803 000 1234')),
                      );
                    },
                    icon: const Icon(FeatherIcons.phone, color: AppColors.textPrimary, size: 18),
                    style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
