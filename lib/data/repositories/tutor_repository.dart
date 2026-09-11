import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/tutor.dart';
import '../mock_tutors.dart';

/// In-memory tutor data source. Swapping this for a real HTTP-backed
/// repository later only requires changing this one class — every screen
/// consumes it through Riverpod providers, never the raw list.
class TutorRepository {
  List<Tutor> getAll() => List.unmodifiable(mockTutors);

  Tutor getById(String id) => mockTutors.firstWhere((t) => t.id == id);

  /// Powers the real Tutor Discovery functionality: filters by a text
  /// query (matched against name and subject) and, optionally, a subject
  /// category chip.
  List<Tutor> search({String query = '', String? category}) {
    final normalizedQuery = query.trim().toLowerCase();

    return mockTutors.where((tutor) {
      final matchesQuery = normalizedQuery.isEmpty ||
          tutor.name.toLowerCase().contains(normalizedQuery) ||
          tutor.subject.toLowerCase().contains(normalizedQuery);

      final matchesCategory = category == null ||
          category == 'All' ||
          tutor.subject.toLowerCase().contains(category.toLowerCase()) ||
          tutor.subjectTags
              .any((tag) => tag.toLowerCase().contains(category.toLowerCase()));

      return matchesQuery && matchesCategory;
    }).toList();
  }
}

final tutorRepositoryProvider = Provider<TutorRepository>((ref) {
  return TutorRepository();
});

final allTutorsProvider = Provider<List<Tutor>>((ref) {
  return ref.watch(tutorRepositoryProvider).getAll();
});
