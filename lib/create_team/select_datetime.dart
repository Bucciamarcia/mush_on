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
  bool _isDistanceBeingEdited = false;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    timeController = TextEditingController();
    distanceController = TextEditingController();

    // Set up focus listener for distance field to track editing state
    distanceController.addListener(_handleDistanceChange);

    // Initial setup in next frame to avoid build issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllerValues();
    });
  }

  void _handleDistanceChange() {
    // Only update provider if user is actively editing (not when we programmatically update)
    if (_isDistanceBeingEdited && distanceController.text.isNotEmpty) {
      final double? parsedValue = double.tryParse(distanceController.text);
      if (parsedValue != null) {
        Provider.of<CreateTeamProvider>(context, listen: false)
            .changeDistance(parsedValue);
      }
    }
  }

  void _updateControllerValues() {
    if (!mounted) return;

    final teamProvider =
        Provider.of<CreateTeamProvider>(context, listen: false);

    // Format date for display
    dateController.text =
        DateFormat("dd-MM-yy").format(teamProvider.group.date);

    // Set time from the provider's date
    final time = TimeOfDay.fromDateTime(teamProvider.group.date);
    timeController.text =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

    // Only update distance controller if not being edited
    if (!_isDistanceBeingEdited) {
      distanceController.text = teamProvider.group.distance.toString();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateControllerValues();
  }

  @override
  void dispose() {
    distanceController.removeListener(_handleDistanceChange);
    dateController.dispose();
    timeController.dispose();
    distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to react to changes
    return Row(
      children: [
        Flexible(
          child: TextField(
            key: Key("Date text field"),
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
            child: Focus(
          onFocusChange: (hasFocus) {
            // Track when user starts/stops editing the distance field
            setState(() {
              _isDistanceBeingEdited = hasFocus;
            });

            // When user stops editing, update the controller with provider value
            if (!hasFocus) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  // Format the value to clean up any invalid input
                  final double? parsedValue =
                      double.tryParse(distanceController.text);
                  if (parsedValue != null) {
                    distanceController.text = parsedValue.toString();
                  } else if (distanceController.text.isEmpty) {
                    distanceController.text = "0.0";
                    Provider.of<CreateTeamProvider>(context, listen: false)
                        .changeDistance(0.0);
                  }
                }
              });
            }
          },
          child: TextField(
            controller: distanceController,
            onChanged: (_) =>
                Provider.of<CreateTeamProvider>(context, listen: false)
                    .changeUnsavedData(true),
            decoration: InputDecoration(
              labelText: "Distance",
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            // We handle changes via the listener and focus system instead of onChanged
          ),
        ))
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final teamProvider =
        Provider.of<CreateTeamProvider>(context, listen: false);
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: teamProvider.group.date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat("dd-MM-yy").format(picked);
      });
      teamProvider.changeDate(picked);
      teamProvider.changeUnsavedData(true);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final teamProvider =
        Provider.of<CreateTeamProvider>(context, listen: false);
    TimeOfDay initialTime = TimeOfDay.fromDateTime(teamProvider.group.date);

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime != null) {
      setState(() {
        timeController.text =
            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      });
      teamProvider.changeTime(pickedTime);
      teamProvider.changeUnsavedData(true);
    }
  }
}
