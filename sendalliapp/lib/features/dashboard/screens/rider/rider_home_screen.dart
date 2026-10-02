import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/storage/session_manager.dart';
import '../../../../widgets/delivery/delivery_widgets.dart';
import '../../../../widgets/map/sendalli_map_view.dart';
import '../../../../widgets/dashboard_app_bar.dart';
import 'rider_delivery_detail_screen.dart';
import '../../../../widgets/verification/verification_widgets.dart';
import '../../../onboarding/screens/welcome_screen.dart';
import '../common/notifications_screen.dart';
import '../common/profile_screen.dart';
import '../common/settings_screen.dart';

/// Comprehensive Rider Dashboard matching Screen 1, 2, and 3 of the rider delivery specification.
///
/// Features:
/// 1. Top greeting overlay ("Hello John") & "Online" corridor broadcast switch.
/// 2. Live background Map View with corridor route and waypoint markers.
/// 3. Incoming delivery card with Pickup/Drop-off route, notes, and Accept/Cancel actions.
/// 4. Full active delivery management with customer contact, release code banner, status dropdown,
///    and order completion.
/// 5. 4-tab bottom navigation bar (Home, Deliveries, Wallet, Profile).
class RiderHomeScreen extends StatefulWidget {
  final UserProfile user;

  const RiderHomeScreen({super.key, required this.user});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  bool _isOnline = false;
  bool _hasActiveDelivery = false;
  int _selectedTabIndex = 0;

  // Active delivery state variables matching Screen 2 & 3
  String _deliveryStatus = 'Pickup';
  final List<String> _statusOptions = ['Pickup', 'In Transit', 'Delivered'];

