import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/teamgroup.dart';
import 'package:uuid/uuid.dart';

class CustomerGroupEditorAlert extends ConsumerStatefulWidget {
  final Function(CustomerGroup) onCgEdited;
  final CustomerGroup? customerGroup;
  const CustomerGroupEditorAlert({
    super.key,
    required this.onCgEdited,
    this.customerGroup,
  });

  @override
  ConsumerState<CustomerGroupEditorAlert> createState() =>
      _CustomerGroupEditorAlertState();
}

class _CustomerGroupEditorAlertState
    extends ConsumerState<CustomerGroupEditorAlert> {
  late String id;
  late TextEditingController nameController;
  late DateTime dateTime;
  String? selectedTeamGroupId;

  @override
  void initState() {
    super.initState();
    id = widget.customerGroup?.id ?? Uuid().v4();
    nameController = TextEditingController(text: widget.customerGroup?.name);
    dateTime = widget.customerGroup?.datetime ?? DateTimeUtils.today();
    selectedTeamGroupId = widget.customerGroup?.teamGroupId;
  }

  @override
  Widget build(BuildContext context) {
    List<TeamGroup> possibleTeamGroups =
        ref.watch(teamGroupsByDateProvider(dateTime)).value ?? [];
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text("Customer group editor"),
      content: Column(
        spacing: 10,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              label: Text("Customer group name"),
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
                    setState(() {
                      selectedTeamGroupId == null;
                    });
                  }
                },
                child: Text("Pick time"),
              ),
            ],
          ),
          Text(
            "Assign to team group",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          possibleTeamGroups.isEmpty
              ? Text("No team groups with the same date and time")
              : Text("TODO"),
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
            widget.onCgEdited(
              CustomerGroup(
                id: id,
                datetime: dateTime,
                name: nameController.text,
                teamGroupId: selectedTeamGroupId,
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
