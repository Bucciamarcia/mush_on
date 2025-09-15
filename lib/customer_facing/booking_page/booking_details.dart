import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';

class BookingDetails extends ConsumerWidget {
  final CustomerGroup cg;
  final int customersNumber;
  final TourType tourType;
  const BookingDetails(
      {super.key,
      required this.cg,
      required this.tourType,
      required this.customersNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int placesLeft = cg.maxCapacity - customersNumber;
    final List<int> placesList = List.generate(placesLeft + 1, (i) => i);
    List<DropdownMenuEntry<int>> menuEntries = placesList
        .map((n) => DropdownMenuEntry<int>(value: n, label: n.toString()))
        .toList();
    String account = ref.watch(accountProvider)!;
    List<TourTypePricing>? pricings = ref
        .watch(tourTypePricesByTourIdProvider(
            tourId: tourType.id, account: account))
        .value;
    if (pricings == null) return const CircularProgressIndicator.adaptive();
    final selectedPricings =
        ref.watch(bookingDetailsSelectedPricingsProvider(pricings));
    final notifier =
        ref.watch(bookingDetailsSelectedPricingsProvider(pricings).notifier);
    return Column(
      children: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Go back")),
        ...pricings.map((pricing) => PricingTierCard(
            pricing: pricing,
            menuEntries: menuEntries,
            onChanged: (s) => notifier.editSinglePricing(pricing.id, s))),
        ElevatedButton(
            onPressed: () {
              BasicLogger().info(
                  "This will load the Stripe page for payment and add the booking to the db");
              BasicLogger().debug(selectedPricings);
            },
            child: const Text("Book now"))
      ],
    );
  }
}

class PricingTierCard extends StatelessWidget {
  final TourTypePricing pricing;
  final List<DropdownMenuEntry<int>> menuEntries;
  final Function(int) onChanged;
  const PricingTierCard(
      {super.key,
      required this.pricing,
      required this.menuEntries,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Column(
            children: [
              Text(pricing.displayName),
              Text(pricing.displayDescription ?? ""),
            ],
          ),
          DropdownMenu<int>(
              onSelected: (s) {
                if (s != null) {
                  onChanged(s);
                }
              },
              initialSelection: 0,
              dropdownMenuEntries: menuEntries)
        ],
      ),
    );
  }
}
