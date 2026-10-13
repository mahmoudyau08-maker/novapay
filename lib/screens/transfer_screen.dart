import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/wallet_state.dart';
import '../utils/formatters.dart';
import '../widgets/app_button.dart';
import '../widgets/demo_frame.dart';
import '../widgets/responsive_center.dart';
import 'receipt_screen.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String? _error;

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim());
    if (_recipientController.text.trim().isEmpty) {
      setState(() => _error = "Enter the recipient's name.");
      return;
    }
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid amount.');
      return;
    }
    if (amount > walletState.balance) {
      setState(() => _error =
          'That is more than your demo balance (${formatNaira(walletState.balance)}).');
      return;
    }

    final transfer = DemoTransfer(
      recipientName: _recipientController.text.trim(),
      amount: amount,
      note: _noteController.text.trim(),
      reference: generateDemoReference(),
      timestamp: DateTime.now(),
    );

    final applied = walletState.applyTransfer(transfer);
    if (!applied) {
      setState(() => _error = 'Could not process that demo transfer.');
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const ReceiptScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Send Demo Transfer')),
      body: DemoFrame(
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Available demo balance: ${formatNaira(walletState.balance)}',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _recipientController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: "Recipient's name",
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Amount (₦, fictional)',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: TextStyle(color: scheme.error)),
              ],
              const SizedBox(height: 20),
              AppButton(
                label: 'Send Demo Transfer',
                icon: Icons.send_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
