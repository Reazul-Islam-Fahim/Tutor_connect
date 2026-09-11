import 'package:flutter/material.dart';

import '../../routing/app_router.dart';
import '../theme/app_colors.dart';
import 'bottom_nav_bar.dart';
import 'max_width_container.dart';

/// Shared page shell used by every screen: caps content width on large
/// screens (see [MaxWidthContainer]) and optionally shows the persistent
/// bottom navigation, matching the original's `showBottomNav` screen set.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.topBar,
    this.activeTab,
    this.backgroundColor = AppColors.background,
  });

  final Widget body;
  final PreferredSizeWidget? topBar;
  final BottomNavTab? activeTab;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: topBar,
      body: MaxWidthContainer(child: body),
      bottomNavigationBar: activeTab == null
          ? null
          : MaxWidthContainer(
              child: BottomNavBar(
                activeTab: activeTab!,
                onSelect: (tab) => navigateToTab(context, tab),
              ),
            ),
    );
  }
}
