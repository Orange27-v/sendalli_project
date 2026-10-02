import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import 'sendalli_qr_display.dart';
import 'sendalli_qr_scanner_view.dart';
import 'sendalli_pin_input_view.dart';

enum VerificationMode { scanQr, enterPin, showQr }

/// Unified Step Verification Modal Sheet supporting both QR Code Scanning and PIN input.
/// Operates seamlessly across Rider, Hub, Sender, and Receiver workflows.
class SendalliVerificationModal extends StatefulWidget {
  final String title;
  final String subtitle;
  final String expectedPin;
  final String qrPayload;
  final bool showPresentationTab;
  final int pinLength;
  final ValueChanged<String>? onVerified;

  const SendalliVerificationModal({
    super.key,
    required this.title,
    required this.subtitle,
    required this.expectedPin,
    this.qrPayload = 'SND-WAR-8492',
    this.showPresentationTab = false,
    this.pinLength = 4,
    this.onVerified,
  });

  /// Convenience launcher to open this modal bottom sheet and return whether verification succeeded.
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String expectedPin,
    String qrPayload = 'SND-WAR-8492',
    bool showPresentationTab = false,
    int pinLength = 4,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SendalliVerificationModal(
        title: title,
        subtitle: subtitle,
        expectedPin: expectedPin,
        qrPayload: qrPayload,
        showPresentationTab: showPresentationTab,
        pinLength: pinLength,
      ),
    );
  }

  @override
  State<SendalliVerificationModal> createState() => _SendalliVerificationModalState();
}

class _SendalliVerificationModalState extends State<SendalliVerificationModal> {
  late VerificationMode _currentMode;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _currentMode = VerificationMode.scanQr;
  }

  void _handleSuccess(String verifiedCode) async {
    setState(() => _isSuccess = true);
    if (widget.onVerified != null) {
      widget.onVerified!(verifiedCode);
    }
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(18, 12, 18, bottomInset + 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.borderMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(FeatherIcons.shield, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.subtitle,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(FeatherIcons.x, size: 20, color: AppColors.textMuted),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Success Animation Banner
          if (_isSuccess) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FeatherIcons.check, size: 36, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Verification Confirmed!',
                    style: AppTextStyles.h3.copyWith(color: AppColors.success),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Step authenticated safely on Sendalli Corridor.',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Mode Selector Tabs (Scan QR vs. Enter PIN vs. Show QR)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(AppDimens.radiusButton),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      mode: VerificationMode.scanQr,
                      icon: FeatherIcons.camera,
                      label: 'Scan QR',
                    ),
                  ),
                  Expanded(
                    child: _buildTabButton(
                      mode: VerificationMode.enterPin,
                      icon: FeatherIcons.lock,
                      label: 'Enter PIN',
                    ),
                  ),
                  if (widget.showPresentationTab)
                    Expanded(
                      child: _buildTabButton(
                        mode: VerificationMode.showQr,
                        icon: FeatherIcons.maximize,
                        label: 'My QR/PIN',
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Content
            if (_currentMode == VerificationMode.scanQr)
              SendalliQrScannerView(
                simulatedCode: widget.expectedPin.isNotEmpty ? widget.expectedPin : widget.qrPayload,
                onScanned: (code) => _handleSuccess(code),
              )
            else if (_currentMode == VerificationMode.enterPin)
              SendalliPinInputView(
                pinLength: widget.pinLength,
                expectedPin: widget.expectedPin,
                onVerified: (pin) => _handleSuccess(pin),
              )
            else
              SendalliQrDisplay(
                qrData: widget.qrPayload,
                pin: widget.expectedPin,
                onScanPressed: () {
                  setState(() => _currentMode = VerificationMode.scanQr);
                },
              ),
          ],
        ],
      ),
      ),
    );
  }

  Widget _buildTabButton({
    required VerificationMode mode,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentMode == mode;

    return GestureDetector(
      onTap: () => setState(() => _currentMode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusButton),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
