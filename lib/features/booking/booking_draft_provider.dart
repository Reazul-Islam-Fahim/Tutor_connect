import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The in-progress selections a student makes while booking a session:
/// Select Date/Time writes here, Booking Summary reads (and can adjust
/// notes), and Booking Success/confirmation consumes the final value.
/// This is what makes the flow "real" rather than three disconnected
/// static screens.
@immutable
class BookingDraft {
  const BookingDraft({
    this.dateLabel = 'Tue 25',
    this.timeLabel = '6:00 PM',
    this.notes = 'ER diagrams, normalisation and SQL joins.',
  });

  final String dateLabel;
  final String timeLabel;
  final String notes;

  BookingDraft copyWith({String? dateLabel, String? timeLabel, String? notes}) {
    return BookingDraft(
      dateLabel: dateLabel ?? this.dateLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      notes: notes ?? this.notes,
    );
  }
}

class BookingDraftNotifier extends StateNotifier<BookingDraft> {
  BookingDraftNotifier() : super(const BookingDraft());

  void setDate(String dateLabel) => state = state.copyWith(dateLabel: dateLabel);

  void setTime(String timeLabel) => state = state.copyWith(timeLabel: timeLabel);

  void setNotes(String notes) => state = state.copyWith(notes: notes);

  void reset() => state = const BookingDraft();
}

final bookingDraftProvider =
    StateNotifierProvider<BookingDraftNotifier, BookingDraft>((ref) {
  return BookingDraftNotifier();
});
