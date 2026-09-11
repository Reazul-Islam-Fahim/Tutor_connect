import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/avatar.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/star_rating.dart';
import '../../core/widgets/top_nav_bar.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/tutor_repository.dart';
import '../../routing/route_paths.dart';
import 'booking_draft_provider.dart';

const _dayNames = {
  'Mon': 'Monday',
  'Tue': 'Tuesday',
  'Wed': 'Wednesday',
  'Thu': 'Thursday',
  'Fri': 'Friday',
  'Sat': 'Saturday',
  'Sun': 'Sunday',
};

String _formatDate(String dateLabel) {
  final parts = dateLabel.split(' ');
  if (parts.length != 2) return '$dateLabel, August';
  final dayName = _dayNames[parts[0]] ?? parts[0];
  return '$dayName, ${parts[1]} August';
}

/// Ports `BookingSummaryScreen`.
///
/// TIER 1 — FULLY IMPLEMENTED: "Confirm Booking" doesn't just navigate —
/// it calls [BookingsNotifier.confirmBooking], which actually appends a
/// new [Booking] to shared app state. My Bookings and Booking Details
/// afterwards show this exact booking, not static mock content.
class BookingSummaryScreen extends ConsumerStatefulWidget {
  const BookingSummaryScreen({super.key, required this.tutorId});

  final String tutorId;

  @override
  ConsumerState<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bookingDraftProvider);
    _notesController = TextEditingController(text: draft.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tutor = ref.watch(tutorRepositoryProvider).getById(widget.tutorId);
    final draft = ref.watch(bookingDraftProvider);

    return AppScaffold(
      activeTab: BottomNavTab.findTutor,
      topBar: TopNavBar(
        title: 'Booking Summary',
        onBack: () => context.go(RoutePaths.selectDateTimePath(widget.tutorId)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel('Tutor'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Avatar(name: tutor.name, size: 44, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tutor.name,
                            style:
                                AppTextStyles.body(fontSize: 15, fontWeight: FontWeight.w700)),
                        Text(tutor.subject,
                            style: AppTextStyles.body(
                                fontSize: 13, color: AppColors.textSecondary)),
                        StarRating(rating: tutor.rating),
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
                _SectionLabel('Session Details'),
                const SizedBox(height: 12),
                _Row('Date', _formatDate(draft.dateLabel)),
                _Row('Time', draft.timeLabel),
                _Row('Duration', '60 minutes', isLast: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style:
                            AppTextStyles.body(fontSize: 15, fontWeight: FontWeight.w700)),
                    Text(
                      '\$${tutor.price.toStringAsFixed(2)}',
                      style: AppTextStyles.display(
                          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
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
                _SectionLabel('Topics To Cover'),
                const SizedBox(height: 10),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  onChanged: (value) => ref.read(bookingDraftProvider.notifier).setNotes(value),
                  style: AppTextStyles.body(fontSize: 14, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'What topics would you like help with?',
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.13)),
            ),
            child: Text(
              '💳 Payment will be processed securely after session confirmation. '
              'No charge until confirmed.',
              style: AppTextStyles.body(
                  fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary, height: 1.5),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Confirm Booking',
            onPressed: () {
              final booking = ref.read(bookingsProvider.notifier).confirmBooking(
                    tutor: tutor,
                    dateLabel: _formatDate(draft.dateLabel),
                    timeLabel: draft.timeLabel,
                    durationMinutes: 60,
                    price: tutor.price.toDouble(),
                    notes: _notesController.text,
                  );
              ref.read(bookingDraftProvider.notifier).reset();
              context.go(RoutePaths.bookingSuccessPath(booking.id));
            },
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
      style: AppTextStyles.body(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.isLast = false});

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
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
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
