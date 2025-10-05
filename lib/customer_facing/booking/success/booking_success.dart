import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:url_launcher/url_launcher.dart';
import 'riverpod.dart';

class BookingSuccessPage extends ConsumerWidget {
  final String? bookingId;
  final String? account;
  static final logger = BasicLogger();
  const BookingSuccessPage(
      {super.key, required this.bookingId, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bookingId == null || account == null) {
      return const Scaffold(body: SafeArea(child: Text("Error")));
    }
    final bookingDataAsync = ref.watch(
        bookingDataSuccessProvider(account: account!, bookingId: bookingId!));
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: bookingDataAsync.when(
              data: (bookingAndCustomers) {
                final (booking, customers, cg) = bookingAndCustomers;
                return BookingConfirmationDataPage(
                    booking: booking, customers: customers, cg: cg);
              },
              error: (e, s) {
                logger.error("Couldn't load booking", error: e, stackTrace: s);
                return const Text(
                    "Error: couldn't load the booking. Contact the kennel.");
              },
              loading: () => const CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}

class BookingConfirmationDataPage extends ConsumerWidget {
  final Booking booking;
  final List<Customer> customers;
  final CustomerGroup cg;
  const BookingConfirmationDataPage({
    super.key,
    required this.booking,
    required this.customers,
    required this.cg,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 600;
    final maxWidth = isDesktop ? 700.0 : double.infinity;
    final urlAndAmount = ref.watch(receiptUrlProvider(booking.id)).value;

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: EdgeInsets.all(isDesktop ? 48.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success header with gradient background
              Container(
                padding: EdgeInsets.all(isDesktop ? 48.0 : 32.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.secondaryContainer.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 72,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "Booking Confirmed!",
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "We're looking forward to your visit",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tour details card
              _InfoCard(
                title: "Tour Details",
                icon: Icons.calendar_today_rounded,
                children: [
                  _InfoRow(
                    icon: Icons.event_rounded,
                    label: "Date",
                    value: DateFormat("EEEE, MMMM d, yyyy").format(cg.datetime),
                  ),
                  _InfoRow(
                    icon: Icons.access_time_rounded,
                    label: "Time",
                    value: DateFormat("HH:mm").format(cg.datetime),
                  ),
                  if (booking.name.isNotEmpty)
                    _InfoRow(
                      icon: Icons.badge_rounded,
                      label: "Booking Name",
                      value: booking.name,
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Participants card
              _InfoCard(
                title: "Participants",
                icon: Icons.people_rounded,
                children: [
                  ...customers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final customer = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outlineVariant
                                .withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorScheme.secondaryContainer,
                                    colorScheme.tertiaryContainer,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                customer.name,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primaryContainer.withValues(alpha: 0.5),
                          colorScheme.secondaryContainer.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total participants",
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${customers.length}",
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Contact information card
              if (booking.email != null ||
                  booking.phone != null ||
                  booking.streetAddress != null)
                _InfoCard(
                  title: "Contact Information",
                  icon: Icons.contact_mail_rounded,
                  children: [
                    if (booking.email != null)
                      _InfoRow(
                        icon: Icons.email_rounded,
                        label: "Email",
                        value: booking.email!,
                      ),
                    if (booking.phone != null)
                      _InfoRow(
                        icon: Icons.phone_rounded,
                        label: "Phone",
                        value: booking.phone!,
                      ),
                    if (booking.streetAddress != null ||
                        booking.city != null ||
                        booking.country != null)
                      _InfoRow(
                        icon: Icons.location_on_rounded,
                        label: "Address",
                        value: [
                          booking.streetAddress,
                          [booking.zipCode, booking.city]
                              .where((e) => e != null)
                              .join(" "),
                          booking.country,
                        ].where((e) => e != null && e.isNotEmpty).join(", "),
                      ),
                  ],
                ),

              const SizedBox(height: 32),

              // Payment status with elevated card design
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getPaymentStatusColor(
                          booking.paymentStatus, colorScheme),
                      _getPaymentStatusColor(booking.paymentStatus, colorScheme)
                          .withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getPaymentStatusColor(
                              booking.paymentStatus, colorScheme)
                          .withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getPaymentStatusIcon(booking.paymentStatus),
                        size: 28,
                        color: _getPaymentStatusIconColor(
                            booking.paymentStatus, colorScheme),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment Status",
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getPaymentStatusText(booking.paymentStatus),
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Receipt button with modern style
              if (urlAndAmount != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () async {
                      await launchReceiptUrl(urlAndAmount.url);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "View Payment Receipt",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPaymentStatusColor(PaymentStatus status, ColorScheme colorScheme) {
    switch (status) {
      case PaymentStatus.paid:
        return colorScheme.primaryContainer;
      case PaymentStatus.waiting:
        return colorScheme.secondaryContainer;
      case PaymentStatus.deferredPayment:
        return colorScheme.tertiaryContainer;
      case PaymentStatus.unknown:
        return colorScheme.surfaceContainerHighest;
    }
  }

  IconData _getPaymentStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return Icons.check_circle_rounded;
      case PaymentStatus.waiting:
        return Icons.schedule_rounded;
      case PaymentStatus.deferredPayment:
        return Icons.event_note_rounded;
      case PaymentStatus.unknown:
        return Icons.help_outline_rounded;
    }
  }

  String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return "Payment Completed";
      case PaymentStatus.waiting:
        return "Payment Pending";
      case PaymentStatus.deferredPayment:
        return "Pay Later";
      case PaymentStatus.unknown:
        return "Payment Status Unknown";
    }
  }

  Color _getPaymentStatusIconColor(
      PaymentStatus status, ColorScheme colorScheme) {
    switch (status) {
      case PaymentStatus.paid:
        return colorScheme.primary;
      case PaymentStatus.waiting:
        return colorScheme.secondary;
      case PaymentStatus.deferredPayment:
        return colorScheme.tertiary;
      case PaymentStatus.unknown:
        return colorScheme.onSurfaceVariant;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.secondaryContainer.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 24, color: colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> launchReceiptUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception("Could not launch $url");
  }
}
