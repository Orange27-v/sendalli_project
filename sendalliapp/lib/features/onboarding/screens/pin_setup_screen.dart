import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'role_selection_screen.dart';

/// Screen 5: 4-Digit Security PIN Setup (Onboarding-6.png).
class PinSetupScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;

  const PinSetupScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _enteredPin = '';
  String? _firstPin;
  bool _isConfirming = false;
  String? _errorMessage;

  void _onKeyPressed(String key) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += key;
        _errorMessage = null;
      });
      if (_enteredPin.length == 4) {
        _handlePinComplete();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = null;
      });
    }
  }

  void _handlePinComplete() {
    if (!_isConfirming) {
      // First entry finished -> ask to confirm
      setState(() {
        _firstPin = _enteredPin;
        _enteredPin = '';
        _isConfirming = true;
      });
    } else {
      // Confirmation entry
      if (_enteredPin == _firstPin) {
        // PINs match -> proceed to role selection
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RoleSelectionScreen(
              phoneNumber: widget.phoneNumber,
              firstName: widget.firstName,
              lastName: widget.lastName,
              pin: _enteredPin,
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'PINs did not match. Please try again.';
          _enteredPin = '';
          _firstPin = null;
          _isConfirming = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Step 4 of 4', style: AppTextStyles.caption.copyWith(fontSize: 13)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Column(
            children: [
              Text(
                _isConfirming ? 'Confirm your PIN' : 'Create 4-digit PIN',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isConfirming
                    ? 'Re-enter your 4-digit PIN to confirm.'
                    : 'You will use this PIN to quickly sign in anytime.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 4 Dot Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < _enteredPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? AppColors.primary : AppColors.surface,
                      border: Border.all(
                        color: isFilled ? AppColors.primary : AppColors.borderFocus,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
                  textAlign: TextAlign.center,
                ),
              ],
              const Spacer(),

              // Custom Numeric Keypad
              _buildKeypad(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              if (key.isEmpty) {
                return const SizedBox(width: 72, height: 60);
              }
              if (key == '⌫') {
                return InkWell(
                  onTap: _onBackspace,
                  borderRadius: BorderRadius.circular(36),
                  child: Container(
                    width: 72,
                    height: 60,
                    alignment: Alignment.center,
                    child: const Icon(FeatherIcons.delete, size: 22, color: AppColors.textPrimary),
                  ),
                );
              }
              return InkWell(
                onTap: () => _onKeyPressed(key),
                borderRadius: BorderRadius.circular(36),
                child: Container(
                  width: 72,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(key, style: AppTextStyles.h2),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
