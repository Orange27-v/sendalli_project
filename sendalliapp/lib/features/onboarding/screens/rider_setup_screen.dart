import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/corridor_constants.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/form_randomizer.dart';
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
  String _selectedCorridor = CorridorConstants.pilotCorridors.first;
  bool _selfieCaptured = true; // Default simulated capture for quick onboarding
  bool _isLoading = false;

  void _randomize() {
    setState(() {
      _plateController.text = FormSampleData.randomPlateNumber();
      _selectedCorridor = FormSampleData.randomCorridor();
      _parkController.text = FormSampleData.randomPark();
      _selfieCaptured = true;
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    _parkController.dispose();
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(FeatherIcons.arrowLeft),
            onPressed: () => AppNavigator.safePop(context),
          ),
          title: Text('Rider Setup', style: AppTextStyles.caption.copyWith(fontSize: 13)),
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
              const SizedBox(height: 8),
              Text(
                'Add your vehicle details and your usual route to get delivery jobs.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Driver Photo Preview (Onboarding-8 / Onboarding-9)
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.surfaceSubtle,
                          child: Icon(
                            _selfieCaptured ? FeatherIcons.checkCircle : FeatherIcons.user,
                            size: 40,
                            color: _selfieCaptured ? AppColors.deepGreen : AppColors.textPrimary,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(FeatherIcons.camera, color: AppColors.textInverse, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Driver Profile Photo (Active)', style: AppTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Plate Number
              CustomTextField(
                controller: _plateController,
                labelText: 'Tricycle Plate Number',
                hintText: 'e.g. WRA-492-XA',
                textCapitalization: TextCapitalization.characters,
                prefixIcon: FeatherIcons.hash,
              ),
              const SizedBox(height: 18),

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
              const SizedBox(height: 18),

              // Union Park Name
              CustomTextField(
                controller: _parkController,
                labelText: 'Home Keke Park / Chairman',
                hintText: 'e.g. Refinery Junction Unit Park',
                textCapitalization: TextCapitalization.words,
                prefixIcon: FeatherIcons.users,
              ),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: _isLoading ? null : _completeSetup,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
                      )
                    : const Text('Complete & Start Earning'),
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
