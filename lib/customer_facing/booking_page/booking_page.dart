import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Widget build(BuildContext context) {
    if (widget.account == null || widget.tourId == null) {
      return const NoKennelOrTourIdErrorPage();
    }
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(accountProvider.notifier).change(widget.account!);
      ref.read(selectedTourIdProvider.notifier).change(widget.tourId!);
    });

    /// Info about the tour type that is being booked.
    final tourTypeAsync = ref.watch(tourTypeProvider(
        account: widget.account!,
        tourId: ref.watch(selectedTourIdProvider) ?? ""));
    DateTime? selectedDate = ref.watch(selectedDateInCalendarProvider);

    return tourTypeAsync.when(
        data: (tourType) {
          if (tourType == null) {
            return const NoKennelOrTourIdErrorPage();
          }
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    BookingPageColors.mainBlue.color,
                    BookingPageColors.mainPurple.color
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
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
                        const BookingPageSelectDateHeaderRow(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                BookingCalendar(
                                    tourType: tourType,
                                    account: widget.account!),
                                selectedDate == null
                                    ? const SizedBox.shrink()
                                    : BookingDayDetails(tourType: tourType)
                              ],
                            ),
                          ),
                        ),
                      ],
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

class BookingPageSelectDateHeaderRow extends StatelessWidget {
  const BookingPageSelectDateHeaderRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        BookingPageNumberBubble(content: "1"),
        SizedBox(width: 10),
        Text(
          "Select date",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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

class BookingDayDetails extends ConsumerWidget {
  final TourType tourType;
  const BookingDayDetails({super.key, required this.tourType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<DateTime, List<CustomerGroup>>? customerGroupsByDay =
        ref.watch(customerGroupsByDayProvider).value;
    DateTime? selectedDate = ref.watch(selectedDateInCalendarProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: (customerGroupsByDay?[selectedDate]
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
    String formattedTime = DateFormat("HH:mm").format(cg.datetime);
    String occupiedAndTotal =
        "${customersNumberByCgId[cg.id]}/${cg.maxCapacity}";
    bool isFull = customersNumberByCgId[cg.id]! >= cg.maxCapacity;
    return InkWell(
      onTap: () => isFull
          ? null
          : Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BookingDetails(
                  cg: cg,
                  customersNumber: customersNumberByCgId[cg.id]!,
                  tourType: tourType))),
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
