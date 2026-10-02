import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/models/user_role.dart';
import '../../../../core/storage/session_manager.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../onboarding/screens/welcome_screen.dart';
import '../../../onboarding/screens/terms_and_conditions_screen.dart';

/// Classy, comprehensive Settings screen tailored to each Sendalli user role.
class SettingsScreen extends StatefulWidget {
  final UserProfile user;

  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Preference toggles
  bool _pushNotifications = true;
  bool _smsArrivalAlerts = true;
  bool _whatsappUpdates = false;
  bool _biometricLogin = true;
  bool _autoAcceptNearby = false;
  bool _audioChime = true;

  late String _selectedLandmark;

  final List<String> _corridorLandmarks = [
    'PTI Junction, Warri',
    'Effurun Roundabout, Delta',
    'Jakpa Junction',
    'Enerhen Junction',
    'Refinery Road Depot',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLandmark = widget.user.landmark ?? _corridorLandmarks.first;
    if (!_corridorLandmarks.contains(_selectedLandmark)) {
      _corridorLandmarks.insert(0, _selectedLandmark);
    }
  }

  void _showChangePinDialog() {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Security PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your current 4-digit PIN followed by your new PIN:'),
            const SizedBox(height: 12),
            TextField(
              controller: oldPinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current PIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newPinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New 4-Digit PIN',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Security PIN successfully updated.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Update PIN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Settings'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: AppDimens.screenInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Notification Preferences
              _buildSectionTitle('NOTIFICATIONS & ALERTS'),
              _buildCardContainer([
                _buildSwitchTile(
                  icon: FeatherIcons.bell,
                  title: 'Push Notifications',
                  subtitle: 'Real-time transit updates and corridor pings',
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                const Divider(color: AppColors.border, height: 1),
                _buildSwitchTile(
                  icon: FeatherIcons.messageSquare,
                  title: 'Roadside SMS Arrival Alerts',
                  subtitle: 'High-priority SMS when rider is within 3 minutes',
                  value: _smsArrivalAlerts,
                  onChanged: (val) => setState(() => _smsArrivalAlerts = val),
                ),
                const Divider(color: AppColors.border, height: 1),
                _buildSwitchTile(
                  icon: FeatherIcons.phoneCall,
                  title: 'WhatsApp Status Updates',
                  subtitle: 'Automated receipt and handover confirmations',
                  value: _whatsappUpdates,
                  onChanged: (val) => setState(() => _whatsappUpdates = val),
                ),
              ]),
              const SizedBox(height: 20),

              // 2. Corridor & Waypoint Preferences
              _buildSectionTitle('CORRIDOR PREFERENCES'),
              _buildCardContainer([
                ListTile(
                  leading: const Icon(FeatherIcons.mapPin, color: AppColors.primary, size: 20),
                  title: const Text('Primary Roadside Landmark'),
                  subtitle: Text(_selectedLandmark, style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  trailing: const Icon(FeatherIcons.chevronRight, size: 18, color: AppColors.textMuted),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text('Select Default Landmark', style: AppTextStyles.h3),
                            ),
                            ..._corridorLandmarks.map(
                              (landmark) => ListTile(
                                leading: Icon(
                                  landmark == _selectedLandmark ? FeatherIcons.checkCircle : FeatherIcons.circle,
                                  color: landmark == _selectedLandmark ? AppColors.primary : AppColors.textMuted,
                                ),
                                title: Text(landmark),
                                onTap: () {
                                  setState(() => _selectedLandmark = landmark);
                                  Navigator.pop(ctx);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (widget.user.role == UserRole.rider) ...[
                  const Divider(color: AppColors.border, height: 1),
                  _buildSwitchTile(
                    icon: FeatherIcons.zap,
                    title: 'Auto-Accept Nearby Corridor Trips',
                    subtitle: 'Automatically receive jobs along current travel route',
                    value: _autoAcceptNearby,
                    onChanged: (val) => setState(() => _autoAcceptNearby = val),
                  ),
                  const Divider(color: AppColors.border, height: 1),
                  _buildSwitchTile(
                    icon: FeatherIcons.volume2,
                    title: 'Audio Navigation Chime',
                    subtitle: 'Spoken warnings for 1-minute roadside countdowns',
                    value: _audioChime,
                    onChanged: (val) => setState(() => _audioChime = val),
                  ),
                ],
              ]),
              const SizedBox(height: 20),

              // 3. Security & PIN
              _buildSectionTitle('SECURITY & PRIVACY'),
              _buildCardContainer([
                ListTile(
                  leading: const Icon(FeatherIcons.lock, color: AppColors.primary, size: 20),
                  title: const Text('Change 4-Digit Security PIN'),
                  subtitle: const Text('Required for wallet withdrawals and identity auth'),
                  trailing: const Icon(FeatherIcons.chevronRight, size: 18, color: AppColors.textMuted),
                  onTap: _showChangePinDialog,
                ),
                const Divider(color: AppColors.border, height: 1),
                _buildSwitchTile(
                  icon: FeatherIcons.shield,
                  title: 'Biometric Login',
                  subtitle: 'Unlock app quickly with Face ID or Fingerprint',
                  value: _biometricLogin,
                  onChanged: (val) => setState(() => _biometricLogin = val),
                ),
              ]),
              const SizedBox(height: 20),

              // 4. Support & Compliance
              _buildSectionTitle('SUPPORT & LEGAL'),
              _buildCardContainer([
                ListTile(
                  leading: const Icon(FeatherIcons.helpCircle, color: AppColors.primary, size: 20),
                  title: const Text('Dispute & Emergency Corridor Desk'),
                  subtitle: const Text('Direct resolution for roadside delays and escrow claims'),
                  trailing: const Icon(FeatherIcons.chevronRight, size: 18, color: AppColors.textMuted),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dispute desk opened. Support available 24/7.'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
                const Divider(color: AppColors.border, height: 1),
                ListTile(
                  leading: const Icon(FeatherIcons.fileText, color: AppColors.primary, size: 20),
                  title: const Text('Terms of Roadside Transit'),
                  trailing: const Icon(FeatherIcons.chevronRight, size: 18, color: AppColors.textMuted),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TermsAndConditionsScreen(isViewOnly: true),
                      ),
                    );
                  },
                ),
                const Divider(color: AppColors.border, height: 1),
                ListTile(
                  leading: const Icon(FeatherIcons.info, color: AppColors.primary, size: 20),
                  title: const Text('Sendalli Version'),
                  trailing: Text('v1.0.0 (Warri Launch)', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 24),

              // 5. Sign Out
              OutlinedButton.icon(
                onPressed: () async {
                  await SessionManager.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(FeatherIcons.logOut, size: 16, color: AppColors.danger),
                label: Text('Sign Out of Account', style: AppTextStyles.button.copyWith(color: AppColors.danger)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.danger, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
      trailing: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 24,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: value ? AppColors.primary : AppColors.border,
          ),
          child: Align(
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
