import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/delivery/delivery_widgets.dart';
import '../../../../widgets/map/sendalli_map_view.dart';

/// Full-page detailed information screen for an incoming corridor delivery request.
///
/// Cleanly presents full order details including declared package value,
/// dispatch photo with full inspection preview, pickup & drop-off locations,
/// customer notes, escrow protection, and counter-offer action buttons.
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
  final String packageValue;
  final String? photoAsset;
  final String senderName;
  final String senderPhone;
  final String customerPhone;
  final String weightCategory;
  final String paymentStatus;
  final bool isCompleted;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final void Function(String proposedAmount, String? reason)? onCounterOffer;

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
    this.packageValue = '₦ 5,000.00',
    this.photoAsset,
    this.senderName = 'Corridor Sender',
    this.senderPhone = '+234 803 111 2233',
    this.customerPhone = '+234 803 000 1234',
    this.weightCategory = 'Small Parcel (< 1kg)',
    this.paymentStatus = 'Escrow Secured (Sendalli Guarantee)',
    this.isCompleted = false,
    this.onAccept,
    this.onDecline,
    this.onCounterOffer,
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
            const SizedBox(height: 8),

            // 1. Mandatory Parcel Dispatch Photo Card with Tap-to-Inspect
            ParcelPhotoCard(
              orderId: orderId,
              packageItem: packageItem,
              packageValue: packageValue,
              photoAsset: photoAsset,
              captureTime: 'Dispatch Photo • Verified at $dateText',
            ),
            const SizedBox(height: 12),

            // 2. Route Map Preview
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

            // 3. Route Details (Pickup & Drop-off)
            DeliveryRouteCard(
              pickupTitle: pickupTitle,
              pickupSubtitle: pickupSubtitle,
              dropoffTitle: dropoffTitle,
              dropoffSubtitle: dropoffSubtitle,
            ),
            const SizedBox(height: 12),

            // 4. Detailed Package & Value Card
            DeliveryPackageCard(
              packageId: orderId,
              packageItem: packageItem,
              deliveryFee: deliveryFee,
              packageValue: packageValue,
              weightCategory: weightCategory,
              paymentStatus: paymentStatus,
            ),
            const SizedBox(height: 12),

            // 5. Sender & Customer Contact Details Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CONTACT & PARTIES',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          paymentStatus,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Sender Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FeatherIcons.arrowUpRight, size: 14, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sender: $senderName',
                              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              senderPhone,
                              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Calling sender: $senderPhone')),
                          );
                        },
                        icon: const Icon(FeatherIcons.phone, size: 12),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 10),

                  // Receiver Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FeatherIcons.arrowDownRight, size: 14, color: Color(0xFF16A34A)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receiver: $customerName',
                              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              customerPhone,
                              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Calling receiver: $customerPhone')),
                          );
                        },
                        icon: const Icon(FeatherIcons.phone, size: 12),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 6. Customer Action Row (Chat & Call)
            DeliveryCustomerRow(
              name: customerName,
              onChatPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening chat with $customerName...')),
                );
              },
              onCallPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling customer: $customerPhone')),
                );
              },
            ),
            const SizedBox(height: 12),

            // 7. Handover Code Security Reminder
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radius),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.0),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FeatherIcons.key, size: 16, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Handover Release Code Required',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Receiver reads code "$handoverCode" to verify handover and instantly credit delivery fare.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 8. Roadside 1-Minute Window Notice
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
                  SnackBar(content: Text('Pickup: Collect from $pickupTitle')),
                );
              },
            ),
            DeliveryNoteTile(
              title: 'Drop-off note',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Drop-off: Roadside handover at $dropoffTitle')),
                );
              },
            ),
            if (customerNote.isNotEmpty) ...[
              const SizedBox(height: 8),
              DeliveryCustomerNoteCard(note: customerNote),
            ],
            const SizedBox(height: 20),

            // Counter-Offer / Fare Objection Button
            if (!isCompleted) ...[
              OutlinedButton.icon(
                key: const Key('object_propose_fare_button'),
                onPressed: () {
                  ProposeFareSheet.show(
                    context: context,
                    orderId: orderId,
                    currentFee: deliveryFee,
                    onSendOffer: (proposedAmount, reason) {
                      if (onCounterOffer != null) {
                        onCounterOffer!(proposedAmount, reason);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Proposed $proposedAmount sent to sender for $orderId!'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(FeatherIcons.dollarSign, size: 15, color: AppColors.primary),
                label: const Text('Object & Propose Fare Amount'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                  side: const BorderSide(color: AppColors.primary, width: 1.2),
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
              ),
              const SizedBox(height: 12),

              // Action Buttons: Accept / Decline
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
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF86EFAC), width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(FeatherIcons.checkCircle, color: Color(0xFF16A34A), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Completed & Verified',
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 14,
                              color: const Color(0xFF166534),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Fare $deliveryFee was credited to your wallet balance.',
                            style: AppTextStyles.caption.copyWith(color: const Color(0xFF15803D)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
