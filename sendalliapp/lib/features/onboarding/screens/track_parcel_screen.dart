import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/storage/session_manager.dart';
import '../../../widgets/form_randomizer.dart';
import '../../dashboard/screens/receiver_home_screen.dart';
import '../../dashboard/screens/receiver_tracking_screen.dart';

/// Dedicated, separate screen for the Receiver context.
/// Zero login required. Allows users to track parcels with live ETA and handover PIN.
class TrackParcelScreen extends StatefulWidget {
  const TrackParcelScreen({super.key});

  @override
  State<TrackParcelScreen> createState() => _TrackParcelScreenState();
}

class _TrackParcelScreenState extends State<TrackParcelScreen> {
  final TextEditingController _trackingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _trackingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _randomize() {
    setState(() {
      _trackingController.text = FormSampleData.randomTrackingId();
      _errorMessage = null;
    });
  }

  Future<void> _submitTracking() async {
    final query = _trackingController.text.trim().toUpperCase();
    if (query.isEmpty) {
      setState(() => _errorMessage = 'Please enter a valid Tracking ID');
      return;
    }

    await SessionManager.saveTrackingId(query);
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReceiverTrackingScreen(trackingId: query),
      ),
    );
  }

  void _openReceiverPortal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReceiverHomeScreen(
          user: UserProfile.guestReceiver(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _trackingController.text.isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        AppNavigator.safePop(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(FeatherIcons.arrowLeft, size: 20),
            onPressed: () => AppNavigator.safePop(context),
          ),
          title: Text(
            'Track Parcel',
            style: AppTextStyles.caption.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            RandomizeButton(label: 'Sample ID', onRandomize: _randomize),
          ],
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Artwork for Receiver Context
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SvgPicture.asset(
                    'assets/svg/delivery-location.svg',
                    height: 150,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Text('Track Your Parcel', style: AppTextStyles.h1),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'NO LOGIN',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Enter the 10-digit Tracking ID shared by the sender or from your SMS arrival link.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Square High-Visibility Input Box
              Text(
                'TRACKING NUMBER',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6), // Modern square radius
                  border: Border.all(
                    color: _errorMessage != null
                        ? AppColors.danger
                        : (_isFocused ? AppColors.primaryDark : AppColors.borderMedium),
                    width: _isFocused ? 1.6 : 1.4,
                  ),
                ),
                child: TextField(
                  controller: _trackingController,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.characters,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'SND-WAR-8492',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 15,
                      letterSpacing: 1.0,
                      color: AppColors.textMuted,
                    ),
                    prefixIcon: const Icon(
                      FeatherIcons.package,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: hasText
                        ? IconButton(
                            icon: const Icon(FeatherIcons.xCircle, size: 16, color: AppColors.textMuted),
                            onPressed: () {
                              setState(() {
                                _trackingController.clear();
                                _errorMessage = null;
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                  onChanged: (_) {
                    if (_errorMessage != null) {
                      setState(() => _errorMessage = null);
                    }
                  },
                ),
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 2.0),
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.danger,
                      fontSize: 12,
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Quick sample suggestions
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Sample IDs:',
                    style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textMuted),
                  ),
                  _buildSampleChip('SND-WAR-8492'),
                  _buildSampleChip('SND-EFF-4019'),
                  _buildSampleChip('SND-DSC-7721'),
                ],
              ),

              const SizedBox(height: 36),

              // Primary Action: Track Live Delivery
              ElevatedButton.icon(
                onPressed: _submitTracking,
                icon: const Icon(FeatherIcons.search, size: 16),
                label: const Text('Track Live Delivery'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),

              // Secondary Action: Open Full Receiver Portal
              OutlinedButton.icon(
                onPressed: _openReceiverPortal,
                icon: const Icon(FeatherIcons.mapPin, size: 16),
                label: const Text('Open Receiver Portal & Hubs'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: const BorderSide(color: AppColors.borderMedium, width: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }

  Widget _buildSampleChip(String sampleId) {
    return InkWell(
      onTap: () {
        setState(() {
          _trackingController.text = sampleId;
          _errorMessage = null;
        });
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.borderMedium, width: 0.8),
        ),
        child: Text(
          sampleId,
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
