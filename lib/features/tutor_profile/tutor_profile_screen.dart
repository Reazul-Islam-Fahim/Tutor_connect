import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/repositories/tutor_repository.dart';
import '../../routing/route_paths.dart';

/// Ports `TutorProfileScreen`: hero header with avatar/name/rating stats,
/// three quick-stat tiles, About, subject tags, and a "Book Session" CTA
/// that starts the Tier 1 booking flow.
class TutorProfileScreen extends ConsumerWidget {
  const TutorProfileScreen({super.key, required this.tutorId});

  final String tutorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutor = ref.watch(tutorRepositoryProvider).getById(tutorId);

    return AppScaffold(
      activeTab: BottomNavTab.findTutor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 32),
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Material(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => context.go(RoutePaths.searchResults),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Avatar(name: tutor.name, size: 72, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      tutor.name,
                      style: AppTextStyles.display(
                          fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    Text(
                      '${tutor.subject} Tutor',
                      style: AppTextStyles.body(
                          fontSize: 13, color: Colors.white.withOpacity(0.75)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _HeroStat(label: 'Rating', value: '${tutor.rating} ★'),
                        const SizedBox(width: 20),
                        _HeroStat(label: 'Reviews', value: '${tutor.reviewCount}'),
                        const SizedBox(width: 20),
                        _HeroStat(label: 'Rate', value: '\$${tutor.price}/hr'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                          emoji: '🏆', value: '${tutor.experienceYears} Years', label: 'Experience'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatTile(
                          emoji: '📚', value: '${tutor.sessionCount}+', label: 'Sessions'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatTile(
                          emoji: '✅', value: '${tutor.successRate}%', label: 'Success Rate'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About',
                          style: AppTextStyles.display(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(
                        tutor.about,
                        style: AppTextStyles.body(
                            fontSize: 14, color: AppColors.textSecondary, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Subjects',
                          style: AppTextStyles.display(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in tutor.subjectTags)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.primary.withOpacity(0.13)),
                              ),
                              child: Text(
                                tag,
                                style: AppTextStyles.body(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Book Session',
                  onPressed: () => context.go(RoutePaths.selectDateTimePath(tutor.id)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.display(
                fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        Text(label,
            style: AppTextStyles.body(fontSize: 11, color: Colors.white.withOpacity(0.6))),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.emoji, required this.value, required this.label});

  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.display(fontSize: 14, fontWeight: FontWeight.w700)),
          Text(label, style: AppTextStyles.body(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
