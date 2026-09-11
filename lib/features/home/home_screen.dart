import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/tutor_card.dart';
import '../../data/repositories/tutor_repository.dart';
import '../../routing/route_paths.dart';

/// Ports `HomeScreen`: greeting header with search bar that hands off to
/// Find Tutor on focus (real functionality — it's the entry point into
/// Tier 1's Tutor Discovery flow), a subject-category grid, and a
/// recommended-tutor card.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  static const _subjects = [
    ('🗄️', 'Database'),
    ('💻', 'Programming'),
    ('📐', 'Mathematics'),
    ('🌐', 'Networking'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goFindTutor([String? category]) {
    final query = _searchController.text;
    final params = <String, String>{
      if (query.isNotEmpty) 'q': query,
      if (category != null) 'category': category,
    };
    context.go(Uri(
      path: RoutePaths.findTutor,
      queryParameters: params.isEmpty ? null : params,
    ).toString());
  }

  @override
  Widget build(BuildContext context) {
    final tutors = ref.watch(allTutorsProvider);
    final featured = tutors.first;

    return AppScaffold(
      activeTab: BottomNavTab.home,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 28),
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning,',
                            style: AppTextStyles.body(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            'Hi, Alex 👋',
                            style: AppTextStyles.display(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Avatar(name: 'Alex Morgan', size: 42, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'What would you like to learn?',
                  style: AppTextStyles.body(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  onTap: _goFindTutor,
                  style: AppTextStyles.body(fontSize: 14, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search subject or tutor',
                    hintStyle: AppTextStyles.body(
                        fontSize: 14, color: Colors.white.withOpacity(0.75)),
                    prefixIcon: Icon(LucideIcons.search,
                        size: 18, color: Colors.white.withOpacity(0.75)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    enabledBorder: null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Browse Subjects',
                  style: AppTextStyles.display(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.6,
                  children: [
                    for (final subject in _subjects)
                      _SubjectTile(
                        emoji: subject.$1,
                        label: subject.$2,
                        onTap: () => _goFindTutor(subject.$2),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended Tutors',
                      style: AppTextStyles.display(fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                    TextButton(
                      onPressed: () => context.go(RoutePaths.searchResults),
                      child: Text(
                        'See all',
                        style: AppTextStyles.body(
                            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                TutorCard(
                  tutor: featured,
                  compact: true,
                  onView: () =>
                      context.go(RoutePaths.tutorProfilePath(featured.id)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({required this.emoji, required this.label, required this.onTap});

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.display(fontSize: 14, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
