import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Modal bottom sheet allowing riders to object to a delivery fee
/// and propose the amount they are willing to accept for the trip.
class ProposeFareSheet extends StatefulWidget {
  final String orderId;
  final String currentFee;
  final void Function(String proposedAmount, String? reason) onSendOffer;

  const ProposeFareSheet({
    super.key,
    required this.orderId,
    required this.currentFee,
    required this.onSendOffer,
  });

  static Future<void> show({
    required BuildContext context,
    required String orderId,
    required String currentFee,
    required void Function(String proposedAmount, String? reason) onSendOffer,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: ProposeFareSheet(
          orderId: orderId,
          currentFee: currentFee,
          onSendOffer: onSendOffer,
        ),
      ),
    );
  }

  @override
  State<ProposeFareSheet> createState() => _ProposeFareSheetState();
}

class _ProposeFareSheetState extends State<ProposeFareSheet> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedReason;

  final List<String> _commonReasons = [
    'Heavy Cargo / Weight',
    'Detour from Main Corridor',
    'Peak Traffic Jam',
    'Rain / Flooded Road',
  ];

  @override
  void initState() {
    super.initState();
    // Default proposed amount: e.g. current fee or slight bump
    final digits = widget.currentFee.replaceAll(RegExp(r'[^0-9]'), '');
    final numVal = int.tryParse(digits) ?? 500;
    _amountController.text = (numVal + 150).toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _addAmount(int addition) {
    final current = int.tryParse(_amountController.text.trim()) ?? 0;
    setState(() {
      _amountController.text = (current + addition).toString();
    });
  }

  void _submit() {
    final text = _amountController.text.trim();
    if (text.isEmpty) return;
    final formatted = '₦ $text.00';
    Navigator.of(context).pop();
    widget.onSendOffer(formatted, _selectedReason);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.borderMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title & Subtitle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Object & Propose Fare', style: AppTextStyles.h2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.orderId,
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Riders can specify the amount they would take for this delivery. The sender will review your counter-offer immediately.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),

          // Current offer box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(FeatherIcons.tag, size: 15, color: AppColors.textMuted),
                    const SizedBox(width: 8),
                    Text(
                      'Sender Offered Price:',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.currentFee,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Proposed Amount Input Field
          Text(
            'Your Proposed Amount (₦)',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            key: const Key('propose_fare_input'),
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
            decoration: InputDecoration(
              prefixText: '₦ ',
              prefixStyle: AppTextStyles.h2.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
              hintText: 'Enter amount',
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: AppColors.surfaceSubtle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Quick Increment Chips
          Wrap(
            spacing: 8,
            children: [
              _buildQuickAddChip('+₦100', 100),
              _buildQuickAddChip('+₦200', 200),
              _buildQuickAddChip('+₦300', 300),
              _buildQuickAddChip('+₦500', 500),
            ],
          ),
          const SizedBox(height: 16),

          // Reason for Objection (Optional)
          Text(
            'Reason for Objection (Optional)',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _commonReasons.map((reason) {
              final isSelected = _selectedReason == reason;
              return ChoiceChip(
                label: Text(reason),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    _selectedReason = val ? reason : null;
                  });
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                backgroundColor: AppColors.surfaceSubtle,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Action Buttons: Send Proposed Amount & Cancel
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: AppColors.borderMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  key: const Key('send_proposed_amount_button'),
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textInverse,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Send Proposed Amount',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                      ),
                      SizedBox(width: 6),
                      Icon(FeatherIcons.send, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddChip(String label, int value) {
    return ActionChip(
      label: Text(label),
      onPressed: () => _addAmount(value),
      backgroundColor: AppColors.surfaceSubtle,
      labelStyle: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
