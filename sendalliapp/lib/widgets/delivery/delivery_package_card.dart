import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Reusable package details card for rider delivery workflows.
///
/// Cleanly presents Package ID, package item category, and delivery fee.
class DeliveryPackageCard extends StatelessWidget {
  final String packageId;
  final String? packageItem;
  final String deliveryFee;
  final String? secondaryNote;
  final EdgeInsetsGeometry margin;

  const DeliveryPackageCard({
    super.key,
    required this.packageId,
    this.packageItem,
    required this.deliveryFee,
    this.secondaryNote,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Package Id $packageId',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Delivery Fee',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                if (packageItem != null && packageItem!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Package Item: $packageItem',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (secondaryNote != null && secondaryNote!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    secondaryNote!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            deliveryFee,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Header row displaying tracking number and formatted date.
class DeliveryDateHeader extends StatelessWidget {
  final String referenceNumber;
  final String dateString;
  final EdgeInsetsGeometry margin;

  const DeliveryDateHeader({
    super.key,
    required this.referenceNumber,
    required this.dateString,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            referenceNumber,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            dateString,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
