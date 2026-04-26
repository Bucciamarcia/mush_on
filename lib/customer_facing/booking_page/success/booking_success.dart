import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:url_launcher/url_launcher.dart';
import 'riverpod.dart';

class BookingSuccessPage extends ConsumerWidget {
  final String? bookingId;
  final String? account;
  static final logger = BasicLogger();
  const BookingSuccessPage({
    super.key,
    required this.bookingId,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bookingId == null || account == null) {
      return const Scaffold(body: SafeArea(child: Text("Error")));
    }
    final bookingDataAsync = ref.watch(
      bookingDataSuccessProvider(account: account!, bookingId: bookingId!),
    );
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: bookingDataAsync.when(
            data: (bookingAndCustomers) {
              final (booking, customers, cg, pricings) = bookingAndCustomers;
              return BookingConfirmationDataPage(
                account: account!,
                booking: booking,
                customers: customers,
                cg: cg,
                pricings: pricings,
              );
            },
            error: (e, s) {
              logger.error("Couldn't load booking", error: e, stackTrace: s);
              return const Text(
                "Error: couldn't load the booking. Contact the kennel.",
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ),
      ),
    );
  }
}

class BookingConfirmationDataPage extends ConsumerWidget {
  final String account;
  final Booking booking;
  final List<Customer> customers;
  final CustomerGroup cg;
  final List<TourTypePricing> pricings;
  const BookingConfirmationDataPage({
    super.key,
    required this.account,
    required this.booking,
    required this.customers,
    required this.cg,
    required this.pricings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: SingleChildScrollView(
        child: Column(
          spacing: 25,
          children: [
            _PaymentStatusHeader(status: booking.paymentStatus),
            TourDetailsBox(booking: booking, customers: customers, cg: cg),
            ParticipantsBox(
              booking: booking,
              customers: customers,
              cg: cg,
              pricings: pricings,
            ),
            if (booking.paymentStatus == PaymentStatus.paid)
              _ReceiptSection(account: account, bookingId: booking.id),
          ],
        ),
      ),
    );
  }
}

class _PaymentStatusHeader extends StatelessWidget {
  final PaymentStatus status;
  const _PaymentStatusHeader({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = _contentFor(status);
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [content.color.withAlpha(45), content.color.withAlpha(10)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: content.color.withAlpha(120),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
              shape: BoxShape.circle,
              color: colorScheme.surface,
            ),
            child: Icon(
              content.icon,
              color: content.color,
              weight: 60,
              size: 80,
            ),
          ),
          Text(
            content.title,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          Text(
            content.subtitle,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          Text(content.body, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  _PaymentStatusContent _contentFor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return const _PaymentStatusContent(
          icon: Icons.check_circle,
          color: Colors.green,
          title: "Booking confirmed!",
          subtitle: "See the details below",
          body: "You will receive a confirmation email shortly.",
        );
      case PaymentStatus.waiting:
        return const _PaymentStatusContent(
          icon: Icons.pending,
          color: Colors.orange,
          title: "Payment processing",
          subtitle: "Your booking is not confirmed yet",
          body:
              "We are waiting for the payment provider to confirm the payment.",
        );
      case PaymentStatus.refunded:
        return const _PaymentStatusContent(
          icon: Icons.undo,
          color: Colors.blueGrey,
          title: "Booking refunded",
          subtitle: "This payment has been refunded",
          body: "Contact the kennel if you have questions about this booking.",
        );
      case PaymentStatus.deferredPayment:
      case PaymentStatus.unknown:
        return const _PaymentStatusContent(
          icon: Icons.info,
          color: Colors.blueGrey,
          title: "Payment not confirmed",
          subtitle: "We could not confirm this payment yet",
          body: "Contact the kennel if this message does not change.",
        );
    }
  }
}

class _PaymentStatusContent {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String body;
  const _PaymentStatusContent({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.body,
  });
}

class _ReceiptSection extends ConsumerWidget {
  final String account;
  final String bookingId;
  const _ReceiptSection({required this.account, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlAndAmount = ref
        .watch(receiptUrlProvider(account: account, bookingId: bookingId))
        .value;
    if (urlAndAmount == null) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator.adaptive(),
          Text(
            "Loading receipt",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      );
    }
    return Row(
      children: [
        Text(
          "Total: ${(urlAndAmount.amount) / 100}€",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        ElevatedButton(
          onPressed: () async => await launchReceiptUrl(urlAndAmount.url),
          child: const Text("View receipt"),
        ),
      ],
    );
  }

  Future<void> launchReceiptUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
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
        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.primaryContainer.withAlpha(150),
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: colorScheme.primary,
                  size: 30,
                ),
              ),
              const Text(
                "Tour Details",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
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
          ),
        ],
      ),
    );
  }
}

class ParticipantsBox extends StatelessWidget {
  final Booking booking;
  final List<Customer> customers;
  final CustomerGroup cg;
  final List<TourTypePricing> pricings;
  const ParticipantsBox({
    super.key,
    required this.booking,
    required this.customers,
    required this.cg,
    required this.pricings,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: colorScheme.primary.withAlpha(50)),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.primaryContainer.withAlpha(150),
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(
                  Icons.perm_identity,
                  color: colorScheme.primary,
                  size: 30,
                ),
              ),
              const Text(
                "Participants",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          ...customers.map((customer) {
            TourTypePricing pricing = pricings.firstWhere(
              (p) => p.id == customer.pricingId,
            );
            return BoxElement(
              iconData: Icons.person,
              title: customer.name,
              content: pricing.displayName,
            );
          }),
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
        Icon(iconData, color: colorScheme.primary, size: 26),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
