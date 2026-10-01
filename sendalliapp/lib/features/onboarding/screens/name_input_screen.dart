import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/form_randomizer.dart';
import 'phone_input_screen.dart';

/// Screen 2: User's Name Identification (Onboarding-1.png).
class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validate);
    _lastNameController.addListener(_validate);
  }

  void _validate() {
    final valid = _firstNameController.text.trim().length >= 2 &&
        _lastNameController.text.trim().length >= 2;
    if (valid != _isValid) {
      setState(() => _isValid = valid);
    }
  }

  void _randomize() {
    _firstNameController.text = FormSampleData.randomFirstName();
    _lastNameController.text = FormSampleData.randomLastName();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (!_isValid) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhoneInputScreen(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Step 1 of 4', style: AppTextStyles.caption.copyWith(fontSize: 13)),
        actions: [
          RandomizeButton(onRandomize: _randomize),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter your name', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Enter your first name and last name to get started.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                hintText: 'e.g. Diran',
                textCapitalization: TextCapitalization.words,
                prefixIcon: FeatherIcons.user,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                hintText: 'e.g. Olakunle',
                textCapitalization: TextCapitalization.words,
                prefixIcon: FeatherIcons.user,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isValid ? _proceed : null,
                child: const Text('Continue'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
