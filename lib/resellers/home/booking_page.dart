import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
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
    final tourType = ref
        .watch(tourTypeByIdProvider(cg.tourTypeId!,
            account: accountToResell?.accountName ?? ""))
        .value;
    final pricings = ref
        .watch(TourTypePricesByTourIdProvider(
            tourId: cg.tourTypeId!,
            account: accountToResell?.accountName ?? ""))
        .value;

    /// List of sposts that have been selected for this specific booking.
    final bookedSpots = ref.watch(BookedSpotsProvider(pricings ?? []));
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
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              FirstColumn(
                  cg: cg,
                  tourType: tourType,
                  pricings: pricings,
                  customers: customersInBooking,
                  bookedSpots: bookedSpots),
              SecondColumn(),
              ThirdColumn(),
            ],
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
  final CustomerGroup cg;
  final TourType? tourType;
  final List<TourTypePricing>? pricings;
  final List<Customer> customers;

  /// List of sposts that have been selected for this specific booking.
  final List<BookedSpot> bookedSpots;
  const FirstColumn(
      {super.key,
      required this.cg,
      required this.tourType,
      required this.pricings,
      required this.customers,
      required this.bookedSpots});

  @override
  Widget build(BuildContext context) {
    if (tourType == null || pricings == null) {
      const CircularProgressIndicator.adaptive();
    }
    final spotsAvailable = cg.maxCapacity - customers.length;
    final listSpotsAvailable = List.generate(spotsAvailable, (i) => (i + 1));
    return SizedBox(
        width: 200,
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tourType!.displayName,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            ...pricings!.map((p) => SinglePricingRow(
                pricing: p,
                listSpotsAvailable: listSpotsAvailable,
                prices: pricings!)),
          ],
        ));
  }
}

class SinglePricingRow extends ConsumerWidget {
  final TourTypePricing pricing;
  final List<TourTypePricing> prices;
  final List<int> listSpotsAvailable;
  const SinglePricingRow(
      {super.key,
      required this.pricing,
      required this.listSpotsAvailable,
      required this.prices});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(pricing.displayName, overflow: TextOverflow.fade),
            Text(
              "${(pricing.priceCents / 100).toString()}€",
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          ],
        ),
        DropdownMenu(
            onSelected: (v) {
              if (v != null) {
                ref
                    .read(bookedSpotsProvider(prices).notifier)
                    .changeOne(pricing, v);
              }
            },
            dropdownMenuEntries: listSpotsAvailable
                .map((n) => DropdownMenuEntry(value: n, label: n.toString()))
                .toList())
      ],
    );
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
