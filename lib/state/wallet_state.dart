import 'package:flutter/foundation.dart';

/// Details of the one transfer currently being shown on the receipt screen.
class DemoTransfer {
  const DemoTransfer({
    required this.recipientName,
    required this.amount,
    required this.note,
    required this.reference,
    required this.timestamp,
  });

  final String recipientName;
  final double amount;
  final String note;
  final String reference;
  final DateTime timestamp;
}

/// All in-memory state for the demo wallet.
///
/// Deliberately NOT persisted to disk: every time the app is closed and
/// reopened, the disclaimer and setup start over from scratch. That is a
/// safety choice, not an oversight — it keeps this a one-off toy rather than
/// a standing tool someone could reuse again and again.
class WalletState extends ChangeNotifier {
  String displayName = '';
  String pin = '';
  double balance = 0;
  bool setupComplete = false;
  DemoTransfer? lastTransfer;

  void completeSetup({
    required String name,
    required double startingBalance,
    required String pin,
  }) {
    displayName = name.trim().isEmpty ? 'Demo User' : name.trim();
    this.pin = pin;
    balance = startingBalance;
    setupComplete = true;
    notifyListeners();
  }

  /// Returns false (and changes nothing) if the amount exceeds the balance.
  bool applyTransfer(DemoTransfer transfer) {
    if (transfer.amount <= 0 || transfer.amount > balance) return false;
    balance -= transfer.amount;
    lastTransfer = transfer;
    notifyListeners();
    return true;
  }

  void reset() {
    displayName = '';
    pin = '';
    balance = 0;
    setupComplete = false;
    lastTransfer = null;
    notifyListeners();
  }
}

/// Single shared instance, read the same way across every screen.
final WalletState walletState = WalletState();
