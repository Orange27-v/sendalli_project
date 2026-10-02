import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/storage/session_manager.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../dashboard/screens/screens.dart';
import '../../../core/models/user_role.dart';
import 'pin_setup_screen.dart';

/// Screen 4: SMS OTP Verification (Onboarding-3.png).
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final bool isReturningLogin;
  final UserRole? targetRole;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.isReturningLogin = false,
    this.targetRole,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  late final List<FocusNode> _focusNodes;
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _focusNodes = List.generate(4, (index) {
      final node = FocusNode(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[index].text.isEmpty &&
              index > 0) {
            _controllers[index - 1].clear();
            _focusNodes[index - 1].requestFocus();
            setState(() {});
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
      );
      node.addListener(() {
        if (mounted) setState(() {});
      });
      return node;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Handles pasting full OTP (e.g. "1234")
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < 4 && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final nextIndex = digits.length.clamp(0, 3);
      _focusNodes[nextIndex].requestFocus();
      setState(() {});
      if (_currentOtp.length == 4) {
        _verifyOtp();
      }
      return;
    }

    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {});

    if (_currentOtp.length == 4) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    if (_currentOtp.length < 4) return;

    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 600)); // Simulating network handshake

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (widget.isReturningLogin) {
      // Returning user login -> check stored profile or navigate to PIN check
      final user = await SessionManager.getUserProfile();
      if (!mounted) return;
      if (user != null) {
        switch (user.role) {
          case UserRole.sender:
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => SenderHomeScreen(user: user)),
              (route) => false,
            );
            return;
          case UserRole.rider:
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => RiderHomeScreen(user: user)),
              (route) => false,
            );
            return;
          case UserRole.hub:
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HubHomeScreen(user: user)),
              (route) => false,
            );
            return;
          case UserRole.receiver:
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => ReceiverHomeScreen(user: user)),
              (route) => false,
            );
            return;
        }
      }
    }

    // New User Sign Up -> proceed to Step 4 (PIN Setup)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PinSetupScreen(
          phoneNumber: widget.phoneNumber,
          firstName: widget.firstName ?? 'Sendalli',
          lastName: widget.lastName ?? 'User',
          targetRole: widget.targetRole,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        AppNavigator.safePop(context);
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Verify OTP',
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('We sent you an SMS', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Enter the 4-digit code sent to ${widget.phoneNumber}',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 36),

              // Sizable, prominent 4-box OTP row with high-visibility architecture
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFocused = _focusNodes[index].hasFocus;
                  final hasText = _controllers[index].text.isNotEmpty;

                  return GestureDetector(
                    onTap: () => _focusNodes[index].requestFocus(),
                    child: Container(
                      width: 68,
                      height: 72,
                      margin: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        color: isFocused
                            ? Colors.white
                            : (hasText ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isFocused
                              ? AppColors.primary
                              : (hasText ? AppColors.primaryDark : const Color(0xFFCBD5E1)),
                          width: isFocused ? 2.2 : (hasText ? 1.8 : 1.5),
                        ),
                        boxShadow: [
                          if (isFocused)
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.18),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
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
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        maxLength: 1,
                        cursorColor: AppColors.primary,
                        cursorHeight: 28,
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                          filled: false,
                        ),
                        onChanged: (val) => _onDigitChanged(index, val),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Countdown and WhatsApp fallback
              Center(
                child: _secondsRemaining > 0
                    ? Text(
                        'Resend code in ${_secondsRemaining}s',
                        style: AppTextStyles.bodySmall,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _startTimer,
                            child: const Text('Resend SMS'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('OTP sent via WhatsApp.')),
                              );
                              _startTimer();
                            },
                            icon: const Icon(FeatherIcons.messageSquare, size: 16),
                            label: const Text('Send via WhatsApp'),
                          ),
                        ],
                      ),
              ),

              const Spacer(),
              ElevatedButton(
                onPressed: _currentOtp.length == 4 && !_isVerifying ? _verifyOtp : null,
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textInverse),
                      )
                    : const Text('Confirm'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    ),);
  }
}
