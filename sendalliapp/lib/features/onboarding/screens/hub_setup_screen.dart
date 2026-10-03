import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'business_sender_registration_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../../core/constants/corridor_constants.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/map/sendalli_map_view.dart';
import '../../../widgets/permission_dialog.dart';
import '../../../widgets/profile_completed_dialog.dart';
import '../../dashboard/screens/hub/hub_home_screen.dart';

/// Branch C: Drop Hub Partner Setup Screen.
/// Hub centers serve as physical roadside custody and holding points for parcels along corridors.
/// This is a complete business application form requiring registered business identity,
/// corridor location, capacity, settlement banking, and mandatory CAC certificate upload.
class HubSetupScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String pin;

  const HubSetupScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.pin,
  });

  @override
  State<HubSetupScreen> createState() => _HubSetupScreenState();
}

class _HubSetupScreenState extends State<HubSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  // Note: Test suite expects:
  // TextField index 0: Store / Business Name
  // TextField index 1: Roadside Landmark
  // TextField index 2: Email Address (for Invoices & Holding Fees)
  final _storeNameController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _emailController = TextEditingController();
  final _cacNumberController = TextEditingController();
  final _tinController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();

  String _selectedCorridor = CorridorConstants.pilotCorridors.first;
  String _selectedCapacity = '20-50 Parcels';
  String _selectedBank = 'Zenith Bank';
  bool _isLoading = false;
  bool _isUploadingCertificate = false;
  bool _hasAgreedToTerms = true;

  // Certificate Upload State
  String? _certificateFileName;
  String? _certificateFileSize;

  final List<String> _capacities = [
    '10-20 Parcels',
    '20-50 Parcels',
    '50+ Parcels',
  ];

  final List<String> _banks = [
    'Zenith Bank',
    'First Bank of Nigeria',
    'Access Bank',
    'Guaranty Trust Bank (GTB)',
    'United Bank for Africa (UBA)',
    'Fidelity Bank',
    'Stanbic IBTC',
  ];

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phoneNumber;
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _landmarkController.dispose();
    _emailController.dispose();
    _cacNumberController.dispose();
    _tinController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  void _fillSampleBusinessData() {
    setState(() {
      _storeNameController.text = 'Warri Central Mercantile Ltd';
      _landmarkController.text = 'Opposite First Gate, PTI Road, Effurun';
      _emailController.text = 'compliance@warricentral.ng';
      _cacNumberController.text = 'RC-1849204';
      _tinController.text = '23891048-0001';
      _addressController.text = 'Block C, Deco Commercial Center, Warri';
      _phoneController.text = widget.phoneNumber.isNotEmpty ? widget.phoneNumber : '+234 803 555 8899';
      _accountNumberController.text = '1029384756';
      _accountNameController.text = 'Warri Central Mercantile Ltd';
      _selectedBank = 'Zenith Bank';
      _selectedCorridor = CorridorConstants.pilotCorridors.first;
      _selectedCapacity = '20-50 Parcels';
      _certificateFileName = 'CAC_Incorporation_Cert.pdf';
      _certificateFileSize = '1.84 MB • PDF Document';
      _hasAgreedToTerms = true;
    });
  }

  void _simulateCertificatePick() async {
    setState(() => _isUploadingCertificate = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      _isUploadingCertificate = false;
      _certificateFileName = 'CAC_Certificate_Registration_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}.pdf';
      _certificateFileSize = '2.1 MB • Corporate Affairs Commission';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CAC Registration Certificate attached successfully!'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  void _loadSampleCertificate() {
    setState(() {
      _certificateFileName = 'CAC_Incorporation_Cert.pdf';
      _certificateFileSize = '1.84 MB • PDF Document';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sample CAC Certificate attached!'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  void _removeCertificate() {
    setState(() {
      _certificateFileName = null;
      _certificateFileSize = null;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _completeSetup() async {
    if (_storeNameController.text.trim().isEmpty) {
      _showError('Please enter your Registered Business Name.');
      return;
    }
    if (_landmarkController.text.trim().isEmpty) {
      _showError('Please enter your roadside landmark.');
      return;
    }
    if (_cacNumberController.text.trim().isEmpty) {
      _showError('Please enter your CAC Registration (RC or BN) number.');
      return;
    }
    if (_certificateFileName == null) {
      _showError('Business Registration Certificate is mandatory. Please upload your CAC certificate.');
      return;
    }
    if (!_hasAgreedToTerms) {
      _showError('Please confirm the regulatory declaration to proceed.');
      return;
    }

    setState(() => _isLoading = true);

    // Request Notification permission contextually
    await PermissionDialog.show(
      context: context,
      icon: FeatherIcons.bell,
      title: 'Turn on Hub Notifications',
      description: 'Get instant alerts when riders are en route to drop off or pick up parcels at your shop.',
      primaryButtonText: 'Enable Notifications',
    );

    final user = UserProfile(
      id: 'HUB-${DateTime.now().millisecondsSinceEpoch}',
      firstName: widget.firstName,
      lastName: widget.lastName,
      phone: widget.phoneNumber,
      role: UserRole.hub,
      pin: widget.pin,
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      shopName: _storeNameController.text.trim(),
      landmark: _landmarkController.text.trim(),
      corridor: _selectedCorridor,
      isVerified: true,
      isBusinessVerified: true,
      cacNumber: _cacNumberController.text.trim(),
      businessCertificateName: _certificateFileName,
      tinNumber: _tinController.text.trim().isNotEmpty ? _tinController.text.trim() : null,
      bankName: _selectedBank,
      accountNumber: _accountNumberController.text.trim().isNotEmpty ? _accountNumberController.text.trim() : null,
    );

    await SessionManager.saveUserProfile(user);

    if (!mounted) return;
    setState(() => _isLoading = false);

    ProfileCompletedDialog.show(
      context: context,
      subtitle: 'Hub Application Submitted! Your roadside drop hub partner profile has been registered with verified CAC status.',
      onContinue: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HubHomeScreen(user: user)),
          (route) => false,
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hub Center Application',
        actions: [
          TextButton.icon(
            key: const Key('quick_fill_business_btn'),
            onPressed: _fillSampleBusinessData,
            icon: const Icon(FeatherIcons.zap, size: 14, color: Colors.white),
            label: Text(
              'Sample Data',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Verification Callout Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(FeatherIcons.award, size: 20, color: Color(0xFF16A34A)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hub Center Business Registration',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF166534),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Drop Hub Centers serve as physical parcel custody points. Complete this registered business application and upload your CAC certificate below.',
                                  style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFF15803D),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          key: const Key('apply_as_hub_center_btn'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => HubCenterRegistrationScreen(
                                  phoneNumber: widget.phoneNumber,
                                  firstName: widget.firstName,
                                  lastName: widget.lastName,
                                  pin: widget.pin,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(FeatherIcons.fileText, size: 14),
                          label: const Text('Review Registration Checklist & Guidelines →'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF166534),
                            side: const BorderSide(color: Color(0xFF16A34A)),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 1: Business Identity
                _buildSectionHeader('1. REGISTERED BUSINESS IDENTITY', FeatherIcons.briefcase),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        key: const Key('business_name_field'),
                        controller: _storeNameController,
                        labelText: 'Shop / Registered Business Name *',
                        hintText: 'e.g. City Care Pharmacy & Stores',
                        textCapitalization: TextCapitalization.words,
                        prefixIcon: FeatherIcons.home,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        key: const Key('landmark_field'),
                        controller: _landmarkController,
                        labelText: 'Roadside Landmark / Premises *',
                        hintText: 'e.g. PTI Road, opposite First Gate',
                        textCapitalization: TextCapitalization.words,
                        prefixIcon: FeatherIcons.mapPin,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        key: const Key('email_field'),
                        controller: _emailController,
                        labelText: 'Email Address (for Invoices & Holding Fees)',
                        hintText: 'e.g. hub@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: FeatherIcons.mail,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              key: const Key('business_cac_field'),
                              controller: _cacNumberController,
                              labelText: 'CAC RC/BN Number *',
                              hintText: 'e.g. RC-1849204',
                              prefixIcon: FeatherIcons.shield,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              key: const Key('business_tin_field'),
                              controller: _tinController,
                              labelText: 'Tax ID (TIN)',
                              hintText: 'e.g. 23891048-0001',
                              prefixIcon: FeatherIcons.hash,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 2: Corridor Location & Capacity
                _buildSectionHeader('2. CORRIDOR LOCATION & CAPACITY', FeatherIcons.navigation),
                const SizedBox(height: 10),
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
                      CustomDropdownField<String>(
                        labelText: 'Corridor Route Base *',
                        value: _selectedCorridor,
                        prefixIcon: FeatherIcons.navigation,
                        items: CorridorConstants.pilotCorridors.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCorridor = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
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
                      const SizedBox(height: 14),
                      CustomTextField(
                        key: const Key('address_field'),
                        controller: _addressController,
                        labelText: 'Physical Shop / Office Address',
                        hintText: 'e.g. Shop 14, Commercial Plaza, Deco Road, Warri',
                        prefixIcon: FeatherIcons.map,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        key: const Key('phone_field'),
                        controller: _phoneController,
                        labelText: 'Contact / WhatsApp Phone Number',
                        hintText: 'e.g. +234 803 555 8899',
                        keyboardType: TextInputType.phone,
                        prefixIcon: FeatherIcons.phone,
                      ),
                      const SizedBox(height: 14),
                      Text('Holding Capacity', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _capacities.map((cap) {
                          final isSelected = _selectedCapacity == cap;
                          return ChoiceChip(
                            label: Text(cap),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedCapacity = cap);
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
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(FeatherIcons.moon, size: 15, color: AppColors.warning),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Overnight Sleepover Custody Enabled: Attracts extra ₦500 per night per parcel paid directly into your wallet.',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 3: CAC Certificate Upload
                _buildSectionHeader('3. CAC REGISTRATION CERTIFICATE (MANDATORY)', FeatherIcons.fileText),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _certificateFileName != null ? const Color(0xFF16A34A) : AppColors.border,
                      width: _certificateFileName != null ? 1.5 : AppDimens.borderWidth,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload official CAC Certificate of Incorporation or Business Name Registration (PDF, PNG, JPG).',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, height: 1.35),
                      ),
                      const SizedBox(height: 12),
                      if (_certificateFileName == null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderMedium, style: BorderStyle.solid),
                          ),
                          child: Column(
                            children: [
                              const Icon(FeatherIcons.uploadCloud, size: 36, color: AppColors.primary),
                              const SizedBox(height: 8),
                              Text(
                                'No document uploaded yet',
                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Maximum file size: 10 MB',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      key: const Key('upload_cac_certificate_btn'),
                                      onPressed: _isUploadingCertificate ? null : _simulateCertificatePick,
                                      icon: _isUploadingCertificate
                                          ? const SizedBox(
                                              width: 14,
                                              height: 14,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : const Icon(FeatherIcons.upload, size: 14),
                                      label: const Text(
                                        'Upload CAC Certificate / Document',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        side: const BorderSide(color: AppColors.primary),
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                        minimumSize: const Size(0, 42),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      key: const Key('sample_cac_certificate_btn'),
                                      onPressed: _loadSampleCertificate,
                                      icon: const Icon(FeatherIcons.file, size: 14),
                                      label: const Text(
                                        'Sample CAC Doc',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.textSecondary,
                                        side: const BorderSide(color: AppColors.borderMedium),
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                        minimumSize: const Size(0, 42),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDCFCE7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(FeatherIcons.fileText, size: 20, color: Color(0xFF16A34A)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _certificateFileName!,
                                          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          _certificateFileSize ?? 'Document Verified',
                                          style: AppTextStyles.caption.copyWith(color: const Color(0xFF15803D)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF16A34A),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Attached',
                                      style: AppTextStyles.caption.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    key: const Key('replace_certificate_btn'),
                                    onPressed: _simulateCertificatePick,
                                    icon: const Icon(FeatherIcons.refreshCw, size: 12),
                                    label: const Text('Replace', style: TextStyle(fontSize: 12)),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    key: const Key('remove_certificate_btn'),
                                    onPressed: _removeCertificate,
                                    icon: const Icon(FeatherIcons.trash2, size: 12, color: AppColors.danger),
                                    label: const Text(
                                      'Remove',
                                      style: TextStyle(fontSize: 12, color: AppColors.danger),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 4: Settlement Account
                _buildSectionHeader('4. SETTLEMENT BANK ACCOUNT (HOLDING FEES & SLEEPOVER)', FeatherIcons.dollarSign),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border, width: AppDimens.borderWidth),
                  ),
                  child: Column(
                    children: [
                      CustomDropdownField<String>(
                        labelText: 'Settlement Bank',
                        value: _selectedBank,
                        prefixIcon: FeatherIcons.briefcase,
                        items: _banks.map((b) {
                          return DropdownMenuItem(value: b, child: Text(b, style: AppTextStyles.bodyMedium));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBank = val);
                        },
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        key: const Key('account_num_field'),
                        controller: _accountNumberController,
                        labelText: 'Account Number (10 Digits)',
                        hintText: 'e.g. 0123456789',
                        keyboardType: TextInputType.number,
                        prefixIcon: FeatherIcons.creditCard,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        key: const Key('account_name_field'),
                        controller: _accountNameController,
                        labelText: 'Account Name (as registered with bank)',
                        hintText: 'e.g. Warri Central Mercantile Ltd',
                        textCapitalization: TextCapitalization.words,
                        prefixIcon: FeatherIcons.user,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section 5: Regulatory Declaration
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderMedium),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        key: const Key('business_declaration_checkbox'),
                        value: _hasAgreedToTerms,
                        activeColor: AppColors.primary,
                        onChanged: (val) => setState(() => _hasAgreedToTerms = val ?? false),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'I declare that this business is duly incorporated with the Corporate Affairs Commission (CAC), the uploaded certificate is authentic, and we agree to uphold the Sendalli physical holding, safe custody, and sleepover protocols.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    key: const Key('submit_business_application_btn'),
                    onPressed: _isLoading ? null : _completeSetup,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textInverse),
                          )
                        : const Text('Submit Application & Register Verified Hub Center'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
