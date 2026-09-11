import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/star_rating.dart';
import '../../data/repositories/booking_repository.dart';
import '../../models/booking.dart';
import '../../routing/route_paths.dart';

/// Ports `MyBookingsScreen`.
///
/// TIER 1 — FULLY IMPLEMENTED: both tabs read from [bookingsProvider], the
/// same shared state the booking flow writes to — so a session confirmed
/// moments ago genuinely appears in "Upcoming" here, rather than the
/// screen showing unrelated static mock content.
class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  bool _showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(bookingsProvider.notifier);
    ref.watch(bookingsProvider); // rebuild when the list changes
    final upcoming = notifier.upcoming;
    final completed = notifier.completed;

    return AppScaffold(
      activeTab: BottomNavTab.bookings,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 34, 20, 0),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Bookings',
                    style: AppTextStyles.display(fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _Tab(
                        label: 'Upcoming',
                        active: _showUpcoming,
                        onTap: () => setState(() => _showUpcoming = true),
                      ),
                    ),
                    Expanded(
                      child: _Tab(
                        label: 'Completed',
                        active: !_showUpcoming,
                        onTap: () => setState(() => _showUpcoming = false),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _showUpcoming
                ? _UpcomingList(bookings: upcoming)
                : _CompletedList(bookings: completed),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? AppColors.primary : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.body(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _UpcomingList extends StatelessWidget {
  const _UpcomingList({required this.bookings});

  final List<Booking> bookings;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          'No upcoming sessions yet.\nBook a tutor to see it here.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body(fontSize: 14, color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Confirmed',
                    style: AppTextStyles.body(
                        fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Avatar(name: booking.tutor.name, size: 44, color: booking.tutor.avatarColor),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.tutor.name,
                          style: AppTextStyles.body(fontSize: 15, fontWeight: FontWeight.w700)),
                      Text(booking.tutor.subject,
                          style:
                              AppTextStyles.body(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4,
                crossAxisSpacing: 8,
                childAspectRatio: 5,
                children: [
                  _InfoChip('📅', booking.dateLabel),
                  _InfoChip('🕕', booking.timeLabel),
                  _InfoChip('⏱️', '${booking.durationMinutes} minutes'),
                  _InfoChip('💰', '\$${booking.price.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'View Details',
                onPressed: () => context.go(RoutePaths.bookingDetailsPath(booking.id)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.emoji, this.text);

  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _CompletedList extends StatelessWidget {
  const _CompletedList({required this.bookings});

  final List<Booking> bookings;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          'No completed sessions yet.',
          style: AppTextStyles.body(fontSize: 14, color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Opacity(
          opacity: 0.85,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.muted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Completed',
                      style: AppTextStyles.body(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Avatar(name: booking.tutor.name, size: 44, color: booking.tutor.avatarColor),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.tutor.name,
                            style: AppTextStyles.body(fontSize: 15, fontWeight: FontWeight.w700)),
                        Text(booking.tutor.subject,
                            style: AppTextStyles.body(
                                fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${booking.dateLabel} · ${booking.timeLabel} · \$${booking.price.toStringAsFixed(2)}',
                  style: AppTextStyles.body(fontSize: 13, color: AppColors.textSecondary),
                ),
                if (booking.myRating != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      StarRating(rating: booking.myRating!),
                      const SizedBox(width: 6),
                      Text('Your rating',
                          style: AppTextStyles.body(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
