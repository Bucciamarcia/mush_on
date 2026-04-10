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
import 'package:timezone/timezone.dart' as tz;

class BookingTimeAndDate extends StatelessWidget {
  final TourType tourType;
  final String account;
  static final logger = BasicLogger();
  const BookingTimeAndDate({
    super.key,
    required this.tourType,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BookingSectionCard(
          stepNumber: "1",
          title: "Select date",
          subtitle: "Choose the day that works best for your guests.",
          child: BookingCalendar(),
        ),
        const SizedBox(height: 18),
        BookingSectionCard(
          stepNumber: "2",
          title: "Choose time",
          subtitle: "Available departures update based on the selected day.",
          child: TimeSelectorByDate(tourType: tourType),
        ),
      ],
    );
  }
}

class TimeSelectorByDate extends ConsumerWidget {
  final TourType tourType;
  const TimeSelectorByDate({super.key, required this.tourType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroupsByDay = ref.watch(customerGroupsByDayProvider).value;
    final selectedDate = ref.watch(selectedDateInCalendarProvider);
    if (selectedDate == null) {
      return const _BookingHintState(
        icon: Icons.calendar_today_outlined,
        text: "Select a date to see available departures.",
      );
    }

    final todayCustomerGroups =
        customerGroupsByDay?[bookingDayKey(selectedDate)];
    if (todayCustomerGroups == null || todayCustomerGroups.isEmpty) {
      return const _BookingHintState(
        icon: Icons.event_busy_outlined,
        text: "No groups available for this date.",
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: todayCustomerGroups
          .map((cg) => SingleCgSlotCard(cg: cg, tourType: tourType))
          .toList(),
    );
  }
}

class SingleCgSlotCard extends ConsumerWidget {
  final CustomerGroup cg;
  final TourType tourType;
  const SingleCgSlotCard({super.key, required this.cg, required this.tourType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersNumberByCgId = ref
        .watch(customersNumberByCustomerGroupIdBookingProvider)
        .value;
    if (customersNumberByCgId == null || customersNumberByCgId[cg.id] == null) {
      return const SizedBox.shrink();
    }

    final timezoneStr = ref.watch(kennelTimezoneProvider);
    final location = tz.getLocation(timezoneStr);
    final kennelDt = tz.TZDateTime.fromMillisecondsSinceEpoch(
      location,
      cg.datetime.millisecondsSinceEpoch,
    );
    final formattedTime = DateFormat("HH:mm").format(kennelDt);
    final selectedCustomerGroup = ref.watch(
      selectedCustomerGroupInCalendarProvider,
    );
    final availableSpots = cg.maxCapacity - customersNumberByCgId[cg.id]!;
    final isFull = customersNumberByCgId[cg.id]! >= cg.maxCapacity;
    final isSelected =
        selectedCustomerGroup != null && selectedCustomerGroup.id == cg.id;

    final backgroundColor = isSelected
        ? BookingPageColors.primaryDark.color
        : BookingPageColors.surfaceStrong.color;
    final foregroundColor = isSelected
        ? Colors.white
        : BookingPageColors.textStrong.color;

    return InkWell(
      onTap: isFull
          ? null
          : () {
              ref
                  .read(selectedCustomerGroupInCalendarProvider.notifier)
                  .change(cg);
              ref.invalidate(bookingDetailsSelectedPricingsProvider);
            },
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isFull ? BookingPageColors.outlineSoft.color : backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? BookingPageColors.primaryDark.color
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedTime,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isFull
                    ? BookingPageColors.textMuted.color
                    : foregroundColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFull ? "Fully booked" : "$availableSpots spots left",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isFull
                    ? BookingPageColors.textMuted.color
                    : foregroundColor.withValues(alpha: 0.82),
              ),
            ),
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
    final customerGroupsByDay = ref.watch(customerGroupsByDayProvider).value;
    final customersNumberByCgId = ref
        .watch(customersNumberByCustomerGroupIdBookingProvider)
        .value;
    final visibleDates = ref.watch(visibleDatesProvider);
    final noDatesAvailableThisMonth =
        customerGroupsByDay != null &&
        visibleDates.isNotEmpty &&
        visibleDates.every(
          (date) => (customerGroupsByDay[bookingDayKey(date)] ?? []).isEmpty,
        );

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(
          context,
        ).colorScheme.copyWith(primary: BookingPageColors.primaryDark.color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: BookingPageColors.surface.color,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: BookingPageColors.outlineSoft.color),
            ),
            padding: const EdgeInsets.all(8),
            child: SfCalendar(
              backgroundColor: Colors.transparent,
              headerStyle: CalendarHeaderStyle(
                textAlign: TextAlign.center,
                backgroundColor: Colors.transparent,
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: BookingPageColors.textStrong.color,
                ),
              ),
              viewHeaderStyle: ViewHeaderStyle(
                dayTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: BookingPageColors.textMuted.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              todayHighlightColor: BookingPageColors.primaryDark.color,
              showNavigationArrow: true,
              showDatePickerButton: true,
              selectionDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              allowViewNavigation: false,
              initialDisplayDate: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                1,
              ),
              view: CalendarView.month,
              firstDayOfWeek: 1,
              monthCellBuilder:
                  (BuildContext cellContext, MonthCellDetails details) {
                    final cellDate = bookingDayKey(details.date);
                    final todayCustomerGroups =
                        customerGroupsByDay?[cellDate] ?? [];
                    final availability = _getAvailability(
                      todayCustomerGroups,
                      customersNumberByCgId,
                    );
                    final isSelected =
                        cellDate == ref.watch(selectedDateInCalendarProvider);
                    final isEnabled = todayCustomerGroups.isNotEmpty;

                    final fillColor = switch (availability) {
                      _BookingDayAvailability.available =>
                        BookingPageColors.primaryLight.color,
                      _BookingDayAvailability.full =>
                        BookingPageColors.outlineSoft.color,
                      _BookingDayAvailability.empty => Colors.transparent,
                    };

                    final dotColor = switch (availability) {
                      _BookingDayAvailability.available =>
                        BookingPageColors.success.color,
                      _BookingDayAvailability.full =>
                        BookingPageColors.danger.color,
                      _BookingDayAvailability.empty => Colors.transparent,
                    };

                    return InkWell(
                      onTap: !isEnabled
                          ? null
                          : () {
                              ref
                                  .read(selectedDateInCalendarProvider.notifier)
                                  .change(cellDate);
                              ref
                                  .read(
                                    selectedCustomerGroupInCalendarProvider
                                        .notifier,
                                  )
                                  .change(null);
                              ref.invalidate(
                                bookingDetailsSelectedPricingsProvider,
                              );
                            },
                      borderRadius: BorderRadius.circular(18),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? BookingPageColors.primaryDark.color
                              : fillColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? BookingPageColors.primaryDark.color
                                : BookingPageColors.outlineSoft.color,
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final showDot = constraints.maxHeight >= 34;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat("d").format(cellDate),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : isEnabled
                                        ? BookingPageColors.textStrong.color
                                        : BookingPageColors.textMuted.color,
                                  ),
                                ),
                                if (showDot) ...[
                                  const SizedBox(height: 2),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : dotColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
              monthViewSettings: const MonthViewSettings(
                showTrailingAndLeadingDates: false,
                dayFormat: "EEE",
                appointmentDisplayCount: 1,
                appointmentDisplayMode: MonthAppointmentDisplayMode.none,
              ),
              onViewChanged: (ViewChangedDetails details) {
                if (!context.mounted) return;
                SchedulerBinding.instance.addPostFrameCallback((_) async {
                  logger.info("Changing dates");
                  logger.debug(details.visibleDates);
                  ref
                      .read(visibleDatesProvider.notifier)
                      .change(details.visibleDates);
                });
              },
            ),
          ),
          if (noDatesAvailableThisMonth) ...[
            const SizedBox(height: 14),
            const _BookingHintState(
              icon: Icons.event_busy_outlined,
              text: "No dates available this month.",
            ),
          ],
        ],
      ),
    );
  }

  _BookingDayAvailability _getAvailability(
    List<CustomerGroup> dayCustomerGroups,
    Map<String, int>? customersNumberByCgId,
  ) {
    if (dayCustomerGroups.isEmpty || customersNumberByCgId == null) {
      return _BookingDayAvailability.empty;
    }
    for (final cg in dayCustomerGroups) {
      final n = customersNumberByCgId[cg.id];
      if (n == null) continue;
      if (cg.maxCapacity > n) return _BookingDayAvailability.available;
    }
    return _BookingDayAvailability.full;
  }
}

enum _BookingDayAvailability { empty, available, full }

class BookingSectionCard extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String subtitle;
  final Widget child;
  const BookingSectionCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BookingFlowFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWithBubble(
            number: stepNumber,
            title: title,
            subtitle: subtitle,
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class HeaderWithBubble extends StatelessWidget {
  final String number;
  final String title;
  final String? subtitle;
  const HeaderWithBubble({
    super.key,
    required this.number,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingPageNumberBubble(content: number),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: BookingPageColors.textStrong.color,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: BookingPageColors.textMuted.color,
                    height: 1.45,
                  ),
                ),
              ],
            ],
          ),
        ),
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
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: BookingPageColors.primaryDark.color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _BookingHintState extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BookingHintState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BookingPageColors.surfaceStrong.color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon, color: BookingPageColors.primaryDark.color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: BookingPageColors.textMuted.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
