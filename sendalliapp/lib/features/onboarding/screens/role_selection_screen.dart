import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_role.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../widgets/custom_app_bar.dart';
import 'sender_setup_screen.dart';
import 'rider_setup_screen.dart';
import 'hub_setup_screen.dart';

/// Screen 6: Role Selection "How will you use Sendalli?" (Onboarding-10.png).
/// Note: Receivers access Sendalli without account login from the Welcome Gateway.
class RoleSelectionScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String pin;

  const RoleSelectionScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.pin,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.sender;

  void _proceed() {
    switch (_selectedRole) {
      case UserRole.sender:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SenderSetupScreen(
              phoneNumber: widget.phoneNumber,
              firstName: widget.firstName,
              lastName: widget.lastName,
              pin: widget.pin,
            ),
          ),
        );
        break;
      case UserRole.rider:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RiderSetupScreen(
              phoneNumber: widget.phoneNumber,
              firstName: widget.firstName,
              lastName: widget.lastName,
              pin: widget.pin,
            ),
          ),
        );
        break;
      case UserRole.hub:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HubSetupScreen(
              phoneNumber: widget.phoneNumber,
              firstName: widget.firstName,
              lastName: widget.lastName,
              pin: widget.pin,
            ),
          ),
        );
        break;
      case UserRole.receiver:
        // Receivers enter directly from outside without account creation
        break;
    }
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
          title: 'Account Setup',
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How will you use Sendalli?', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Select your primary operator role. Receivers do not need an account and can track directly.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 20),

              // 3 Selectable Operator Role Cards
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildRoleCard(
                        role: UserRole.sender,
                        icon: FeatherIcons.shoppingBag,
                        title: 'Send Parcels',
                        subtitle: 'I run a shop, market stall, or want to send items across town.',
                      ),
                      const SizedBox(height: 14),
                      _buildRoleCard(
                        role: UserRole.rider,
                        icon: FeatherIcons.navigation,
                        title: 'Deliver Along Route (Rider)',
                        subtitle: 'I drive a keke or minibus and want to earn extra on my regular trips.',
                      ),
                      const SizedBox(height: 14),
                      _buildRoleCard(
                        role: UserRole.hub,
                        icon: FeatherIcons.home,
                        title: 'Roadside Drop Hub Partner',
                        subtitle: 'I operate a roadside store or chemist and want to earn fees holding packages.',
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _proceed,
                child: const Text('Continue'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    ),);
  }

  Widget _buildRoleCard({
    required UserRole role,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.deepGreen : AppColors.border,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.deepGreenLight : AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.deepGreen : AppColors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? AppColors.textSecondary : AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.deepGreen : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.deepGreen : AppColors.border,
                  width: 1.8,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(FeatherIcons.check, size: 13, color: Colors.white),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
