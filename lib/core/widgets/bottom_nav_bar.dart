import 'package:flutter/material.dart';
import '../theme/app_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum BottomNavTab { home, findTutor, bookings, profile }

/// Ports `BottomNav`: four persistent destinations, with `activeMap`
/// semantics reproduced by the caller choosing the correct [activeTab]
/// (e.g. every screen in the booking flow reports [BottomNavTab.findTutor]
/// as active, matching the original's `activeMap`).
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.activeTab,
    required this.onSelect,
  });

  final BottomNavTab activeTab;
  final ValueChanged<BottomNavTab> onSelect;

  static const _tabs = [
    (tab: BottomNavTab.home, label: 'Home', icon: LucideIcons.home),
    (tab: BottomNavTab.findTutor, label: 'Find Tutor', icon: LucideIcons.compass),
    (tab: BottomNavTab.bookings, label: 'Bookings', icon: LucideIcons.calendar),
    (tab: BottomNavTab.profile, label: 'Profile', icon: LucideIcons.user),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              for (final entry in _tabs)
                Expanded(
                  child: _NavItem(
                    label: entry.label,
                    icon: entry.icon,
                    active: entry.tab == activeTab,
                    onTap: () => onSelect(entry.tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: active
                  ? AppTextStyles.display(fontSize: 10, fontWeight: FontWeight.w700, color: color)
                  : AppTextStyles.body(fontSize: 10, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
