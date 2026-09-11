import 'package:flutter/material.dart';

/// Central colour tokens, ported 1:1 from the Figma Make source's `C` object
/// and `:root` CSS variables so every screen stays visually consistent.
abstract final class AppColors {
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color primaryMid = Color(0xFF6366F1);

  /// The 135° indigo → violet gradient used behind primary buttons.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
  );

  /// The header gradient used on Splash / Welcome / Sign In / Tutor Profile /
  /// Home / Profile screens (150–160° indigo → violet).
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment(-0.6, -1),
    end: Alignment(0.6, 1),
    colors: [Color(0xFF4338CA), Color(0xFF4F46E5), Color(0xFF7C3AED)],
    stops: [0.0, 0.4, 1.0],
  );

  static const Color background = Color(0xFFF5F6FA);
  static const Color white = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  static const Color border = Color(0xFFE2E8F0);

  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);

  static const Color muted = Color(0xFFF1F5F9);

  static const Color star = Color(0xFFF59E0B);

  static const Color red = Color(0xFFEF4444);
  static const Color redLight = Color(0xFFFEF2F2);
}
