import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/models/user_role.dart';
import '../../../../core/storage/session_manager.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../onboarding/screens/welcome_screen.dart';

/// Classy, role-aware Profile screen for all Sendalli users.
/// Displays credentials, vehicle/store specifics, trust tier, and payout details.
class ProfileScreen extends StatelessWidget {
  final UserProfile user;

  const ProfileScreen({super.key, required this.user});

  String get _roleTitle {
    switch (user.role) {
      case UserRole.rider:
        return 'Pioneer Corridor Rider';
      case UserRole.sender:
        return 'Verified Merchant';
      case UserRole.receiver:
        return 'Roadside Receiver';
      case UserRole.hub:
        return 'Drop Hub Partner';
    }
  }

  IconData get _roleIcon {
    switch (user.role) {
      case UserRole.rider:
        return FeatherIcons.navigation;
      case UserRole.sender:
        return FeatherIcons.shoppingBag;
      case UserRole.receiver:
        return FeatherIcons.mapPin;
      case UserRole.hub:
        return FeatherIcons.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'User Profile',
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.edit2, size: 18, color: AppColors.textInverse),
            tooltip: 'Edit Profile',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile edit mode enabled for contact and landmark.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: AppDimens.screenInsets,
          child: Column(
            children: [
              // Avatar & Role Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: AppDimens.screenPaddingH),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            user.firstName.isNotEmpty ? user.firstName[0] : 'U',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 34,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_roleIcon, size: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(user.fullName, style: AppTextStyles.h2),
                    const SizedBox(height: 4),
                    Text(
                      user.phone.isNotEmpty ? user.phone : 'Roadside Guest Access',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(FeatherIcons.checkCircle, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            _roleTitle,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Role-Specific Metric Summary
              _buildMetricsRow(),
              const SizedBox(height: 18),

              // Account & Operation Details
              _buildSectionTitle('Operational Credentials'),
              _buildCredentialsCard(context),
              const SizedBox(height: 18),

              // Banking & Settlement Section
              if (user.role != UserRole.receiver) ...[
                _buildSectionTitle('Settlement & Payout Account'),
                _buildBankCard(),
                const SizedBox(height: 18),
              ],

              // Sign Out CTA
              OutlinedButton.icon(
                onPressed: () async {
                  await SessionManager.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(FeatherIcons.logOut, size: 16, color: AppColors.danger),
                label: Text(
                  'Sign Out of Sendalli',
                  style: AppTextStyles.button.copyWith(color: AppColors.danger),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.danger, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          title,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    switch (user.role) {
      case UserRole.rider:
        return Row(
          children: [
            Expanded(child: _buildMetricItem('TRUST SCORE', '${user.trustScore}.0', 'Pioneer Tier', AppColors.primary)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricItem('CORRIDOR TRIPS', '28', '100% On-Time', AppColors.textPrimary)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricItem('RATING', '4.9 ★', 'Warri Corridor', AppColors.eliteGold)),
          ],
        );
      case UserRole.sender:
        return Row(
          children: [
            Expanded(child: _buildMetricItem('ESCROW TIER', '₦20k Cap', '100% Protected', AppColors.primary)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricItem('DISPATCHES', '15', '1 In Transit', AppColors.textPrimary)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricItem('DISPUTES', '0%', 'Clean Record', AppColors.primaryDark)),
          ],
        );
      case UserRole.receiver:
        return Row(
          children: [
            Expanded(child: _buildMetricItem('PARCELS', '8 Held', 'Safe Handoff', AppColors.primary)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricItem('COMPLIANCE', '1 Min', 'Roadside Stop', AppColors.eliteGold)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricItem('PIN CODE', 'Verified', '6-Digit Auth', AppColors.primaryDark)),
          ],
        );
      case UserRole.hub:
        return Row(
          children: [
            Expanded(child: _buildMetricItem('EARNING RATE', '₦500', 'Per Package', AppColors.primary)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricItem('HELD TODAY', '25', 'Active Storage', AppColors.textPrimary)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricItem('CAPACITY', '50 Max', 'Corridor Depot', AppColors.eliteGold)),
          ],
        );
    }
  }

  Widget _buildMetricItem(String label, String value, String sub, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.h3.copyWith(color: valueColor, fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 2),
          Text(sub, style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildCredentialsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Column(
        children: [
          if (user.role == UserRole.rider) ...[
            _buildDetailRow(FeatherIcons.truck, 'Vehicle', user.vehiclePlate ?? 'Bajaj Boxer (DEL-492-WW)'),
            const Divider(color: AppColors.border, height: 20),
            _buildDetailRow(FeatherIcons.map, 'Corridor', user.corridor ?? 'Warri — Effurun Main Expressway'),
            const Divider(color: AppColors.border, height: 20),
            _buildDetailRow(FeatherIcons.shield, 'Union Park Hub', user.unionPark ?? 'Effurun Central Transit Hub'),
            const Divider(color: AppColors.border, height: 20),
            _buildDetailRow(FeatherIcons.checkCircle, 'Driver License', 'Verified & In Good Standing'),
          ] else if (user.role == UserRole.sender) ...[
            _buildDetailRow(FeatherIcons.shoppingBag, 'Business Name', user.shopName ?? 'Warri Central Merchant'),
            const Divider(color: AppColors.border, height: 20),
            _buildDetailRow(FeatherIcons.mapPin, 'Corridor Landmark', user.landmark ?? 'Main Market Waypoint, Warri'),
            const Divider(color: AppColors.border, height: 20),
            _buildDetailRow(FeatherIcons.shield, 'KYC Status', 'Verified Level 2 (CAC & NIN)'),
          ] else if (user.role == UserRole.receiver) ...[
            _buildDetailRow(FeatherIcons.mapPin, 'Primary Roadside Stop', user.landmark ?? 'PTI Junction, Warri'),
            const Divider(color: AppColors.border, height: 20),
            _buildDetailRow(FeatherIcons.map, 'Corridor', user.corridor ?? 'Refinery Road — Jakpa Corridor'),
            const Divider(color: AppColors.border, height: 20),
            _buildDetailRow(FeatherIcons.clock, 'Roadside Window', '1-Minute Handoff (or Hub Diversion)'),
          ] else if (user.role == UserRole.hub) ...[
            _buildDetailRow(FeatherIcons.home, 'Drop Hub Store', user.shopName ?? 'Chinedu Supermarket & Chemist'),
            const Divider(color: AppColors.border, height: 20),
            _buildDetailRow(FeatherIcons.mapPin, 'Depot Landmark', user.landmark ?? '14 Effurun Roundabout, Delta'),
            const Divider(color: AppColors.border, height: 20),
            _buildDetailRow(FeatherIcons.clock, 'Operating Hours', '8:00 AM – 7:00 PM Daily'),
          ],
        ],
      ),
    );
  }

  Widget _buildBankCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(FeatherIcons.creditCard, color: AppColors.primaryDark, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Guaranty Trust Bank (GTB)', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('•••• •••• 4921 • Paystack Transfer', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: AppDimens.borderWidth),
            ),
            child: Text(
              'ACTIVE',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
