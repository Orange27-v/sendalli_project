import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/corridor_constants.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../widgets/permission_dialog.dart';
import '../widgets/profile_completed_dialog.dart';
import '../../dashboard/screens/rider_home_screen.dart';

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
  final bool _selfieCaptured = true; // Default simulated capture for quick onboarding
  bool _isLoading = false;

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
      icon: Icons.location_on_outlined,
      title: 'Share your Location',
      description: 'Sendalli needs your location to broadcast orders matching your active transit corridor in real-time.',
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
      subtitle: 'Your Rider profile is approved with a starting Trust Score of 80% (Pioneer Verified).',
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
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Rider Vetting', style: AppTextStyles.caption.copyWith(fontSize: 13)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle & Corridor', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Register your vehicle details and main route to receive corridor delivery broadcasts.',
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
                          backgroundColor: AppColors.primaryLight,
                          child: Icon(
                            _selfieCaptured ? Icons.check_circle_rounded : Icons.person_rounded,
                            size: 48,
                            color: AppColors.primary,
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
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
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
              TextField(
                controller: _plateController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Tricycle Plate Number',
                  hintText: 'e.g. WRA-492-XA',
                  prefixIcon: Icon(Icons.pin_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Corridor Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCorridor,
                decoration: const InputDecoration(
                  labelText: 'Primary Corridor',
                  prefixIcon: Icon(Icons.alt_route_rounded, color: AppColors.primary),
                ),
                items: CorridorConstants.pilotCorridors.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCorridor = val);
                },
              ),
              const SizedBox(height: 16),

              // Union Park Name
              TextField(
                controller: _parkController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Home Keke Park / Chairman',
                  hintText: 'e.g. Refinery Junction Unit Park',
                  prefixIcon: Icon(Icons.groups_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: _isLoading ? null : _completeSetup,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Complete & Start Earning'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
