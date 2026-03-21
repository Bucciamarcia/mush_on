import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_facing/booking_page/repository.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:sealed_countries/sealed_countries.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'booking_page.dart';
import 'calendar/main.dart';

class CollectInfoPage extends StatelessWidget {
  final TourType tourType;
  final List<BookingPricingNumberBooked> selectedPricings;
  final List<TourTypePricing> pricings;
  final BookingManagerKennelInfo kennelInfo;
  const CollectInfoPage({
    super.key,
    required this.tourType,
    required this.selectedPricings,
    required this.pricings,
    required this.kennelInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingPageColors.background.color,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 980;
            final bookingId = const Uuid().v4();

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1320),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BookingPageHeader(),
                      const SizedBox(height: 18),
                      BookingPageTopOverview(tourType: tourType),
                      const SizedBox(height: 18),
                      BookingFlowFrame(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const BookingProgressBanner(
                              currentStep: 2,
                              title: "Add guest details",
                              subtitle:
                                  "Complete contact information and passenger details before checkout.",
                            ),
                            const SizedBox(height: 28),
                            if (wide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: CollectInfoWidget(
                                      selectedPricings: selectedPricings,
                                      pricings: pricings,
                                      bookingId: bookingId,
                                      kennelInfo: kennelInfo,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 4,
                                    child: BookingSummaryImmobile(
                                        tourType: tourType),
                                  ),
                                ],
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CollectInfoWidget(
                                    selectedPricings: selectedPricings,
                                    pricings: pricings,
                                    bookingId: bookingId,
                                    kennelInfo: kennelInfo,
                                  ),
                                  const SizedBox(height: 20),
                                  BookingSummaryImmobile(tourType: tourType),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CollectInfoWidget extends ConsumerWidget {
  final List<BookingPricingNumberBooked> selectedPricings;
  final String bookingId;
  final List<TourTypePricing> pricings;
  final BookingManagerKennelInfo kennelInfo;
  const CollectInfoWidget({
    super.key,
    required this.selectedPricings,
    required this.bookingId,
    required this.pricings,
    required this.kennelInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var customers = ref.watch(customersInfoProvider);

    if (customers.isEmpty) {
      final initialCustomers = _getCustomerPricings();
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        if (ref.read(customersInfoProvider).isEmpty) {
          ref.read(customersInfoProvider.notifier).changeAll(initialCustomers);
        }
      });
      customers = initialCustomers;
    }

    final pricingById = _getPricingById();
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        const spacing = 16.0;
        final itemWidth =
            wide ? (constraints.maxWidth - spacing) / 2 : constraints.maxWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BookingInfoPage(kennelInfo: kennelInfo),
            const SizedBox(height: 18),
            BookingSectionCard(
              stepNumber: "5",
              title: "Passengers",
              subtitle: "Add the required details for each guest.",
              child: Column(
                children: [
                  for (final customerMap in customers.asMap().entries) ...[
                    _PassengerBlock(
                      index: customerMap.key,
                      customer: customerMap.value,
                      pricingLabel: pricingById[customerMap.value.pricingId]
                              ?.displayName ??
                          '',
                      itemWidth: itemWidth,
                      customerCustomFields: kennelInfo.customerCustomFields,
                    ),
                    if (customerMap.key != customers.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Divider(
                          color: BookingPageColors.outlineSoft.color,
                          height: 1,
                        ),
                      ),
                  ],
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => context.pushNamed("/privacy_customer"),
                      icon: const Icon(Icons.privacy_tip_outlined),
                      label: const Text("Privacy policy"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, TourTypePricing> _getPricingById() {
    final toReturn = <String, TourTypePricing>{};
    for (final p in pricings) {
      toReturn[p.id] = p;
    }
    return toReturn;
  }

  List<Customer> _getCustomerPricings() {
    final toReturn = <Customer>[];
    for (final p in selectedPricings) {
      for (var i = 0; i < p.numberBooked; i++) {
        toReturn.add(
          Customer(
            id: const Uuid().v4(),
            bookingId: bookingId,
            pricingId: p.tourTypePricingId,
          ),
        );
      }
    }
    return toReturn;
  }
}

class _PassengerBlock extends StatelessWidget {
  final int index;
  final Customer customer;
  final String pricingLabel;
  final double itemWidth;
  final List<CustomerCustomField> customerCustomFields;
  const _PassengerBlock({
    required this.index,
    required this.customer,
    required this.pricingLabel,
    required this.itemWidth,
    required this.customerCustomFields,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: BookingPageColors.surfaceStrong.color,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Text(
                "${index + 1}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: BookingPageColors.primaryDark.color,
                    ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  pricingLabel.isEmpty
                      ? "Passenger ${index + 1}"
                      : "Passenger ${index + 1} • $pricingLabel",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: BookingPageColors.textStrong.color,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 16,
          runSpacing: 14,
          children: customerCustomFields
              .map(
                (field) => SizedBox(
                  width: itemWidth,
                  child: CustomerInfoWidget(
                    customer: customer,
                    field: field,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class CustomerInfoWidget extends ConsumerWidget {
  final Customer customer;
  final CustomerCustomField field;
  const CustomerInfoWidget({
    super.key,
    required this.customer,
    required this.field,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersInfoProvider);
    final notifier = ref.read(customersInfoProvider.notifier);
    final showErrors = ref.watch(showValidationErrorsProvider);
    final current = customers.firstWhere((c) => c.id == customer.id,
        orElse: () => customer);

    bool hasValue(String? value) => (value ?? '').trim().isNotEmpty;

    final value = current.customerOtherInfo[field.name];
    final filled = hasValue(value);
    final hasError = showErrors && field.isRequired && !filled;

    final label =
        "${field.name} ${field.isRequired ? "(Required)" : "(Not required)"}";

    return _BookingFormFieldShell(
      filled: filled,
      hasError: hasError,
      child: TextField(
        onChanged: (v) {
          final updatedOtherInfo =
              Map<String, String>.from(current.customerOtherInfo);
          updatedOtherInfo[field.name] = v;
          notifier.changeSingle(
            customer.id,
            current.copyWith(customerOtherInfo: updatedOtherInfo),
          );
        },
        decoration: bookingInputDecoration(
          context: context,
          label: label,
          icon: Icons.person_outline,
          isFilled: filled,
          showError: hasError,
        ),
      ),
    );
  }
}

class BookingInfoPage extends ConsumerWidget {
  final BookingManagerKennelInfo kennelInfo;
  const BookingInfoPage({super.key, required this.kennelInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingInfoProvider);
    if (booking == null) return const SizedBox.shrink();

    var countries = WorldCountry.list.map((wc) => wc.name.name).toList();
    if (kDebugMode) {
      countries = ["One", "two"];
    }

    final showErrors = ref.watch(showValidationErrorsProvider);

    bool filled(String? v) => (v ?? '').trim().isNotEmpty;

    bool isValidEmail(String? email) {
      if (email == null || email.trim().isEmpty) return false;
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      return emailRegex.hasMatch(email.trim().toLowerCase());
    }

    bool hasOtherDataValue(String? value) => filled(value);

    Map<int, bool> spoolOtherInfoFilled() {
      final toReturn = <int, bool>{};

      for (var i = 0; i < kennelInfo.bookingCustomFields.length; i++) {
        final field = kennelInfo.bookingCustomFields[i];
        final value = booking.otherBookingData[field.name];
        toReturn[i] = hasOtherDataValue(value);
      }

      return toReturn;
    }

    Map<int, bool> spoolOtherInfoError() {
      final toReturn = <int, bool>{};

      for (var i = 0; i < kennelInfo.bookingCustomFields.length; i++) {
        final field = kennelInfo.bookingCustomFields[i];
        final value = booking.otherBookingData[field.name];
        toReturn[i] = showErrors && field.isRequired && !filled(value);
      }

      return toReturn;
    }

    bool isOtherDataValid(String? value, BookingCustomField field) {
      if (!field.isRequired) return true;
      return hasOtherDataValue(value);
    }

    final phoneFilled = filled(booking.phone);
    final emailFilled = isValidEmail(booking.email);
    final streetFilled = filled(booking.streetAddress);
    final zipFilled = filled(booking.zipCode);
    final cityFilled = filled(booking.city);
    final countryFilled = filled(booking.country);
    final Map<int, bool> otherInfoFilled = spoolOtherInfoFilled();
    final Map<int, bool> otherInfoError = spoolOtherInfoError();
    final otherInfoData = Map<String, String>.from(booking.otherBookingData);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final itemWidth =
            wide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BookingSectionCard(
              stepNumber: "3",
              title: "Contact details",
              subtitle:
                  "These details will be used for confirmations and receipts.",
              child: Wrap(
                spacing: 16,
                runSpacing: 14,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _BookingFormFieldShell(
                      filled: phoneFilled,
                      hasError: showErrors && !phoneFilled,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: bookingInputDecoration(
                          context: context,
                          label: "Phone number",
                          icon: Icons.phone_outlined,
                          isFilled: phoneFilled,
                          showError: showErrors && !phoneFilled,
                        ),
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
                    child: _BookingFormFieldShell(
                      filled: emailFilled,
                      hasError: showErrors && !emailFilled,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: bookingInputDecoration(
                          context: context,
                          label: "Email",
                          icon: Icons.email_outlined,
                          isFilled: emailFilled,
                          showError: showErrors && !emailFilled,
                        ),
                        onChanged: (nv) {
                          final normalizedEmail = nv.trim().toLowerCase();
                          ref
                              .read(bookingInfoProvider.notifier)
                              .change(booking.copyWith(email: normalizedEmail));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            BookingSectionCard(
              stepNumber: "4",
              title: "Billing address",
              subtitle: "Required by the payment provider before checkout.",
              child: Wrap(
                spacing: 16,
                runSpacing: 14,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _BookingFormFieldShell(
                      filled: streetFilled,
                      hasError: showErrors && !streetFilled,
                      child: TextField(
                        keyboardType: TextInputType.streetAddress,
                        decoration: bookingInputDecoration(
                          context: context,
                          label: "Street address",
                          icon: Icons.home_work_outlined,
                          isFilled: streetFilled,
                          showError: showErrors && !streetFilled,
                        ),
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
                    child: _BookingFormFieldShell(
                      filled: zipFilled,
                      hasError: showErrors && !zipFilled,
                      child: TextField(
                        decoration: bookingInputDecoration(
                          context: context,
                          label: "Zip code",
                          icon: Icons.local_post_office_outlined,
                          isFilled: zipFilled,
                          showError: showErrors && !zipFilled,
                        ),
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
                    child: _BookingFormFieldShell(
                      filled: cityFilled,
                      hasError: showErrors && !cityFilled,
                      child: TextField(
                        decoration: bookingInputDecoration(
                          context: context,
                          label: "City",
                          icon: Icons.location_city_outlined,
                          isFilled: cityFilled,
                          showError: showErrors && !cityFilled,
                        ),
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
                    child: _BookingFormFieldShell(
                      filled: countryFilled,
                      hasError: showErrors && !countryFilled,
                      child: DropdownMenu<String>(
                        label: const Text("Country"),
                        leadingIcon: const Icon(Icons.public),
                        trailingIcon: bookingFieldStatusIcon(
                          isFilled: countryFilled,
                          showError: showErrors && !countryFilled,
                        ),
                        initialSelection: booking.country,
                        width: itemWidth,
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            BookingPageColors.surface.color,
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        inputDecorationTheme: bookingDropdownDecorationTheme(
                          isFilled: countryFilled,
                          showError: showErrors && !countryFilled,
                        ),
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
            ),
            const SizedBox(height: 16),
            kennelInfo.bookingCustomFields.isEmpty
                ? const SizedBox.shrink()
                : BookingSectionCard(
                    stepNumber: "5",
                    title: "Other information",
                    subtitle: "Required for your booking.",
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 14,
                      children: [
                        ...kennelInfo.bookingCustomFields
                            .asMap()
                            .entries
                            .map((entry) {
                          final i = entry.key;
                          final field = entry.value;
                          return SizedBox(
                            width: itemWidth,
                            child: _BookingFormFieldShell(
                              filled: otherInfoFilled[i] ?? true,
                              hasError: otherInfoError[i] ?? false,
                              child: TextField(
                                decoration: bookingInputDecoration(
                                  context: context,
                                  label:
                                      "${field.name} ${field.isRequired ? "(Required)" : "(Not required)"}",
                                  icon: Icons.question_mark,
                                  isFilled: hasOtherDataValue(
                                      otherInfoData[field.name]),
                                  showError: showErrors &&
                                      !isOtherDataValid(
                                        otherInfoData[field.name],
                                        field,
                                      ),
                                ),
                                onChanged: (nv) {
                                  final updatedOtherInfoData =
                                      Map<String, String>.from(
                                    ref
                                            .read(bookingInfoProvider)
                                            ?.otherBookingData ??
                                        const <String, String>{},
                                  );
                                  updatedOtherInfoData[field.name] = nv;
                                  ref.read(bookingInfoProvider.notifier).change(
                                      booking.copyWith(
                                          otherBookingData:
                                              updatedOtherInfoData));
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: BookingPageColors.primaryDark.color,
                ),
                const SizedBox(width: 8),
                Text(
                  "We keep your information private.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: BookingPageColors.textMuted.color,
                      ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class BookingSummaryImmobile extends ConsumerWidget {
  final TourType tourType;
  const BookingSummaryImmobile({super.key, required this.tourType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateInCalendarProvider);
    final isLoadingCart = ref.watch(isLoadingCartProvider);
    final selectedCustomerGroup =
        ref.watch(selectedCustomerGroupInCalendarProvider);
    final account = ref.watch(accountPublicProvider);

    final pricings = account == null
        ? <TourTypePricing>[]
        : ref
                .watch(
                  tourTypePricesByTourIdProvider(
                    tourId: tourType.id,
                    account: account,
                  ),
                )
                .value ??
            [];

    final selectedPricings =
        ref.watch(bookingDetailsSelectedPricingsProvider(pricings));
    final customersNumberByCgId =
        ref.watch(customersNumberByCustomerGroupIdBookingProvider).value;
    final maxCapacity = selectedCustomerGroup?.maxCapacity;
    final customersBooked = customersNumberByCgId?[selectedCustomerGroup?.id];
    final availableSpots = maxCapacity == null || customersBooked == null
        ? 0
        : maxCapacity - customersBooked;

    int totalBooked() {
      var total = 0;
      for (final sp in selectedPricings) {
        total += sp.numberBooked;
      }
      return total;
    }

    double total() {
      var amount = 0.0;
      for (final sp in selectedPricings) {
        final pricing =
            pricings.firstWhere((p) => p.id == sp.tourTypePricingId);
        amount += (pricing.priceCents.toDouble() / 100) * sp.numberBooked;
      }
      return amount;
    }

    final grandTotalToPay = total();
    final maxBookingsSelected = totalBooked() >= availableSpots;
    final isComplete = ref.watch(bookingAllFieldsCompleteProvider);

    return BookingSummaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Checkout summary",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: BookingPageColors.textStrong.color,
                ),
          ),
          const SizedBox(height: 24),
          BookingSummaryInfoRow(
            icon: Icons.pets_outlined,
            label: "Experience",
            value: tourType.displayName,
          ),
          const SizedBox(height: 18),
          BookingSummaryInfoRow(
            icon: Icons.calendar_today_outlined,
            label: "Date",
            value: selectedDate == null
                ? "Choose a date"
                : DateFormat("EEEE, MMM d, yyyy").format(selectedDate),
          ),
          const SizedBox(height: 18),
          BookingSummaryInfoRow(
            icon: Icons.schedule_outlined,
            label: "Departure",
            value: selectedCustomerGroup == null
                ? "Choose a time"
                : DateFormat("HH:mm").format(selectedCustomerGroup.datetime),
          ),
          const SizedBox(height: 18),
          BookingSummaryInfoRow(
            icon: Icons.event_seat_outlined,
            label: "Availability",
            value: "$availableSpots spots left",
          ),
          const SizedBox(height: 24),
          for (final pricing in pricings) ...[
            PricingOptionCounterImmobile(
              pricing: pricing,
              available: availableSpots,
              pricings: pricings,
              maxBookingsSelected: maxBookingsSelected,
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
          for (final pricing in pricings) ...[
            PricingOptionTotalPrice(
              bookingInfo: selectedPricings
                  .firstWhere((sp) => sp.tourTypePricingId == pricing.id),
              pricing: pricing,
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
          GrandTotalSummaryRow(
            selectedPricings: selectedPricings,
            pricings: pricings,
            grandTotalToPay: grandTotalToPay,
          ),
          const SizedBox(height: 14),
          const CancellationPolicySection(),
          const SizedBox(height: 20),
          if (isLoadingCart)
            const Column(
              children: [
                CircularProgressIndicator.adaptive(),
                SizedBox(height: 10),
                Text("Please wait: loading secure payment system"),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: bookingSecondaryButtonStyle(),
                    child: const Text("Go back"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: account == null
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          onPressed: () async {
                            if (!isComplete) {
                              ref
                                  .read(showValidationErrorsProvider.notifier)
                                  .state = true;
                              return;
                            }
                            ref
                                .read(isLoadingCartProvider.notifier)
                                .change(true);
                            final kennelInfo = await ref.watch(
                              bookingManagerKennelInfoProvider(account: account)
                                  .future,
                            );
                            if (kennelInfo == null) return;
                            final repo = BookingPageRepository(
                              account: account,
                              tourId: tourType.id,
                            );
                            try {
                              final booking = ref.read(bookingInfoProvider);
                              final customers = ref.read(customersInfoProvider);
                              if (booking != null) {
                                final url = await repo.getStripePaymentUrl(
                                  booking: booking,
                                  customers: customers,
                                  pricings: pricings,
                                  kennelInfo: kennelInfo,
                                );
                                await _launchUrl(url);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar(
                                    context,
                                    "Couldn't add booking: contact support.",
                                  ),
                                );
                              }
                            } finally {
                              ref
                                  .read(isLoadingCartProvider.notifier)
                                  .change(false);
                            }
                          },
                          style: bookingPrimaryButtonStyle(),
                          child:
                              Text(isComplete ? "Book now" : "Complete form"),
                        ),
                ),
              ],
            ),
          const SizedBox(height: 18),
          const SafetyIconsWrap(),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw Exception("Could not launch $url");
    }
  }
}

class PricingOptionCounterImmobile extends ConsumerWidget {
  final List<TourTypePricing> pricings;
  final TourTypePricing pricing;
  final int available;
  final bool maxBookingsSelected;
  const PricingOptionCounterImmobile({
    super.key,
    required this.pricing,
    required this.available,
    required this.pricings,
    required this.maxBookingsSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountPublicProvider);
    if (account == null) return const SizedBox.shrink();
    final selectedPricings =
        ref.watch(bookingDetailsSelectedPricingsProvider(pricings));
    final selectedPricing =
        selectedPricings.firstWhere((sp) => sp.tourTypePricingId == pricing.id);

    if (selectedPricing.numberBooked == 0) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: Text(
            pricing.displayName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: BookingPageColors.textMuted.color,
                ),
          ),
        ),
        Text(
          "x${selectedPricing.numberBooked}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: BookingPageColors.textStrong.color,
              ),
        ),
      ],
    );
  }
}

class CancellationPolicySection extends ConsumerWidget {
  const CancellationPolicySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountPublicProvider);
    if (account == null) return const Text("Error");
    final kennelInfo =
        ref.watch(bookingManagerKennelInfoProvider(account: account)).value;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BookingPageColors.surfaceStrong.color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 18,
                color: BookingPageColors.primaryDark.color,
              ),
              const SizedBox(width: 8),
              Text(
                "Cancellation policy",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: BookingPageColors.textStrong.color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            kennelInfo?.cancellationPolicy ?? "",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: BookingPageColors.textMuted.color,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _BookingFormFieldShell extends StatelessWidget {
  final bool filled;
  final bool hasError;
  final Widget child;
  const _BookingFormFieldShell({
    required this.filled,
    required this.hasError,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final background = hasError
        ? const Color(0xffffefef)
        : filled
            ? BookingPageColors.primaryLight.color.withValues(alpha: 0.55)
            : BookingPageColors.surface.color;

    final borderColor = hasError
        ? BookingPageColors.danger.color
        : filled
            ? BookingPageColors.primary.color
            : BookingPageColors.outlineSoft.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

InputDecoration bookingInputDecoration({
  required BuildContext context,
  required String label,
  required IconData icon,
  required bool isFilled,
  required bool showError,
}) {
  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide(color: color),
    );
  }

  final effectiveBorder = showError
      ? BookingPageColors.danger.color
      : isFilled
          ? BookingPageColors.primary.color
          : BookingPageColors.outlineSoft.color;

  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: BookingPageColors.textMuted.color),
    prefixIcon: Icon(icon, color: BookingPageColors.primaryDark.color),
    suffixIcon: bookingFieldStatusIcon(
      isFilled: isFilled,
      showError: showError,
    ),
    filled: true,
    fillColor: Colors.transparent,
    border: border(effectiveBorder),
    enabledBorder: border(effectiveBorder),
    focusedBorder: border(effectiveBorder),
    errorBorder: border(BookingPageColors.danger.color),
    focusedErrorBorder: border(BookingPageColors.danger.color),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
  );
}

Widget bookingFieldStatusIcon({
  required bool isFilled,
  required bool showError,
}) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 160),
    child: isFilled
        ? Icon(
            Icons.check_circle,
            key: const ValueKey('ok'),
            color: BookingPageColors.success.color,
          )
        : showError
            ? Icon(
                Icons.error_outline,
                key: const ValueKey('err'),
                color: BookingPageColors.danger.color,
              )
            : Icon(
                Icons.circle_outlined,
                key: const ValueKey('empty'),
                color: BookingPageColors.outline.color,
              ),
  );
}

InputDecorationTheme bookingDropdownDecorationTheme({
  required bool isFilled,
  required bool showError,
}) {
  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide(color: color),
    );
  }

  final effectiveBorder = showError
      ? BookingPageColors.danger.color
      : isFilled
          ? BookingPageColors.primary.color
          : BookingPageColors.outlineSoft.color;

  return InputDecorationTheme(
    filled: true,
    fillColor: Colors.transparent,
    border: border(effectiveBorder),
    enabledBorder: border(effectiveBorder),
    focusedBorder: border(effectiveBorder),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
  );
}
