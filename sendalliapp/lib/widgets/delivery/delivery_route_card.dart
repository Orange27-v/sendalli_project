import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Reusable Pickup & Drop-off route card as shown in the rider delivery specification.
///
/// Features two bordered location boxes (Pickup and Drop-off) joined by a vertical
/// dot connector indicator, with full support for titles, subtitles, and tap handlers.
class DeliveryRouteCard extends StatelessWidget {
  final String pickupTitle;
  final String? pickupSubtitle;
  final VoidCallback? onPickupTap;

  final String dropoffTitle;
  final String? dropoffSubtitle;
  final VoidCallback? onDropoffTap;

  /// Optional outer padding.
  final EdgeInsetsGeometry padding;

  const DeliveryRouteCard({
    super.key,
    required this.pickupTitle,
    this.pickupSubtitle,
    this.onPickupTap,
    required this.dropoffTitle,
    this.dropoffSubtitle,
    this.onDropoffTap,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Pickup Location Box
          _LocationBox(
            indicator: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                shape: BoxShape.circle,
              ),
            ),
            title: pickupTitle,
            subtitle: pickupSubtitle,
            onTap: onPickupTap,
          ),

          // 2. Vertical Dot Connector
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, bottom: 2),
            child: Column(
              children: List.generate(
                3,
                (index) => Container(
                  width: 3,
                  height: 3,
                  margin: const EdgeInsets.symmetric(vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // 3. Drop-off Location Box
          _LocationBox(
            indicator: const Icon(
              FeatherIcons.mapPin,
              size: 14,
              color: Color(0xFF1E293B),
            ),
            title: dropoffTitle,
            subtitle: dropoffSubtitle,
            onTap: onDropoffTap,
          ),
        ],
      ),
    );
  }
}

/// Internal helper for the bordered location row.
class _LocationBox extends StatelessWidget {
  final Widget indicator;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _LocationBox({
    required this.indicator,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: Center(child: indicator),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
