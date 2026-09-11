import 'package:flutter/material.dart';

/// Breakpoints follow Material 3 window-size-class guidance:
/// compact (phones) / medium (large phones, foldables) / expanded (tablets).
abstract final class Breakpoints {
  static const double compact = 600;
  static const double medium = 900;
}

enum DeviceClass { compact, medium, expanded }

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  DeviceClass get deviceClass {
    final width = screenWidth;
    if (width < Breakpoints.compact) return DeviceClass.compact;
    if (width < Breakpoints.medium) return DeviceClass.medium;
    return DeviceClass.expanded;
  }

  bool get isCompact => deviceClass == DeviceClass.compact;

  /// Scales a base font size gently on very small phones so text never
  /// clips, without the layout re-flowing like on a tablet.
  double scaledFont(double base) {
    final width = screenWidth;
    if (width < 340) return base * 0.92;
    if (width > 480) return base * 1.03;
    return base;
  }
}
