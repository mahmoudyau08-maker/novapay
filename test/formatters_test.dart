import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/utils/formatters.dart';

void main() {
  test('formatNaira groups thousands correctly', () {
    expect(formatNaira(50000), '₦50,000.00');
    expect(formatNaira(1234567.5), '₦1,234,567.50');
    expect(formatNaira(0), '₦0.00');
    expect(formatNaira(999), '₦999.00');
  });

  test('generateDemoReference always starts with DEMO-', () {
    for (var i = 0; i < 20; i++) {
      expect(generateDemoReference(), startsWith('DEMO-'));
    }
  });
}
