import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';
import '../riverpod.dart';

class BookingEditorAlert extends ConsumerStatefulWidget {
  final Function(Booking) onBookingEdited;
  final Booking? booking;
  const BookingEditorAlert(
      {super.key, required this.onBookingEdited, this.booking});

  @override
  ConsumerState<BookingEditorAlert> createState() => _BookingEditorAlertState();
}

class _BookingEditorAlertState extends ConsumerState<BookingEditorAlert> {
  late bool isNewBooking;
  late String id;
  late TextEditingController nameController;
  late TextEditingController priceController;
  late bool isPaid;
  late DateTime dateTime;
  CustomerGroup? selectedCustomerGroup;
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
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CustomerGroup> possibleCustomerGroups =
        ref.watch(customerGroupsByDateProvider(dateTime)).value ?? [];
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
                    dateTime = dateTime.copyWith(
                      year: newDate.year,
                      month: newDate.month,
                      day: newDate.day,
                    );
                    setState(() {
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
            "Assign to Customer Group",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          possibleCustomerGroups.isEmpty
              ? Text("No customer groups have the same date and time")
              : Text("TODO")
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
          onPressed: () {
            widget.onBookingEdited(
              Booking(
                id: id,
                date: dateTime,
                name: nameController.text,
                price: double.parse(priceController.text),
                hasPaidAmount: isPaid ? double.parse(priceController.text) : 0,
                customerGroupId: selectedCustomerGroup?.id,
              ),
            );
            Navigator.of(context).pop();
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
