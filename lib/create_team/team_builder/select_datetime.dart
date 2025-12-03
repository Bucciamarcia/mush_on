import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/riverpod.dart';

class DateTimeDistancePicker extends ConsumerStatefulWidget {
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
  ConsumerState<DateTimeDistancePicker> createState() =>
      _DateTimeDistancePickerState();
}

class _DateTimeDistancePickerState
    extends ConsumerState<DateTimeDistancePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Flexible(
          child: TextField(
            decoration:
                const InputDecoration(hint: Text("Date"), label: Text("Date")),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: widget.teamGroup.date,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
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
            decoration:
                const InputDecoration(hint: Text("Time"), label: Text("Time")),
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
            decoration: const InputDecoration(label: Text("Distance")),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: (v) => widget.onDistanceChanged(double.tryParse(v) ?? 0),
            controller: ref.watch(distanceControllerProvider),
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
