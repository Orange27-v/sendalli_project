import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../widgets/dashboard_app_bar.dart';
import '../../../../widgets/delivery/delivery_code_banner.dart';
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
  int _heldPackageCount = 0;
  double _custodyEarnings = 12500.0;

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
                  setState(() {
                    _heldPackageCount++;
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
                Navigator.pop(ctx);
                setState(() {
                  _heldPackageCount++;
                  _custodyEarnings += 500.0;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Package ${id.isNotEmpty ? id : "SND-WAR-8492"} taken into custody. +₦500 credited.'),
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
      if (_heldPackageCount > 0) {
        setState(() => _heldPackageCount--);
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

                Text('Packages In Holding ($_heldPackageCount)', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                if (_heldPackageCount == 0)
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(FeatherIcons.package, size: 40, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text('No parcels currently held in custody', style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 4),
                          Text('When riders drop missed handoffs, they will appear here.', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
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
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(FeatherIcons.package, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('#SND-WAR-8492', style: AppTextStyles.h3.copyWith(fontSize: 14)),
                              Text('Customer: +234 803 000 1234', style: AppTextStyles.caption),
                              Text('Held for 1 hr • ₦500 Fee Payable on PIN Release', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _showReleasePackageDialog,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          child: const Text('Release'),
                        ),
                      ],
                    ),
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
