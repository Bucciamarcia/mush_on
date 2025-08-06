import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/alert_editors/customer.dart';
import 'package:mush_on/customer_management/repository.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';
import '../riverpod.dart';

class BookingEditorAlert extends ConsumerStatefulWidget {
  final Function(Booking) onBookingEdited;
  final Function(List<Customer>) onCustomersEdited;
  final Function() onBookingDeleted;
  final Booking? booking;
  final String? id;
  const BookingEditorAlert(
      {super.key,
      required this.onBookingEdited,
      this.booking,
      this.id,
      required this.onCustomersEdited,
      required this.onBookingDeleted});

  @override
  ConsumerState<BookingEditorAlert> createState() => _BookingEditorAlertState();
}

class _BookingEditorAlertState extends ConsumerState<BookingEditorAlert> {
  static final logger = BasicLogger();
  late bool isNewBooking;
  late String id;
  late TextEditingController nameController;
  late DateTime dateTime;
  CustomerGroup? selectedCustomerGroup;
  late List<CustomerGroup> possibleCustomerGroups;
  late List<Customer> customers;
  @override
  void initState() {
    super.initState();
    isNewBooking = widget.booking == null;
    id = widget.booking?.id ?? widget.id ?? Uuid().v4();
    nameController = TextEditingController(text: widget.booking?.name);
    dateTime = widget.booking?.date ?? DateTimeUtils.today();
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
    if (selectedCustomerGroup == null &&
        widget.booking != null &&
        widget.booking!.customerGroupId != null) {
      selectedCustomerGroup = ref
          .watch(
            customerGroupByIdProvider(widget.booking!.customerGroupId!),
          )
          .valueOrNull;
    }
    final customerGroupsAsync =
        ref.watch(customerGroupsByDateProvider(dateTime));
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
                        Icon(Icons.schedule,
                            size: 20, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          "Date & Time",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.event,
                                  size: 18, color: colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                "Selected Date & Time:",
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat("EEEE, MMMM d, yyyy 'at' HH:mm")
                                .format(dateTime),
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 12,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              initialDate: dateTime,
                              context: context,
                              firstDate: DateTimeUtils.today().subtract(
                                Duration(days: 365),
                              ),
                              lastDate: DateTimeUtils.today().add(
                                Duration(days: 365),
                              ),
                            );
                            if (newDate != null) {
                              setState(() {
                                dateTime = dateTime.copyWith(
                                  year: newDate.year,
                                  month: newDate.month,
                                  day: newDate.day,
                                );
                                selectedCustomerGroup = null;
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text("Change Date"),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () async {
                            TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: dateTime.hour, minute: dateTime.minute),
                            );
                            if (newTime != null) {
                              dateTime = dateTime.copyWith(
                                hour: newTime.hour,
                                minute: newTime.minute,
                              );
                              setState(() {
                                selectedCustomerGroup = null;
                              });
                            }
                          },
                          icon: const Icon(Icons.access_time),
                          label: const Text("Change Time"),
                        ),
                      ],
                    ),
                  ],
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
                        Icon(Icons.group, size: 20, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          "Customer Group",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    customerGroupsAsync.when(
                        data: (data) {
                          if (data.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 18,
                                      color: colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "No customer groups available for this date and time",
                                      style: TextStyle(
                                          color: colorScheme.onSurfaceVariant),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return DropdownMenu<CustomerGroup>(
                              controller: TextEditingController(
                                  text: selectedCustomerGroup?.name),
                              label: Text("Select customer group"),
                              initialSelection: selectedCustomerGroup,
                              dropdownMenuEntries: data
                                  .map((c) => DropdownMenuEntry(
                                      value: c, label: c.name))
                                  .toList(),
                              onSelected: (v) {
                                logger.debug(
                                    "Selected customer group: ${v?.name}");
                                setState(
                                  () {
                                    selectedCustomerGroup = v;
                                  },
                                );
                              },
                            );
                          }
                        },
                        error: (e, s) {
                          logger.error("Couldn't get customer group async",
                              error: e, stackTrace: s);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    size: 18,
                                    color: colorScheme.onErrorContainer),
                                const SizedBox(width: 8),
                                Text(
                                  "Error loading customer groups",
                                  style: TextStyle(
                                      color: colorScheme.onErrorContainer),
                                ),
                              ],
                            ),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator())),
                    ElevatedButton.icon(
                      onPressed: () => _addCustomerGroup().catchError(
                        (e) => ScaffoldMessenger.of(context).showSnackBar(
                          errorSnackBar(context, "Couldn't add customer group"),
                        ),
                      ),
                      icon: Icon(Icons.add),
                      label: Center(
                        child: Text("Add new"),
                      ),
                    ),
                  ],
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
                                    customerGroup: selectedCustomerGroup,
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
                                  customerGroup: selectedCustomerGroup,
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
          onPressed: () => Navigator.of(context)
              .popUntil(ModalRoute.withName("/client_management")),
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
                    Navigator.of(context).popUntil(
                      ModalRoute.withName("/client_management"),
                    );
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
                      date: dateTime,
                      name: nameController.text,
                      customerGroupId: selectedCustomerGroup?.id,
                    ),
                  );
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName("/client_management"));
                }
              : null,
          icon: const Icon(Icons.save),
          label: const Text("Save Booking"),
        ),
      ],
    );
  }

  Future<void> _addCustomerGroup() async {
    String groupName = "";
    late TourType tourType;
    await showDialog(
      context: context,
      builder: (_) => AddCustomerGroupName(
        onNameAdded: (name, tour) {
          groupName = name;
          tourType = tour;
        },
      ),
    );
    if (groupName.isNotEmpty) {
      final createdCg = CustomerGroup(
        id: Uuid().v4(),
        tourTypeId: tourType.id,
        datetime: dateTime,
        name: groupName,
      );
      final repo = CustomerManagementRepository(
        account: await ref.watch(accountProvider.future),
      );
      try {
        await repo.setCustomerGroup(createdCg);
        setState(() {
          selectedCustomerGroup = createdCg;
        });
      } catch (e, s) {
        logger.error("Couldn't create customer group in booking manager",
            error: e, stackTrace: s);
        rethrow;
      }
    }
  }
}

class AddCustomerGroupName extends ConsumerStatefulWidget {
  final Function(String, TourType) onNameAdded;
  const AddCustomerGroupName({super.key, required this.onNameAdded});

  @override
  ConsumerState<AddCustomerGroupName> createState() =>
      _AddCustomerGroupNameState();
}

class _AddCustomerGroupNameState extends ConsumerState<AddCustomerGroupName> {
  late TextEditingController controller;
  late TextEditingController tourNameController;
  TourType? selectedTour;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    tourNameController = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    tourNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TourType> tours = ref.watch(allTourTypesProvider).value ?? [];
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text("Add customer group"),
      content: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hint: Text("Name of the customer group"),
            ),
          ),
          DropdownMenu<TourType>(
            width: double.infinity,
            hintText: "Select tour type",
            onSelected: (s) {
              if (s != null) {
                setState(() {
                  selectedTour = s;
                  tourNameController.text = s.name;
                });
              }
            },
            dropdownMenuEntries: tours
                .map(
                  (tour) => DropdownMenuEntry(
                      value: tour, label: "${tour.name} - ${tour.distance} km"),
                )
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: selectedTour == null
              ? null
              : () {
                  widget.onNameAdded(controller.text, selectedTour!);
                  Navigator.of(context).pop();
                },
          child: Text("Confirm"),
        ),
      ],
    );
  }
}
