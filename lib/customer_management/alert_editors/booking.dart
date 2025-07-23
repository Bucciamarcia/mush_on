import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';

class BookingEditorAlert extends StatefulWidget {
  final Function(Booking) onBookingAdded;
  final Booking? booking;
  const BookingEditorAlert(
      {super.key, required this.onBookingAdded, this.booking});

  @override
  State<BookingEditorAlert> createState() => _BookingEditorAlertState();
}

class _BookingEditorAlertState extends State<BookingEditorAlert> {
  late bool isNewBooking;
  late String id;
  late TextEditingController nameController;
  late DateTime dateTime;
  @override
  void initState() {
    super.initState();
    isNewBooking = widget.booking == null;
    id = widget.booking?.id ?? Uuid().v4();
    nameController = TextEditingController(text: widget.booking?.name);
    dateTime = widget.booking?.date ?? DateTimeUtils.today();
  }

  @override
  Widget build(BuildContext context) {
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
                    setState(() {});
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
                    setState(() {});
                  }
                },
                child: Text("Pick time"),
              ),
            ],
          )
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
            Navigator.of(context).pop();
          },
          child: Text(
            "Save booking",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
