import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/resellers/home/riverpod.dart';
import 'package:mush_on/resellers/repository.dart';
import 'package:mush_on/resellers/reseller_template.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';

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
              const Expanded(child: SecondColumn()),
              ThirdColumn(
                  cg: cg,
                  pricings: pricings ?? [],
                  bookingData: bookingData,
                  customers: customersInBooking),
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
    final listSpotsAvailable = List.generate(spotsAvailable + 1, (i) => (i));
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
            initialSelection: listSpotsAvailable.first,
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

class SecondColumn extends ConsumerWidget {
  const SecondColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: TextField(
            maxLines: 1,
            decoration: const InputDecoration(label: Text("Name on booking")),
            onChanged: (v) {
              ref.read(nameOnBookingProvider.notifier).change(v);
            },
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: TextField(
            maxLines: 5,
            decoration: const InputDecoration(label: Text("Other notes")),
            onChanged: (v) {
              ref.read(otherNotesProvider.notifier).change(v);
            },
          ),
        )
      ],
    );
  }
}

class ThirdColumn extends ConsumerWidget {
  final CustomerGroup cg;
  final List<TourTypePricing> pricings;
  final BookingDetailsDataFetch bookingData;
  final List<Customer> customers;
  const ThirdColumn(
      {super.key,
      required this.cg,
      required this.pricings,
      required this.customers,
      required this.bookingData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookedSpots = ref.watch(bookedSpotsProvider(pricings));
    final payNowPreference = ref.watch(payNowPreferenceProvider);
    final logger = BasicLogger();
    return SizedBox(
      width: 200,
      child: Column(
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total price:"),
              Text("${_calculateTotalPrice(bookedSpots)}€")
            ],
          ),
          const Text(
              "Price includes VAT. It will be removed on the invoice based on your state preferences"),
          Tooltip(
            message: _canPayLater()
                ? "Check to pay now, uncheck to pay later"
                : "This tour must be paid at the time of booking",
            child: CheckboxListTile(
                value: payNowPreference,
                title: const Text("Pay now"),
                enabled: _canPayLater(),
                onChanged: (v) {
                  if (v != null) {
                    ref.read(payNowPreferenceProvider.notifier).change(v);
                  }
                }),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary)),
            onPressed: () async {
              if (payNowPreference) {
                try {
                  final kennelInfo = await ref.watch(
                      bookingManagerKennelInfoProvider(
                              account: bookingData.accountToResell!.accountName)
                          .future);
                  if (kennelInfo == null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(
                          context, "Error: couldn't get kennel info"));
                      return;
                    } else {
                      return;
                    }
                  }
                  await ResellerRepository().getStripeUrlReseller(
                      bookedSpots: bookedSpots,
                      account: bookingData.accountToResell!.accountName,
                      kennelInfo: kennelInfo,
                      pricings: pricings,
                      customerGroup: cg,
                      resellerName:
                          bookingData.resellerData!.businessInfo.legalName,
                      existingCustomers: customers);
                  logger.info("Booking confirmed");
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        confirmationSnackbar(context, "Booking confirmed"));
                  }
                } on GroupAlreadyFullException catch (e, s) {
                  logger.error("The group is already full!",
                      error: e, stackTrace: s);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(errorSnackBar(context, e.toString()));
                  }
                } catch (e, s) {
                  logger.error("Error while making reseller booking",
                      error: e, stackTrace: s);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar(context, "Couldn't book this tour"));
                  }
                }
              }
            },
            child: Text("Confirm booking",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
          )
        ],
      ),
    );
  }

  /// Calculates whether the reseller is allows to pay late.
  bool _canPayLater() {
    if (!bookingData.resellerSettings!.allowedDelayedPayment) return false;
    int maxDelay = bookingData.resellerSettings!.paymentDelayDays;
    DateTime cgDatetime = cg.datetime;
    final distanceToTour = cgDatetime.difference(DateTime.now());
    if (distanceToTour.inDays <= maxDelay) return false;
    return true;
  }

  double _calculateTotalPrice(List<BookedSpot> booked) {
    double toReturn = 0;
    for (final b in booked) {
      toReturn = toReturn + b.pricing.priceCents.toDouble() * b.number;
    }
    return toReturn / 100;
  }
}
