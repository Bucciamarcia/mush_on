import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              loading: () => const CircularProgressIndicator.adaptive()),
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
    final urlAndAmount = ref.watch(receiptUrlProvider(booking.id)).value;
    return const Placeholder();
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
