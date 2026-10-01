import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_role.dart';
import '../../../widgets/form_randomizer.dart';
import 'otp_verification_screen.dart';

/// Screen 3: Mobile Phone Number Entry with Square, High-Visibility Input Architecture.
class PhoneInputScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final bool isReturningLogin;
  final UserRole? targetRole;

  const PhoneInputScreen({
    super.key,
    this.firstName,
    this.lastName,
    this.isReturningLogin = false,
    this.targetRole,
  });

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isValid = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validate);
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  void _validate() {
    final raw = _cleanPhone(_phoneController.text);
    final valid = raw.length == 10;
    if (valid != _isValid) {
      setState(() => _isValid = valid);
    }
  }

  void _randomize() {
    final sample = FormSampleData.randomPhone();
    _phoneController.text = _cleanPhone(sample);
  }

  void _selectPrefix(String prefix) {
    // Quick-fill starting prefix for rapid testing
    final randomSuffix = (1000000 + (DateTime.now().microsecondsSinceEpoch % 9000000)).toString();
    _phoneController.text = '$prefix$randomSuffix'.substring(0, 10);
  }

  String _cleanPhone(String text) {
    var digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('234')) {
      digits = digits.substring(3);
    }
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    return digits;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
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
          targetRole: widget.targetRole,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _phoneController.text.isNotEmpty;
    final digits = _cleanPhone(_phoneController.text);
    final isComplete = digits.length == 10;

    // High-visibility dynamic border contrast
    Color fieldBorderColor;
    if (isComplete) {
      fieldBorderColor = AppColors.success;
    } else if (_isFocused) {
      fieldBorderColor = AppColors.primaryDark;
    } else {
      fieldBorderColor = AppColors.borderMedium;
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          widget.isReturningLogin ? 'Sign In' : 'Step 2 of 4',
          style: AppTextStyles.caption.copyWith(fontSize: 13),
        ),
        actions: [
          RandomizeButton(label: 'Fill Sample', onRandomize: _randomize),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contextual user greeting if signing up with name
              if (widget.firstName != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    'Hi, ${widget.firstName} 👋',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              Text(
                widget.isReturningLogin ? 'Enter your phone' : 'Mobile Number',
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 6),
              Text(
                'We will send a 4-digit SMS verification code to verify your SIM line.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 28),

              // ==========================================
              // SQUARE, HIGH-VISIBILITY, CONCISE INPUT BOX
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MOBILE PHONE NUMBER',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isComplete
                          ? AppColors.success.withValues(alpha: 0.12)
                          : (hasText ? AppColors.warning.withValues(alpha: 0.12) : AppColors.surfaceSubtle),
                      borderRadius: BorderRadius.circular(4), // Crisp square badge
                      border: Border.all(
                        color: isComplete
                            ? AppColors.success
                            : (hasText ? AppColors.warning : AppColors.borderMedium),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      isComplete
                          ? '✓ 10 digits valid'
                          : (hasText ? '${digits.length}/10 digits' : '10 digits required'),
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isComplete
                            ? AppColors.success
                            : (hasText ? AppColors.warning : AppColors.textMuted),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Dual-Box Square Arrangement
              Row(
                children: [
                  // Box 1: Square Country Code Box (+234)
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6), // Modern square radius
                      border: Border.all(
                        color: _isFocused ? AppColors.primaryDark : AppColors.borderMedium,
                        width: 1.4,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇳🇬', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          '+234',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Box 2: Square Main Digits Input Box
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(6), // Modern square radius
                        border: Border.all(
                          color: fieldBorderColor,
                          width: _isFocused || isComplete ? 1.6 : 1.4,
                        ),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.phone,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: '803 123 4567',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 16,
                            letterSpacing: 1.0,
                            color: AppColors.textMuted,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (hasText)
                                IconButton(
                                  icon: const Icon(FeatherIcons.xCircle, size: 16, color: AppColors.textMuted),
                                  onPressed: () {
                                    _phoneController.clear();
                                  },
                                  splashRadius: 16,
                                ),
                              if (isComplete)
                                const Padding(
                                  padding: EdgeInsets.only(right: 12.0),
                                  child: Icon(FeatherIcons.checkCircle, size: 18, color: AppColors.success),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Concise Network Prefix Quick-Select Chips
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Quick fill:',
                    style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textMuted),
                  ),
                  _buildSampleChip('803', 'MTN'),
                  _buildSampleChip('802', 'Airtel'),
                  _buildSampleChip('805', 'Glo'),
                  _buildSampleChip('809', '9mobile'),
                ],
              ),

              const Spacer(),

              // Concise Security Footnote
              Row(
                children: [
                  const Icon(FeatherIcons.shield, size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Protected by Sendalli SIM Auth • Used for handover release PINs',
                      style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Square High-Contrast Action Button
              ElevatedButton(
                onPressed: _isValid ? _proceed : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Send Verification Code'),
                    SizedBox(width: 8),
                    Icon(FeatherIcons.arrowRight, size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  /// Clean, square sample prefix chip
  Widget _buildSampleChip(String prefix, String carrier) {
    return InkWell(
      onTap: () => _selectPrefix(prefix),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.borderMedium, width: 0.8),
        ),
        child: Text(
          '$prefix ($carrier)',
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
