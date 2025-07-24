import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/alert_editors/customer.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';
import '../riverpod.dart';

class BookingEditorAlert extends ConsumerStatefulWidget {
  final Function(Booking) onBookingEdited;
  final Function(List<Customer>) onCustomersEdited;
  final Booking? booking;
  const BookingEditorAlert(
      {super.key,
      required this.onBookingEdited,
      this.booking,
      required this.onCustomersEdited});

  @override
  ConsumerState<BookingEditorAlert> createState() => _BookingEditorAlertState();
}

class _BookingEditorAlertState extends ConsumerState<BookingEditorAlert> {
  static final logger = BasicLogger();
  late bool isNewBooking;
  late String id;
  late TextEditingController nameController;
  late TextEditingController priceController;
  late bool isPaid;
  late DateTime dateTime;
  List<Customer> customers = [];
  CustomerGroup? selectedCustomerGroup;
  late List<CustomerGroup> possibleCustomerGroups;
  @override
  void initState() {
    super.initState();
    isNewBooking = widget.booking == null;
    id = widget.booking?.id ?? Uuid().v4();
    nameController = TextEditingController(text: widget.booking?.name);
    priceController =
        TextEditingController(text: widget.booking?.price.toString());
    isPaid = widget.booking?.isFullyPaid ?? false;
    dateTime = widget.booking?.date ?? DateTimeUtils.today();
    possibleCustomerGroups = [];
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerGroupsAsync =
        ref.watch(customerGroupsByDateProvider(dateTime));
    return AlertDialog(
      scrollable: true,
      title: Text("Booking editor"),
      content: Column(
        spacing: 15,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              label: Text("Booking name"),
              hint: Text("Will never be shown to customer."),
            ),
          ),
          Text(
            "Date and time",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(DateFormat("dd-MM-yyyy | HH:mm").format(dateTime)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Pick the date
              ElevatedButton(
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
                child: Text("Pick date"),
              ),

              // Pick the time.
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
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
                child: Text("Pick time"),
              ),
            ],
          ),
          Text(
            "Price",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          TextField(
            decoration: InputDecoration(
              label: Text("The price of the booking"),
            ),
            controller: priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          CheckboxListTile.adaptive(
            title: Text("Is paid"),
            value: isPaid,
            onChanged: (v) {
              if (v != null) {
                setState(() {
                  isPaid = v;
                });
              }
            },
          ),
          Text(
            "Customers in this booking",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          ...customers.map(
            (customer) => ActionChip.elevated(
              label: Text(customer.name),
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => CustomerEditorAlert(
                        customer: customer,
                        onCustomerEdited: (editedCustomer) {
                          setState(() {
                            customers
                                .removeWhere((c) => c.id == editedCustomer.id);
                            customers.add(editedCustomer);
                          });
                        },
                        bookingId: id,
                      )),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (_) {
                      return CustomerEditorAlert(
                        bookingId: id,
                        onCustomerEdited: (customer) => setState(
                          () {
                            customers = [...customers, customer];
                          },
                        ),
                      );
                    });
              },
              child: Text("Add customer")),
          Text(
            "Assign to Customer Group",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          customerGroupsAsync.when(
              data: (data) {
                if (data.isEmpty) {
                  return Text("No customer groups have the same date and time");
                } else {
                  return Text("todo");
                }
              },
              error: (e, s) {
                logger.error("Couldn't get customer group async",
                    error: e, stackTrace: s);
                return Text("error");
              },
              loading: () => SizedBox.shrink()),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context)
              .popUntil(ModalRoute.withName("/client_management")),
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onCustomersEdited(customers);
            widget.onBookingEdited(
              Booking(
                id: id,
                date: dateTime,
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? 0,
                hasPaidAmount:
                    isPaid ? double.tryParse(priceController.text) ?? 0 : 0,
                customerGroupId: selectedCustomerGroup?.id,
              ),
            );
            Navigator.of(context)
                .popUntil(ModalRoute.withName("/client_management"));
          },
          child: Text(
            "Save",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
