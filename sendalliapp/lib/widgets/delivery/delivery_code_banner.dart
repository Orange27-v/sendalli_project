import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_text_styles.dart';

/// Reusable delivery code banner widget with a soft warm amber highlight.
///
/// Prominently displays the required handover code (e.g. "Confirm Delivery Code from customer: 1234")
/// to ensure frictionless roadside package validation between rider and customer.
class DeliveryCodeBanner extends StatelessWidget {
  final String label;
  final String code;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;

  const DeliveryCodeBanner({
    super.key,
    this.label = 'Confirm Delivery Code from customer:',
    required this.code,
    this.onTap,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9C3), // Soft cream/amber background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFDE047).withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FeatherIcons.key,
            size: 15,
            color: Color(0xFF854D0E),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text.rich(
              TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF854D0E), // Deep amber text
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(text: '$label '),
                  TextSpan(
                    text: code,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF713F12),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
