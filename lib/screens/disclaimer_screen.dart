import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/demo_banner.dart';
import '../widgets/responsive_center.dart';
import 'setup_screen.dart';

/// First screen on every launch. Nothing persists between runs, so this is
/// always seen again — on purpose (see WalletState's doc comment).
class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: ResponsiveCenter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.info_outline_rounded, size: 56, color: scheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.disclaimerTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.disclaimerBody,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => setState(() => _agreed = !_agreed),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _agreed,
                            onChanged: (v) => setState(() => _agreed = v ?? false),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              AppConstants.disclaimerCheckboxLabel,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Continue',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _agreed
                        ? () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const SetupScreen(),
                              ),
                            )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          const DemoBanner(),
        ],
      ),
    );
  }
}
