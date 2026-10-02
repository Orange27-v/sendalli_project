import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/models/hub_parcel_item.dart';
import '../../../../widgets/dashboard_app_bar.dart';
import '../../../../widgets/delivery/delivery_widgets.dart';
import '../../../../widgets/verification/verification_widgets.dart';
import '../../../../widgets/map/sendalli_map_view.dart';
import '../common/profile_screen.dart';

/// Hub Operator Home Dashboard (Custody management & ₦500 custody fee tracking).
class HubHomeScreen extends StatefulWidget {
  final UserProfile user;

  const HubHomeScreen({super.key, required this.user});

  @override
  State<HubHomeScreen> createState() => _HubHomeScreenState();
}

class _HubHomeScreenState extends State<HubHomeScreen> {
  bool _isOpenForDropoffs = true;
  double _custodyEarnings = 12500.0;
  int _hubFilterIndex = 0; // 0: Pending Requests, 1: In Custody, 2: Delivered

  // Direct initializers to guarantee non-null safety during hot-reloads and gestures
  final List<HubParcelItem> _pendingHubRequests = [
    HubParcelItem(
      trackingId: 'SND-WAR-9021',
      packageName: 'Electronics • Bluetooth Speaker & Charger',
      riderName: 'Musa Ibrahim (Keke #44)',
      riderPhone: '+234 803 444 5566',
      customerName: 'Emeka Obi',
      customerPhone: '+234 812 345 6789',
      corridor: 'Refinery Road — Jakpa',
      intakeTime: 'ETA: 4 mins • Approaching Hub',
      custodyFee: '₦ 500.00',
      releasePin: '902155',
      reason: 'Receiver delayed at Jakpa Stop (>60s timeout)',
      eta: '4 mins',
      packageValue: '₦ 16,500.00',
      pickupTitle: 'Deco Road Electronics Hub',
      dropoffTitle: 'Jakpa Roadside Stop',
      weightCategory: '1.2 kg • Bluetooth Box',
      status: HubParcelStatus.pendingDropoff,
    ),
    HubParcelItem(
      trackingId: 'SND-EFF-4180',
      packageName: 'Documents • CAC Certificate & Deeds',
      riderName: 'Diran Olakunle (Keke #12)',
      riderPhone: '+234 803 111 2233',
      customerName: 'Barrister Aliyu',
      customerPhone: '+234 802 987 6543',
      corridor: 'PTI Corridor',
      intakeTime: 'ETA: 8 mins • Near PTI Gate',
      custodyFee: '₦ 500.00',
      releasePin: '418022',
      reason: 'Designated Hub Drop-off (PTI Corridor)',
      eta: '8 mins',
      packageValue: '₦ 5,000.00',
      pickupTitle: 'High Court Chambers, Effurun',
      dropoffTitle: 'PTI Gate Roadside Kiosk',
      weightCategory: '0.3 kg • Sealed Envelope',
      status: HubParcelStatus.pendingDropoff,
    ),
    HubParcelItem(
      trackingId: 'SND-WAR-7734',
      packageName: 'Fashion • Aso-ebi Lace Fabric',
      riderName: 'Godwin Efe (Keke #09)',
      riderPhone: '+234 814 555 1212',
      customerName: 'Mrs. Okiemute',
      customerPhone: '+234 814 777 9900',
      corridor: 'Airport Road — Effurun',
      intakeTime: 'ETA: 12 mins • Approaching Effurun',
      custodyFee: '₦ 500.00',
      releasePin: '773411',
      reason: 'Receiver phone unreachable at roadside',
      eta: '12 mins',
      packageValue: '₦ 24,000.00',
      pickupTitle: 'Main Market Textile Row',
      dropoffTitle: 'Airport Road Express Stop',
      weightCategory: '1.8 kg • Lace Fabric Pack',
      status: HubParcelStatus.pendingDropoff,
    ),
  ];

