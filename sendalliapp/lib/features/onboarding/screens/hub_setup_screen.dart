import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/constants/corridor_constants.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/form_randomizer.dart';
import '../../../widgets/map/sendalli_map_view.dart';
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
  final _emailController = TextEditingController();
  String _selectedCorridor = CorridorConstants.pilotCorridors.first;
  String _selectedCapacity = '20-50 Parcels';
  bool _isLoading = false;

  final List<String> _capacities = [
    '10-20 Parcels',
    '20-50 Parcels',
    '50+ Parcels',
  ];

  void _randomize() {
    setState(() {
      _storeNameController.text = FormSampleData.randomHubStore();
      _emailController.text = FormSampleData.randomEmail(widget.firstName);
      _landmarkController.text = FormSampleData.randomLandmark();
      _selectedCorridor = FormSampleData.randomCorridor();
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _landmarkController.dispose();
    _emailController.dispose();
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
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      shopName: store,
      corridor: _selectedCorridor,
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
        appBar: CustomAppBar(
          title: 'Drop Hub Setup',
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
                const SizedBox(height: 6),
                Text(
                  'Add your roadside shop details to start receiving parcel drop-offs and earning custody fees.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 20),

                // Hub Partner Preview Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primaryLight,
                        child: const Icon(FeatherIcons.home, color: AppColors.primaryDark, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _storeNameController.text.isNotEmpty
                                  ? _storeNameController.text
                                  : "Roadside Hub Store",
                              style: AppTextStyles.h3,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Verified Roadside Holding Partner',
                              style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.eliteGoldLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.eliteGold.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '₦500 / HOLD',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.eliteGold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Corridor Route Map Preview
                Text('Corridor Hub Location', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SendalliMapView(
                    height: 125,
                    corridorName: _selectedCorridor,
                    showLiveRider: false,
                  ),
                ),
                const SizedBox(height: 20),

                // Form Inputs Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _storeNameController,
                        labelText: 'Shop / Pharmacy Name',
                        hintText: 'e.g. City Care Pharmacy & Stores',
                        textCapitalization: TextCapitalization.words,
                        prefixIcon: FeatherIcons.home,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      // Corridor Dropdown
                      CustomDropdownField<String>(
                        labelText: 'Corridor Route',
                        value: _selectedCorridor,
                        prefixIcon: FeatherIcons.navigation,
                        items: CorridorConstants.pilotCorridors.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCorridor = val);
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _landmarkController,
                        labelText: 'Roadside Landmark',
                        hintText: 'e.g. PTI Road, opposite First Gate',
                        textCapitalization: TextCapitalization.words,
                        prefixIcon: FeatherIcons.mapPin,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email Address (for Invoices & Holding Fees)',
                        hintText: 'e.g. hub@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: FeatherIcons.mail,
                      ),
                      const SizedBox(height: 16),

                      // Holding Capacity
                      Text('Holding Capacity', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _capacities.map((cap) {
                          final isSelected = _selectedCapacity == cap;
                          return ChoiceChip(
                            label: Text(cap),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedCapacity = cap);
                            },
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surfaceSubtle,
                            labelStyle: AppTextStyles.caption.copyWith(
                              color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.border,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _completeSetup,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textInverse),
                          )
                        : const Text('Complete & Register Hub'),
                  ),
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
