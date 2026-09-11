import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../routing/route_paths.dart';

/// Ports `ProfileScreen`.
///
/// NOT IMPLEMENTED (documented in the report): the menu items (Edit
/// Profile, My Subjects, Notifications, Help & Support) are built as
/// polished, navigable-looking rows but have no destination screens or
/// backing data behind them, matching the original source (none of them
/// carry an `onClick` there either). Only "Sign Out" is wired, returning
/// to Welcome.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _menuItems = [
    (LucideIcons.edit3, 'Edit Profile'),
    (LucideIcons.bookOpen, 'My Subjects'),
    (LucideIcons.bell, 'Notifications'),
    (LucideIcons.helpCircle, 'Help & Support'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      activeTab: BottomNavTab.profile,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 32),
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                const Avatar(name: 'Alex Morgan', size: 72, color: Colors.white),
                const SizedBox(height: 10),
                Text('Alex Morgan',
                    style: AppTextStyles.display(
                        fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('University Student',
                    style: AppTextStyles.body(
                        fontSize: 13, color: Colors.white.withOpacity(0.75))),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _HeroStat(label: 'Sessions', value: '7'),
                    SizedBox(width: 28),
                    _HeroStat(label: 'Subjects', value: '3'),
                    SizedBox(width: 28),
                    _HeroStat(label: 'Hours', value: '12'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < _menuItems.length; i++)
                        _MenuRow(
                          icon: _menuItems[i].$1,
                          label: _menuItems[i].$2,
                          showDivider: i < _menuItems.length - 1,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _MenuRow(
                    icon: LucideIcons.logOut,
                    label: 'Sign Out',
                    danger: true,
                    onTap: () => context.go(RoutePaths.welcome),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text('TutorConnect v1.0.0',
                      style:
                          AppTextStyles.body(fontSize: 12, color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.display(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        Text(label,
            style: AppTextStyles.body(fontSize: 11, color: Colors.white.withOpacity(0.6))),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    this.showDivider = false,
    this.danger = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool showDivider;
  final bool danger;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.red : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: showDivider
            ? const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border)))
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: danger ? AppColors.red : AppColors.textSecondary),
                const SizedBox(width: 14),
                Text(label,
                    style: AppTextStyles.body(
                        fontSize: 15, fontWeight: FontWeight.w500, color: color)),
              ],
            ),
            Icon(LucideIcons.chevronRight,
                size: 16, color: danger ? AppColors.red : AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
