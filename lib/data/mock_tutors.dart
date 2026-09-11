import 'package:flutter/material.dart';

import '../models/tutor.dart';

/// Ported from the `TUTORS` array in the Figma Make source, extended with
/// the extra profile fields (`about`, `subjectTags`, stats) that the Tutor
/// Profile screen displays.
final List<Tutor> mockTutors = [
  const Tutor(
    id: 'emily-carter',
    name: 'Emily Carter',
    subject: 'Database Management',
    rating: 4.9,
    price: 40,
    experienceYears: 6,
    avatarColor: Color(0xFF4F46E5),
    subjectTags: ['Database Management', 'SQL', 'Data Modelling'],
    about:
        'Experienced database tutor specialising in SQL, ER diagrams, '
        'normalisation and database design. I help students build strong '
        'conceptual understanding alongside practical skills.',
    reviewCount: 86,
    sessionCount: 120,
    successRate: 98,
  ),
  const Tutor(
    id: 'michael-chen',
    name: 'Michael Chen',
    subject: 'SQL & Data Modelling',
    rating: 4.8,
    price: 35,
    experienceYears: 4,
    avatarColor: Color(0xFF0891B2),
    subjectTags: ['SQL', 'Data Modelling', 'Database Systems'],
    about:
        'I focus on making relational database concepts click through '
        'real-world modelling exercises and query-writing practice.',
    reviewCount: 54,
    sessionCount: 78,
    successRate: 96,
  ),
  const Tutor(
    id: 'sarah-wilson',
    name: 'Sarah Wilson',
    subject: 'Database Systems',
    rating: 4.7,
    price: 32,
    experienceYears: 3,
    avatarColor: Color(0xFF7C3AED),
    subjectTags: ['Database Systems', 'SQL', 'Transactions'],
    about:
        'Patient, example-driven tutor covering database systems fundamentals, '
        'transactions and indexing for university coursework.',
    reviewCount: 31,
    sessionCount: 45,
    successRate: 94,
  ),
];
