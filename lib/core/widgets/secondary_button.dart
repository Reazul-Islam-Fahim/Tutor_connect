import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Outlined button. Ports `SecondaryButton`, including the `danger` variant
/// used for destructive actions like cancelling a booking.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
    this.danger = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final bool danger;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final foreground = danger ? AppColors.red : AppColors.primary;
    final background = danger ? AppColors.redLight : AppColors.white;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: BorderSide(color: foreground.withOpacity(0.3), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 8)],
            Text(
              label,
              style: AppTextStyles.display(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: foreground,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
