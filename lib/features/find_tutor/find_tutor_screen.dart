import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_input_field.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/subject_chip.dart';
import '../../routing/route_paths.dart';

/// Ports `FindTutorScreen`.
///
/// TIER 1 — FULLY IMPLEMENTED: the subject chips and search field carry
/// real, mutable state (not static mock values). Tapping "Search Tutors"
/// — or any popular-subject suggestion — passes the current query and
/// selected category on to Search Results, which genuinely filters the
/// tutor list against them.
class FindTutorScreen extends StatefulWidget {
  const FindTutorScreen({super.key, this.initialQuery, this.initialCategory});

  final String? initialQuery;
  final String? initialCategory;

  @override
  State<FindTutorScreen> createState() => _FindTutorScreenState();
}

class _FindTutorScreenState extends State<FindTutorScreen> {
  late final TextEditingController _searchController;
  late String _activeChip;

  static const _chips = ['All', 'Database', 'Programming', 'Mathematics', 'Networking'];

  static const _popularSubjects = [
    'Database Management',
    'SQL & Data Modelling',
    'Algorithms & Data Structures',
    'Network Security',
    'Discrete Mathematics',
  ];

  @override
  void initState() {
    super.initState();
    _activeChip = widget.initialCategory ?? 'Database';
    _searchController =
        TextEditingController(text: widget.initialQuery ?? 'Database Management');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search([String? subjectOverride]) {
    final query = subjectOverride ?? _searchController.text;
    context.go(Uri(
      path: RoutePaths.searchResults,
      queryParameters: {
        'q': query,
        'category': _activeChip,
      },
    ).toString());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      activeTab: BottomNavTab.findTutor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find a Tutor',
                  style: AppTextStyles.display(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                SearchField(
                  controller: _searchController,
                  placeholder: 'Search subject or tutor name',
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _chips.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final chip = _chips[index];
                      return SubjectChip(
                        label: chip,
                        active: _activeChip == chip,
                        onTap: () => setState(() => _activeChip = chip),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular subjects',
                      style: AppTextStyles.body(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    Row(
                      children: [
                        const Icon(LucideIcons.slidersHorizontal,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('Filter',
                            style: AppTextStyles.body(
                                fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final subject in _popularSubjects)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _search(subject),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(LucideIcons.bookOpen,
                                    size: 18, color: AppColors.primary),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  subject,
                                  style: AppTextStyles.body(
                                      fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                              const Icon(LucideIcons.chevronRight,
                                  size: 16, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: PrimaryButton(label: 'Search Tutors', onPressed: _search),
          ),
        ],
      ),
    );
  }
}
