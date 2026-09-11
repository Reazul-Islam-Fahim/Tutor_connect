import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/booking.dart';
import '../../models/tutor.dart';

/// Holds the in-memory list of the signed-in student's bookings. This is
/// the state that makes the booking flow "real": confirming a booking
/// actually appends here, and My Bookings/Booking Details read from here
/// rather than showing static mock content.
class BookingsNotifier extends StateNotifier<List<Booking>> {
  BookingsNotifier() : super(_seedCompletedBooking());

  static List<Booking> _seedCompletedBooking() {
    return [
      Booking(
        id: 'seed-completed-1',
        tutor: const Tutor(
          id: 'michael-chen',
          name: 'Michael Chen',
          subject: 'SQL & Data Modelling',
          rating: 4.8,
          price: 35,
          experienceYears: 4,
          avatarColor: Color.fromARGB(255, 8, 145, 178),
        ),
        dateLabel: 'Saturday, 12 July',
        timeLabel: '2:00 PM',
        durationMinutes: 60,
        price: 35,
        notes: '',
        status: BookingStatus.completed,
        myRating: 5,
      ),
    ];
  }

  int _sequence = 0;

  /// Creates a new confirmed booking from the selections made across
  /// Select Date/Time → Booking Summary, and returns it so the success
  /// screen can display its details.
  Booking confirmBooking({
    required Tutor tutor,
    required String dateLabel,
    required String timeLabel,
    required int durationMinutes,
    required double price,
    required String notes,
  }) {
    _sequence += 1;
    final booking = Booking(
      id: 'booking-$_sequence',
      tutor: tutor,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      durationMinutes: durationMinutes,
      price: price,
      notes: notes,
      status: BookingStatus.confirmed,
    );
    state = [booking, ...state];
    return booking;
  }

  void cancelBooking(String id) {
    state = state
        .map((b) => b.id == id ? b.copyWith(status: BookingStatus.cancelled) : b)
        .where((b) => b.status != BookingStatus.cancelled)
        .toList();
  }

  List<Booking> get upcoming =>
      state.where((b) => b.status == BookingStatus.confirmed).toList();

  List<Booking> get completed =>
      state.where((b) => b.status == BookingStatus.completed).toList();

  Booking? findById(String id) {
    for (final booking in state) {
      if (booking.id == id) return booking;
    }
    return null;
  }
}

final bookingsProvider =
    StateNotifierProvider<BookingsNotifier, List<Booking>>((ref) {
  return BookingsNotifier();
});
