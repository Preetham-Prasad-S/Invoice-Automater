import 'package:app_prototype/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('usd', () {
    test('groups thousands and keeps two decimals', () {
      expect(Formatters.usd(28450), r'$28,450.00');
    });

    test('leaves values below a thousand ungrouped', () {
      expect(Formatters.usd(999.5), r'$999.50');
    });

    test('groups the leading thousands only', () {
      expect(Formatters.usd(1000), r'$1,000.00');
      expect(Formatters.usd(10000), r'$10,000.00');
      expect(Formatters.usd(100000), r'$100,000.00');
    });

    test('rounds fractions to two decimals', () {
      expect(Formatters.usd(1850.567), r'$1,850.57');
    });

    test('puts the sign before the symbol', () {
      expect(Formatters.usd(-2450), r'-$2,450.00');
    });

    test('handles zero', () {
      expect(Formatters.usd(0), r'$0.00');
    });

    test('honours a different symbol', () {
      expect(Formatters.usd(1500, symbol: '€'), '€1,500.00');
    });
  });

  group('usdCompact', () {
    test('drops decimals on whole amounts', () {
      expect(Formatters.usdCompact(19820), r'$19,820');
      expect(Formatters.usdCompact(2450), r'$2,450');
    });

    test('falls back to full formatting when there are cents', () {
      expect(Formatters.usdCompact(19820.5), r'$19,820.50');
    });

    test('puts the sign before the symbol', () {
      expect(Formatters.usdCompact(-2450), r'-$2,450');
    });

    test('handles zero', () {
      expect(Formatters.usdCompact(0), r'$0');
    });
  });
}
