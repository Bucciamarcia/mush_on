import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/riverpod.dart';

class DateTimeDistancePicker extends StatefulWidget {
  final TeamGroupWorkspace teamGroup;
  final Function(DateTime) onDateChanged;
  final Function(double) onDistanceChanged;
  const DateTimeDistancePicker({
    super.key,
    required this.teamGroup,
    required this.onDateChanged,
    required this.onDistanceChanged,
  });

  @override
  State<DateTimeDistancePicker> createState() => _DateTimeDistancePickerState();
}

class _DateTimeDistancePickerState extends State<DateTimeDistancePicker> {
  late TextEditingController _distanceController;
  @override
  void initState() {
    super.initState();
    _distanceController =
        TextEditingController(text: widget.teamGroup.distance.toString());
  }

  @override
  void dispose() {
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Flexible(
          child: TextField(
            decoration: InputDecoration(hint: Text("Date")),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: widget.teamGroup.date,
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (pickedDate != null) {
                widget.onDateChanged(
                  DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
                      widget.teamGroup.date.hour, widget.teamGroup.date.minute),
                );
              }
            },
            controller: TextEditingController(
              text: _formatDate(widget.teamGroup.date),
            ),
          ),
        ),
        Flexible(
          child: TextField(
            decoration: InputDecoration(hint: Text("Time")),
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                    hour: widget.teamGroup.date.hour,
                    minute: widget.teamGroup.date.minute),
              );
              if (pickedTime != null) {
                widget.onDateChanged(
                  DateTime(
                    widget.teamGroup.date.year,
                    widget.teamGroup.date.month,
                    widget.teamGroup.date.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  ),
                );
              }
            },
            controller: TextEditingController(
              text: _formatTime(widget.teamGroup.date),
            ),
          ),
        ),
        Flexible(
          child: TextField(
            decoration: InputDecoration(label: Text("Distance")),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: (v) => widget.onDistanceChanged(double.tryParse(v) ?? 0),
            controller: _distanceController,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd-MM-yyyy").format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat("HH:mm").format(date);
  }
}
