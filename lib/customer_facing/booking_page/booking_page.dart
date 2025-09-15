import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_facing/booking_page/booking_details.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'calendar/main.dart';

import 'riverpod.dart';

class BookingPage extends ConsumerStatefulWidget {
  final String? account;
  final String? tourId;
  const BookingPage({super.key, required this.tourId, required this.account});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  static final logger = BasicLogger();
  @override
  void initState() {
    super.initState();
    // Initialize global state once with provided params
    if (widget.account != null) {
      ref.read(accountProvider.notifier).change(widget.account!);
    }
    if (widget.tourId != null) {
      ref.read(selectedTourIdProvider.notifier).state = widget.tourId!;
    }
  }

  @override
  void didUpdateWidget(covariant BookingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update providers only if values actually changed
    if (widget.account != null && widget.account != oldWidget.account) {
      ref.read(accountProvider.notifier).change(widget.account!);
    }
    if (widget.tourId != null && widget.tourId != oldWidget.tourId) {
      ref.read(selectedTourIdProvider.notifier).state = widget.tourId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.account == null || widget.tourId == null) {
      return const NoKennelOrTourIdErrorPage();
    }

    /// Info about the tour type that is being booked.
    final tourTypeAsync = ref.watch(
        tourTypeProvider(account: widget.account!, tourId: widget.tourId!));
    DateTime? selectedDate = ref.watch(selectedDateInCalendarProvider);

    return tourTypeAsync.when(
        data: (tourType) {
          if (tourType == null) {
            return const NoKennelOrTourIdErrorPage();
          }

          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  BookingCalendar(tourType: tourType, account: widget.account!),
                  selectedDate == null
                      ? const SizedBox.shrink()
                      : BookingDayDetails(tourType: tourType)
                ],
              ),
            ),
          );
        },
        error: (e, s) {
          logger.error("Error loading tour type for booking page",
              error: e, stackTrace: s);
          return const NoKennelOrTourIdErrorPage();
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}

class BookingDayDetails extends ConsumerWidget {
  final TourType tourType;
  const BookingDayDetails({super.key, required this.tourType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<DateTime, List<CustomerGroup>>? customerGroupsByDay =
        ref.watch(customerGroupsByDayProvider).value;
    Map<String, List<Booking>>? bookingsByCustomerGroupId =
        ref.watch(bookingsByCustomerGroupIdProvider).value;
    Map<String, List<Customer>>? customersByBookingId =
        ref.watch(customersByBookingIdProvider).value;
    Map<String, int>? customersNumberByCgId =
        ref.watch(customersNumberByCustomerGroupIdProvider).value;
    DateTime? selectedDate = ref.watch(selectedDateInCalendarProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: (customerGroupsByDay?[selectedDate!]
              ?.map(
                (cg) => SingleCgSlotCard(cg: cg, tourType: tourType),
              )
              .toList()) ??
          [],
    );
  }
}

class SingleCgSlotCard extends ConsumerWidget {
  final CustomerGroup cg;
  final TourType tourType;
  const SingleCgSlotCard({super.key, required this.cg, required this.tourType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, int>? customersNumberByCgId =
        ref.watch(customersNumberByCustomerGroupIdProvider).value;
    if (customersNumberByCgId == null || customersNumberByCgId[cg.id] == null) {
      return const SizedBox.shrink();
    }
    String formattedTime = DateFormat("hh:mm").format(cg.datetime);
    String occupiedAndTotal =
        "${customersNumberByCgId[cg.id]}/${cg.maxCapacity}";
    bool isFull = customersNumberByCgId[cg.id]! >= cg.maxCapacity;
    return InkWell(
      onTap: isFull
          ? null
          : () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookingDetails(
                      cg: cg,
                      customersNumber: customersNumberByCgId[cg.id]!,
                      tourType: tourType),
                ),
              ),
      child: Card(
        color: isFull ? Colors.grey : Colors.lightGreen[200],
        child: Text("$formattedTime $occupiedAndTotal"),
      ),
    );
  }
}

class NoKennelOrTourIdErrorPage extends StatelessWidget {
  const NoKennelOrTourIdErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Text("Error: kennel or tourId are empty or not valid.")),
    );
  }
}
