import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Initials avatar. Ports `Avatar`, including its special-cased "on white
/// gradient background" tint when [color] is [AppColors.white].
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.name,
    this.size = 48,
    this.color = AppColors.primary,
  });

  final String name;
  final double size;
  final Color color;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters = parts.where((p) => p.isNotEmpty).map((p) => p[0]);
    return letters.take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isOnWhite = color == AppColors.white;

    final background =
        isOnWhite ? Colors.white.withOpacity(0.2) : color.withOpacity(0.094);
    final borderColor =
        isOnWhite ? Colors.white.withOpacity(0.35) : color.withOpacity(0.157);
    final textColor = isOnWhite ? AppColors.white : color;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Text(
        _initials,
        style: AppTextStyles.display(
          fontSize: size * 0.33,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
