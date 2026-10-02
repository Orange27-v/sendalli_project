import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../widgets/checkout/order_step_progress.dart';
import '../../../../widgets/verification/verification_widgets.dart';
import '../../../../widgets/delivery/delivery_widgets.dart';
import '../../../../widgets/map/sendalli_map_view.dart';

/// Live Order Status & Tracking Screen matching Screen 3 of the design.
///
/// Features ETA time window, multi-step milestone progress tracker,
/// sender favorite bookmarking, and route address summary.
class SenderOrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final String senderName;
  final String pickupAddress;
  final String dropoffAddress;
  final String totalAmount;
  final String deliveryOption;
  final String? addressDetails;
  final String? noteToDriver;
  final String? packageValue;
  final String? photoAsset;
  final String? weightCategory;
  final String? itemDescription;
  final String? customerName;
  final String? customerPhone;

  const SenderOrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.senderName,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.totalAmount,
    required this.deliveryOption,
    this.addressDetails,
    this.noteToDriver,
    this.packageValue = '₦ 6,500.00',
    this.photoAsset = 'assets/images/parcel_sample.png',
    this.weightCategory = 'Standard (< 5kg)',
    this.itemDescription = 'Enclosed order dispatch with tamper-evident seal',
    this.customerName = 'Amara Okafor',
    this.customerPhone = '+234 812 345 6789',
  });

  @override
  State<SenderOrderTrackingScreen> createState() => _SenderOrderTrackingScreenState();
}

class _SenderOrderTrackingScreenState extends State<SenderOrderTrackingScreen> {
  int _currentStep = 0;
  bool _isFavorite = false;
  bool _isSummaryExpanded = false;

  final List<String> _stepMessages = [
    "We've received your order and notified the sender.",
    "Order is being prepared and packed at the hub.",
    "A corridor rider is en route to deliver your parcel.",
    "Parcel delivered safely to the roadside drop point!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(FeatherIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support line: support@sendalli.com / +234 800 SENDALLI')),
              );
            },
            child: Text(
              'Get help',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(FeatherIcons.share2, size: 18, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tracking Link copied for Order ${widget.orderId}')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimens.screenInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ETA and Order confirmation header card
            Container(
              padding: const EdgeInsets.all(AppDimens.cardPadding),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '10:20 - 10:30 PM',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "On time • We've got your order!",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          FeatherIcons.smartphone,
                          color: AppColors.primaryDark,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Live Interactive Countdown Timer
                  const TrackingCountdownTimer(
                    initialDuration: Duration(minutes: 18, seconds: 40),
                    label: 'Estimated Arrival in:',
                    style: TrackingTimerStyle.card,
                  ),
                  const SizedBox(height: 20),

                  // Step Progress Tracker
                  OrderStepProgress(
                    currentStep: _currentStep,
                    statusMessage: _stepMessages[_currentStep],
                  ),

                  // Interactive test progress advance button
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentStep = (_currentStep + 1) % 4;
                        });
                      },
                      icon: const Icon(FeatherIcons.fastForward, size: 14, color: AppColors.primary),
                      label: Text(
                        _currentStep < 3 ? 'Simulate Next Step' : 'Restart Status Loop',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Corridor Map
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              clipBehavior: Clip.antiAlias,
              child: const SendalliMapView(
                height: 160,
                corridorName: 'Live Corridor: Refinery Road — Jakpa',
                showLiveRider: true,
              ),
            ),
            const SizedBox(height: 16),

            // Promo Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(FeatherIcons.zap, size: 18, color: Color(0xFFD97706)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Save up to ₦ 300 on delivery for your next order with Sendalli Pass',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(FeatherIcons.chevronRight, size: 18, color: AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sender / Store Card with Favorite Action
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        widget.senderName.isNotEmpty ? widget.senderName[0].toUpperCase() : 'S',
                        style: AppTextStyles.h3.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.senderName,
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Save this sender to Favorites and find it quickly next time.',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : FeatherIcons.heart,
                      color: _isFavorite ? Colors.red : AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _isFavorite = !_isFavorite);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite
                                ? 'Added ${widget.senderName} to favorites!'
                                : 'Removed from favorites',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order Summary Expansion Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        widget.totalAmount,
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => setState(() => _isSummaryExpanded = !_isSummaryExpanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'View order summary',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            _isSummaryExpanded ? FeatherIcons.chevronUp : FeatherIcons.chevronRight,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isSummaryExpanded) ...[
                    const Divider(color: AppColors.border, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID', style: AppTextStyles.caption),
                        Text(widget.orderId, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Tier', style: AppTextStyles.caption),
                        Text(widget.deliveryOption, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    if (widget.addressDetails != null && widget.addressDetails!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Address details', style: AppTextStyles.caption),
                          Text(widget.addressDetails!, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ],
                    if (widget.noteToDriver != null && widget.noteToDriver!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Driver note', style: AppTextStyles.caption),
                          Text(widget.noteToDriver!, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Route addresses card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E293B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.pickupAddress,
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 16,
                          color: AppColors.border,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(FeatherIcons.mapPin, size: 14, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.dropoffAddress,
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dispatch Parcel Photo & Order Inspection Card
            ParcelPhotoCard(
              orderId: widget.orderId,
              packageItem: widget.itemDescription ?? 'Enclosed Order Dispatch',
              packageValue: widget.packageValue ?? '₦ 6,500.00',
              photoAsset: widget.photoAsset,
            ),
            const SizedBox(height: 16),

            // Order Specifications & Financial Protection
            Container(
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
                      Text(
                        'ORDER SPECIFICATIONS',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(FeatherIcons.shield, size: 11, color: Color(0xFF16A34A)),
                            const SizedBox(width: 4),
                            Text(
                              'Escrow Secured',
                              style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFF16A34A),
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 18),
                  _buildSpecRow('Declared Item Value', widget.packageValue ?? '₦ 6,500.00', isBold: true),
                  const SizedBox(height: 8),
                  _buildSpecRow('Weight Category', widget.weightCategory ?? 'Standard (< 5kg)'),
                  const SizedBox(height: 8),
                  _buildSpecRow('Delivery Fee Paid', widget.totalAmount, isBold: true),
                  const SizedBox(height: 8),
                  _buildSpecRow('Recipient Contact', '${widget.customerName} (${widget.customerPhone})'),
                  if (widget.noteToDriver != null && widget.noteToDriver!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildSpecRow('Rider Notes', widget.noteToDriver!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Handover Verification (QR Code & PIN)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radius),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.35), width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FeatherIcons.maximize, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Handover Verification (QR / PIN)',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Authenticate rider pickup or scan driver badge',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SendalliVerificationModal.show(
                        context: context,
                        title: 'Sender Handover Verification',
                        subtitle: 'Scan Rider QR code or show release PIN: 849201',
                        expectedPin: '849201',
                        qrPayload: 'SND-WAR-8492-849201',
                        showPresentationTab: true,
                        pinLength: 6,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(78, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: const Text('Verify'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 30-Minute Dispute Window (app_plan.md Module 7)
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Report Issue / Dispute'),
                    content: const Text(
                      '30-minute protection window active for this order.\n\nReport parcel damage, incorrect drop-off, or driver mismatch directly to Sendalli Admin arbitration:',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dispute lodged. Escrow held pending admin review.'),
                              backgroundColor: AppColors.danger,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                        child: const Text('Submit Claim'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(FeatherIcons.alertTriangle, size: 16, color: AppColors.danger),
              label: const Text('Report Damage or Dispute (30-min window)', style: TextStyle(color: AppColors.danger)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                side: const BorderSide(color: AppColors.danger),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}