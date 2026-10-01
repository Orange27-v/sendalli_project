import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
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
              TextField(
                controller: _firstNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  hintText: 'e.g. Diran',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  hintText: 'e.g. Olakunle',
                ),
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
