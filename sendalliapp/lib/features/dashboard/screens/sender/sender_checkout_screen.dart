import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/corridor_constants.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../widgets/checkout/save_location_sheet.dart';
import '../../../../widgets/delivery/parcel_photo_card.dart';
import '../../../../widgets/map/sendalli_map_view.dart';
import 'sender_order_tracking_screen.dart';

/// Redesigned Sender Checkout & Parcel Dispatch Screen tailored to the Sendalli
/// Transit-Logistics Corridor Vision (Warri & Effurun).
///
/// Enables local merchants and senders to pool small parcels into commercial
/// tricycles (kekes) travelling established transit corridors (Refinery Road,
/// PTI Road, Airport Road, Enerhen Junction, Jakpa) for fare-anchored prices.
/// Features mandatory dispatch parcel photo upload and two-way photo verification protocol.
class SenderCheckoutScreen extends StatefulWidget {
  final UserProfile user;

  const SenderCheckoutScreen({super.key, required this.user});

  @override
  State<SenderCheckoutScreen> createState() => _SenderCheckoutScreenState();
}

class _SenderCheckoutScreenState extends State<SenderCheckoutScreen> {
  // Corridor & Route locations matching Sendalli secondary-city operations
  late final String _pickupStore;
  final String _storeDistance = 'Distance from you: 3.8 km';
  final String _selectedCorridor = CorridorConstants.pilotCorridors.first;
  final String _dropoffTitle = 'Effurun Market Plaza, Shop 14B';
  final String _dropoffAddress = '78 Airport Road, Effurun, Delta State';
  String? _addressDetails;
  String? _noteToDriver;

  // Parcel identity & mandatory image upload ("send should upload item image")
  late final TextEditingController _packageNameController;
  String? _photoAsset = 'assets/images/parcel_sample.png';
  String _captureTimestamp = 'Dispatch Photo • Just now';

  // Package transit size constraints (Must fit alongside passengers in commercial kekes)
  String _packageSize = 'Lap Size'; // 'Lap Size' or 'Under-Seat'
  final double _declaredValue = 5000.0; // Insured via Escrow, Max ₦20,000 cap
  final String _recipientPhone = '+234 803 000 1234';
  final String _recipientName = 'Amara Okafor';

  // Delivery option: 0 = Priority (< 15 mins), 1 = Standard (25 mins)
  int _selectedTierIndex = 0;

  final double _baseItemTotal = 1200.0;
  final double _priorityFee = 650.0;
  final double _standardFee = 400.0;

  double get _currentFee => _selectedTierIndex == 0 ? _priorityFee : _standardFee;
  double get _orderTotal => _baseItemTotal + _currentFee;

  @override
  void initState() {
    super.initState();
    _pickupStore = widget.user.shopName ?? 'Amaka Kitchen & Grills';
    _packageNameController = TextEditingController(text: 'Food • Jollof Rice, meat and moi moi');
  }

  @override
  void dispose() {
    _packageNameController.dispose();
    super.dispose();
  }

