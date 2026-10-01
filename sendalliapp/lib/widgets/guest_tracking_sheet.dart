import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/storage/session_manager.dart';
import '../features/dashboard/screens/receiver_tracking_screen.dart';
import 'custom_text_field.dart';
import 'form_randomizer.dart';

/// Instant bottom sheet allowing receivers to enter a Tracking ID with zero registration.
class GuestTrackingSheet extends StatefulWidget {
  const GuestTrackingSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const GuestTrackingSheet(),
    );
  }

  @override
  State<GuestTrackingSheet> createState() => _GuestTrackingSheetState();
}

class _GuestTrackingSheetState extends State<GuestTrackingSheet> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitTrackingId() async {
    final query = _controller.text.trim().toUpperCase();
    if (query.isEmpty) {
      setState(() => _errorMessage = 'Please enter your Tracking ID');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Save tracking ID locally for persistence
    await SessionManager.saveTrackingId(query);

    if (!mounted) return;
    Navigator.of(context).pop(); // dismiss sheet

    // Navigate to live receiver tracking screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReceiverTrackingScreen(trackingId: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: bottomInset + 32,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Track Your Parcel', style: AppTextStyles.h2),
              RandomizeButton.inline(
                label: 'Sample ID',
                onRandomize: () {
                  setState(() {
                    _controller.text = FormSampleData.randomTrackingId();
                    _errorMessage = null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Enter the Tracking ID shared by the sender or from your SMS link.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _controller,
            labelText: 'Tracking ID',
            hintText: 'e.g. SND-WAR-8492',
            textCapitalization: TextCapitalization.characters,
            prefixIcon: FeatherIcons.search,
            validator: (_) => _errorMessage,
            onChanged: (_) {
              if (_errorMessage != null) {
                setState(() => _errorMessage = null);
              }
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitTrackingId,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
                  )
                : const Text('Track Package Now'),
          ),
        ],
      ),
    );
  }
}
