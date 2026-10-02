import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../widgets/checkout/save_location_sheet.dart';
import '../../../../widgets/map/sendalli_map_view.dart';
import 'sender_order_tracking_screen.dart';

/// Dedicated Sender Checkout / Place Order screen matching Screen 1 of the design.
///
/// Features store banner, delivery mode selector, delivery address card with
/// interactive address details bottom sheet, tier selection, and sticky Place Order bar.
class SenderCheckoutScreen extends StatefulWidget {
  final UserProfile user;

  const SenderCheckoutScreen({super.key, required this.user});

  @override
  State<SenderCheckoutScreen> createState() => _SenderCheckoutScreenState();
}

class _SenderCheckoutScreenState extends State<SenderCheckoutScreen> {
  // Default sample locations tailored to Sendalli corridor operations
  final String _pickupStore = 'Warri Central Kitchen';
  final String _storeDistance = 'Distance from you: 3.8 km';
  final String _dropoffTitle = 'Effurun Market Plaza, Shop 14B';
  final String _dropoffAddress = '78 Airport Road, Effurun, Delta State';
  String? _addressDetails;
  String? _noteToDriver;
  bool _isFavoriteLocation = false;

  // Package constraints per Warri Transit-Logistics Business Model V3.md
  String _packageSize = 'Lap Size'; // 'Lap Size' (fits on lap) or 'Under-Seat'
  final double _declaredValue = 5000.0; // Max ₦20,000 cap
  final String _recipientPhone = '+234 803 000 1234';

  // Delivery option: 0 = Priority, 1 = Standard
  int _selectedTierIndex = 0;

  final double _baseItemTotal = 1200.0;
  final double _priorityFee = 650.0;
  final double _standardFee = 400.0;

  double get _currentFee => _selectedTierIndex == 0 ? _priorityFee : _standardFee;
  double get _orderTotal => _baseItemTotal + _currentFee;

  void _openSaveLocationSheet() {
    SaveLocationSheet.show(
      context,
      initialAddressDetails: _addressDetails,
      initialNoteToDriver: _noteToDriver,
      onSave: (details, note, saveFav) {
        setState(() {
          _addressDetails = details.isNotEmpty ? details : null;
          _noteToDriver = note.isNotEmpty ? note : null;
          _isFavoriteLocation = saveFav;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delivery instructions saved.')),
        );
      },
      onSkip: () {
        // Dismissed with default
      },
    );
  }

  void _handlePlaceOrder() {
    final orderId = '#SE${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SenderOrderTrackingScreen(
          orderId: orderId,
          merchantName: widget.user.shopName ?? _pickupStore,
          pickupAddress: '$_pickupStore (Pickup Location)',
          dropoffAddress: '$_dropoffTitle, $_dropoffAddress',
          totalAmount: '₦ ${_orderTotal.toStringAsFixed(2)}',
          deliveryOption: _selectedTierIndex == 0 ? 'Priority (< 15 mins)' : 'Standard (25 mins)',
          addressDetails: _addressDetails,
          noteToDriver: _noteToDriver,
        ),
      ),
    );
  }

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.shopName ?? _pickupStore,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _storeDistance,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimens.screenInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Delivery Mode Card
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
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FeatherIcons.truck, size: 20, color: AppColors.primaryDark),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Deliver now',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delivery mode options: On Demand or Scheduled.')),
                      );
                    },
                    child: Text(
                      'Change',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. Schedule & Flexibility Promo Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Want more flexibility?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Order for later to pick the best delivery time slot and fees for you.',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(FeatherIcons.tag, size: 18, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. Location & Address Details Card
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
                  InkWell(
                    onTap: _openSaveLocationSheet,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(FeatherIcons.mapPin, size: 16, color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _dropoffTitle,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (_isFavoriteLocation) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.favorite, size: 14, color: Colors.red),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _dropoffAddress,
                                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        const Icon(FeatherIcons.chevronRight, size: 18, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const SendalliMapView(
                      height: 130,
                      corridorName: 'Delivery Corridor: Warri — Effurun',
                      showLiveRider: false,
                    ),
                  ),
                  const Divider(color: AppColors.border, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _addressDetails != null
                              ? '$_addressDetails${_noteToDriver != null ? " • $_noteToDriver" : ""}'
                              : 'Add address details and delivery instructions',
                          style: AppTextStyles.caption.copyWith(
                            color: _addressDetails != null ? AppColors.textPrimary : AppColors.textMuted,
                            fontWeight: _addressDetails != null ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: _openSaveLocationSheet,
                        child: Text(
                          _addressDetails != null ? 'Edit' : 'Add',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Package Specifications & Declared Value (Warri Transit-Logistics Business Model V3.md)
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
                      Text('Package Specifications', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Max ₦20,000 Cap',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Transit Size (Must fit without blocking passengers):', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Lap Size (Standard)'),
                        selected: _packageSize == 'Lap Size',
                        onSelected: (sel) {
                          if (sel) setState(() => _packageSize = 'Lap Size');
                        },
                        selectedColor: AppColors.primaryLight,
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Under-Seat Size'),
                        selected: _packageSize == 'Under-Seat',
                        onSelected: (sel) {
                          if (sel) setState(() => _packageSize = 'Under-Seat');
                        },
                        selectedColor: AppColors.primaryLight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Declared Value:', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text('₦ ${_declaredValue.toStringAsFixed(0)} (Insured via Escrow)', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recipient Contact:', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text(_recipientPhone, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Delivery Options Section
            Row(
              children: [
                const Icon(FeatherIcons.send, size: 16, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(
                  'Delivery Options',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Priority Option
            _DeliveryOptionCard(
              title: 'Priority < 15 mins',
              subtitle: "We'll prioritize finding you a driver. You'll get a ₦ 200 voucher if no driver is available.",
              price: '₦ ${_priorityFee.toStringAsFixed(2)}',
              isSelected: _selectedTierIndex == 0,
              onTap: () => setState(() => _selectedTierIndex = 0),
            ),
            const SizedBox(height: 10),

            // Standard Option
            _DeliveryOptionCard(
              title: 'Standard 25 mins',
              subtitle: 'Reliable roadside handover matching regular keke corridor schedules.',
              price: '₦ ${_standardFee.toStringAsFixed(2)}',
              isSelected: _selectedTierIndex == 1,
              onTap: () => setState(() => _selectedTierIndex = 1),
            ),
            const SizedBox(height: 90), // Space for sticky bottom bar
          ],
        ),
      ),

      // 5. Sticky Bottom Checkout Bar
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.screenPaddingH, vertical: 14),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: AppDimens.borderWidth)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '₦ ${_orderTotal.toStringAsFixed(2)}',
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handlePlaceOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textInverse,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Place Order',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliveryOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryOptionCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.4) : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? AppDimens.borderWidthThick : AppDimens.borderWidth,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              price,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
