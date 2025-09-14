import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    List<CustomerGroup>? visibleCustomerGroups =
        ref.watch(visibleCustomerGroupsProvider).value;
    Map<DateTime, List<CustomerGroup>>? customerGroupsByDay =
        ref.watch(customerGroupsByDayProvider).value;
    Map<String, int>? customersNumberByCgId =
        ref.watch(customersNumberByCustomerGroupIdProvider).value;
    return Expanded(
      child: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 1,
        monthCellBuilder: (BuildContext cellContext, MonthCellDetails details) {
          List<CustomerGroup> todayCustomerGroups =
              customerGroupsByDay?[details.date] ?? [];

          return InkWell(
            onTap: () {
              ref
                  .read(selectedDateInCalendarProvider.notifier)
                  .change(details.date);
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              color: _getCellColor(todayCustomerGroups, customersNumberByCgId),
              child: Text(details.date.toString()),
            ),
          );
        },
        monthViewSettings: const MonthViewSettings(
            numberOfWeeksInView: 5,
            dayFormat: "EEE",
            appointmentDisplayCount: 1,
            appointmentDisplayMode: MonthAppointmentDisplayMode.none),
        dataSource: CustomerGroupDataSource(
            cgs: visibleCustomerGroups ?? [], tourType: tourType),
        onViewChanged: (ViewChangedDetails details) {
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            logger.info("Changing dates");
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
    if (dayCustomerGroups.isEmpty) return Colors.red;
    if (customersNumberByCgId == null) return Colors.red;
    for (final cg in dayCustomerGroups) {
      final n = customersNumberByCgId[cg.id];
      if (n == null) continue;
      if (cg.maxCapacity > n) return Colors.green;
    }
    return Colors.red;
  }
}

class CustomerGroupDataSource extends CalendarDataSource<CustomerGroup> {
  final List<CustomerGroup> cgs;
  final TourType tourType;
  CustomerGroupDataSource({required this.cgs, required this.tourType});
  @override
  List<CustomerGroup> get appointments => cgs;
  @override
  DateTime getStartTime(int index) {
    return appointments[index].datetime;
  }

  @override
  DateTime getEndTime(int index) {
    DateTime startTime = appointments[index].datetime;
    int duration = tourType.duration;
    return startTime.add(Duration(minutes: duration));
  }

  @override
  String getSubject(int index) {
    return "";
  }
}
