import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../widgets/dashboard_app_bar.dart';
import '../../../../widgets/verification/verification_widgets.dart';
import '../../../../widgets/map/sendalli_map_view.dart';
import '../common/profile_screen.dart';
import '../../../onboarding/screens/business_sender_registration_screen.dart';
import 'sender_checkout_screen.dart';
import 'sender_order_tracking_screen.dart';

/// Sender Home Dashboard.
class SenderHomeScreen extends StatelessWidget {
  final UserProfile user;

  const SenderHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: DashboardAppBar(
          user: user,
          title: 'Hello ${user.firstName}',
          subtitle: user.shopName ?? 'Sendalli Sender',
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: AppDimens.screenInsets,
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(AppDimens.cardPaddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: AppDimens.borderWidth,
                  ),
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
                          Text('Sender • Corridor Active', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    const Icon(FeatherIcons.chevronRight, size: 20, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Business Verification Status or Apply Banner
            if (user.isBusinessVerified == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(FeatherIcons.checkCircle, size: 16, color: Color(0xFF16A34A)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Verified Commercial Business • CAC: ${user.cacNumber ?? "Active"}',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF166534),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(FeatherIcons.award, size: 20, color: Color(0xFF16A34A)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Applying as a Registered Business?',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF166534),
                            ),
                          ),
                          Text(
                            'File full application & upload CAC certificate',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 11,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      key: const Key('home_business_apply_btn'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BusinessSenderRegistrationScreen(currentUser: user),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Apply →',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF166534),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            // Escrow & Wallet Quick Stat Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('₦ 4,800.00', style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                      const SizedBox(height: 2),
                      Text('In Escrow', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                  Container(height: 30, width: 1, color: AppColors.border),
                  Column(
                    children: [
                      Text('1 Active', style: AppTextStyles.h3),
                      const SizedBox(height: 2),
                      Text('In Transit', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                  Container(height: 30, width: 1, color: AppColors.border),
                  Column(
                    children: [
                      Text('14', style: AppTextStyles.h3),
                      const SizedBox(height: 2),
                      Text('Completed', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Primary CTA: Send a New Parcel
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SenderCheckoutScreen(user: user),
                  ),
                );
              },
              icon: const Icon(FeatherIcons.plus, size: 18, color: AppColors.textInverse),
              label: const Text('Send a New Parcel'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textInverse,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
            ),
            const SizedBox(height: 16),

            // Drop Hub Application Banner (per Warri Transit-Logistics Business Model V3.md)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: AppDimens.borderWidth),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FeatherIcons.home, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Turn Your Shop into a Drop Hub',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Earn ₦500 per parcel held for customers on your corridor.',
                          style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Apply as Drop Hub Partner'),
                          content: const Text(
                            'Turn your existing store or pharmacy into a verified Sendalli Drop Hub:\n\n• Earn ₦500 for every parcel kept in custody\n• Gain extra daily foot traffic from corridor pickups\n• Operating hours: 8:00 AM - 7:00 PM\n• Instant wallet payouts',
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Drop Hub Partner application submitted for corridor review.'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              },
                              child: const Text('Apply Now'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Corridor Map
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Corridor Route Activity', style: AppTextStyles.h3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: AppDimens.borderWidth),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Corridor Live',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              clipBehavior: Clip.antiAlias,
              child: const SendalliMapView(
                height: 165,
                corridorName: 'Active Corridor: Warri — Effurun',
                showLiveRider: true,
              ),
            ),
            const SizedBox(height: 24),

            // Active Deliveries with Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Deliveries', style: AppTextStyles.h3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '1 Live',
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Interactive Active Parcel Card
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SenderOrderTrackingScreen(
                      orderId: '#SND-WAR-8492',
                      senderName: user.shopName ?? 'Amaka Kitchen & Grills',
                      pickupAddress: 'Warri Central Kitchen (Pickup Location)',
                      dropoffAddress: 'Effurun Market Plaza, Shop 14B',
                      totalAmount: '₦ 1,850.00',
                      deliveryOption: 'Priority (< 15 mins)',
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('#SND-WAR-8492', style: AppTextStyles.h3.copyWith(fontSize: 15)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'IN TRANSIT',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(FeatherIcons.navigation, size: 14, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Refinery Road — Jakpa Junction Stop', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(FeatherIcons.clock, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        Text('ETA: ~12 mins away', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                        const Spacer(),
                        Text(
                          'Release PIN: 849 201',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        SendalliVerificationModal.show(
                          context: context,
                          title: 'Sender Handover Verification',
                          subtitle: 'Scan Rider QR or show your 6-digit release PIN: 849201',
                          expectedPin: '849201',
                          qrPayload: 'SND-WAR-8492-849201',
                          showPresentationTab: true,
                          pinLength: 6,
                        );
                      },
                      icon: const Icon(FeatherIcons.maximize, size: 14),
                      label: const Text('Show Handover QR & Scanner'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(38),
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 1.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Protection Reassurance
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Row(
                children: [
                  const Icon(FeatherIcons.shield, size: 16, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '100% Escrow Guarantee • Max ₦20,000 loss coverage • 30-min dispute window.',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  ),
);
  }
}
