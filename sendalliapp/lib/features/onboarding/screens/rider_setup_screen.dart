import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/corridor_constants.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/form_randomizer.dart';
import '../../../widgets/map/sendalli_map_view.dart';
import '../../../widgets/permission_dialog.dart';
import '../../../widgets/profile_completed_dialog.dart';
import '../../dashboard/screens/rider/rider_home_screen.dart';

/// Branch B: Rider Vetting & Vehicle Setup Screen (Onboarding-8.png / Onboarding-9.png).
class RiderSetupScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String pin;

  const RiderSetupScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.pin,
  });

  @override
  State<RiderSetupScreen> createState() => _RiderSetupScreenState();
}

class _RiderSetupScreenState extends State<RiderSetupScreen> {
  final _plateController = TextEditingController();
  final _parkController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedCorridor = CorridorConstants.pilotCorridors.first;
  bool _selfieCaptured = true; // Default simulated capture for quick onboarding
  bool _isLoading = false;

  void _randomize() {
    setState(() {
      _plateController.text = FormSampleData.randomPlateNumber();
      _emailController.text = FormSampleData.randomEmail(widget.firstName);
      _selectedCorridor = FormSampleData.randomCorridor();
      _parkController.text = FormSampleData.randomPark();
      _selfieCaptured = true;
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    _parkController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _completeSetup() async {
    final plate = _plateController.text.trim().toUpperCase();
    if (plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Tricycle / Minibus plate number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Request Location permission contextually (Modal - Location-3.png)
    await PermissionDialog.show(
      context: context,
      icon: FeatherIcons.mapPin,
      title: 'Share your Location',
      description: 'We need your location to send you nearby delivery jobs.',
      primaryButtonText: 'Allow Location Access',
    );

    final user = UserProfile(
      id: 'RDR-${DateTime.now().millisecondsSinceEpoch}',
      firstName: widget.firstName,
      lastName: widget.lastName,
      phone: widget.phoneNumber,
      role: UserRole.rider,
      pin: widget.pin,
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      trustScore: 80, // Autonomous baseline score
      vehiclePlate: plate,
      corridor: _selectedCorridor,
      unionPark: _parkController.text.trim().isNotEmpty
          ? _parkController.text.trim()
          : 'Refinery Junction Keke Park',
      isVerified: true,
    );

    await SessionManager.saveUserProfile(user);

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Celebration modal (Modal - Location-2.png)
    ProfileCompletedDialog.show(
      context: context,
      subtitle: 'Your Rider account is ready! You start with a Trust Score of 80%.',
      onContinue: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => RiderHomeScreen(user: user)),
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
          title: 'Rider Setup',
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
              Text('Your Vehicle & Route', style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text(
                'Add your tricycle details and regular route to receive parcel delivery jobs along your corridor.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Driver Card with Baseline Trust
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            widget.firstName.isNotEmpty ? widget.firstName[0].toUpperCase() : 'R',
                            style: AppTextStyles.h2.copyWith(color: AppColors.primaryDark),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _selfieCaptured ? AppColors.primary : AppColors.textMuted,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _selfieCaptured ? FeatherIcons.check : FeatherIcons.camera,
                              color: AppColors.textInverse,
                              size: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.firstName} ${widget.lastName}', style: AppTextStyles.h3),
                          const SizedBox(height: 2),
                          Text('Commercial Corridor Operator', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.eliteGoldLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.eliteGold.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(FeatherIcons.shield, size: 12, color: AppColors.eliteGold),
                          const SizedBox(width: 4),
                          Text(
                            '80% Trust',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.eliteGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Corridor Route Map Preview
              Text('Corridor Route Coverage', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                ),
                clipBehavior: Clip.antiAlias,
                child: SendalliMapView(
                  height: 130,
                  corridorName: _selectedCorridor,
                  showLiveRider: true,
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
                  children: [
                    // Plate Number
                    CustomTextField(
                      controller: _plateController,
                      labelText: 'Tricycle Plate Number',
                      hintText: 'e.g. WRA-492-XA',
                      textCapitalization: TextCapitalization.characters,
                      prefixIcon: FeatherIcons.hash,
                    ),
                    const SizedBox(height: 16),

                    // Corridor Dropdown
                    CustomDropdownField<String>(
                      labelText: 'Primary Corridor',
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

                    // Union Park Name
                    CustomTextField(
                      controller: _parkController,
                      labelText: 'Home Keke Park / Chairman',
                      hintText: 'e.g. Refinery Junction Unit Park',
                      textCapitalization: TextCapitalization.words,
                      prefixIcon: FeatherIcons.users,
                    ),
                    const SizedBox(height: 16),

                    // Email Address
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address (for Payout Statements)',
                      hintText: 'e.g. rider@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: FeatherIcons.mail,
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
                      : const Text('Complete & Start Earning'),
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
