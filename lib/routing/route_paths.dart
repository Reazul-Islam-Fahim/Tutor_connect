/// Route path constants — a direct analogue of the original TS `Screen`
/// union type, so the navigation graph stays easy to cross-reference with
/// the Figma Make source.
abstract final class RoutePaths {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const home = '/home';
  static const findTutor = '/find-tutor';
  static const searchResults = '/find-tutor/search-results';
  static const tutorProfile = '/tutor/:tutorId';
  static const selectDateTime = '/tutor/:tutorId/select-datetime';
  static const bookingSummary = '/tutor/:tutorId/booking-summary';
  static const bookingSuccess = '/booking-success/:bookingId';
  static const myBookings = '/my-bookings';
  static const bookingDetails = '/my-bookings/:bookingId';
  static const profile = '/profile';

  static String tutorProfilePath(String tutorId) => '/tutor/$tutorId';
  static String selectDateTimePath(String tutorId) =>
      '/tutor/$tutorId/select-datetime';
  static String bookingSummaryPath(String tutorId) =>
      '/tutor/$tutorId/booking-summary';
  static String bookingSuccessPath(String bookingId) =>
      '/booking-success/$bookingId';
  static String bookingDetailsPath(String bookingId) =>
      '/my-bookings/$bookingId';
}
