/// Number and money formatting shared across the app.
///
/// Hand-rolled rather than pulled from `intl` to keep the dependency list
/// (and therefore the binary size) unchanged; the app only ever needs
/// grouping separators and a currency symbol.
class Formatters {
  /// Formats [amount] as a currency figure with grouping separators and two
  /// decimal places, e.g. `28450` becomes `$28,450.00`.
  ///
  /// This is the form used wherever the design shows a full amount: the hero
  /// total on the dashboard and the per-invoice figures in the recent list.
  static String usd(double amount, {String symbol = r'$'}) {
    final negative = amount < 0;
    final parts = amount.abs().toStringAsFixed(2).split('.');
    final sign = negative ? '-' : '';
    return '$sign$symbol${_groupDigits(parts[0])}.${parts[1]}';
  }

  /// Formats [amount] as a currency figure with grouping separators but drops
  /// the decimals when the amount is whole, e.g. `19820` becomes `$19,820`
  /// while `19820.5` falls back to [usd].
  ///
  /// The dashboard's three status cards deliberately drop `.00`: at that size
  /// the cents are noise, and the reference design omits them there while
  /// keeping them on the hero total and the invoice amounts.
  static String usdCompact(double amount, {String symbol = r'$'}) {
    if (amount != amount.roundToDouble()) return usd(amount, symbol: symbol);

    final negative = amount < 0;
    final sign = negative ? '-' : '';
    final grouped = _groupDigits(amount.abs().round().toString());
    return '$sign$symbol$grouped';
  }

  /// Inserts a comma every three digits from the right of [digits], which is
  /// expected to be an unsigned run of digits with no separators.
  static String _groupDigits(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
