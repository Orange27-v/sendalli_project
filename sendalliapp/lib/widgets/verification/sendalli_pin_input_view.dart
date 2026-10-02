import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

/// Reusable PIN Input View with separate digit boxes, validation, and sample quick fill.
class SendalliPinInputView extends StatefulWidget {
  final int pinLength;
  final String expectedPin;
  final ValueChanged<String> onVerified;
  final String title;
  final String subtitle;

  const SendalliPinInputView({
    super.key,
    this.pinLength = 4,
    required this.expectedPin,
    required this.onVerified,
    this.title = 'Enter Security Handover PIN',
    this.subtitle = 'Ask the other party for their verification PIN',
  });

  @override
  State<SendalliPinInputView> createState() => _SendalliPinInputViewState();
}

class _SendalliPinInputViewState extends State<SendalliPinInputView> {
  late final TextEditingController _controller;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _verifyPin() {
    final entered = _controller.text.trim();
    if (entered.length < widget.pinLength) {
      setState(() => _errorMessage = 'Please enter all ${widget.pinLength} digits.');
      return;
    }

    // If expectedPin is specified and doesn't match
    if (widget.expectedPin.isNotEmpty && entered != widget.expectedPin.replaceAll(' ', '')) {
      setState(() => _errorMessage = 'Incorrect PIN code. Please verify and try again.');
      return;
    }

    setState(() => _errorMessage = '');
    widget.onVerified(entered);
  }

  void _quickFill() {
    final clean = widget.expectedPin.replaceAll(' ', '');
    _controller.text = clean.isNotEmpty ? clean : ('1' * widget.pinLength);
    setState(() => _errorMessage = '');
    _verifyPin();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),

        // Hidden input field coupled with visible styled boxes
        Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.0,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                maxLength: widget.pinLength,
                autofocus: false,
                onChanged: (val) {
                  setState(() => _errorMessage = '');
                  if (val.length == widget.pinLength) {
                    _verifyPin();
                  }
                },
              ),
            ),
            // Visible Digit Boxes
            GestureDetector(
              onTap: () {
                // Focus hidden textfield
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.pinLength, (index) {
                  final text = _controller.text;
                  final hasChar = index < text.length;
                  final char = hasChar ? text[index] : '';
                  final isFocused = index == text.length;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 44,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                      border: Border.all(
                        color: _errorMessage.isNotEmpty
                            ? AppColors.danger
                            : (isFocused ? AppColors.primary : AppColors.border),
                        width: isFocused ? 2.0 : AppDimens.borderWidth,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      char,
                      style: AppTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),

        if (_errorMessage.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.danger,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Verify Button
        ElevatedButton(
          onPressed: _verifyPin,
          child: const Text('Verify PIN'),
        ),
        const SizedBox(height: 8),

        // Quick fill shortcut for testing
        TextButton(
          onPressed: _quickFill,
          child: Text(
            'Quick Fill Valid PIN (${widget.expectedPin.isNotEmpty ? widget.expectedPin : "Auto"})',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
