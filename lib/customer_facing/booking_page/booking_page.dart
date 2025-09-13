import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Widget build(BuildContext context) {
    if (widget.account == null || widget.tourId == null) {
      return const NoKennelOrTourIdErrorPage();
    }

    /// Info about the tour type that is being booked.
    final tourTypeAsync = ref.watch(
        tourTypeProvider(account: widget.account!, tourId: widget.tourId!));
    final selectedDate = ref.watch(selectedDateInCalendarProvider);

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
                  ref
                          .watch(BookingWidgetProvider(
                              selectedDate, widget.account!))
                          .value ??
                      const CircularProgressIndicator.adaptive()
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
