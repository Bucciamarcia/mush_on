import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_facing/booking_page/repository.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'calendar/main.dart';

import 'info_page.dart';
import 'riverpod.dart';

class BookingPage extends ConsumerStatefulWidget {
  final String? account;
  final String? tourId;
  const BookingPage({super.key, required this.tourId, required this.account});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  static final logger = BasicLogger();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(accountPublicProvider.notifier).change(widget.account!);
      ref.read(selectedTourIdProvider.notifier).change(widget.tourId!);
    });
  }

  @override
  void didUpdateWidget(covariant BookingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.account != widget.account ||
        oldWidget.tourId != widget.tourId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(accountPublicProvider.notifier).change(widget.account!);
        ref.read(selectedTourIdProvider.notifier).change(widget.tourId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.account == null || widget.tourId == null) {
      return const NoKennelOrTourIdErrorPage();
    }

    /// Info about the tour type that is being booked.
    final tourTypeAsync = ref.watch(tourTypeProvider(
        account: widget.account!,
        tourId: ref.watch(selectedTourIdProvider) ?? ""));
    return tourTypeAsync.when(
        data: (tourType) {
          if (tourType == null) {
            return const NoKennelOrTourIdErrorPage();
          }
          return FutureBuilder(
              future: BookingPageRepository(
                      account: widget.account!, tourId: widget.tourId!)
                  .getStripeConnection(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final stripe = snapshot.data!;
                  if (!stripe.isActive) {
                    return const NotAvailable();
                  }
                  return MainContent(
                      account: widget.account!,
                      tourType: tourType,
                      stripe: stripe);
                } else if (snapshot.hasError) {
                  return const NotAvailable();
                } else {
                  return const Scaffold(
                      body: Center(
                          child: Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Loading the booking page, please wait..."),
                      CircularProgressIndicator.adaptive(),
                    ],
                  )));
                }
              });
        },
        error: (e, s) {
          logger.error("Error loading tour type for booking page",
              error: e, stackTrace: s);
          return const NoKennelOrTourIdErrorPage();
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}

class MainContent extends ConsumerWidget {
  final TourType tourType;
  final String account;
  final StripeConnection stripe;
  const MainContent(
      {super.key,
      required this.tourType,
      required this.account,
      required this.stripe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingManagerKennelInfoAsync =
        ref.watch(bookingManagerKennelInfoProvider(account: account));
    final logger = BasicLogger();
    return bookingManagerKennelInfoAsync.when(data: (kennelInfo) {
      if (kennelInfo == null) return const NotAvailable();
      return Scaffold(
          body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                constraints: const BoxConstraints(maxWidth: 1200),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const BookingPageHeader(),
                      BookingPageTopOverview(
                        tourType: tourType,
                      ),
                      const Divider(),
                      DateSelectionWidget(
                          constraints: constraints,
                          tourType: tourType,
                          account: account)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      })));
    }, error: (e, s) {
      logger.error("Couldn't get booking info", error: e, stackTrace: s);
      return const NotAvailable();
    }, loading: () {
      return const Scaffold(
          body: Center(
              child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Loading the booking page, please wait..."),
          CircularProgressIndicator.adaptive(),
        ],
      )));
    });
  }
}

class DateSelectionWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final TourType tourType;
  final String account;
  const DateSelectionWidget(
      {super.key,
      required this.constraints,
      required this.tourType,
      required this.account});

  @override
  Widget build(BuildContext context) {
    final w = constraints.maxWidth;
    if (w >= 768) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: BookingTimeAndDate(tourType: tourType, account: account),
            ),
          ),
          BookingSummaryColumn(tourType: tourType)
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: BookingTimeAndDate(tourType: tourType, account: account),
          ),
          BookingSummaryColumn(tourType: tourType)
        ],
      );
    }
  }
}