  final List<HubParcelItem> _heldPackages = [
    HubParcelItem(
      trackingId: 'SND-WAR-8492',
      packageName: 'Pharmacy • Prescription box',
      riderName: 'Diran Olakunle (Keke #12)',
      riderPhone: '+234 803 111 2233',
      customerName: 'Sarah Amadi',
      customerPhone: '+234 803 000 1234',
      corridor: 'Refinery Road — Jakpa',
      intakeTime: 'Held for 1 hr • Intake: 1:30 PM',
      storageLocation: 'Shelf A-3',
      custodyFee: '₦ 500.00',
      releasePin: '849201',
      reason: 'Roadside timer expired',
      packageValue: '₦ 8,500.00',
      pickupTitle: 'Enerhen Central Pharmacy',
      dropoffTitle: 'Refinery Road Junction',
      weightCategory: '0.4 kg • Medicine Box',
      status: HubParcelStatus.heldInCustody,
    ),
    HubParcelItem(
      trackingId: 'SND-EFF-3312',
      packageName: 'Automotive • Replacement Gaskets',
      riderName: 'Musa Ibrahim (Keke #44)',
      riderPhone: '+234 803 444 5566',
      customerName: 'Mr. Festus',
      customerPhone: '+234 805 777 8899',
      corridor: 'Effurun Roundabout Corridor',
      intakeTime: 'Held for 45 mins • Intake: 2:00 PM',
      storageLocation: 'Locker B-1',
      custodyFee: '₦ 500.00',
      releasePin: '331205',
      reason: 'Direct hub drop-off request',
      packageValue: '₦ 12,000.00',
      pickupTitle: 'Warri Spare Parts Depot',
      dropoffTitle: 'Effurun Roundabout Stop',
      weightCategory: '1.5 kg • Mechanical Spares',
      status: HubParcelStatus.heldInCustody,
    ),
  ];

  final List<HubParcelItem> _deliveredParcels = [
    HubParcelItem(
      trackingId: 'SND-WAR-8201',
      packageName: 'Food • Jollof Rice Pack',
      riderName: 'Diran Olakunle (Keke #12)',
      riderPhone: '+234 803 111 2233',
      customerName: 'Tariere Brisibe',
      customerPhone: '+234 803 999 4433',
      corridor: 'Refinery Road — Jakpa',
      intakeTime: '12:00 PM',
      releaseTime: 'Today • 1:15 PM',
      custodyFee: '₦ 500.00',
      releasePin: '820104',
      reason: 'Released via verified 6-digit PIN',
      packageValue: '₦ 4,800.00',
      pickupTitle: '9ja Kitchen',
      dropoffTitle: 'Jakpa Roadside Stop',
      weightCategory: '0.8 kg • Food Container',
      status: HubParcelStatus.delivered,
    ),
    HubParcelItem(
      trackingId: 'SND-EFF-2940',
      packageName: 'Cosmetics • Skincare Package',
      riderName: 'Godwin Efe (Keke #09)',
      riderPhone: '+234 814 555 1212',
      customerName: 'Blessing Akpan',
      customerPhone: '+234 802 333 1122',
      corridor: 'Effurun Roundabout Corridor',
      intakeTime: '10:15 AM',
      releaseTime: 'Today • 11:30 AM',
      custodyFee: '₦ 500.00',
      releasePin: '294088',
      reason: 'Released via verified QR Code',
      packageValue: '₦ 9,500.00',
      pickupTitle: 'Delta Glow Boutique',
      dropoffTitle: 'Effurun Market Stop',
      weightCategory: '0.6 kg • Cosmetics Box',
      status: HubParcelStatus.delivered,
    ),
    HubParcelItem(
      trackingId: 'SND-WAR-7115',
      packageName: 'Hardware • Drill Bits set',
      riderName: 'Musa Ibrahim (Keke #44)',
      riderPhone: '+234 803 444 5566',
      customerName: 'Engr. Victor',
      customerPhone: '+234 806 888 7766',
      corridor: 'Refinery Road Corridor',
      intakeTime: '08:45 AM',
      releaseTime: 'Today • 10:05 AM',
      custodyFee: '₦ 500.00',
      releasePin: '711533',
      reason: 'Released via verified 6-digit PIN',
      packageValue: '₦ 18,000.00',
      pickupTitle: 'Warri Tool Mart',
      dropoffTitle: 'Refinery Road Matrix Gate',
      weightCategory: '2.1 kg • Hardware Box',
      status: HubParcelStatus.delivered,
    ),
    HubParcelItem(
      trackingId: 'SND-WAR-6890',
      packageName: 'Books • Educational Textbooks',
      riderName: 'Diran Olakunle (Keke #12)',
      riderPhone: '+234 803 111 2233',
      customerName: 'Principal Oghenero',
      customerPhone: '+234 803 555 4422',
      corridor: 'Jakpa Road Corridor',
      intakeTime: 'Yesterday • 2:10 PM',
      releaseTime: 'Yesterday • 4:45 PM',
      custodyFee: '₦ 500.00',
      releasePin: '689012',
      reason: 'Released via verified 6-digit PIN',
      packageValue: '₦ 7,200.00',
      pickupTitle: 'Deco Bookshop',
      dropoffTitle: 'Jakpa Road Bus Stop',
      weightCategory: '1.4 kg • Books Pack',
      status: HubParcelStatus.delivered,
    ),
  ];

