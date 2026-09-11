import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_input_field.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/tutor_card.dart';
import '../../core/widgets/top_nav_bar.dart';
import '../../data/repositories/tutor_repository.dart';
import '../../routing/route_paths.dart';

/// Ports `SearchResultsScreen`.
///
/// TIER 1 — FULLY IMPLEMENTED: results are genuinely filtered against
/// [TutorRepository.search] using the query/category carried over from
/// Find Tutor, and the search field here keeps filtering live as the
/// student edits it — the "N tutors found" count is real, not hardcoded.
class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({
    super.key,
    required this.initialQuery,
    this.category,
  });

  final String initialQuery;
  final String? category;

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  late final TextEditingController _controller;
  late String _query;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tutorRepositoryProvider);
    final results = repository.search(query: _query, category: widget.category);

    return AppScaffold(
      activeTab: BottomNavTab.findTutor,
      topBar: TopNavBar(
        title: 'Search Results',
        onBack: () => context.go(RoutePaths.findTutor),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: SearchField(
              controller: _controller,
              placeholder: 'Search',
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${results.length} tutor${results.length == 1 ? '' : 's'} found',
                  style: AppTextStyles.body(fontSize: 13, color: AppColors.textSecondary),
                ),
                Row(
                  children: [
                    const Icon(LucideIcons.slidersHorizontal,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('Sort',
                        style:
                            AppTextStyles.body(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Text(
                      'No tutors match your search.',
                      style: AppTextStyles.body(
                          fontSize: 14, color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final tutor = results[index];
                      return TutorCard(
                        tutor: tutor,
                        onView: () => context.go(RoutePaths.tutorProfilePath(tutor.id)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
