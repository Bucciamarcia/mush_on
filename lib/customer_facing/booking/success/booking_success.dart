import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/services/error_handling.dart';
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
    final String? receiptUrl = ref.watch(receiptUrlProvider(booking.id)).value;

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: EdgeInsets.all(isDesktop ? 48.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Booking Confirmed!",
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We're looking forward to your visit",
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

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
                  ...customers.map((customer) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 20,
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer.name,
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (customer.age != null)
                                    Text(
                                      "${customer.age} years old",
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total participants",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${customers.length}",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
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

              // Payment status
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: _getPaymentStatusColor(
                        booking.paymentStatus, colorScheme),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPaymentStatusIcon(booking.paymentStatus),
                        size: 20,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                          onPressed: () {
                            if (receiptUrl != null) {
                              print(receiptUrl);
                            } else {
                              print("NOEP");
                            }
                          },
                          child: const Text("Show receipt")),
                      const SizedBox(width: 8),
                      Text(
                        _getPaymentStatusText(booking.paymentStatus),
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
