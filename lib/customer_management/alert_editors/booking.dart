import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/alert_editors/customer.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';
import '../riverpod.dart';

class BookingEditorAlert extends ConsumerStatefulWidget {
  final Function(Booking) onBookingEdited;
  final Function(List<Customer>) onCustomersEdited;
  final Function() onBookingDeleted;
  final Booking? booking;
  final String? id;
  final CustomerGroup selectedCustomerGroup;
  const BookingEditorAlert(
      {super.key,
      required this.onBookingEdited,
      this.booking,
      this.id,
      required this.onCustomersEdited,
      required this.onBookingDeleted,
      required this.selectedCustomerGroup});

  @override
  ConsumerState<BookingEditorAlert> createState() => _BookingEditorAlertState();
}

class _BookingEditorAlertState extends ConsumerState<BookingEditorAlert> {
  static final logger = BasicLogger();
  late bool isNewBooking;
  late String id;
  late TextEditingController nameController;
  late List<CustomerGroup> possibleCustomerGroups;
  late List<Customer> customers;
  @override
  void initState() {
    super.initState();
    isNewBooking = widget.booking == null;
    id = widget.booking?.id ?? widget.id ?? Uuid().v4();
    nameController = TextEditingController(text: widget.booking?.name);
    possibleCustomerGroups = [];
    customers = [];
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.booking != null && customers.isEmpty) {
      customers =
          ref.watch(customersByBookingIdProvider(widget.booking!.id)).value ??
              [];
    }
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      scrollable: true,
      title: Row(
        children: [
          Icon(Icons.event_note, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text("Booking Editor"),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              TextField(
                onChanged: (s) {
                  setState(() {});
                },
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Booking Name",
                  hintText: "Internal name (not shown to customer)",
                  prefixIcon: const Icon(Icons.edit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people,
                            size: 20, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          "Customers (${customers.length})",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    if (customers.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: customers
                            .map(
                              (customer) => FilterChip(
                                avatar: const Icon(Icons.person, size: 16),
                                label: Text(customer.name),
                                onDeleted: () => setState(() {
                                  customers
                                      .removeWhere((c) => c.id == customer.id);
                                }),
                                onSelected: (_) => showDialog(
                                  context: context,
                                  builder: (_) => CustomerEditorAlert(
                                    customerGroup: widget.selectedCustomerGroup,
                                    customer: customer,
                                    onCustomerEdited: (editedCustomer) {
                                      setState(
                                        () {
                                          customers.removeWhere(
                                              (c) => c.id == editedCustomer.id);
                                          customers.add(editedCustomer);
                                        },
                                      );
                                    },
                                    bookingId: id,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    Center(
                      child: FilledButton.tonalIcon(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return CustomerEditorAlert(
                                  customerGroup: widget.selectedCustomerGroup,
                                  bookingId: id,
                                  onCustomerEdited: (customer) => setState(
                                    () {
                                      logger.debug(
                                          "Existing customers: $customers");
                                      logger.debug(
                                          "New customer: ${customer.name}");
                                      customers = [...customers, customer];
                                      logger.debug("New customers: $customers");
                                    },
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Customer"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () async => await showDialog(
            context: context,
            builder: (_) => AlertDialog.adaptive(
              title: Text("Are you sure?"),
              content: Text(
                "Are you sure you want to delete this booking? It will be gone forever. All customers will be deleted too!",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Nevermind",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onBookingDeleted();
                    Navigator.of(context).pop();
                  },
                  child: Text("Proceed"),
                ),
              ],
            ),
          ),
          child: Text("Delete this booking"),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: nameController.text.isNotEmpty
              ? () {
                  logger.debug("Customers: $customers");
                  widget.onCustomersEdited(customers);
                  widget.onBookingEdited(
                    Booking(
                      id: id,
                      name: nameController.text,
                      customerGroupId: widget.selectedCustomerGroup.id,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              : null,
          icon: const Icon(Icons.save),
          label: const Text("Save Booking"),
        ),
      ],
    );
  }
}
