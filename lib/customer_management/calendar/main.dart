import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingCalendar extends ConsumerStatefulWidget {
  static final logger = BasicLogger();
  const BookingCalendar({super.key});

  @override
  ConsumerState<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends ConsumerState<BookingCalendar> {
  late List<DateTime> visibleDates;
  late CalendarView viewLength = CalendarView.week;
  @override
  void initState() {
    super.initState();
    visibleDates = [];
  }

  @override
  Widget build(BuildContext context) {
    List<CustomerGroup> customerGroups =
        ref.watch(customerGroupsByDateRangeProvider(visibleDates)).value ?? [];
    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Text("Select view:"),
            DropdownMenu<CalendarView>(
              textStyle: TextStyle(fontSize: 12.0),
              inputDecorationTheme: InputDecorationTheme(
                isCollapsed: true,
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                border: OutlineInputBorder(),
              ),
              requestFocusOnTap: false,
              initialSelection: CalendarView.week,
              dropdownMenuEntries: [
                DropdownMenuEntry(value: CalendarView.week, label: "Week"),
                DropdownMenuEntry(value: CalendarView.day, label: "Day"),
              ],
              onSelected: (view) {
                if (view != null) {
                  setState(() {
                    viewLength = view;
                  });
                }
              },
            ),
          ],
        ),
        Expanded(
          child: SfCalendar(
            key: ValueKey(viewLength),
            view: viewLength,
            appointmentBuilder:
                (BuildContext context, CalendarAppointmentDetails details) {
              final CustomerGroup customerGroup =
                  details.appointments.first as CustomerGroup;

              if (customerGroup.name.isEmpty) {
                return Container();
              }

              // Get notes using the data source method
              final dataSource =
                  BookingsDataSource(source: customerGroups, ref: ref);
              final int index = customerGroups.indexOf(customerGroup);
              final String? notes =
                  index >= 0 ? dataSource.getNotes(index) : null;

              return Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerGroup.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (notes != null && notes.isNotEmpty) ...[
                      SizedBox(height: 2),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            notes,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            onViewChanged: (details) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  visibleDates = details.visibleDates;
                });
              });
            },
            showWeekNumber: true,
            firstDayOfWeek: 1,
            dataSource: BookingsDataSource(source: customerGroups, ref: ref),
          ),
        ),
      ],
    );
  }
}

class BookingsDataSource extends CalendarDataSource<CustomerGroup> {
  WidgetRef ref;
  BookingsDataSource({required List<CustomerGroup> source, required this.ref}) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].datetime;
  }

  @override
  DateTime getEndTime(int index) {
    CustomerGroup cg = appointments![index];
    if (cg.tourTypeId == null) {
      return cg.datetime.add(Duration(minutes: 60));
    }
    TourType? tour = ref.watch(tourTypeByIdProvider(cg.tourTypeId!)).value;
    if (tour == null) {
      return cg.datetime.add(Duration(minutes: 60));
    }
    return cg.datetime.add(Duration(minutes: tour.duration));
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  String? getNotes(int index) {
    CustomerGroup cg = appointments![index];
    if (cg.tourTypeId == null) {
      return null;
    }
    TourType? tour = ref.watch(tourTypeByIdProvider(cg.tourTypeId!)).value;
    if (tour == null) {
      return null;
    }
    List<Customer>? customers =
        ref.watch(CustomersByCustomerGroupIdProvider(cg.id)).value;
    if (customers == null) return null;
    List<TourTypePricing>? pricings =
        ref.watch(tourTypePricesProvider(tour.id)).value;
    if (pricings == null) return null;
    String toReturn = "${customers.length}/${cg.maxCapacity.toString()}\n";
    for (var price in pricings) {
      List<Customer> customerWithPrice = customers
          .where((c) => c.pricingId != null && c.pricingId == price.id)
          .toList();
      if (customerWithPrice.isNotEmpty) {
        toReturn = "$toReturn\n${price.name}: ${customerWithPrice.length}";
      }
    }
    return toReturn.trim().isEmpty ? null : toReturn.trim();
  }
}
