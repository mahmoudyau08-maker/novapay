/// Formats a number as a Naira amount, e.g. 125000.5 -> "₦125,000.50".
String formatNaira(num amount) {
  final fixed = amount.toStringAsFixed(2);
  final parts = fixed.split('.');
  final wholeDigits = parts[0].replaceFirst('-', '');
  final isNegative = parts[0].startsWith('-');

  final buffer = StringBuffer();
  for (var i = 0; i < wholeDigits.length; i++) {
    final remaining = wholeDigits.length - i;
    if (i != 0 && remaining % 3 == 0) buffer.write(',');
    buffer.write(wholeDigits[i]);
  }

  return '${isNegative ? '-' : ''}₦$buffer.${parts[1]}';
}

/// Generates a reference code that is unmistakably fake, e.g. "DEMO-7F3K2Q".
String generateDemoReference() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final random = DateTime.now().microsecondsSinceEpoch;
  final buffer = StringBuffer('DEMO-');
  var seed = random;
  for (var i = 0; i < 6; i++) {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    buffer.write(chars[seed % chars.length]);
  }
  return buffer.toString();
}
