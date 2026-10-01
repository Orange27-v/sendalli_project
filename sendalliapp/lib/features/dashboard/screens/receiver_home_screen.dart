import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/storage/session_manager.dart';
import '../../onboarding/screens/welcome_screen.dart';
import '../../../widgets/guest_tracking_sheet.dart';
import '../../../widgets/settings_kit.dart';
import '../../../widgets/content_card.dart';

/// Full-featured Receiver Home Dashboard using Nelo specs & Feather icons.
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Receiver Dashboard',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.logOut, size: 20, color: AppColors.textSecondary),
            tooltip: 'Log out',
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card (Nelo pattern)
            ProfileHeaderCard(
              name: widget.user.fullName,
              subtitle: '${widget.user.phone} • ${widget.user.corridor ?? "Warri Route"}',
              roleBadgeText: 'Receiver',
              accent: AppColors.primaryDark,
              initial: widget.user.firstName.isNotEmpty ? widget.user.firstName[0] : 'R',
              isVerified: widget.user.isVerified,
            ),
            const SizedBox(height: 16),

            // Track Another Parcel Fast Action
            OutlinedButton.icon(
              onPressed: () => GuestTrackingSheet.show(context),
              icon: const Icon(FeatherIcons.search, size: 18),
              label: const Text('Track Another Tracking ID'),
            ),
            const SizedBox(height: 24),

            // Active Incoming Parcel using ContentCard
            ContentCard(
              title: 'Active Incoming Parcel',
              badgeCount: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _mockTrackingId,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 19,
                        ),
                      ),
                      const StatusBadge(
                        text: 'IN TRANSIT',
                        color: AppColors.textPrimary,
                        backgroundColor: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ETA Tile
                  Row(
                    children: [
                      const Icon(FeatherIcons.clock, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Estimated Arrival: In ~12 mins',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(FeatherIcons.mapPin, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Roadside Stop: ${widget.user.landmark ?? "Jakpa Junction"}',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 6-digit release code container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '6-DIGIT RELEASE CODE',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '849 201',
                          style: AppTextStyles.displayLarge.copyWith(
                            fontSize: 30,
                            letterSpacing: 6,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Read this code to the keke rider at the roadside stop.',
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Driver Details & 1-tap call
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FeatherIcons.user, color: AppColors.primaryDark, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diran Olakunle (Keke)',
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Plate: WRA-492-XA • Score: 94%',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calling rider: +234 803 000 1234')),
                          );
                        },
                        icon: const Icon(FeatherIcons.phone, color: AppColors.textPrimary, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Drop Hub Diversion Helper (Nelo SettingsGroup)
            SettingsGroup(
              label: 'Cannot meet the rider?',
              children: [
                SettingsRow(
                  icon: FeatherIcons.home,
                  title: 'Divert to Partner Drop Hub',
                  subtitle: 'Store package at a nearby chemist/shop for ₦500 pickup.',
                  accent: AppColors.primaryDark,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rider notified to divert parcel to nearest partner Hub.')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
