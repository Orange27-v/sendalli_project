import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'delivery_action_buttons.dart';
import 'delivery_note_tile.dart';
import 'delivery_package_card.dart';
import 'delivery_route_card.dart';

/// Bottom sheet modal representing an incoming delivery request for riders,
/// matching the exact layout of Screen 1 in the rider specification.
class IncomingDeliverySheet extends StatelessWidget {
  final String dateText;
  final String pickupTitle;
  final String? pickupSubtitle;
  final String dropoffTitle;
  final String? dropoffSubtitle;
  final String packageId;
  final String deliveryFee;
  final VoidCallback onAccept;
  final VoidCallback onCancel;
  final VoidCallback? onPickupNoteTap;
  final VoidCallback? onDropoffNoteTap;

  const IncomingDeliverySheet({
    super.key,
    this.dateText = '12th of November, 2024',
    this.pickupTitle = '9ja kitchen (Pickup Location)',
    this.pickupSubtitle = 'Lagos avenue, Ring road',
    this.dropoffTitle = 'John Deo (Drop-off Location)',
    this.dropoffSubtitle = '114, Ojuelegba, Lagos state',
    this.packageId = '#BE12345',
    this.deliveryFee = '₦ 260.00',
    required this.onAccept,
    required this.onCancel,
    this.onPickupNoteTap,
    this.onDropoffNoteTap,
  });

  /// Helper method to display this sheet modally from any BuildContext.
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onAccept,
    required VoidCallback onCancel,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => IncomingDeliverySheet(
        onAccept: () {
          Navigator.of(sheetContext).pop();
          onAccept();
        },
        onCancel: () {
          Navigator.of(sheetContext).pop();
          onCancel();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtle drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title and Date row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Package Delivery',
                    style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    dateText,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Route Card (Pickup & Drop-off)
              DeliveryRouteCard(
                pickupTitle: pickupTitle,
                pickupSubtitle: pickupSubtitle,
                dropoffTitle: dropoffTitle,
                dropoffSubtitle: dropoffSubtitle,
              ),
              const SizedBox(height: 12),

              // Package Details
              DeliveryPackageCard(
                packageId: packageId,
                deliveryFee: deliveryFee,
              ),
              const SizedBox(height: 12),

              // Notes
              DeliveryNoteTile(
                title: 'Pickup note',
                onTap: onPickupNoteTap,
              ),
              DeliveryNoteTile(
                title: 'Drop-off note',
                onTap: onDropoffNoteTap,
              ),
              const SizedBox(height: 16),

              // Action Buttons
              DeliveryActionGroup(
                primaryLabel: 'Accept Delivery',
                onPrimary: onAccept,
                secondaryLabel: 'Cancel',
                onSecondary: onCancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
