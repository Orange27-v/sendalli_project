import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../../widgets/permission_dialog.dart';
import '../../../widgets/profile_completed_dialog.dart';
import '../../dashboard/screens/sender_home_screen.dart';

/// Branch A: Sender / Merchant Setup Screen.
class SenderSetupScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String pin;

  const SenderSetupScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.pin,
  });

  @override
  State<SenderSetupScreen> createState() => _SenderSetupScreenState();
}

class _SenderSetupScreenState extends State<SenderSetupScreen> {
  final _shopNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _completeSetup() async {
    setState(() => _isLoading = true);

    // Request Notification permission contextually (Modal - Location-1.png)
    await PermissionDialog.show(
      context: context,
      icon: Icons.notifications_active_outlined,
      title: 'Turn on Notifications',
      description: 'Get real-time updates when a keke rider accepts and arrives with your parcel.',
      primaryButtonText: 'Turn On Notifications',
    );

    final shopName = _shopNameController.text.trim();
    final user = UserProfile(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      firstName: widget.firstName,
      lastName: widget.lastName,
      phone: widget.phoneNumber,
      role: UserRole.sender,
      pin: widget.pin,
      shopName: shopName.isNotEmpty ? shopName : '${widget.firstName}\'s Shop',
      isVerified: true,
    );

    await SessionManager.saveUserProfile(user);

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Display profile completed modal (Modal - Location-2.png)
    ProfileCompletedDialog.show(
      context: context,
      subtitle: 'Your merchant account is ready. Start sending parcels along Warri corridors!',
      onContinue: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => SenderHomeScreen(user: user)),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Merchant Profile', style: AppTextStyles.caption.copyWith(fontSize: 13)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Business Details', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Enter your shop or brand name so riders can identify you at the roadside pickup point.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _shopNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Shop / Business Name',
                  hintText: 'e.g. Warri Glow Boutique',
                  prefixIcon: Icon(Icons.storefront_outlined, color: AppColors.primary),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _completeSetup,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Complete & Start Sending'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
