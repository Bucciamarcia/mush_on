import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
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
    List<DateTime> visibleDates = ref.watch(visibleDatesProvider);
    List<CustomerGroup> customerGroups = ref
            .watch(customerGroupsByDateRangeProvider(visibleDates,
                account: account))
            .value ??
        [];
    return Expanded(
      child: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayCount: 1,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        dataSource:
            CustomerGroupDataSource(cgs: customerGroups, tourType: tourType),
        onViewChanged: (ViewChangedDetails details) {
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            logger.info("View changed");
            List<DateTime> visibleDates = details.visibleDates;
            visibleDates.sort((a, b) => a.compareTo(b));
            if (visibleDates.isNotEmpty) {
              ref.read(visibleDatesProvider.notifier).change(visibleDates);
            }
          });
        },
      ),
    );
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
