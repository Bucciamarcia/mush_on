import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/booking_page/booking_page.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingCalendar extends ConsumerWidget {
  /// The tour type for this booking.
  final TourType tourType;
  final String account;
  static final logger = BasicLogger();
  const BookingCalendar(
      {super.key, required this.tourType, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<DateTime, List<CustomerGroup>>? customerGroupsByDay =
        ref.watch(customerGroupsByDayProvider).value;
    Map<String, int>? customersNumberByCgId =
        ref.watch(customersNumberByCustomerGroupIdProvider).value;
    return Expanded(
      child: SfCalendar(
        showWeekNumber: true,
        showNavigationArrow: true,
        showDatePickerButton: true,
        initialDisplayDate:
            DateTime(DateTime.now().year, DateTime.now().month, 1),
        view: CalendarView.month,
        firstDayOfWeek: 1,
        monthCellBuilder: (BuildContext cellContext, MonthCellDetails details) {
          List<CustomerGroup> todayCustomerGroups =
              customerGroupsByDay?[details.date] ?? [];
          Color cellColor =
              _getCellColor(todayCustomerGroups, customersNumberByCgId);

          return InkWell(
            onTap: () {
              ref
                  .read(selectedDateInCalendarProvider.notifier)
                  .change(details.date);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: cellColor.withAlpha(150)),
              margin: const EdgeInsets.all(5),
              child: Text(details.date.toString()),
            ),
          );
        },
        monthViewSettings: const MonthViewSettings(
            showTrailingAndLeadingDates: false,
            dayFormat: "EEE",
            appointmentDisplayCount: 1,
            appointmentDisplayMode: MonthAppointmentDisplayMode.none),
        onViewChanged: (ViewChangedDetails details) {
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            logger.info("Changing dates");
            logger.debug(details.visibleDates);
            ref
                .read(visibleDatesProvider.notifier)
                .change(details.visibleDates);
          });
        },
      ),
    );
  }

  Color _getCellColor(List<CustomerGroup> dayCustomerGroups,
      Map<String, int>? customersNumberByCgId) {
    if (dayCustomerGroups.isEmpty) return BookingPageColors.danger.color;
    if (customersNumberByCgId == null) return BookingPageColors.danger.color;
    for (final cg in dayCustomerGroups) {
      final n = customersNumberByCgId[cg.id];
      if (n == null) continue;
      if (cg.maxCapacity > n) return BookingPageColors.success.color;
    }
    return BookingPageColors.danger.color;
  }
}
