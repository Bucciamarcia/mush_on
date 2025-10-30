import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/resellers/home/riverpod.dart';
import 'package:mush_on/resellers/reseller_template.dart';
import 'package:mush_on/services/error_handling.dart';

class BookingDetailsReseller extends ConsumerWidget {
  const BookingDetailsReseller({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCg = ref.watch(selectedCustomerGroupProvider);
    if (selectedCg == null) {
      return const ResellerError(
          message: "There is no selected customer group");
    }
    return ResellerTemplate(
        title: "Booking details",
        child: BookingDetailsResellerMain(cg: selectedCg));
  }
}

class BookingDetailsResellerMain extends ConsumerWidget {
  final CustomerGroup cg;
  const BookingDetailsResellerMain({super.key, required this.cg});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final bookingDataAsync = ref.watch(bookingDetailsDataFetchProvider);
    final accountToResell = ref.watch(accountToResellProvider).value;
    if (cg.tourTypeId == null) {
      return const Text("The customer group has no tour type: can't be resold");
    }
    final tourType = ref.watch(tourTypeByIdProvider(cg.tourTypeId!,
        account: accountToResell?.accountName ?? ""));
    final pricings = ref.watch(TourTypePricesByTourIdProvider(
        tourId: cg.tourTypeId!, account: accountToResell?.accountName ?? ""));
    final List<Customer> customersInBooking;
    if (accountToResell == null) {
      customersInBooking = [];
    } else {
      customersInBooking = ref
              .watch(customersByCustomerGroupIdProvider(cg.id,
                  account: accountToResell.accountName))
              .value ??
          [];
    }
    return bookingDataAsync.when(
        data: (bookingData) {
          if (bookingData.resellerUser == null) {
            logger.error("not logged in");
            return const Text("Not logged in");
          }
          if (bookingData.resellerData == null) {
            logger.error("no reseller data");
            return const Text("No reseller data present");
          }
          if (bookingData.resellerSettings == null) {
            logger.error("no reseller settings");
            return const Text("No reseller settigns present");
          }
          if (bookingData.accountToResell == null) {
            logger.error("no account to resell");
            return const Text("There is no account to resell set");
          }
          return const IntrinsicHeight(
            child: Row(
              spacing: 5,
              children: [
                FirstColumn(),
                VerticalDivider(),
                SecondColumn(),
                VerticalDivider(),
                ThirdColumn(),
              ],
            ),
          );
        },
        error: (e, s) {
          logger.error("Couldn't load data for reseller details",
              error: e, stackTrace: s);
          return ResellerError(
              message:
                  "Couldn't load the data: error occurred - ${e.toString()}");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}

class FirstColumn extends StatelessWidget {
  const FirstColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 300, height: 300, child: const Placeholder());
  }
}

class SecondColumn extends StatelessWidget {
  const SecondColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: const Placeholder());
  }
}

class ThirdColumn extends StatelessWidget {
  const ThirdColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 300, child: const Placeholder());
  }
}
