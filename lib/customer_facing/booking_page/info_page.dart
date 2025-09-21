import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:sealed_countries/sealed_countries.dart';
import 'package:uuid/uuid.dart';
import 'booking_page.dart';

class CollectInfoPage extends StatelessWidget {
  final TourType tourType;
  final List<BookingPricingNumberBooked> selectedPricings;
  final List<TourTypePricing> pricings;
  const CollectInfoPage(
      {super.key,
      required this.tourType,
      required this.selectedPricings,
      required this.pricings});

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
                                Expanded(
                                  child: CollectInfoWidget(
                                      selectedPricings: selectedPricings,
                                      pricings: pricings,
                                      bookingId: bookingId),
                                ),
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
                                    pricings: pricings,
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
  final List<TourTypePricing> pricings;
  const CollectInfoWidget(
      {super.key,
      required this.selectedPricings,
      required this.bookingId,
      required this.pricings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// A list of tour type pricings, one for each customers, so that they can fill the info.
    List<Customer> customerPricings = _getCustomerPricings();
    Map<String, TourTypePricing> pricingById = _getPricingById();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(customersInfoProvider.notifier).changeAll(customerPricings);
    });
    return Column(
      children: [
        const BookingInfoPage(),
        const Text("Customers information"),
        ...customerPricings.asMap().entries.map((customerMap) {
          final customer = customerMap.value;
          final i = customerMap.key;
          return CustomerInfoWidget(
              customer: customer,
              pricing: pricingById[customer.pricingId],
              i: i);
        })
      ],
    );
  }

  Map<String, TourTypePricing> _getPricingById() {
    Map<String, TourTypePricing> toReturn = {};
    for (final p in pricings) {
      toReturn.addAll({p.id: p});
    }
    return toReturn;
  }

  List<Customer> _getCustomerPricings() {
    final toReturn = <Customer>[];

    for (final p in selectedPricings) {
      for (var i = 0; i < p.numberBooked; i++) {
        toReturn.add(Customer(
            id: const Uuid().v4(),
            bookingId: bookingId,
            pricingId: p.tourTypePricingId));
      }
    }

    return toReturn;
  }
}

class CustomerInfoWidget extends ConsumerStatefulWidget {
  final Customer customer;
  final TourTypePricing? pricing;
  final int i;
  const CustomerInfoWidget(
      {super.key,
      required this.customer,
      required this.pricing,
      required this.i});

  @override
  ConsumerState<CustomerInfoWidget> createState() => _CustomerInfoWidgetState();
}

class _CustomerInfoWidgetState extends ConsumerState<CustomerInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(customersInfoProvider.notifier);
    return Column(
      children: [
        Text(
            "${widget.i + 1} - Passenger information: ${widget.pricing?.displayName}"),
        TextField(
          onChanged: (v) {
            notifier.changeSingle(
                widget.customer.id, widget.customer.copyWith(name: v));
          },
          decoration: const InputDecoration(labelText: "Name"),
        ),
        TextField(
          onChanged: (v) {
            notifier.changeSingle(widget.customer.id,
                widget.customer.copyWith(age: int.tryParse(v)));
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Age"),
        ),
      ],
    );
  }
}

class BookingInfoPage extends ConsumerStatefulWidget {
  const BookingInfoPage({super.key});

  @override
  ConsumerState<BookingInfoPage> createState() => _BookingInfoPageState();
}

class _BookingInfoPageState extends ConsumerState<BookingInfoPage> {
  bool _phoneFilled = false;
  bool _emailFilled = false;
  bool _streetFilled = false;
  bool _zipFilled = false;
  bool _cityFilled = false;
  bool _countryFilled = false;

  @override
  void initState() {
    super.initState();
    final booking = ref.read(bookingInfoProvider);
    _phoneFilled = (booking?.phone ?? '').trim().isNotEmpty;
    _emailFilled = (booking?.email ?? '').trim().isNotEmpty;
    _streetFilled = (booking?.streetAddress ?? '').trim().isNotEmpty;
    _zipFilled = (booking?.zipCode ?? '').trim().isNotEmpty;
    _cityFilled = (booking?.city ?? '').trim().isNotEmpty;
    _countryFilled = (booking?.country ?? '').trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    Booking? booking = ref.read(bookingInfoProvider);
    if (booking == null) return const SizedBox.shrink();
    List<String> countries =
        WorldCountry.list.map((wc) => wc.name.name).toList();

    final colorScheme = Theme.of(context).colorScheme;

    InputDecoration _inputDecoration({
      required String label,
      IconData? icon,
      required bool filled,
    }) {
      const green = Colors.green;
      const baseBorder = OutlineInputBorder();
      const successBorder = OutlineInputBorder(
        borderSide: BorderSide(color: green, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      );
      return InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: baseBorder,
        enabledBorder: filled ? successBorder : baseBorder,
        focusedBorder: filled ? successBorder : baseBorder,
        suffixIcon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: ScaleTransition(scale: anim, child: child),
          ),
          child: filled
              ? const Icon(Icons.check_circle,
                  key: ValueKey('ok'), color: green)
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      );
    }

