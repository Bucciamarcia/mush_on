import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    super.key,
  });

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController distanceController;
  late CreateTeamProvider teamProvider;
  @override
  void initState() {
    teamProvider = Provider.of<CreateTeamProvider>(context, listen: false);
    dateController = TextEditingController();
    dateController.text = teamProvider.group.date.toString().split(" ")[0];
    timeController = TextEditingController();
    distanceController = TextEditingController();
    distanceController.text = teamProvider.group.distance.toString();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: dateController,
            decoration: InputDecoration(labelText: "Date"),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
        ),
        SizedBox(width: 10),
        Flexible(
            child: TextField(
          controller: timeController,
          decoration: InputDecoration(labelText: "Time"),
          readOnly: true,
          onTap: () => _selectTime(context),
        )),
        Flexible(
            child: TextField(
          controller: distanceController,
          decoration: InputDecoration(labelText: "Distance"),
          keyboardType: TextInputType.number,
          onChanged: (value) =>
              teamProvider.changeDistance(double.parse(value)),
        ))
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(
        () {
          dateController.text = DateFormat("dd-MM-yy").format(picked);
        },
      );
      teamProvider.changeDate(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        timeController.text =
            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      });
      teamProvider.changeTime(pickedTime);
    }
  }
}
