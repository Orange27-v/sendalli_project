import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/storage/session_manager.dart';
import '../../onboarding/screens/welcome_screen.dart';
import '../../../widgets/guest_tracking_sheet.dart';

/// Full-featured Receiver Home Dashboard for recipients.
class ReceiverHomeScreen extends StatefulWidget {
  final UserProfile user;

  const ReceiverHomeScreen({super.key, required this.user});

  @override
  State<ReceiverHomeScreen> createState() => _ReceiverHomeScreenState();
}

class _ReceiverHomeScreenState extends State<ReceiverHomeScreen> {
  final String _mockTrackingId = 'SND-WAR-8492';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receiver Dashboard', style: AppTextStyles.h3),
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
            // User Greeting Header
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
                    child: Text(
                      widget.user.firstName.isNotEmpty ? widget.user.firstName[0] : 'R',
                      style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back,', style: AppTextStyles.caption),
                        Text(widget.user.fullName, style: AppTextStyles.h3),
                        Text(widget.user.phone, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Receiver',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Track another parcel CTA
            OutlinedButton.icon(
              onPressed: () => GuestTrackingSheet.show(context),
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
              label: const Text('Track Another Tracking ID'),
            ),
            const SizedBox(height: 28),

            // Active Incoming Package Banner
            Text('Active Incoming Parcel', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_mockTrackingId, style: AppTextStyles.h3.copyWith(color: AppColors.primaryDark)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'IN TRANSIT',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Estimated Arrival: In ~12 mins',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Roadside Stop: ${widget.user.landmark ?? "Jakpa Junction"}',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 20),

                  // 6-digit release code container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Text('6-DIGIT RELEASE CODE', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(
                          '849 201',
                          style: AppTextStyles.h1.copyWith(
                            letterSpacing: 6,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Read this to the rider at the roadside stop.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Driver Details & Call
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.surfaceSubtle,
                        child: Icon(Icons.person, color: AppColors.primaryDark, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Diran Olakunle (Keke)', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            Text('Plate: WRA-492-XA • Score: 94%', style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calling rider: +234 803 000 1234')),
                          );
                        },
                        icon: const Icon(Icons.phone_rounded, color: AppColors.textPrimary, size: 20),
                        style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Drop Hub Diversion Helper
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.storefront_outlined, color: AppColors.textSecondary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cannot meet the keke rider?', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(
                          'Riders can divert your parcel to a nearby partner Drop Hub for ₦500 pickup anytime.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
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