    Widget _sectionCard({
      required IconData icon,
      required String title,
      required List<Widget> children,
    }) {
      return Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final twoCols = w >= 700;
      const spacing = 16.0;
      const runSpacing = 12.0;
      final itemWidth = twoCols ? (w - (spacing * 3)) / 2 : w - (spacing * 2);

      Widget _animatedField({required bool filled, required Widget child}) =>
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: filled ? Colors.green.withOpacity(0.05) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          _sectionCard(
            icon: Icons.person_outline,
            title: "Contact information",
            children: [
              Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _animatedField(
                      filled: _phoneFilled,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                            label: "Phone number",
                            icon: Icons.phone,
                            filled: _phoneFilled),
                        onChanged: (nv) {
                          setState(() => _phoneFilled = nv.trim().isNotEmpty);
                          ref
                              .read(bookingInfoProvider.notifier)
                              .change(booking.copyWith(phone: nv));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _animatedField(
                      filled: _emailFilled,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration(
                            label: "Email",
                            icon: Icons.email_outlined,
                            filled: _emailFilled),
                        onChanged: (nv) {
                          setState(() => _emailFilled = nv.trim().isNotEmpty);
                          ref
                              .read(bookingInfoProvider.notifier)
                              .change(booking.copyWith(email: nv));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _sectionCard(
            icon: Icons.home_outlined,
            title: "Address",
            children: [
              Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _animatedField(
                      filled: _streetFilled,
                      child: TextField(
                        keyboardType: TextInputType.streetAddress,
                        decoration: _inputDecoration(
                            label: "Street address",
                            icon: Icons.home_work_outlined,
                            filled: _streetFilled),
                        onChanged: (nv) {
                          setState(() => _streetFilled = nv.trim().isNotEmpty);
                          ref
                              .read(bookingInfoProvider.notifier)
                              .change(booking.copyWith(streetAddress: nv));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _animatedField(
                      filled: _zipFilled,
                      child: TextField(
                        decoration: _inputDecoration(
                            label: "Zip code",
                            icon: Icons.local_post_office,
                            filled: _zipFilled),
                        onChanged: (nv) {
                          setState(() => _zipFilled = nv.trim().isNotEmpty);
                          ref
                              .read(bookingInfoProvider.notifier)
                              .change(booking.copyWith(zipCode: nv));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _animatedField(
                      filled: _cityFilled,
                      child: TextField(
                        decoration: _inputDecoration(
                            label: "City",
                            icon: Icons.location_city,
                            filled: _cityFilled),
                        onChanged: (nv) {
                          setState(() => _cityFilled = nv.trim().isNotEmpty);
                          ref
                              .read(bookingInfoProvider.notifier)
                              .change(booking.copyWith(city: nv));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: _countryFilled
                            ? Colors.green.withOpacity(0.05)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownMenu(
                        label: const Text("Country"),
                        leadingIcon: const Icon(Icons.public),
                        trailingIcon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: ScaleTransition(scale: anim, child: child),
                          ),
                          child: _countryFilled
                              ? const Icon(Icons.check_circle,
                                  key: ValueKey('country-ok'),
                                  color: Colors.green)
                              : const Icon(Icons.arrow_drop_down,
                                  key: ValueKey('country-empty')),
                        ),
                        width: itemWidth,
                        onSelected: (v) {
                          setState(() =>
                              _countryFilled = (v ?? '').trim().isNotEmpty);
                          ref
                              .read(bookingInfoProvider.notifier)
                              .change(booking.copyWith(country: v));
                        },
                        dropdownMenuEntries: countries
                            .map((c) => DropdownMenuEntry(value: c, label: c))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.lock_outline, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                "We keep your information private",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )
        ],
      );
    });
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
                              final logger = BasicLogger();
                              logger.info("TODO: go to stripe");
                              logger.debug(ref.read(customersInfoProvider));
                              logger.debug(ref.read(bookingInfoProvider));
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
