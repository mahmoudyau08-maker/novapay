import 'package:flutter/material.dart';

import '../state/wallet_state.dart';
import '../utils/constants.dart';
import '../widgets/demo_frame.dart';
import '../widgets/responsive_center.dart';
import 'home_screen.dart';

/// Asks for the demo PIN just created in setup, purely to mirror the "enter
/// your PIN" step real wallet apps have. It only checks against the in-memory
/// PIN for this session — there is nothing real behind it to protect.
class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _entered = '';
  String? _error;

  void _tap(String digit) {
    if (_entered.length >= AppConstants.pinLength) return;
    setState(() {
      _entered += digit;
      _error = null;
    });
    if (_entered.length == AppConstants.pinLength) _check();
  }

  void _backspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  void _check() {
    if (_entered == walletState.pin) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      setState(() {
        _error = 'Incorrect PIN, try again.';
        _entered = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Demo PIN')),
      body: DemoFrame(
        child: ResponsiveCenter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, ${walletState.displayName}',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(AppConstants.pinLength, (i) {
                  final filled = i < _entered.length;
                  return Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? scheme.primary : Colors.transparent,
                      border: Border.all(color: scheme.primary, width: 2),
                    ),
                  );
                }),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: scheme.error)),
              ],
              const SizedBox(height: 32),
              _buildPinPad(scheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinPad(ColorScheme scheme) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: keys.map((key) {
        if (key.isEmpty) return const SizedBox.shrink();
        final isBackspace = key == '⌫';
        return Material(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isBackspace ? _backspace : () => _tap(key),
            child: Center(
              child: isBackspace
                  ? const Icon(Icons.backspace_outlined)
                  : Text(key, style: const TextStyle(fontSize: 20)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
