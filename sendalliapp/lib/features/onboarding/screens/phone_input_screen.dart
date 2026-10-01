import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import 'otp_verification_screen.dart';

/// Screen 3: Mobile Phone Number Entry (Onboarding-2.png).
class PhoneInputScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final bool isReturningLogin;

  const PhoneInputScreen({
    super.key,
    this.firstName,
    this.lastName,
    this.isReturningLogin = false,
  });

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validate);
  }

  void _validate() {
    final raw = _cleanPhone(_phoneController.text);
    final valid = raw.length == 10;
    if (valid != _isValid) {
      setState(() => _isValid = valid);
    }
  }

  String _cleanPhone(String text) {
    var digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    return digits;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (!_isValid) return;
    final cleaned = _cleanPhone(_phoneController.text);
    final fullNumber = '+234$cleaned';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          phoneNumber: fullNumber,
          firstName: widget.firstName,
          lastName: widget.lastName,
          isReturningLogin: widget.isReturningLogin,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          widget.isReturningLogin ? 'Sign In' : 'Step 2 of 4',
          style: AppTextStyles.caption.copyWith(fontSize: 13),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isReturningLogin ? 'Enter your phone' : 'Enter contact details',
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 8),
              Text(
                'We will send a 4-digit verification code to this phone number.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '803 123 4567',
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    width: 80,
                    child: Text(
                      '🇳🇬 +234',
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isValid ? _proceed : null,
                child: const Text('Send Verification Code'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
