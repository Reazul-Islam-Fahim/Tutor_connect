import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/bottom_nav_bar.dart';
import '../features/booking/booking_success_screen.dart';
import '../features/booking/booking_summary_screen.dart';
import '../features/booking/select_datetime_screen.dart';
import '../features/find_tutor/find_tutor_screen.dart';
import '../features/find_tutor/search_results_screen.dart';
import '../features/home/home_screen.dart';
import '../features/my_bookings/booking_details_screen.dart';
import '../features/my_bookings/my_bookings_screen.dart';
import '../features/onboarding/sign_in_screen.dart';
import '../features/onboarding/welcome_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/tutor_profile/tutor_profile_screen.dart';
import 'route_paths.dart';

/// The declarative navigation graph. Every route here corresponds 1:1 to a
/// case in the original `{screen === '...' && <Screen navigate={navigate} />}`
/// block in `App.tsx`.
final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.splash,
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: RoutePaths.signIn,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: RoutePaths.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RoutePaths.findTutor,
      builder: (context, state) => FindTutorScreen(
        initialQuery: state.uri.queryParameters['q'],
        initialCategory: state.uri.queryParameters['category'],
      ),
    ),
    GoRoute(
      path: RoutePaths.searchResults,
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        final category = state.uri.queryParameters['category'];
        return SearchResultsScreen(initialQuery: query, category: category);
      },
    ),
    GoRoute(
      path: RoutePaths.tutorProfile,
      builder: (context, state) {
        final tutorId = state.pathParameters['tutorId']!;
        return TutorProfileScreen(tutorId: tutorId);
      },
    ),
    GoRoute(
      path: RoutePaths.selectDateTime,
      builder: (context, state) {
        final tutorId = state.pathParameters['tutorId']!;
        return SelectDateTimeScreen(tutorId: tutorId);
      },
    ),
    GoRoute(
      path: RoutePaths.bookingSummary,
      builder: (context, state) {
        final tutorId = state.pathParameters['tutorId']!;
        return BookingSummaryScreen(tutorId: tutorId);
      },
    ),
    GoRoute(
      path: RoutePaths.bookingSuccess,
      builder: (context, state) {
        final bookingId = state.pathParameters['bookingId']!;
        return BookingSuccessScreen(bookingId: bookingId);
      },
    ),
    GoRoute(
      path: RoutePaths.myBookings,
      builder: (context, state) => const MyBookingsScreen(),
    ),
    GoRoute(
      path: RoutePaths.bookingDetails,
      builder: (context, state) {
        final bookingId = state.pathParameters['bookingId']!;
        return BookingDetailsScreen(bookingId: bookingId);
      },
    ),
    GoRoute(
      path: RoutePaths.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

/// Handles taps on the persistent bottom nav, matching the original's
/// `navigate(tab.target)` behaviour for the four primary destinations.
void navigateToTab(BuildContext context, BottomNavTab tab) {
  switch (tab) {
    case BottomNavTab.home:
      context.go(RoutePaths.home);
    case BottomNavTab.findTutor:
      context.go(RoutePaths.findTutor);
    case BottomNavTab.bookings:
      context.go(RoutePaths.myBookings);
    case BottomNavTab.profile:
      context.go(RoutePaths.profile);
  }
}