  int get _heldPackageCount => _heldPackages.length;

  void _intakeSpecificPackage(HubParcelItem item) {
    setState(() {
      item.status = HubParcelStatus.heldInCustody;
      _pendingHubRequests.removeWhere((p) => p.trackingId == item.trackingId);
      _heldPackages.insert(0, item);
      _custodyEarnings += 500.0;
      _hubFilterIndex = 1; // switch to In Custody tab
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Package ${item.trackingId} taken into custody. +₦500 credited.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _releaseSpecificPackage(HubParcelItem item) async {
    final verified = await SendalliVerificationModal.show(
      context: context,
      title: 'Release Package to Recipient',
      subtitle: 'Scan recipient QR or enter 6-digit release PIN',
      expectedPin: item.releasePin,
      pinLength: 6,
    );

    if (verified == true && mounted) {
      setState(() {
        item.status = HubParcelStatus.delivered;
        _heldPackages.removeWhere((p) => p.trackingId == item.trackingId);
        _deliveredParcels.insert(0, item);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PIN verified. Package ${item.trackingId} released to ${item.customerName}.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _showParcelDetails(HubParcelItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Parcel Order Details', style: AppTextStyles.h3),
                  IconButton(
                    icon: const Icon(FeatherIcons.x),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dispatch Photo
                    ParcelPhotoCard(
                      orderId: item.trackingId,
                      packageItem: item.packageName,
                      packageValue: item.packageValue,
                      photoAsset: item.photoAsset,
                      captureTime: 'Dispatch Photo • ${item.intakeTime}',
                    ),
                    const SizedBox(height: 12),

                    // Value and Custody Fee Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Declared Parcel Value', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
                                  Text(item.packageValue, style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary, fontSize: 16)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Custody Payout', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
                                  Text(item.custodyFee, style: AppTextStyles.h3.copyWith(color: AppColors.primary, fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(FeatherIcons.shield, size: 13, color: Color(0xFF16A34A)),
                                const SizedBox(width: 6),
                                Text(
                                  'Sendalli Escrow Protected • ₦500 Custody Guarantee',
                                  style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFF166534),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Route details
                    DeliveryRouteCard(
                      pickupTitle: item.pickupTitle,
                      pickupSubtitle: item.corridor,
                      dropoffTitle: item.dropoffTitle,
                      dropoffSubtitle: 'Roadside Drop Hub Delivery Stop',
                    ),
                    const SizedBox(height: 12),

                    // Parties & Contact details
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PEOPLE & CONTACTS',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(FeatherIcons.truck, size: 14, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Rider: ${item.riderName} (${item.riderPhone})',
                                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(FeatherIcons.user, size: 14, color: Color(0xFF16A34A)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Customer: ${item.customerName} (${item.customerPhone})',
                                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Reason / Handover details
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(FeatherIcons.info, size: 16, color: AppColors.warning),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Reason: ${item.reason} • Release PIN: ${item.releasePin}',
                              style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFFB45309),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Primary Action Button
                    if (item.status == HubParcelStatus.pendingDropoff)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _intakeSpecificPackage(item);
                        },
                        icon: const Icon(FeatherIcons.download, size: 16),
                        label: const Text('Confirm Custody Intake (+₦500)'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                      )
                    else if (item.status == HubParcelStatus.heldInCustody)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _releaseSpecificPackage(item);
                        },
                        icon: const Icon(FeatherIcons.upload, size: 16),
                        label: const Text('Release Package (Verify PIN)'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Package Released • +₦500 Credited',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF166534),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showIntakePackageSheet() {
    final controller = TextEditingController();

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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Intake Package into Custody', style: AppTextStyles.h3),
                IconButton(icon: const Icon(FeatherIcons.x), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Scan QR or enter the Tracking ID handed over by the keke rider:', style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(ctx);
                final verified = await SendalliVerificationModal.show(
                  context: context,
                  title: 'Scan Keke Rider QR',
                  subtitle: 'Align rider QR code within frame or enter PIN',
                  expectedPin: '8492',
                  pinLength: 4,
                );
                if (verified == true && mounted) {
                  final newHeldItem = HubParcelItem(
                    trackingId: 'SND-WAR-8492',
                    packageName: 'Verified Parcel Intake',
                    riderName: 'Corridor Keke Rider',
                    riderPhone: '+234 803 111 2233',
                    customerName: 'Customer Inbound',
                    customerPhone: '+234 803 000 1234',
                    corridor: 'Refinery Road — Jakpa',
                    intakeTime: 'Just now',
                    storageLocation: 'Shelf A-1',
                    custodyFee: '₦ 500.00',
                    releasePin: '849201',
                    reason: 'Roadside timer fallback',
                    status: HubParcelStatus.heldInCustody,
                  );
                  setState(() {
                    _heldPackages.insert(0, newHeldItem);
                    _custodyEarnings += 500.0;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Package SND-WAR-8492 verified & taken into custody. +₦500 credited.'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              },
              icon: const Icon(FeatherIcons.maximize, size: 16),
              label: const Text('Open QR Code Scanner'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.2),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Tracking ID (e.g. SND-WAR-8492)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(FeatherIcons.package),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final id = controller.text.trim().toUpperCase();
                final safeId = id.isNotEmpty ? id : 'SND-WAR-8492';
                Navigator.pop(ctx);
                final newHeldItem = HubParcelItem(
                  trackingId: safeId,
                  packageName: 'Manual Custody Intake',
                  riderName: 'Corridor Keke Rider',
                  riderPhone: '+234 803 111 2233',
                  customerName: 'Awaiting Customer',
                  customerPhone: '+234 803 000 1234',
                  corridor: 'Refinery Road — Jakpa',
                  intakeTime: 'Just now',
                  storageLocation: 'Shelf A-2',
                  custodyFee: '₦ 500.00',
                  releasePin: '849201',
                  reason: 'Roadside timer fallback',
                  status: HubParcelStatus.heldInCustody,
                );
                setState(() {
                  _heldPackages.insert(0, newHeldItem);
                  _custodyEarnings += 500.0;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Package $safeId taken into custody. +₦500 credited.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              icon: const Icon(FeatherIcons.check, size: 18),
              label: const Text('Confirm Custody Intake (+₦500)'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ],
        ),
      ),
    );
  }

  void _showReleasePackageDialog() async {
    final verified = await SendalliVerificationModal.show(
      context: context,
      title: 'Release Package to Recipient',
      subtitle: 'Scan recipient QR or enter 6-digit release PIN',
      expectedPin: '849201',
      pinLength: 6,
    );

    if (verified == true && mounted) {
      if (_heldPackages.isNotEmpty) {
        setState(() {
          final released = _heldPackages.removeAt(0);
          released.status = HubParcelStatus.delivered;
          _deliveredParcels.insert(0, released);
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN verified. Package released to customer safely.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: DashboardAppBar(
          user: user,
          title: user.unionPark ?? 'Drop Hub Custody',
          subtitle: 'Active Roadside Custody Center',
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: AppDimens.screenInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hub Profile Card with Store status switch
                Container(
                  padding: const EdgeInsets.all(AppDimens.cardPaddingLarge),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.primary,
                              child: const Icon(FeatherIcons.home, color: AppColors.textInverse, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.shopName ?? 'Drop Hub Store', style: AppTextStyles.h3),
                                  Text('Landmark: ${user.landmark ?? "Near PTI Junction"}', style: AppTextStyles.bodySmall),
                                  Text('₦500 custody credit per package', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                                ],
                              ),
                            ),
                            const Icon(FeatherIcons.chevronRight, size: 18, color: AppColors.primary),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.border, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isOpenForDropoffs ? AppColors.primary : AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isOpenForDropoffs ? 'Open for Drop-offs (8AM - 7PM)' : 'Hub Closed',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: _isOpenForDropoffs ? AppColors.primary : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _isOpenForDropoffs = !_isOpenForDropoffs),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 44,
                              height: 24,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: _isOpenForDropoffs ? AppColors.primary : AppColors.border,
                              ),
                              child: Align(
                                alignment: _isOpenForDropoffs ? Alignment.centerRight : Alignment.centerLeft,
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
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Custody Fee Ledger Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CUSTODY EARNINGS', style: AppTextStyles.caption.copyWith(color: Colors.white70, fontSize: 10, letterSpacing: 1.0)),
                          const SizedBox(height: 4),
                          Text('₦ ${_custodyEarnings.toStringAsFixed(0)}', style: AppTextStyles.h2.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                          Text('₦500 x 25 Packages Held', style: AppTextStyles.caption.copyWith(color: AppColors.primaryLight, fontSize: 11)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Custody fee withdrawal initiated via Paystack Transfer.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        child: const Text('Withdraw'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Dual Action Buttons: Intake & Release
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showIntakePackageSheet,
                        icon: const Icon(FeatherIcons.download, size: 16, color: AppColors.textInverse),
                        label: const Text('Intake Package'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textInverse,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showReleasePackageDialog,
                        icon: const Icon(FeatherIcons.upload, size: 16),
                        label: const Text('Release (PIN)'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Live Corridor Hub Logistics Map
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Corridor Hub Logistics', style: AppTextStyles.h3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: AppDimens.borderWidth),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Hub Active',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: const SendalliMapView(
                    height: 165,
                    corridorName: 'Hub Corridor: Refinery Road — Jakpa',
                    showLiveRider: true,
                  ),
                ),
                const SizedBox(height: 20),

                // Code Verification Helper Banner
                const DeliveryCodeBanner(
                  label: 'Verify Customer Pickup Code:',
                  code: '849201',
                ),
                const SizedBox(height: 24),

                // Packages In Holding header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Packages In Holding ($_heldPackageCount)', style: AppTextStyles.h3),
                    Text(
                      '₦500 per release',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Segmented Filter Bar: Pending Drop-offs, In Custody, Delivered / Released
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 1.0),
                  ),
                  child: Row(
                    children: [
                      _buildHubFilterTab(
                        key: const Key('hub_filter_pending'),
                        index: 0,
                        label: 'Pending',
                        count: _pendingHubRequests.length,
                      ),
                      _buildHubFilterTab(
                        key: const Key('hub_filter_held'),
                        index: 1,
                        label: 'In Custody',
                        count: _heldPackages.length,
                      ),
                      _buildHubFilterTab(
                        key: const Key('hub_filter_delivered'),
                        index: 2,
                        label: 'Delivered',
                        count: _deliveredParcels.length,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Content according to selected filter
                if (_hubFilterIndex == 0) ...[
                  _buildPendingHubList(),
                ] else if (_hubFilterIndex == 1) ...[
                  _buildHeldPackagesList(),
                ] else ...[
                  _buildDeliveredHubList(),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHubFilterTab({
    required Key key,
    required int index,
    required String label,
    required int count,
  }) {
    final isSelected = _hubFilterIndex == index;

    return Expanded(
      child: InkWell(
        key: key,
        onTap: () => setState(() => _hubFilterIndex = index),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingHubList() {
    if (_pendingHubRequests.isEmpty) {
      return _buildEmptyState(
        icon: FeatherIcons.inbox,
        title: 'No Pending Drop-offs',
        subtitle: 'When keke riders encounter delayed recipients along the corridor, incoming drop-offs will appear here.',
      );
    }

    return Column(
      children: _pendingHubRequests.map((item) {
        return InkWell(
          onTap: () => _showParcelDetails(item),
          borderRadius: BorderRadius.circular(12),
          child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.3), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FeatherIcons.truck, size: 14, color: AppColors.warning),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.trackingId,
                        style: AppTextStyles.h3.copyWith(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(FeatherIcons.clock, size: 11, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          item.eta ?? 'Incoming',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFFB45309),
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Package & Reason
              Text(
                item.packageName,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(FeatherIcons.alertCircle, size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Reason: ${item.reason}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(FeatherIcons.user, size: 12, color: AppColors.primary),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Rider: ${item.riderName} • ${item.riderPhone}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 8),

              // Fee & Intake Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Custody Credit', style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.textMuted)),
                      Text(
                        item.custodyFee,
                        style: AppTextStyles.h3.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    key: Key('hub_intake_btn_${item.trackingId}'),
                    onPressed: () => _intakeSpecificPackage(item),
                    icon: const Icon(FeatherIcons.download, size: 13),
                    label: const Text('Intake (+₦500)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textInverse,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

  Widget _buildHeldPackagesList() {
    if (_heldPackages.isEmpty) {
      return _buildEmptyState(
        icon: FeatherIcons.package,
        title: 'No parcels currently held in custody',
        subtitle: 'When riders drop missed handoffs, they will appear here.',
      );
    }

    return Column(
      children: _heldPackages.map((item) {
        return InkWell(
          onTap: () => _showParcelDetails(item),
          borderRadius: BorderRadius.circular(12),
          child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FeatherIcons.package, size: 14, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.trackingId,
                        style: AppTextStyles.h3.copyWith(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  if (item.storageLocation != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.storageLocation!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                item.packageName,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Customer: ${item.customerName} • ${item.customerPhone}',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                '${item.intakeTime} • ₦500 Fee Payable on PIN Release',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Release PIN: ${item.releasePin}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton.icon(
                    key: Key('hub_release_btn_${item.trackingId}'),
                    onPressed: () => _releaseSpecificPackage(item),
                    icon: const Icon(FeatherIcons.upload, size: 13),
                    label: const Text('Release (PIN)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textInverse,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

  Widget _buildDeliveredHubList() {
    if (_deliveredParcels.isEmpty) {
      return _buildEmptyState(
        icon: FeatherIcons.checkCircle,
        title: 'No Released Parcels Yet',
        subtitle: 'Parcels successfully verified with recipient PIN/QR code will appear here with custody fee credit.',
      );
    }

    return Column(
      children: _deliveredParcels.map((item) {
        return InkWell(
          onTap: () => _showParcelDetails(item),
          borderRadius: BorderRadius.circular(12),
          child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FeatherIcons.check, size: 13, color: Color(0xFF16A34A)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.trackingId,
                        style: AppTextStyles.h3.copyWith(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Delivered & Released',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF16A34A),
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.packageName,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 3),
              Text(
                'Recipient: ${item.customerName} • ${item.customerPhone}',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 3),
              Text(
                'Verified: ${item.reason}',
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 11),
              ),
              const SizedBox(height: 8),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.releaseTime ?? 'Completed',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 11),
                  ),
                  Text(
                    '+₦500.00 Credited',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF16A34A),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.caption, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
