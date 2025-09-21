import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_facing/booking_page/repository.dart';
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
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final twoCols = w >= 700;
      const spacing = 16.0;
      const runSpacing = 12.0;
      final itemWidth = twoCols ? (w - (spacing * 3)) / 2 : w - (spacing * 2);
      final colorScheme = Theme.of(context).colorScheme;

      Widget sectionCard({
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

      return Column(
        children: [
          const BookingInfoPage(),
          sectionCard(
            icon: Icons.group_outlined,
            title: "Passengers information",
            children: [
              ...customerPricings.asMap().entries.map((customerMap) {
                final customer = customerMap.value;
                final i = customerMap.key;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${i + 1} - Passenger: ${pricingById[customer.pricingId]?.displayName ?? ''}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: spacing,
                      runSpacing: runSpacing,
                      children: [
                        SizedBox(
                          width: itemWidth,
                          child: CustomerInfoWidget(
                            customer: customer,
                            pricing: pricingById[customer.pricingId],
                            i: i,
                            itemWidth: itemWidth,
                            field: _CustomerField.name,
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: CustomerInfoWidget(
                            customer: customer,
                            pricing: pricingById[customer.pricingId],
                            i: i,
                            itemWidth: itemWidth,
                            field: _CustomerField.age,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (i != customerPricings.length - 1)
                      const Divider(height: 24),
                  ],
                );
              }),
            ],
          ),
        ],
      );
    });
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

enum _CustomerField { name, age }

class CustomerInfoWidget extends ConsumerWidget {
  final Customer customer;
  final TourTypePricing? pricing;
  final int i;
  final double itemWidth;
  final _CustomerField field;
  const CustomerInfoWidget(
      {super.key,
      required this.customer,
      required this.pricing,
      required this.i,
      required this.itemWidth,
      required this.field});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersInfoProvider);
    final notifier = ref.read(customersInfoProvider.notifier);
    final showErrors = ref.watch(showValidationErrorsProvider);
    final current = customers.firstWhere((c) => c.id == customer.id,
        orElse: () => customer);

    bool nameFilled = (current.name).trim().isNotEmpty;
    bool ageFilled = current.age != null;
    bool filled = field == _CustomerField.name ? nameFilled : ageFilled;
    bool hasError = showErrors && !filled;

    const green = Colors.green;
    const baseBorder = OutlineInputBorder();
    const successBorder = OutlineInputBorder(
      borderSide: BorderSide(color: green, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );
    const errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );

    InputDecoration deco(String label, IconData icon) => InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: baseBorder,
          enabledBorder:
              hasError ? errorBorder : (filled ? successBorder : baseBorder),
          focusedBorder:
              hasError ? errorBorder : (filled ? successBorder : baseBorder),
          suffixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: ScaleTransition(scale: anim, child: child),
            ),
            child: filled
                ? const Icon(Icons.check_circle,
                    key: ValueKey('ok'), color: green)
                : hasError
                    ? const Icon(Icons.error_outline,
                        key: ValueKey('err'), color: Colors.red)
                    : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        );

    Widget wrapField(Widget child) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: filled
                ? Colors.green.withValues(alpha: 0.05)
                : (hasError ? Colors.red.withValues(alpha: 0.05) : null),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        );

    switch (field) {
      case _CustomerField.name:
        return wrapField(TextField(
          onChanged: (v) {
            notifier.changeSingle(customer.id, current.copyWith(name: v));
          },
          decoration: deco("Name", Icons.person_outline),
        ));
      case _CustomerField.age:
        return wrapField(TextField(
          onChanged: (v) {
            notifier.changeSingle(
                customer.id, current.copyWith(age: int.tryParse(v)));
          },
          keyboardType: TextInputType.number,
          decoration: deco("Age", Icons.cake_outlined),
        ));
    }
  }
}