class BookingSummaryColumn extends ConsumerWidget {
  final TourType tourType;
  const BookingSummaryColumn({super.key, required this.tourType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(customersNumberByCustomerGroupIdBookingProvider);
    final logger = BasicLogger();
    logger.info('watched provider runtimeType: ${async.runtimeType}');
    async.when(
      data: (m) {
        logger
            .info('map valueType sample: ${m.values.firstOrNull?.runtimeType}');
      },
      loading: () {},
      error: (e, s) {
        logger.info('err: $e');
      },
    );
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

    final account = ref.watch(accountPublicProvider);
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
        ref.watch(customersNumberByCustomerGroupIdBookingProvider).value;
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
          ...pricings.map((pricing) => PricingOptionCounter(
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
            child: ConfirmBookingButton(
                selectedPricings: selectedPricings,
                pricings: pricings,
                tourType: tourType),
          ),
          const SafetyIconsWrap(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class SafetyIconsWrap extends StatelessWidget {
  const SafetyIconsWrap({super.key});

  @override
  Widget build(BuildContext context) {
    double h = 32;
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        SvgPicture.asset(
          "assets/images/visa.svg",
          height: h,
        ),
        SvgPicture.asset(
          "assets/images/mastercard.svg",
          height: h,
        ),
        SvgPicture.asset(
          "assets/images/amex.svg",
          height: h,
        ),
      ],
    );
  }
}

class ConfirmBookingButton extends ConsumerWidget {
  static final BasicLogger logger = BasicLogger();
  final List<BookingPricingNumberBooked> selectedPricings;
  final List<TourTypePricing> pricings;
  final TourType tourType;
  const ConfirmBookingButton(
      {super.key,
      required this.selectedPricings,
      required this.pricings,
      required this.tourType});

  bool _isActive() {
    for (final sp in selectedPricings) {
      if (sp.numberBooked > 0) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: ElevatedButton(
          key: ValueKey(_isActive()),
          onPressed: _isActive()
              ? () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CollectInfoPage(
                          tourType: tourType,
                          pricings: pricings,
                          selectedPricings: selectedPricings)));
                }
              : null,
          style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 20, horizontal: 30)),
              backgroundColor: WidgetStatePropertyAll(_isActive()
                  ? BookingPageColors.primaryDark.color
                  : Colors.grey)),
          child: const Text(
            "Continue",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

class GrandTotalSummaryRow extends StatelessWidget {
  final List<BookingPricingNumberBooked> selectedPricings;
  final List<TourTypePricing> pricings;
  final double grandTotalToPay;
  const GrandTotalSummaryRow(
      {super.key,
      required this.selectedPricings,
      required this.pricings,
      required this.grandTotalToPay});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total:",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        Text("$grandTotalToPay€",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: BookingPageColors.primary.color,
                fontSize: 16))
      ],
    );
  }
}

class PricingOptionTotalPrice extends StatelessWidget {
  final BookingPricingNumberBooked bookingInfo;
  final TourTypePricing pricing;
  const PricingOptionTotalPrice(
      {super.key, required this.bookingInfo, required this.pricing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            "${pricing.displayName}: ${bookingInfo.numberBooked} x ${(pricing.priceCents.toDouble()) / 100}€"),
        Text(
          "${(pricing.priceCents.toDouble() / 100) * bookingInfo.numberBooked}€",
          style: TextStyle(color: BookingPageColors.primary.color),
        )
      ],
    );
  }
}

