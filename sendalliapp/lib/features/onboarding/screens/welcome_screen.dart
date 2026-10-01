import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../widgets/guest_tracking_sheet.dart';
import '../../dashboard/screens/receiver_home_screen.dart';
import 'name_input_screen.dart';
import 'phone_input_screen.dart';

/// Clean, modern Welcome & Gateway Screen.
/// Provides:
/// 1. Outside instant Receiver tracking (Zero login required).
/// 2. Interactive "Choose / Login As" role selector with Quick Onboarding.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UserRole _selectedRole = UserRole.sender;

  String get _roleTitle {
    switch (_selectedRole) {
      case UserRole.sender:
        return 'Sender / Merchant';
      case UserRole.rider:
        return 'Keke Rider';
      case UserRole.hub:
        return 'Drop Hub Partner';
      case UserRole.receiver:
        return 'Receiver';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Brand mark & hero banner
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        FeatherIcons.package,
                        size: 34,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'SENDALLI',
                      style: AppTextStyles.h1.copyWith(
                        letterSpacing: 2,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Corridor Parcel Logistics • Warri & Effurun',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SECTION 1: OUTSIDE RECEIVER ENTRANCE (NO LOGIN)
              _buildReceiverSection(),
              const SizedBox(height: 24),

              // SECTION 2: CHOOSE / LOGIN AS OPERATOR (QUICK ONBOARDING)
              _buildOperatorSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Outside instant Receiver tracking with zero login
  Widget _buildReceiverSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(FeatherIcons.package, size: 18, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Receiving a Parcel?',
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'No account or login required',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => GuestTrackingSheet.show(context),
                  icon: const Icon(FeatherIcons.search, size: 15, color: AppColors.textPrimary),
                  label: const Text('Track by ID'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(42),
                    padding: EdgeInsets.zero,
                    textStyle: AppTextStyles.button.copyWith(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReceiverHomeScreen(
                          user: UserProfile.guestReceiver(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(FeatherIcons.mapPin, size: 15, color: AppColors.textPrimary),
                  label: const Text('Receiver Portal'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(42),
                    padding: EdgeInsets.zero,
                    textStyle: AppTextStyles.button.copyWith(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Operator section: choose role to log in or quick-onboard
  Widget _buildOperatorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.border, height: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'CHOOSE ROLE TO ENTER',
                style: AppTextStyles.caption.copyWith(
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.border, height: 1)),
          ],
        ),
        const SizedBox(height: 16),

        // 3 Interactive Role Selector Cards
        Row(
          children: [
            Expanded(
              child: _buildRoleCard(
                role: UserRole.sender,
                icon: FeatherIcons.shoppingBag,
                title: 'Merchant',
                desc: 'Send items',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRoleCard(
                role: UserRole.rider,
                icon: FeatherIcons.navigation,
                title: 'Rider',
                desc: 'Earn on route',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRoleCard(
                role: UserRole.hub,
                icon: FeatherIcons.home,
                title: 'Drop Hub',
                desc: '₦500 / parcel',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Contextual Quick Onboard Button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NameInputScreen(targetRole: _selectedRole),
              ),
            );
          },
          child: Text('Quick Onboard as $_roleTitle'),
        ),
        const SizedBox(height: 10),

        // Direct Login Button
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PhoneInputScreen(isReturningLogin: true),
              ),
            );
          },
          child: Text('Sign In as $_roleTitle • Phone & PIN'),
        ),
      ],
    );
  }

  /// Compact interactive role selector card
  Widget _buildRoleCard({
    required UserRole role,
    required IconData icon,
    required String title,
    required String desc,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                color: isSelected ? AppColors.primaryDark : AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
