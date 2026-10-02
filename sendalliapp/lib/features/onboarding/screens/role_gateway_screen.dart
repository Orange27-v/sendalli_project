import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_role.dart';
import '../../../core/navigation/app_navigator.dart';
import 'name_input_screen.dart';
import 'phone_input_screen.dart';

/// Dedicated, spacious Role Gateway Screen.
/// Navigated from the Welcome Screen to allow users to select their operator role
/// in an uncluttered, focused environment.
class RoleGatewayScreen extends StatefulWidget {
  final UserRole initialRole;

  const RoleGatewayScreen({
    super.key,
    this.initialRole = UserRole.sender,
  });

  @override
  State<RoleGatewayScreen> createState() => _RoleGatewayScreenState();
}

class _RoleGatewayScreenState extends State<RoleGatewayScreen> {
  late UserRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
  }

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

  void _proceedToRegistration() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NameInputScreen(targetRole: _selectedRole),
      ),
    );
  }

  void _proceedToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhoneInputScreen(
          isReturningLogin: true,
          targetRole: _selectedRole,
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
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(FeatherIcons.arrowLeft, size: 20),
            onPressed: () => AppNavigator.safePop(context),
          ),
          title: Text(
            'Choose Role',
            style: AppTextStyles.caption.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Illustration (take-out-boxes.svg in brand green)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SvgPicture.asset(
                    'assets/svg/take-out-boxes.svg',
                    height: 120,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Text('How will you use Sendalli?', style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text(
                'Select your operator profile. Receivers track directly without an account.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Role Card 1: Sender / Merchant
              _buildRoleOptionCard(
                role: UserRole.sender,
                icon: FeatherIcons.shoppingBag,
                title: 'Merchant / Sender',
                badgeText: 'Send Parcels',
                description: 'I run a market stall, pharmacy, boutique, or need parcels delivered along the corridor.',
              ),
              const SizedBox(height: 12),

              // Role Card 2: Keke Rider
              _buildRoleOptionCard(
                role: UserRole.rider,
                icon: FeatherIcons.navigation,
                title: 'Keke / Dispatch Rider',
                badgeText: 'Earn on Route',
                description: 'Deliver parcels while traveling your regular passenger route between Warri and Effurun.',
              ),
              const SizedBox(height: 12),

              // Role Card 3: Drop Hub Partner
              _buildRoleOptionCard(
                role: UserRole.hub,
                icon: FeatherIcons.home,
                title: 'Drop Hub Partner',
                badgeText: '₦500 / parcel',
                description: 'Monetize your roadside store, kiosk, or pharmacy as a safe parcel drop-off and pickup point.',
              ),
              const SizedBox(height: 28),

              // Contextual Quick Onboard Button (Sendalli Default Lime)
              ElevatedButton.icon(
                onPressed: _proceedToRegistration,
                icon: const Icon(FeatherIcons.arrowRight, size: 16, color: AppColors.textPrimary),
                label: Text('Quick Onboard as $_roleTitle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              const SizedBox(height: 10),

              // Direct Login Button
              OutlinedButton(
                onPressed: _proceedToLogin,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: AppColors.borderMedium, width: 1.2),
                ),
                child: Text('Sign In as $_roleTitle • Phone & PIN'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),);
  }

  Widget _buildRoleOptionCard({
    required UserRole role,
    required IconData icon,
    required String title,
    required String badgeText,
    required String description,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primaryDark : AppColors.border,
                  width: 1.0,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.surface : AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryDark : AppColors.border,
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          badgeText,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Radio Circle Selector
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primaryDark : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primaryDark : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