class BookingInfoPage extends ConsumerWidget {
  const BookingInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingInfoProvider);
    if (booking == null) return const SizedBox.shrink();
    List<String> countries =
        WorldCountry.list.map((wc) => wc.name.name).toList();

    final colorScheme = Theme.of(context).colorScheme;
    final showErrors = ref.watch(showValidationErrorsProvider);

    bool filled(String? v) => (v ?? '').trim().isNotEmpty;
    final phoneFilled = filled(booking.phone);
    final emailFilled = filled(booking.email);
    final streetFilled = filled(booking.streetAddress);
    final zipFilled = filled(booking.zipCode);
    final cityFilled = filled(booking.city);
    final countryFilled = filled(booking.country);

    InputDecoration _inputDecoration({
      required String label,
      IconData? icon,
      required bool isFilled,
    }) {
      const green = Colors.green;
      const baseBorder = OutlineInputBorder();
      const successBorder = OutlineInputBorder(
        borderSide: BorderSide(color: green, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      );
      const errorBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      );
      final hasError = showErrors && !isFilled;
      return InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: baseBorder,
        enabledBorder:
            hasError ? errorBorder : (isFilled ? successBorder : baseBorder),
        focusedBorder:
            hasError ? errorBorder : (isFilled ? successBorder : baseBorder),
        suffixIcon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: ScaleTransition(scale: anim, child: child),
          ),
          child: isFilled
              ? const Icon(Icons.check_circle,
                  key: ValueKey('ok'), color: green)
              : hasError
                  ? const Icon(Icons.error_outline,
                      key: ValueKey('err'), color: Colors.red)
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

      Widget _animatedField({required bool isFilled, required Widget child}) {
        final hasError = showErrors && !isFilled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isFilled
                ? Colors.green.withOpacity(0.05)
                : (hasError ? Colors.red.withOpacity(0.05) : null),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        );
      }

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
                      isFilled: phoneFilled,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                            label: "Phone number",
                            icon: Icons.phone,
                            isFilled: phoneFilled),
                        onChanged: (nv) {
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
                      isFilled: emailFilled,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration(
                            label: "Email",
                            icon: Icons.email_outlined,
                            isFilled: emailFilled),
                        onChanged: (nv) {
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
                      isFilled: streetFilled,
                      child: TextField(
                        keyboardType: TextInputType.streetAddress,
                        decoration: _inputDecoration(
                            label: "Street address",
                            icon: Icons.home_work_outlined,
                            isFilled: streetFilled),
                        onChanged: (nv) {
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
                      isFilled: zipFilled,
                      child: TextField(
                        decoration: _inputDecoration(
                            label: "Zip code",
                            icon: Icons.local_post_office,
                            isFilled: zipFilled),
                        onChanged: (nv) {
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
                      isFilled: cityFilled,
                      child: TextField(
                        decoration: _inputDecoration(
                            label: "City",
                            icon: Icons.location_city,
                            isFilled: cityFilled),
                        onChanged: (nv) {
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
                        color: countryFilled
                            ? Colors.green.withOpacity(0.05)
                            : (showErrors && !countryFilled
                                ? Colors.red.withOpacity(0.05)
                                : null),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: showErrors && !countryFilled
                              ? Colors.red
                              : Colors.transparent,
                          width: showErrors && !countryFilled ? 1.5 : 0.0,
                        ),
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
                          child: countryFilled
                              ? const Icon(Icons.check_circle,
                                  key: ValueKey('country-ok'),
                                  color: Colors.green)
                              : (showErrors && !countryFilled
                                  ? const Icon(Icons.error_outline,
                                      key: ValueKey('country-err'),
                                      color: Colors.red)
                                  : const Icon(Icons.arrow_drop_down,
                                      key: ValueKey('country-empty'))),
                        ),
                        initialSelection: booking.country,
                        width: itemWidth,
                        onSelected: (v) {
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

    final isComplete = ref.watch(bookingAllFieldsCompleteProvider);

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
                account == null
                    ? const SizedBox.shrink()
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: ElevatedButton(
                            key: ValueKey(isComplete),
                            onPressed: () async {
                              if (!isComplete) {
                                ref
                                    .read(showValidationErrorsProvider.notifier)
                                    .state = true;
                                return;
                              }
                              final logger = BasicLogger();
                              logger.info("TODO: go to stripe");
                              logger.debug(ref.read(customersInfoProvider));
                              logger.debug(ref.read(bookingInfoProvider));
                              // Simulate stripe call
                              await Future.delayed(const Duration(seconds: 2));
                              final repo = BookingPageRepository(
                                  account: account, tourId: tourType.id);
                              try {
                                final booking = ref.read(bookingInfoProvider);
                                if (booking != null) {
                                  await repo.bookTour(
                                      booking, ref.read(customersInfoProvider));
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      errorSnackBar(context,
                                          "Couldn't add booking: contact support."));
                                }
                              }
                              BasicLogger().info("DONE!");
                            },
                            style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 30)),
                                backgroundColor: WidgetStatePropertyAll(
                                    isComplete
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
