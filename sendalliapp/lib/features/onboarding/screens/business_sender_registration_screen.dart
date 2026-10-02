import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/corridor_constants.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/user_role.dart';
import '../../../core/storage/session_manager.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/permission_dialog.dart';
import '../../../widgets/profile_completed_dialog.dart';
import '../../dashboard/screens/sender/sender_home_screen.dart';

/// Dedicated separate screen for commercial senders applying to become verified businesses,
/// requiring complete business details and uploading a CAC business registration certificate.
class BusinessSenderRegistrationScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? pin;
  final UserProfile? currentUser;

  const BusinessSenderRegistrationScreen({
    super.key,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.pin,
    this.currentUser,
  });

  @override
  State<BusinessSenderRegistrationScreen> createState() => _BusinessSenderRegistrationScreenState();
}

class _BusinessSenderRegistrationScreenState extends State<BusinessSenderRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyNameController;
  late final TextEditingController _cacNumberController;
  late final TextEditingController _tinController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _accountNameController;

  String _selectedCorridor = CorridorConstants.pilotCorridors.first;
  String _selectedCategory = 'Fashion & Retail';
  String _selectedBank = 'Zenith Bank';

  // Certificate Upload State
  String? _certificateFileName;
  String? _certificateFileSize;
  bool _isUploadingCertificate = false;
  bool _hasAgreedToTerms = true;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Fashion & Retail',
    'Food & Groceries',
    'Electronics & Gadgets',
    'Auto & Mechanical Spares',
    'Pharmaceuticals & Health',
    'Documents & Corporate',
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
    final user = widget.currentUser;
    _companyNameController = TextEditingController(text: user?.shopName ?? '');
    _cacNumberController = TextEditingController(text: user?.cacNumber ?? '');
    _tinController = TextEditingController(text: user?.tinNumber ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: widget.phoneNumber ?? user?.phone ?? '');
    _addressController = TextEditingController(text: 'Shop 14, Commercial Plaza, Deco Road, Warri');
    _accountNumberController = TextEditingController(text: user?.accountNumber ?? '');
    _accountNameController = TextEditingController(text: user?.shopName ?? '');

    if (user?.corridor != null && CorridorConstants.pilotCorridors.contains(user!.corridor)) {
      _selectedCorridor = user.corridor!;
    }
    if (user?.businessCertificateName != null) {
      _certificateFileName = user!.businessCertificateName;
      _certificateFileSize = '1.8 MB • Verified Document';
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _cacNumberController.dispose();
    _tinController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  void _fillSampleBusinessData() {
    setState(() {
      _companyNameController.text = 'Warri Central Mercantile Ltd';
      _cacNumberController.text = 'RC-1849204';
      _tinController.text = '23891048-0001';
      _emailController.text = 'compliance@warricentral.ng';
      _phoneController.text = '+234 803 555 8899';
      _addressController.text = 'Block C, Deco Commercial Center, Warri';
      _accountNumberController.text = '1029384756';
      _accountNameController.text = 'Warri Central Mercantile Ltd';
      _selectedCategory = 'Fashion & Retail';
      _selectedBank = 'Zenith Bank';
      _selectedCorridor = CorridorConstants.pilotCorridors.first;
      _certificateFileName = 'CAC_Cert_WarriCentral_RC1849204.pdf';
      _certificateFileSize = '1.84 MB • PDF Document';
      _hasAgreedToTerms = true;
    });
  }

  void _simulateCertificatePick() async {
    setState(() => _isUploadingCertificate = true);
    await Future.delayed(const Duration(milliseconds: 600));
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

  void _removeCertificate() {
    setState(() {
      _certificateFileName = null;
      _certificateFileSize = null;
    });
  }

  Future<void> _submitBusinessApplication() async {
    if (_companyNameController.text.trim().isEmpty) {
      _showError('Please enter your Registered Business Name.');
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

    setState(() => _isSubmitting = true);

    // Contextual notification permission
    await PermissionDialog.show(
      context: context,
      icon: FeatherIcons.bell,
      title: 'Turn on Business Notifications',
      description: 'Get instant alerts for high-volume dispatches, corridor pickups, and escrow payouts.',
      primaryButtonText: 'Enable Notifications',
    );

    final baseUser = widget.currentUser;
    final fName = widget.firstName ?? baseUser?.firstName ?? 'Business';
    final lName = widget.lastName ?? baseUser?.lastName ?? 'Sender';
    final phone = _phoneController.text.trim().isNotEmpty
        ? _phoneController.text.trim()
        : (widget.phoneNumber ?? baseUser?.phone ?? '');
    final pin = widget.pin ?? baseUser?.pin ?? '1234';

    final updatedProfile = UserProfile(
      id: baseUser?.id ?? 'BIZ-${DateTime.now().millisecondsSinceEpoch}',
      firstName: fName,
      lastName: lName,
      phone: phone,
      role: UserRole.sender,
      pin: pin,
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      shopName: _companyNameController.text.trim(),
      corridor: _selectedCorridor,
      isVerified: true,
      cacNumber: _cacNumberController.text.trim(),
      businessCertificateName: _certificateFileName,
      tinNumber: _tinController.text.trim().isNotEmpty ? _tinController.text.trim() : null,
      bankName: _selectedBank,
      accountNumber: _accountNumberController.text.trim().isNotEmpty ? _accountNumberController.text.trim() : null,
      isBusinessVerified: true,
    );

    await SessionManager.saveUserProfile(updatedProfile);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ProfileCompletedDialog.show(
      context: context,
      subtitle: 'Business Application Submitted! Your CAC certificate is verified and your commercial sender account is ready.',
      onContinue: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => SenderHomeScreen(user: updatedProfile)),
          (route) => false,
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[800],
      ),
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
          title: 'Business Sender Application',
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
                  // Verification Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
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
                                'Commercial Sender Verification',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF166534),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Senders with registered businesses must complete this full verification and upload their CAC business registration certificate.',
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
                          controller: _companyNameController,
                          labelText: 'Registered Business / Company Name *',
                          hintText: 'e.g. Warri Central Mercantile Ltd',
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: FeatherIcons.home,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                key: const Key('business_cac_field'),
                                controller: _cacNumberController,
                                labelText: 'CAC RC or BN Number *',
                                hintText: 'e.g. RC-1849204',
                                prefixIcon: FeatherIcons.fileText,
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
                        const SizedBox(height: 14),
                        CustomDropdownField<String>(
                          key: const Key('business_category_dropdown'),
                          labelText: 'Business Category',
                          value: _selectedCategory,
                          prefixIcon: FeatherIcons.tag,
                          items: _categories.map((c) {
                            return DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Section 2: Corridor & Location
                  _buildSectionHeader('2. DISPATCH BASE & CONTACT', FeatherIcons.mapPin),
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
                          key: const Key('business_corridor_dropdown'),
                          labelText: 'Primary Corridor Dispatch Base',
                          value: _selectedCorridor,
                          prefixIcon: FeatherIcons.navigation,
                          items: CorridorConstants.pilotCorridors.map((c) {
                            return DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCorridor = val);
                          },
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          key: const Key('business_address_field'),
                          controller: _addressController,
                          labelText: 'Store / Warehouse Address',
                          hintText: 'e.g. Shop 14, Commercial Plaza, Deco Road',
                          prefixIcon: FeatherIcons.mapPin,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          key: const Key('business_email_field'),
                          controller: _emailController,
                          labelText: 'Official Business Email *',
                          hintText: 'e.g. dispatch@warricentral.ng',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: FeatherIcons.mail,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          key: const Key('business_phone_field'),
                          controller: _phoneController,
                          labelText: 'Business Hotline / WhatsApp',
                          hintText: 'e.g. +234 803 555 8899',
                          keyboardType: TextInputType.phone,
                          prefixIcon: FeatherIcons.phone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Section 3: CAC Business Registration Certificate Upload
                  _buildSectionHeader('3. CAC REGISTRATION CERTIFICATE (MANDATORY)', FeatherIcons.fileText),
                  const SizedBox(height: 10),
                  _buildCertificateUploadCard(),
                  const SizedBox(height: 22),

                  // Section 4: Settlement Account Details
                  _buildSectionHeader('4. COMMERCIAL SETTLEMENT ACCOUNT', FeatherIcons.creditCard),
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
                          key: const Key('business_bank_dropdown'),
                          labelText: 'Settlement Bank',
                          value: _selectedBank,
                          prefixIcon: FeatherIcons.dollarSign,
                          items: _banks.map((b) {
                            return DropdownMenuItem(value: b, child: Text(b, style: AppTextStyles.bodyMedium));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedBank = val);
                          },
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomTextField(
                                key: const Key('business_account_number_field'),
                                controller: _accountNumberController,
                                labelText: 'Account Number (10 Digits)',
                                hintText: '0123456789',
                                keyboardType: TextInputType.number,
                                prefixIcon: FeatherIcons.creditCard,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 4,
                              child: CustomTextField(
                                key: const Key('business_account_name_field'),
                                controller: _accountNameController,
                                labelText: 'Account Name',
                                hintText: 'Auto-verified Account Name',
                                prefixIcon: FeatherIcons.userCheck,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Declaration Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        key: const Key('business_declaration_checkbox'),
                        value: _hasAgreedToTerms,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _hasAgreedToTerms = v ?? false),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _hasAgreedToTerms = !_hasAgreedToTerms),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'I hereby declare that this business is duly registered with the Corporate Affairs Commission (CAC) and that all submitted documents are genuine and valid.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      key: const Key('submit_business_application_btn'),
                      onPressed: _isSubmitting ? null : _submitBusinessApplication,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textInverse),
                            )
                          : const Text('Submit Application & Verify Business'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateUploadCard() {
    final hasCert = _certificateFileName != null;

    if (hasCert) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF86EFAC), width: 1.2),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(FeatherIcons.fileText, color: Color(0xFF16A34A), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _certificateFileName!,
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _certificateFileSize ?? '2.1 MB • CAC Document',
                        style: AppTextStyles.caption.copyWith(color: const Color(0xFF166534)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(FeatherIcons.checkCircle, size: 12, color: Color(0xFF16A34A)),
                      const SizedBox(width: 4),
                      Text(
                        'Attached',
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
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFBBF7D0), height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  key: const Key('remove_certificate_btn'),
                  onPressed: _removeCertificate,
                  icon: const Icon(FeatherIcons.trash2, size: 13, color: Colors.red),
                  label: Text('Remove', style: AppTextStyles.caption.copyWith(color: Colors.red)),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  key: const Key('replace_certificate_btn'),
                  onPressed: _simulateCertificatePick,
                  icon: const Icon(FeatherIcons.refreshCw, size: 13, color: Color(0xFF166534)),
                  label: Text('Replace Document', style: AppTextStyles.caption.copyWith(color: const Color(0xFF166534))),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(FeatherIcons.uploadCloud, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            'Upload CAC Certificate / Document',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Upload Certificate of Incorporation or Business Name Registration (PDF, PNG, JPG up to 5MB)',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (_isUploadingCertificate)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    key: const Key('upload_cac_certificate_btn'),
                    onPressed: _simulateCertificatePick,
                    icon: const Icon(FeatherIcons.upload, size: 14),
                    label: const Text('Select File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textInverse,
                      minimumSize: const Size(0, 42),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('sample_cac_certificate_btn'),
                    onPressed: () {
                      setState(() {
                        _certificateFileName = 'CAC_RC1849204_Incorporation_Cert.pdf';
                        _certificateFileSize = '1.8 MB • Certified Corporate Copy';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sample CAC Certificate attached!'),
                          backgroundColor: Color(0xFF16A34A),
                        ),
                      );
                    },
                    icon: const Icon(FeatherIcons.fileText, size: 14),
                    label: const Text('Use Sample CAC'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 42),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
