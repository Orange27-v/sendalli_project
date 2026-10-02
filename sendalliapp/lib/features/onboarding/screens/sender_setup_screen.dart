import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/constants/corridor_constants.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/form_randomizer.dart';
import '../../../widgets/map/sendalli_map_view.dart';
import '../../../widgets/permission_dialog.dart';
import '../../../widgets/profile_completed_dialog.dart';
import '../../dashboard/screens/sender/sender_home_screen.dart';
import 'business_sender_registration_screen.dart';

/// Branch A: Sender Setup Screen.
class SenderSetupScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String pin;

  const SenderSetupScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.pin,
  });

  @override
  State<SenderSetupScreen> createState() => _SenderSetupScreenState();
}

class _SenderSetupScreenState extends State<SenderSetupScreen> {
  final _shopNameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedCorridor = CorridorConstants.pilotCorridors.first;
  String _selectedCategory = 'Food & Groceries';
  bool _isLoading = false;

  final List<String> _categories = [
    'Food & Groceries',
    'Fashion & Retail',
    'Electronics',
    'Documents',
  ];

  void _randomize() {
    setState(() {
      _shopNameController.text = FormSampleData.randomSenderShop();
      _emailController.text = FormSampleData.randomEmail(widget.firstName);
      _selectedCorridor = FormSampleData.randomCorridor();
    });
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _completeSetup() async {
    setState(() => _isLoading = true);

    // Request Notification permission contextually (Modal - Location-1.png)
    await PermissionDialog.show(
      context: context,
      icon: FeatherIcons.bell,
      title: 'Turn on Notifications',
      description: 'Get a message when a rider picks up and brings your parcel.',
      primaryButtonText: 'Turn On Notifications',
    );

    final shopName = _shopNameController.text.trim();
    final user = UserProfile(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      firstName: widget.firstName,
      lastName: widget.lastName,
      phone: widget.phoneNumber,
      role: UserRole.sender,
      pin: widget.pin,
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      shopName: shopName.isNotEmpty ? shopName : '${widget.firstName}\'s Shop',
      corridor: _selectedCorridor,
      isVerified: true,
    );

    await SessionManager.saveUserProfile(user);

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Display profile completed modal (Modal - Location-2.png)
    ProfileCompletedDialog.show(
      context: context,
      subtitle: 'You\'re all set! Start sending parcels now.',
      onContinue: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => SenderHomeScreen(user: user)),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        AppNavigator.safePop(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Sender Profile',
          actions: [
            RandomizeButton(onRandomize: _randomize),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sender Details', style: AppTextStyles.h1),
                const SizedBox(height: 6),
                Text(
                  'Tell us your name or business name and dispatch corridor so keke riders know where to pick up.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 20),

                // Sender Header Preview Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primaryLight,
                        child: const Icon(FeatherIcons.shoppingBag, color: AppColors.primaryDark, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _shopNameController.text.isNotEmpty
                                  ? _shopNameController.text
                                  : "${widget.firstName}'s Store",
                              style: AppTextStyles.h3,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Verified Commercial Sender',
                              style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'PIONEER',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Commercial Business Sender Application Card (Separate Dedicated Screen)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(FeatherIcons.award, size: 16, color: Color(0xFF16A34A)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Applying as a Registered Business?',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF166534),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Senders applying to become verified commercial partners must file a complete registration form and upload their CAC business registration certificate on a dedicated form.',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF15803D),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          key: const Key('apply_as_business_sender_btn'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BusinessSenderRegistrationScreen(
                                  phoneNumber: widget.phoneNumber,
                                  firstName: widget.firstName,
                                  lastName: widget.lastName,
                                  pin: widget.pin,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(FeatherIcons.fileText, size: 14),
                          label: const Text('File Business Form & Upload CAC →'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF166534),
                            side: const BorderSide(color: Color(0xFF16A34A)),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Corridor Route Map Preview
                Text('Primary Corridor Dispatch Base', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SendalliMapView(
                    height: 125,
                    corridorName: _selectedCorridor,
                    showLiveRider: false,
                  ),
                ),
                const SizedBox(height: 20),

                // Form Details Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _shopNameController,
                        labelText: 'Sender / Business Name',
                        hintText: 'e.g. Warri Central Kitchen',
                        textCapitalization: TextCapitalization.words,
                        prefixIcon: FeatherIcons.shoppingBag,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email Address (for Receipts & Tracking)',
                        hintText: 'e.g. sender@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: FeatherIcons.mail,
                      ),
                      const SizedBox(height: 16),

                      // Corridor Dropdown
                      CustomDropdownField<String>(
                        labelText: 'Primary Corridor Base',
                        value: _selectedCorridor,
                        prefixIcon: FeatherIcons.navigation,
                        items: CorridorConstants.pilotCorridors.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCorridor = val);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category Selector Chips
                      Text('Business Category', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedCategory = cat);
                            },
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surfaceSubtle,
                            labelStyle: AppTextStyles.caption.copyWith(
                              color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _completeSetup,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textInverse),
                          )
                        : const Text('Complete & Start Sending'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
