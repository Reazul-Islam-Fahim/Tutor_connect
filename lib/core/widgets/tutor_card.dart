import 'package:flutter/material.dart';
import '../theme/app_icons.dart';

import '../../models/tutor.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'avatar.dart';
import 'primary_button.dart';
import 'star_rating.dart';

/// Ports `TutorCard`: avatar + name/subject/rating/experience + price,
/// with a "View Profile" primary button. Used on Home (compact) and
/// Search Results (full).
class TutorCard extends StatelessWidget {
  const TutorCard({
    super.key,
    required this.tutor,
    required this.onView,
    this.compact = false,
  });

  final Tutor tutor;
  final VoidCallback onView;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar(
                name: tutor.name,
                size: compact ? 42 : 50,
                color: tutor.avatarColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutor.name,
                      style: AppTextStyles.display(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tutor.subject,
                      style: AppTextStyles.body(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        StarRating(rating: tutor.rating),
                        if (tutor.experienceYears > 0) ...[
                          const SizedBox(width: 10),
                          const Icon(
                            LucideIcons.briefcase,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${tutor.experienceYears} yrs',
                            style: AppTextStyles.body(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${tutor.price}',
                    style: AppTextStyles.display(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '/hour',
                    style: AppTextStyles.body(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          PrimaryButton(label: 'View Profile', onPressed: onView, small: true),
        ],
      ),
    );
  }
}
