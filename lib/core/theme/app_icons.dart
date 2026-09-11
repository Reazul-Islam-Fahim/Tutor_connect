import 'package:flutter/material.dart';

/// Local drop-in replacement for the `lucide_icons` package: that package
/// extends IconData, which is now a `final` (non-extendable) class on
/// current Flutter SDKs, so it fails to compile. This maps every icon name
/// actually used in the app to its closest built-in Material icon instead —
/// no external dependency, guaranteed to match whatever Flutter SDK you have.
abstract final class LucideIcons {
  static const IconData star = Icons.star_rounded;
  static const IconData briefcase = Icons.work_outline_rounded;
  static const IconData arrowLeft = Icons.arrow_back_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData slidersHorizontal = Icons.tune_rounded;
  static const IconData bookOpen = Icons.menu_book_outlined;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData clock = Icons.access_time_rounded;
  static const IconData messageSquare = Icons.chat_bubble_outline_rounded;
  static const IconData edit3 = Icons.edit_outlined;
  static const IconData bell = Icons.notifications_outlined;
  static const IconData helpCircle = Icons.help_outline_rounded;
  static const IconData logOut = Icons.logout_rounded;
  static const IconData home = Icons.home_rounded;
  static const IconData compass = Icons.explore_outlined;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData user = Icons.person_outline_rounded;
  static const IconData mail = Icons.mail_outline_rounded;
  static const IconData lock = Icons.lock_outline_rounded;
}