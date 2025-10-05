import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:url_launcher/url_launcher.dart';
import 'riverpod.dart';

class BookingSuccessPage extends ConsumerWidget {
  final String? bookingId;
  final String? account;
  static final logger = BasicLogger();
  const BookingSuccessPage(
      {super.key, required this.bookingId, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bookingId == null || account == null) {
      return const Scaffold(body: SafeArea(child: Text("Error")));
    }
    final bookingDataAsync = ref.watch(
        bookingDataSuccessProvider(account: account!, bookingId: bookingId!));
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: bookingDataAsync.when(
              data: (bookingAndCustomers) {
                final (booking, customers, cg) = bookingAndCustomers;
                return BookingConfirmationDataPage(
                    booking: booking, customers: customers, cg: cg);
              },
              error: (e, s) {
                logger.error("Couldn't load booking", error: e, stackTrace: s);
                return const Text(
                    "Error: couldn't load the booking. Contact the kennel.");
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive())),
        ),
      ),
    );
  }
}

class BookingConfirmationDataPage extends ConsumerWidget {
  final Booking booking;
  final List<Customer> customers;
  final CustomerGroup cg;
  const BookingConfirmationDataPage({
    super.key,
    required this.booking,
    required this.customers,
    required this.cg,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final urlAndAmount = ref.watch(receiptUrlProvider(booking.id)).value;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: SingleChildScrollView(
        child: Column(
          spacing: 25,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.primaryContainer.withAlpha(20),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: colorScheme.primary.withAlpha(150),
                          blurRadius: 15,
                          spreadRadius: 3)
                    ], shape: BoxShape.circle, color: Colors.white),
                    child: Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      weight: 60,
                      size: 80,
                    ),
                  ),
                  const Text(
                    "Booking confirmed!",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "See the details below",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            TourDetailsBox(booking: booking, customers: customers, cg: cg),
            ParticipantsBox(booking: booking, customers: customers, cg: cg),
          ],
        ),
      ),
    );
  }

  Future<void> launchReceiptUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not launch $url");
    }
  }
}

class TourDetailsBox extends StatelessWidget {
  final Booking booking;
  final List<Customer> customers;
  final CustomerGroup cg;
  const TourDetailsBox({
    super.key,
    required this.booking,
    required this.customers,
    required this.cg,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: colorScheme.primary.withAlpha(50)),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 20,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      colorScheme.primaryContainer,
                      colorScheme.primaryContainer.withAlpha(150)
                    ]),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Icon(
                  Icons.calendar_today,
                  color: colorScheme.primary,
                  size: 30,
                ),
              ),
              const Text(
                "Tour Details",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              )
            ],
          ),
          BoxElement(
            iconData: Icons.calendar_month,
            title: "Date",
            content: DateFormat("dd-MM-yyyy").format(cg.datetime),
          ),
          BoxElement(
            iconData: Icons.punch_clock,
            title: "Time",
            content: DateFormat("hh:mm").format(cg.datetime),
          )
        ],
      ),
    );
  }
}

class ParticipantsBox extends StatelessWidget {
  final Booking booking;
  final List<Customer> customers;
  final CustomerGroup cg;
  const ParticipantsBox({
    super.key,
    required this.booking,
    required this.customers,
    required this.cg,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: colorScheme.primary.withAlpha(50)),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 20,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      colorScheme.primaryContainer,
                      colorScheme.primaryContainer.withAlpha(150)
                    ]),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Icon(
                  Icons.calendar_today,
                  color: colorScheme.primary,
                  size: 30,
                ),
              ),
              const Text(
                "Tour Details",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              )
            ],
          ),
          BoxElement(
            iconData: Icons.calendar_month,
            title: "Date",
            content: DateFormat("dd-MM-yyyy").format(cg.datetime),
          ),
          BoxElement(
            iconData: Icons.punch_clock,
            title: "Time",
            content: DateFormat("hh:mm").format(cg.datetime),
          )
        ],
      ),
    );
  }
}

class BoxElement extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String content;
  const BoxElement({
    super.key,
    required this.iconData,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      spacing: 20,
      children: [
        Icon(
          iconData,
          color: colorScheme.primary,
          size: 26,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            )
          ],
        )
      ],
    );
  }
}
