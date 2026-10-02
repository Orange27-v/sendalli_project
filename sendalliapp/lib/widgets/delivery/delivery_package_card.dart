import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Reusable package details card for rider delivery workflows.
///
/// Cleanly presents Package ID, declared package value, item category,
/// weight specifications, escrow security protection, and delivery fee.
class DeliveryPackageCard extends StatelessWidget {
  final String packageId;
  final String? packageItem;
  final String deliveryFee;
  final String? packageValue;
  final String? weightCategory;
  final String? paymentStatus;
  final String? secondaryNote;
  final String? photoAsset;
  final EdgeInsetsGeometry margin;

  const DeliveryPackageCard({
    super.key,
    required this.packageId,
    this.packageItem,
    required this.deliveryFee,
    this.packageValue,
    this.weightCategory,
    this.paymentStatus,
    this.secondaryNote,
    this.photoAsset,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Package ID & Delivery Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Package Id $packageId',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Delivery Payout Fee',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
              Text(
                deliveryFee,
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),

          // Sender Uploaded Item Photo Preview
          if (photoAsset != null && photoAsset!.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      photoAsset!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 44,
                        height: 44,
                        color: AppColors.primaryLight,
                        child: const Icon(FeatherIcons.package, color: AppColors.primary, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sender Dispatch Photo Attached',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Inspect parcel before roadside pickup confirmation',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(FeatherIcons.checkCircle, size: 14, color: Color(0xFF16A34A)),
                ],
              ),
            ),
          ],

          // Declared Value & Escrow Protection Row
          if (packageValue != null && packageValue!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBBF7D0), width: 1.0),
              ),
              child: Row(
                children: [
                  const Icon(FeatherIcons.shield, size: 14, color: Color(0xFF16A34A)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Declared Item Value: ',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF166534),
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: packageValue!,
                            style: AppTextStyles.caption.copyWith(
                              color: const Color(0xFF166534),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: ' • Escrow Protected',
                            style: AppTextStyles.caption.copyWith(
                              color: const Color(0xFF15803D),
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Package Item Details
          if (packageItem != null && packageItem!.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(FeatherIcons.package, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contents / Description',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 10.5),
                      ),
                      Text(
                        'Package Item: $packageItem',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          // Weight / Tier Details
          if (weightCategory != null && weightCategory!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(FeatherIcons.box, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Weight / Size: $weightCategory',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (secondaryNote != null && secondaryNote!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              secondaryNote!,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
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
