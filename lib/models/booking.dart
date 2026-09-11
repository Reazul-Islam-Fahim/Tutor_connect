import 'package:flutter/material.dart';

import 'tutor.dart';

enum BookingStatus { confirmed, completed, cancelled }

/// A confirmed (or historical) tutoring session, created at the end of the
/// Select Date/Time → Booking Summary → Booking Success flow and displayed
/// on My Bookings / Booking Details.
@immutable
class Booking {
  const Booking({
    required this.id,
    required this.tutor,
    required this.dateLabel,
    required this.timeLabel,
    required this.durationMinutes,
    required this.price,
    required this.notes,
    required this.status,
    this.myRating,
  });

  final String id;
  final Tutor tutor;
  final String dateLabel;
  final String timeLabel;
  final int durationMinutes;
  final double price;
  final String notes;
  final BookingStatus status;
  final double? myRating;

  Booking copyWith({BookingStatus? status}) {
    return Booking(
      id: id,
      tutor: tutor,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      durationMinutes: durationMinutes,
      price: price,
      notes: notes,
      status: status ?? this.status,
      myRating: myRating,
    );
  }
}
