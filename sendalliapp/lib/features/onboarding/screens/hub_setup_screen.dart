import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/form_randomizer.dart';
import '../../../widgets/permission_dialog.dart';
import '../../../widgets/profile_completed_dialog.dart';
import '../../dashboard/screens/hub/hub_home_screen.dart';

/// Branch C: Drop Hub Partner Setup Screen.
class HubSetupScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String pin;

  const HubSetupScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.pin,
  });

  @override
  State<HubSetupScreen> createState() => _HubSetupScreenState();
}

class _HubSetupScreenState extends State<HubSetupScreen> {
  final _storeNameController = TextEditingController();
  final _landmarkController = TextEditingController();
  bool _isLoading = false;

  void _randomize() {
    _storeNameController.text = FormSampleData.randomHubStore();
    _landmarkController.text = FormSampleData.randomLandmark();
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _completeSetup() async {
    final store = _storeNameController.text.trim();
    if (store.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your store or chemist name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Request Notification permission contextually (Modal - Location-1.png)
    await PermissionDialog.show(
      context: context,
      icon: FeatherIcons.bell,
      title: 'Turn on Notifications',
      description: 'Get a message when a rider is coming to drop off a parcel at your shop.',
      primaryButtonText: 'Allow Notifications',
    );

    final user = UserProfile(
      id: 'HUB-${DateTime.now().millisecondsSinceEpoch}',
      firstName: widget.firstName,
      lastName: widget.lastName,
      phone: widget.phoneNumber,
      role: UserRole.hub,
      pin: widget.pin,
      shopName: store,
      landmark: _landmarkController.text.trim().isNotEmpty
          ? _landmarkController.text.trim()
          : 'Opposite PTI First Gate',
      isVerified: true,
    );

    await SessionManager.saveUserProfile(user);

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Celebration modal (Modal - Location-2.png)
    ProfileCompletedDialog.show(
      context: context,
      subtitle: 'Your Drop Hub is set up! You can now earn ₦500 for each parcel you hold.',
      onContinue: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HubHomeScreen(user: user)),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        AppNavigator.safePop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(FeatherIcons.arrowLeft),
            onPressed: () => AppNavigator.safePop(context),
          ),
          title: const Text('Drop Hub Setup'),
          actions: [
            RandomizeButton(onRandomize: _randomize),
          ],
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Store & Location', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Add your store details to start earning as a parcel drop-off point.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _storeNameController,
                labelText: 'Shop / Pharmacy Name',
                hintText: 'e.g. City Care Pharmacy & Stores',
                textCapitalization: TextCapitalization.words,
                prefixIcon: FeatherIcons.home,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _landmarkController,
                labelText: 'Roadside Landmark',
                hintText: 'e.g. PTI Road, opposite First Gate',
                textCapitalization: TextCapitalization.words,
                prefixIcon: FeatherIcons.mapPin,
              ),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: _isLoading ? null : _completeSetup,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textInverse),
                      )
                    : const Text('Complete & Register Hub'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );
}
}
