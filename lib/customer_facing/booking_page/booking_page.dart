import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(accountProvider.notifier).change(widget.account!);
      ref.read(selectedTourIdProvider.notifier).change(widget.tourId!);
    });
  }

  @override
  void didUpdateWidget(covariant BookingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.account != widget.account ||
        oldWidget.tourId != widget.tourId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(accountProvider.notifier).change(widget.account!);
        ref.read(selectedTourIdProvider.notifier).change(widget.tourId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.account == null || widget.tourId == null) {
      return const NoKennelOrTourIdErrorPage();
    }

    /// Info about the tour type that is being booked.
    final tourTypeAsync = ref.watch(tourTypeProvider(
        account: widget.account!,
        tourId: ref.watch(selectedTourIdProvider) ?? ""));
    DateTime? selectedDate = ref.watch(selectedDateInCalendarProvider);
    String formatSelectedDate() {
      if (selectedDate == null) return "No date selected";
      return DateFormat("EEEE MMMM, yyyy").format(selectedDate);
    }

    CustomerGroup? selectedCustomerGroup =
        ref.watch(selectedCustomerGroupInCalendarProvider);
    String formatTimeOfSelectedCg() {
      if (selectedCustomerGroup == null) return "No time selected";
      return DateFormat("hh:mm a").format(selectedCustomerGroup.datetime);
    }

    return tourTypeAsync.when(
        data: (tourType) {
          if (tourType == null) {
            return const NoKennelOrTourIdErrorPage();
          }
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    BookingPageColors.mainBlue.color,
                    BookingPageColors.mainPurple.color
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      constraints: const BoxConstraints(maxWidth: 1440),
                      child: Column(
                        children: [
                          const BookingPageHeader(),
                          BookingPageTopOverview(
                            tourType: tourType,
                          ),
                          const Divider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: BookingTimeAndDate(
                                      tourType: tourType,
                                      account: widget.account!),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                width: 250,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 25,
                                  children: [
                                    const Text("Booking Summary",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const BookingSummaryTitleText(
                                            text: "Tour Type"),
                                        BookingSummaryValueText(
                                            text: tourType.displayName)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const BookingSummaryTitleText(
                                            text: "Date"),
                                        BookingSummaryValueText(
                                            text: formatSelectedDate())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const BookingSummaryTitleText(
                                            text: "Time"),
                                        BookingSummaryValueText(
                                            text: formatTimeOfSelectedCg()),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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

class BookingSummaryTitleText extends StatelessWidget {
  final String text;
  const BookingSummaryTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54),
    );
  }
}

class BookingSummaryValueText extends StatelessWidget {
  final String text;
  const BookingSummaryValueText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.clip),
    );
  }
}

class BookingPageTopOverview extends StatelessWidget {
  final TourType tourType;
  const BookingPageTopOverview({
    super.key,
    required this.tourType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
              child: Text(
                tourType.displayName,
                style: TextStyle(
                    color: BookingPageColors.primaryDark.color,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 20),
          FaIcon(
            FontAwesomeIcons.stopwatch,
            size: 18,
            color: BookingPageColors.primary.color.withAlpha(200),
          ),
          const SizedBox(width: 10),
          Text("${tourType.duration} minutes")
        ],
      ),
    );
  }
}

class BookingPageHeader extends StatelessWidget {
  const BookingPageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))
          ],
          gradient: LinearGradient(colors: [
            BookingPageColors.mainBlue.color,
            BookingPageColors.mainPurple.color
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: BoxBorder.all(color: BookingPageColors.mainBlue.color),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Text(
                "Book your adventure",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Select the date and time of your tour",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
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

enum BookingPageColors {
  success(color: Color(0xff10b091)),
  warning(color: Color(0xfff59e0b)),
  danger(color: Color(0xffef4444)),
  primary(color: Color(0xff2563eb)),
  primaryDark(color: Color(0xff1e40af)),
  primaryLight(color: Color(0xffdbeafe)),
  mainBlue(color: Color(0xff667eea)),
  mainPurple(color: Color(0xff764ba2));

  final Color color;

  const BookingPageColors({required this.color});
}
