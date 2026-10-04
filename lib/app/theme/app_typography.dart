import 'package:flutter/material.dart';

class AppTypography {
  static const String _fontFamily = 'Quicksand';

  static TextTheme textTheme = const TextTheme(
    displaySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 34,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFF0B0B14),
      height: 1.1,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 15.5,
      fontWeight: FontWeight.w400,
      color: Color(0xFF6B7280),
      height: 1.5,
    ),
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF3A3F52),
      height: 1.2,
    ),
    bodySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF9AA0AE),
      height: 1.2,
    ),
    labelSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFFB6BAC6),
      height: 1.2,
    ),
  );

  // Dashboard typography styles (from home screen reference)
  /// Hero amount display - Total Invoiced. Matches 32dp w700 from design.
  static const TextStyle heroAmount = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: Color(0xFF0B0B14),
    height: 1.1,
  );

  /// Greeting name text - "Good morning, Alex". Matches 20dp w700 from design.
  static const TextStyle greetingName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color(0xFF0B0B14),
    height: 1.2,
  );

  /// Section title - "Recent Invoices". Matches 19dp w700 from design.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: Color(0xFF0B0B14),
    height: 1.2,
  );

  /// Invoice client name. Matches 15dp w700 from design.
  static const TextStyle invoiceClient = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Color(0xFF0B0B14),
    height: 1.2,
  );

  /// Status card amount. Matches 15dp w700 from design.
  static const TextStyle statusAmount = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Color(0xFF0B0B14),
    height: 1.2,
  );

  /// Card label text - "Total Invoiced", "Paid" etc. Matches 13dp w600 from design.
  static const TextStyle cardLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7280),
    height: 1.2,
  );

  /// Invoice metadata - "INV-0042 • Due May 18". Matches 12.5dp w500 from design.
  static const TextStyle invoiceMeta = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: Color(0xFF6B7280),
    height: 1.2,
  );

  /// Pill label text. Matches 12dp w600 from design.
  static const TextStyle pillLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Navigation label. Matches 11dp w600 from design.
  static const TextStyle navLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Primary call-to-action label. Matches 17dp w700 white from design.
  static const TextStyle ctaLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.2,
  );

  /// Avatar initials. Matches 15dp w700 from design.
  static const TextStyle avatarInitials = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.2,
  );
}
