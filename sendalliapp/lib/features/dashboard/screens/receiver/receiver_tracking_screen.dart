import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/storage/session_manager.dart';
import '../../../../widgets/checkout/order_step_progress.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/delivery/delivery_widgets.dart';
import '../../../../widgets/map/sendalli_map_view.dart';

/// Friction-free guest tracking screen for parcel recipients.
class ReceiverTrackingScreen extends StatelessWidget {
  final String trackingId;

  const ReceiverTrackingScreen({super.key, required this.trackingId});

  void _handleExit(BuildContext context) async {
    await SessionManager.clearTrackingId();
    if (!context.mounted) return;
    AppNavigator.safePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleExit(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Live Parcel Tracker',
          leading: IconButton(
            icon: const Icon(FeatherIcons.x, size: 20, color: AppColors.textInverse),
            onPressed: () => _handleExit(context),
          ),
          actions: [
            TextButton(
              onPressed: () => _handleExit(context),
              child: Text(
                'Exit',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textInverse, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: AppDimens.screenInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tracking Header
                Container(
                  padding: const EdgeInsets.all(AppDimens.cardPaddingLarge),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: AppDimens.borderWidth,
                    ),
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
                              color: AppColors.deepGreenLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'IN TRANSIT',
                              style: AppTextStyles.caption.copyWith(color: AppColors.deepGreen, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(height: 4),
                  Text(trackingId, style: AppTextStyles.h2.copyWith(color: AppColors.primaryDark)),
                  const SizedBox(height: 14),

                  // Live interactive countdown timer
                  const TrackingCountdownTimer(
                    initialDuration: Duration(minutes: 12, seconds: 15),
                    label: 'Estimated Arrival in:',
                    style: TrackingTimerStyle.card,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Drop Point: Jakpa Junction (Roadside Stop)',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Live Corridor Map
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              clipBehavior: Clip.antiAlias,
              child: const SendalliMapView(
                height: 160,
                corridorName: 'Live Corridor: Refinery Road — Jakpa',
                showLiveRider: true,
              ),
            ),
            const SizedBox(height: 18),

            // Step Progress Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: const OrderStepProgress(
                currentStep: 2,
                statusMessage: 'Keke rider is en route to Jakpa Junction roadside stop.',
              ),
            ),
            const SizedBox(height: 20),

            // 6-Digit Release Code Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary, width: 1.5),
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
                      borderRadius: BorderRadius.circular(6),
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
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
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
                    icon: const Icon(FeatherIcons.phone, color: AppColors.textInverse, size: 18),
                    style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 1-Minute Roadside Stop Limit Notice (per Golden Rules)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3), width: AppDimens.borderWidth),
              ),
              child: Row(
                children: [
                  const Icon(FeatherIcons.clock, size: 18, color: AppColors.warning),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Rider has a 1-minute roadside handoff limit. If unavailable, divert to nearby Drop Hub.',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 1-Tap Hub Diversion Button
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Divert to Drop Hub?'),
                    content: const Text(
                      'Cannot meet rider at the roadside? Divert this delivery to partner hub:\n\n• City Care Pharmacy Hub (Jakpa Junction)\n• 48 hours safe custody\n• Standard ₦500 holding fee payable on pickup with your PIN.',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Rider notified to divert parcel to City Care Pharmacy Hub.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        child: const Text('Confirm (₦500 Fee)'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(FeatherIcons.home, size: 16),
              label: const Text('Cannot Meet at Roadside? Divert to Hub (₦500)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                side: const BorderSide(color: AppColors.borderMedium),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
            ),
            const SizedBox(height: 10),

            // Dispute Action (30-min window)
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Report Package Issue'),
                    content: const Text(
                      'Have an issue with this parcel (damaged seal, wrong items, missing delivery)?\n\nSubmit directly to Sendalli Admin for arbitration within the 30-minute window.',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dispute submitted to admin operations.'),
                              backgroundColor: AppColors.danger,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                        child: const Text('Submit Report'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(FeatherIcons.alertTriangle, size: 14, color: AppColors.textMuted),
              label: Text('Report Issue or Damage', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
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
