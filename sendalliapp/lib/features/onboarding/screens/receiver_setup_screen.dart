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
import '../../../widgets/form_randomizer.dart';
import '../../../widgets/map/sendalli_map_view.dart';
import '../../../widgets/permission_dialog.dart';
import '../../../widgets/profile_completed_dialog.dart';
import '../../../widgets/settings_kit.dart';
import '../../dashboard/screens/receiver/receiver_home_screen.dart';

/// Branch D: Receiver Setup Screen — Clean Nelo UI Design Flow.
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
  bool _notificationsEnabled = true;
  bool _isLoading = false;

  void _randomize() {
    setState(() {
      _selectedCorridor = FormSampleData.randomCorridor();
      _selectedLandmark = FormSampleData.randomLandmark();
      _notificationsEnabled = true;
    });
  }

  Future<void> _completeSetup() async {
    setState(() => _isLoading = true);

    if (_notificationsEnabled) {
      // Request Notification permission contextually (Modal - Location-1.png)
      await PermissionDialog.show(
        context: context,
        icon: FeatherIcons.bell,
        title: 'Turn on Notifications',
        description: 'Receive real-time arrival countdowns whenever a parcel is sent to your phone number.',
        primaryButtonText: 'Turn On Notifications',
      );
    }

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        AppNavigator.safePop(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: 'Receiver Setup',
          actions: [
            RandomizeButton(onRandomize: _randomize),
          ],
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Delivery Preferences',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 26,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your transit corridor and roadside stop for seamless, zero-detour parcel handovers.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),

              // Group 1: Transit & Corridor Selection
              SettingsGroup(
                label: 'Transit Corridor & Roadside Stop',
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const IconTile(
                          icon: FeatherIcons.map,
                          tone: AppColors.primaryDark,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedCorridor,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              items: CorridorConstants.pilotCorridors.map((c) {
                                return DropdownMenuItem(value: c, child: Text(c));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedCorridor = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const IconTile(
                          icon: FeatherIcons.mapPin,
                          tone: AppColors.primaryDark,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedLandmark,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              items: CorridorConstants.refineryJakpaLandmarks.map((l) {
                                return DropdownMenuItem(value: l, child: Text(l));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedLandmark = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Roadside Stop Map Preview
              Text('Roadside Corridor Map', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
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
                  corridorName: '$_selectedCorridor • $_selectedLandmark',
                  showLiveRider: true,
                ),
              ),
              const SizedBox(height: 24),

              // Group 2: Notifications & Alerts
              SettingsGroup(
                label: 'Real-time Alerts',
                children: [
                  SettingsSwitchRow(
                    icon: FeatherIcons.bell,
                    title: 'Live Arrival Alerts',
                    description: 'Receive audio & push notifications when keke riders are 10 minutes away.',
                    accent: AppColors.primaryDark,
                    value: _notificationsEnabled,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Group 3: Quiet Information Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(kDefaultCardRadius),
                  border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconTile(
                      icon: FeatherIcons.refreshCw,
                      tone: AppColors.primaryDark,
                      size: 32,
                      iconSize: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Automatic Parcel Linking',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Any merchant in Warri or Effurun sending to ${widget.phoneNumber} will automatically appear in your active shipments.',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Primary Action
              ElevatedButton(
                onPressed: _isLoading ? null : _completeSetup,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textInverse),
                      )
                    : const Text('Complete & Start Tracking'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
}