class PricingOptionCounter extends ConsumerWidget {
  final List<TourTypePricing> pricings;
  final TourTypePricing pricing;
  final int available;
  final bool maxBookingsSelected;
  const PricingOptionCounter(
      {super.key,
      required this.pricing,
      required this.available,
      required this.pricings,
      required this.maxBookingsSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? account = ref.watch(accountPublicProvider);
    if (account == null) return const SizedBox.shrink();
    final selectedPricings =
        ref.watch(bookingDetailsSelectedPricingsProvider(pricings));
    final selectedPricing =
        selectedPricings.firstWhere((sp) => sp.tourTypePricingId == pricing.id);
    final notifier =
        ref.watch(bookingDetailsSelectedPricingsProvider(pricings).notifier);
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
        IconButton.outlined(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: selectedPricing.numberBooked == 0
                  ? Colors.grey
                  : BookingPageColors.primary.color,
              width: 2,
            ),
            foregroundColor: BookingPageColors.primary.color,
            disabledForegroundColor: Colors.grey,
            disabledBackgroundColor: Colors.grey.shade200,
          ),
          onPressed: selectedPricing.numberBooked == 0
              ? null
              : () {
                  int currentNumber = selectedPricing.numberBooked;
                  notifier.editSinglePricing(pricing.id, currentNumber - 1);
                },
          icon: Icon(
            Icons.remove,
            color: selectedPricing.numberBooked == 0
                ? Colors.grey
                : BookingPageColors.primary.color,
          ),
        ),
        Text(selectedPricing.numberBooked.toString()),
        IconButton.outlined(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: maxBookingsSelected
                  ? Colors.grey
                  : BookingPageColors.primary.color,
              width: 2,
            ),
            foregroundColor: BookingPageColors.primary.color,
            disabledForegroundColor: Colors.grey,
            disabledBackgroundColor: Colors.grey.shade200,
          ),
          onPressed: maxBookingsSelected
              ? null
              : () {
                  int currentNumber = selectedPricing.numberBooked;
                  notifier.editSinglePricing(pricing.id, currentNumber + 1);
                },
          icon: Icon(
            Icons.add,
            color: maxBookingsSelected
                ? Colors.grey
                : BookingPageColors.primary.color,
          ),
        ),
      ],
    );
  }
}

class BookingSummaryTitleText extends StatelessWidget {
  final String text;
  const BookingSummaryTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54),
    );
  }
}

class BookingSummaryValueText extends StatelessWidget {
  final String text;
  const BookingSummaryValueText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.clip),
    );
  }
}

class BookingPageTopOverview extends StatelessWidget {
  final TourType tourType;
  const BookingPageTopOverview({
    super.key,
    required this.tourType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
              child: Text(
                tourType.displayName,
                style: TextStyle(
                    color: BookingPageColors.primaryDark.color,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 20),
          FaIcon(
            FontAwesomeIcons.stopwatch,
            size: 18,
            color: BookingPageColors.primary.color.withAlpha(200),
          ),
          const SizedBox(width: 10),
          Text("${tourType.duration} minutes")
        ],
      ),
    );
  }
}

class BookingPageHeader extends ConsumerWidget {
  const BookingPageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kennelImage = ref
        .watch(kennelImageProvider(account: ref.read(accountPublicProvider)))
        .value;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))
          ],
          gradient: LinearGradient(colors: [
            BookingPageColors.mainBlue.color,
            BookingPageColors.mainPurple.color
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: BoxBorder.all(color: BookingPageColors.mainBlue.color),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              kennelImage != null
                  ? Image.memory(
                      kennelImage,
                      height: 200,
                      fit: BoxFit.contain,
                    )
                  : const SizedBox.shrink(),
              const Text(
                "Book your adventure",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w600),
              ),
              const Text(
                "Select the date and time of your tour",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NoKennelOrTourIdErrorPage extends StatelessWidget {
  const NoKennelOrTourIdErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Text("Error: kennel or tourId are empty or not valid.")),
    );
  }
}

class NotAvailable extends StatelessWidget {
  const NotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Text("The booking system is not available right now.")),
    );
  }
}

enum BookingPageColors {
  success(color: Color(0xff10b091)),
  warning(color: Color(0xfff59e0b)),
  danger(color: Color(0xffef4444)),
  primary(color: Color(0xff2563eb)),
  primaryDark(color: Color(0xff1e40af)),
  primaryLight(color: Color(0xffdbeafe)),
  mainBlue(color: Color(0xff667eea)),
  mainPurple(color: Color(0xff764ba2));

  final Color color;

  const BookingPageColors({required this.color});
}
