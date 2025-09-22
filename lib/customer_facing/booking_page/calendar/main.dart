import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_facing/booking_page/booking_page.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingTimeAndDate extends StatelessWidget {
  /// The tour type for this booking.
  final TourType tourType;
  final String account;
  static final logger = BasicLogger();
  const BookingTimeAndDate(
      {super.key, required this.tourType, required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HeaderWithBubble(
          number: "1",
          title: "Select date",
        ),
        const Flexible(
          fit: FlexFit.loose,
          child: BookingCalendar(),
        ),
        TimeSelectorByDate(tourType: tourType)
      ],
    );
  }
}

class TimeSelectorByDate extends ConsumerWidget {
  final TourType tourType;
  const TimeSelectorByDate({super.key, required this.tourType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<DateTime, List<CustomerGroup>>? customerGroupsByDay =
        ref.watch(customerGroupsByDayProvider).value;
    DateTime? selectedDate = ref.watch(selectedDateInCalendarProvider);
    if (selectedDate == null) return const SizedBox.shrink();
    List<CustomerGroup>? todayCustomerGroups =
        customerGroupsByDay?[selectedDate];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWithBubble(number: "2", title: "Choose time"),
        const SizedBox(height: 15),
        todayCustomerGroups == null || todayCustomerGroups.isEmpty
            ? const Text("No groups today")
            : Wrap(
                alignment: WrapAlignment.start,
                children: todayCustomerGroups
                    .map((cg) => SingleCgSlotCard(cg: cg, tourType: tourType))
                    .toList(),
              )
      ],
    );
  }
}

class SingleCgSlotCard extends ConsumerStatefulWidget {
  final CustomerGroup cg;
  final TourType tourType;
  const SingleCgSlotCard({super.key, required this.cg, required this.tourType});

  @override
  ConsumerState<SingleCgSlotCard> createState() => _SingleCgSlotCardState();
}

class _SingleCgSlotCardState extends ConsumerState<SingleCgSlotCard> {
  late BoxBorder hoverDecoration;
  @override
  void initState() {
    super.initState();
    hoverDecoration = BoxBorder.all(color: Colors.transparent, width: 2);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int>? customersNumberByCgId =
        ref.watch(customersNumberByCustomerGroupIdBookingProvider).value;
    if (customersNumberByCgId == null ||
        customersNumberByCgId[widget.cg.id] == null) {
      return const SizedBox.shrink();
    }
    String formattedTime = DateFormat("HH:mm").format(widget.cg.datetime);
    CustomerGroup? selectedCustomerGroup =
        ref.watch(selectedCustomerGroupInCalendarProvider);
    int availableSpots =
        widget.cg.maxCapacity - customersNumberByCgId[widget.cg.id]!;
    bool isFull = customersNumberByCgId[widget.cg.id]! >= widget.cg.maxCapacity;
    bool isSelected = selectedCustomerGroup != null &&
        selectedCustomerGroup.id == widget.cg.id;
    return InkWell(
      onHover: (isHovering) {
        if (isHovering) {
          setState(() {
            hoverDecoration =
                BoxBorder.all(color: BookingPageColors.primary.color, width: 2);
          });
        } else {
          setState(() {
            hoverDecoration =
                BoxBorder.all(color: Colors.transparent, width: 2);
          });
        }
      },
      onTap: isFull
          ? null
          : () {
              ref
                  .read(selectedCustomerGroupInCalendarProvider.notifier)
                  .change(widget.cg);
              ref.invalidate(bookingDetailsSelectedPricingsProvider);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isSelected
                ? BookingPageColors.primaryDark.color.withAlpha(240)
                : null,
            border: isSelected
                ? BoxBorder.all(
                    color: BookingPageColors.primaryDark.color, width: 2)
                : hoverDecoration,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            Text(
              formattedTime,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : isFull
                          ? Colors.grey
                          : null),
            ),
            Text(
              "$availableSpots available",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: isSelected
                      ? Colors.white
                      : isFull
                          ? Colors.grey
                          : Colors.black87),
            )
          ],
        ),
      ),
    );
  }
}

class BookingCalendar extends ConsumerWidget {
  static final logger = BasicLogger();
  const BookingCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<DateTime, List<CustomerGroup>>? customerGroupsByDay =
        ref.watch(customerGroupsByDayProvider).value;
    Map<String, int>? customersNumberByCgId =
        ref.watch(customersNumberByCustomerGroupIdBookingProvider).value;
    return SfCalendar(
      showWeekNumber: true,
      showNavigationArrow: true,
      showDatePickerButton: true,
      selectionDecoration: const BoxDecoration(color: Colors.transparent),
      allowViewNavigation: false,
      initialDisplayDate:
          DateTime(DateTime.now().year, DateTime.now().month, 1),
      view: CalendarView.month,
      firstDayOfWeek: 1,
      monthCellBuilder: (BuildContext cellContext, MonthCellDetails details) {
        List<CustomerGroup> todayCustomerGroups =
            customerGroupsByDay?[details.date] ?? [];
        Color cellColor =
            _getCellColor(todayCustomerGroups, customersNumberByCgId);
        bool isSelected =
            details.date == ref.watch(selectedDateInCalendarProvider);

        return InkWell(
          onTap: todayCustomerGroups.isEmpty
              ? null
              : () {
                  ref
                      .read(selectedDateInCalendarProvider.notifier)
                      .change(details.date);
                  ref
                      .read(selectedCustomerGroupInCalendarProvider.notifier)
                      .change(null);
                  ref.invalidate(bookingDetailsSelectedPricingsProvider);
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            decoration: BoxDecoration(
                border:
                    BoxBorder.all(color: cellColor, width: isSelected ? 2 : 1),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: cellColor.withAlpha(isSelected ? 170 : 100)),
            margin: const EdgeInsets.all(5),
            child: Center(
                child: Text(
              DateFormat("dd").format(details.date),
              style: const TextStyle(fontWeight: FontWeight.w600),
            )),
          ),
        );
      },
      monthViewSettings: const MonthViewSettings(
          showTrailingAndLeadingDates: false,
          dayFormat: "EEE",
          appointmentDisplayCount: 1,
          appointmentDisplayMode: MonthAppointmentDisplayMode.none),
      onViewChanged: (ViewChangedDetails details) {
        if (!(context.mounted)) return;
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          logger.info("Changing dates");
          logger.debug(details.visibleDates);
          ref.read(visibleDatesProvider.notifier).change(details.visibleDates);
        });
      },
    );
  }

  Color _getCellColor(List<CustomerGroup> dayCustomerGroups,
      Map<String, int>? customersNumberByCgId) {
    if (dayCustomerGroups.isEmpty) return Colors.white;
    if (customersNumberByCgId == null) return Colors.white;
    for (final cg in dayCustomerGroups) {
      final n = customersNumberByCgId[cg.id];
      if (n == null) continue;
      if (cg.maxCapacity > n) return BookingPageColors.success.color;
    }
    return BookingPageColors.danger.color;
  }
}

class HeaderWithBubble extends StatelessWidget {
  final String number;
  final String title;
  const HeaderWithBubble(
      {super.key, required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 20),
        BookingPageNumberBubble(content: number),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}

class BookingPageNumberBubble extends StatelessWidget {
  final String content;
  const BookingPageNumberBubble({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: BookingPageColors.primaryDark.color, shape: BoxShape.circle),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Text(content,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
