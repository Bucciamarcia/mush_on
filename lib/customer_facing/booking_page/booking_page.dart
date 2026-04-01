import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_facing/booking_page/repository.dart';
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

    final tourTypeAsync = ref.watch(
      tourTypeProvider(
        account: widget.account!,
        tourId: ref.watch(selectedTourIdProvider) ?? "",
      ),
    );

    return tourTypeAsync.when(
      data: (tourType) {
        if (tourType == null) {
          return const NoKennelOrTourIdErrorPage();
        }
        return FutureBuilder(
          future: BookingPageRepository(
            account: widget.account!,
            tourId: widget.tourId!,
          ).getStripeConnection(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final stripe = snapshot.data!;
              if (!stripe.isActive) {
                return const NotAvailable();
              }
              return MainContent(
                account: widget.account!,
                tourType: tourType,
                stripe: stripe,
              );
            } else if (snapshot.hasError) {
              return const NotAvailable();
            } else {
              return const BookingLoadingState();
            }
          },
        );
      },
      error: (e, s) {
        logger.error(
          "Error loading tour type for booking page",
          error: e,
          stackTrace: s,
        );
        return const NoKennelOrTourIdErrorPage();
      },
      loading: () => const BookingLoadingState(),
    );
  }
}

class MainContent extends ConsumerWidget {
  final TourType tourType;
  final String account;
  final StripeConnection stripe;
  const MainContent({
    super.key,
    required this.tourType,
    required this.account,
    required this.stripe,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingManagerKennelInfoAsync =
        ref.watch(bookingManagerKennelInfoProvider(account: account));
    final logger = BasicLogger();

    return bookingManagerKennelInfoAsync.when(
      data: (kennelInfo) {
        if (kennelInfo == null) return const NotAvailable();
        return Scaffold(
          backgroundColor: BookingPageColors.background.color,
          body: SafeArea(
            child: Center(
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
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const BookingProgressBanner(
                                  currentStep: 1,
                                  title: "Choose your date and guests",
                                  subtitle:
                                      "Select a day, pick a departure, and set the number of participants.",
                                ),
                                const SizedBox(height: 28),
                                DateSelectionWidget(
                                  constraints: constraints,
                                  tourType: tourType,
                                  account: account,
                                  kennelInfo: kennelInfo,
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        context.go("/privacy_customer"),
                                    icon:
                                        const Icon(Icons.privacy_tip_outlined),
                                    label: const Text("Privacy policy"),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      error: (e, s) {
        logger.error("Couldn't get booking info", error: e, stackTrace: s);
        return const NotAvailable();
      },
      loading: () => const BookingLoadingState(),
    );
  }
}

class DateSelectionWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final TourType tourType;
  final String account;
  final BookingManagerKennelInfo kennelInfo;
  const DateSelectionWidget({
    super.key,
    required this.constraints,
    required this.tourType,
    required this.account,
    required this.kennelInfo,
  });

  @override
  Widget build(BuildContext context) {
    final wide = constraints.maxWidth >= 980;
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: BookingTimeAndDate(tourType: tourType, account: account),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: BookingSummaryColumn(
              tourType: tourType,
              kennelInfo: kennelInfo,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BookingTimeAndDate(tourType: tourType, account: account),
        const SizedBox(height: 20),
        BookingSummaryColumn(
          tourType: tourType,
          kennelInfo: kennelInfo,
        ),
      ],
    );
  }
}

class BookingSummaryColumn extends ConsumerWidget {
  final TourType tourType;
  final BookingManagerKennelInfo kennelInfo;
  const BookingSummaryColumn(
      {super.key, required this.tourType, required this.kennelInfo});

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

    final selectedDate = ref.watch(selectedDateInCalendarProvider);
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

    final maxBookingsSelected = totalBooked() >= availableSpots;
    final grandTotalToPay = total();

    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: BookingSummaryCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking summary",
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
            if (selectedCustomerGroup != null) ...[
              const SizedBox(height: 18),
              BookingSummaryInfoRow(
                icon: Icons.event_seat_outlined,
                label: "Availability",
                value: "$availableSpots spots left",
              ),
            ],
            const SizedBox(height: 24),
            for (final pricing in pricings) ...[
              PricingOptionCounter(
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
            const SizedBox(height: 24),
            ConfirmBookingButton(
              selectedPricings: selectedPricings,
              pricings: pricings,
              tourType: tourType,
              kennelInfo: kennelInfo,
            ),
            const SizedBox(height: 18),
            const SafetyIconsWrap(),
            const SizedBox(height: 14),
            Text(
              "Secure checkout powered by Stripe",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: BookingPageColors.textMuted.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class SafetyIconsWrap extends StatelessWidget {
  const SafetyIconsWrap({super.key});

  @override
  Widget build(BuildContext context) {
    const h = 24.0;
    return const Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _PaymentBadge(asset: "assets/images/visa.svg", height: h),
        _PaymentBadge(asset: "assets/images/mastercard.svg", height: h),
        _PaymentBadge(asset: "assets/images/amex.svg", height: h),
      ],
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String asset;
  final double height;
  const _PaymentBadge({required this.asset, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BookingPageColors.outlineSoft.color),
      ),
      child: SvgPicture.asset(asset, height: height),
    );
  }
}

class ConfirmBookingButton extends ConsumerWidget {
  static final BasicLogger logger = BasicLogger();
  final List<BookingPricingNumberBooked> selectedPricings;
  final List<TourTypePricing> pricings;
  final TourType tourType;
  final BookingManagerKennelInfo kennelInfo;
  const ConfirmBookingButton({
    super.key,
    required this.selectedPricings,
    required this.pricings,
    required this.tourType,
    required this.kennelInfo,
  });

  bool _isActive() {
    for (final sp in selectedPricings) {
      if (sp.numberBooked > 0) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: ElevatedButton.icon(
          key: ValueKey(_isActive()),
          onPressed: _isActive()
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CollectInfoPage(
                        tourType: tourType,
                        pricings: pricings,
                        selectedPricings: selectedPricings,
                        kennelInfo: kennelInfo,
                      ),
                    ),
                  );
                }
              : null,
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text("Continue"),
          style: _isActive()
              ? bookingPrimaryButtonStyle()
              : bookingPrimaryButtonStyle().copyWith(
                  backgroundColor: WidgetStatePropertyAll(
                    BookingPageColors.outline.color,
                  ),
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
        ),
      ),
    );
  }
}

class GrandTotalSummaryRow extends StatelessWidget {
  final List<BookingPricingNumberBooked> selectedPricings;
  final List<TourTypePricing> pricings;
  final double grandTotalToPay;
  const GrandTotalSummaryRow({
    super.key,
    required this.selectedPricings,
    required this.pricings,
    required this.grandTotalToPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: BookingPageColors.outlineSoft.color),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                "VAT included",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: BookingPageColors.textMuted.color,
                    ),
              ),
            ],
          ),
          Text(
            formatEuro(grandTotalToPay),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: BookingPageColors.primaryDark.color,
                ),
          ),
        ],
      ),
    );
  }
}

