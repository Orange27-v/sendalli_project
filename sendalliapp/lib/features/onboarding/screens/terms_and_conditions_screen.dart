import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_role.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../widgets/custom_app_bar.dart';
import 'name_input_screen.dart';

/// Terms and Conditions screen presented when onboarding/signing up for the first time.
///
/// Requires users to review key corridor operating rules, escrow safety terms,
/// and check the acceptance box to proceed with account creation.
class TermsAndConditionsScreen extends StatefulWidget {
  final UserRole? targetRole;
  final VoidCallback? onAccepted;
  final bool isViewOnly;

  const TermsAndConditionsScreen({
    super.key,
    this.targetRole,
    this.onAccepted,
    this.isViewOnly = false,
  });

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isAccepted = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (!_isAccepted && !widget.isViewOnly) return;

    if (widget.onAccepted != null) {
      widget.onAccepted!();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NameInputScreen(targetRole: widget.targetRole),
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
        backgroundColor: AppColors.surface,
        appBar: const CustomAppBar(
          title: 'Terms & Conditions',
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Scrollable Terms Content
              Expanded(
                child: SingleChildScrollView(
                  key: const Key('terms_scroll_view'),
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'CORRIDOR LOGISTICS AGREEMENT',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        'Sendalli Terms of Service',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Please review and accept our corridor operations protocol, escrow protection rules, and safety standards to continue.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 1: Corridor Operations
                      _buildSectionCard(
                        icon: FeatherIcons.navigation,
                        title: '1. Corridor Operations & Roadside Handover',
                        description:
                            'Sendalli operates along high-density transit corridors (e.g. Warri — Effurun, Delta State). All pickups, drop-offs, and transfers must take place at designated roadside junction markers or registered Drop Hubs. Deviations from authorized corridors are prohibited.',
                      ),
                      const SizedBox(height: 14),

                      // Section 2: 60-Second Stop Rule & Drop Hub Diversion
                      _buildSectionCard(
                        icon: FeatherIcons.clock,
                        title: '2. 60-Second Waiting Rule & Hub Diversion',
                        description:
                            'To maintain rapid transit speed along congested corridors, keke and minibus riders are held to a strict 1-minute roadside waiting window. If a receiver is unavailable after 60 seconds, the parcel is automatically rerouted to the nearest verified Drop Hub for secure safekeeping.',
                      ),
                      const SizedBox(height: 14),

                      // Section 3: Escrow & Dispute Resolution
                      _buildSectionCard(
                        icon: FeatherIcons.shield,
                        title: '3. Escrow Security & 30-Minute Inspection Window',
                        description:
                            'All delivery payments and holding fees are locked in escrow. Receivers have an automatic 30-minute inspection window upon delivery. Once verified or elapsed without dispute, funds are immediately credited to the rider and hub partner wallets.',
                      ),
                      const SizedBox(height: 14),

                      // Section 4: Dual Verification Security
                      _buildSectionCard(
                        icon: FeatherIcons.checkCircle,
                        title: '4. Mandatory QR Code & 4-Digit PIN Handover',
                        description:
                            'Every step of parcel transfer requires mutual cryptographic verification. Operators must scan the dynamic QR code or input the 4-digit verification PIN. Never release or receive a parcel without confirmed in-app completion.',
                      ),
                      const SizedBox(height: 14),

                      // Section 5: Prohibited Items & Safety Compliance
                      _buildSectionCard(
                        icon: FeatherIcons.alertTriangle,
                        title: '5. Prohibited Items & Roadside Safety',
                        description:
                            'Hazardous chemicals, illegal substances, unregistered firearms, and dangerous goods are strictly banned. Operators and senders are subject to immediate account termination and law enforcement reporting for violations.',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Acceptance & Action Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: const Border(top: BorderSide(color: AppColors.border, width: 1.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!widget.isViewOnly) ...[
                      // Checkbox acceptance row
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isAccepted = !_isAccepted;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  key: const Key('terms_accept_checkbox'),
                                  value: _isAccepted,
                                  onChanged: (val) {
                                    setState(() {
                                      _isAccepted = val ?? false;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'I have read, understood, and accept the Terms and Conditions, Corridor Protocol, and Escrow Safety Policy.',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 12.5,
                                    height: 1.35,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Accept and Continue Button (Pill shaped)
                    ElevatedButton(
                      key: const Key('terms_continue_button'),
                      onPressed: (_isAccepted || widget.isViewOnly) ? _handleContinue : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textInverse,
                        disabledBackgroundColor: AppColors.surfaceSubtle,
                        disabledForegroundColor: AppColors.textMuted,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.isViewOnly ? 'Back' : 'Accept & Continue',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          if (!widget.isViewOnly) ...[
                            const SizedBox(width: 8),
                            const Icon(FeatherIcons.arrowRight, size: 16),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
