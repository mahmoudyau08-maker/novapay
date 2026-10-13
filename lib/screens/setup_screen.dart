import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/wallet_state.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/demo_frame.dart';
import '../widgets/responsive_center.dart';
import 'pin_lock_screen.dart';

/// Lets the person name their demo profile, pick a starting demo balance,
/// and set a demo PIN. Everything here is explicitly fictional and is only
/// ever stored in memory for this one run of the app.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController(text: '50000');
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _submit() {
    final balance = double.tryParse(_balanceController.text.trim());
    if (balance == null || balance <= 0) {
      setState(() => _error = 'Enter a starting demo balance greater than 0.');
      return;
    }
    if (_pinController.text.length != AppConstants.pinLength) {
      setState(() => _error = 'PIN must be ${AppConstants.pinLength} digits.');
      return;
    }
    if (_pinController.text != _confirmPinController.text) {
      setState(() => _error = 'PINs do not match.');
      return;
    }

    walletState.completeSetup(
      name: _nameController.text,
      startingBalance: balance,
      pin: _pinController.text,
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const PinLockScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Demo Profile')),
      body: DemoFrame(
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Everything below is fictional and only lives in this app '
                'session — none of it is a real account.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _balanceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Starting demo balance (₦, fictional)',
                  prefixIcon: Icon(Icons.savings_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: AppConstants.pinLength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Create a demo PIN',
                  counterText: '',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: AppConstants.pinLength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Confirm demo PIN',
                  counterText: '',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: TextStyle(color: scheme.error)),
              ],
              const SizedBox(height: 20),
              AppButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
