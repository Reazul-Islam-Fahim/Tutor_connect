import 'package:flutter/material.dart';

/// A tutor available for booking. Ported from the `TUTORS` mock array in
/// the Figma Make source.
@immutable
class Tutor {
  const Tutor({
    required this.id,
    required this.name,
    required this.subject,
    required this.rating,
    required this.price,
    required this.experienceYears,
    required this.avatarColor,
    this.subjectTags = const [],
    this.about = '',
    this.reviewCount = 0,
    this.sessionCount = 0,
    this.successRate = 0,
  });

  final String id;
  final String name;
  final String subject;
  final double rating;
  final int price;
  final int experienceYears;
  final Color avatarColor;
  final List<String> subjectTags;
  final String about;
  final int reviewCount;
  final int sessionCount;
  final int successRate;
}