  // Sample package info
  final String _orderId = '#BE12345';
  final String _referenceId = '#123456789';
  final String _dateText = '12th of November, 2024';
  final String _pickupTitle = '9ja kitchen (Pickup Location)';
  final String _pickupSubtitle = 'Lagos avenue, Ring road';
  final String _dropoffTitle = 'John Deo (Drop-off Location)';
  final String _dropoffSubtitle = '114, Ojuelegba, Lagos state';
  final String _customerName = 'John Deo';
  final String _handoverCode = '1234';
  final String _deliveryFee = '₦ 260.00';
  final String _customerNote = 'Ring the bell when you get to the gate';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _hasActiveDelivery
            ? _buildActiveDeliveryAppBar()
            : DashboardAppBar(
                user: widget.user,
                title: 'Rider Dashboard',
                subtitle: widget.user.corridor ?? 'Warri — Effurun Corridor',
              ),
        body: SafeArea(
          top: !_hasActiveDelivery,
          child: _hasActiveDelivery
              ? _buildActiveDeliveryBody()
              : _buildCurrentTabBody(),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  /// App Bar shown when actively executing a delivery order (Screens 2 & 3)
  PreferredSizeWidget _buildActiveDeliveryAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(FeatherIcons.arrowLeft, color: AppColors.textPrimary),
        onPressed: () {
          setState(() => _hasActiveDelivery = false);
        },
      ),
      centerTitle: true,
      title: Text(
        _orderId,
        style: AppTextStyles.h3.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(FeatherIcons.bell, size: 20, color: AppColors.textSecondary),
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
          icon: const Icon(FeatherIcons.settings, size: 20, color: AppColors.textSecondary),
          tooltip: 'Settings',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SettingsScreen(user: widget.user)),
            );
          },
        ),
      ],
    );
  }

  /// Main Map View with redesigned floating toggler (matching image)
  /// and compact floating delivery request list (bottom modal disabled).
  Widget _buildMapHomeView() {
    return Stack(
      children: [
        // 1. Live Google / Corridor Map Background
        Positioned.fill(
          child: SendalliMapView(
            corridorName: widget.user.corridor ?? 'Warri — Effurun Corridor',
            showLiveRider: _isOnline,
          ),
        ),

        // 2. Redesigned Floating Toggler Container (Matching User Uploaded Image)
        Positioned(
          top: 14,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "Hello John" in clean green text on the left (matching image)
                Text(
                  'Hello ${widget.user.firstName}',
                  style: const TextStyle(
                    color: Color(0xFF1E7E34),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // "Online" / "Offline" + Switch on the right (matching image)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isOnline ? 'Online' : 'Offline',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.scale(
                      scale: 0.85,
                      child: Switch.adaptive(
                        value: _isOnline,
                        activeThumbColor: const Color(0xFF1E7E34),
                        activeTrackColor: const Color(0xFF1E7E34).withValues(alpha: 0.35),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFD1D5DB),
                        onChanged: (val) {
                          setState(() => _isOnline = val);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                val
                                    ? 'Online: Listening for corridor parcel requests.'
                                    : 'Offline: Broadcast paused.',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 3. Compact Floating Request List or Offline Card (Bottom modal disabled!)
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: _isOnline
              ? _buildIncomingRequestsList()
              : _buildOfflineCorridorCard(),
        ),
      ],
    );
  }

  /// Compact floating request list for incoming deliveries.
  /// Does NOT cover the entire screen — leaves map view fully interactive.
  /// Shows request address along the route and price.
  /// On click opens complete detailed information page.
  Widget _buildIncomingRequestsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Category & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Package Delivery',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '1 Available',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                _dateText,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Compact Request Card: shows route address and price. On click opens complete details!
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upper Route Details Area (Tappable -> Opens Full Details)
                InkWell(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  onTap: _openDeliveryDetailPage,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Request address along the route
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Icon(FeatherIcons.circle, size: 9, color: AppColors.primary),
                                Container(width: 1.5, height: 14, color: AppColors.borderMedium),
                                const Icon(FeatherIcons.mapPin, size: 10, color: Color(0xFFEF4444)),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _pickupTitle,
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      fontSize: 11.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _dropoffTitle,
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      fontSize: 11.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tap to inspect route & parcel details',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(FeatherIcons.arrowRight, size: 11, color: AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),

                // Lower Price & Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Payout Price
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Price: ',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Text(
                            _deliveryFee,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      // Accept Delivery button (Pill rounded)
                      ElevatedButton(
                        onPressed: _acceptDelivery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textInverse,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Accept Delivery',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDeliveryDetailPage() async {
    final accepted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RiderDeliveryDetailScreen(
          orderId: _orderId,
          referenceId: _referenceId,
          dateText: _dateText,
          pickupTitle: _pickupTitle,
          pickupSubtitle: _pickupSubtitle,
          dropoffTitle: _dropoffTitle,
          dropoffSubtitle: _dropoffSubtitle,
          packageItem: 'Food • Jollof Rice, meat and moi moi',
          deliveryFee: _deliveryFee,
          customerName: _customerName,
          customerNote: _customerNote,
          handoverCode: _handoverCode,
          corridorName: widget.user.corridor ?? 'Warri — Effurun Corridor',
          onAccept: () {
            _acceptDelivery();
          },
        ),
      ),
    );

    if (accepted == true && !_hasActiveDelivery) {
      _acceptDelivery();
    }
  }

  void _acceptDelivery() {
    setState(() {
      _hasActiveDelivery = true;
      _deliveryStatus = 'Pickup';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted delivery for $_orderId! Navigating to corridor route.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  /// Offline status card prompting rider to go online
  Widget _buildOfflineCorridorCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  shape: BoxShape.circle,
                ),
                child: const Icon(FeatherIcons.radio, color: AppColors.textMuted, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Corridor Broadcast Paused',
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Toggle Online at the top to receive parcel alerts along your route.',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Corridor: ${widget.user.corridor ?? "Refinery Road — Jakpa"}',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Trust: ${widget.user.trustScore}%',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.eliteGold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Active Delivery Details View matching Screen 2 & 3
  Widget _buildActiveDeliveryBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.screenPaddingH, vertical: AppDimens.screenPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subheader: Reference ID & Date
          DeliveryDateHeader(
            referenceNumber: _referenceId,
            dateString: _dateText,
          ),

          // Route details
          DeliveryRouteCard(
            pickupTitle: _pickupTitle,
            pickupSubtitle: _pickupSubtitle,
            dropoffTitle: _dropoffTitle,
            dropoffSubtitle: _dropoffSubtitle,
          ),
          const SizedBox(height: 12),

          // Package Summary
          DeliveryPackageCard(
            packageId: _orderId,
            packageItem: 'Food • Jollof Rice, meat and moi moi',
            deliveryFee: _deliveryFee,
          ),
          const SizedBox(height: 10),

          // Customer Row with Message & Call
          DeliveryCustomerRow(
            name: _customerName,
            onChatPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening chat with $_customerName...')),
              );
            },
            onCallPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling customer: +234 803 000 1234')),
              );
            },
          ),
          const SizedBox(height: 12),

          // Handover Release Code Banner
          DeliveryCodeBanner(
            code: _handoverCode,
          ),
          const SizedBox(height: 10),

          // Step Verification: QR Code Scanner & PIN Verification
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppDimens.radius),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: AppDimens.borderWidth,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(FeatherIcons.maximize, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _deliveryStatus == 'Pickup'
                            ? 'Step 1: Verify Pickup'
                            : 'Step 2: Verify Handover',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        'Scan QR code or enter recipient PIN ()',
                        style: AppTextStyles.caption.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final verified = await SendalliVerificationModal.show(
                      context: context,
                      title: _deliveryStatus == 'Pickup' ? 'Verify Parcel Pickup' : 'Verify Handover',
                      subtitle: 'Scan QR or enter PIN: $_handoverCode',
                      expectedPin: _handoverCode,
                      pinLength: 4,
                    );
                    if (verified == true && mounted) {
                      setState(() {
                        if (_deliveryStatus == 'Pickup') {
                          _deliveryStatus = 'In Transit';
                        } else {
                          _deliveryStatus = 'Delivered';
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _deliveryStatus == 'In Transit'
                                ? 'Pickup verified! En route to delivery stop.'
                                : 'Handover verified! Ready to complete order.',
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(78, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Verify'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Notes
          DeliveryNoteTile(
            title: 'Pickup note',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pickup: Collect package from counter.')),
              );
            },
          ),
          DeliveryNoteTile(
            title: 'Drop-off note',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Drop-off: Roadside delivery handover.')),
              );
            },
          ),

          // Customer note card (Screen 3)
          DeliveryCustomerNoteCard(
            note: _customerNote,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3), width: AppDimens.borderWidth),
            ),
            child: Row(
              children: [
                const Icon(FeatherIcons.clock, size: 20, color: AppColors.warning),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1-Minute Roadside Window',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'If receiver is not at the roadside stop within 1 min, divert to Drop Hub.',
                        style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Fallback to Drop Hub action
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Divert to Partner Drop Hub?'),
                  content: const Text(
                    'Receiver is unavailable at the roadside stop. Package will be dropped at nearest verified partner hub:\n\n• Chinedu Chemist & Hub (PTI Junction)\n• ₦500 holding fee will be credited upon intake.',
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() => _deliveryStatus = 'In Transit');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rerouted to Chinedu Chemist Drop Hub.'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      child: const Text('Confirm Diversion'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(FeatherIcons.home, size: 16),
            label: const Text('Receiver Absent? Divert to Drop Hub'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.borderMedium),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
          ),
          const SizedBox(height: 14),

          // Delivery Status Dropdown
          Text(
            'Delivery Status',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _deliveryStatus,
                isExpanded: true,
                icon: const Icon(FeatherIcons.chevronDown, size: 18, color: AppColors.textMuted),
                items: _statusOptions.map((opt) {
                  return DropdownMenuItem<String>(
                    value: opt,
                    child: Text(
                      opt,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: opt == 'Delivered' ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _deliveryStatus = val);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Complete Order Primary Button
          DeliveryPrimaryButton(
            label: 'Complete Order',
            onPressed: () {
              setState(() {
                _hasActiveDelivery = false;
                _deliveryStatus = 'Pickup';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order completed! Delivery fare credited to your wallet.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Switches content based on selected bottom navigation tab
  Widget _buildCurrentTabBody() {
    switch (_selectedTabIndex) {
      case 1:
        return _buildDeliveriesTab();
      case 2:
        return _buildWalletTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildMapHomeView();
    }
  }

  /// Tab 1: Corridor Trips & Delivery History
  Widget _buildDeliveriesTab() {
    return SingleChildScrollView(
      padding: AppDimens.screenInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Deliveries', style: AppTextStyles.h2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '8 Completed Today',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildTripCard(
            orderId: '#BE12345',
            pickup: '9ja Kitchen • Ring Road',
            dropoff: 'John Deo • Jakpa Junction Stop',
            fare: '₦ 800.00',
            status: 'Delivered',
            time: '12:45 PM',
            isComplete: true,
          ),
          const SizedBox(height: 12),
          _buildTripCard(
            orderId: '#BE12344',
            pickup: 'Warri Central Chemist',
            dropoff: 'PTI Gate Roadside',
            fare: '₦ 800.00',
            status: 'Delivered',
            time: '11:15 AM',
            isComplete: true,
          ),
          const SizedBox(height: 12),
          _buildTripCard(
            orderId: '#BE12343',
            pickup: 'Deco Road Provisions',
            dropoff: 'Airport Road Express Stop',
            fare: '₦ 800.00',
            status: 'Delivered',
            time: '09:40 AM',
            isComplete: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard({
    required String orderId,
    required String pickup,
    required String dropoff,
    required String fare,
    required String status,
    required String time,
    required bool isComplete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Text(orderId, style: AppTextStyles.h3.copyWith(fontSize: 15)),
              Text(fare, style: AppTextStyles.h3.copyWith(color: AppColors.primary, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FeatherIcons.arrowUpRight, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(child: Text(pickup, style: AppTextStyles.bodySmall)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(FeatherIcons.arrowDownRight, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(child: Text(dropoff, style: AppTextStyles.bodySmall)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isComplete ? AppColors.primaryLight : AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: isComplete ? AppColors.primary : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tab 2: Rider Wallet & Paystack Same-Day Payout
  Widget _buildWalletTab() {
    return SingleChildScrollView(
      padding: AppDimens.screenInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available Balance Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.cardPaddingLarge),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AVAILABLE BALANCE',
                      style: AppTextStyles.caption.copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Escrow Active',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '₦ 18,400.00',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('In-Escrow Pending', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        const SizedBox(height: 2),
                        Text('₦ 2,400.00', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Today's Earnings", style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        const SizedBox(height: 2),
                        Text('₦ 6,400.00 (8 Trips)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryAccent, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Withdraw Button
          ElevatedButton.icon(
            onPressed: _showWithdrawalModal,
            icon: const Icon(FeatherIcons.arrowUpRight, size: 18, color: AppColors.textInverse),
            label: const Text('Withdraw to Bank (Same-Day Paystack)'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
          ),
          const SizedBox(height: 24),

          Text('Recent Ledger Activity', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          _buildTransactionRow(
            title: 'Delivery Fare • #BE12345',
            subtitle: 'Refinery Express Route • Jakpa stop',
            amount: '+ ₦ 800.00',
            date: 'Today, 12:45 PM',
            isCredit: true,
          ),
          _buildTransactionRow(
            title: 'Delivery Fare • #BE12344',
            subtitle: 'PTI Route • PTI Gate',
            amount: '+ ₦ 800.00',
            date: 'Today, 11:15 AM',
            isCredit: true,
          ),
          _buildTransactionRow(
            title: 'Bank Payout Transfer',
            subtitle: 'Access Bank ••••• 4821',
            amount: '- ₦ 10,000.00',
            date: 'Yesterday, 06:30 PM',
            isCredit: false,
          ),
          _buildTransactionRow(
            title: 'Delivery Fare • #BE12343',
            subtitle: 'Airport Road Express Stop',
            amount: '+ ₦ 800.00',
            date: 'Yesterday, 04:10 PM',
            isCredit: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow({
    required String title,
    required String subtitle,
    required String amount,
    required String date,
    required bool isCredit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCredit ? AppColors.primaryLight : AppColors.surfaceSubtle,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? FeatherIcons.arrowDownLeft : FeatherIcons.arrowUpRight,
              color: isCredit ? AppColors.primary : AppColors.textSecondary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                Text(date, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 10)),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: isCredit ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Tab 3: Profile & Autonomous Trust Score System (per new_feature.md & Sendalli Autonomous Rider Trust Score System.md)
  Widget _buildProfileTab() {
    final trust = widget.user.trustScore;

    return SingleChildScrollView(
      padding: AppDimens.screenInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Details Card
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProfileScreen(user: widget.user)),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(AppDimens.cardPaddingLarge),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      widget.user.firstName.isNotEmpty ? widget.user.firstName[0] : 'R',
                      style: AppTextStyles.h1.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.fullName, style: AppTextStyles.h3),
                        Text('Tricycle Plate: ${widget.user.vehiclePlate ?? "WRA-492-XA"}', style: AppTextStyles.bodySmall),
                        Text('Park: ${widget.user.unionPark ?? "Effurun Central Park"}', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  const Icon(FeatherIcons.chevronRight, size: 20, color: AppColors.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Autonomous Trust Score System Engine Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AUTONOMOUS TRUST SCORE', style: AppTextStyles.caption.copyWith(letterSpacing: 1.0, fontWeight: FontWeight.w700)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        trust >= 90 ? 'ELITE TIER' : 'STANDARD',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '$trust%',
                      style: AppTextStyles.displayLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        trust >= 90
                            ? 'Elite Partner: First refusal on express and high-value (up to ₦20,000) parcels.'
                            : 'Standard Partner: Verified for all standard corridor deliveries.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: trust / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 12),

                Text('Scoring Breakdown (Objective Metrics):', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                _buildScoreMetric('+1 pt', 'Successful completed delivery', isPositive: true),
                _buildScoreMetric('+2 pts', 'Fast roadside pickup under 3 mins', isPositive: true),
                _buildScoreMetric('+5 pts', '10 consecutive deliveries zero disputes', isPositive: true),
                _buildScoreMetric('+2 pts', 'Clean handoff to partner Drop Hub', isPositive: true),
                _buildScoreMetric('-5 pts', 'Post-acceptance cancellation', isPositive: false),
                _buildScoreMetric('-3 pts', 'Late or missed roadside handoff', isPositive: false),
                _buildScoreMetric('-20 pts', 'Verified damage claim or dispute', isPositive: false),

                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _showTrustScoreAppealsModal,
                  icon: const Icon(FeatherIcons.alertCircle, size: 14),
                  label: const Text('Submit Score Dispute / Appeal'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Log out
          OutlinedButton.icon(
            onPressed: _handleLogout,
            icon: const Icon(FeatherIcons.logOut, size: 16, color: AppColors.danger),
            label: const Text('Log Out', style: TextStyle(color: AppColors.danger)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              side: const BorderSide(color: AppColors.danger),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildScoreMetric(String points, String description, {required bool isPositive}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: isPositive ? AppColors.primaryLight : AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                points,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  color: isPositive ? AppColors.primary : AppColors.danger,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawalModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bank Withdrawal (Paystack)', style: AppTextStyles.h3),
                IconButton(icon: const Icon(FeatherIcons.x), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Withdraw instantly to your verified Nigerian commercial or fintech account.', style: AppTextStyles.bodySmall),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Account Number',
                hintText: '0123456789',
                border: OutlineInputBorder(),
                prefixIcon: Icon(FeatherIcons.creditCard),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(FeatherIcons.checkCircle, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Beneficiary: ${widget.user.fullName.toUpperCase()}', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount (₦)',
                hintText: '5000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(FeatherIcons.dollarSign),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Withdrawal request initiated via Paystack Transfer.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              child: const Text('Confirm Payout'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTrustScoreAppealsModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Score Dispute'),
        content: const Text(
          'Appeals are reviewed directly by the Sendalli Operations panel via timestamp cross-referencing and delivery proof verification (bypassing park chairmen).\n\nPlease enter the Delivery ID and explanation:',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dispute submitted for admin arbitration.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Submit Dispute'),
          ),
        ],
      ),
    );
  }

  /// 4-Tab Bottom Navigation Bar matching design (Home, Deliveries, Wallet, Profile)
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: AppDimens.borderWidth)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() => _selectedTabIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: AppTextStyles.caption,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.home, size: 20),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.package, size: 20),
            label: 'Deliveries',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.creditCard, size: 20),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.user, size: 20),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _handleLogout() async {
    await SessionManager.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }
}

