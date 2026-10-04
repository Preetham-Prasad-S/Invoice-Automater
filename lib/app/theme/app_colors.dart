import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFF3B5BFF);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B5BFF), Color(0xFF5B7CFF)],
  );
  static const Color success = Color(0xFF22C55E);
  static const Color surfaceMuted = Color(0xFFF1F2F7);
  static const Color border = Color(0xFFE6E8F0);
  static const Color textPrimary = Color(0xFF0B0B14);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9AA0AE);
  static const Color track = Color(0xFFE8EAF2);
  static const Color trail = Color(0xFFA5B4FC);
  static const Color backgroundStart = Color(0xFFF8F9FE);
  static const Color backgroundEnd = Color(0xFFFBFBFD);

  // Home dashboard - status colors (from reference)
  /// Paid status dot color. Matches #22C55E from design.
  static const Color statusPaid = Color(0xFF22C55E);

  /// Pending status dot color. Matches #F59E0B from design.
  static const Color statusPending = Color(0xFFF59E0B);

  /// Overdue status dot color. Matches #EF4444 from design.
  static const Color statusOverdue = Color(0xFFEF4444);

  /// Paid status pill background. Matches #E7F8F0 from design.
  static const Color statusPaidTint = Color(0xFFE7F8F0);

  /// Pending status pill background. Matches #FEF3E2 from design.
  static const Color statusPendingTint = Color(0xFFFEF3E2);

  /// Overdue status pill background. Matches #FDE9EC from design.
  static const Color statusOverdueTint = Color(0xFFFDE9EC);

  /// Segmented bar paid segment (deeper green). Matches #137A4A from design.
  static const Color barPaid = Color(0xFF137A4A);

  /// Segmented bar pending segment. Matches #F5A623 from design.
  static const Color barPending = Color(0xFFF5A623);

  /// Segmented bar overdue segment. Matches #E8384F from design.
  static const Color barOverdue = Color(0xFFE8384F);

  /// Trend badge text for positive movement. Matches #0E9F6E from design.
  static const Color trendPositive = Color(0xFF0E9F6E);

  /// Trend badge background for positive movement. Matches #E8F8F0 from design.
  static const Color trendPositiveTint = Color(0xFFE8F8F0);

  /// Card shadow color with low alpha. Matches reference shadow.
  static const Color cardShadow = Color(0x140B0B14);

  /// Bottom navigation inactive icon/text color. Matches #9AA0AE from design.
  static const Color navInactive = Color(0xFF9AA0AE);
}