class PricingOptionTotalPrice extends StatelessWidget {
  final BookingPricingNumberBooked bookingInfo;
  final TourTypePricing pricing;
  const PricingOptionTotalPrice({
    super.key,
    required this.bookingInfo,
    required this.pricing,
  });

  @override
  Widget build(BuildContext context) {
    if (bookingInfo.numberBooked == 0) return const SizedBox.shrink();
    final unitPrice = pricing.priceCents.toDouble() / 100;
    final totalPrice = unitPrice * bookingInfo.numberBooked;

    return Row(
      children: [
        Expanded(
          child: Text(
            "${pricing.displayName} x${bookingInfo.numberBooked}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: BookingPageColors.textMuted.color,
                ),
          ),
        ),
        Text(
          formatEuro(totalPrice),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: BookingPageColors.textStrong.color,
              ),
        ),
      ],
    );
  }
}

class PricingOptionCounter extends ConsumerWidget {
  final List<TourTypePricing> pricings;
  final TourTypePricing pricing;
  final int available;
  final bool maxBookingsSelected;
  const PricingOptionCounter({
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
    final notifier =
        ref.watch(bookingDetailsSelectedPricingsProvider(pricings).notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BookingPageColors.surfaceStrong.color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: BookingPageColors.outlineSoft.color),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pricing.displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: BookingPageColors.textStrong.color,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  pricing.displayDescription?.trim().isNotEmpty == true
                      ? pricing.displayDescription!
                      : "${formatEuro(pricing.priceCents / 100)} per guest",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: BookingPageColors.textMuted.color,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _QuantityButton(
                icon: Icons.remove,
                enabled: selectedPricing.numberBooked > 0,
                onTap: () {
                  final currentNumber = selectedPricing.numberBooked;
                  notifier.editSinglePricing(pricing.id, currentNumber - 1);
                },
              ),
              SizedBox(
                width: 34,
                child: Text(
                  selectedPricing.numberBooked.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              _QuantityButton(
                icon: Icons.add,
                enabled: !maxBookingsSelected,
                onTap: () {
                  final currentNumber = selectedPricing.numberBooked;
                  notifier.editSinglePricing(pricing.id, currentNumber + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      style: IconButton.styleFrom(
        backgroundColor: enabled
            ? BookingPageColors.surface.color
            : BookingPageColors.outlineSoft.color.withValues(alpha: 0.8),
        foregroundColor: enabled
            ? BookingPageColors.primaryDark.color
            : BookingPageColors.textMuted.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        fixedSize: const Size(42, 42),
      ),
      icon: Icon(icon),
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
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: BookingPageColors.textMuted.color,
            letterSpacing: 0.3,
          ),
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
      textAlign: TextAlign.end,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: BookingPageColors.textStrong.color,
          ),
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
    return BookingFlowFrame(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          BookingTag(
            icon: Icons.pets_outlined,
            text: tourType.displayName,
            emphasized: true,
          ),
          BookingTag(
            icon: Icons.schedule_outlined,
            text: "${tourType.duration} minutes",
          ),
        ],
      ),
    );
  }
}

class BookingPageHeader extends ConsumerWidget {
  const BookingPageHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kennelImage = ref
        .watch(kennelImageProvider(account: ref.read(accountPublicProvider)))
        .value;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: LinearGradient(
          colors: [
            BookingPageColors.heroTop.color,
            BookingPageColors.heroBottom.color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -65,
            left: -15,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 900;
                return Flex(
                  direction: compact ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              "Book now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            "Book your adventure",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              height: 1.05,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20, height: 20),
                    if (kennelImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.94),
                          width: compact ? double.infinity : 250,
                          constraints: const BoxConstraints(maxHeight: 190),
                          padding: const EdgeInsets.all(18),
                          child: Image.memory(
                            kennelImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookingLoadingState extends StatelessWidget {
  const BookingLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingPageColors.background.color,
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
              SizedBox(height: 12),
              Text("Loading the booking page, please wait..."),
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
    return const BookingMessageState(
      title: "Booking unavailable",
      message: "Kennel or tour id is missing or not valid.",
      icon: Icons.error_outline_rounded,
    );
  }
}

class NotAvailable extends StatelessWidget {
  const NotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return const BookingMessageState(
      title: "Booking unavailable",
      message: "The booking system is not available right now.",
      icon: Icons.event_busy_outlined,
    );
  }
}

class BookingMessageState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  const BookingMessageState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingPageColors.background.color,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: BookingFlowFrame(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: BookingPageColors.surfaceStrong.color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 30,
                        color: BookingPageColors.primaryDark.color,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: BookingPageColors.textMuted.color,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookingFlowFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const BookingFlowFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BookingPageColors.surface.color,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: BookingPageColors.outlineSoft.color),
        boxShadow: [
          BoxShadow(
            color: BookingPageColors.shadow.color,
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class BookingProgressBanner extends StatelessWidget {
  final int currentStep;
  final String title;
  final String subtitle;
  const BookingProgressBanner({
    super.key,
    required this.currentStep,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        return Flex(
          direction: compact ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment:
              compact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Step $currentStep of 3",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: BookingPageColors.primaryDark.color,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: BookingPageColors.textStrong.color,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: BookingPageColors.textMuted.color,
                          height: 1.45,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(width: compact ? 0 : 24, height: compact ? 20 : 0),
            SizedBox(
              width: compact ? double.infinity : 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: currentStep / 3,
                  backgroundColor: BookingPageColors.surfaceStrong.color,
                  color: BookingPageColors.primary.color,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BookingTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool emphasized;
  const BookingTag({
    super.key,
    required this.icon,
    required this.text,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = emphasized
        ? BookingPageColors.primary.color
        : BookingPageColors.surfaceStrong.color;
    final foreground =
        emphasized ? Colors.white : BookingPageColors.textStrong.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: foreground,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingSummaryCard extends StatelessWidget {
  final Widget child;
  const BookingSummaryCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BookingPageColors.summaryBackground.color,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: BookingPageColors.outlineSoft.color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}

class BookingSummaryInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const BookingSummaryInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: BookingPageColors.surfaceStrong.color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 18,
            color: BookingPageColors.primaryDark.color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: BookingPageColors.textMuted.color,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: BookingPageColors.textStrong.color,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

ButtonStyle bookingPrimaryButtonStyle() {
  return ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: BookingPageColors.primaryDark.color,
    foregroundColor: Colors.white,
    disabledBackgroundColor: BookingPageColors.outline.color,
    disabledForegroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
  );
}

ButtonStyle bookingSecondaryButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: BookingPageColors.textStrong.color,
    side: BorderSide(color: BookingPageColors.outlineSoft.color),
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
  );
}

String formatEuro(num amount) {
  return "${amount.toStringAsFixed(2)}€";
}

enum BookingPageColors {
  success(color: Color(0xff2a9d6f)),
  warning(color: Color(0xffd89b34)),
  danger(color: Color(0xffcc5b5b)),
  primary(color: Color(0xff8f739d)),
  primaryDark(color: Color(0xff624f73)),
  primaryLight(color: Color(0xffefe5f4)),
  mainBlue(color: Color(0xffd4dce6)),
  mainPurple(color: Color(0xffc3b3d6)),
  background(color: Color(0xfff5f1eb)),
  surface(color: Color(0xfffdfaf6)),
  surfaceStrong(color: Color(0xfff1e8df)),
  summaryBackground(color: Color(0xfff7efe7)),
  textStrong(color: Color(0xff2b2623)),
  textMuted(color: Color(0xff7b7168)),
  outline(color: Color(0xffb7ab9f)),
  outlineSoft(color: Color(0xffe2d7cc)),
  shadow(color: Color(0x12000000)),
  heroTop(color: Color(0xff8b709f)),
  heroBottom(color: Color(0xffc7b7a4));

  final Color color;

  const BookingPageColors({required this.color});
}
