import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/customer_group_viewer.dart';
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
            const Text("Select view:"),
            DropdownMenu<CalendarView>(
              textStyle: const TextStyle(fontSize: 12.0),
              inputDecorationTheme: const InputDecorationTheme(
                isCollapsed: true,
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                border: OutlineInputBorder(),
              ),
              requestFocusOnTap: false,
              initialSelection: CalendarView.week,
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: CalendarView.day, label: "Day"),
                DropdownMenuEntry(value: CalendarView.week, label: "Week"),
                DropdownMenuEntry(value: CalendarView.month, label: "Month"),
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
            showNavigationArrow: true,
            onTap: (details) {
              if (details.appointments == null) return;
              if (details.appointments!.isEmpty) return;
              if (details.appointments!.length == 1) {
                CustomerGroup cg = details.appointments!.first;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomerGroupViewerScreen(customerGroupId: cg.id),
                  ),
                );
              }
            },
            monthViewSettings: const MonthViewSettings(
                appointmentDisplayCount: 3, showAgenda: true),
            monthCellBuilder: viewLength == CalendarView.month
                ? (BuildContext context, MonthCellDetails details) {
                    final List<CustomerGroup> dayAppointments = customerGroups
                        .where((cg) =>
                            cg.datetime.year == details.date.year &&
                            cg.datetime.month == details.date.month &&
                            cg.datetime.day == details.date.day)
                        .toList();

                    return Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date number
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              details.date.day.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: details.date.month ==
                                        details.visibleDates.first.month
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          // Appointments
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dayAppointments.length,
                              itemBuilder: (context, index) {
                                final cg = dayAppointments[index];
                                TourType? tourType;
                                if (cg.tourTypeId != null) {
                                  tourType = ref
                                      .watch(
                                        tourTypeByIdProvider(cg.tourTypeId!),
                                      )
                                      .value;
                                }
                                List<Customer> customers = ref
                                        .watch(
                                            customersByCustomerGroupIdProvider(
                                                cg.id))
                                        .value ??
                                    [];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 1, vertical: 1),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: tourType?.backgroundColor ??
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${cg.name} ${customers.length}/${cg.maxCapacity}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "${cg.datetime.hour.toString().padLeft(2, '0')}:${cg.datetime.minute.toString().padLeft(2, '0')}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                : null,
            appointmentBuilder: viewLength != CalendarView.month
                ? (BuildContext context, CalendarAppointmentDetails details) {
                    final CustomerGroup customerGroup =
                        details.appointments.first as CustomerGroup;

                    if (customerGroup.name.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    // Get notes using the data source method
                    final dataSource =
                        BookingsDataSource(source: customerGroups, ref: ref);
                    final int index = customerGroups.indexOf(customerGroup);
                    final String? notes =
                        index >= 0 ? dataSource.getNotes(index) : null;
                    TourType? tourType;
                    if (customerGroup.tourTypeId != null) {
                      tourType = ref
                          .watch(
                              tourTypeByIdProvider(customerGroup.tourTypeId!))
                          .value;
                    }
                    List<Customer> customers = ref
                            .watch(customersByCustomerGroupIdProvider(
                                customerGroup.id))
                            .value ??
                        [];

                    // Day/Week view - show title and notes
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: tourType?.backgroundColor ??
                            Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${customerGroup.name} ${customers.length}/${customerGroup.maxCapacity}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (notes != null && notes.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  notes,
                                  style: const TextStyle(
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
                  }
                : null,
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
      return cg.datetime.add(const Duration(minutes: 60));
    }
    TourType? tour = ref.watch(tourTypeByIdProvider(cg.tourTypeId!)).value;
    if (tour == null) {
      return cg.datetime.add(const Duration(minutes: 60));
    }
    return cg.datetime.add(Duration(minutes: tour.duration));
  }

  @override
  String getSubject(int index) {
    List<Customer> customers = ref
            .watch(customersByCustomerGroupIdProvider(appointments![index].id))
            .value ??
        [];
    return appointments![index].name +
        " " +
        "${customers.length}/${appointments![index].maxCapacity}";
  }

  @override
  Color getColor(int index) {
    final cg = appointments![index];
    if (cg.tourTypeId != null) {
      final tourType = ref.watch(tourTypeByIdProvider(cg.tourTypeId!)).value;
      if (tourType?.backgroundColor != null) {
        return tourType!.backgroundColor;
      }
    }
    return Theme.of(ref.context).colorScheme.primary; // fallback
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
    String toReturn = "${customers.length}/${cg.maxCapacity}\n";
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
