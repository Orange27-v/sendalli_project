import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/delivery/delivery_widgets.dart';
import '../../../../widgets/map/sendalli_map_view.dart';

/// Full-page detailed information screen for an incoming corridor delivery request.
/// Opened when a rider taps on an item in the slide-up requests modal.
class RiderDeliveryDetailScreen extends StatelessWidget {
  final String orderId;
  final String referenceId;
  final String dateText;
  final String pickupTitle;
  final String pickupSubtitle;
  final String dropoffTitle;
  final String dropoffSubtitle;
  final String packageItem;
  final String deliveryFee;
  final String customerName;
  final String customerNote;
  final String handoverCode;
  final String corridorName;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const RiderDeliveryDetailScreen({
    super.key,
    this.orderId = '#BE12345',
    this.referenceId = 'Ref: #BE12345',
    this.dateText = 'Today • 2:45 PM',
    this.pickupTitle = '9ja kitchen (Pickup Location)',
    this.pickupSubtitle = '34 Airport Road, Warri',
    this.dropoffTitle = 'John Deo (Drop-off Location)',
    this.dropoffSubtitle = '12 Enerhen Junction, Effurun',
    this.packageItem = 'Food • Jollof Rice, meat and moi moi',
    this.deliveryFee = '₦ 1,200',
    this.customerName = 'John Deo',
    this.customerNote = 'Please call when you reach Enerhen Junction. I will meet you at the roadside.',
    this.handoverCode = '1234',
    this.corridorName = 'Warri — Effurun Corridor',
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Request Information',
        subtitle: orderId,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.screenPaddingH,
          vertical: AppDimens.screenPaddingV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subheader: Reference ID & Date
            DeliveryDateHeader(
              referenceNumber: referenceId,
              dateString: dateText,
            ),
            const SizedBox(height: 12),

            // Route map preview
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radius),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              clipBehavior: Clip.antiAlias,
              child: SendalliMapView(
                corridorName: corridorName,
                height: 160,
                showLiveRider: true,
              ),
            ),
            const SizedBox(height: 14),

            // Route details
            DeliveryRouteCard(
              pickupTitle: pickupTitle,
              pickupSubtitle: pickupSubtitle,
              dropoffTitle: dropoffTitle,
              dropoffSubtitle: dropoffSubtitle,
            ),
            const SizedBox(height: 12),

            // Package Summary & Fee
            DeliveryPackageCard(
              packageId: orderId,
              packageItem: packageItem,
              deliveryFee: deliveryFee,
            ),
            const SizedBox(height: 12),

            // Customer Row with Message & Call
            DeliveryCustomerRow(
              name: customerName,
              onChatPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening chat with $customerName...')),
                );
              },
              onCallPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling customer: +234 803 000 1234')),
                );
              },
            ),
            const SizedBox(height: 12),

            // Roadside 1-Minute Window Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimens.radius),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                  width: AppDimens.borderWidth,
                ),
              ),
              child: Row(
                children: [
                  const Icon(FeatherIcons.clock, size: 20, color: AppColors.warning),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1-Minute Roadside Window',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Receiver must be at roadside stop within 1 min upon arrival or package is diverted to Drop Hub.',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Notes
            DeliveryNoteTile(
              title: 'Pickup note',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pickup: Collect package from front desk.')),
                );
              },
            ),
            DeliveryNoteTile(
              title: 'Drop-off note',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Drop-off: Roadside handover.')),
                );
              },
            ),
            if (customerNote.isNotEmpty) ...[
              const SizedBox(height: 8),
              DeliveryCustomerNoteCard(note: customerNote),
            ],
            const SizedBox(height: 20),

            // Action Buttons
            DeliveryActionGroup(
              primaryLabel: 'Accept Delivery',
              onPrimary: () {
                Navigator.of(context).pop(true);
                if (onAccept != null) onAccept!();
              },
              secondaryLabel: 'Decline Request',
              onSecondary: () {
                Navigator.of(context).pop(false);
                if (onDecline != null) onDecline!();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
