import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import 'sendalli_qr_painter.dart';

/// Reusable QR Code presentation card displaying a live QR matrix and human-readable PIN.
/// Used by Senders and Receivers to present handover/release credentials to Riders or Hubs.
class SendalliQrDisplay extends StatelessWidget {
  final String qrData;
  final String pin;
  final String? title;
  final String? subtitle;
  final double qrSize;
  final VoidCallback? onScanPressed;

  const SendalliQrDisplay({
    super.key,
    required this.qrData,
    required this.pin,
    this.title = 'Handover QR Code',
    this.subtitle = 'Show this QR or PIN to confirm safe delivery handover',
    this.qrSize = 170.0,
    this.onScanPressed,
  });

  String get _formattedPin {
    // Format "849201" as "849 201" or "1234" as "1 2 3 4"
    if (pin.length == 6) {
      return '${pin.substring(0, 3)} ${pin.substring(3)}';
    } else if (pin.length == 4) {
      return '${pin.substring(0, 2)} ${pin.substring(2)}';
    }
    return pin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (subtitle != null) ...[
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),
          ],

          // QR Matrix Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomPaint(
              size: Size(qrSize, qrSize),
              painter: SendalliQrPainter(
                data: qrData,
                darkColor: const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Human Readable PIN Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(AppDimens.radiusButton),
              border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FeatherIcons.key, size: 14, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'PIN: $_formattedPin',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),

          if (onScanPressed != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onScanPressed,
              icon: const Icon(FeatherIcons.camera, size: 16),
              label: const Text('Or Scan Other Party\'s QR Code'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
