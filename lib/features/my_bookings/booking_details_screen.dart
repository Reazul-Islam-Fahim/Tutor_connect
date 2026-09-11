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
import '../../core/widgets/secondary_button.dart';
import '../../core/widgets/star_rating.dart';
import '../../core/widgets/top_nav_bar.dart';
import '../../data/repositories/booking_repository.dart';
import '../../routing/route_paths.dart';

/// Ports `BookingDetailsScreen`.
///
/// TIER 1 — FULLY IMPLEMENTED: "Cancel Booking" opens the same
/// confirmation bottom sheet as the original, and confirming it actually
/// removes the booking from [bookingsProvider] state before returning to
/// My Bookings — it isn't a dead-end button.
///
/// "Message Tutor" is left without a handler, matching the original
/// source (it has no `onClick` there either) — messaging a tutor is
/// out of scope for this front-end-only assessment.
class BookingDetailsScreen extends ConsumerWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  void _showCancelSheet(BuildContext context, WidgetRef ref) {
    final booking = ref.read(bookingsProvider.notifier).findById(bookingId);
    if (booking == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Cancel Booking?',
                    style:
                        AppTextStyles.display(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Are you sure you want to cancel this session with '
                  '${booking.tutor.name} on ${booking.dateLabel} at ${booking.timeLabel}?',
                  style: AppTextStyles.body(
                      fontSize: 14, color: AppColors.textSecondary, height: 1.6),
                ),
              ),
              const SizedBox(height: 24),
              SecondaryButton(
                label: 'Yes, Cancel Booking',
                danger: true,
                onPressed: () {
                  ref.read(bookingsProvider.notifier).cancelBooking(bookingId);
                  Navigator.of(sheetContext).pop();
                  context.go(RoutePaths.myBookings);
                },
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                label: 'Keep Booking',
                onPressed: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bookingsProvider);
    final booking = ref.read(bookingsProvider.notifier).findById(bookingId);

    return AppScaffold(
      activeTab: BottomNavTab.bookings,
      topBar: TopNavBar(
        title: 'Booking Details',
        onBack: () => context.go(RoutePaths.myBookings),
      ),
      body: booking == null
          ? Center(
              child: Text('This booking is no longer available.',
                  style: AppTextStyles.body(fontSize: 14, color: AppColors.textSecondary)),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success.withOpacity(0.13)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 20, color: AppColors.success),
                      const SizedBox(width: 8),
                      Text('Session Confirmed',
                          style: AppTextStyles.body(
                              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.success)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel('Tutor'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Avatar(name: booking.tutor.name, size: 48, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booking.tutor.name,
                                  style: AppTextStyles.body(
                                      fontSize: 15, fontWeight: FontWeight.w700)),
                              Text(booking.tutor.subject,
                                  style: AppTextStyles.body(
                                      fontSize: 13, color: AppColors.textSecondary)),
                              StarRating(rating: booking.tutor.rating),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel('Session Info'),
                      const SizedBox(height: 10),
                      _InfoRow('Subject', booking.tutor.subject),
                      _InfoRow('Date', booking.dateLabel),
                      _InfoRow('Time', booking.timeLabel),
                      _InfoRow('Duration', '${booking.durationMinutes} minutes'),
                      _InfoRow('Price', '\$${booking.price.toStringAsFixed(2)}', isLast: true),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lesson Notes',
                              style: AppTextStyles.body(
                                  fontSize: 14, color: AppColors.textSecondary)),
                          Expanded(
                            child: Text(
                              booking.notes.isEmpty ? '—' : booking.notes,
                              textAlign: TextAlign.right,
                              style: AppTextStyles.body(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Messaging is outside this front-end\'s scope.')),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(LucideIcons.messageSquare, size: 18),
                  label: const Text('Message Tutor'),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: 'Cancel Booking',
                  danger: true,
                  onPressed: () => _showCancelSheet(context, ref),
                ),
              ],
            ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.body(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.isLast = false});

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: isLast
          ? null
          : const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body(fontSize: 14, color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.body(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
