import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/top_nav_bar.dart';
import '../../data/repositories/tutor_repository.dart';
import '../../routing/route_paths.dart';
import 'booking_draft_provider.dart';

/// Ports `SelectDateTimeScreen`.
///
/// TIER 1 — FULLY IMPLEMENTED: date and time selection write to
/// [bookingDraftProvider] in real time (not local-only UI state that
/// evaporates on navigation), so Booking Summary reflects exactly what
/// was picked here. The 12:00 PM slot is genuinely disabled/unselectable,
/// matching the original's `unavailable` list.
class SelectDateTimeScreen extends ConsumerWidget {
  const SelectDateTimeScreen({super.key, required this.tutorId});

  final String tutorId;

  static const _dates = [
    ('Mon', '24'),
    ('Tue', '25'),
    ('Wed', '26'),
    ('Thu', '27'),
    ('Fri', '28'),
  ];

  static const _times = ['10:00 AM', '12:00 PM', '2:00 PM', '4:00 PM', '6:00 PM'];
  static const _unavailable = {'12:00 PM'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutor = ref.watch(tutorRepositoryProvider).getById(tutorId);
    final draft = ref.watch(bookingDraftProvider);
    final draftNotifier = ref.read(bookingDraftProvider.notifier);

    return AppScaffold(
      activeTab: BottomNavTab.findTutor,
      topBar: TopNavBar(
        title: 'Select Date & Time',
        onBack: () => context.go(RoutePaths.tutorProfilePath(tutorId)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Avatar(name: tutor.name, size: 40, color: AppColors.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tutor.name,
                        style: AppTextStyles.body(fontSize: 14, fontWeight: FontWeight.w700)),
                    Text('${tutor.subject} · \$${tutor.price}/hr',
                        style:
                            AppTextStyles.body(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Choose Date',
              style: AppTextStyles.display(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('August 2026',
              style: AppTextStyles.body(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final entry in _dates)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _DateCell(
                      day: entry.$1,
                      date: entry.$2,
                      active: draft.dateLabel == '${entry.$1} ${entry.$2}',
                      onTap: () => draftNotifier.setDate('${entry.$1} ${entry.$2}'),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Available Times',
              style: AppTextStyles.display(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.6,
            children: [
              for (final time in _times)
                _TimeCell(
                  time: time,
                  active: draft.timeLabel == time,
                  disabled: _unavailable.contains(time),
                  onTap: () => draftNotifier.setTime(time),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: const [
              _Legend(color: AppColors.primary, label: 'Selected'),
              _Legend(color: AppColors.white, borderColor: AppColors.border, label: 'Available'),
              _Legend(color: AppColors.muted, borderColor: AppColors.border, label: 'Unavailable'),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Continue',
            onPressed: () => context.go(RoutePaths.bookingSummaryPath(tutorId)),
          ),
        ],
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  const _DateCell({
    required this.day,
    required this.date,
    required this.active,
    required this.onTap,
  });

  final String day;
  final String date;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: active ? AppColors.primary : AppColors.border, width: 1.5),
          ),
          child: Column(
            children: [
              Text(
                day,
                style: AppTextStyles.body(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: active ? Colors.white.withOpacity(0.75) : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: AppTextStyles.body(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeCell extends StatelessWidget {
  const _TimeCell({
    required this.time,
    required this.active,
    required this.disabled,
    required this.onTap,
  });

  final String time;
  final bool active;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = disabled ? AppColors.muted : (active ? AppColors.primary : AppColors.white);
    final borderColor = disabled ? AppColors.border : (active ? AppColors.primary : AppColors.border);
    final foreground = disabled
        ? AppColors.textSecondary
        : (active ? Colors.white : AppColors.textPrimary);

    return Opacity(
      opacity: disabled ? 0.6 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.clock, size: 14, color: foreground),
                const SizedBox(width: 6),
                Text(time,
                    style: AppTextStyles.body(
                        fontSize: 14, fontWeight: FontWeight.w600, color: foreground)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, this.borderColor});

  final Color color;
  final Color? borderColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: borderColor ?? color, width: 1.5),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.body(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
