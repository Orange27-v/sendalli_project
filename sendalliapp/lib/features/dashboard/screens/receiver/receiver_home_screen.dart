import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/form_randomizer.dart';
import '../../../../widgets/map/sendalli_map_view.dart';
import '../../../../widgets/settings_kit.dart';
import '../common/notifications_screen.dart';
import '../common/profile_screen.dart';
import '../common/settings_screen.dart';

/// Clean, simplified, and well-organized Receiver Tracking & Portal Screen.
/// Built with Nelo quiet aesthetics, zero elevation, and hairline borders.
class ReceiverHomeScreen extends StatefulWidget {
  final UserProfile user;

  const ReceiverHomeScreen({super.key, required this.user});

  @override
  State<ReceiverHomeScreen> createState() => _ReceiverHomeScreenState();
}

class _ReceiverHomeScreenState extends State<ReceiverHomeScreen> {
  final TextEditingController _trackingController = TextEditingController(text: 'SND-WAR-8492');
  String _activeTrackingId = 'SND-WAR-8492';
  bool _isDivertedToHub = false;

  bool get _isGuest => widget.user.id.startsWith('GUEST');

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  void _onTrackSubmitted() {
    final query = _trackingController.text.trim().toUpperCase();
    if (query.isNotEmpty) {
      setState(() => _activeTrackingId = query);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tracking parcel: $query'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _safeExit() {
    if (_isGuest) {
      AppNavigator.safePop(context);
    } else {
      AppNavigator.exitApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _safeExit();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          centerTitle: false,
          onLeadingPressed: _safeExit,
          title: 'Package Tracker',
          subtitle: _isGuest ? 'Roadside Guest Access • No login' : widget.user.fullName,
          actions: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(FeatherIcons.bell, size: 20, color: AppColors.textInverse),
                  tooltip: 'Notifications',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => NotificationsScreen(user: widget.user)),
                    );
                  },
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(FeatherIcons.user, size: 20, color: AppColors.textInverse),
              tooltip: 'Profile',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileScreen(user: widget.user)),
                );
              },
            ),
            IconButton(
              icon: const Icon(FeatherIcons.settings, size: 20, color: AppColors.textInverse),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SettingsScreen(user: widget.user)),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: AppDimens.screenInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Search / Track By ID Bar
                _buildTrackingSearchBar(),
                const SizedBox(height: 20),

                // 2. Active Parcel Card (Hero card)
                _buildActiveParcelCard(),
                const SizedBox(height: 18),

                // 3. Roadside Drop Hub Diversion Card
                _buildHubDiversionCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Compact, clean search bar with Sample ID generator
  Widget _buildTrackingSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Track A Parcel',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              RandomizeButton.inline(
                label: 'Sample ID',
                onRandomize: () {
                  final sample = FormSampleData.randomTrackingId();
                  _trackingController.text = sample;
                  setState(() => _activeTrackingId = sample);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _trackingController,
                  hintText: 'e.g. SND-WAR-8492',
                  textCapitalization: TextCapitalization.characters,
                  prefixIcon: FeatherIcons.search,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _onTrackSubmitted,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(60, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Track'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// High-contrast, clean Active Parcel Card
  Widget _buildActiveParcelCard() {
    final stop = widget.user.landmark ?? 'Jakpa Junction Roadside';
    final corridor = widget.user.corridor ?? 'Refinery Road — Jakpa';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header: ID + Live Status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRACKING ID',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      _activeTrackingId,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                StatusBadge(
                  text: _isDivertedToHub ? 'DIVERTED TO HUB' : 'IN TRANSIT',
                  color: _isDivertedToHub ? AppColors.textSecondary : AppColors.deepGreen,
                  backgroundColor: _isDivertedToHub ? AppColors.surfaceSubtle : AppColors.deepGreenLight,
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Route & ETA Strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(FeatherIcons.navigation, size: 15, color: AppColors.primaryDark),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        corridor,
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(FeatherIcons.clock, size: 12, color: AppColors.primaryDark),
                          const SizedBox(width: 4),
                          Text(
                            _isDivertedToHub ? 'Awaiting drop' : '~12 mins away',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(FeatherIcons.mapPin, size: 15, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Pickup Stop: $stop',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Live Corridor Map
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SendalliMapView(
                height: 130,
                corridorName: corridor,
                showLiveRider: true,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Delivery Illustration
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
              child: SvgPicture.asset(
                'assets/svg/order-delivered.svg',
                height: 90,
              ),
            ),
          ),

          // 6-digit Release Code Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HANDOVER RELEASE CODE',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '849 201',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 24,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(FeatherIcons.check, size: 16, color: AppColors.primaryDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Driver Strip with 1-tap call
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: const Icon(FeatherIcons.user, color: AppColors.primaryDark, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diran Olakunle (Keke)',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Plate: WRA-492-XA • Score: 94%',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling rider: +234 803 000 1234')),
                    );
                  },
                  icon: const Icon(FeatherIcons.phone, size: 16, color: AppColors.textInverse),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// Drop Hub Diversion Card
  Widget _buildHubDiversionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(FeatherIcons.home, size: 20, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cannot meet rider at roadside?',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  _isDivertedToHub
                      ? 'Diverted to City Care Pharmacy Hub (₦500 custody fee on pickup).'
                      : 'Store parcel at nearby partner chemist or shop for ₦500 pickup.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _isDivertedToHub = !_isDivertedToHub);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isDivertedToHub
                              ? 'Rider instructed to drop at City Care Pharmacy Hub.'
                              : 'Parcel reset to direct roadside pickup.',
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    _isDivertedToHub ? FeatherIcons.check : FeatherIcons.cornerUpRight,
                    size: 14,
                    color: AppColors.textPrimary,
                  ),
                  label: Text(_isDivertedToHub ? 'Diverted to Hub' : 'Divert to Partner Hub (₦500)'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(38),
                    textStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
