import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../repository.dart';

class BookingCalendar extends ConsumerWidget {
  /// The tour type for this booking.
  final TourType tourType;
  final String account;
  static final logger = BasicLogger();
  const BookingCalendar(
      {super.key, required this.tourType, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = BookingPageRepository(account: account, tourId: tourType.id);
    List<CustomerGroup> customerGroups =
        ref.watch(customerGroupsForTourProvider);
    return Expanded(
      child: SfCalendar(
        view: CalendarView.month,
        onViewChanged: (ViewChangedDetails details) {
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            logger.info("View changed");
            List<DateTime> visibleDates = details.visibleDates;
            visibleDates.sort((a, b) => a.compareTo(b));
            if (visibleDates.isNotEmpty) {
              final firstAndLastDate = FirstAndLastDateInCalendar(
                  firstDate: visibleDates.first, lastDate: visibleDates.last);
              final newCgs = await repo.customerGroupsForTour(firstAndLastDate);
              ref.read(customerGroupsForTourProvider.notifier).change(newCgs);
            }
          });
        },
      ),
    );
  }
}
