import 'package:flutter/material.dart';
import '../theme/app_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Ports `StarRating`: a single filled star icon next to the numeric value.
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(LucideIcons.star, size: 14, color: AppColors.star),
        const SizedBox(width: 3),
        Text(
          rating % 1 == 0 ? rating.toStringAsFixed(0) : rating.toString(),
          style: AppTextStyles.body(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
