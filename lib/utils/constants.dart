/// App-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'NovaPay';

  /// Shown as a tiled watermark and as solid banners on every screen, and
  /// baked into any exported/shared image. Keep this blunt — it is the
  /// whole point of the app.
  static const String watermarkText = 'DEMO — NOT REAL MONEY';

  static const String disclaimerTitle = 'Before you start';

  static const String disclaimerBody =
      'NovaPay is a fictional wallet simulator made for entertainment and '
      'education. It is not a real banking or payment app, it is not '
      'affiliated with any bank or payment provider, and it never moves, '
      'sends, or receives real money.\n\n'
      'Every screen — including anything you share from it — is permanently '
      'watermarked as a demo. Please do not use it, or anything it generates, '
      'to try to convince another person that a real payment was made. Doing '
      'that is fraud, even as a "joke".\n\n'
      'By continuing, you agree you understand this is fictional and you '
      'will not use it to deceive anyone.';

  static const String disclaimerCheckboxLabel =
      "I understand NovaPay is fictional and won't use it to deceive anyone.";

  static const int pinLength = 4;
}
