import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:uuid/uuid.dart';
import 'booking_page.dart';

class CollectInfoPage extends StatelessWidget {
  final TourType tourType;
  final List<BookingPricingNumberBooked> selectedPricings;
  const CollectInfoPage(
      {super.key, required this.tourType, required this.selectedPricings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final String bookingId = const Uuid().v4();
      return Center(
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
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  const BookingPageHeader(),
                  BookingPageTopOverview(
                    tourType: tourType,
                  ),
                  const Divider(),
                  w >= 768
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CollectInfoWidget(
                                    selectedPricings: selectedPricings,
                                    bookingId: bookingId),
                                BookingSummaryImmobile(tourType: tourType)
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CollectInfoWidget(
                                    selectedPricings: selectedPricings,
                                    bookingId: bookingId),
                                BookingSummaryImmobile(tourType: tourType)
                              ],
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      );
    })));
  }
}

class CollectInfoWidget extends ConsumerWidget {
  final List<BookingPricingNumberBooked> selectedPricings;
  final String bookingId;
  const CollectInfoWidget(
      {super.key, required this.selectedPricings, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// A list of tour type pricings, one for each customers, so that they can fill the info.
    List<Customer> customerPricings = ref.watch(customersInfoProvider);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(customersInfoProvider.notifier)
          .changeAll(_getCustomerPricings());
    });
    return Column(children: [
      const BookingInfoCard(),
      ...customerPricings.map((cp) => CustomerFormCard(
          customer: cp,
          onChanged: (nc) =>
              ref.read(customersInfoProvider.notifier).changeSingle(nc.id, nc)))
    ]);
  }

  List<Customer> _getCustomerPricings() {
    final toReturn = <Customer>[];

    for (final p in selectedPricings) {
      for (var i = 0; i < p.numberBooked; i++) {
        toReturn.add(Customer(
          id: const Uuid().v4(),
          bookingId: bookingId,
        ));
      }
    }

    return toReturn;
  }
}

class BookingInfoCard extends ConsumerWidget {
  const BookingInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Booking? bookingInfo = ref.watch(bookingInfoProvider);
    return const Placeholder();
  }
}

class CustomerFormCard extends StatefulWidget {
  final Function(Customer) onChanged;
  final Customer customer;
  const CustomerFormCard(
      {super.key, required this.customer, required this.onChanged});

  @override
  State<CustomerFormCard> createState() => _CustomerFormCardState();
}

class _CustomerFormCardState extends State<CustomerFormCard> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _ageController =
        TextEditingController(text: widget.customer.age?.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class BookingSummaryImmobile extends ConsumerWidget {
  final TourType tourType;
  const BookingSummaryImmobile({super.key, required this.tourType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime? selectedDate = ref.watch(selectedDateInCalendarProvider);
    String formatSelectedDate() {
      if (selectedDate == null) return "No date selected";
      return DateFormat("MMMM dd, yyyy").format(selectedDate);
    }

    CustomerGroup? selectedCustomerGroup =
        ref.watch(selectedCustomerGroupInCalendarProvider);
    String formatTimeOfSelectedCg() {
      if (selectedCustomerGroup == null) return "No time selected";
      return DateFormat("HH:mm").format(selectedCustomerGroup.datetime);
    }

    final account = ref.watch(accountProvider);
    late final List<TourTypePricing> pricings;
    if (account == null) {
      pricings = [];
    } else {
      pricings = ref
              .watch(tourTypePricesByTourIdProvider(
                  tourId: tourType.id, account: account))
              .value ??
          [];
    }
    final selectedPricings =
        ref.watch(bookingDetailsSelectedPricingsProvider(pricings));
    Map<String, int>? customersNumberByCgId =
        ref.watch(customersNumberByCustomerGroupIdProvider).value;
    int? maxCapacity = selectedCustomerGroup?.maxCapacity;
    int? customersBooked = customersNumberByCgId?[selectedCustomerGroup?.id];
    late final int availableSpots;
    if (maxCapacity == null || customersBooked == null) {
      availableSpots = 0;
    } else {
      availableSpots = maxCapacity - customersBooked;
    }
    int totalBooked() {
      int toReturn = 0;
      for (final sp in selectedPricings) {
        toReturn += sp.numberBooked;
      }
      return toReturn;
    }

    bool maxBookingsSelected = totalBooked() >= availableSpots;
    double total() {
      double toReturn = 0;
      for (final sp in selectedPricings) {
        TourTypePricing pricing =
            pricings.firstWhere((p) => p.id == sp.tourTypePricingId);
        toReturn += (pricing.priceCents.toDouble() / 100) * sp.numberBooked;
      }
      return toReturn;
    }

    double grandTotalToPay = total();

    bool isActive() {
      return true;
    }

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 25,
        children: [
          const Text(
            "Booking Summary",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BookingSummaryTitleText(text: "Tour Type"),
              BookingSummaryValueText(text: tourType.displayName)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BookingSummaryTitleText(text: "Date"),
              BookingSummaryValueText(text: formatSelectedDate())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BookingSummaryTitleText(text: "Time"),
              BookingSummaryValueText(text: formatTimeOfSelectedCg()),
            ],
          ),
          ...pricings.map((pricing) => PricingOptionCounterImmobile(
                pricing: pricing,
                available: availableSpots,
                pricings: pricings,
                maxBookingsSelected: maxBookingsSelected,
              )),
          ...pricings.map((pricing) => PricingOptionTotalPrice(
                bookingInfo: selectedPricings
                    .firstWhere((sp) => sp.tourTypePricingId == pricing.id),
                pricing: pricing,
              )),
          GrandTotalSummaryRow(
              selectedPricings: selectedPricings,
              pricings: pricings,
              grandTotalToPay: grandTotalToPay),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.grey),
                        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                            vertical: 20, horizontal: 30))),
                    child: const Text(
                      "Go back",
                      style: TextStyle(color: Colors.black),
                    )),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: ElevatedButton(
                      key: ValueKey(isActive()),
                      onPressed: isActive()
                          ? () async {
                              BasicLogger().info("TODO: go to stripe");
                              // Simulate stripe call
                              await Future.delayed(const Duration(seconds: 2));
                              BasicLogger().info("DONE!");
                            }
                          : null,
                      style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30)),
                          backgroundColor: WidgetStatePropertyAll(isActive()
                              ? BookingPageColors.primaryDark.color
                              : Colors.grey)),
                      child: const Text(
                        "Book now",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          ),
          const SafetyIconsWrap(),
        ],
      ),
    );
  }
}

class PricingOptionCounterImmobile extends ConsumerWidget {
  final List<TourTypePricing> pricings;
  final TourTypePricing pricing;
  final int available;
  final bool maxBookingsSelected;
  const PricingOptionCounterImmobile(
      {super.key,
      required this.pricing,
      required this.available,
      required this.pricings,
      required this.maxBookingsSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? account = ref.watch(accountProvider);
    if (account == null) return const SizedBox.shrink();
    final selectedPricings =
        ref.watch(bookingDetailsSelectedPricingsProvider(pricings));
    final selectedPricing =
        selectedPricings.firstWhere((sp) => sp.tourTypePricingId == pricing.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  pricing.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            SizedBox(
              width: 100,
              child: Text(pricing.displayDescription ?? "",
                  style: const TextStyle(fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            )
          ],
        ),
        Text(selectedPricing.numberBooked.toString()),
      ],
    );
  }
}
