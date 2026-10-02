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

                  final boxWidth = widget.pinLength <= 4 ? 62.0 : 46.0;
                  final boxHeight = widget.pinLength <= 4 ? 68.0 : 54.0;

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: widget.pinLength <= 4 ? 6 : 4),
                    width: boxWidth,
                    height: boxHeight,
                    decoration: BoxDecoration(
                      color: hasChar
                          ? const Color(0xFFF0FDF4)
                          : (isFocused ? Colors.white : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _errorMessage.isNotEmpty
                            ? AppColors.danger
                            : (isFocused
                                ? AppColors.primary
                                : (hasChar ? AppColors.primaryDark : const Color(0xFFCBD5E1))),
                        width: isFocused ? 2.2 : (hasChar ? 1.8 : 1.5),
                      ),
                      boxShadow: [
                        if (isFocused)
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.16),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        else
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      char,
                      style: AppTextStyles.h1.copyWith(
                        fontSize: widget.pinLength <= 4 ? 24 : 20,
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