  void _openSaveLocationSheet() {
    SaveLocationSheet.show(
      context,
      initialAddressDetails: _addressDetails,
      initialNoteToDriver: _noteToDriver,
      onSave: (details, note, saveFav) {
        setState(() {
          _addressDetails = details.isNotEmpty ? details : null;
          _noteToDriver = note.isNotEmpty ? note : null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delivery instructions saved.')),
        );
      },
      onSkip: () {},
    );
  }

  void _simulatePhotoCapture() {
    setState(() {
      _photoAsset = 'assets/images/parcel_sample.png';
      _captureTimestamp = 'Dispatch Photo • Verified at ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Parcel dispatch photo captured successfully!'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  void _selectSampleItem(String name, String category) {
    setState(() {
      _packageNameController.text = name;
      _photoAsset = 'assets/images/parcel_sample.png';
      _captureTimestamp = '$category Photo • Attached';
    });
  }

  void _handlePlaceOrder() {
    final orderId = '#SE${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SenderOrderTrackingScreen(
          orderId: orderId,
          senderName: _pickupStore,
          pickupAddress: '$_pickupStore (Pickup Location)',
          dropoffAddress: '$_dropoffTitle, $_dropoffAddress',
          totalAmount: '₦ ${_orderTotal.toStringAsFixed(2)}',
          deliveryOption: _selectedTierIndex == 0 ? 'Priority (< 15 mins)' : 'Standard (25 mins)',
          addressDetails: _addressDetails,
          noteToDriver: _noteToDriver,
          packageValue: '₦ ${_declaredValue.toStringAsFixed(0)}',
          photoAsset: _photoAsset,
          itemDescription: _packageNameController.text,
          customerName: _recipientName,
          customerPhone: _recipientPhone,
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
              _pickupStore,
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
            // 1. Sendalli Corridor Transit-Logistics Concept Header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FeatherIcons.truck, size: 18, color: Color(0xFF16A34A)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Keke Route-Pooled Delivery',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF166534),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'TRANSIT POOL',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF166534),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Your small parcel rides with a commercial keke already travelling along the corridor. Fast, affordable, and escrow-secured.',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF15803D),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. Interactive Corridor Route Map Preview & Stops
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map View with Corridor Tag
                  Stack(
                    children: [
                      SendalliMapView(
                        height: 135,
                        corridorName: _selectedCorridor,
                        showLiveRider: true,
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.border, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FeatherIcons.navigation, size: 12, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                'Delivery Corridor: Warri — Effurun',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Route Roadside Stops
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
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
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Pickup Stop: $_pickupStore',
                                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Roadside Drop-off: $_dropoffTitle',
                                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: AppColors.border, height: 1),
                        const SizedBox(height: 8),

                        // Delivery instructions link (matching screenshot element)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _addressDetails ?? 'Add address details and delivery instructions',
                                style: AppTextStyles.caption.copyWith(
                                  color: _addressDetails != null ? AppColors.textPrimary : AppColors.textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              onPressed: _openSaveLocationSheet,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
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
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Package Specifications & Mandatory Image Upload Section ("send should upload item image")
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Package Specifications',
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Max ₦20,000 Cap',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Mandatory Item Photo Card
                  Text(
                    'PARCEL DISPATCH PHOTO (MANDATORY)',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Interactive Parcel Photo Preview
                  ParcelPhotoCard(
                    orderId: 'NEW-DISPATCH',
                    packageItem: _packageNameController.text,
                    packageValue: '₦ ${_declaredValue.toStringAsFixed(0)}',
                    photoAsset: _photoAsset,
                    captureTime: _captureTimestamp,
                    margin: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 10),

                  // Photo Capture Actions & Sample Pickers
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _simulatePhotoCapture,
                          icon: const Icon(FeatherIcons.camera, size: 14),
                          label: const Text('Snap Item Photo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                                                      _photoAsset = 'assets/images/parcel_sample.png';
                              _captureTimestamp = 'Gallery Photo • Uploaded';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Item photo uploaded from gallery.')),
                            );
                          },
                          icon: const Icon(FeatherIcons.image, size: 14),
                          label: const Text('Upload Image'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Quick-fill sample item tags
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSampleItemChip('🍱 Food Cooler', 'Food • Jollof Rice, meat and moi moi', 'Food'),
                        const SizedBox(width: 6),
                        _buildSampleItemChip('👗 Fashion Pack', 'Fashion • 5 Yards Ankara & Lace', 'Fashion'),
                        const SizedBox(width: 6),
                        _buildSampleItemChip('📱 Gadget & Spares', 'Electronics • Bluetooth Speaker & Charger', 'Electronics'),
                        const SizedBox(width: 6),
                        _buildSampleItemChip('💊 Medicine Box', 'Pharmacy • Prescription Drugs Box', 'Pharmacy'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Transit Size Selection (Keke passenger constraints)
                  Text(
                    'Transit Size (Must fit without blocking passengers):',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_packageSize == 'Lap Size') ...[
                              const Icon(FeatherIcons.check, size: 14, color: AppColors.primaryDark),
                              const SizedBox(width: 4),
                            ],
                            const Text('Lap Size (Standard)'),
                          ],
                        ),
                        selected: _packageSize == 'Lap Size',
                        onSelected: (sel) {
                          if (sel) setState(() => _packageSize = 'Lap Size');
                        },
                        selectedColor: AppColors.primaryLight,
                      ),
                      const SizedBox(width: 10),
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
                      Text('₦ ${_declaredValue.toStringAsFixed(0)} (Insured via Escrow)',
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
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
            const SizedBox(height: 16),

            // 4. Two-Way Photo Verification Guarantee Card ("rider should snap and send confirmation picture")
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(FeatherIcons.shield, size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Two-Way Photo Verification Protocol',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. Sender attaches item dispatch photo before booking.\n'
                    '2. Keke rider snaps & submits confirmation picture with recipient at roadside drop-off.\n'
                    '3. Recipient inspects item & supplies 6-digit PIN before escrow releases.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(FeatherIcons.checkCircle, size: 12, color: Color(0xFF16A34A)),
                      const SizedBox(width: 6),
                      Text(
                        '100% Escrow Protected • Zero Package Tampering',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF166534),
                          fontWeight: FontWeight.w700,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Delivery Options Section (Fare-anchored keke pricing)
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

      // 6. Sticky Bottom Checkout Bar
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

  Widget _buildSampleItemChip(String label, String fullItemName, String category) {
    final isCurrent = _packageNameController.text == fullItemName;
    return InkWell(
      onTap: () => _selectSampleItem(fullItemName, category),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: isCurrent ? AppColors.primaryLight : AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isCurrent ? AppColors.primary : AppColors.border,
            width: isCurrent ? 1.2 : 0.8,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            color: isCurrent ? AppColors.primaryDark : AppColors.textPrimary,
            fontSize: 11,
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
