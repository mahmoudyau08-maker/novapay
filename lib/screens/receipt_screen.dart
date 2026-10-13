import 'dart:io';
import 'dart:ui' as ui;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../state/wallet_state.dart';
import '../utils/formatters.dart';
import '../widgets/app_button.dart';
import '../widgets/demo_frame.dart';
import '../widgets/responsive_center.dart';

/// Shows the one transfer just made. The card is wrapped in a RepaintBoundary
/// together with [DemoFrame], so the watermark and red banners are painted
/// as part of the same image whenever this screen is captured and shared —
/// there is no "clean" version of this screen to export.
class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final GlobalKey _captureKey = GlobalKey();
  bool _sharing = false;

  Future<void> _shareReceipt() async {
    setState(() => _sharing = true);
    try {
      final boundary = _captureKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 2.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/novapay_demo_receipt_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(byteData.buffer.asUint8List());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'NovaPay demo receipt — fictional, not a real transaction.',
          subject: 'NovaPay demo receipt',
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final transfer = walletState.lastTransfer;

    return Scaffold(
      appBar: AppBar(title: const Text('Demo Receipt')),
      body: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RepaintBoundary(
              key: _captureKey,
              child: DemoFrame(
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: transfer == null
                        ? const Text('No transfer to show.')
                        : Column(
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  size: 56, color: scheme.primary),
                              const SizedBox(height: 12),
                              Text(
                                'Demo transfer sent',
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'This is fictional. No real money moved.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const Divider(height: 32),
                              _row(theme, 'Recipient', transfer.recipientName),
                              _row(theme, 'Amount', formatNaira(transfer.amount)),
                              if (transfer.note.isNotEmpty)
                                _row(theme, 'Note', transfer.note),
                              _row(theme, 'Reference', transfer.reference),
                              _row(
                                theme,
                                'Date',
                                transfer.timestamp.toLocal().toString().split('.').first,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Share Demo Receipt',
              icon: Icons.ios_share_rounded,
              loading: _sharing,
              onPressed: transfer == null ? null : _shareReceipt,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Back to Home',
              icon: Icons.home_rounded,
              outlined: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
