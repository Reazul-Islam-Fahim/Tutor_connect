import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../data/repositories/booking_repository.dart';
import '../../routing/route_paths.dart';

/// Ports `BookingSuccessScreen`.
///
/// TIER 1 — FULLY IMPLEMENTED: reads the just-created [Booking] from
/// [bookingsProvider] by id, so the tutor/date/time/price shown here are
/// the real values the student picked — not restated mock text.
class BookingSuccessScreen extends ConsumerWidget {
  const BookingSuccessScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingsProvider.notifier).findById(bookingId);

    if (booking == null) {
      // Defensive fallback: shouldn't happen in normal navigation, but
      // avoids a crash if this route is ever opened without a valid id.
      return AppScaffold(
        activeTab: BottomNavTab.home,
        body: Center(
          child: PrimaryButton(
            label: 'Return Home',
            onPressed: () => context.go(RoutePaths.home),
          ),
        ),
      );
    }

    return AppScaffold(
      activeTab: BottomNavTab.findTutor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.4),
                        width: 3,
                      ),
                    ),
                    child: const Icon(Icons.check, size: 42, color: AppColors.success),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Booking Successful!',
                    style: AppTextStyles.display(fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your session has been confirmed. You'll receive a "
                    'confirmation email shortly.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(
                        fontSize: 14, color: AppColors.textSecondary, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Avatar(
                                name: booking.tutor.name, size: 44, color: AppColors.primary),
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
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(emoji: '📅', text: booking.dateLabel),
                        _InfoRow(
                            emoji: '🕕',
                            text: '${booking.timeLabel} · ${booking.durationMinutes} minutes'),
                        _InfoRow(emoji: '💰', text: '\$${booking.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                PrimaryButton(
                  label: 'View My Bookings',
                  onPressed: () => context.go(RoutePaths.myBookings),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: 'Return Home',
                  onPressed: () => context.go(RoutePaths.home),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.emoji, required this.text});

  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 10),
          Text(text, style: AppTextStyles.body(fontSize: 14)),
        ],
      ),
    );
  }
}
