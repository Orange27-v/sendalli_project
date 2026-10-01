import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/corridor_constants.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../../widgets/permission_dialog.dart';
import '../../../widgets/profile_completed_dialog.dart';
import '../../dashboard/screens/receiver_home_screen.dart';

/// Branch D: Receiver Setup Screen.
class ReceiverSetupScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String pin;

  const ReceiverSetupScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.pin,
  });

  @override
  State<ReceiverSetupScreen> createState() => _ReceiverSetupScreenState();
}

class _ReceiverSetupScreenState extends State<ReceiverSetupScreen> {
  String _selectedCorridor = CorridorConstants.pilotCorridors.first;
  String _selectedLandmark = CorridorConstants.refineryJakpaLandmarks.last; // Jakpa Junction
  bool _isLoading = false;

  Future<void> _completeSetup() async {
    setState(() => _isLoading = true);

    // Request Notification permission contextually (Modal - Location-1.png)
    await PermissionDialog.show(
      context: context,
      icon: Icons.notifications_active_outlined,
      title: 'Turn on Notifications',
      description: 'Receive real-time arrival countdowns whenever a parcel is sent to your phone number.',
      primaryButtonText: 'Turn On Notifications',
    );

    final user = UserProfile(
      id: 'RCV-${DateTime.now().millisecondsSinceEpoch}',
      firstName: widget.firstName,
      lastName: widget.lastName,
      phone: widget.phoneNumber,
      role: UserRole.receiver,
      pin: widget.pin,
      corridor: _selectedCorridor,
      landmark: _selectedLandmark,
      isVerified: true,
    );

    await SessionManager.saveUserProfile(user);

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Display profile completed modal (Modal - Location-2.png)
    ProfileCompletedDialog.show(
      context: context,
      subtitle: 'Your receiver account is ready. Any parcel sent to ${widget.phoneNumber} will appear on your dashboard!',
      onContinue: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => ReceiverHomeScreen(user: user)),
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
        title: Text('Receiver Profile', style: AppTextStyles.caption.copyWith(fontSize: 13)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Preferred Drop Point', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Select your frequent transit corridor and roadside stop so drivers know where to meet you.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Corridor Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCorridor,
                decoration: const InputDecoration(
                  labelText: 'Primary Transit Corridor',
                  prefixIcon: Icon(Icons.alt_route_rounded, color: AppColors.primaryDark),
                ),
                items: CorridorConstants.pilotCorridors.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCorridor = val);
                },
              ),
              const SizedBox(height: 20),

              // Landmark Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedLandmark,
                decoration: const InputDecoration(
                  labelText: 'Frequent Roadside Landmark',
                  prefixIcon: Icon(Icons.pin_drop_outlined, color: AppColors.primaryDark),
                ),
                items: CorridorConstants.refineryJakpaLandmarks.map((l) {
                  return DropdownMenuItem(value: l, child: Text(l, style: AppTextStyles.bodyMedium));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedLandmark = val);
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _completeSetup,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
                      )
                    : const Text('Complete & Start Tracking'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
