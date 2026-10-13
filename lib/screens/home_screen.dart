import 'package:flutter/material.dart';

import '../state/wallet_state.dart';
import '../theme/theme_controller.dart';
import '../utils/formatters.dart';
import '../widgets/app_button.dart';
import '../widgets/demo_frame.dart';
import '../widgets/responsive_center.dart';
import 'disclaimer_screen.dart';
import 'transfer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _confirmStartOver(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Start over?'),
        content: const Text(
          'This clears your demo profile and balance and takes you back to '
          'the start.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      walletState.reset();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const DisclaimerScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NovaPay'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => themeController.toggle(theme.brightness),
          ),
        ],
      ),
      body: DemoFrame(
        child: ListenableBuilder(
          listenable: walletState,
          builder: (context, _) {
            return ResponsiveCenter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Hi, ${walletState.displayName}',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            'DEMO BALANCE (fictional)',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formatNaira(walletState.balance),
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Send Demo Transfer',
                    icon: Icons.send_rounded,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const TransferScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Start Over',
                    icon: Icons.refresh_rounded,
                    outlined: true,
                    onPressed: () => _confirmStartOver(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
